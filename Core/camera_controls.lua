
local perspective=require("Core.perspective")
camera=perspective.createView()

camera:setBounds(-5000,5000, -5000,5000)

print_string = ""
statusText = display.newText( print_string, 100, display.contentHeight / 2, native.systemFontBold, 48 )


--camera:add(icon, 4, false) --Add an onject to the camera: object, layer, isfocus
--camera:setFocus(icon) --Seperately set focus on an item
--camera:track() --Track the focal point