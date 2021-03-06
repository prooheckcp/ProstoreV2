--[[
    This library was created at 08/07/2021 MM/DD/YYYY by Prooheckcp

    Contact:
    Discord: レム デベロッパー | prooheckcp#2001
    Twitter: @prooheckcp

    Prooheckcp is a portuguese game developer who's currently a full time game development student
    and a part-time software engineer for a British company called Dubit.
]]

--Services||
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
----------||

--Dependencies||
local Settings = require(script.Settings)
local PlayerClass = require(script.PlayerClass)
local DeepCopy = require(script.DeepCopy)
--------------||

--Constants||
local MINUTE_SCALE = 60 -- 60 seconds = 1 minute
local DATA_KEY = "playerData_"

--Events names
local PLAYERS_JOINED = "Player_Joined"
-----------||

--Variables||
local playersDataStore = DataStoreService:GetDataStore(Settings.keycode)

local storedEvents = {
    [PLAYERS_JOINED] = {}
}
local playersSocket = {} --Store currently online players
-----------||

--VALIDATION TO STOP ERRORS--
--this part of the code checks if all the settings in the settings files are correct

if typeof(Settings.keycode) ~= "string" then
    error("keycode in settings must be a string!")
end

if typeof(Settings.saveOnStudio) ~= "boolean" then
    error("saveOnStudio in settings must be a boolean!")
end

if typeof(Settings.actionsFeedback) ~= "boolean" then
    error("actionsFeedback in settings must be a boolean!")
end

if typeof(Settings.autoSave) ~= "number" then
    error("autoSave in settings must be a number!")
end

if typeof(Settings.schema) ~= "table" or Settings.schema[1] ~= nil then
    error("schema in settings must be a dictionary!")
end

-----------------------------

--Methods||
local function wrongTypeException(expected, got)

    local error = "Error: expected \""..expected.."\" got \""..typeof(got).."\" instead!"
    warn(error)
    return error

end

local function notification(message)

    if Settings.actionsFeedback then
        warn(message)
    end

end

local function createEvent(key)

    local module = {}
    
    function module:Connect(method)
        
        if typeof(method) ~= "function" then
            return error(wrongTypeException("function", method))
        end

        table.insert(storedEvents[key], method)
    end

    return module

end

--[[
    Checks if the table is correctly corresponding to the one from the schema
    If it isn't then it will it, in order to make this work with nested value I'll
    be using a recursive method
]]
local function recursiveAssing(table, currentSchema)
    
    currentSchema = currentSchema or Settings.schema

    for schemaName, defaultValue in pairs(currentSchema) do

        --Makes sure tables are never references from the schema
        local cleanValue = (typeof(defaultValue) == "table") and DeepCopy(defaultValue) or defaultValue

        local foundValue = false

        for indexName, playerValue in pairs(table) do
            
            if schemaName == indexName then

                --Force variables to have the same type
                if typeof(cleanValue) == typeof(playerValue) then    
                    --Check if it is a table to apply recursive method
                    if typeof(playerValue) == "table" then
                        recursiveAssing(playerValue, cleanValue)
                    end
                else
                    notification(indexName.." no longer has the same type!")
                    --This variables no longer share the same type!
                    table[schemaName] = cleanValue
                end

                foundValue = true
            end

        end

        --The user still did not have this value
        if not foundValue then
            table[schemaName] = cleanValue 
        end

    end

end

--[[
    Removes variables from the user data that are no longer being used
]]
local function recursiveClean(table, currentSchema)
    
    currentSchema = currentSchema or Settings.schema

    for indexName, playerValue in pairs(table) do

        local indexExists = false
        for schemaName, defaultValue in pairs(currentSchema) do
            if indexName == schemaName then
                indexExists = true
                break
            end
        end

        if not indexExists then
            table[indexName] = nil
        else
            --This index exists, check if u can search into it
            if typeof(playerValue) == "table" then
                recursiveClean(playerValue, currentSchema[indexName])
            end
        end

    end

end

--[[
    Gets the data from a user given his player ID 
]]
local function getUserData(userID)
    
    if typeof(userID) == "number" then

        local success, userData = pcall(function()
            return playersDataStore:GetAsync(DATA_KEY..tostring(userID))
        end)

        if success and typeof(userData) == "table" then

            recursiveAssing(userData) --Fixes any variable that is wrongly assigned
            recursiveClean(userData) --Removes variables that are no longer part of the schema

            return userData

        else
            --It's a new user
            return DeepCopy(Settings.schema)
        end

    else
        return wrongTypeException("number", userID)
    end

end

--[[
    Saves a user data into the dataStore
]]
local function saveUser(player)
    
    if RunService:IsStudio() and not Settings.saveOnStudio then
        return
    end

    notification("Saving "..player.name.."'s data!")

    local index, userData = GetPlayer(player)

    if index == nil then
        return warn("This user is no longer online!")
    end
    
    local success = pcall(function()
        return playersDataStore:UpdateAsync(DATA_KEY..tostring(player.UserId), function(oldValue)
            
            --If the data got corrupted do not save it
            if typeof(userData) == "table" then
                return userData
            else
                return oldValue
            end

        end)
    end)

    if not success then
        warn("There was a critical error saving "..player.Name.." data!")
    else
        notification("Saved "..player.Name.." data!")
    end

end

local function removeFromSocket(player)
    
    for index, user in pairs(playersSocket) do
        if user.player == player then
            table.remove(playersSocket, index)
            break
        end
    end

end

local function playerJoined(player)
    
    --Declare a new player instance
    local Player = PlayerClass.new(player)

    Player.data = getUserData(player.UserId)

    Player.saveTime = os.time()

    function Player:Get(dataName)
        return GetData(self.player, dataName)
    end

    function Player:Set(dataName, newValue)
        return SetData(self.player, dataName, newValue)
    end

    --Get the player into the socket
    table.insert(playersSocket, Player)

    --Give the player data to the event
    for _, method in pairs(storedEvents[PLAYERS_JOINED]) do
        method(player, Player.data)
    end

end

local function playerLeft(player)
    saveUser(player)
    removeFromSocket(player)
end

local function autoSaveMethod()

    local currentOS = os.time()
    
    for _, user in pairs(playersSocket) do
        
        local timeVariation = math.abs(currentOS - user.saveTime)

        if timeVariation > (Settings.autoSave * MINUTE_SCALE) then
            --Check if the user still exists
            if user.player.Parent == Players then
                user.saveTime = currentOS
                saveUser(user.player)
            else
                removeFromSocket(user.player)
            end
        end

    end

end

--Exposed methods

--Returns information about this user in the socket: used to help other functions
function GetPlayer(player)
    
    if typeof(player) == "Instance" and player.Parent == Players then

        for index, instance in pairs(playersSocket) do
            if instance.player.UserId == player.UserId then
                return index, instance.data, instance --returns a tupple with both the index and the player instance
            end
        end

        return error("Did not find "..player.Name.." in the local socket!")

    else
        return wrongTypeException("Player instance", player)
    end

end

--[[
    Returns the user instance from the socket
]]
function GetUser(player)
    
    for _, instance in pairs(playersSocket) do
        if instance.player.UserId == player.UserId then
            return instance
        end
    end

    return warn("Could not find user!")

end

--[[
    A simple method to get the nested value of a table
]]
function recursiveSearch(indexesTable, table, startValue)

    local currentIteration = startValue or 1

    local currentIndex = indexesTable[currentIteration]

    for indexName, value in pairs(table) do

        if indexName == currentIndex then

            if currentIteration == #indexesTable then
                return value
            else

                if typeof(value) == "table" then
                    return recursiveSearch(indexesTable, value, currentIteration + 1)
                else
                   return warn(indexesTable[currentIteration + 1].." cannot be searched for in "..typeof(value)) 
                end
            end

        end
    end

    if currentIteration > 1 then
        return warn(currentIndex.." is not part of "..indexesTable[currentIteration - 1])
    else
       return warn(currentIndex.." is not part of the players data!") 
    end

end

function GetData(player, dataName)
    
    local index, data = GetPlayer(player)
    local indexsValues = string.split(dataName, ".")

    --There was no error processing this
    if index ~= nil then
        return recursiveSearch(indexsValues, data)
    end

end

function SetData(player, dataName, newValue)

    local index, data, instance = GetPlayer(player)
    local indexsValues = string.split(dataName, ".")
    local storeFinalIndex = indexsValues[#indexsValues]

    if #indexsValues > 1 then

        --Do not use the last index in the search
        table.remove(indexsValues, #indexsValues)

        --Search here
        local outterTable = recursiveSearch(indexsValues, data)
        outterTable[storeFinalIndex] = newValue

        return instance
    else
        playersSocket[index].data[dataName] = newValue
        return instance
    end

end

function GetOfflineData(userID)
    return getUserData(userID)
end

function ForcedSave(player)

    local user = GetUser(player)

    if user ~= nil then
        user.saveTime = os.time() --Reset save time to avoid auto saving too early
    end

    saveUser(player)
end

--[[
    In case the server closes either cause a dev turned off or due to a random crash
    make the game save the players data 
]]
local function serverClosed()
    for _, user in pairs(playersSocket) do
        saveUser(user.player)
    end
end
---------||

--Events||
Players.PlayerAdded:Connect(playerJoined)
Players.PlayerRemoving:Connect(playerLeft)
game:BindToClose(serverClosed)

--Auto save
if Settings.autoSave > 0 then
    RunService.Heartbeat:Connect(autoSaveMethod)
else
    notification("Autosave is disabled!")
end

--------||

return {
    GetUser = GetUser,
    Get = GetData,
    Set = SetData,
    ForcedSave = ForcedSave,
    GetOfflineUser = GetOfflineData,
    PlayerAdded = createEvent(PLAYERS_JOINED)
}