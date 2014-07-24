local discard_max = 0
local limb_modifier = 0
local applied_to = 0

function Hide_LimbTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.limb_screen.card1.icon.isVisible  = false
    GameInfo.limb_screen.card2.icon.isVisible  = false
    GameInfo.limb_screen.card3.icon.isVisible  = false
    GameInfo.limb_screen.card4.icon.isVisible  = false
    TitleText.text = ""
    CheckActionPos(false)
    limb_modifier = 0
end

function Show_LimbTable(action_var)
    GameInfo.screen_elements.image.isVisible  = true
    GameInfo.limb_screen.card1.icon.isVisible  = true
    GameInfo.limb_screen.card2.icon.isVisible  = true
    GameInfo.limb_screen.card3.icon.isVisible  = true
    GameInfo.limb_screen.card4.icon.isVisible  = true

    if (action_var < 0) then
        limb_modifier = -1
        applied_to = 1
        TitleText.text = "Damage Limb"
    else
        limb_modifier = 1
        applied_to = 0
        TitleText.text = "Heal Limb"
    end
    run_popup(TitleText.text .. ": " .. discard_max)
end

function SetCrippleMax(draw_value)

    if (draw_value < 0) then
        draw_value = draw_value * -1 --RATIONALISE ANY NEGATIVE VALES
        --A MODIFIER IS CREATED WHEN THE LIMB TABLE IS SHOWN
    end
    discard_max = draw_value
    --print("draw value" .. discard_max)
end

function CheckLimbs()
    if (discard_max <= 1) then
        Hide_LimbTable()
    end
    --print("chagnged value" .. discard_max)
    discard_max = discard_max - 1
    run_popup(TitleText.text .. ": " .. discard_max)
end

function SetLimbMax(discard_value)
    discard_max = discard_value
    --print("draw value" .. draw_max)
end

function LoadLimbTable()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}
    draw_item.card1 = {}
    draw_item.card2 = {}
    draw_item.card3 = {}
    draw_item.card4 = {}

    AddLimbZone(draw_item.card1,180,500,"red","cripple_arm",1);
    AddLimbZone(draw_item.card2,620,500,"red","cripple_arm",2);
    AddLimbZone(draw_item.card3,180,700,"red","cripple_leg",1);
    AddLimbZone(draw_item.card4,620,700,"red","cripple_leg",2);

    GameInfo.limb_screen = draw_item
    Hide_LimbTable()
    --Show_LimbTable()
end

function AddLimbZone(draw_card,x,y,colour,type, type_int)

    local icon = display.newRoundedRect( 
        x, y, 300, 150, 1 )
            icon:setFillColor( colorsRGB.RGB(colour) )
            icon.strokeWidth = 6
            icon:setStrokeColor( 200,200,200,255 )
            
    icon:addEventListener( "touch", CrippleLimb_button )
    icon.item_loaded = false
    icon.card_type = type
    icon.type_int = type_int
    icon.bbox_min_x = x - (400 / 2)
    icon.bbox_max_x = x + (400 / 2)
    icon.bbox_min_y = y - (400 / 2)
    icon.bbox_max_y = y + (400 / 2)
    draw_card.icon = icon
end

function CrippleLimb_button( event )
    local t = event.target
    local phase = event.phase

    if "began" == phase then
        
        local parent = t.parent
        parent:insert( t )
        display.getCurrentStage():setFocus( t ) 
        t.isFocus = true

    elseif t.isFocus then
        if "moved" == phase then

        elseif "ended" == phase then
            display.getCurrentStage():setFocus( nil )
            
            appWarpClient.sendUpdatePeers(
            tostring("cripple_limb") .. " " .. 
            tostring(GameInfo.username) .. " " ..
            tostring(limb_modifier) .. " " ..
            tostring(t.card_type) .. " " ..
            tostring(applied_to)) 
        end
    end

    return true
end