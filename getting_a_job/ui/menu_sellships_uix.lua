local ModLua = {}

local origFuncs = {}
local newFuncs = {}
local interactMenu
local kTFTR = {
	isRemoveSellshipsCommandFromMap = 1,
}

function ModLua.init()
	interactMenu = Helper.getMenu ("InteractMenu")
	origFuncs.insertLuaAction = interactMenu.insertLuaAction
	interactMenu.insertLuaAction = newFuncs.insertLuaAction
	RegisterEvent ("kTFTR.SetMapSellshipsButtonAvailability", kTFTR.SetMapSellshipsButtonAvailability)
end
function newFuncs.insertLuaAction (actiontype, istobedisplayed)
	if actiontype ~= "sellships" or kTFTR.isRemoveSellshipsCommandFromMap ~= 1 then
		origFuncs.insertLuaAction (actiontype, istobedisplayed)
	end
end
function kTFTR.SetMapSellshipsButtonAvailability (_, isRemoveSellshipsCommandFromMap)
	Helper.debugText("SetMapSellshipsButtonAvailability", isRemoveSellshipsCommandFromMap)
	kTFTR.isRemoveSellshipsCommandFromMap = isRemoveSellshipsCommandFromMap
end

return ModLua
