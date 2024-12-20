local ffi = require ("ffi")
local C = ffi.C

local ModLua = {}

local mapMenu = nil
local playerInfoMenu = nil
local origFuncs = {}
local newFuncs = {}
newFuncs.uiFinesByFactionsData = {}
-- [factionId] = {uiFactionText = "", uiFinesText = ""}
newFuncs.uiInsertedCriminalShipsByFactions = {}
-- [factionId] = {
-- 	[shipId] = 1
-- }
newFuncs.uiCriminalShipsByFactionsData = {}
-- [factionId] = {
-- 	{shipId = shipId, uiCrimesData = [table[$crimeText, $timeText, $victimText, $finesText]], uiFinesText = "", uiImpoundedText = ""}
-- }
newFuncs.config = nil
newFuncs.isDataSet = nil
newFuncs.extendedCriminalShipId = nil
newFuncs.extendedfactionId = nil
newFuncs.extendedCrimePage = 0

function ModLua.init ()
	-- DebugError ("kuertee_chc.lua.init")
	newFuncs.player_id = ConvertStringTo64Bit (tostring (C.GetPlayerID ()))
	-- DebugError ("kuertee_chc.lua.init C.GetPlayerID (): " .. tostring (C.GetPlayerID ()))
	mapMenu = Helper.getMenu ("MapMenu")
	playerInfoMenu = Helper.getMenu ("PlayerInfoMenu")
	RegisterEvent ("kCHC.ForceGetUp", newFuncs.ForceGetUp)
	RegisterEvent ("kCHC.OnMapMenuOpen", newFuncs.OnMapMenuOpen)
	RegisterEvent ("kCHC.OnMapMenuClose", newFuncs.OnMapMenuClose)
	RegisterEvent ("kCHC.OnMapMenuUpdate", newFuncs.OnMapMenuUpdate)
	RegisterEvent ("kCHC.OnPayFineByShipDone", newFuncs.OnPayFineByShipDone)
	mapMenu.registerCallback ("buttonToggleObjectList_on_start", newFuncs.buttonToggleObjectList_on_start)
	mapMenu.registerCallback ("createSideBar_on_start", newFuncs.createSideBar_on_start)
	mapMenu.registerCallback ("createInfoFrame_on_menu_infoTableMode", newFuncs.createInfoFrame_on_menu_infoTableMode)
	-- player criminal record in faction screen
	playerInfoMenu.registerCallback ("createFactions_on_before_render_licences", newFuncs.createFactions_on_before_render_licences)
	RegisterEvent ("kCHC.playerInfoMenu.onClearUIData", newFuncs.onClearUIData)
end
function newFuncs.debugText (data1, data2, indent, isForced)
	local isDebug = false
	if isDebug == true or isForced == true then
		if indent == nil then
			indent = ""
		end
		if type (data1) == "table" then
			for i, value in pairs (data1) do
				DebugError (indent .. tostring (i) .. " (" .. type (i) .. ")" .. ReadText (1001, 120) .. " " .. tostring (value) .. " (" .. type (value) .. ")")
				if type (value) == "table" then
					newFuncs.debugText (value, nil, indent .. "    ", isForced)
				end
			end
		else
			DebugError (indent .. tostring (data1) .. " (" .. type (data1) .. ")")
		end
		if data2 then
			newFuncs.debugText (data2, nil, indent .. "    ", isForced)
		end
	end
end
function newFuncs.debugText (data1, data2, indent)
	return newFuncs.debugText (data1, data2, indent, true)
end
function newFuncs.ForceGetUp ()
	if C.GetUp() then
		AddUITriggeredEvent ("kCHC", "on_force_get_up", "on_force_get_up_succeeded")
	else
		AddUITriggeredEvent ("kCHC", "on_force_get_up", "on_force_get_up_failed")
	end
end
function newFuncs.OnMapMenuOpen ()
	-- if newFuncs.isDataSet ~= true then
		-- newFuncs.isDataSet = true
		local uiFinesByFactionsData = GetNPCBlackboard (newFuncs.player_id, "$uiFinesByFactionsData")
		local faction
		for factionId, data in pairs (uiFinesByFactionsData) do
			-- DebugError ("kuertee_chc.lua.newFuncs.OnMapMenuOpen factionId: " .. tostring (factionId))
			-- DebugError ("kuertee_chc.lua.newFuncs.OnMapMenuOpen data.uiFactionText: " .. tostring (data.uiFactionText))
			-- DebugError ("kuertee_chc.lua.newFuncs.OnMapMenuOpen data.uiFinesText: " .. tostring (data.uiFinesText))
			newFuncs.uiFinesByFactionsData [tostring (factionId)] = {
				uiFactionText = tostring (data.uiFactionText),
				uiFinesText = tostring (data.uiFinesText),
				uiFines = data.uiFines
			}
		end
		local uiCriminalShipsByFactionsData = GetNPCBlackboard (newFuncs.player_id, "$uiCriminalShipsByFactionsData")
		for factionId, data in pairs (uiCriminalShipsByFactionsData) do
			-- DebugError ("kuertee_chc.lua.newFuncs.OnMapMenuOpen factionId: " .. tostring (factionId))
			if (not newFuncs.uiCriminalShipsByFactionsData [tostring (factionId)]) then
				newFuncs.uiCriminalShipsByFactionsData [tostring (factionId)] = {}
				newFuncs.uiInsertedCriminalShipsByFactions [tostring (factionId)] = {}
			end
			local uiCrimeData
			for _, crimeData in ipairs (data) do
				-- DebugError ("kuertee_chc.lua.newFuncs.OnMapMenuOpen crimeData.ship: " .. tostring (crimeData.ship))
				-- DebugError ("kuertee_chc.lua.newFuncs.OnMapMenuOpen crimeData.uiCrimesData: " .. tostring (crimeData.uiCrimesData))
				-- DebugError ("kuertee_chc.lua.newFuncs.OnMapMenuOpen crimeData.uiFinesText: " .. tostring (crimeData.uiFinesText))
				-- DebugError ("kuertee_chc.lua.newFuncs.OnMapMenuOpen crimeData.uiImpoundedText: " .. tostring (crimeData.uiImpoundedText))
				-- newFuncs.debugText ("OnMapMenuOpen", crimeData)
				uiCrimeData = {
					shipId = crimeData.ship,
					shipName = crimeData.shipName,
					uiCrimesData = crimeData.uiCrimesData,
					uiFines = crimeData.uiFines,
					uiFinesText = tostring (crimeData.uiFinesText),
					uiImpoundedText = tostring (crimeData.uiImpoundedText),
					uiImpoundedTime = crimeData.uiImpoundedTime,
					uiImpoundedTimeText = tostring (crimeData.uiImpoundedTimeText)
				}
				if not crimeData.uiCrimeAttacksCount then
					uiCrimeData.uiCrimeAttacksCount = 0
				else
					uiCrimeData.uiCrimeAttacksCount = crimeData.uiCrimeAttacksCount
				end
				if not crimeData.uiCrimeKillsCount then
					uiCrimeData.uiCrimeKillsCount = 0
				else
					uiCrimeData.uiCrimeKillsCount = crimeData.uiCrimeKillsCount
				end
				if not crimeData.uiCrimeBoardingsCount then
					uiCrimeData.uiCrimeBoardingsCount = 0
				else
					uiCrimeData.uiCrimeBoardingsCount = crimeData.uiCrimeBoardingsCount
				end
				if not crimeData.uiCrimeIllegalScansCount then
					uiCrimeData.uiCrimeIllegalScansCount = 0
				else
					uiCrimeData.uiCrimeIllegalScansCount = crimeData.uiCrimeIllegalScansCount
				end
				if not crimeData.uiCrimeIllegalCargoCount then
					uiCrimeData.uiCrimeIllegalCargoCount = 0
				else
					uiCrimeData.uiCrimeIllegalCargoCount = crimeData.uiCrimeIllegalCargoCount
				end
				if not crimeData.uiCrimeIllegalPlotsCount then
					uiCrimeData.uiCrimeIllegalPlotsCount = 0
				else
					uiCrimeData.uiCrimeIllegalPlotsCount = crimeData.uiCrimeIllegalPlotsCount
				end
				if (not newFuncs.uiInsertedCriminalShipsByFactions [tostring (factionId)][tostring (crimeData.ship)]) then
					newFuncs.uiInsertedCriminalShipsByFactions [tostring (factionId)][tostring (crimeData.ship)] = 1
					table.insert (newFuncs.uiCriminalShipsByFactionsData [tostring (factionId)], uiCrimeData)
				end
			end
		end
	-- end
end
function newFuncs.OnMapMenuClose ()
	-- DebugError ("kuertee_chc.lua.newFuncs.OnMapMenuClose")
	newFuncs.uiFinesByFactionsData = {}
	newFuncs.uiInsertedCriminalShipsByFactions = {}
	newFuncs.uiCriminalShipsByFactionsData = {}
	newFuncs.extendedCriminalShipId = nil
	newFuncs.extendedfactionId = nil
	newFuncs.isDataSet = nil
end
function newFuncs.OnMapMenuUpdate ()
	-- DebugError ("kuertee_chc.lua.newFuncs.OnMapMenuUpdate")
	newFuncs.OnMapMenuClose ()
	newFuncs.OnMapMenuOpen ()
	local menu = mapMenu
	menu.settoprow = GetTopRow (menu.infoTable)
	menu.createInfoFrame()
end
function newFuncs.addToLeftBar (config)
	local isCHCLeftBarExists
	for _, leftBarEntry in ipairs (config.leftBar) do
		if leftBarEntry.mode == "propertyowned_chc" then
			isCHCLeftBarExists = true
		end
	end
	if not isCHCLeftBarExists then
		local chcEntry = {
			name = ReadText(11383, 1000),
			icon = "mapst_chc",
			mode = "propertyowned_chc",
			helpOverlayID = "map_sidebar_chc",
			helpOverlayText = ReadText(11383, 1000),
		}
		-- table.insert (config.leftBar, {spacing = true})
		table.insert (config.leftBar, 3, chcEntry)
	end
	newFuncs.config = config
end
function newFuncs.buttonToggleObjectList_on_start (objectlistparam, config)
	newFuncs.addToLeftBar (config)
end
function newFuncs.createSideBar_on_start (config)
	newFuncs.addToLeftBar (config)
end
function newFuncs.createInfoFrame_on_menu_infoTableMode (infoFrame)
	local menu = mapMenu
	-- DebugError ("kuertee_chc.lua.newFuncs.createInfoFrame_on_menu_infoTableMode menu.mode: " .. tostring (menu.mode))
	if menu.infoTableMode == "propertyowned_chc" then
		local playerMoney = GetPlayerMoney ()
		local ftable = infoFrame:addTable (6, {tabOrder = 1, multiSelect = true})
		ftable:setDefaultCellProperties ("text", {minRowHeight = newFuncs.config.mapRowHeight, fontsize = newFuncs.config.mapFontSize})
		ftable:setDefaultCellProperties ("button", {height = newFuncs.config.mapRowHeight})
		ftable:setDefaultComplexCellProperties ("button", "text", {fontsize = newFuncs.config.mapFontSize})
		ftable:setColWidth (1, Helper.scaleY (newFuncs.config.mapRowHeight), false)
		local row = ftable:addRow (false)
		row[1]:setColSpan (6):createText (ReadText (11383, 1000), Helper.headerRowCenteredProperties) -- Fines and Forfeiture
		local numdisplayed = 0
		local maxvisibleheight = ftable:getFullHeight()
		if menu.highlightedbordersection == "propertyowned_chc" then
			menu.sethighlightborderrow = row.index + 1
		end
		-- faction -- fines
		-- (indent) -- ship.knownname (ship.idcode) -- fines -- crimes -- impounded?
		local name, color, bgcolor, font, mouseover
		local alertString
		local alertMouseOver
		local alertStatus, missionlist
		local minAlertLevel
		local color
		local indentation, actualname
		local shipname
		local shipnametruncated
		-- columns
		local columnExpandCollapse = 1
		local columnExpandCollapseSpan = 1
		local columnName = 2
		local columnNameSpan = 2
		local columnImpoundedBy = 4
		local columnImpoundedBySpan = 1
		local columnImpoundedTime = 5
		local columnImpoundedTimeSpan = 1
		local columnFines = 6
		local columnFinesSpan = 1
		-- column headings
		row = ftable:addRow (false, {bgColor = Helper.color.unselectable})
		row [columnName]:setColSpan (columnNameSpan):createText (ReadText (11383, 1100), {font = Helper.standardFontBold, mouseOverText = ReadText (11383, 1100)}) -- Ship
		row [columnImpoundedBy]:setColSpan (columnImpoundedBySpan + 1):createText (ReadText (11383, 1101), {font = Helper.standardFontBold, mouseOverText = ReadText (11383, 1101)}) -- Impound Location
		row [columnFines]:setColSpan (columnFinesSpan):createText (ReadText (11383, 1102), {font = Helper.standardFontBold, mouseOverText = ReadText (11383, 1102)}) -- Fines
		-- red = { r = 255, g = 0, b = 0, a = 100 },
		-- green = { r = 0, g = 255, b = 0, a = 100 },
		-- blue = { r = 90, g = 146, b = 186, a = 100 },
		-- yellow = { r = 144, g = 144, b = 0, a = 100 },
		-- orange = { r = 255, g = 192, b = 0, a = 100 },
		-- grey = { r = 128, g = 128, b = 128, a = 100 },
		-- darkgrey = { r = 32, g = 32, b = 32, a = 100 },
		local darkGreen = {r = 0, g = 128, b = 0, a = 100}
		local colorPositive = Helper.color.white
		local colorNegative = Helper.color.grey
		local colorSelfDefense = darkGreen
		table.sort (newFuncs.uiFinesByFactionsData, function (a, b) 
			return a.uiFactionText < b.uiFactionText
		end)
		local allFactionFines = 0
		local isPayFineBtn = false
		for factionId, data in pairs (newFuncs.uiFinesByFactionsData) do
			-- DebugError ("kuertee_chc.lua.newFuncs.createInfoFrame_on_menu_infoTableMode factionId: " .. tostring (factionId))
			row = ftable:addRow (false)
			row[1]:setColSpan (6):createText (data.uiFactionText, Helper.headerRowCenteredProperties) -- faction name
			if newFuncs.uiCriminalShipsByFactionsData [factionId] then
				table.sort (newFuncs.uiCriminalShipsByFactionsData [factionId], function (a, b) 
					-- return GetComponentData (a.shipId, "name") < GetComponentData (b.shipId, "name")
					return a.shipName < b.shipName
				end)
				local num_shipsWithCrimes = 0
				local num_shipsImpounded = 0
				for _, criminalShipData in ipairs (newFuncs.uiCriminalShipsByFactionsData [factionId]) do
					if #criminalShipData.uiCrimesData > 0 then
						num_shipsWithCrimes = num_shipsWithCrimes + 1
					end
					if tostring (criminalShipData.uiImpoundedText) ~= "" then
						num_shipsImpounded = num_shipsImpounded + 1
					end
				end
				for _, criminalShipData in ipairs (newFuncs.uiCriminalShipsByFactionsData [factionId]) do
					isPayFineBtn = playerMoney >= criminalShipData.uiFines and tostring (criminalShipData.uiImpoundedText) == "" and num_shipsWithCrimes - num_shipsImpounded > 0
					if isPayFineBtn then
						-- required because the ui trigger to md may not have paid the fine yet when this lua is refreshed
						local isShipFinesPaid = nil
						local shipId_key = tostring (ConvertStringTo64Bit (tostring (criminalShipData.shipId)))
						if newFuncs.isShipFinesPaidByFaction [shipId_key] then
							isShipFinesPaid = newFuncs.isShipFinesPaidByFaction [shipId_key][factionId]
						end
						if isShipFinesPaid then
							isPayFineBtn = false
						end
					end
					if isPayFineBtn or (criminalShipData.uiImpoundedText ~= "") then
						-- row = ftable:addRow (false, {fixed = true, bgColor = Helper.color.transparent})
						name, color, bgcolor, font, mouseover = menu.getContainerNameAndColors (criminalShipData.shipId, 0, false, false)
						-- DebugError ("kuertee_chc.lua.newFuncs.createInfoFrame_on_menu_infoTableMode criminalShipData.shipId " .. tostring (criminalShipData.shipId))
						-- DebugError ("kuertee_chc.lua.newFuncs.createInfoFrame_on_menu_infoTableMode newFuncs.player_id " .. tostring (ConvertStringToLuaID (tostring (newFuncs.player_id))))
						-- if tostring (criminalShipData.shipId) == tostring (ConvertStringToLuaID (tostring (newFuncs.player_id))) then
						-- 	name = GetComponentData (criminalShipData.shipId, "name")
						-- 	-- DebugError ("kuertee_chc.lua.newFuncs.createInfoFrame_on_menu_infoTableMode name" .. tostring (name))
						-- end
						name = criminalShipData.shipName
						-- DebugError ("kuertee_chc.lua.newFuncs.createInfoFrame_on_menu_infoTableMode name " .. tostring (name) .. " " .. GetComponentData (criminalShipData.shipId, "owner"))
						alertString = ""
						alertMouseOver = ""
						if menu.getFilterOption ("layer_think") then
							alertStatus, missionlist = menu.getContainerAlertLevel (criminalShipData.shipId)
							minAlertLevel = menu.getFilterOption ("think_alert")
							if (minAlertLevel ~= 0) and alertStatus >= minAlertLevel then
								color = Helper.color.white
								if alertStatus == 1 then
									color = menu.holomapcolor.lowalertcolor
								elseif alertStatus == 2 then
									color = menu.holomapcolor.mediumalertcolor
								else
									color = menu.holomapcolor.highalertcolor
								end
								alertString = Helper.convertColorToText (color) .. "\027[workshop_error]\027X"
								alertMouseOver = ReadText(1001, 3305) .. ReadText(1001, 120) .. "\n" .. missionlist
							end
						end
						row = ftable:addRow ({"property", criminalShipData.shipId, nil, 0}, {bgColor = bgcolor, multiSelected = menu.isSelectedComponent (criminalShipData.shipId)})
						if (menu.getNumSelectedComponents () == 1) and menu.isSelectedComponent (criminalShipData.shipId) then
							menu.setrow = row.index
						end
						if IsSameComponent (criminalShipData.shipId, menu.highlightedbordercomponent) then
							menu.sethighlightborderrow = row.index
						end
						-- if criminalShipData.uiFines > 0 then
						if #criminalShipData.uiCrimesData then
							row[columnExpandCollapse]:setColSpan (columnExpandCollapseSpan):createButton ():setText (newFuncs.getIsCriminalShipByFactionExtended (criminalShipData.shipId, factionId) and "-" or "+", {halign = "center"})
							row[columnExpandCollapse].handlers.onClick = function () return newFuncs.extendCriminalShipByFaction (criminalShipData.shipId, factionId) end
						end
						indentation, actualname = string.match (name, "([ ]*)(.*)")
						shipname = indentation .. alertString .. actualname
						shipnametruncated = TruncateText (shipname, font, Helper.scaleFont (font, newFuncs.config.mapFontSize), row[1]:getColSpanWidth () - Helper.scaleX (Helper.standardTextOffsetx))
						mouseover = ""
						if shipnametruncated ~= shipname then
							mouseover = shipname
						end
						if tostring (criminalShipData.uiImpoundedText) ~= "" then
							row[columnName]:setColSpan (columnNameSpan):createText (shipname, {font = font, color = color, mouseOverText = mouseover})
							row[columnImpoundedBy]:setColSpan (columnImpoundedBySpan):createText (tostring (criminalShipData.uiImpoundedText), {mouseOverText = ReadText (11383, 1001) .. ": " .. tostring (criminalShipData.uiImpoundedText)})
							row[columnImpoundedTime]:setColSpan (columnImpoundedTimeSpan):createText (Helper.getPassedTime (criminalShipData.uiImpoundedTime), {color = color, mouseOverText = criminalShipData.uiImpoundedTimeText})
						else
							row[columnName]:setColSpan (columnNameSpan + 1):createText (shipname, {font = font, color = color, mouseOverText = mouseover})
						end
						if criminalShipData.uiFines > 0 then
							row[columnFines]:setColSpan (columnFinesSpan):createText (tostring (criminalShipData.uiFinesText))
						end
						if IsComponentClass (criminalShipData.shipId, "station") then
							AddKnownItem ("stationtypes", GetComponentData (criminalShipData.shipId, "macro"))
						elseif IsComponentClass (criminalShipData.shipId, "ship_xl") then
							AddKnownItem ("shiptypes_xl", GetComponentData (criminalShipData.shipId, "macro"))
						elseif IsComponentClass (criminalShipData.shipId, "ship_l") then
							AddKnownItem ("shiptypes_l", GetComponentData (criminalShipData.shipId, "macro"))
						elseif IsComponentClass (criminalShipData.shipId, "ship_m") then
							AddKnownItem ("shiptypes_m", GetComponentData (criminalShipData.shipId, "macro"))
						elseif IsComponentClass (criminalShipData.shipId, "ship_s") then
							AddKnownItem ("shiptypes_s", GetComponentData (criminalShipData.shipId, "macro"))
						elseif IsComponentClass (criminalShipData.shipId, "ship_xs") then
							AddKnownItem ("shiptypes_xs", GetComponentData (criminalShipData.shipId, "macro"))
						end
						if newFuncs.getIsCriminalShipByFactionExtended (criminalShipData.shipId, factionId) then
							row = ftable:addRow (true, {bgColor = Helper.color.transparent})
							row[6]:createButton ({active = isPayFineBtn}):setText (ReadText (11383, 1103), {halign = "center"}) -- pay now
							row[6].handlers.onClick = function () return newFuncs.payFineByShip (criminalShipData.shipId, factionId) end
							-- row = ftable:addRow (false, {bgColor = Helper.color.transparent})
							color = colorPositive
							if criminalShipData.uiCrimeAttacksCount == 0 then
								color = colorNegative
							end
							row[2]:createText (ReadText (11383, 1015) .. ": " .. tostring (criminalShipData.uiCrimeAttacksCount), {color = color})
							color = colorPositive
							if criminalShipData.uiCrimeKillsCount == 0 then
								color = colorNegative
							end
							row[3]:createText (ReadText (11383, 1017) .. ": " .. tostring (criminalShipData.uiCrimeKillsCount), {color = color})
							color = colorPositive
							if criminalShipData.uiCrimeBoardingsCount == 0 then
								color = colorNegative
							end
							row[4]:createText (ReadText (11383, 1016) .. ": " .. tostring (criminalShipData.uiCrimeBoardingsCount), {color = color})
							row = ftable:addRow (false, {bgColor = Helper.color.transparent})
							color = colorPositive
							if criminalShipData.uiCrimeIllegalScansCount == 0 then
								color = colorNegative
							end
							row[2]:createText (ReadText (11383, 1019) .. ": " .. tostring (criminalShipData.uiCrimeIllegalScansCount), {color = color})
							color = colorPositive
							if criminalShipData.uiCrimeIllegalCargoCount == 0 then
								color = colorNegative
							end
							row[3]:createText (ReadText (11383, 1020) .. ": " .. tostring (criminalShipData.uiCrimeIllegalCargoCount), {color = color})
							color = colorPositive
							if criminalShipData.uiCrimeIllegalPlotsCount == 0 then
								color = colorNegative
							end
							row[4]:createText (ReadText (11383, 1021) .. ": " .. tostring (criminalShipData.uiCrimeIllegalPlotsCount), {color = color})
							local lastI
							local crimeLineStart = newFuncs.extendedCrimePage * 10 + 1
							local crimeLineEnd = newFuncs.extendedCrimePage * 10 + 10
							for i = crimeLineStart, crimeLineEnd do
								if i <= #criminalShipData.uiCrimesData then
									lastI = i
									crimeData = criminalShipData.uiCrimesData [i]
									if crimeData.victimId and C.IsComponentOperational (ConvertIDTo64Bit (crimeData.victimId)) == true then
										row = ftable:addRow ({"property", crimeData.victimId, nil, 0}, {bgColor = Helper.color.transparent})
										color = colorPositive
									else
										row = ftable:addRow (false, {bgColor = Helper.color.transparent})
										color = colorNegative
									end
									row[2]:createText (Helper.getPassedTime (crimeData.time), {color = color, mouseOverText = crimeData.timeText})
									if crimeData.isSelfDefense == 1 then
										row[3]:createText ("(" .. crimeData.crimeText .. ")", {color = colorSelfDefense, mouseOverText = ReadText (11383, 1005) .. ": " .. crimeData.crimeText})
									elseif crimeData.isCommanderCrime == 1 then
										row[3]:createText ("(" .. crimeData.crimeText .. ")", {color = colorSelfDefense, mouseOverText = ReadText (11383, 1022) .. ": " .. crimeData.crimeText})
									elseif crimeData.kCHC_isSanctioned == 1 then
										-- <t id="1023">Sanctioned(EM and RAP support)</t>
										row[3]:createText ("(" .. crimeData.crimeText .. ")", {color = colorSelfDefense, mouseOverText = ReadText (11383, 1023) .. ": " .. crimeData.crimeText})
									else
										row[3]:createText (crimeData.crimeText, {color = color})
									end
									shipnametruncated = TruncateText (crimeData.victimText, font, Helper.scaleFont (font, newFuncs.config.mapFontSize), row[3]:getColSpanWidth () - Helper.scaleX (Helper.standardTextOffsetx))
									mouseover = ""
									if shipnametruncated ~= shipname then
										mouseover = crimeData.victimText
									end
									row[4]:setColSpan (2):createText (crimeData.victimText, {color = color, mouseOverText = mouseover})
									if crimeData.isSelfDefense == 1 then
										row[6]:createText ("(" .. crimeData.finesText .. ")", {color = colorSelfDefense, mouseOverText = ReadText (11383, 1005) .. ": " .. crimeData.finesText})
									elseif crimeData.isCommanderCrime == 1 then
										row[6]:createText ("(" .. crimeData.finesText .. ")", {color = colorSelfDefense, mouseOverText = ReadText (11383, 1022) .. ": " .. crimeData.finesText})
									elseif crimeData.kCHC_isSanctioned == 1 then
										-- <t id="1023">Sanctioned(EM and RAP support)</t>
										row[6]:createText ("(" .. crimeData.finesText .. ")", {color = colorSelfDefense, mouseOverText = ReadText (11383, 1023) .. ": " .. crimeData.finesText})
									else
										row[6]:createText (crimeData.finesText, {color = color})
									end
									numdisplayed = numdisplayed + 1
								else
									break
								end
							end
							if (newFuncs.extendedCrimePage ~= nil and newFuncs.extendedCrimePage) > 0 or (lastI ~=nil and lastI < #criminalShipData.uiCrimesData) then
								row = ftable:addRow (true, {bgColor = Helper.color.transparent})
								if newFuncs.extendedCrimePage > 0 then
									row[5]:createButton ():setText (ReadText (11383, 1003)) -- previous 10
									row[5].handlers.onClick = function () return newFuncs.extendedCrimePagePrevious () end
								end
								if  lastI < #criminalShipData.uiCrimesData then
									row[6]:createButton ():setText (ReadText (11383, 1002), {halign = "right"}) -- next 10
									row[6].handlers.onClick = function () return newFuncs.extendedCrimePageNext () end
								end
							end
						end
						numdisplayed = numdisplayed + 1
					end
				end
			end
			row = ftable:addRow (false, {bgColor = Helper.color.transparent})
			row[columnFines - 1]:createText (ReadText (11383, 1004)) -- Total fines
			row[columnFines]:createText (data.uiFinesText) -- Total fines
			if data.uiFines then
				allFactionFines = allFactionFines + data.uiFines
			end
		end
		-- DebugError ("allFactionFines: " .. tostring (allFactionFines))
		if numdisplayed == 0 and allFactionFines == 0 then
			row = ftable:addRow (true, {bgColor = Helper.color.transparent})
			row[2]:setColSpan (5):createText ("-- " .. ReadText (11383, 1104) .. " --") -- No fines
		elseif numdisplayed > 50 then
			ftable.properties.maxVisibleHeight = maxvisibleheight + 50 * (Helper.scaleY (newFuncs.config.mapRowHeight) + Helper.borderSize)
		end
		menu.numFixedRows = ftable.numfixedrows
		menu.settoprow = 1
		ftable:setTopRow (menu.settoprow)
		if menu.infoTable then
			local result = GetShiftStartEndRow (menu.infoTable)
			if result then
				ftable:setShiftStartEnd (table.unpack (result))
			end
		end
		ftable:setSelectedRow (menu.sethighlightborderrow or menu.setrow)
		menu.setrow = nil
		menu.settoprow = nil
		menu.setcol = nil
		menu.sethighlightborderrow = nil
		return true
	end
	return nil
end
function newFuncs.extendCriminalShipByFaction (shipId, factionId)
	local menu = mapMenu
	if newFuncs.getIsCriminalShipByFactionExtended (shipId, factionId) then
		newFuncs.extendedCriminalShipId = nil
		newFuncs.extendedfactionId = nil
		newFuncs.extendedCrimePage = 0
	else
		newFuncs.extendedCriminalShipId = shipId
		newFuncs.extendedfactionId = factionId
		newFuncs.extendedCrimePage = 0
	end
	menu.settoprow = GetTopRow (menu.infoTable)
	menu.createInfoFrame()
end
function newFuncs.getIsCriminalShipByFactionExtended (shipId, factionId)
	if newFuncs.extendedCriminalShipId == shipId and newFuncs.extendedfactionId == factionId then
		return true
	end
	return nil
end
function newFuncs.extendedCrimePageNext ()
	local menu = mapMenu
	newFuncs.extendedCrimePage = newFuncs.extendedCrimePage + 1
	menu.settoprow = GetTopRow (menu.infoTable)
	menu.createInfoFrame()
end
function newFuncs.extendedCrimePagePrevious ()
	local menu = mapMenu
	newFuncs.extendedCrimePage = newFuncs.extendedCrimePage - 1
	if newFuncs.extendedCrimePage < 0 then
		newFuncs.extendedCrimePage = 0
	end
	menu.settoprow = GetTopRow (menu.infoTable)
	menu.createInfoFrame()
end
newFuncs.isShipFinesPaidByFaction = {}
function newFuncs.payFineByShip (shipId, factionId)
	local menu = mapMenu
	local shipId_key = tostring (ConvertStringTo64Bit (tostring (shipId)))
	if not newFuncs.isShipFinesPaidByFaction [shipId_key] then
		newFuncs.isShipFinesPaidByFaction [shipId_key] = {}
	end
	newFuncs.isShipFinesPaidByFaction [shipId_key][factionId] = true
	AddUITriggeredEvent ("kCHC", "pay_fine_by_ship", {ship = shipId, faction = factionId})
end
function newFuncs.OnPayFineByShipDone ()
	local menu = mapMenu
	menu.refreshInfoFrame ()
end
-- player criminal record in factions screen
newFuncs.extendedPlayerCriminalRecord_factionId = nil
function newFuncs.createFactions_on_before_render_licences (frame, tableProperties, factionId, infotable)
	local menu = playerInfoMenu
	-- DebugError ("kuertee_chc createFactions_on_before_render_licences factionId " .. tostring (factionId) .. " newFuncs.ui_kCHC_playerCrimesData " .. tostring (newFuncs.ui_kCHC_playerCrimesData))
	if not newFuncs.ui_kCHC_playerCrimesData then
		Helper.debugText("not ok")
		newFuncs.ui_kCHC_playerCrimesData = GetNPCBlackboard (newFuncs.player_id, "$ui_kCHC_playerCrimesData")
	end
	if factionId and newFuncs.ui_kCHC_playerCrimesData then
		Helper.debugText("ok", tostring(newFuncs.extendedPlayerCriminalRecord_factionId) .. " == " .. tostring(factionId))
		-- Helper.debugText("chc createFactions_on_before_render_licences ui_kCHC_playerCrimesData", tostring(newFuncs.ui_kCHC_playerCrimesData))
		if newFuncs.extendedPlayerCriminalRecord_factionId ~= factionId then
			newFuncs.extendedPlayerCriminalRecord_factionId = nil
		end
		newFuncs.renderPlayerCriminalRecord (factionId, infotable)
	end
end
newFuncs.uiCrimesTexts = nil
newFuncs.playerCriminalRecord = nil
newFuncs.playerCrimesByFaction = nil
function newFuncs.renderPlayerCriminalRecord (factionId, infotable)
	local menu = playerInfoMenu
	-- <append_to_list name="$playerCriminalRecord" exact="table[
	-- 	$time = $Time,
	-- 	$shipName = $shipName,
	-- 	$crime = $Crime,
	-- 	$victimName = $victimName,
	-- 	$victimFaction = $VictimFaction,
	-- 	$fine = $Fine
	-- ]" />
	-- DebugError ("kuertee_chc renderPlayerCriminalRecord factionId: " .. tostring (factionId))
	-- Helper.debugText("chc renderPlayerCriminalRecord", factionId)
	if (not newFuncs.uiCrimesTexts) or (not newFuncs.playerCriminalRecord) then
		-- Helper.debugText("newFuncs.uiCrimesTexts", newFuncs.uiCrimesTexts)
		newFuncs.uiCrimesTexts = newFuncs.ui_kCHC_playerCrimesData ["uiCrimeTexts"]
		newFuncs.playerCriminalRecord = newFuncs.ui_kCHC_playerCrimesData ["playerCriminalRecord"]
		newFuncs.playerCrimesByFaction = {}
		newFuncs.playerTotalFinesByFaction = {}
		newFuncs.playerOutstandingFinesByFaction = {}
		-- DebugError ("kuertee_chc renderPlayerCriminalRecord #playerCriminalRecord: " .. tostring (#playerCriminalRecord))
		if #newFuncs.playerCriminalRecord > 0 then
			local victimFactionId, row, text, timeText, crimeText, shipName, victimName, finesText
			table.sort (newFuncs.playerCriminalRecord, function (a, b)
				-- return Helper.getPassedTime (a.time) > Helper.getPassedTime (b.time)
				return a.time > b.time
			end)
			for i, crimeData in ipairs (newFuncs.playerCriminalRecord) do
				victimFactionId = crimeData.victimFaction
				if not newFuncs.playerTotalFinesByFaction[victimFactionId] then
					newFuncs.playerTotalFinesByFaction[victimFactionId] = 0
				end
				newFuncs.playerTotalFinesByFaction[victimFactionId] = newFuncs.playerTotalFinesByFaction[victimFactionId] + crimeData.fines
				-- timeText = Helper.convertGameTimeToXTimeString (crimeData.time)
				timeText = Helper.getPassedTime (crimeData.time)
				crimeText = newFuncs.uiCrimesTexts [crimeData.crime]
				shipName = crimeData.shipName
				victimName = crimeData.victimName
				finesText = ConvertMoneyString (crimeData.fines, false, true, nil, true) .. " " .. ReadText (1001, 101)
				if not newFuncs.playerOutstandingFinesByFaction[victimFactionId] then
					newFuncs.playerOutstandingFinesByFaction[victimFactionId] = 0
				end
				if crimeData.isPaid ~= 1 and crimeData.isPaid ~= true then
					newFuncs.playerOutstandingFinesByFaction[victimFactionId] = newFuncs.playerOutstandingFinesByFaction[victimFactionId] + crimeData.fines
					finesText = Helper.convertColorToText (Helper.color.red) .. finesText .. "\27X"
				end
				-- DebugError ("kuertee_chc renderPlayerCriminalRecord timeText: " .. tostring (timeText))
				-- DebugError ("kuertee_chc renderPlayerCriminalRecord crimeText: " .. tostring (crimeText))
				-- DebugError ("kuertee_chc renderPlayerCriminalRecord shipName: " .. tostring (shipName))
				-- DebugError ("kuertee_chc renderPlayerCriminalRecord victimName: " .. tostring (victimName))
				-- DebugError ("kuertee_chc renderPlayerCriminalRecord finesText: " .. tostring (finesText))
				local text = string.format (ReadText (11383, 5001), timeText, crimeText, shipName, victimName, finesText)
				if not newFuncs.playerCrimesByFaction[victimFactionId] then
					newFuncs.playerCrimesByFaction[victimFactionId] = {}
				end
				table.insert(newFuncs.playerCrimesByFaction[victimFactionId], text)
			end
		end
	end
	if newFuncs.playerCrimesByFaction and newFuncs.playerCrimesByFaction[factionId] and #newFuncs.playerCrimesByFaction[factionId] then
		-- <page id="1001" title="Interface" descr="Text for interface and menus" voice="no">
		-- <t id="2637">Total</t>
		-- <t id="120">($COLON_TEXT$):</t>
		-- <page id="11383" voice="no">
		-- <t id="5000">Criminal Record</t>
		-- <t id="5001">%s(time): %s(crime), offender: %s(ship), victim: %s(victim), fines: %s(fines)</t>
		-- <t id="5002">Unpaid</t>
		-- <t id="5003">Not on record</t>
		row = infotable:addRow (true, {bgColor = Helper.color.transparent})
		row [3]:createButton ():setText (ReadText (11383, 5000), {halign = "center"})
		row [3].handlers.onClick = function () return newFuncs.togglePlayerCriminalRecord (factionId) end
		if newFuncs.extendedPlayerCriminalRecord_factionId == factionId then
			if newFuncs.playerCrimesByFaction[factionId] and next(newFuncs.playerCrimesByFaction[factionId]) then
				for i, text in ipairs (newFuncs.playerCrimesByFaction[factionId]) do
					row = infotable:addRow (true, {bgColor = Helper.color.transparent})
					row [1]:setColSpan (3):createText (text)
				end
				if newFuncs.playerOutstandingFinesByFaction[factionId] > 0 then
					finesText = ConvertMoneyString (newFuncs.playerOutstandingFinesByFaction[factionId], false, true, 0, true) .. " " .. ReadText (1001, 101)
					finesText = Helper.convertColorToText (Helper.color.red) .. finesText .. "\27X"
					text = ReadText (11383, 5002) .. ReadText (1001, 120) .. " " .. finesText
					row = infotable:addRow (true, {bgColor = Helper.color.transparent})
					row [1]:setColSpan (3):createText (text, {halign = "right"})
				end
				finesText = ConvertMoneyString (newFuncs.playerTotalFinesByFaction[factionId], false, true, 0, true) .. " " .. ReadText (1001, 101)
				text = ReadText (1001, 2637) .. ReadText (1001, 120) .. " " .. finesText
				row = infotable:addRow (true, {bgColor = Helper.color.transparent})
				row [1]:setColSpan (3):createText (text, {halign = "right"})
				row = infotable:addRow (true, {bgColor = Helper.color.transparent})
				row [1]:createText ("")
			end
		end
	end
end
function newFuncs.togglePlayerCriminalRecord (factionId)
	local menu = playerInfoMenu
	if newFuncs.extendedPlayerCriminalRecord_factionId ~= nil then
		newFuncs.extendedPlayerCriminalRecord_factionId = nil
	else
		newFuncs.extendedPlayerCriminalRecord_factionId = factionId
	end
	menu.refresh = getElapsedTime ()
end
function newFuncs.onClearUIData ()
	Helper.debugText("chc onClearUIData")
	newFuncs.ui_kCHC_playerCrimesData = nil
	newFuncs.extendedPlayerCriminalRecord_factionId = nil
	newFuncs.isShipFinesPaidByFaction = {}
	newFuncs.uiCrimesTexts = nil
	newFuncs.playerCriminalRecord = nil
	newFuncs.playerCrimesByFaction = nil
	newFuncs.playerTotalFinesByFaction = nil
	newFuncs.playerOutstandingFinesByFaction = nil
end

return ModLua
