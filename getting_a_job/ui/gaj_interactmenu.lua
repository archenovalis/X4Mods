local ModLua = {}
local interactMenu = {}

-- Initialize function to register the callback
function init()
    interactMenu = Helper.getMenu("InteractMenu")
    interactMenu.registerCallback("createContentTable_getIsActionValid", ModLua.createContentTable_getIsActionValid)
end

-- Callback function to validate actions
function ModLua.createContentTable_getIsActionValid(entry)
    -- Invalidate the "sellships" action
    if entry and entry.type and entry.type == "sellships" then
        return false
    end

    -- Return true to allow other actions
    return true
end

-- Initialize ModLua
init()
