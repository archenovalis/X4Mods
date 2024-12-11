local ModLua = {}

local interactMenu

function ModLua.init()
  interactMenu = Helper.getMenu("InteractMenu")
  interactMenu.registerCallback("createContentTable_getIsActionValid", {sellships = false})
end

return ModLua