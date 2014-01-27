
function networkSetup()
	-- create global warp client and initialize it
	appWarpClient = require "AppWarp.WarpClient"

	-- Replace these with the values from AppHQ dashboard of your AppWarp app
	API_KEY = "439c555cc07424fcefa72589975e9e8047c720c155577151937969cf23c113b1"
	SECRET_KEY = "1d85a06cf2105700dc78f697fe6eb896d8d86640c64e06e4b4abde8c5b2108f8"
	STATIC_ROOM_ID = "1402891999"

	appWarpClient.initialize(API_KEY, SECRET_KEY)
end

function networkConnection()
	-- do the appwarp client related handling in a separate file
	require "Network.warplisteners"

	--statusText = display.newText( "Connecting..", 100, display.contentHeight, native.systemFontBold, 24 )
	--statusText.width = 300
	-- start connecting with a random name
	GameInfo.username  = tostring(os.clock())
	appWarpClient.connectWithUserName(GameInfo.username)
	--print(GameInfo.username)
end
