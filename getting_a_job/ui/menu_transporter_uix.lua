-- merged transport from transporter room and locked high security rooms
local ffi = require("ffi")
local C = ffi.C

local ModLua = {}

local transporterMenu
local origFuncs = {}
local newFuncs = {}
local transporterMenu
local interactMenu
local kTFTR = {
    isRemoveTeleportCommandFromMap = 1,
    isDestinationShipsOk = 1,
    isShowTeleportButton = 1
}
local kHSRAL = {}
kHSRAL.securedRoomsData = {}
kHSRAL.unlockedRoomsData = {}

function ModLua.init()
    transporterMenu = Helper.getMenu("TransporterMenu")
    transporterMenu.registerCallback("display_on_set_buttontable", kTFTR.display_on_set_buttontable)
    interactMenu = Helper.getMenu("InteractMenu")
    origFuncs.insertLuaAction = interactMenu.insertLuaAction
    interactMenu.insertLuaAction = newFuncs.insertLuaAction
    RegisterEvent("kTFTR.SetMapTeleportButtonAvailability", kTFTR.SetMapTeleportButtonAvailability)
    RegisterEvent("kTFTR.SetTeleportDestinationShipsOk", kTFTR.SetTeleportDestinationShipsOk)
    RegisterEvent("kTFTR.ShowTeleportButtonInTransporterRoom", kTFTR.ShowTeleportButtonInTransporterRoom)
    RegisterEvent("kTFTR.HideTeleportButtonInTransporterRoom", kTFTR.HideTeleportButtonInTransporterRoom)
    RegisterEvent("kTFTR.CloseMenu", kTFTR.CloseMenu)
    origFuncs.buttonGoTo = transporterMenu.buttonGoTo
    transporterMenu.buttonGoTo = kHSRAL.buttonGoTo
    origFuncs.display = transporterMenu.display
    transporterMenu.display = kHSRAL.display
    transporterMenu.registerCallback("addEntry_on_set_room_name", kHSRAL.addEntry_on_set_room_name)
    transporterMenu.registerCallback("display_on_set_room_active", kHSRAL.display_on_set_room_active)
end

function newFuncs.insertLuaAction(actiontype, istobedisplayed)
    if actiontype ~= "teleport" or kTFTR.isRemoveTeleportCommandFromMap ~= 1 then
        origFuncs.insertLuaAction(actiontype, istobedisplayed)
    end
end
function kTFTR.SetMapTeleportButtonAvailability(_, isRemoveTeleportCommandFromMap)
    Helper.debugText("SetMapTeleportButtonAvailability", isRemoveTeleportCommandFromMap)
    kTFTR.isRemoveTeleportCommandFromMap = isRemoveTeleportCommandFromMap
end
function kTFTR.SetTeleportDestinationShipsOk(_, isOk)
    Helper.debugText("SetTeleportDestinationShipsOk", isOk)
    kTFTR.isDestinationShipsOk = isOk
end
function kTFTR.ShowTeleportButtonInTransporterRoom()
    Helper.debugText("ShowTeleportButtonInTransporterRoom")
    kTFTR.isShowTeleportButton = 1
end
function kTFTR.HideTeleportButtonInTransporterRoom()
    Helper.debugText("HideTeleportButtonInTransporterRoom")
    kTFTR.isShowTeleportButton = false
end
function kTFTR.display_on_set_buttontable(buttontable)
    if kTFTR.isShowTeleportButton == 1 then
        local buttonrow = buttontable:addRow(true, {
            fixed = true,
            bgColor = Helper.color.transparent
        })
        buttonrow[1]:setColSpan(3):createButton({
            active = true,
            height = Helper.standardTextHeight
        }):setText(ReadText(1001, 7808) .. " ...", {
            halign = "center"
        })
        buttonrow[1].handlers.onClick = function()
            return kTFTR.onTeleportClicked()
        end
    end
end
function kTFTR.onTeleportClicked()
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
        table.insert(modeparam_classList, "ship_s")
        table.insert(modeparam_classList, "ship_m")
        table.insert(modeparam_classList, "ship_l")
        table.insert(modeparam_classList, "ship_xl")
    end
    table.insert(modeparam_classList, "station")
    local modeparam_playerowned = true
    Helper.debugText("modeparam_playerowned", modeparam_playerowned)
    local modeparam_customheading = nil
    local modeparam_screenname = "kTFTR_set_destination"
    local modeparam = {modeparam_returnsection, modeparam_classList, modeparam_category, modeparam_playerowned,
                       modeparam_customheading, modeparam_screenname}
    local param = {0, 0, showzone, focuscomponent, history, mode, modeparam}
    local noreturn = true
    Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", param, noreturn)
end
function kTFTR.CloseMenu()
    -- local menu = transporterMenu
    -- Helper.closeMenu (menu, "close")
    local menu = Helper.getMenu("MapMenu")
    menu.onCloseElement("close")
end

function kHSRAL.buttonGoTo()
    local menu = transporterMenu
    local isCancel = false
    if not menu.currentselection.hassubentries then
        if (menu.transportercomponent ~= menu.currentselection.target.component) or
            (menu.transporterconnection ~= menu.currentselection.target.connection) then
            local parent = ConvertIDTo64Bit(GetComponentData(ConvertStringTo64Bit(
                tostring(menu.currentselection.target.component)), "parent"))
            local isLocked = kHSRAL.securedRoomsData[tostring(parent)]
            local isUnlocked = kHSRAL.unlockedRoomsData[tostring(parent)]
            if isLocked and not isUnlocked then
                isCancel = true
            end
        end
    end
    if not isCancel then
        origFuncs.buttonGoTo()
    end
    return isCancel
end
function kHSRAL.addEntry_on_set_room_name(name, target)
    local parent = ConvertIDTo64Bit(GetComponentData(ConvertStringTo64Bit(tostring(target.directtarget.component)),
        "parent"))
    local isLocked = kHSRAL.securedRoomsData[tostring(parent)]
    local isUnlocked = kHSRAL.unlockedRoomsData[tostring(parent)]
    -- DebugError ("kHSRAL.display kHSRAL.securedRoomsData isLocked " .. tostring (isLocked))
    -- DebugError ("kHSRAL.display kHSRAL.securedRoomsData isUnlocked " .. tostring (isUnlocked))
    if isUnlocked then
        name = name .. ReadText(81918112, 2)
    elseif isLocked then
        name = name .. ReadText(81918112, 1)
    end
    return {
        name = name
    }
end
function kHSRAL.display()
    -- DebugError ("kuertee_hsral.kHSRAL.display")
    kHSRAL.securedRoomsData = {}
    local playerId = ConvertStringTo64Bit(tostring(C.GetPlayerID()))
    -- local dataFromMD = GetNPCBlackboard (ConvertStringTo64Bit (tostring (C.GetPlayerID ())), "$securedRoomsData")
    -- DebugError ("kuertee_hsral.kHSRAL.display securedRoomsData playerId " .. tostring (playerId))
    local dataFromMD = GetNPCBlackboard(playerId, "$securedRoomsData")
    -- DebugError ("kuertee_hsral.kHSRAL.display securedRoomsData dataFromMD " .. tostring (dataFromMD))
    if dataFromMD then
        for roomId, dynamicInteriorId in pairs(dataFromMD) do
            local room64Bit = ConvertStringTo64Bit(tostring(roomId))
            local dynamicInterior64Bit = ConvertStringTo64Bit(tostring(dynamicInteriorId))
            -- DebugError ("kuertee_hsral.kHSRAL.display room64Bit " .. tostring (room64Bit))
            if not kHSRAL.securedRoomsData[tostring(dynamicInterior64Bit)] then
                kHSRAL.securedRoomsData[tostring(dynamicInterior64Bit)] = room64Bit
                -- DebugError ("kuertee_hsral.kHSRAL.display kHSRAL.securedRoomsData [" .. tostring (dynamicInterior64Bit) .. "] " .. tostring (kHSRAL.securedRoomsData [tostring (dynamicInterior64Bit)]))
            end
        end
    end
    kHSRAL.unlockedRoomsData = {}
    -- local dataFromMD = GetNPCBlackboard (ConvertStringTo64Bit (tostring (C.GetPlayerID ())), "$unlockedRoomsData")
    local dataFromMD = GetNPCBlackboard(playerId, "$unlockedRoomsData")
    -- DebugError ("kuertee_hsral.kHSRAL.display unlockedRoomsData dataFromMD " .. tostring (dataFromMD))
    if dataFromMD then
        for roomId, dynamicInteriorId in pairs(dataFromMD) do
            local room64Bit = ConvertStringTo64Bit(tostring(roomId))
            local dynamicInterior64Bit = ConvertStringTo64Bit(tostring(dynamicInteriorId))
            -- DebugError ("kuertee_hsral.kHSRAL.display room64Bit " .. tostring (room64Bit))
            if not kHSRAL.unlockedRoomsData[tostring(dynamicInterior64Bit)] then
                kHSRAL.unlockedRoomsData[tostring(dynamicInterior64Bit)] = room64Bit
                -- DebugError ("kuertee_hsral.kHSRAL.display kHSRAL.unlockedRoomsData [" .. tostring (dynamicInterior64Bit) .. "] " .. tostring (kHSRAL.unlockedRoomsData [tostring (dynamicInterior64Bit)]))
            end
        end
    end
    -- DebugError ("kuertee_hsral.kHSRAL.display securedRoomsData and unlockedRoomsData done")
    origFuncs.display()
end
function kHSRAL.display_on_set_room_active(isActive)
    local menu = transporterMenu
    local parent = ConvertIDTo64Bit(GetComponentData(ConvertStringTo64Bit(
        tostring(menu.currentselection.target.component)), "parent"))
    if kHSRAL.securedRoomsData[tostring(parent)] and not kHSRAL.unlockedRoomsData[tostring(parent)] then
        isActive = false
    end
    return {
        active = isActive
    }
end

return ModLua
