--[[
    Module settings
]]
return {

    --Data store key    
	["keycode"] = "someRandomKey4", 

	--If you can save data while testing on studio
	["saveOnStudio"] = true,

	--If the console should print all changes
	["actionsFeedback"] = true,

	--[[
		How often does the server auto save? (Default: every 3 minutes) 
		If you don't want autosave set it to a number smaller or equal to 0

		It's recommended to have auto save on to avoid data loss due to roblox issues, please keep in mind
		that having a small number in the refresh rate of the auto save might overload the requests and make the library
		not work properly, I personally recommend using a number above 2!
	]]
	["autoSave"] = 3,

	--[[
		How you want the data of the game to be designed
		this one is just a random example on how you can prepare your own!
	]]
    ["schema"] = {
		["Points"] = 0,
		["Coins"] = 10,
		["Inventory"] = {},
		["stats"] = {
			["health"] = 0,

			["someTable"] = {
				["anotherNestedValue"] = 12,
				["evenMoreNested"] = {
					["UwU"] = 3,
					["OwO"] = 10,
				}
			}
		}
	}
}