--[[
    This script is being used just to show how to use the module by testing random methods
]]

--Services||
local ServerScriptService = game:GetService("ServerScriptService")
----------||

--Dependencies||
local ProStore2 = require(ServerScriptService.ProStoreV2)
--------------||

--Methods||
local function playerJoined(player, playerData)
    
    print(player.Name.." just joined.")
    print(playerData)

    wait(1)

    --Example on how to set a variable
    local playerDetail = ProStore2.Get(player, "stats.health")
    local playerInstance = ProStore2.Set(player, "stats.health", 25)
   -- local playerDetail = playerInstance:Get("stats.health")

    if playerDetail ~= nil then
        print(playerDetail)
    end

end
---------||

--Events||
ProStore2.PlayerAdded:Connect(playerJoined)
--------||