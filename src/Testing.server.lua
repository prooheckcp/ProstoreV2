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

    wait(5)

    local playerCoins = ProStore2.Get(player, "Coins")

    print("Coins: "..playerCoins)

end
---------||

--Events||
ProStore2.PlayerAdded:Connect(playerJoined)
--------||