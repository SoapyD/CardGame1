
local characters = {"assassin","barbarian","hunter","knight","monk","ninja",
                    "pirate","samurai","sumo","swordmaster","thief","vanguard"};

function Get_CharacterList()
    return characters;
end

function CheckCharacter(character_name)

    local character_info = {}

    CheckState = switch { 
        ["test"] = function()    --
                character_info[1] = 0
                character_info[2] = 0
                character_info[3] = 0
                character_info[4] = 0
                character_info[5] = 0
                character_info[6] = 0
            end,
        ["assassin"] = function()    --
        		character_info[1] = 1
        		character_info[2] = 0
        		character_info[3] = 0
        		character_info[4] = 5
        		character_info[5] = 0
        		character_info[6] = 2
            end,
        ["barbarian"] = function()    --
        		character_info[1] = 0
        		character_info[2] = 5
        		character_info[3] = 0
        		character_info[4] = 0
        		character_info[5] = 2
        		character_info[6] = 1
            end,
        ["hunter"] = function()    --
        		character_info[1] = 0
        		character_info[2] = 0
        		character_info[3] = 4
        		character_info[4] = 2
        		character_info[5] = 1
        		character_info[6] = 1
            end,
        ["knight"] = function()    --
        		character_info[1] = 2
        		character_info[2] = 0
        		character_info[3] = 1
        		character_info[4] = 0
        		character_info[5] = 5
        		character_info[6] = 0
            end,
        ["monk"] = function()    --
        		character_info[1] = 0
        		character_info[2] = 2
        		character_info[3] = 5
        		character_info[4] = 1
        		character_info[5] = 0
        		character_info[6] = 0
            end,
        ["ninja"] = function()    --
        		character_info[1] = 1
        		character_info[2] = 1
        		character_info[3] = 0
        		character_info[4] = 4
        		character_info[5] = 0
        		character_info[6] = 2
            end,
        ["pirate"] = function()    --
        		character_info[1] = 1
        		character_info[2] = 2
        		character_info[3] = 1
        		character_info[4] = 0
        		character_info[5] = 0
        		character_info[6] = 4
            end,
        ["samurai"] = function()    --
        		character_info[1] = 4
        		character_info[2] = 0
        		character_info[3] = 1
        		character_info[4] = 1
        		character_info[5] = 2
        		character_info[6] = 0
            end,
        ["sumo"] = function()    --
        		character_info[1] = 0
        		character_info[2] = 4
        		character_info[3] = 2
        		character_info[4] = 1
        		character_info[5] = 1
        		character_info[6] = 0
            end,
        ["swordmaster"] = function()    --
        		character_info[1] = 5
        		character_info[2] = 0
        		character_info[3] = 2
        		character_info[4] = 0
        		character_info[5] = 1
        		character_info[6] = 0
            end,
        ["thief"] = function()    --
        		character_info[1] = 0
        		character_info[2] = 1
        		character_info[3] = 0
        		character_info[4] = 2
        		character_info[5] = 0
        		character_info[6] = 5
            end,
        ["vanguard"] = function()    --
        		character_info[1] = 2
        		character_info[2] = 1
        		character_info[3] = 0
        		character_info[4] = 4
        		character_info[5] = 0
        		character_info[6] = 1
            end,
        default = function () print( "ERROR - Character Class not within switch") end,
    }

    CheckState:case(character_name)

    return character_info

end