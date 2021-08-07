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

end
---------||

--Events||
ProStore2.PlayerAdded:Connect(playerJoined)
--------||