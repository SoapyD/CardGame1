
local perspective=require("Core.perspective")
camera=perspective.createView()

camera:setBounds(-5000,5000, -5000,5000)


camera.xScale = GameInfo.zoom
camera.yScale = GameInfo.zoom

print_string = ""
statusText = display.newText( print_string, 100, display.contentHeight / 2, native.systemFontBold, 48 )


--camera:add(icon, 4, false) --Add an onject to the camera: object, layer, isfocus
--camera:setFocus(icon) --Seperately set focus on an item
--camera:track() --Track the focal point


function CheckZoom()

	if (table.getn(GameInfo.touches) >= 2) then
		local x = GameInfo.touches[1].x - GameInfo.touches[2].x
		local y = GameInfo.touches[1].y - GameInfo.touches[2].y		
		local zoom =  math.sqrt((x * x) + (y * y))

		if ( zoom > 50) then
			GameInfo.zoom_dis = zoom			
		end

		if(GameInfo.zoom_saved ~= 0) then
			GameInfo.zoom =  GameInfo.zoom - ((GameInfo.zoom_saved - GameInfo.zoom_dis) / 500)
			camera.xScale = GameInfo.zoom
			camera.yScale = GameInfo.zoom
		end

		GameInfo.zoom_saved = GameInfo.zoom_dis
	else
		GameInfo.zoom_saved = 0
		GameInfo.zoom_dis = 0
	end

end