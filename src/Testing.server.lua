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

    local playerInstance = ProStore2.Set(player, "Coins", 25)

    local playerDetail = ProStore2.Get(player, "Coins")

    if playerDetail ~= nil then
        print(playerDetail)
    end

end
---------||

--Events||
ProStore2.PlayerAdded:Connect(playerJoined)
--------||