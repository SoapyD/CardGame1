function SetGame()
    --portrait:toFront()
    statusText:toFront()
    statusText2:toFront()
    --GameInfo.screen_elements2:toFront()
    --statusText3:toFront()

	--for i = 1, table.getn(GameInfo.cards) do
	--	local hand_card = GameInfo.cards[i]
	--	hand_card:toFront()
	--end

	--MAKE FINALISATION BUTTON NON VISIBLE FOR BOTH PLAYERS NOW
    --if ( GameInfo.username ~= GameInfo.player_list[1].username) then
    --	finalise_button.isVisible = false
    --	finalise_button.text.isVisible = false
    --end

    --check_FinalisationButton(1)
end


function loadGame()
	--HERE'S WHERE WE CAN LOAD ANYTHING THAT ONLY NEEDS INITIALISING
	GameInfo.print_string = ""
	statusText = display.newText( GameInfo.print_string, 100, display.contentHeight / 2, native.systemFontBold, 48 )
	statusText:setFillColor( 0, 0, 0 )

	GameInfo.print_string2 = ""
	statusText2 = display.newText( GameInfo.print_string2, 100, 0, native.systemFontBold, 48 )
	statusText2:setFillColor( 0, 0, 0 )


	--MAIN GAME STUFF

	print( "LOAD INFO")
	--MAXIMUM 2000x2000 SCALE TEXTURES. THE BOARD IS LOADED IN 4 PARTS
	LoadTable( "table2" .. ".jpg",875,875);
	LoadTable( "table2" .. ".jpg",2625,875);
	LoadTable( "table2" .. ".jpg",875,2625);
	LoadTable( "table2" .. ".jpg",2625,2625);
	--THEN THE CAMERA IS SET TO THE MIDDLE OF THOSE SECTIONS
	camera:toPoint(1750, 1750)
	camera.damping = 0
	--SET THE MARKERS
	setBoards();

	Load_GameTypeScreen()

	EndBounds();
	createDeck();
	Setup_ScreenElements()
	LoadDrawCard();
	LoadDiscardCard();
	--LoadLimbTable();
	LoadFaceOff();
	LoadCounter();
	--LoadLimbDiscardCard();
	LoadOptions();
	
	--SetupButtons();
	--run_main_loop() --NEEDS TO RUN ONCE IN THE LOAD GAME LOOP
	Reset_SetCards_state()
	createMsgBox()

	--SCREEN STUFF
	Load_CharacterScreen()


	ResetAnimationState()

	--ADVANCE THE GAMESTATE
	GameInfo.gamestate = GameInfo.gamestate + 1
end


function EndBounds()
	button1 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button1:setFillColor( colorsRGB.RGB("green") )
			button1.strokeWidth = 6
			button1:setStrokeColor( 200,200,200,255 )

    camera:add(button1, 1, false)

	button2 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button2:setFillColor( colorsRGB.RGB("green") )
			button2.strokeWidth = 6
			button2:setStrokeColor( 200,200,200,255 )

    camera:add(button2, 1, false)

	button3 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button3:setFillColor( colorsRGB.RGB("green"))
			button3.strokeWidth = 6
			button3:setStrokeColor( 200,200,200,255 )

    camera:add(button3, 1, false)

	button4 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button4:setFillColor( colorsRGB.RGB("green") )
			button4.strokeWidth = 6
			button4:setStrokeColor( 200,200,200,255 )

    camera:add(button4, 1, false)        

end
