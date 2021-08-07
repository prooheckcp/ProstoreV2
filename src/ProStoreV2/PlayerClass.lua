local playerInstance = {}
playerInstance.__index = playerInstance

--Properties||
playerInstance.player = nil --Player instance
playerInstance.data = nil --current player data
------------||

function playerInstance.new(player)

    local newData = setmetatable({}, playerInstance) 
    
    newData.player = player

    return newData

end

return playerInstance
