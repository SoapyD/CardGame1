


function run_main_loop()

	GameInfo.print_string = ""

	GameInfo.frame_num= GameInfo.frame_num + 1;
    if (GameInfo.frame_num > 60) then
    	GameInfo.frame_num = 0
    end

    --BOUNDS NEEDED TO KEEP THE SYNCING OF SCREEN AND GAME SPACES TOGETHER
    --USED TO KEEP CARDS WITHIN THE TABLE BOUNDS
	boundX1 = -camera.scrollX
	boundX2 = -camera.scrollX + (display.contentWidth / camera.xScale)
	boundY1 = -camera.scrollY
	boundY2 = -camera.scrollY + (display.contentHeight / camera.yScale)


    --INPUTS AND MAIN FUNCTIONS FOR THE GAME
 	run_button_loop()
 	run_card_loop()
 	CheckZoom()

    --RUN THE ACTION LIST LOOP, A SET OF ADVANCING NAMES AND INTERNAL STATES
 	CheckActionState()
 	action_CounterLoop()

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
		button1.x = (GameInfo.touches[1].x  / camera.xScale) - camera.scrollX
		button1.y = (GameInfo.touches[1].y  / camera.yScale) - camera.scrollY
		
	end 
	if ( table.getn(GameInfo.touches) >= 2) then	
		button2.x = (GameInfo.touches[2].x  / camera.xScale) - camera.scrollX
		button2.y = (GameInfo.touches[2].y  / camera.yScale) - camera.scrollY
	end 

	local pos_String = ""
	for i = 1, table.getn(GameInfo.touches) do
		pos_String = pos_String .. "x: " .. GameInfo.touches[i].x .. "y: " .. GameInfo.touches[i].y .. "\n"
	end

	GameInfo.touches = {}	



	--print("text: " .. GameInfo.print_string)
	statusText.text = GameInfo.print_string
	--statusText.text = pos_String
	statusText.x = statusText.width / 2
	--statusText.y = display.contentHeight - statusText.height / 2
	statusText.y = bar.y + (bar.height / 2) - statusText.height / 2


	statusText2.text = GameInfo.print_string2
	statusText2.x = statusText2.width / 2
	statusText2.y = bar2.y + (bar2.height / 2) - statusText2.height / 2


    --CHECK THE NETWORK CONNECTION
    appWarpClient.Loop()

end

