local ffi = require("ffi")
local C = ffi.C

local ModLua = {}

-- required to remove swi vanilla maintenance
--[[ local sw_maintenance = require("extensions.starwarsmod_m1.ui.sw_maintenance") ]]

local playerInfoMenu = nil
--[[ local encyclopediaMenu = nil ]]
gajMaintenanceMenu = {}
gajMaintenanceMenu.infotable = nil
gajMaintenanceMenu.timeNextAssessmentRow = nil
gajMaintenanceMenu.timeNextAssessmentCol = nil
gajMaintenanceMenu.data = nil
gajMaintenanceMenu.props = nil

function ModLua.init()
    --[[ DebugError("gajMaintenance.init")
    DebugError("sw_maintenance: " .. tostring(sw_maintenance))
    for key, value in pairs(sw_maintenance.swiMaintenanceMenu) do
        DebugError("Key: " .. tostring(key) .. ", Value: " .. tostring(value))
    end
    
    DebugError("buttonTogglePlayerInfo_on_start: " .. tostring(sw_maintenance.swiMaintenanceMenu.buttonTogglePlayerInfo_on_start)) ]]
    playerInfoMenu = Helper.getMenu("PlayerInfoMenu")
    --[[ encyclopediaMenu = Helper.getMenu("EncyclopediaMenu")
    -- deregister vanilla
    playerInfoMenu.deregisterCallback("buttonTogglePlayerInfo_on_start", sw_maintenance.buttonTogglePlayerInfo_on_start)
    playerInfoMenu.deregisterCallback("createPlayerInfo_on_start", sw_maintenance.createPlayerInfo_on_start)
    playerInfoMenu.deregisterCallback("createInfoFrame_on_start", sw_maintenance.createInfoFrame_on_start)
    playerInfoMenu.deregisterCallback("createInfoFrame_on_info_frame_mode",
        sw_maintenance.createInfoFrame_on_info_frame_mode)
    playerInfoMenu.deregisterCallback("cleanup", sw_maintenance.cleanup)
    encyclopediaMenu.deregisterCallback("display_on_start", sw_maintenance.display_on_start)
    encyclopediaMenu.deregisterCallback("addDetailRow_known_sector_production_module_entries",
        sw_maintenance.addDetailRow_known_sector_production_module_entries)
    playerInfoMenu.deregisterCallback("cleanup", sw_maintenance.cleanup) ]]

    DebugError("gajMaintenance.registerCallbacks")
    gajMaintenanceMenu.playerId = ConvertStringTo64Bit(tostring(C.GetPlayerID()))
    playerInfoMenu.registerCallback("buttonTogglePlayerInfo_on_start",
        gajMaintenanceMenu.buttonTogglePlayerInfo_on_start)
    playerInfoMenu.registerCallback("createPlayerInfo_on_start", gajMaintenanceMenu.createPlayerInfo_on_start)
    playerInfoMenu.registerCallback("createInfoFrame_on_start", gajMaintenanceMenu.createInfoFrame_on_start)
    playerInfoMenu.registerCallback("createInfoFrame_on_info_frame_mode",
        gajMaintenanceMenu.createInfoFrame_on_info_frame_mode)
    playerInfoMenu.registerCallback("cleanup", gajMaintenanceMenu.cleanup)
    RegisterEvent("gaj.togglePlayerInfoMenuRefresh", gajMaintenanceMenu.togglePlayerInfoMenuRefresh)
end
function gajMaintenanceMenu.addToLeftBar(config)
    DebugError("gajMaintenance.addToLeftBar")
    local isgajMaintenanceMenuExists
    for _, leftBarEntry in ipairs(config.leftBar) do
        if leftBarEntry.mode == "gajMaintenance" then
            isgajMaintenanceMenuExists = true
        end
    end
    if not isgajMaintenanceMenuExists then
        local gajMaintenanceBtn = {
            name = "Emergent Maintenance",
            icon = "shipbuildst_repair",
            mode = "gajMaintenance",
            active = true,
            helpOverlayID = "playerinfo_sidebar_gajMaintenance",
            helpOverlayText = "Emergent Maintenance"
        }
        for i, leftBarEntry in ipairs(config.leftBar) do
            if leftBarEntry.mode == "accounts" then
                table.insert(config.leftBar, i + 1, gajMaintenanceBtn)
                break
            end
        end
    end
    playerInfoMenu.config = config
end
function gajMaintenanceMenu.buttonTogglePlayerInfo_on_start(mode, config)
    DebugError("gajMaintenance.buttonTogglePlayerInfo_on_start")
    gajMaintenanceMenu.addToLeftBar(config)
end
function gajMaintenanceMenu.createPlayerInfo_on_start(config)
    DebugError("gajMaintenance.createPlayerInfo_on_start")
    gajMaintenanceMenu.addToLeftBar(config)
end
function gajMaintenanceMenu.createInfoFrame_on_start()
    DebugError("gajMaintenance.createInfoFrame_on_start")
    gajMaintenanceMenu.data = GetNPCBlackboard(gajMaintenanceMenu.playerId, "$gajMaintenanceData")
    gajMaintenanceMenu.props = GetNPCBlackboard(gajMaintenanceMenu.playerId, "$gajMaintenanceProps")
end
function gajMaintenanceMenu.cleanup()
    DebugError("gajMaintenance.cleanup")
    gajMaintenanceMenu.infotable = nil
    gajMaintenanceMenu.timeNextAssessmentRow = nil
    gajMaintenanceMenu.timeNextAssessmentCol = nil
    gajMaintenanceMenu.data = nil
    gajMaintenanceMenu.props = nil
end
function gajMaintenanceMenu.createInfoFrame_on_info_frame_mode(infoFrame, tableProperties)
    DebugError("gajMaintenance.createInfoFrame_on_info_frame_mode")
    local menu = playerInfoMenu
    local config = menu.config
    local row
    if menu.mode == "gajMaintenance" then
        DebugError("gajMaintenance.menu.mode")
        local tableCols = 13
        tableProperties.width = tableProperties.width * 5 / 4
        gajMaintenanceMenu.infotable = infoFrame:addTable(tableCols, {
            tabOrder = 1,
            borderEnabled = true,
            width = tableProperties.width,
            x = tableProperties.x,
            y = tableProperties.y
        })
        if menu.setdefaulttable then
            gajMaintenanceMenu.infotable.properties.defaultInteractiveObject = true
            menu.setdefaulttable = nil
        end
        gajMaintenanceMenu.infotable:setDefaultCellProperties("text", {
            minRowHeight = config.rowHeight,
            fontsize = Helper.standardFontSize
        })
        gajMaintenanceMenu.infotable:setDefaultCellProperties("button", {
            height = config.rowHeight
        })
        -- gajMaintenanceMenu.infotable:setColWidth (1, Helper.scaleY (config.rowHeight), false)
        -- gajMaintenanceMenu.infotable:setColWidth (tableCols, Helper.scaleY (config.rowHeight), false)
        row = gajMaintenanceMenu.infotable:addRow(nil, {
            bgColor = Helper.defaultTitleBackgroundColor,
            borderBelow = false
        })
        row[1]:setColSpan(tableCols):createText("Emergent Maintenance", Helper.titleTextProperties)
        if gajMaintenanceMenu.data then
            DebugError("gajMaintenance.menu.data")
            row = gajMaintenanceMenu.infotable:addRow(true, {
                bgColor = Helper.color.transparent,
                borderBelow = false
            })
            gajMaintenanceMenu.timeNextAssessmentRow = 2
            row[1]:createText("Next Cycle")
            DebugError("timeNextAssessment", gajMaintenanceMenu.data.timeNextAssessment)
            local timeLeft = gajMaintenanceMenu.data.timeNextAssessment - C.GetCurrentGameTime()
            if timeLeft < 60 then
                row[2]:createText(tostring(math.floor(timeLeft * 100) / 100) .. ReadText(1001, 100)) -- seconds
            else
                row[2]:createText(tostring(math.floor(timeLeft / 60.0 * 100) / 100) .. ReadText(1001, 103)) -- minutes
            end
            gajMaintenanceMenu.timeNextAssessmentCol = 2
            if next(gajMaintenanceMenu.data.supplyships) then
                DebugError("gajMaintenance.menu.data.supplyships")
                row = gajMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("")

                row = gajMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.defaultTitleBackgroundColor,
                    borderBelow = false
                })
                row[1]:setColSpan(tableCols):createText("Supply Ships", Helper.titleTextProperties)
                row = gajMaintenanceMenu.infotable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("Size", Helper.subHeaderTextProperties)
                row[2]:createText("Name", Helper.subHeaderTextProperties)
                row[3]:createText("Sector", Helper.subHeaderTextProperties)
                row[4]:createText("Supplies", Helper.subHeaderTextProperties)
                row[5]:createText("Repair Complexity", Helper.subHeaderTextProperties)
                row[6]:createText("Total Usage", Helper.subHeaderTextProperties)
                row[7]:createText("Crew Usage", Helper.subHeaderTextProperties)
                row[8]:createText("Energy Usage", Helper.subHeaderTextProperties)
                row[9]:createText("Wear and Tear", Helper.subHeaderTextProperties)
                row[10]:createText("Cargo Supplies", Helper.subHeaderTextProperties)
                row[11]:createText("Remove Supply Ship", Helper.subHeaderTextProperties)
                for shipid, ship in pairs(gajMaintenanceMenu.data.supplyships) do
                    row = gajMaintenanceMenu.infotable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    row[1]:createText(ship.Size)
                    row[2]:createText(ship.Name)
                    row[3]:createText(ship.Sector)
                    row[4]:createButton(gajMaintenanceMenu.props.SetDesiredUnits):setText(ship.ShipUnits + " / " +
                                                                                              ship.DesiredUnits)
                    row[4].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetDesiredUnits", shipid)
                    end
                    row[5]:createText(ship.RepairComplexity)
                    row[6]:createText(ship.TotalUsage)
                    row[7]:createText(ship.CrewUsage)
                    row[8]:createText(ship.EnergyUsage)
                    row[9]:createText(ship.WearTear)
                    row[10]:createButton(gajMaintenanceMenu.props.SetDesiredSupplies):setText(
                        ship.ShipSupplies + " / " + ship.DesiredSupplies)
                    row[10].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetDesiredSupplies", shipid)
                    end
                    row[11]:createButton(gajMaintenanceMenu.props.RemoveSupplyShip):setText("Remove")
                    row[11].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "RemoveSupplyShip", shipid)
                    end
                end
            end
            --	-- dedicated resupply ship
            -- 	size | name | sector | shields | hull | crew | cargo | personal supplies | expected supply usage | crew supply usage | ship supply usage | supply ship | change supply ship button | make range button
            if next(gajMaintenanceMenu.data.dedicatedresupplyships) then
                DebugError("gajMaintenance.menu.data.dedicatedresupplyships")
                row = gajMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("")

                row = gajMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.defaultTitleBackgroundColor,
                    borderBelow = false
                })
                row[1]:setColSpan(tableCols):createText("Dedicated Resupply Ships", Helper.titleTextProperties)
                row = gajMaintenanceMenu.infotable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("Size", Helper.subHeaderTextProperties)
                row[2]:createText("Name", Helper.subHeaderTextProperties)
                row[3]:createText("Sector", Helper.subHeaderTextProperties)
                row[4]:createText("Supplies", Helper.subHeaderTextProperties)
                row[5]:createText("Repair Complexity", Helper.subHeaderTextProperties)
                row[6]:createText("Total Usage", Helper.subHeaderTextProperties)
                row[7]:createText("Crew Usage", Helper.subHeaderTextProperties)
                row[8]:createText("Energy Usage", Helper.subHeaderTextProperties)
                row[9]:createText("Wear and Tear", Helper.subHeaderTextProperties)
                row[10]:createText("Cargo Supplies", Helper.subHeaderTextProperties)
                row[11]:createText("Supply Ship", Helper.subHeaderTextProperties)
                row[12]:createText("Make Range Resupply", Helper.subHeaderTextProperties)
                for shipid, ship in pairs(gajMaintenanceMenu.data.dedicatedresupplyships) do
                    row = gajMaintenanceMenu.infotable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    row[1]:createText(ship.Size)
                    row[2]:createText(ship.Name)
                    row[3]:createText(ship.Sector)
                    row[4]:createButton(gajMaintenanceMenu.props.SetDesiredUnits):setText(ship.ShipUnits + " / " +
                                                                                              ship.DesiredUnits)
                    row[4].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetDesiredUnits", shipid)
                    end
                    row[5]:createText(ship.RepairComplexity)
                    row[6]:createText(ship.TotalUsage)
                    row[7]:createText(ship.CrewUsage)
                    row[8]:createText(ship.EnergyUsage)
                    row[9]:createText(ship.WearTear)
                    row[10]:createText(ship.ShipSupplies)
                    row[11]:createButton(gajMaintenanceMenu.props.ChangeSupplyShip):setText(ship.SupplyShip)
                    row[11].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "MakeDedicated", shipid)
                    end
                    row[12]:createButton(gajMaintenanceMenu.props.MakeResupplyShip):setText("Switch")
                    row[12].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "MakeResupplyShip", shipid)
                    end
                end
            end
            --  -- resupply ships
            --	size | name | sector | shields | hull | crew | cargo | personal supplies | expected supply usage | crew supply usage | ship supply usage | home sector | range | set home sector button | set range button | make dedicated button
            if next(gajMaintenanceMenu.data.resupplyships) then
                DebugError("gajMaintenance.menu.data.resupplyships")
                row = gajMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("")

                row = gajMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.defaultTitleBackgroundColor,
                    borderBelow = false
                })
                row[1]:setColSpan(tableCols):createText("Resupply Ships", Helper.titleTextProperties)
                row = gajMaintenanceMenu.infotable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("Size", Helper.subHeaderTextProperties)
                row[2]:createText("Name", Helper.subHeaderTextProperties)
                row[3]:createText("Sector", Helper.subHeaderTextProperties)
                row[4]:createText("Supplies", Helper.subHeaderTextProperties)
                row[5]:createText("Repair Complexity", Helper.subHeaderTextProperties)
                row[6]:createText("Total Usage", Helper.subHeaderTextProperties)
                row[7]:createText("Crew Usage", Helper.subHeaderTextProperties)
                row[8]:createText("Energy Usage", Helper.subHeaderTextProperties)
                row[9]:createText("Wear and Tear", Helper.subHeaderTextProperties)
                row[10]:createText("Cargo Supplies", Helper.subHeaderTextProperties)
                -- home sector | range | set home sector button | set range button | make dedicated button
                row[11]:createText("Home Sector", Helper.subHeaderTextProperties)
                row[12]:createText("Gate Range", Helper.subHeaderTextProperties)
                row[13]:createText("Make Dedicated", Helper.subHeaderTextProperties)
                for _, ship in ipairs(gajMaintenanceMenu.data.resupplyships) do
                    row = gajMaintenanceMenu.infotable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    row[1]:createText(ship.Size)
                    row[2]:createText(ship.Name)
                    row[3]:createText(ship.Sector)
                    row[4]:createButton(gajMaintenanceMenu.props.SetDesiredUnits):setText(ship.ShipUnits + " / " +
                                                                                              ship.DesiredUnits)
                    row[4].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetDesiredUnits", shipid)
                    end
                    row[5]:createText(ship.RepairComplexity)
                    row[6]:createText(ship.TotalUsage)
                    row[7]:createText(ship.CrewUsage)
                    row[8]:createText(ship.EnergyUsage)
                    row[9]:createText(ship.WearTear)
                    row[10]:createText(ship.ShipSupplies)
                    row[11]:createButton(gajMaintenanceMenu.props.SetHomeSector):setText(ship.HomeSector)
                    row[11].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetHomeSector", ship)
                    end
                    row[12]:createButton(gajMaintenanceMenu.props.SetRange):setText(ship.GateRange)
                    row[12].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetRange", ship)
                    end
                    row[13]:createButton(gajMaintenanceMenu.props.MakeDedicated):setText("Switch")
                    row[13].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "MakeDedicated", ship)
                    end
                end
            end
            --  -- ships
            --	size | name | sector | shields | hull | crew | cargo | personal supplies | expected supply usage | crew supply usage | ship supply usage | receive delivery checkbox | resupply self checkbox | make supply ship button
            if next(gajMaintenanceMenu.data.ships) then
                DebugError("gajMaintenance.menu.data.ships")
                row = gajMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("")

                row = gajMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.defaultTitleBackgroundColor,
                    borderBelow = false
                })
                row[1]:setColSpan(tableCols):createText("Ships", Helper.titleTextProperties)
                row = gajMaintenanceMenu.infotable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("Size", Helper.subHeaderTextProperties)
                row[2]:createText("Name", Helper.subHeaderTextProperties)
                row[3]:createText("Sector", Helper.subHeaderTextProperties)
                row[4]:createText("Supplies", Helper.subHeaderTextProperties)
                row[5]:createText("Repair Complexity", Helper.subHeaderTextProperties)
                row[6]:createText("Total Usage", Helper.subHeaderTextProperties)
                row[7]:createText("Crew Usage", Helper.subHeaderTextProperties)
                row[8]:createText("Energy Usage", Helper.subHeaderTextProperties)
                row[9]:createText("Wear and Tear", Helper.subHeaderTextProperties)
                -- receive delivery checkbox | make supply ship button
                row[10]:createText("Receive Deliveries", Helper.subHeaderTextProperties)
                row[11]:createText("Make Supply Ship", Helper.subHeaderTextProperties)
                for _, ship in ipairs(gajMaintenanceMenu.data.resupplyships) do
                    row = gajMaintenanceMenu.infotable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    row[1]:createText(ship.Size)
                    row[2]:createText(ship.Name)
                    row[3]:createText(ship.Sector)
                    row[4]:createButton(gajMaintenanceMenu.props.SetDesiredUnits):setText(ship.ShipUnits + " / " +
                                                                                              ship.DesiredUnits)
                    row[4].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetDesiredUnits", shipid)
                    end
                    row[5]:createText(ship.RepairComplexity)
                    row[6]:createText(ship.TotalUsage)
                    row[7]:createText(ship.CrewUsage)
                    row[8]:createText(ship.EnergyUsage)
                    row[9]:createText(ship.WearTear)
                    if ship.ReceiveDeliveries then
                        row[10]:createCheckBox(ship.ReceiveDeliveries.checked,
                            gajMaintenanceMenu.props.ReceiveDeliveries)
                        row[10].handlers.onClick = function(_, checked)
                            AddUITriggeredEvent("GAJ_Maint", "ReceiveDeliveries", {checked, ship})
                        end
                        row[11]:createButton(gajMaintenanceMenu.props.MakeSupplyShip):setText("Set")
                        row[11].handlers.onClick = function()
                            AddUITriggeredEvent("GAJ_Maint", "MakeSupplyShip", ship)
                        end
                    end
                end
            end
        end
        gajMaintenanceMenu.infotable:setTopRow(menu.settoprow)
        gajMaintenanceMenu.infotable:setSelectedRow(menu.setselectedrow)
        menu.settoprow = nil
        menu.setselectedrow = nil
    end
end
function gajMaintenanceMenu.togglePlayerInfoMenuRefresh()
    DebugError("gajMaintenance.togglePlayerInfoMenuRefresh")
    local menu = playerInfoMenu
    if menu.mode == "gajMaintenance" then
        gajMaintenanceMenu.data = GetNPCBlackboard(gajMaintenanceMenu.playerId, "$gajMaintenanceData")
        if gajMaintenanceMenu.data then
            if gajMaintenanceMenu.timeNextAssessmentRow then
                local timeLeft = gajMaintenanceMenu.data.timeNextAssessment - C.GetCurrentGameTime()
                if timeLeft < 60 then
                    timeLeft = tostring(math.floor(timeLeft * 100) / 100) .. ReadText(1001, 100) -- seconds
                else
                    timeLeft = tostring(math.floor(timeLeft / 60 * 100) / 100) .. ReadText(1001, 103) -- minutes
                end
                DebugError("gajMaintenanceMenu.infotable.id", gajMaintenanceMenu.infotable.id)
                DebugError("gajMaintenanceMenu.timeNextAssessmentRow", gajMaintenanceMenu.timeNextAssessmentRow)
                Helper.updateCellText(gajMaintenanceMenu.infotable.id, gajMaintenanceMenu.timeNextAssessmentRow,
                    gajMaintenanceMenu.timeNextAssessmentCol, timeLeft)
            else
                menu.refresh = getElapsedTime()
            end
        end
    end
end
return ModLua
