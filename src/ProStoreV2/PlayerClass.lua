local playerInstance = {}
playerInstance.__index = playerInstance

--Properties||
playerInstance.player = nil --Player instance
playerInstance.data = nil --current player data
playerInstance.saveTime = nil --Hold last time it saved for auto save
------------||

function playerInstance.new(player)

    local newData = setmetatable({}, playerInstance) 

    newData.player = player

    return newData

end

return playerInstance
