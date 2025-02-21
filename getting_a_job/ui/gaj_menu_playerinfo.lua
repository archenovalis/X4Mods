local ffi = require ("ffi")
local C = ffi.C
ffi.cdef[[
	SofttargetDetails2 GetSofttarget2(void);
]]

local ModLua = {}

local mapMenu
local interactMenu
local transporterMenu
local playerInfoMenu
local origFuncs = {}
local kNPCConstructionShips = {}
local kNPCTaxis = {}
local kNPCBankLoans = {}
local kBridgeCrew = {}
local playerId
local kNPCRumours = {}
local newFuncs = {}
Helper.loadModLuas("gaj_maintenance", "gaj_maintenance")
function init()
	Helper.initModLuas("gaj_maintenance")
	playerId = ConvertStringTo64Bit (tostring (C.GetPlayerID ()))
	-- start: NPC constructors
	local builderFee = tonumber (C.GetBuilderHiringFee ())
	AddUITriggeredEvent ("kNPCReactionsLuaReady", "data", {builderFee = builderFee})
	mapMenu = Helper.getMenu ("MapMenu")
	RegisterEvent ("kNPCConstructionShips.SetCVToDeploy", kNPCConstructionShips.SetCVToDeploy)
	RegisterEvent ("kNPCConstructionShips.SetStationToBuild", kNPCConstructionShips.SetStationToBuild)
	RegisterEvent ("kNPCConstructionShips.DeployCVToStation", kNPCConstructionShips.DeployCVToStation)
	-- end: NPC constructors
	-- start: NPC taxi
	interactMenu = Helper.getMenu ("InteractMenu")
	origFuncs.createContentTable = interactMenu.createContentTable
	interactMenu.createContentTable = kNPCTaxis.interactMenuCreateContentTable
	transporterMenu = Helper.getMenu ("TransporterMenu")
	transporterMenu.registerCallback ("display_on_set_buttontable", kNPCTaxis.display_on_set_buttontable)
	RegisterEvent ("kNPCTaxis.OnArriveAtDestination", kNPCTaxis.OnArriveAtDestination)
	RegisterEvent ("kNPCTaxis.OnDisembarkAtDestination", kNPCTaxis.OnDisembarkAtDestination)
	-- end: NPC taxi
	-- start: NPC bank loans
	playerInfoMenu = Helper.getMenu ("PlayerInfoMenu")
	playerInfoMenu.registerCallback ("createInfoFrame_on_start", kNPCBankLoans.createInfoFrame_on_start)
	playerInfoMenu.registerCallback ("createInfoFrame_on_info_frame_mode", kNPCBankLoans.createInfoFrame_on_info_frame_mode)
	RegisterEvent ("kNPCBankLoans.onClearUIData", kNPCBankLoans.onClearUIData)
	RegisterEvent ("kNPCBankLoans.togglePlayerInfoMenuRefresh", kNPCBankLoans.togglePlayerInfoMenuRefresh)
	-- end: NPC bank loans
	-- start: Bridge crew
	RegisterEvent ("kBridgeCrew_get_target", kBridgeCrew.getTarget)
	RegisterEvent ("kBridgeCrew_set_target", kBridgeCrew.setTarget)
	RegisterEvent ("kBridgeCrew_give_order", kBridgeCrew.giveOrder)
	-- end: Bridge crew
	-- start: rumours
	RegisterEvent ("kNPCRumours.get_active_mission", kNPCRumours.get_active_mission)
	-- end:
end
function newFuncs.debugText (data1, data2, indent, isForced)
	local isDebug = false
	if isDebug == true or isForced == true then
		if indent == nil then
			indent = ""
		end
		if type (data1) == "table" then
			for i, value in pairs (data1) do
				DebugError (indent .. tostring (i) .. ReadText (1001, 120) .. " " .. tostring (value))
				if type (value) == "table" then
					newFuncs.debugText (value, nil, indent .. "    ", isForced)
				end
			end
		else
			DebugError (indent .. tostring (data1))
		end
		if data2 then
			newFuncs.debugText (data2, nil, indent .. "    ", isForced)
		end
	end
end
function newFuncs.debugText_forced (data1, data2, indent)
	return newFuncs.debugText (data1, data2, indent, true)
end
-- start: NPC constructors
function kNPCConstructionShips.SetCVToDeploy (_, object)
	kNPCConstructionShips.CV = ConvertStringTo64Bit (object)
end
function kNPCConstructionShips.SetStationToBuild (_, object)
	kNPCConstructionShips.station = ConvertStringTo64Bit (object)
end
function kNPCConstructionShips.DeployCVToStation ()
	if kNPCConstructionShips.CV and kNPCConstructionShips.station then
		mapMenu.orderDeployToStation (kNPCConstructionShips.CV, kNPCConstructionShips.station, true)
		kNPCConstructionShips.CV = nil
		kNPCConstructionShips.station = nil
	end
end
-- end: NPC constructors
-- start: NPC taxi
function kNPCTaxis.interactMenuCreateContentTable (frame, position)
	local ui_kNPCTaxis_data = GetNPCBlackboard (playerId, "$ui_kNPCTaxis_data")
	newFuncs.debugText ("interactMenuCreateContentTable", ui_kNPCTaxis_data)
	local ftable = origFuncs.createContentTable (frame, position)
	if ui_kNPCTaxis_data then
		if interactMenu.mode == "shipconsole" then
			local entry = {
				text = ReadText (1416318, 689113),
				script = kNPCTaxis.interactMenuCallForTransport,
				active = true,
				mouseOverText = ""
			}
			-- ReadText (1416318, 689113) = call for transport
			local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
			local button = row[1]:setColSpan(4):createButton({
				bgColor = entry.active and Helper.color.transparent or Helper.color.darkgrey,
				highlightColor = entry.active and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor,
				mouseOverText = entry.mouseOverText,
				helpOverlayID = entry.helpOverlayID,
				helpOverlayText = entry.helpOverlayText,
				helpOverlayHighlightOnly = entry.helpOverlayHighlightOnly,
			}):setText(entry.text, { color = entry.active and Helper.color.white or Helper.color.lightgrey })
			if entry.active then
				row[1].handlers.onClick = entry.script
			end
		end
	end
	return ftable
end
function kNPCTaxis.interactMenuCallForTransport ()
	AddUITriggeredEvent ("kNPCTaxis", "call_for_transport")
	interactMenu.onCloseElement ("close")
end
function kNPCTaxis.OnArriveAtDestination ()
	kNPCTaxis.isShowTeleportToDestinationButton = true
end
function kNPCTaxis.display_on_set_buttontable (buttontable)
	if kNPCTaxis.isShowTeleportToDestinationButton == true then
		local buttonrow = buttontable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		buttonrow[2]:setColSpan(2):createButton({ active = true, height = Helper.standardTextHeight }):setText(ReadText (1416318, 689124), { halign = "center" })
		buttonrow[2].handlers.onClick = kNPCTaxis.teleportToDestination
	end
end
function kNPCTaxis.teleportToDestination ()
	AddUITriggeredEvent ("kNPCTaxis", "teleport_to_destination")
	local menu = transporterMenu
	Helper.closeMenuAndReturn(menu)
	menu.cleanup()
end
function kNPCTaxis.OnDisembarkAtDestination ()
	kNPCTaxis.isShowTeleportToDestinationButton = false
end
-- end: NPC taxi
-- start: NPC bank loans
function kNPCBankLoans.addBankLoansToLeftBar (config)
	local isBankLoansExists
	local insertAt
	for i, leftBarEntry in ipairs (config.leftBar) do
		if leftBarEntry.mode == "accounts" then
			insertAt = i + 1
		elseif leftBarEntry.mode == "bank_loans" then
			isBankLoansExists = true
		end
	end
	if not isBankLoansExists then
		local addThis = {
			name = ReadText (1416318, 689300),
			icon = "pi_accountmanagement",
			mode = "bank_loans",
			active = true,
			helpOverlayID = "playerinfo_sidebar_bank_loans",
			helpOverlayText = ReadText (1416318, 689300)
		}
		table.insert (config.leftBar, insertAt, addThis)
	end
	kNPCBankLoans.config = config
end
function kNPCBankLoans.createInfoFrame_on_start ()
	kNPCBankLoans.ui_kNPCBankLoans_data = GetNPCBlackboard (playerId, "$ui_kNPCBankLoans_data")
end
function kNPCBankLoans.togglePlayerInfoMenuRefresh ()
	local menu = playerInfoMenu
	kNPCBankLoans.ui_kNPCBankLoans_data = GetNPCBlackboard (playerId, "$ui_kNPCBankLoans_data")
	if menu.mode == "accounts" then
		menu.refresh = getElapsedTime ()
	end
end
function kNPCBankLoans.createInfoFrame_on_info_frame_mode (infoFrame, tableProperties)
	local menu = playerInfoMenu
	if menu.mode == "accounts" then
		tableProperties.width = menu.playerInfoFullWidth - menu.sideBarWidth - Helper.borderSize
		kNPCBankLoans.createBankLoansInfo (infoFrame, tableProperties)
	end
end
function kNPCBankLoans.createBankLoansInfo (frame, tableProperties)
	local menu = playerInfoMenu
	local playerMoney = GetPlayerMoney ()

	local width_max, x_min, y_min = 0, 1000000, 1000000
	local ftable
	for i = 1, #menu.infoFrame.content do
		if menu.infoFrame.content [i].type == "table" then
			if menu.infoFrame.content [i].properties.width <= width_max then
				if menu.infoFrame.content [i].properties.x >= x_min then
					if menu.infoFrame.content [i].properties.y < y_min then
						width_max = menu.infoFrame.content [i].properties.width
						x_min = menu.infoFrame.content [i].properties.x
						y_min = menu.infoFrame.content [i].properties.y
						ftable = menu.infoFrame.content [i]
					end
				elseif menu.infoFrame.content [i].properties.x < x_min then
					width_max = menu.infoFrame.content [i].properties.width
					x_min = menu.infoFrame.content [i].properties.x
					y_min = menu.infoFrame.content [i].properties.y
					ftable = menu.infoFrame.content [i]
				end
			elseif menu.infoFrame.content [i].properties.width > width_max then
				width_max = menu.infoFrame.content [i].properties.width
				x_min = menu.infoFrame.content [i].properties.x
				y_min = menu.infoFrame.content [i].properties.y
				ftable = menu.infoFrame.content [i]
			end
		end
	end
	local accountsTable = ftable -- assume left-most, highest, and widest table is always accounts table

	local width = menu.playerInfoFullWidth - menu.sideBarWidth - Helper.borderSize - accountsTable.properties.width
	if width > accountsTable.properties.width then
		width = accountsTable.properties.width
	end
	local x = accountsTable.properties.x + accountsTable.properties.width + Helper.borderSize
	local y = accountsTable.properties.y
	local bankLoansTable = frame:addTable (5, {tabOrder = 2, width = width, x = x, y = y})

	local row = bankLoansTable:addRow (nil, {fixed = true, bgColor = Helper.defaultTitleBackgroundColor})
	row [1]:setColSpan (5):createText (ReadText (1416318, 689300), Helper.titleTextProperties) -- Bank Loans
	row = bankLoansTable:addRow (nil, {fixed = true, bgColor = Helper.color.unselectable})
	row [1]:createText (ReadText (1416318, 689301), {font = Helper.standardFontBold}) -- Station
	row [2]:createText (ReadText (1416318, 689302), {font = Helper.standardFontBold}) -- Lender
	row [3]:createText (ReadText (1416318, 689303), {font = Helper.standardFontBold}) -- Loan
	row [4]:createText (ReadText (1416318, 689304), {font = Helper.standardFontBold}) -- Interest rate
	-- row [5]:createText (ReadText (1416318, 689305)) -- Pay loan
	local bankLoansByStation = kNPCBankLoans.ui_kNPCBankLoans_data
	if bankLoansByStation and type (bankLoansByStation) == "table" then
		local stations = {}
		local loansByStation = {}
		for station, lenders in pairs (bankLoansByStation) do
			table.insert (stations, station)
			local loansByLender = {}
			for lender, loan in pairs (lenders) do
				loan.lender = lender
				table.insert (loansByLender, loan)
			end
			table.sort (loansByLender, function (a, b)
				return a.current > b.current
			end)
			loansByStation [station] = loansByLender
		end
		table.sort (stations, function (a, b)
			return GetComponentData (a, "name") < GetComponentData (b, "name")
		end)
		local loans
		for i, station in ipairs (stations) do
			local loansByLender = loansByStation [station]
			local stationName, lender, lenderName, mouseOverText
			for j, loan in ipairs (loansByLender) do
				if loan and type (loan) == "table" then
					lender = loan.lender
					if lender then
						row = bankLoansTable:addRow (true, {bgColor = Helper.color.transparent})
						stationName = GetComponentData (station, "name")
						mouseOverText = string.format (ReadText (1416318, 689307), stationName)
						row [1]:createButton ({active = true, mouseOverText = mouseOverText}):setText (stationName) -- station
						row [1].handlers.onClick = function () return kNPCBankLoans.showOnMap (station) end
						lenderName = GetComponentData (lender, "name")
						mouseOverText = string.format (ReadText (1416318, 689308), lenderName)
						row [2]:createButton ({active = true, mouseOverText = mouseOverText}):setText (lenderName) -- lender
						row [2].handlers.onClick = function () return kNPCBankLoans.setGuidance (lender) end
						row [3]:createText (loan.currentText)
						row [4]:createText (loan.interestRateText)
						row [5]:createButton ({active = playerMoney >= loan.current}):setText (ReadText (1416318, 689305), {halign = "center"}) -- Pay loan
						row [5].handlers.onClick = function () return kNPCBankLoans.payLoan (station, lender) end
					end
				end
			end
		end
	else
		row = bankLoansTable:addRow (true, {bgColor = Helper.color.transparent})
		row [1]:setColSpan (5):createText ("--- " .. ReadText(1001, 33) .. " ---", {halign = "center"})
	end
	-- bankLoansTable:setTopRow (menu.settoprow)
	-- bankLoansTable:setSelectedRow (menu.setselectedrow)
	-- menu.settoprow = nil
	-- menu.setselectedrow = nil
end
function kNPCBankLoans.payLoan (station, lender)
	AddUITriggeredEvent ("kNPCBankLoans", "pay_loan", {station = station, lender = lender})
end
function kNPCBankLoans.onClearUIData ()
	kNPCBankLoans.ui_kNPCBankLoans_data = nil
end
function kNPCBankLoans.showOnMap (station)
	local menu = playerInfoMenu
	menu.buttonLogbookInteraction ({interaction = "showonmap", interactioncomponent = station})
end
function kNPCBankLoans.setGuidance (lender)
	local menu = playerInfoMenu
	menu.buttonLogbookInteraction ({interaction = "guidance", interactioncomponent = lender})
	kNPCBankLoans.showOnMap (lender)
end
-- end: NPC bank loans
-- start: Bridge crew
function kBridgeCrew.getTarget (_, object)
	local softtarget = ConvertStringToLuaID (tostring (C.GetSofttarget2().softtargetID))
	AddUITriggeredEvent ("kBridgeCrew", "getTarget", softtarget)
end
function kBridgeCrew.setTarget (_, object)
	local object64Bit = ConvertStringTo64Bit (object)
	C.SetSofttarget(object64Bit, "")
end
function kBridgeCrew.giveOrder (_, ship)
	local menu = mapMenu
	-- OpenMenu ("MapMenu", { 0, 0 }, nil)
	local ship64Bit = ConvertStringTo64Bit (ship)
	newFuncs.debugText ("kuertee_npc_reactions giveOrder ship: " .. tostring (ship64Bit))
	menu.addSelectedComponent (ship64Bit)
end
-- end: Bridge crew
function kNPCRumours.get_active_mission ()
	local activeMissionId = ConvertStringToLuaID (tostring (C.GetActiveMissionID ()))
	AddUITriggeredEvent ("kNPCRumours", "get_active_mission", activeMissionId)
end

init()
