


--function CheckAbility(ability, applied_to, value)
function CheckAbility(action)
    local add_info = false
    local temp_mods = {}
    temp_mods.type = ""
    --print("ability passed" .. ability)
    Check_Ab = switch { 
    	["health"] = function (x) mod_health(action.applied_to, action.value) end,
        ["armour"] = function (x) mod_armour(action.applied_to, action.value) end,
        ["arm"] = function (x) mod_arm(action.applied_to, action.value) end,
    	["leg"] = function (x) mod_leg(action.applied_to, action.value) end, 
        ["prev_card"] = function (x) mod_from_prev(action.applied_to, action.sub_action) end, 
        ["block"] = function (x) --don't add onto the action list 
                end,
        ["next_card"] = function (x) --don't add onto the action list 
                end,
        ["counter"] = function (x) --don't add onto the action list 
                end,
        ["win_faceoff"] = function (x) --don't add onto the action list 
                end,
        ["no_counter"] = function (x) --don't add onto the action list 
                end,   
	   	default = function () 
                --print( "ERROR - ability not within switch") 
                add_info = true
                end,
	}

	Check_Ab:case(action.name)

    if (add_info == true) then
        temp_mods.type = action.name
        temp_mods.sub_action = action.sub_action
        temp_mods.applied_to = action.applied_to
        temp_mods.value = action.value
        --temp_mods = action
    end
    --print("used friggin action: " .. action.name)

    --CHECK THE LAST CARD IN CASE THERE WAS ANY NEXT_CARD ACTIONS ON IT
    mod_next()

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
    if (applied_player.health < 1 ) then
        applied_player.health = 0
    end
    if (applied_player.health > applied_player.max_health ) then
        applied_player.health = applied_player.max_health
    end
    print("health add:" .. value)
    if (value > 0) then
        run_popup( "+" .. value .. " Health")
    else
        run_popup( value .. " Health")
    end
end

function mod_armour(applied_to, value)

    apply_to = find_applied_to(applied_to)

    local applied_player = GameInfo.player_list[apply_to]
    applied_player.armour = applied_player.armour + value
    if (applied_player.armour < 0 ) then
        applied_player.armour = 0
    end
    print("armour add:" .. value)
    if (value > 0) then
        run_popup( "+" .. value .. " Armour")
    else
        run_popup( value .. " Armour")
    end
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
    if (value > 0) then
        run_popup( "+" .. value .. " Arms Crippled")
    else
        run_popup( value .. " Arms Crippled")
    end
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
    if (value > 0) then
        run_popup( "+" .. value .. " Legs Crippled")
    else
        run_popup( value .. " Legs Crippled")
    end
end

function mod_from_prev(applied_to, sub_action)

    if (GameInfo.previous_card_int ~= -1) then    

        local last_card_info = GameInfo.table_cards[GameInfo.previous_card_int]
        local last_card = retrieve_card(last_card_info.filename)


        Check_SubAction(applied_to, sub_action, last_card.power)
    end
end


function mod_next()

    if (GameInfo.previous_card_int ~= -1) then    

        local current_card_info = GameInfo.table_cards[GameInfo.current_card_int]
        local current_card = retrieve_card(current_card_info.filename)


        local last_card_info = GameInfo.table_cards[GameInfo.previous_card_int]
        local last_card = retrieve_card(last_card_info.filename)

        if ( table.getn(last_card.actions) > 0) then
            for i=1, table.getn(last_card.actions) do
                local action = last_card.actions[i]
                if( action.name == "next_card") then
                    Check_SubAction(action.applied_to, action.sub_action, current_card.power)
                end
            end
        end

        
    end
end

function Check_SubAction(applied_to, sub_action, power)

    --print("sub: " .. sub_action .. ", power: " .. power)

        check_next = switch { 

            ["damage"] = function (x)
                    local value = -power
                    mod_health(applied_to, value)
                    end,
            ["armour"] = function (x)
                    local value = power
                    mod_armour(applied_to, value)
                    end,
            default = function () 
                    print( "ERROR - sub_action not within switch") 
                    end,
        }

        check_next:case(sub_action)
end