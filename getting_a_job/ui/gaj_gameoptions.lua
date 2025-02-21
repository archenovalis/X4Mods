local ModLua = {}

local ffi = require ("ffi")
local C = ffi.C

local OptionsMenu
local saveGamesForGameId
local newFuncs = {}
local gameId
local currentSaveFileName

function init ()
	OptionsMenu = Helper.getMenu("OptionsMenu")
	OptionsMenu.registerCallback("addSavegameRow_isListSaveGame", newFuncs.addSavegameRow_isListSaveGame)
	OptionsMenu.registerCallback("displaySavegameOptions_isShowUnusedSaveGame", newFuncs.displaySavegameOptions_isShowUnusedSaveGame)
	OptionsMenu.registerCallback("addSavegameRow_changeSaveGameDisplayName", newFuncs.addSavegameRow_changeSaveGameDisplayName)
	OptionsMenu.registerCallback("cleanup", newFuncs.cleanup)

	if GameIdManager then
		GameIdManager.registerCallback("onSaveGame", newFuncs.onSaveGame)
	end
end

function newFuncs.cleanup()
	saveGamesForGameId = nil
	gameId = nil
	currentSaveFileName = nil
end

function newFuncs.addSavegameRow_isListSaveGame(ftable, savegame, name, slot)
	if not GameIdManager then
		return true
	end

	-- list this save file or not?
	-- save file modes:
	-- dead is dead = after death, can't load a game until after a save
	-- save scum death penalty = can't load a game more than userSaveScumPenalty_timeMinutes older than current game
	-- ironman mode = limit to 1 save slot

	local player_id = ConvertStringTo64Bit (tostring (C.GetPlayerID ()))
	local kATD_gameData
	if player_id > 0 then
		kATD_gameData = GetNPCBlackboard (player_id, "$kATD_gameData")
	end

	if not gameId then
		gameId = GameIdManager.getCurrentGameId()
	end
	if not currentSaveFileName then
		currentSaveFileName = GameIdManager.getCurrentSaveFileName()
	end
	local gameId_fromSaveGame = GameIdManager.getGameIdFromSaveGame(savegame.filename)
	local gameIdData_fromSaveGame
	if gameId_fromSaveGame then
		gameIdData_fromSaveGame = newFuncs.readFromATDModData(gameId_fromSaveGame)
		if not gameIdData_fromSaveGame then
			gameIdData_fromSaveGame = {}
		end
	end
	-- Helper.debugText("gameId: " .. tostring(gameId) .. " currentSaveFileName: " .. tostring(currentSaveFileName))
	-- Helper.debugText("    savegame.filename: " .. tostring(savegame.filename) .. " gameId_fromSaveGame: " .. tostring(gameId_fromSaveGame))
	-- Helper.debugText("    gameIdData_fromSaveGame", gameIdData_fromSaveGame)
	local isAutosave = string.find(savegame.filename, "autosave")
	local isQuicksave = string.find(savegame.filename, "quicksave")

	if OptionsMenu.currentOption == "save" then
		if OptionsMenu.isStartmenu then
			return true
		else
			if gameId and gameId == gameId_fromSaveGame then
				if kATD_gameData and kATD_gameData.isIronManMode == 1 then
					if isAutosave or isQuicksave then
						return false
					elseif not currentSaveFileName then
						return true
					elseif savegame.filename == currentSaveFileName then
						return true
					else
						return false
					end
				else
					return true
				end
			else
				return newFuncs.isListSaveFileOfAnotherGameId(savegame, gameIdData_fromSaveGame)
			end
		end
	elseif OptionsMenu.currentOption == "load" then
		if OptionsMenu.isStartmenu then
			if isAutosave or isQuicksave then
				return true
			else
				return newFuncs.isListSaveFileOfAnotherGameId(savegame, gameIdData_fromSaveGame)
			end
		else
			if gameId and gameId == gameId_fromSaveGame then
				if kATD_gameData and kATD_gameData.isIronManMode == 1 then
					if isAutosave or isQuicksave then
						return true
					elseif not currentSaveFileName then
						return true
					elseif savegame.filename == currentSaveFileName then
						return true
					else
						return false
					end
				else
					return true
				end
			else
				return newFuncs.isListSaveFileOfAnotherGameId(savegame, gameIdData_fromSaveGame)
			end
		end
	else
		return true
	end
end

function newFuncs.isListSaveFileOfAnotherGameId(savegame, gameIdData_fromSaveGame)
	if not GameIdManager then
		return true
	end

	-- limit loading of 1 file for gameids that are in ironman mode
	if gameIdData_fromSaveGame and gameIdData_fromSaveGame.isIronManMode then
		-- this gameId is in ironman mode
		if savegame.filename == gameIdData_fromSaveGame.currentSaveFileName then
			-- this save file is this gameid's current save file
			return true
		else
			if OptionsMenu.currentOption == "save" then
				return true
			else
				return false
			end
		end
	else
		return true
	end
end

function newFuncs.displaySavegameOptions_isShowUnusedSaveGame(slot)
	if not GameIdManager then
		return true
	end

	-- list unused save slot?
	local player_id = ConvertStringTo64Bit (tostring (C.GetPlayerID ()))
	if player_id == 0 then
		return true
	end
	local kATD_gameData = GetNPCBlackboard (player_id, "$kATD_gameData")
	if not kATD_gameData then
		return true
	end

	if kATD_gameData.isIronManMode == 1 then
		if OptionsMenu.currentOption == "save" then
			if not currentSaveFileName then
				return true
			else
				return false
			end
		elseif OptionsMenu.currentOption == "load" then
			return false
		else
			return false
		end
	else
		if OptionsMenu.currentOption == "save" then
			return true
		elseif OptionsMenu.currentOption == "load" then
			return false
		else
			return true
		end
	end
end

function newFuncs.addSavegameRow_changeSaveGameDisplayName(ftable, savegame, name, slot, name)
	if not GameIdManager then
		return name
	end

	local gameId = GameIdManager.getCurrentGameId()
	local gameId_fromSaveGame = GameIdManager.getGameIdFromSaveGame(savegame.filename)
	local gameIdData
	local newName = name
	if gameId_fromSaveGame then
		gameIdData = newFuncs.readFromATDModData(gameId_fromSaveGame)
		if gameIdData and gameIdData.isIronManMode and savegame.filename == gameIdData.currentSaveFileName then
			local ironManText = " - " .. ReadText(111204, 58)
			if gameId == gameId_fromSaveGame then
				ironManText = Helper.convertColorToText(Helper.color.green) .. ironManText .. "\27X"
			else
				ironManText = Helper.convertColorToText(GameIdManager.coloursByGameId[gameId_fromSaveGame]) .. ironManText .. "\27X"
			end
			name = name .. ironManText
		end
	end
	return name
end

function newFuncs.onSaveGame(savegame)
	if not GameIdManager then
		return true
	end

	local player_id = ConvertStringTo64Bit (tostring (C.GetPlayerID ()))
	if player_id == 0 then
		return true
	end
	local kATD_gameData = GetNPCBlackboard (player_id, "$kATD_gameData")
	-- Helper.debugText("kuertee_atd addSavegameRow_isListSaveGame kATD_gameData", kATD_gameData)
	if not kATD_gameData then
		-- requires data from MD
		return
	end

	if not gameId then
		gameId = GameIdManager.getCurrentGameId()
		if not gameId then
			return
		end
	end

	if savegame then
		local gameIdData = newFuncs.readFromATDModData(gameId)
		if not gameIdData then
			gameIdData = {}
		end
		Helper.debugText("gameIdData (pre)", gameIdData)
		if kATD_gameData.isIronManMode == 1 then
			gameIdData.isIronManMode = 1
		else
			gameIdData.isIronManMode = nil
		end
		gameIdData.currentSaveFileName = savegame.filename
		Helper.debugText("gameIdData (post)", gameIdData)
		newFuncs.writetoATDModData(gameId, gameIdData)
	end
end

function newFuncs.writetoATDModData(key, value)
	local owner = "kuertee_alternatives_to_death"
	__MOD_USERDATA = __MOD_USERDATA or {}
	if __MOD_USERDATA[owner] == nil then
		__MOD_USERDATA[owner] = {}
	end
	if type(__MOD_USERDATA[owner][key]) == "table" then
		__MOD_USERDATA[owner][key] = 0
	else
		__MOD_USERDATA[owner][key] = nil
	end
	__MOD_USERDATA[owner][key] = value
end

function newFuncs.readFromATDModData(key)
	local owner = "kuertee_alternatives_to_death"
	local value
	local isSuccess, errorMsg = pcall(function () value = __MOD_USERDATA[owner][key] end)
	if isSuccess then
		return value
	else
		if key ~= "playerId" or (not string.find(errorMsg, "attempt to index a nil value")) then
			if newFuncs.isDebug then
				Helper.debugText("errorMsg: " .. tostring(errorMsg))
				Helper.debugText("    owner: " .. tostring(owner) .. " key: " .. tostring(key) .. " value:", value)
			end
		end
		return nil
	end
end

init()
