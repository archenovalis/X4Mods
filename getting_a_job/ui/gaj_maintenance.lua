local ffi = require("ffi")
local C = ffi.C

local ModLua = {}

-- required to remove swi vanilla maintenance
--[[ local sw_maintenance = require("extensions.starwarsmod_m1.ui.sw_maintenance") ]]

local playerInfoMenu = nil
--[[ local encyclopediaMenu = nil ]]
GAJMaintenanceMenu = {}
GAJMaintenanceMenu.infotable = nil
GAJMaintenanceMenu.timeNextAssessmentRow = nil
GAJMaintenanceMenu.timeNextAssessmentCol = nil
GAJMaintenanceMenu.data = nil
GAJMaintenanceMenu.props = nil
GAJMaintenanceMenu.empireData = nil

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
    GAJMaintenanceMenu.playerId = ConvertStringTo64Bit(tostring(C.GetPlayerID()))
    playerInfoMenu.registerCallback("buttonTogglePlayerInfo_on_start",
        GAJMaintenanceMenu.buttonTogglePlayerInfo_on_start)
    playerInfoMenu.registerCallback("createPlayerInfo_on_start", GAJMaintenanceMenu.createPlayerInfo_on_start)
    playerInfoMenu.registerCallback("createInfoFrame_on_start", GAJMaintenanceMenu.createInfoFrame_on_start)
    playerInfoMenu.registerCallback("createInfoFrame_on_info_frame_mode",
        GAJMaintenanceMenu.createInfoFrame_on_info_frame_mode)
    playerInfoMenu.registerCallback("cleanup", GAJMaintenanceMenu.cleanup)
    RegisterEvent("gaj_maint.togglePlayerInfoMenuRefresh", GAJMaintenanceMenu.togglePlayerInfoMenuRefresh)
    RegisterEvent("gaj_maint.chooseSector", GAJMaintenanceMenu.chooseSector)
end

function GAJMaintenanceMenu.addToLeftBar(config)
    DebugError("gajMaintenance.addToLeftBar")
    local isGAJMaintenanceMenuExists
    for _, leftBarEntry in ipairs(config.leftBar) do
        if leftBarEntry.mode == "gajMaintenance" then
            isGAJMaintenanceMenuExists = true
        end
    end
    if not isGAJMaintenanceMenuExists then
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

function GAJMaintenanceMenu.buttonTogglePlayerInfo_on_start(mode, config)
    DebugError("gajMaintenance.buttonTogglePlayerInfo_on_start")
    GAJMaintenanceMenu.addToLeftBar(config)
end

function GAJMaintenanceMenu.createPlayerInfo_on_start(config)
    DebugError("gajMaintenance.createPlayerInfo_on_start")
    GAJMaintenanceMenu.addToLeftBar(config)
end

function GAJMaintenanceMenu.createInfoFrame_on_start()
    DebugError("gajMaintenance.createInfoFrame_on_start")
    GAJMaintenanceMenu.data = GetNPCBlackboard(GAJMaintenanceMenu.playerId, "$gajMaintenanceData")
    GAJMaintenanceMenu.props = GetNPCBlackboard(GAJMaintenanceMenu.playerId, "$gajMaintenanceProps")
    GAJMaintenanceMenu.empireData = GetNPCBlackboard(GAJMaintenanceMenu.playerId, "$gajMaintenanceEmpireData")
end

function GAJMaintenanceMenu.cleanup()
    DebugError("gajMaintenance.cleanup")
    GAJMaintenanceMenu.infotable = nil
    GAJMaintenanceMenu.timeNextAssessmentRow = nil
    GAJMaintenanceMenu.timeNextAssessmentCol = nil
    GAJMaintenanceMenu.data = nil
    GAJMaintenanceMenu.props = nil
    GAJMaintenanceMenu.empireData = nil
end

function GAJMaintenanceMenu.createInfoFrame_on_info_frame_mode(infoFrame, tableProperties)
    DebugError("gajMaintenance.createInfoFrame_on_info_frame_mode")
    local menu = playerInfoMenu
    local config = menu.config
    local row
    if menu.mode == "gajMaintenance" then
        DebugError("gajMaintenance.menu.mode")
        local tableCols = 13
        tableProperties.width = tableProperties.width * 5 / 4
        GAJMaintenanceMenu.infotable = infoFrame:addTable(tableCols, {
            tabOrder = 1,
            borderEnabled = true,
            width = tableProperties.width,
            x = tableProperties.x,
            y = tableProperties.y
        })
        if menu.setdefaulttable then
            GAJMaintenanceMenu.infotable.properties.defaultInteractiveObject = true
            menu.setdefaulttable = nil
        end
        GAJMaintenanceMenu.infotable:setDefaultCellProperties("text", {
            minRowHeight = config.rowHeight,
            fontsize = Helper.standardFontSize
        })
        GAJMaintenanceMenu.infotable:setDefaultCellProperties("button", {
            height = config.rowHeight
        })
        -- GAJMaintenanceMenu.infotable:setColWidth (1, Helper.scaleY (config.rowHeight), false)
        -- GAJMaintenanceMenu.infotable:setColWidth (tableCols, Helper.scaleY (config.rowHeight), false)
        row = GAJMaintenanceMenu.infotable:addRow(nil, {
            bgColor = Helper.defaultTitleBackgroundColor,
            borderBelow = false
        })
        row[1]:setColSpan(tableCols):createText("Emergent Maintenance", Helper.titleTextProperties)
        if GAJMaintenanceMenu.data then
            DebugError("gajMaintenance.menu.data")
            row = GAJMaintenanceMenu.infotable:addRow(true, {
                bgColor = Helper.color.transparent,
                borderBelow = false
            })
            GAJMaintenanceMenu.timeNextAssessmentRow = 2
            row[1]:createText("Next Cycle")
            DebugError("timeNextAssessment", GAJMaintenanceMenu.data.timeNextAssessment)
            local timeLeft = GAJMaintenanceMenu.data.timeNextAssessment - C.GetCurrentGameTime()
            if timeLeft < 60 then
                row[2]:createText(tostring(math.floor(timeLeft * 100) / 100) .. ReadText(1001, 100))        -- seconds
            else
                row[2]:createText(tostring(math.floor(timeLeft / 60.0 * 100) / 100) .. ReadText(1001, 103)) -- minutes
            end
            GAJMaintenanceMenu.timeNextAssessmentCol = 2


            if next(GAJMaintenanceMenu.empireData.LastCycle) then
                row = GAJMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.defaultTitleBackgroundColor,
                    borderBelow = false
                })
                row[1]:setColSpan(tableCols):createText("Last Cycle Stats:", Helper.titleTextProperties)
                row = GAJMaintenanceMenu.infotable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
            end
            if next(GAJMaintenanceMenu.empireData.Current) then
                row = GAJMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.defaultTitleBackgroundColor,
                    borderBelow = false
                })
                row[1]:setColSpan(tableCols):createText("Current Stats:", Helper.titleTextProperties)
                row = GAJMaintenanceMenu.infotable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
            end
            --  create section showing:
            --    last cycle (5 rows)
            --    next cycle (5 rows)
            --
            --    crew stats: (5 columns)
            --      number Pilots
            --      number Marines
            --      number Service
            --      total salary
            --      total crew supplies needed
            --
            --    ship stats (7 columns)
            --      number of supply ships
            --      number of dedicated resupply ships
            --      number of resupply ships
            --      number of ships with low supplies (button to set cycle remaining)
            --      total wear and tear
            --      total energy
            --      total supplies needed

            if next(GAJMaintenanceMenu.data.supplyships) then
                DebugError("gajMaintenance.menu.data.supplyships")
                row = GAJMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("")

                row = GAJMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.defaultTitleBackgroundColor,
                    borderBelow = false
                })
                row[1]:setColSpan(tableCols):createText("Supply Ships", Helper.titleTextProperties)
                row = GAJMaintenanceMenu.infotable:addRow(true, {
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
                for shipid, ship in pairs(GAJMaintenanceMenu.data.supplyships) do
                    row = GAJMaintenanceMenu.infotable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    row[1]:createText(ship.Size)
                    row[2]:createText(ship.Name)
                    row[3]:createText(ship.Sector)
                    row[4]:createButton(GAJMaintenanceMenu.props.SetDesiredUnits):setText(ship.ShipUnits + " / " +
                        ship.DesiredUnits)
                    row[4].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetDesiredUnits", shipid)
                    end
                    row[5]:createText(ship.RepairComplexity)
                    row[6]:createText(ship.TotalUsage)
                    row[7]:createText(ship.CrewUsage)
                    row[8]:createText(ship.EnergyUsage)
                    row[9]:createText(ship.WearTear)
                    row[10]:createButton(GAJMaintenanceMenu.props.SetDesiredSupplies):setText(
                        ship.ShipSupplies + " / " + ship.DesiredSupplies)
                    row[10].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetDesiredSupplies", shipid)
                    end
                    row[11]:createButton(GAJMaintenanceMenu.props.RemoveSupplyShip):setText("Remove")
                    row[11].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "RemoveSupplyShip", shipid)
                    end
                end
            end
            --	-- dedicated resupply ship
            -- 	size | name | sector | shields | hull | crew | cargo | personal supplies | expected supply usage | crew supply usage | ship supply usage | supply ship | change supply ship button | make range button
            if next(GAJMaintenanceMenu.data.dedicatedresupplyships) then
                DebugError("gajMaintenance.menu.data.dedicatedresupplyships")
                row = GAJMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("")

                row = GAJMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.defaultTitleBackgroundColor,
                    borderBelow = false
                })
                row[1]:setColSpan(tableCols):createText("Dedicated Resupply Ships", Helper.titleTextProperties)
                row = GAJMaintenanceMenu.infotable:addRow(true, {
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
                for shipid, ship in pairs(GAJMaintenanceMenu.data.dedicatedresupplyships) do
                    row = GAJMaintenanceMenu.infotable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    row[1]:createText(ship.Size)
                    row[2]:createText(ship.Name)
                    row[3]:createText(ship.Sector)
                    row[4]:createButton(GAJMaintenanceMenu.props.SetDesiredUnits):setText(ship.ShipUnits + " / " +
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
                    row[11]:createButton(GAJMaintenanceMenu.props.AssignSupplyShip):setText(ship.SupplyShip)
                    row[11].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "AssignSupplyShip", shipid)
                    end
                    row[12]:createButton(GAJMaintenanceMenu.props.MakeResupplyShip):setText("Switch")
                    row[12].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "MakeResupplyShip", shipid)
                    end
                end
            end
            --  -- resupply ships
            --	size | name | sector | shields | hull | crew | cargo | personal supplies | expected supply usage | crew supply usage | ship supply usage | home sector | range | set home sector button | set range button | make dedicated button
            if next(GAJMaintenanceMenu.data.resupplyships) then
                DebugError("gajMaintenance.menu.data.resupplyships")
                row = GAJMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("")

                row = GAJMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.defaultTitleBackgroundColor,
                    borderBelow = false
                })
                row[1]:setColSpan(tableCols):createText("Resupply Ships", Helper.titleTextProperties)
                row = GAJMaintenanceMenu.infotable:addRow(true, {
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
                for shipid, ship in pairs(GAJMaintenanceMenu.data.resupplyships) do
                    row = GAJMaintenanceMenu.infotable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    row[1]:createText(ship.Size)
                    row[2]:createText(ship.Name)
                    row[3]:createText(ship.Sector)
                    row[4]:createButton(GAJMaintenanceMenu.props.SetDesiredUnits):setText(ship.ShipUnits + " / " +
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
                    row[11]:createButton(GAJMaintenanceMenu.props.SetHomeSector):setText(ship.HomeSector)
                    row[11].handlers.onClick = function() return GAJMaintenanceMenu.setHomeSector(shipid) end
                    row[12]:createButton(GAJMaintenanceMenu.props.SetRange):setText(ship.GateRange)
                    row[12].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetRange", ship)
                    end
                    row[13]:createButton(GAJMaintenanceMenu.props.AssignSupplyShip):setText("Switch")
                    row[13].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "AssignSupplyShip", ship)
                    end
                end
            end
            --  -- ships
            --	size | name | sector | shields | hull | crew | cargo | personal supplies | expected supply usage | crew supply usage | ship supply usage | receive delivery checkbox | resupply self checkbox | make supply ship button
            if next(GAJMaintenanceMenu.data.ships) then
                DebugError("gajMaintenance.menu.data.ships")
                row = GAJMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("")

                row = GAJMaintenanceMenu.infotable:addRow(nil, {
                    bgColor = Helper.defaultTitleBackgroundColor,
                    borderBelow = false
                })
                row[1]:setColSpan(tableCols):createText("Ships", Helper.titleTextProperties)
                row = GAJMaintenanceMenu.infotable:addRow(true, {
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
                row[10]:createText("Make Resupply Ship", Helper.subHeaderTextProperties)
                -- receive delivery checkbox | make supply ship button
                row[11]:createText("Receive Deliveries", Helper.subHeaderTextProperties)
                row[12]:createText("Make Supply Ship", Helper.subHeaderTextProperties)
                for shipid, ship in pairs(GAJMaintenanceMenu.data.resupplyships) do
                    row = GAJMaintenanceMenu.infotable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    row[1]:createText(ship.Size)
                    row[2]:createText(ship.Name)
                    row[3]:createText(ship.Sector)
                    row[4]:createButton(GAJMaintenanceMenu.props.SetDesiredUnits):setText(ship.ShipUnits + " / " +
                        ship.DesiredUnits)
                    row[4].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "SetDesiredUnits", shipid)
                    end
                    row[5]:createText(ship.RepairComplexity)
                    row[6]:createText(ship.TotalUsage)
                    row[7]:createText(ship.CrewUsage)
                    row[8]:createText(ship.EnergyUsage)
                    row[9]:createText(ship.WearTear)
                    row[10]:createButton(GAJMaintenanceMenu.props.MakeResupplyShip):setText("Switch")
                    row[10].handlers.onClick = function()
                        AddUITriggeredEvent("GAJ_Maint", "MakeResupplyShip", shipid)
                    if ship.ReceiveDeliveries then
                        row[11]:createCheckBox(ship.ReceiveDeliveries.checked,
                            GAJMaintenanceMenu.props.ReceiveDeliveries)
                        row[11].handlers.onClick = function(_, checked)
                            AddUITriggeredEvent("GAJ_Maint", "ReceiveDeliveries", { checked, ship })
                        end
                        row[12]:createButton(GAJMaintenanceMenu.props.MakeSupplyShip):setText("Set")
                        row[12].handlers.onClick = function()
                            AddUITriggeredEvent("GAJ_Maint", "MakeSupplyShip", ship)
                        end
                    end
                end
            end
        end
        GAJMaintenanceMenu.infotable:setTopRow(menu.settoprow)
        GAJMaintenanceMenu.infotable:setSelectedRow(menu.setselectedrow)
        menu.settoprow = nil
        menu.setselectedrow = nil
    end
end

function GAJMaintenanceMenu.chooseSector()
    local shipid = GetNPCBlackboard(GAJMaintenanceMenu.playerId, "$gajMaintenanceShipId")
    GAJMaintenanceMenu.selectHomeSector(shipid)
end

function GAJMaintenanceMenu.selectHomeSector(shipid)
    local mapMenu = Helper.getMenu("MapMenu")
    AddUITriggeredEvent("GAJ_Maint", "SetHomeSector", shipid)
    -- menu.setSelectComponentMode (returnsection, classlist, category, playerowned, customheading, screenname)local classList = {}
    local classList = {}
    table.insert(classList, "sector")
    mapMenu.setSelectComponentMode(nil, classList, nil, nil, nil, "GAJ_Maint_SelectHomeSector")
end

function GAJMaintenanceMenu.togglePlayerInfoMenuRefresh()
    DebugError("gajMaintenance.togglePlayerInfoMenuRefresh")
    local menu = playerInfoMenu
    if menu.mode == "gajMaintenance" then
        GAJMaintenanceMenu.data = GetNPCBlackboard(GAJMaintenanceMenu.playerId, "$gajMaintenanceData")
        GAJMaintenanceMenu.empireData = GetNPCBlackboard(GAJMaintenanceMenu.playerId, "$gajMaintenanceEmpireData")
        if GAJMaintenanceMenu.data then
            if GAJMaintenanceMenu.timeNextAssessmentRow then
                local timeLeft = GAJMaintenanceMenu.data.timeNextAssessment - C.GetCurrentGameTime()
                if timeLeft < 60 then
                    timeLeft = tostring(math.floor(timeLeft * 100) / 100) .. ReadText(1001, 100)      -- seconds
                else
                    timeLeft = tostring(math.floor(timeLeft / 60 * 100) / 100) .. ReadText(1001, 103) -- minutes
                end
                DebugError("GAJMaintenanceMenu.infotable.id", GAJMaintenanceMenu.infotable.id)
                DebugError("GAJMaintenanceMenu.timeNextAssessmentRow", GAJMaintenanceMenu.timeNextAssessmentRow)
                Helper.updateCellText(GAJMaintenanceMenu.infotable.id, GAJMaintenanceMenu.timeNextAssessmentRow,
                    GAJMaintenanceMenu.timeNextAssessmentCol, timeLeft)
            else
                menu.refresh = getElapsedTime()
            end
        end
    end
end

return ModLua
