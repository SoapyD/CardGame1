function LoadFaceOff()
    local group = display.newGroup()
    -- width, height, x, y
    local faceoff_item = {}
    faceoff_item.image = display.newImage(group, "Images/" .. "black marble.jpg", 
        1200 / 2, 1600 / 2)  

    AddPlayerZone(faceoff_item);
    --faceoff_item.image.isVisible  = false

    GameInfo.faceoff_screen = faceoff_item
end

function AddPlayerZone(faceoff_item)

    TitleText = display.newText( "FaceOff", 
        display.contentWidth / 2, 100, native.systemFontBold, 68 )


    faceoff_item.player1 = display.newRoundedRect( 
        (GameInfo.width / 2) - 200, (GameInfo.height / 2), 250, 500, 1 )
            faceoff_item.player1:setFillColor( colorsRGB.RGB("red") )
            faceoff_item.player1.strokeWidth = 6
            faceoff_item.player1:setStrokeColor( 200,200,200,255 )

    faceoff_item.player2 = display.newRoundedRect( 
        (GameInfo.width / 2) + 200, (GameInfo.height / 2), 250, 500, 1 )
            faceoff_item.player2:setFillColor( colorsRGB.RGB("blue") )
            faceoff_item.player2.strokeWidth = 6
            faceoff_item.player2:setStrokeColor( 200,200,200,255 )
end