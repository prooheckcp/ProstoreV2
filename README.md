# ProStore V2
## A small Roblox Data Store Library V2.0

## Changes
- None yet

ProStore V2 is a remake of my previous library done around september 2020, it allows you to easily work with Roblox data stores. This is a module socket based system.

- Simple
- Low amount of lines (from your side at least)
- Very easy to learn and apply

## Features

- Make your own database schema
- Dynamic schema, you can add and or remove variables at any time from it without damaging player data
- Auto save (Customizable time gap)


# API

### Setting up settings

    Inside of ProStore V2 there's a file called "Settings.lua", in this file you should typedown the schema
    that you wish to have for your game and some of the settings of this system.

### Declaring ProStore V2

This should be the way you declare the module at the top of your script

```lua
local ServerScriptService = game:GetService("ServerScriptService")
local ProStore2 = require(ServerScriptService.ProStoreV2) --Change to script location
```
## Main Methods

### ProStore2.Get(playerInstance, ParameterName)

Returns the user parameter via string, it's important to notice that both the Get and Set support nested values!

Example:
```lua

--[[
    Assuming the schema looks like this:

    schema = {
        Coins = 0,
        stats = {
            health = 100
        }
    }
]]

--Getting nested variables is easy, all you have to do is add a "." between each index name as in the example below
local playerHealth = ProStore2.Get(player, "stats.health")
local playerCoins = ProStore2.Get(player, "Coins")

print("Health: ", playerHealth, "Coins: ", playerCoins)

```

### ProStore2.Set(playerInstance, ParameterName, NewValue)

Returns the user instance, it's important to notice that both the Get and Set support nested values!

Example:
```lua

--[[
    Assuming the schema looks like this:

    schema = {
        Coins = 0,
        stats = {
            health = 100
        }
    }
]]

--As you can see the Set method changes the health of the player to 50
--and it also returns a player instance which can be used to check the player
--data by doing playerInstance.data or to get/set values by doing playerInstance:Get or playerInstance:Set
local playerInstance = ProStore2.Set(player, "stats.health", 50)
local playerHealth = playerInstance:Get(player, "stats.health")

print("Health: ", playerHealth)

```

### ProStore2.ForcedSave(playerInstance)

Forces the game to save this user data, I would highly reccommend doing this after 
important data has been inserted into the player such as a developer product bought
Example:
```lua
ProStore2.ForcedSave(player)
```

### ProStore2.GetOfflineUser(userID)

Gets the data from an offline user, might be useful for leaderboards per example
Example:
```lua
local userData = ProStore2.GetOfflineUser(30165668) --Prooheckcp's userID
```

### ProStore2.GetUser(player)
Returns the user instance of the socket, rememer you can use this user instance to get and set data per example
Example:
```lua
local Coins = ProStore2.GetUser(player):Get("Coins")
print("Coins: "..Coins)
```

## Events

### ProStore2.PlayerAdded:Connect(method)

Attaches a method to the playerAdded event of the ProStore, this method will receive has arguments both the player
and his own data.

Example:
```lua

--Method

--[[
    Assuming the schema looks like this:

    schema = {
        Coins = 0,
        stats = {
            health = 100
        }
    }
]]


local function playerJoined(player, playerData)
    
    --Prints the player name and his data
    print(player.Name.." just joined.")
    print(playerData)

    wait(1) --Just a random wait :p

    --Example on how to set a variable
    local playerInstance = ProStore2.Set(player, "stats.health", 25)    

    --Example on how to get a variable
    local playerDetail = ProStore2.Get(player, "stats.health")

    if playerDetail ~= nil then
        print(playerDetail)
    end

end

--Event
ProStore2.PlayerAdded:Connect(playerJoined)
```
## Installation

All it requires is Roblox Studio.

* Download it from here: https://www.roblox.com/library/7220328141/ProStore-V2
* In Roblox Studio open the "Toolbox" window and open the model.
*  Now in the **Explorer** drag and drop the script from the **Workspace** into the **ServerScriptService**.
*  Open the **ProStore** Instance and open the script named "**Settings**". Inside of this script you should edit the database schema into your needs. You can also set some custom settings as explained in the scripts comments.

## Contact

Found any problem or simply wanna give some feedback regarding the library? Just hit me up!

Discord: レム デベロッパー | prooheckcp#2001

Twitter: https://twitter.com/Prooheckcp


**100% free and open source**
