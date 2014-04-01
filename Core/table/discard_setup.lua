local discard_max = 0

function Hide_DiscardTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.discard_screen.card1.icon.isVisible  = false
    TitleText.text = ""
    GameInfo.pause_add = false
    CheckActionPos(false)
end

function Show_DiscardTable()
    GameInfo.screen_elements.image.isVisible  = true
    GameInfo.discard_screen.card1.icon.isVisible  = true
    TitleText.text = "Discard Card"
    GameInfo.pause_add = true
    
end

function CheckDiscard()
    if (discard_max <= 1) then
        Hide_DiscardTable(false)
    end

    discard_max = discard_max - 1
end

function SetDiscardMax(discard_value)
    discard_max = discard_value
    --print("draw value" .. draw_max)
end

function LoadDiscardCard()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}
    draw_item.card1 = {}

    AddDiscardZone(draw_item.card1,GameInfo.width / 2,GameInfo.height / 2 - 150,"red","discard",1);


    GameInfo.discard_screen = draw_item
    Hide_DiscardTable()
    --Show_DiscardTable()
end

function AddDiscardZone(draw_card,x,y,colour,type, type_int)

    local icon = display.newRoundedRect( 
        x, y, 400, 400, 1 )
            icon:setFillColor( colorsRGB.RGB(colour) )
            icon.strokeWidth = 6
            icon:setStrokeColor( 200,200,200,255 )
            
    --icon:addEventListener( "touch", DrawTempCard )
    icon.item_loaded = false
    icon.card_type = type
    icon.type_int = type_int
    icon.bbox_min_x = x - (400 / 2)
    icon.bbox_max_x = x + (400 / 2)
    icon.bbox_min_y = y - (400 / 2)
    icon.bbox_max_y = y + (400 / 2)
    draw_card.icon = icon
end