local draw_max = 0

function DrawTempCard( event )
    local t = event.target
    local phase = event.phase

    if "began" == phase then
        
        local parent = t.parent
        parent:insert( t )
        display.getCurrentStage():setFocus( t ) 
        t.isFocus = true

        if (t.item_loaded == false) then
            print("loading")

            local icon = display.newRoundedRect( 
                t.x, t.y, 350, 350, 1 )
                    icon:setFillColor( colorsRGB.RGB("white") )
                    icon.strokeWidth = 6
                    icon:setStrokeColor( 200,200,200,255 )

            GameInfo.temp_card.icon = icon

            local text = display.newText( t.card_type, 
                GameInfo.temp_card.icon.x, GameInfo.temp_card.icon.y, 
                native.systemFontBold, 48 )
                text:setFillColor( colorsRGB.RGB("red") )

            GameInfo.temp_card.icon.text = text
            t.item_loaded = true           
        end
        print("draw start")
    elseif t.isFocus then
        if "moved" == phase then
            GameInfo.temp_card.icon.x = event.x
            GameInfo.temp_card.icon.y = event.y 
            GameInfo.temp_card.icon.text.x = event.x
            GameInfo.temp_card.icon.text.y = event.y
        elseif "ended" == phase then
            display.getCurrentStage():setFocus( nil )
            print("off button")
            if (t.item_loaded == true) then
                local max_hight = display.contentHeight - (300 * GameInfo.zoom)
                if (GameInfo.temp_card.icon.y > max_hight) then
                    print("card drawn" .. t.type_int)
                    DrawCard(t.type_int, true)
                    portrait:toFront()
                    statusText:toFront()

                    if (draw_max <= 1) then
                        Hide_DrawTable()
                    else
                        draw_max = draw_max - 1
                    end

                end
                GameInfo.temp_card.icon:removeSelf()
                GameInfo.temp_card.icon.text:removeSelf()
                t.item_loaded = false
            end
        end
    end

    return true
end

function Hide_DrawTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.draw_screen.card1.icon.isVisible  = false
    GameInfo.draw_screen.card2.icon.isVisible  = false
    GameInfo.draw_screen.card3.icon.isVisible  = false
    GameInfo.draw_screen.card4.icon.isVisible  = false
    GameInfo.draw_screen.card5.icon.isVisible  = false
    GameInfo.draw_screen.card6.icon.isVisible  = false
    TitleText.text = ""
    GameInfo.pause_main = false
    CheckActionPos(false)
end

function Show_DrawTable()
    GameInfo.screen_elements.image.isVisible  = true
    GameInfo.draw_screen.card1.icon.isVisible  = true
    GameInfo.draw_screen.card2.icon.isVisible  = true
    GameInfo.draw_screen.card3.icon.isVisible  = true
    GameInfo.draw_screen.card4.icon.isVisible  = true
    GameInfo.draw_screen.card5.icon.isVisible  = true
    GameInfo.draw_screen.card6.icon.isVisible  = true
    TitleText.text = "Draw Card"
    GameInfo.pause_main = true
    
end

function SetDrawMax(draw_value)
    draw_max = draw_value
    --print("draw value" .. draw_max)
end


function LoadDrawCard()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}

    draw_item.card1 = {}
    draw_item.card2 = {}
    draw_item.card3 = {}
    draw_item.card4 = {}
    draw_item.card5 = {}
    draw_item.card6 = {}

    AddCardZone(draw_item.card1,130,300,"red","weapon",1);
    AddCardZone(draw_item.card2,400,300,"blue","physical",2);
    AddCardZone(draw_item.card3,670,300,"green","focus",3);
    AddCardZone(draw_item.card4,130,570,"yellow","speed",4);
    AddCardZone(draw_item.card5,400,570,"purple","armour",5);
    AddCardZone(draw_item.card6,670,570,"aqua","cheat",6);

    GameInfo.draw_screen = draw_item
    Hide_DrawTable()
end

function AddCardZone(draw_card,x,y,colour,type, type_int)

    local icon = display.newRoundedRect( 
        x, y, 250, 250, 1 )
            icon:setFillColor( colorsRGB.RGB(colour) )
            icon.strokeWidth = 6
            icon:setStrokeColor( 200,200,200,255 )

    icon:addEventListener( "touch", DrawTempCard )
    icon.item_loaded = false
    icon.card_type = type
    icon.type_int = type_int
    draw_card.icon = icon
end