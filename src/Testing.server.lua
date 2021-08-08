--[[
    This script is being used just to show how to use the module by testing random methods
    it's super messy so do not take it as an example
]]

--Services||
local ServerScriptService = game:GetService("ServerScriptService")
----------||

--Dependencies||
local ProStore2 = require(ServerScriptService.ProStoreV2)
--------------||

--Methods||
local function addCoins(player, amount)
    local currentCoins = ProStore2.Get(player, "Coins")
    local newCurrency = currentCoins + amount
    local playerInstance = ProStore2.Set(player, "Coins", newCurrency)

    print(newCurrency)

    local newCoins = playerInstance:Get("Coins")

   

    player:SetAttribute("coins", newCoins)

end

local function playerJoined(player, playerData)
    
    print(player.Name.." just joined.")
    print(playerData)

    wait(1)

    addCoins(player, 100)


end
---------||

--Events||
game.ReplicatedStorage.coins.OnServerEvent:Connect(addCoins)
ProStore2.PlayerAdded:Connect(playerJoined)
--------||