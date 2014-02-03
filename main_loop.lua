
function run_main_loop()

	GameInfo.frame_num= GameInfo.frame_num + 1;
    if (GameInfo.frame_num > 60) then
    	GameInfo.frame_num = 0
    end

    --BOUNDS NEEDED TO KEEP THE SYNCING OF SCREEN AND GAME SPACES TOGETHER
	boundX1 = -camera.scrollX
	boundX2 = -camera.scrollX + (display.contentWidth / camera.xScale)
	boundY1 = -camera.scrollY
	boundY2 = -camera.scrollY + (display.contentHeight / camera.yScale)


    --CREATE TOOLS TO KEEP THE CARD AND SCROLL IT UP AND DOWN THE SCREEN
 	run_button_loop()
 	run_card_loop()
 	CheckZoom()



 	--SOME TEMPORARY DRAWN BUTTONS I'M USING TO TEST THE CAMERA AND IT'S SPACING
	button1.x = -camera.scrollX
	button1.y = -camera.scrollY
	button2.x = -camera.scrollX + (display.contentWidth / camera.xScale)
	button2.y = -camera.scrollY
	button3.x = -camera.scrollX 
	button3.y = -camera.scrollY + (display.contentHeight / camera.yScale)
	button4.x = -camera.scrollX + (display.contentWidth / camera.xScale)
	button4.y = -camera.scrollY + (display.contentHeight / camera.yScale)

	if ( table.getn(GameInfo.touches) >= 1) then
		--local parent = GameInfo.touches[1].parent
		--parent:insert( GameInfo.touches[1] )
		--button1.isFocus = true
		button1.x = (GameInfo.touches[1].x  / camera.xScale) - camera.scrollX
		button1.y = (GameInfo.touches[1].y  / camera.yScale) - camera.scrollY
		
	end 
	if ( table.getn(GameInfo.touches) >= 2) then
		--local parent = GameInfo.touches[2].parent
		--parent:insert( GameInfo.touches[2] )
		--button2.isFocus = true		
		button2.x = (GameInfo.touches[2].x  / camera.xScale) - camera.scrollX
		button2.y = (GameInfo.touches[2].y  / camera.yScale) - camera.scrollY
	end 

	print_string = "CameraX:" .. math.round(camera.scrollX)
	print_string = print_string .. "\nCameraY:" .. math.round(camera.scrollY)
	print_string = print_string .. "\nTouches:" .. table.getn(GameInfo.touches)
	print_string = print_string .. "\nZoom:" .. GameInfo.zoom_dis
	--print_string = print_string .. "\nTable:" .. GameInfo.table_item.x .. "," .. GameInfo.table_item.y
	--print_string = print_string .. "\nTouches:" .. CountDictionary(GameInfo.touches)

	GameInfo.touches = {}	

	statusText.text = print_string
	statusText.x = statusText.width / 2
	statusText.y = display.contentHeight - statusText.height / 2
	--print("cameraX1:",camera.scrollX)

    --CHECK THE NETWORK CONNECTION
    appWarpClient.Loop()

end