
function Setup_ScreenElements()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}
    draw_item.image = display.newImage(group, "Images/" .. "black marble.jpg", 
        1200 / 2, 1600 / 2)  

    TitleText = display.newText( "", 
        display.contentWidth / 2, 200, native.systemFontBold, 68 )

    GameInfo.screen_elements = draw_item


    draw_item = {}
    draw_item.image = display.newImage(group, "Images/" .. "black marble2.jpg", 
        1200 / 2, 1600 / 2)  

    TitleText2 = display.newText( "", 
        display.contentWidth / 2, 200, native.systemFontBold, 68 )

    GameInfo.screen_elements2 = draw_item

end