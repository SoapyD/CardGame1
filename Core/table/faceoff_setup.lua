local sub_action = ""

function Hide_FOTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.faceoff_screen.player1.isVisible  = false
    GameInfo.faceoff_screen.player2.isVisible  = false
    TitleText.text = ""
    GameInfo.pause_add = 0
    CheckActionPos(false)
end

function Show_FOTable(temp_sub_action)
    GameInfo.screen_elements.image.isVisible  = true
    GameInfo.faceoff_screen.player1.isVisible  = true
    GameInfo.faceoff_screen.player2.isVisible  = true
    TitleText.text = "Face-Off!"
    sub_action = temp_sub_action
    GameInfo.pause_add = 2

    --print(sub_action)
end

function LoadFaceOff()
    local group = display.newGroup()
    -- width, height, x, y
    local faceoff_item = {}

    AddPlayerZone(faceoff_item);
    GameInfo.faceoff_screen = faceoff_item

    Show_FOTable()
    --Hide_FOTable()
end

function AddPlayerZone(faceoff_item)

    faceoff_item.player1 = display.newRoundedRect( 
        (GameInfo.width / 2) - 200, (GameInfo.height / 2) - 100, 360,360, 1 )
            faceoff_item.player1:setFillColor( colorsRGB.RGB("red") )
            faceoff_item.player1.strokeWidth = 6
            faceoff_item.player1:setStrokeColor( 200,200,200,255 )

    faceoff_item.player2 = display.newRoundedRect( 
        (GameInfo.width / 2) + 200, (GameInfo.height / 2) - 100, 360, 360, 1 )
            faceoff_item.player2:setFillColor( colorsRGB.RGB("blue") )
            faceoff_item.player2.strokeWidth = 6
            faceoff_item.player2:setStrokeColor( 200,200,200,255 )
end