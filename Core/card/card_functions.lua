
function onTouch( event )
		--print("touch")
		local t = event.target
		local phase = event.phase

		if (t.finalised == false and 
			(GameInfo.username == GameInfo.player_list[GameInfo.current_player].username and
			GameInfo.pause_main == false) or
			(GameInfo.pause_add > 0 and GameInfo.pause_main == false)) then
			if "began" == phase then
				-- Make target the top-most object
				local parent = t.parent
				parent:insert( t )
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				-- Store initial position

				if (t.drawn == false) then
					t.x0 = event.x - t.x
					t.y0 = event.y - t.y
				else
					t.x0 = (event.x / camera.xScale) - t.x
					t.y0 = (event.y / camera.xScale) - t.y
				end
				t.moved = true
				--print("moved: " , t.moved)
				t.touched = true
				--GameInfo.hand.hide = true

				--print("touched")
			elseif t.isFocus then
				if "moved" == phase then
					-- Make object move (we subtract t.x0,t.y0 so that moves are
					-- relative to initial grab point, rather than object "snapping").
					t.x = (event.x / camera.xScale) - t.x0
					t.y = (event.y / camera.xScale) - t.y0

					if (t.drawn == false) then
						t.x = event.x - t.x0
						t.y = event.y - t.y0
					else
						t.x = (event.x / camera.xScale) - t.x0
						t.y = (event.y / camera.xScale) - t.y0
					end

				elseif "ended" == phase or "cancelled" == phase then
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
		      		--If the card is being placed from the hand, add it to the table
		      		--then make the "hand card" non-visible
		      		if (GameInfo.pause_add == 0) then
			      		if (t.drawn == false) then
							--Update_Pos2(t.unique_id, t.filename, t.x, t.y)
							Update_Pos3(t.unique_id, t.filename, t.sheet, t.sprite, t.x, t.y)
							t.isVisible = false
							--print("pos not checked")
						else
							if (t ~= nil) then
							local pos_info = CheckBoard_Pos(t)
							--print("checking pos: " .. table.getn(GameInfo.quads))
							Check_Quad_Region(t, pos_info[3], true)
							GameInfo.hand.hide = false
						end
						end
					end
					--DISCARD CARD STATE
					if (GameInfo.pause_add == 1) then 
						if (t.x > GameInfo.discard_screen.card1.icon.bbox_min_x and
							t.x < GameInfo.discard_screen.card1.icon.bbox_max_x and
							t.y > GameInfo.discard_screen.card1.icon.bbox_min_y and
							t.y < GameInfo.discard_screen.card1.icon.bbox_max_y) then
								t.isVisible = false
								CheckDiscard(t)
						end
					end

					--FACEOFF STATE
					if (GameInfo.pause_add == 2) then
						for i=1, table.getn(GameInfo.cards) do
							local card = GameInfo.cards[i]
							if(card.isVisible == true 
								and card.touched == true and card.moved == false) then
								card.touched = false
							end
						end

						for i=1, table.getn(GameInfo.player_list) do
							if (GameInfo.username == GameInfo.player_list[i].username
								and t.y < GameInfo.height - 350) then
								if ( i == 1 ) then
									t.x = GameInfo.faceoff_screen.player1.x
									t.y = GameInfo.faceoff_screen.player1.y
								end
								if ( i == 2 ) then
									t.x = GameInfo.faceoff_screen.player2.x
									t.y = GameInfo.faceoff_screen.player2.y
								end

								GameInfo.faceoff_int = t.id
								GameInfo.player_list[i].faceoff_card = t.filename

								local current_player = GetPlayer()
								local card_info = retrieve_card(t.filename)
								local allow_placement = true

							    if (card_info.arms > current_player.arms) then
							        run_popup("Can't use card, need " .. card_info.arms .. " arm/s.")
							        allow_placement = false
							    end
							    if (card_info.legs > current_player.legs) then
							        run_popup("Can't use card, need " .. card_info.legs .. " leg/s.")
							        allow_placement = false
							    end

							    if ( allow_placement == true) then
							    	finalise_button.isVisible = true
							    	finalise_button.text.isVisible = true
							    else
							    	finalise_button.isVisible = false
							    	finalise_button.text.isVisible = false
							    end
							end
						end
					end

					--COUNTER STATE
					if (GameInfo.pause_add == 3) then
						for i=1, table.getn(GameInfo.cards) do
							local card = GameInfo.cards[i]
							if(card.isVisible == true 
							and card.touched == true 
							and card.moved == false) then
								card.touched = false
							end
						end

						for i=1, table.getn(GameInfo.player_list) do
							if (GameInfo.username == GameInfo.player_list[i].username
								and t.y < GameInfo.height - 350) then
								
								t.x = GameInfo.counter_screen.player1.x
								t.y = GameInfo.counter_screen.player1.y

								GameInfo.faceoff_int = t.id
								GameInfo.player_list[i].faceoff_card = t.filename 
							end
						end
					end

					--LIMB DISCARD CARD STATE
					if (GameInfo.pause_add == 4) then 
						if (t.x > GameInfo.limb_discard_screen.card1.icon.bbox_min_x and
							t.x < GameInfo.limb_discard_screen.card1.icon.bbox_max_x and
							t.y > GameInfo.limb_discard_screen.card1.icon.bbox_min_y and
							t.y < GameInfo.limb_discard_screen.card1.icon.bbox_max_y) then
								t.isVisible = false
								CheckLimbDiscard(t, "cripple_arm")
						end
						if (t.x > GameInfo.limb_discard_screen.card2.icon.bbox_min_x and
							t.x < GameInfo.limb_discard_screen.card2.icon.bbox_max_x and
							t.y > GameInfo.limb_discard_screen.card2.icon.bbox_min_y and
							t.y < GameInfo.limb_discard_screen.card2.icon.bbox_max_y) then
								t.isVisible = false
								CheckLimbDiscard(t, "cripple_leg")
						end
					end

					t.moved = false
				end
			end
		end

		--THIS ALLOWS ME TO KEEP TRACK OF CARD SELECTIONS
		if (t.finalised == true) then
			if "began" == phase then
				-- Make target the top-most object
				local parent = t.parent
				parent:insert( t )
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				-- Store initial position

				--print("touched")
			elseif t.isFocus then
				if "moved" == phase then


				elseif "ended" == phase or "cancelled" == phase then
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false

					GameInfo.selected_card = t
					run_popup(t.filename .. " card selected")
				end
			end
		end

		--GameInfo.touches[ table.getn(GameInfo.touches)+1 ] = event
		return true
end

--ALLOW THE CARDS PLACED ON THE TABLE TO BE ROTATED IF CLICKED ON
function tapRotateLeftButton( e )
    local t = e.target

    if (t.finalised == false) then
    	--print("rotate")
	    if ( t.rotation == 0 or t.rotation == -90 or 
	    	t.rotation == -180 or t.rotation == -270) then
	    	transition.to(t, {time=250,
	    	--rotation= t.rotation -90.0, onComplete=UpdateRotation(t)})
			--t.rotation = t.rotation - 90

			rotation= t.rotation -90.0, onComplete=function()
    		timer.performWithDelay(250, UpdateRotation(t),1)end })
		end
	end
end

function UpdateRotation(t)
	--print("updating rotation")

	if ( t.rotation <= -360 ) then
		t.rotation = 0
	end

	local pos_info = CheckBoard_Pos(t)
	Check_Quad_Region(t, pos_info[3], true)
	--SEND AN UPDATE TO THE OTHER PLAYERS THAT THE CARD'S ROTATING AND BY WHAT ANGLE
	QueueMessage(
	--appWarpClient.sendUpdatePeers(
        --tostring("MSG_CODE") .. " " ..
		tostring("rotation") .. " " ..
		tostring(t.unique_id) .. " " .. 
		tostring(GameInfo.username) .. " " ..		
		--tostring(t.rotation - 90))
		tostring(t.rotation))
end

function CheckBoard_Pos(card)
	local used_x = card.x
	local used_y = card.y
	local x_space = 350		
	local y_space = 350

	x_itts = used_x / x_space
	y_itts = used_y / y_space

	x_itts = math.round(x_itts) + 1
	y_itts = math.round(y_itts)
	section_num = x_itts + (y_itts * GameInfo.world_width)

	--verticle card, y must be ODD, x must be EVEN
	--horizontal card, y must be EVEN, x must be ODD
	--divide end position values by 2 to get the table grid reference
	local return_info = {}
	return_info[1] = x_itts 
	return_info[2] = y_itts
	return_info[3] = section_num
	return return_info
end