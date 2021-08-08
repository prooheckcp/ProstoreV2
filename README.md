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

    local playerHealth = ProStore2.Get(player, "stats.health")
    local playerCoins = ProStore2.Get(player, "Coins")

    print("Health: ", playerHealth, "Coins: ", playerCoins)

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
