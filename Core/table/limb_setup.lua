local discard_max = 0
local limb_modifier = 0
local applied_to = 0

function Get_LimbTable_Info()
    local limb_info = {}
    limb_info.limb_modifier = limb_modifier
    limb_info.applied_to = applied_to
    limb_info.discard_max = discard_max

    return limb_info
end

function Hide_LimbTable()
    Hide_GameTypeScreen();

    TitleText.text = ""
    CheckActionPos(false)
    limb_modifier = 0
end

function Hide_LimbButton(button_info)
    button_info.icon.isVisible  = false
    button_info.icon.text.isVisible = false
end

function Show_LimbTable(action_var)
    local used_text = ""

    if (action_var < 0) then
        limb_modifier = -1
        applied_to = 1
        TitleText.text = "Damage Limb"
        used_text = "cripple"
    else
        limb_modifier = 1
        applied_to = 0
        TitleText.text = "Heal Limb"
        used_text = "heal"
    end

    LoadLimbTable(used_text)
    Show_GameTypeButtons();

    run_popup(TitleText.text .. ": " .. discard_max)

    LoopLimbCheck()
end

function LoopLimbCheck()
    local applied_player = {}
    if (applied_to == 0) then --THE CURRENT PLAYER
        applied_player = GameInfo.player_list[GameInfo.current_player]
    else
        local pos = GameInfo.current_player
        pos = pos + 1
        if (pos > 2) then
            pos = 1
        end
        applied_player = GameInfo.player_list[pos]
        --print("PLAYER POS: " .. pos .. ", LIST LENGTH: " .. table.getn(GameInfo.player_list))
    end
    --print("APPLIED LIMB PLAYER: " .. applied_player.username)
end

function SetCrippleMax(draw_value)

    if (draw_value < 0) then
        draw_value = draw_value * -1 --RATIONALISE ANY NEGATIVE VALES
        --A MODIFIER IS CREATED WHEN THE LIMB TABLE IS SHOWN
    end
    discard_max = draw_value
end

function CheckLimbs()
    if (discard_max <= 1) then
        Hide_LimbTable()
    else
        LoopLimbCheck()
    end
    discard_max = discard_max - 1
    if (discard_max > 0) then
        run_popup(TitleText.text .. ": " .. discard_max)
    end 

end

function SetLimbMax(discard_value)
    discard_max = discard_value
end

function SetLimbColour(limb_figure, limb_function)
    
    local return_info = {}

    local limb = limb_function
    local colour = "red"

    if (limb_modifier == -1) then
        --CRIPPLE FUNCTIONS
        if (limb_figure == 0) then
            limb = ""
            colour = "gray"
        end
    else
        --HEAL FUNCTIONS
        if (limb_figure == 2) then
            limb = ""
            colour = "gray"
        end
    end

    return_info.limb = limb
    return_info.colour = colour

    return return_info
end

function LoadLimbTable(used_text)
    local group = display.newGroup()

    local button_info = {}
    local apply_to = find_applied_to(applied_to)
    local applied_player = GameInfo.player_list[apply_to]

    --ARM BUTTONS
    local limb_info = SetLimbColour(applied_player.arms, "cripple_arm")

    Add_GameType_Button(button_info,1,
        GameInfo.width / 2, 500,
        300,150,limb_info.colour,used_text .. " arm",limb_info.limb,1)

    --LEG BUTTONS
    local limb_info = SetLimbColour(applied_player.legs, "cripple_leg")

    button_info = {}
    Add_GameType_Button(button_info,3,
        GameInfo.width / 2, 700,
        300,150,limb_info.colour,used_text .. " leg",limb_info.limb,1)
end