local ffi = require ("ffi")
local C = ffi.C

local ModLua = {}
local origFuncs = {}
local newFuncs = {}
local transporterMenu
local interactMenu
local kTFTR = {
	isRemoveTeleportCommandFromMap = 1,
	isDestinationShipsOk = 1,
	isShowTeleportButton = 1,
}

function ModLua.init()
	transporterMenu = Helper.getMenu ("TransporterMenu")
	transporterMenu.registerCallback ("display_on_set_buttontable", kTFTR.display_on_set_buttontable)
	interactMenu = Helper.getMenu ("InteractMenu")
	origFuncs.insertLuaAction = interactMenu.insertLuaAction
	interactMenu.insertLuaAction = newFuncs.insertLuaAction
	RegisterEvent ("kTFTR.SetMapTeleportButtonAvailability", kTFTR.SetMapTeleportButtonAvailability)
	RegisterEvent ("kTFTR.SetTeleportDestinationShipsOk", kTFTR.SetTeleportDestinationShipsOk)
	RegisterEvent ("kTFTR.ShowTeleportButtonInTransporterRoom", kTFTR.ShowTeleportButtonInTransporterRoom)
	RegisterEvent ("kTFTR.HideTeleportButtonInTransporterRoom", kTFTR.HideTeleportButtonInTransporterRoom)
	RegisterEvent ("kTFTR.CloseMenu", kTFTR.CloseMenu)
end

function newFuncs.insertLuaAction (actiontype, istobedisplayed)
	if actiontype ~= "teleport" or kTFTR.isRemoveTeleportCommandFromMap ~= 1 then
		origFuncs.insertLuaAction (actiontype, istobedisplayed)
	end
end
function kTFTR.SetMapTeleportButtonAvailability (_, isRemoveTeleportCommandFromMap)
	Helper.debugText("SetMapTeleportButtonAvailability", isRemoveTeleportCommandFromMap)
	kTFTR.isRemoveTeleportCommandFromMap = isRemoveTeleportCommandFromMap
end
function kTFTR.SetTeleportDestinationShipsOk (_, isOk)
	Helper.debugText("SetTeleportDestinationShipsOk", isOk)
	kTFTR.isDestinationShipsOk = isOk
end
function kTFTR.ShowTeleportButtonInTransporterRoom ()
	Helper.debugText("ShowTeleportButtonInTransporterRoom")
	kTFTR.isShowTeleportButton = 1
end
function kTFTR.HideTeleportButtonInTransporterRoom ()
	Helper.debugText("HideTeleportButtonInTransporterRoom")
	kTFTR.isShowTeleportButton = false
end
function kTFTR.display_on_set_buttontable (buttontable)
	if kTFTR.isShowTeleportButton == 1 then
		local buttonrow = buttontable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		buttonrow[1]:setColSpan(3):createButton({ active = true, height = Helper.standardTextHeight }):setText(ReadText (1001, 7808) .. " ...", { halign = "center" })
		buttonrow[1].handlers.onClick = function () return kTFTR.onTeleportClicked () end
	end
end
function kTFTR.onTeleportClicked ()
	local menu = transporterMenu
	-- Helper.closeMenu (transporterMenu, "close")
	-- param == { 0, 0, showzone, focuscomponent [, history] [, mode, modeparam] }
	-- modes: - "orderparam_object",	param: { returnfunction, paramdata, toprow, ordercontrollable } 
	--		  - "orderparam_position",	param: { returnfunction, paramdata, toprow, ordercontrollable } 
	--		  - "selectbuildlocation",	param: { returnsection, { 0, 0, trader, buildership_or_module, object, macro } }
	--		  - "tradecontext",			param: { station, initialtradingship, iswareexchange, shadyOnly, loop, trader }
	--		  - "selectCV",				param: { buildstorage }
	--		  - "infomode",				param: { mode, ... }
	--		  - "boardingcontext",		param: { target, boardingships }
	--		  - "hire",					param: { returnsection, npc_or_context, ishiring[, npctemplate] }
	--		  - "sellships",			param: { shipyard, ships }
	--		  - "dropwarescontext",		param: { mode, entity }
	--		  - "renamecontext",		param: { component, renamefleet }
	--		  - "selectComponent",		param: { returnsection, classlist[, category][, playerowned][, customheading] }
	--		  - "crewtransfercontext",	param: { othership, ship }
	--		  - "ventureconsole",		param: { ventureplatform }
	--		  - "venturepatroninfo",	param: { ventureplatform }
	local showzone = nil
	local focuscomponent = nil
	local history = nil
	local mode = "selectComponent"
	local modeparam_returnsection = nil
	local modeparam_category = nil
	local modeparam_classList = {}
	if kTFTR.isDestinationShipsOk == 1 or kTFTR.isDestinationShipsOk == true then
		table.insert (modeparam_classList, "ship_s")
		table.insert (modeparam_classList, "ship_m")
		table.insert (modeparam_classList, "ship_l")
		table.insert (modeparam_classList, "ship_xl")
	end
	table.insert (modeparam_classList, "station")
	local modeparam_playerowned = true
	Helper.debugText("modeparam_playerowned", modeparam_playerowned)
	local modeparam_customheading = nil
	local modeparam_screenname = "kTFTR_set_destination"
	local modeparam = {
		modeparam_returnsection,
		modeparam_classList,
		modeparam_category,
		modeparam_playerowned,
		modeparam_customheading,
		modeparam_screenname
	}
	local param = {0, 0, showzone, focuscomponent, history, mode, modeparam}
	local noreturn = true
	Helper.closeMenuAndOpenNewMenu (menu, "MapMenu", param, noreturn)
end
function kTFTR.CloseMenu ()
	-- local menu = transporterMenu
	-- Helper.closeMenu (menu, "close")
	local menu = Helper.getMenu ("MapMenu")
	menu.onCloseElement ("close")
end

return ModLua
