local ffi = require("ffi")
local C = ffi.C

local ModLua = {}

-- required to remove swi vanilla maintenance
--[[ local sw_maintenance = require("extensions.starwarsmod_m1.ui.sw_maintenance") ]]

local playerInfoMenu = nil
--[[ local encyclopediaMenu = nil ]]
GAJMaintenanceMenu = {}
GAJMaintenanceMenu.infoTable = nil
GAJMaintenanceMenu.timeNextAssessmentRow = nil
GAJMaintenanceMenu.timeNextAssessmentCol = nil
GAJMaintenanceMenu.data = nil
GAJMaintenanceMenu.props = nil
GAJMaintenanceMenu.empireData = nil

function init()
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
    GAJMaintenanceMenu.infoTable = nil
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
        GAJMaintenanceMenu.infoTable = infoFrame:addTable(tableCols, {
            tabOrder = 1,
            borderEnabled = true,
            width = tableProperties.width,
            x = tableProperties.x,
            y = tableProperties.y
        })
        if menu.setdefaulttable then
            GAJMaintenanceMenu.infoTable.properties.defaultInteractiveObject = true
            menu.setdefaulttable = nil
        end
        GAJMaintenanceMenu.infoTable:setDefaultCellProperties("text", {
            minRowHeight = config.rowHeight,
            fontsize = Helper.standardFontSize
        })
        GAJMaintenanceMenu.infoTable:setDefaultCellProperties("button", {
            height = config.rowHeight
        })
        -- GAJMaintenanceMenu.infotable:setColWidth (1, Helper.scaleY (config.rowHeight), false)
        -- GAJMaintenanceMenu.infotable:setColWidth (tableCols, Helper.scaleY (config.rowHeight), false)
        row = GAJMaintenanceMenu.infoTable:addRow(nil, {
            bgColor = Helper.defaultTitleBackgroundColor,
            borderBelow = false
        })
        row[1]:setcolSpan(tableCols):createText("Emergent Maintenance", Helper.titleTextProperties)
        if GAJMaintenanceMenu.data then
            DebugError("gajMaintenance.menu.data")
            row = GAJMaintenanceMenu.infoTable:addRow(true, {
                bgColor = Helper.color.transparent,
                borderBelow = false
            })
            GAJMaintenanceMenu.timeNextAssessmentRow = 2
            row[1]:createText("Next Cycle: ")
            DebugError("timeNextAssessment", GAJMaintenanceMenu.data.timeNextAssessment)
            local timeLeft = GAJMaintenanceMenu.data.timeNextAssessment - C.GetCurrentGameTime()
            if timeLeft < 60 then
                row[2]:createText(tostring(math.floor(timeLeft * 100) / 100) .. ReadText(1001, 100))        -- seconds
            else
                row[2]:createText(tostring(math.floor(timeLeft / 60.0 * 100) / 100) .. ReadText(1001, 103)) -- minutes
            end
            GAJMaintenanceMenu.timeNextAssessmentCol = 2

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
            if next(GAJMaintenanceMenu.empireData.Current) then
                local current = GAJMaintenanceMenu.empireData.Current

                -- personnel data
                row = GAJMaintenanceMenu.infoTable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                local labels = {
                    "#Pilots",
                    "#Marines",
                    "#Service",
                    "",
                    "T.Salary",
                    "T.Usage",
                }
                for i, label in ipairs(labels) do
                    row[i]:createText(label, Helper.subHeaderTextProperties)
                end
                row = GAJMaintenanceMenu.infoTable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                local values = {
                    current.TotalPilots,
                    current.TotalMarines,
                    current.TotalService,
                    "",
                    current.TotalSalary,
                    current.TotalUse,
                }
                for i, value in ipairs(values) do
                    row[i]:createText(value)
                end

                -- ship data
                row = GAJMaintenanceMenu.infoTable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                labels = {
                    "#Supply",
                    "#Dedicated",
                    "#Resupply",
                    "#LowSupplies",
                    "Set#Cycles",
                    "",
                    "T.Wear&Tear",
                    "T.Energy",
                    "T.Usage"
                }
                for i, label in ipairs(labels) do
                    row[i]:createText(label, Helper.subHeaderTextProperties)
                end
                row = GAJMaintenanceMenu.infoTable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                values = {
                    current.TotalSupply,
                    current.TotalDedicated,
                    current.TotalResupply,
                    { current.NumLow,    "button", "ShowNumLow" },
                    { current.CyclesLow, "button", "SetCyclesLow" },
                    "",
                    current.TotalWearTear,
                    current.TotalEnergy,
                    current.TotalSupplyUse
                }
                for i, value in ipairs(values) do
                    if type(value) == "table" and value[2] == "button" then
                        row[i]:createButton(GAJMaintenanceMenu.props[value[3]]):setText(value[1])
                        row[i].handlers.onClick = function()
                            AddUITriggeredEvent("GAJ_Maint", value[3])
                        end
                    else
                        row[i]:createText(value)
                    end
                end
            end

            -- Display LastCycle Empire Data
            if next(GAJMaintenanceMenu.empireData.LastCycle) then
                row = GAJMaintenanceMenu.infoTable:addRow(nil, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("")
                row = GAJMaintenanceMenu.infoTable:addRow(nil, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                row[1]:createText("Last Cycle:", Helper.titleTextProperties)
                local lastCycle = GAJMaintenanceMenu.empireData.LastCycle

                -- personnel data
                row = GAJMaintenanceMenu.infoTable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                local labels = {
                    "#Pilots",
                    "#Marines",
                    "#Service",
                    "",
                    "T.Salary",
                    "T.Usage",
                }
                for i, label in ipairs(labels) do
                    row[i]:createText(label, Helper.subHeaderTextProperties)
                end
                row = GAJMaintenanceMenu.infoTable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                local values = {
                    lastCycle.TotalPilots,
                    lastCycle.TotalMarines,
                    lastCycle.TotalService,
                    "",
                    lastCycle.TotalSalary,
                    lastCycle.TotalUse,
                }
                for i, value in ipairs(values) do
                    row[i]:createText(value)
                end

                -- ship data
                row = GAJMaintenanceMenu.infoTable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                labels = {
                    "#Supply",
                    "#Dedicated",
                    "#Resupply",
                    "#LowSupplies",
                    "Set#Cycles",
                    "",
                    "T.Wear&Tear",
                    "T.Energy",
                    "T.Usage"
                }
                for i, label in ipairs(labels) do
                    row[i]:createText(label, Helper.subHeaderTextProperties)
                end
                row = GAJMaintenanceMenu.infoTable:addRow(true, {
                    bgColor = Helper.color.transparent,
                    borderBelow = false
                })
                values = {
                    lastCycle.TotalSupply,
                    lastCycle.TotalDedicated,
                    lastCycle.TotalResupply,
                    lastCycle.NumLow,
                    lastCycle.CyclesLow,
                    "",
                    lastCycle.TotalWearTear,
                    lastCycle.TotalEnergy,
                    lastCycle.TotalSupplyUse
                }
                for i, value in ipairs(values) do
                    row[i]:createText(value)
                end
            end

            -- Supply Ships
            if next(GAJMaintenanceMenu.data.supplyships) then
                DebugError("gajMaintenance.menu.data.supplyships")

                local initialRows = {
                    { text = "",      bgColor = Helper.color.transparent },
                    { isTitle = true, text = "Supply Ships",             bgColor = Helper.defaultTitleBackgroundColor, colSpan = tableCols },
                    {
                        isHeader = true,
                        labels = {
                            "Size",
                            "Name",
                            "Sector",
                            "Supplies",
                            "RepairCost",
                            "TotalUse",
                            "CrewUse",
                            "EnergyUse",
                            "Wear&Tear",
                            "CargoSupplies",
                            "Remove"
                        },
                        bgColor = Helper.color.transparent
                    }
                }
                for _, rowData in ipairs(initialRows) do
                    row = GAJMaintenanceMenu.infoTable:addRow(nil, {
                        bgColor = rowData.bgColor,
                        borderBelow = false
                    })
                    if rowData.isTitle then
                        row[1]:setcolSpan(rowData.colSpan):createText(rowData.text, Helper.titleTextProperties)
                    elseif rowData.isHeader then
                        for i, label in ipairs(rowData.labels) do
                            row[i]:createText(label, Helper.subHeaderTextProperties)
                        end
                    else
                        row[1]:createText(rowData.text)
                    end
                end

                for shipid, ship in pairs(GAJMaintenanceMenu.data.supplyships) do
                    row = GAJMaintenanceMenu.infoTable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    local values = {
                        ship.Size,
                        ship.Name,
                        ship.Sector,
                        { ship.ShipUnits .. " / " .. ship.DesiredUnits .. " (" .. ship.NumCycles .. ")", "button", "SetDesiredUnits" },
                        ship.RepairComplexity,
                        ship.TotalUsage,
                        ship.CrewUsage,
                        ship.EnergyUsage,
                        ship.WearTear,
                        { ship.ShipSupplies .. " / " .. ship.DesiredSupplies,                        "button", "SetDesiredSupplies" },
                        { "Remove",                                                                  "button", "RemoveSupplyShip" }
                    }
                    for i, value in ipairs(values) do
                        if type(value) == "table" and value[2] == "button" then
                            row[i]:createButton(GAJMaintenanceMenu.props[value[3]]):setText(value[1])
                            row[i].handlers.onClick = function()
                                AddUITriggeredEvent("GAJ_Maint", value[3], shipid)
                            end
                        else
                            row[i]:createText(value)
                        end
                    end
                end
            end

            -- dedicated resupply ships
            if next(GAJMaintenanceMenu.data.dedicatedresupplyships) then
                DebugError("gajMaintenance.menu.data.dedicatedresupplyships")

                local initialRows = {
                    { text = "",      bgColor = Helper.color.transparent },
                    { isTitle = true, text = "Dedicated Resupply Ships", bgColor = Helper.defaultTitleBackgroundColor, colSpan = tableCols },
                    {
                        isHeader = true,
                        labels = {
                            "Size",
                            "Name",
                            "Sector",
                            "Supplies",
                            "RepairCost",
                            "TotalUse",
                            "CrewUse",
                            "EnergyUse",
                            "Wear&Tear",
                            "SupplyShip",
                            "Switch"
                        },
                        bgColor = Helper.color.transparent
                    }
                }

                for _, rowData in ipairs(initialRows) do
                    row = GAJMaintenanceMenu.infoTable:addRow(nil, {
                        bgColor = rowData.bgColor,
                        borderBelow = false
                    })
                    if rowData.isTitle then
                        row[1]:setcolSpan(rowData.colSpan):createText(rowData.text, Helper.titleTextProperties)
                    elseif rowData.isHeader then
                        for i, label in ipairs(rowData.labels) do
                            row[i]:createText(label, Helper.subHeaderTextProperties)
                        end
                    else
                        row[1]:createText(rowData.text)
                    end
                end

                for shipid, ship in pairs(GAJMaintenanceMenu.data.dedicatedresupplyships) do
                    row = GAJMaintenanceMenu.infoTable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    local values = {
                        ship.Size,
                        ship.Name,
                        ship.Sector,
                        { ship.ShipUnits .. " / " .. ship.DesiredUnits .. " (" .. ship.NumCycles .. ")", "button", "SetDesiredUnits" },
                        ship.RepairComplexity,
                        ship.TotalUsage,
                        ship.CrewUsage,
                        ship.EnergyUsage,
                        ship.WearTear,
                        { ship.SupplyShip,                                                           "button", "AssignSupplyShip" },
                        { "Switch",                                                                  "button", "MakeResupplyShip" }
                    }
                    for i, value in ipairs(values) do
                        if type(value) == "table" and value[2] == "button" then
                            row[i]:createButton(GAJMaintenanceMenu.props[value[3]]):setText(value[1])
                            row[i].handlers.onClick = function()
                                AddUITriggeredEvent("GAJ_Maint", value[3], shipid)
                            end
                        else
                            row[i]:createText(value)
                        end
                    end
                end
            end

            -- resupply ships
            if next(GAJMaintenanceMenu.data.resupplyships) then
                DebugError("gajMaintenance.menu.data.resupplyships")

                local initialRows = {
                    { text = "",      bgColor = Helper.color.transparent },
                    { isTitle = true, text = "Resupply Ships",           bgColor = Helper.defaultTitleBackgroundColor, colSpan = tableCols },
                    {
                        isHeader = true,
                        labels = {
                            "Size",
                            "Name",
                            "Sector",
                            "Supplies",
                            "RepairCost",
                            "TotalUse",
                            "CrewUse",
                            "EnergyUse",
                            "Wear&Tear",
                            "HomeSector",
                            "GateRange",
                            "Switch"
                        },
                        bgColor = Helper.color.transparent
                    }
                }

                for _, rowData in ipairs(initialRows) do
                    row = GAJMaintenanceMenu.infoTable:addRow(nil, {
                        bgColor = rowData.bgColor,
                        borderBelow = false
                    })
                    if rowData.isTitle then
                        row[1]:setcolSpan(rowData.colSpan):createText(rowData.text, Helper.titleTextProperties)
                    elseif rowData.isHeader then
                        for i, label in ipairs(rowData.labels) do
                            row[i]:createText(label, Helper.subHeaderTextProperties)
                        end
                    else
                        row[1]:createText(rowData.text)
                    end
                end

                for shipid, ship in pairs(GAJMaintenanceMenu.data.resupplyships) do
                    row = GAJMaintenanceMenu.infoTable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })

                    local values = {
                        ship.Size,
                        ship.Name,
                        ship.Sector,
                        { ship.ShipUnits .. " / " .. ship.DesiredUnits .. " (" .. ship.NumCycles .. ")", "button", "SetDesiredUnits" },
                        ship.RepairComplexity,
                        ship.TotalUsage,
                        ship.CrewUsage,
                        ship.EnergyUsage,
                        ship.WearTear,
                        { ship.HomeSector,                                                           "button", "SetHomeSector" },
                        { ship.GateRange,                                                            "button", "SetRange" },
                        { "Switch",                                                                  "button", "AssignSupplyShip" }
                    }

                    for i, value in ipairs(values) do
                        if type(value) == "table" and value[2] == "button" then
                            row[i]:createButton(GAJMaintenanceMenu.props[value[3]]):setText(value[1])
                            row[i].handlers.onClick = function()
                                if value[3] == "SetHomeSector" then
                                    return GAJMaintenanceMenu.setHomeSector(shipid)
                                else
                                    AddUITriggeredEvent("GAJ_Maint", value[3], value[3] == "SetRange" and ship or shipid)
                                end
                            end
                        else
                            row[i]:createText(value)
                        end
                    end
                end
            end

            -- all other ships
            if next(GAJMaintenanceMenu.data.ships) then
                DebugError("gajMaintenance.menu.data.ships")

                local initialRows = {
                    { text = "",      bgColor = Helper.color.transparent },
                    { isTitle = true, text = "Ships",                    bgColor = Helper.defaultTitleBackgroundColor, colSpan = tableCols },
                    {
                        isHeader = true,
                        labels = {
                            "Size",
                            "Name",
                            "Sector",
                            "Supplies",
                            "RepairCost",
                            "TotalUse",
                            "CrewUse",
                            "EnergyUse",
                            "Wear&Tear",
                            "SetResupply",
                            "Deliveries",
                            "SetSupplyShip"
                        },
                        bgColor = Helper.color.transparent
                    }
                }

                for _, rowData in ipairs(initialRows) do
                    row = GAJMaintenanceMenu.infoTable:addRow(nil, {
                        bgColor = rowData.bgColor,
                        borderBelow = false
                    })
                    if rowData.isTitle then
                        row[1]:setcolSpan(rowData.colSpan):createText(rowData.text, Helper.titleTextProperties)
                    elseif rowData.isHeader then
                        for i, label in ipairs(rowData.labels) do
                            row[i]:createText(label, Helper.subHeaderTextProperties)
                        end
                    else
                        row[1]:createText(rowData.text)
                    end
                end

                for shipid, ship in pairs(GAJMaintenanceMenu.data.ships) do
                    row = GAJMaintenanceMenu.infoTable:addRow(true, {
                        bgColor = Helper.color.transparent,
                        borderBelow = false
                    })
                    local values = {
                        ship.Size,
                        ship.Name,
                        ship.Sector,
                        { ship.ShipUnits .. " / " .. ship.DesiredUnits .. " (" .. ship.NumCycles .. ")", "button", "SetDesiredUnits" },
                        ship.RepairComplexity,
                        ship.TotalUsage,
                        ship.CrewUsage,
                        ship.EnergyUsage,
                        ship.WearTear,
                        { "Switch",                                                                  "button", "MakeResupplyShip" },
                    }
                    for i, value in ipairs(values) do
                        if type(value) == "table" and value[2] == "button" then
                            row[i]:createButton(GAJMaintenanceMenu.props[value[3]]):setText(value[1])
                            row[i].handlers.onClick = function()
                                AddUITriggeredEvent("GAJ_Maint", value[3], shipid)
                            end
                        else
                            row[i]:createText(value)
                        end
                    end
                    if next(ship.ReceiveDeliveries) then
                        row[11]:createCheckBox(ship.ReceiveDeliveries.checked, GAJMaintenanceMenu.props
                            .ReceiveDeliveries)
                        row[11].handlers.onClick = function(_, checked)
                            AddUITriggeredEvent("GAJ_Maint", "ReceiveDeliveries", { checked, shipid })
                        end
                        row[12]:createButton(GAJMaintenanceMenu.props.MakeSupplyShip):setText("Set")
                        row[12].handlers.onClick = function()
                            AddUITriggeredEvent("GAJ_Maint", "MakeSupplyShip", shipid)
                        end
                    end
                end
            end
        end
        GAJMaintenanceMenu.infoTable:setTopRow(menu.settoprow)
        GAJMaintenanceMenu.infoTable:setSelectedRow(menu.setselectedrow)
        menu.settoprow = nil
        menu.setselectedrow = nil
    end
end

function GAJMaintenanceMenu.chooseSector()
    GAJMaintenanceMenu.setHomeSector(GetNPCBlackboard(GAJMaintenanceMenu.playerId, "$gajMaintenanceShipId"))
end

function GAJMaintenanceMenu.setHomeSector(shipid)
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
                DebugError("GAJMaintenanceMenu.infotable.id", GAJMaintenanceMenu.infoTable.id)
                DebugError("GAJMaintenanceMenu.timeNextAssessmentRow", GAJMaintenanceMenu.timeNextAssessmentRow)
                Helper.updateCellText(GAJMaintenanceMenu.infoTable.id, GAJMaintenanceMenu.timeNextAssessmentRow,
                    GAJMaintenanceMenu.timeNextAssessmentCol, timeLeft)
            else
                menu.refresh = getElapsedTime()
            end
        end
    end
end

init()