


function CheckAbility(ability, applied_to, value)

    local add_info = false
    local temp_mods = {}
    temp_mods.type = ""
    --print("ability passed" .. ability)
    Check_Ab = switch { 
    	["health"] = function (x) mod_health(applied_to, value) end,
        ["armour"] = function (x) mod_armour(applied_to, value) end,
        ["arm"] = function (x) mod_arm(applied_to, value) end,
    	["leg"] = function (x) mod_leg(applied_to, value) end, 
        ["block"] = function (x) 
                --add_info = true
                --value translates to {1="w",2="p",3="f",4="s",5="a",6="c"}
                end,
        --["draw"] = function (x) 
        --        add_info = true
        --        end,
        --["play"] = function (x) 
        --        add_info = true
        --        end, 
        --["discard"] = function (x) 
        --        add_info = true
        --        end, 
        --["end_round"] = function (x)
        --        add_info = true
        --        end, 
        --["limb"] = function (x)
        --        add_info = true
        --        end,
        --["steal"] = function (x)
        --        add_info = true
        --        end, 
        --["shrapnel"] = function (x)
        --        add_info = true
        --        end, 
	   	default = function () 
                --print( "ERROR - ability not within switch") 
                add_info = true
                end,
	}

	Check_Ab:case(ability)

    if (add_info == true) then
        temp_mods.type = ability
        temp_mods.applied_to = applied_to
        temp_mods.value = value
    end

    return temp_mods
end

function find_applied_to(applied_to)
    apply_to = -1
    if (applied_to == 1) then --1 = DEFENDER, 0 = ATTACKER
        apply_to = GameInfo.current_player + 1
        if (apply_to > 2) then
            apply_to = 1
        end
    else
        apply_to = GameInfo.current_player
    end  

    return apply_to
end

function mod_health(applied_to, value)

    apply_to = find_applied_to(applied_to)

    local applied_player = GameInfo.player_list[apply_to]
    applied_player.health = applied_player.health + value
    if (applied_player.health < 0 ) then
        applied_player.health = 0
    end
    if (applied_player.health > applied_player.max_health ) then
        applied_player.health = applied_player.max_health
    end
    print("health add:" .. value)
end

function mod_armour(applied_to, value)

    apply_to = find_applied_to(applied_to)

    local applied_player = GameInfo.player_list[apply_to]
    applied_player.armour = applied_player.armour + value
    if (applied_player.armour < 0 ) then
        applied_player.armour = 0
    end
    print("armour add:" .. value)
end

function mod_arm(applied_to, value)

    apply_to = find_applied_to(applied_to)

    local applied_player = GameInfo.player_list[apply_to]
    applied_player.arms = applied_player.arms + value
    if (applied_player.arms < 0 ) then
        applied_player.arms = 0
    end
    if (applied_player.arms > applied_player.max_arms ) then
        applied_player.arms = applied_player.max_arms
    end
    print("arms add:" .. value)
end

function mod_leg(applied_to, value)

    apply_to = find_applied_to(applied_to)

    local applied_player = GameInfo.player_list[apply_to]
    applied_player.legs = applied_player.legs + value
    if (applied_player.legs < 0 ) then
        applied_player.legs = 0
    end
    if (applied_player.legs > applied_player.max_legs ) then
        applied_player.legs = applied_player.max_legs
    end
    print("legs add:" .. value)
end