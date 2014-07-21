
function Hide_EndTable()
    GameInfo.screen_elements.image.isVisible  = false
    TitleText.text = ""
end

function Show_EndTable()
    GameInfo.screen_elements.image.isVisible  = true
    TitleText.text = "RESETTING GAME"

end