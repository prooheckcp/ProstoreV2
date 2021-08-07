--[[
    This library was created at 08/07/2021 MM/DD/YYYY
]]

--Services||
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
----------||

--Dependencies||
local Settings = require(script.Settings)
local PlayerClass = require(script.PlayerClass)
local DeepCopy = require(script.DeepCopy)
--------------||

--Constants||
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

--Methods||
local function wrongTypeException(expected, got)
    warn("Error: expected \""..expected.."\" got \""..typeof(got).."\" instead!")
end

local function notification(message)
    if Settings.actionsFeedback then
        warn(message)
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

            --User already had data
            for schemaName, defaultValue in pairs(Settings.schema) do

                local foundIndex = false

                for indexName, playerValue in pairs(userData) do
                    
                    if schemaName == indexName then
                        --The player already has this value, just check if the type is correct
                        
                        if not (typeof(defaultValue) == typeof(playerValue)) then

                            notification("This user had a wrong variable type!")
                            
                            if typeof(defaultValue) == "table" then
                                userData[schemaName] = DeepCopy(defaultValue)
                            else
                                userData[schemaName] = defaultValue
                            end

                        end

                        foundIndex = true
                        break
                    end

                end

                if not foundIndex then
                    if typeof(defaultValue) == "table" then
                        userData[schemaName] = DeepCopy(defaultValue)
                    else
                        userData[schemaName] = defaultValue
                    end
                end

            end

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

--Exposed methods

--Returns the player in the socket
function GetPlayer(player)
    
    if typeof(player) == "Instance" and player.Parent == Players then

        for index, instance in pairs(playersSocket) do
            if instance.player.UserId == player.UserId then
                return index, instance.data --returns a tupple with both the index and the player instance
            end
        end

        return error("Did not find "..player.Name.." in the local socket!")

    else
        return wrongTypeException("Player instance", player)
    end

end

function GetData(player, dataName)
    
    local index, data = GetPlayer(player)

end

function SetData(player, dataName, newValue)

    local index, data = GetPlayer(player)
    
end

function GetOfflineData(userID)
    return getUserData(userID)
end

function ForcedSave(player)
    saveUser(player)
end

function PlayerAdded()

    local module = {}
    
    function module:Connect(method)
        table.insert(storedEvents[PLAYERS_JOINED], method)
    end

end
---------||

--Events||
Players.PlayerAdded:Connect(playerJoined)
Players.PlayerRemoving:Connect(playerLeft)
--------||

return {
    GetPlayer = GetPlayer,
    Get = GetData,
    Set = SetData,
    ForcedSave = ForcedSave,
    GetOfflineUser = GetOfflineData,
    PlayerAdded = PlayerAdded
}