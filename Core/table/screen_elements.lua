
function Setup_ScreenElements()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}
    draw_item.image = display.newImage(group, "Images/" .. "black marble.jpg", 
        1200 / 2, 1600 / 2)  

    TitleText = display.newText( "", 
        display.contentWidth / 2, 100, native.systemFontBold, 68 )

    GameInfo.screen_elements = draw_item
end