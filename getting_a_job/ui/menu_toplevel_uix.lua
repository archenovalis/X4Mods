local ffi = require ("ffi")
local C = ffi.C

local ModLua = {}

local mapMenu
local transporterMenu
local topLevelMenu
local researchMenu
local oldFuncs = {}
local newFuncs = {}
local kATD = {
	isPlayerHQLost = false,
	isEscapePodAvailable = false,
	isEscapePodEnabled = false,
}
local kATDHUD = {
	countdown = 0,
	isShowCountdown = false,
	isDestructionCertain = false,
	isDestructionAverted = false
}

function ModLua.init ()
	-- get all player properties start:
	mapMenu = Helper.getMenu ("MapMenu")
	RegisterEvent ("kATD.GetPlayerProperties", kATD.GetPlayerProperties)
	-- get all player properties end

	-- player naming start:
	RegisterEvent ("kATD.SetPlayerNameFromList", kATD.SetPlayerNameFromList)
	RegisterEvent ("kATD.SetPlayerNameClone", kATD.SetPlayerNameClone)
	-- player naming end

	-- destruction countdown HUD start:
	topLevelMenu = Helper.getMenu ("TopLevelMenu")
	topLevelMenu.registerCallback ("kHUD_get_is_show_custom_hud", kATDHUD.kHUD_get_is_show_custom_hud)
	topLevelMenu.registerCallback ("kHUD_add_tables", kATDHUD.kHUD_add_tables)
	RegisterEvent ("kATDHUD.ShowCountdown", kATDHUD.ShowCountdown)
	RegisterEvent ("kATDHUD.ShowCountdownDestructionCertain", kATDHUD.ShowCountdownDestructionCertain)
	RegisterEvent ("kATDHUD.HideCountdown", kATDHUD.HideCountdown)
	RegisterEvent ("kATDHUD.HideCountdownDestructionAverted", kATDHUD.HideCountdownDestructionAverted)
	-- destruction countdown HUD end

	-- top level menu item availability start:
	Helper.registerCallback("checkTopLevelConditions_get_is_entry_available", newFuncs.checkTopLevelConditions_get_is_entry_available)
	-- top level menu item availability end

	-- teleportation availability start:
	researchMenu = Helper.getMenu ("ResearchMenu")
	oldFuncs.buttonStartResearch = researchMenu.buttonStartResearch
	researchMenu.buttonStartResearch = newFuncs.buttonStartResearch
	RegisterEvent ("kATD.SetIsPlayerHQLost", kATD.SetIsPlayerHQLost)
	transporterMenu = Helper.getMenu ("TransporterMenu")
	transporterMenu.registerCallback ("display_on_set_buttontable", kATD.display_on_set_buttontable)
	-- teleportation availability end

	-- escape pod mod compatibility start
	RegisterEvent ("kATD.SetEscapePodAvailability", kATD.SetEscapePodAvailability)
	RegisterEvent ("kATD.EnableEscapePodButton", kATD.EnableEscapePodButton)
	-- escap pod mod compatibility end
end

function kATD.GetPlayerProperties ()
	local playerobjects = GetContainedObjectsByOwner ("player")
	local validProperties = {}
	for i = #playerobjects, 1, -1 do
		local object = playerobjects [i]
		local object64 = ConvertIDTo64Bit (object)
		if mapMenu.isObjectValid (object64) then
			table.insert (validProperties, object)
		else
			table.remove (playerobjects, i)
		end
	end
	AddUITriggeredEvent ("kATD", "on_get_player_properties", validProperties)
end
function kATD.SetPlayerNameClone (_, cloneNumber)
	local player = ConvertStringTo64Bit (tostring (C.GetPlayerID ()))
	local playerName = ffi.string (C.GetComponentName (player))
	local namesTable = {}
	-- for name in string.gmatch (playerName, "v") do
	for name in (playerName .. "v"):gmatch("(.-)".."v") do
		table.insert (namesTable, name)
	end
	local i
	local isVersionFound
	for i = #namesTable, 1, -1 do
		if (tonumber (namesTable [i])) then
			isVersionFound = true
			namesTable [i] = cloneNumber
			break
		end
	end
	local newName = namesTable [1]
	for i = 2, #namesTable do
		newName = newName .. "v" .. tostring (namesTable [i])
	end
	if not isVersionFound then
		newName = newName .. " v" .. tostring (cloneNumber)
	end
	SetComponentName (player, newName)
	AddUITriggeredEvent ("kATD", "on_set_player_name_clone", newName)
end
function kATD.SetPlayerNameFromList (_, names)
	local namesTable = {}
	local names2CharTable = {}
	for name in string.gmatch (names, "%S+") do
		-- if string.len (name) <= 2 then
		if string.find (" I II III IV V VI VII VIII IX X XI XII XIII XIV XV XVI XVII XVIII XIX XX", name) then
			table.insert (names2CharTable, name)
		else
			table.insert (namesTable, name)
		end
	end
	local nameI = math.random (#namesTable)
	local newName = namesTable [nameI]
	table.remove (namesTable, nameI)
	nameI = math.random (#namesTable)
	newName = newName .. " " .. namesTable [nameI]
	table.remove (namesTable, nameI)
	if #names2CharTable > 0 then
		nameI = math.random (#names2CharTable)
		newName = newName .. " " .. names2CharTable [nameI]
		table.remove (names2CharTable, nameI)
	end
	local player = ConvertStringTo64Bit (tostring (C.GetPlayerID ()))
	SetComponentName (player, newName)
	AddUITriggeredEvent ("kATD", "on_set_player_name_from_list", newName)
end
function kATDHUD.ShowCountdown ()
	Helper.debugText("ShowCountdown")
	kATDHUD.isShowCountdown = true
	kATDHUD.isDestructionCertain = false
	kATDHUD.isDestructionAverted = false
	topLevelMenu.requestUpdate()
end
function kATDHUD.ShowCountdownDestructionCertain ()
	Helper.debugText("ShowCountdownDestructionCertain")
	kATDHUD.isShowCountdown = true
	kATDHUD.isDestructionCertain = true
	kATDHUD.isDestructionAverted = false
	topLevelMenu.requestUpdate()
end
function kATDHUD.HideCountdown ()
	Helper.debugText("HideCountdown")
	kATDHUD.isShowCountdown = false
	kATDHUD.isDestructionCertain = false
	kATDHUD.isDestructionAverted = false
	topLevelMenu.requestUpdate()
end
function kATDHUD.HideCountdownDestructionAverted ()
	Helper.debugText("HideCountdownDestructionAverted")
	kATDHUD.isShowCountdown = false
	kATDHUD.isDestructionCertain = false
	kATDHUD.isDestructionAverted = true
	topLevelMenu.requestUpdate()
end
function kATDHUD.kHUD_get_is_show_custom_hud()
	return kATDHUD.isShowCountdown == true or kATDHUD.isDestructionAverted == true
end
function kATDHUD.kHUD_add_tables (frame)
	if kATDHUD.isShowCountdown == true or kATDHUD.isDestructionAverted == true then
		local player_id = ConvertStringTo64Bit (tostring (C.GetPlayerID ()))
		local kATD_countdownData = GetNPCBlackboard (player_id, "$kATD_countdownData")
		kATDHUD.countdown = kATD_countdownData.countdown
		Helper.debugText("kATDHUD.countdown", kATDHUD.countdown)
		local dps = kATD_countdownData.dps
		local dps_trend = kATD_countdownData.dps_trend
		kATDHUD.isDestructionCertain = kATD_countdownData.isDestructionCertain
		Helper.debugText("frame.properties.width", frame.properties.width)
		local ftable = frame:addTable (
			1,
			{
				width = 200,
				height = 200,
				x = frame.properties.width / 2 - 200 / 2,
				y = kHUD.getNextY() + Helper.borderSize,
				scaling = true,
			}
		)
		-- local ftable = frame:addTable (1)
		local font = Helper.standardFontMono
		local fontSize = Helper.standardFontSize
		if dps_trend > 3 or kATDHUD.isDestructionCertain == true or kATDHUD.isDestructionCertain == 1 then
			font = Helper.standardFontBoldMono
			fontSize = fontSize * 2
		end
		local color = Helper.statusYellow
		local bgColor = Helper.color.transparent
		-- if kATDHUD.countdown <= 15 then
		-- 	color = Helper.statusOrange
		-- end
		local row
		if kATDHUD.isDestructionCertain == true or kATDHUD.isDestructionCertain == 1 then
			color = Helper.statusRed
			row = ftable:addRow (false, {bgColor = bgColor})
			row [1]:createText (ReadText (111204, 100), {font = font, halign = "center", color = color, fontsize = fontSize}) -- Abandon ship.
		elseif kATDHUD.isDestructionAverted == true then
			row = ftable:addRow (false, {bgColor = bgColor})
			row [1]:createText ("", {font = font, halign = "center", color = color})
			color = Helper.statusGreen
		else
			row = ftable:addRow (false, {bgColor = bgColor})
			row [1]:createText (ReadText (111204, 103), {font = font, halign = "center", color = color}) -- Execute evasive manouvers.
		end
		local dps_trend_text = string.rep ("|", dps_trend)
		local countdownText
		if kATDHUD.countdown >= 10 then
			countdownText = dps_trend_text .. " " .. tostring (kATDHUD.countdown) .. " " .. dps_trend_text
		else
			countdownText = dps_trend_text .. " 0" .. tostring (kATDHUD.countdown) .. " " .. dps_trend_text
		end
		row = ftable:addRow (false, {bgColor = bgColor})
		row [1]:createText (countdownText, {font = font, halign = "center", color = color, font = Helper.standardFontBold, fontsize = Helper.standardFontSize * 2})
		row = ftable:addRow (false, {bgColor = bgColor})
		if kATDHUD.isDestructionAverted == true then
			row [1]:createText (ReadText (111204, 102), {font = font, halign = "center", color = color}) -- Destruction averted. Destructionaverted.
		else
			row [1]:createText (ReadText (111204, 101), {font = font, halign = "center", color = color}) -- Destruction imminent.
		end
		ftable.properties.height = ftable:getVisibleHeight ()
		return {ftable}
	end
	return {}
end
function newFuncs.checkTopLevelConditions_get_is_entry_available (entry)
	if (entry.canresearch ~= nil) and entry.canresearch and (kATD.isPlayerHQLost == 1 or kATD.isPlayerHQLost == true) then
		return false
	else
		return true
	end
end
function kATD.SetIsPlayerHQLost (_, isLost)
	kATD.isPlayerHQLost = isLost
	if (isLost == 1 or isLost == true) and kATD.lastAvailableResearchModule and kATD.lastTechDataResearchStarted then
		-- cancel current research
		researchMenu.currentResearch [kATD.lastTechDataResearchStarted.tech] = kATD.lastAvailableResearchModule
		researchMenu.buttonCancelResearch (kATD.lastTechDataResearchStarted)
		kATD.lastAvailableResearchModule = nil
		kATD.lastTechDataResearchStarted = nil
	end
end
function newFuncs.buttonStartResearch (techdata)
	kATD.lastAvailableResearchModule = researchMenu.availableresearchmodule
	kATD.lastTechDataResearchStarted = techdata
	oldFuncs.buttonStartResearch (techdata)
end
function kATD.SetEscapePodAvailability (_, isEscapePodAvailable)
	kATD.isEscapePodAvailable = isEscapePodAvailable
end
function kATD.EnableEscapePodButton (_, isEscapePodEnabled)
	kATD.isEscapePodEnabled = isEscapePodEnabled
end
function kATD.display_on_set_buttontable (buttontable)
	if kATD.isEscapePodAvailable == 1 then
		local buttonrow = buttontable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		buttonrow[1]:setColSpan(3):createButton({ active = kATD.isEscapePodEnabled == 1, height = Helper.standardTextHeight }):setText(ReadText (111204, 500), { halign = "center" })
		buttonrow[1].handlers.onClick = kATD.onEscapePodClick
	end
end
function kATD.onEscapePodClick ()
	Helper.closeMenuAndReturn (transporterMenu)
	AddUITriggeredEvent ("kATD", "on_escape_pod_click")
end

return ModLua
