--[[
Project: Perspective
Author: Caleb P
Version: 1.4.2

A library for easily and smoothly integrating a virtual camera into your game.

Changes for v1.4.2
	Fixes/Updates -
		- Fixed a problem with damping and parallax
		- Added "setParallax" function
		- Converted damping algorithm from division to multiplication
		- Moved all the view's "special" values to a single table
	Notes - 
		- I converted the damping algorithm from division to multiplication because multiplication is faster. The new approach is entirely internal; you don't need to change anything.
		- Please do not edit the values inside the camera's "_PERSPECTIVE_PRIVATE_VALUES" table, on pain of possible unexpected results!
--]]

local abs			= math.abs
local inf			= math.huge
local ng			= display.newGroup
local ccx			= display.contentCenterX
local ccy			= display.contentCenterY
local cw			= display.contentWidth
local ch			= display.contentHeight
local drm			= display.remove


local Perspective={
	version="1.4.2",
	author="Caleb P - Gymbyl Coding"
}

function Perspective.createView(numLayers)
	--Localize variables
	local view
	local layer
	local isTracking


	--Check for manual layer count
	numLayers=(type(numLayers)=="number" and numLayers) or 8


	--Variables
	isTracking=false -- Local so that you can't change it and mess up the view's inner workings
	layer={}


	--Create the camera view
	view=ng()
		view.scrollX=0
		view.scrollY=0
		view.damping=10
		view._PERSPECTIVE_PRIVATE_VALUES={
			x1=0,
			x2=cw,
			y1=0,
			y2=ch,
			prevDamping=10,
			damping=0.1
		}


	--Create the layers
	for i=numLayers, 1, -1 do
		layer[i]=ng()	
		layer[i].parallaxRatio=1 -- Parallax
		layer[i]._isPerspectiveLayer=true -- Just a flag for future updates, not sure what I'm going to do with it
		view:insert(layer[i])
	end

	
	--Function to add objects to camera
	function view:add(obj, l, isFocus)
		local isFocus=isFocus or false
		local l=l or 4
		
		layer[l]:insert(obj)
		obj.layer=l

		if isFocus==true then
			view._PERSPECTIVE_PRIVATE_VALUES.focus=obj
		end
		
		--Moves an object to a layer
		function obj:toLayer(newLayer)
			if layer[newLayer] then
				layer[newLayer]:insert(obj)
				obj._perspectiveLayer=newLayer
			end
		end
		
		--Moves an object back a layer
		function obj:back()
			if layer[obj._perspectiveLayer+1] then
				layer[obj._perspectiveLayer+1]:insert(obj)
				obj._perspectiveLayer=obj.layer+1
			end
		end
			
		--Moves an object forwards a layer
		function obj:forward()
			if layer[obj._perspectiveLayer-1] then
				layer[obj._perspectiveLayer-1]:insert(obj)
				obj._perspectiveLayer=obj.layer-1
			end
		end
		
		--Moves an object to the very front of the camera
		function obj:toCameraFront()
			layer[1]:insert(obj)
			obj._perspectiveLayer=1
			obj:toFront()
		end

		--Moves an object to the very back of the camera
		function obj:toCameraBack()
			layer[numLayers]:insert(obj)
			obj._perspectiveLayer=numLayers
			obj:toBack()
		end
	end


	--View's tracking function
	function view.trackFocus()
		--Make damping a number to multiply by, instead of divide
		if view._PERSPECTIVE_PRIVATE_VALUES.prevDamping~=view.damping then
			view._PERSPECTIVE_PRIVATE_VALUES.prevDamping=view.damping
			view._PERSPECTIVE_PRIVATE_VALUES.damping=1/view.damping -- Set up multiplication damping
		end

		if view._PERSPECTIVE_PRIVATE_VALUES.focus then
			layer[1].parallaxRatio=1
			view.scrollX, view.scrollY=layer[1].x, layer[1].y
			for i=1, numLayers do

				------------------------------------------------------------------------
				-- Track X-Axis
				------------------------------------------------------------------------
				if view._PERSPECTIVE_PRIVATE_VALUES.focus.x<=view._PERSPECTIVE_PRIVATE_VALUES.x2 and view._PERSPECTIVE_PRIVATE_VALUES.focus.x>=view._PERSPECTIVE_PRIVATE_VALUES.x1 then
					if view.damping~=0 then
						layer[i].x=(layer[i].x-(layer[i].x-(-view._PERSPECTIVE_PRIVATE_VALUES.focus.x+ccx)*layer[i].parallaxRatio)*view._PERSPECTIVE_PRIVATE_VALUES.damping)
					else
						layer[i].x=-view._PERSPECTIVE_PRIVATE_VALUES.focus.x+ccx*layer[i].parallaxRatio
					end
				else
					if abs(view._PERSPECTIVE_PRIVATE_VALUES.focus.x-view._PERSPECTIVE_PRIVATE_VALUES.x1)<abs(view._PERSPECTIVE_PRIVATE_VALUES.focus.x-view._PERSPECTIVE_PRIVATE_VALUES.x2) then
						if view.damping~=0 then
							layer[i].x=(layer[i].x-(layer[i].x-(-view._PERSPECTIVE_PRIVATE_VALUES.x1+ccx)*layer[i].parallaxRatio)*view._PERSPECTIVE_PRIVATE_VALUES.damping)
						else
							layer[i].x=-view._PERSPECTIVE_PRIVATE_VALUES.x1+ccx*layer[i].parallaxRatio
						end
					elseif abs(view._PERSPECTIVE_PRIVATE_VALUES.focus.x-view._PERSPECTIVE_PRIVATE_VALUES.x1)>abs(view._PERSPECTIVE_PRIVATE_VALUES.focus.x-view._PERSPECTIVE_PRIVATE_VALUES.x2) then
						if view.damping~=0 then
							layer[i].x=(layer[i].x-(layer[i].x-(-view._PERSPECTIVE_PRIVATE_VALUES.x2+ccx)*layer[i].parallaxRatio)*view._PERSPECTIVE_PRIVATE_VALUES.damping)
						else
							layer[i].x=-view._PERSPECTIVE_PRIVATE_VALUES.x2+ccx*layer[i].parallaxRatio
						end
					end
				end

				------------------------------------------------------------------------
				-- Track Y-Axis
				------------------------------------------------------------------------
				if view._PERSPECTIVE_PRIVATE_VALUES.focus.y<=view._PERSPECTIVE_PRIVATE_VALUES.y2 and view._PERSPECTIVE_PRIVATE_VALUES.focus.y>=view._PERSPECTIVE_PRIVATE_VALUES.y1 then
					if view.damping~=0 then
						layer[i].y=(layer[i].y-(layer[i].y-(-view._PERSPECTIVE_PRIVATE_VALUES.focus.y+ccy)*layer[i].parallaxRatio)*view._PERSPECTIVE_PRIVATE_VALUES.damping)
					else
						layer[i].y=-view._PERSPECTIVE_PRIVATE_VALUES.focus.y+ccy*layer[i].parallaxRatio
					end
				else
					if abs(view._PERSPECTIVE_PRIVATE_VALUES.focus.y-view._PERSPECTIVE_PRIVATE_VALUES.y1)<abs(view._PERSPECTIVE_PRIVATE_VALUES.focus.y-view._PERSPECTIVE_PRIVATE_VALUES.y2) then
						if view.damping~=0 then
							layer[i].y=(layer[i].y-(layer[i].y-(-view._PERSPECTIVE_PRIVATE_VALUES.y1+ccy)*layer[i].parallaxRatio)*view._PERSPECTIVE_PRIVATE_VALUES.damping)
						else
							layer[i].y=-view._PERSPECTIVE_PRIVATE_VALUES.y1+ccy*layer[i].parallaxRatio
						end
					elseif abs(view._PERSPECTIVE_PRIVATE_VALUES.focus.y-view._PERSPECTIVE_PRIVATE_VALUES.y1)>abs(view._PERSPECTIVE_PRIVATE_VALUES.focus.y-view._PERSPECTIVE_PRIVATE_VALUES.y2) then
						if view.damping~=0 then
							layer[i].y=(layer[i].y-(layer[i].y-(-view._PERSPECTIVE_PRIVATE_VALUES.y2+ccy)*layer[i].parallaxRatio)*view._PERSPECTIVE_PRIVATE_VALUES.damping)
						else
							layer[i].y=-view._PERSPECTIVE_PRIVATE_VALUES.y2+ccy*layer[i].parallaxRatio
						end
					end
				end

			end
		end
	end
	

	--Start tracking
	function view:track()
		if not isTracking then
			isTracking=true
			Runtime:addEventListener("enterFrame", view.trackFocus)
		end
	end
	

	--Stop tracking
	function view:cancel()
		if isTracking then
			Runtime:removeEventListener("enterFrame", view.trackFocus)
			isTracking=false
		end
	end
	

	--Set bounding box dimensions
	function view:setBounds(x1, x2, y1, y2)
		local x=x1
		local x2=x2
		local y=y1
		local y2=y2
		
		if type(x)=="boolean" then
			view._PERSPECTIVE_PRIVATE_VALUES.x1, view._PERSPECTIVE_PRIVATE_VALUES.x2, view._PERSPECTIVE_PRIVATE_VALUES.y1, view._PERSPECTIVE_PRIVATE_VALUES.y2=-inf, inf, -inf, inf
		else
			view._PERSPECTIVE_PRIVATE_VALUES.x1, view._PERSPECTIVE_PRIVATE_VALUES.x2, view._PERSPECTIVE_PRIVATE_VALUES.y1, view._PERSPECTIVE_PRIVATE_VALUES.y2=x1, x2, y1, y2
		end

		return "bounds set"
	end
	

	--Move camera to an (x,y) point
	function view:toPoint(x, y)
		local x=x or ccx
		local y=y or ccy
		
		view:cancel()
		local tempFocus={x=x, y=y}
		view:setFocus(tempFocus)
		view:track()

		return tempFocus
	end
	

	--Set the view's focus
	function view:setFocus(obj)
		view._PERSPECTIVE_PRIVATE_VALUES.focus=obj
	end
	

	--Get a layer
	function view:layer(t)
		return layer[t]
	end


	--Set parallax easily for each layer
	function view:setParallax(...)
		for i=1, #arg do layer[i].parallaxRatio=arg[i] end
	end


	--Remove an object from the camera
	function view:remove(obj)
		if obj~=nil and layer[obj._perspectiveLayer]~=nil then
			layer[obj._perspectiveLayer]:remove(obj)
    end
  end
	

	--Destroy the camera
	function view:destroy()
		for n=1, numLayers do
			for i=1, #layer[n] do
				layer[n]:remove(layer[n][i])
			end
		end
		
		if isTracking then
			Runtime:removeEventListener("enterFrame", view.trackFocus)
		end
		drm(view)
		view=nil
		return "deleted view"
	end

	return view
end

return Perspective