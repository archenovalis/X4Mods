local menu = nil
local Funcs = {}

local function InitMenu()
	for _, OrigMenu in ipairs(Menus) do
		if OrigMenu.name == "MapMenu" then
			menu = OrigMenu
			menu.createSellShipsContext = Funcs.createSellShipsContext
			break
		end
	end
end

function Funcs.createSellShipsContext(frame)
	-- description table
	local ftable = frame:addTable(2, { tabOrder = 3, x = Helper.borderSize, y = Helper.borderSize, width = menu.contextMenuData.width, highlightMode = "off" })
	ftable:setColWidthPercent(1, 60)

	-- title
	local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
	row[1]:setColSpan(2):createText(ReadText(1001, 7857), Helper.headerRowCenteredProperties)
	-- ships
	local issellingpossible = false
	menu.contextMenuData.totalprice = 0
	for i, data in ipairs(menu.contextMenuData.ships) do
		local errors, warnings = {}, {}
		local n = C.GetNumOrders(data)
		local buf = ffi.new("Order[?]", n)
		n = C.GetOrders(buf, n, data)
		for i = 0, n - 1 do
			if ffi.string(buf[i].orderdef) == "Equip" then
				errors[1] = ReadText(1001, 3267)
				break
			end
		end
		local hasanymod = GetComponentData(data, "hasanymod")
		if hasanymod then
			warnings[1] = ReadText(1001, 3268)
		end
		menu.contextMenuData.ships[i] = { data, errors }
		local ship = menu.contextMenuData.ships[i][1]
		local macro = GetComponentData(ship.shipid, "macro")
		local macroclass = ffi.string(C.GetMacroClass(macro))
		local reduce = 1
		if macroclass == "ship_xl" then
			reduce = 5
		elseif macroclass == "ship_l" then
			reduce = 7
		elseif macroclass == "ship_m" then
			reduce = 4
		elseif macroclass == "ship_s" then
			reduce = 1
		end
		local price = GetTotalValue(ship, true, menu.contextMenuData.shipyard) / reduce  -- divide by ship class ratio s=nochange m=7x, l=13x, xl=9, xxl=9

		local color = Color["text_normal"]
		if #errors > 0 then
			color = Color["text_inactive"]
		else
			issellingpossible = true
			menu.contextMenuData.totalprice = menu.contextMenuData.totalprice + price
		end

		-- keep these selectable to support scrolling when selling a lot of ships
		local row = ftable:addRow(true, { interactive = false })
		row[1]:createText(ffi.string(C.GetComponentName(ship)) .. " (" .. ffi.string(C.GetObjectIDCode(ship)) .. ")", { color = color })
		row[2]:createText(ConvertMoneyString(price, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right", color = color })

		for _, error in ipairs(errors) do
			local row = ftable:addRow(true, { interactive = false })
			row[1]:setColSpan(2):createText(error, { halign = "right", color = Color["text_error"] })
		end
		for _, warning in ipairs(warnings) do
			local row = ftable:addRow(true, { interactive = false })
			row[1]:setColSpan(2):createText(warning, { halign = "right", color = Color["text_warning"] })
		end
	end
	-- button
	local row = ftable:addRow(true, {  })
	row[2]:createButton({ active = issellingpossible, height = Helper.standardTextHeight }):setText(ReadText(1001, 2917), { halign = "center" })
	row[2].handlers.onClick = menu.buttonSellShips

	if frame.properties.x + menu.contextMenuData.width > Helper.viewWidth then
		frame.properties.x = Helper.viewWidth - menu.contextMenuData.width - config.contextBorder
	end
	local height = frame:getUsedHeight()
	if frame.properties.y + height > Helper.viewHeight then
		local newypos = Helper.viewHeight - height - config.contextBorder
		frame.properties.y = math.max(config.contextBorder, newypos)
	end
end

InitMenu()