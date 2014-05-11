
function SetupButtons()
	PlayerHand()
	ScrollBar()
	Tab()
	Finalise_button()
	Portrait()				
end


function PlayerHand()
	print("height: ", display.contentHeight)

	boxwidth = 3000
	boxheight = 360

	GameInfo.hand = display.newRoundedRect(
		GameInfo.portrait_start + boxwidth / 2,
		GameInfo.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	GameInfo.hand:setFillColor( 255, 0, 128 )
	GameInfo.hand.strokeWidth = 6
	GameInfo.hand:setStrokeColor( 200,200,200,255 )
	GameInfo.hand.width = boxwidth
	GameInfo.hand.height = boxheight
	GameInfo.hand.hide = false
	GameInfo.hand.show = false
end

function ScrollBar()
	print("height: ", display.contentHeight)

	boxwidth = GameInfo.hand.width
	boxheight = 100

	bar = display.newRoundedRect(
		GameInfo.portrait_start + boxwidth / 2,
		GameInfo.height - GameInfo.hand.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	bar:setFillColor( 255, 128, 0 )
	bar.strokeWidth = 6
	bar:setStrokeColor( 200,200,200,255 )
		-- Make the button instance respond to touch events
	bar:addEventListener( "touch", onStrafe )
	bar.width = boxwidth
	bar.height = boxheight	
	
end

function Tab()
	boxwidth = 100
	boxheight = 100

	tab = display.newRoundedRect(
		GameInfo.width - boxwidth / 2,
		GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	tab:setFillColor( 0, 128, 128 )
	tab.strokeWidth = 6
	tab:setStrokeColor( 200,200,200,225 )
		-- Make the button instance respond to touch events
	tab:addEventListener( "touch", onStrafe_vert )
	tab.width = boxwidth
	tab.height = boxheight	
	tab.hide_once = true
end

function Finalise_button()
	boxwidth = 300
	boxheight = 100

	finalise_button = display.newRoundedRect(
		GameInfo.portrait_start + boxwidth / 2,
		GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	finalise_button:setFillColor( 1, 1, 1 )
	finalise_button.strokeWidth = 6
	finalise_button:setStrokeColor( 200,200,200,225 )
		-- Make the button instance respond to touch events
	finalise_button.width = boxwidth
	finalise_button.height = boxheight	
	finalise_button:addEventListener( "touch", finishCard )

	--if ( GameInfo.username ~= GameInfo.player_list[GameInfo.current_player].username) then
	--	finalise_button.isVisible = false
	--end
end


function Portrait()
	print("height: ", display.contentHeight)

	portrait = display.newRoundedRect( GameInfo.portrait_start / 2,GameInfo.height - GameInfo.hand.height / 2 ,
		GameInfo.portrait_start,GameInfo.hand.height, 0 )
	portrait:setFillColor( 0, 128, 128 )
	portrait.strokeWidth = 6
	portrait:setStrokeColor( 200,200,200,255 )

end


