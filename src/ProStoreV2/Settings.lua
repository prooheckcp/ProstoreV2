--[[
    Module settings
]]
return {
    --Data store key    
	["keycode"] = "someRandomKey4", 
	--If Roblox Studio is allowed to save player data
	["saveOnStudio"] = true,
	--If the console should print all changes
	["actionsFeedback"] = true,
	--How often does the server auto save? (Default: every 3 minutes)
	["autoSave"] = 3,

    ["schema"] = {
		["Points"] = 0,
		["Coins"] = 10,
		["Inventory"] = {},
		["stats"] = {
			["health"] = 0,
			["someTable"] = {
				["cadeira"] = 12,
				["evenMoreNested"] = {
					["UwU"] = 3,
					["OwO"] = 10,
				}
			}
		}
	}
}