local options = 
{
    --parent = textGroup,
    --if (MsgBox ~= nil) then
    text = "",    
    x = 0,
    y = 0,
    width = 500,     --required for multi-line and alignment
    font = native.systemFontBold,   
    fontSize = 48,
    align = "center"  --new alignment parameter
--end
}

--function run_popup(message)
--    MsgText.text = MsgText.text .. "\n" .. message
--    MsgBox.fade = 2	
--end

function run_popup(message)
    MsgText.text = message
    MsgBox.fade = 2	
end

function clear_popup()
	MsgBox.msg_fade = 0
	MsgBox.fade = 0
	MsgBox:setFillColor( colorsRGB.RGB("white"),MsgBox.msg_fade )
	MsgBox:setStrokeColor( 200,200,200,MsgBox.msg_fade )
	MsgText:setFillColor( colorsRGB.RGB("black"), MsgBox.msg_fade)
	MsgText.text = ""
end

function createMsgBox()

	local width = display.contentWidth 
	local height = display.contentHeight

	local middle_x = width / 2
	local middle_y = height / 2 - ((height / 2) * 0.6)

	GameInfo.msg_string = ""
	MsgBox = display.newRoundedRect( middle_x, middle_y, 500, 200, 0 )
	MsgBox:setFillColor( colorsRGB.RGB("white"),0 )
	MsgBox.strokeWidth = 6
	MsgBox:setStrokeColor( 200,200,200,0 )
	MsgBox.fade = 0
	MsgBox.msg_fade = 0
	MsgBox.msg_timer = 0

	--MsgText = display.newText( 
	--	MsgBox.msg_string, middle_x, middle_y, 500, 200, native.systemFontBold, 48, "center" )
	MsgText = display.newText( options )
	MsgText.x = middle_x
	MsgText.y = middle_y

	MsgText:setFillColor( colorsRGB.RGB("black"), 0)

	Runtime:addEventListener( "enterFrame", setMsgFade )
end


function setMsgFade()

	if ( MsgBox ~= nil) then

		local fade_adjusted = false
		local itts = 0.05

		if (MsgBox.fade == 1) then
			if (MsgBox.msg_fade > 0) then
				MsgBox.msg_fade = MsgBox.msg_fade - itts
			else
				MsgBox.msg_fade = 0
				MsgText.text = ""
			end
			fade_adjusted = true
		end

		if (MsgBox.fade == 2) then
			if (MsgBox.msg_fade < 1) then
				MsgBox.msg_fade = MsgBox.msg_fade + itts
			else
				MsgBox.msg_fade = 1
			end
			fade_adjusted = true
		end

		if (fade_adjusted == true and (MsgBox.fade == 1 or MsgBox.fade == 2)) then
			MsgBox:setFillColor( colorsRGB.RGB("white"),MsgBox.msg_fade )
			MsgBox.strokeWidth = 6
			MsgBox:setStrokeColor( 200,200,200,MsgBox.msg_fade )

			MsgText:setFillColor( colorsRGB.RGB("black"), MsgBox.msg_fade)

			if (MsgBox.fade == 2 and MsgBox.msg_fade == 1) then
				MsgBox.fade = 0
				MsgBox.msg_timer = GameInfo.fps * 3
			end
			if (MsgBox.fade == 1 and MsgBox.msg_fade == 0) then
				MsgBox.fade = 0
			end
		end

		--NOW KEEP A TIMER THAT WILL MAKE THE BOX FADE ONCE IT'S COMPLETE
		if (MsgBox.msg_timer > 0) then
			MsgBox.msg_timer = MsgBox.msg_timer - 1
			--print("mesasge timer " .. MsgBox.msg_timer)			
			if ( MsgBox.msg_timer <= 0) then
				MsgBox.fade = 1
			end
		else
			MsgBox.msg_timer = 0
		end

	end

	if (MsgText ~= nil) then
		options.text = MsgBox.msg_string
	end
end