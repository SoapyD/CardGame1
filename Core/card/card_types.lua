function set_stats(card_info, top, bottom, left, right, arms, legs, either_limb, damage, card_type, card_value)
    card_info.strat_scores = {}
    card_info.strat_scores[1] = top
    card_info.strat_scores[2] = right
    card_info.strat_scores[3] = bottom
    card_info.strat_scores[4] = left        

	card_info.arms = arms
	card_info.legs = legs
	card_info.either_limb = either_limb
	card_info.damage = damage					

    card_info.card_type = card_type
    card_info.card_value = card_value

	card_info.actions = {}
end 

function set_action(action_name, value, applied_to)
	local action_info = {}
	action_info.name = action_name
	action_info.value = value
    action_info.applied_to = applied_to --1 FOR DEFENDER, 0 FOR ATTACKER

	return action_info
end

function retrieve_card(filename)

	local card_info = {}

    card_info.name = ""
    set_stats(card_info, 0,0,0,0,0,0,0,0,"")
    card_info.actions = {}
    --print("checking" .. filename)

    local return_info = Check_WeaponCards(filename)
    if (return_info.found == true) then
        card_info = return_info.card_info
    end
    local return_info = Check_PhysicalCards(filename)
    if (return_info.found == true) then
        card_info = return_info.card_info
    end
    --print("card checked: " .. card_info.name)
	return card_info

end

