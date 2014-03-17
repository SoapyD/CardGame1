
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

local connection_state = 0
local connection_count = 120
local internal_count = 0

function player_check()

    CheckState = switch { 
        [0] = function()    --CHECK PLAYERS ARE CONNECTED

                if (GameInfo.attacker_ready == true and
                    GameInfo.opponent_ready == true) then
                    print("opponent ready")
                    connection_state = connection_state + 1
                    internal_count = 0
                end

                if (internal_count >= connection_count) then
                    appWarpClient.sendUpdatePeers(
                    tostring("check_player") .. " " ..
                    tostring(GameInfo.username))

                    print("sending: " .. GameInfo.username)
                    --connection_state = connection_state + 1
                    internal_count = 0
                end
            end,
        [1] = function()    --ADD EACH PLAYER TO THE LIST
                if (internal_count >= connection_count) then
                    appWarpClient.sendUpdatePeers(
                    tostring("add_player") .. " " ..
                    tostring(GameInfo.username))
                           
                    if (table.getn(GameInfo.player_list) >= 2) then
                        connection_state = connection_state + 1  
                    end

                    internal_count = 0
                end
            end,
        [2] = function() --DECIDE THE ORDER OR PLAY

                if (internal_count >= connection_count) then
                    if (GameInfo.player_1_id == "") then
                        appWarpClient.sendUpdatePeers(
                        tostring("set_player_1") .. " " ..
                        tostring(GameInfo.username))                    
                    end

                    if (GameInfo.player_1_id ~= "") then
                        connection_state = connection_state + 1  
                    end

                    internal_count = 0
                end
            end,
        [3] = function() --ADVANCE THE GAMESTATE
                local temp_list = {}
                local arr_pos = -1
                
                for i=1, table.getn(GameInfo.player_list) do
                    if (GameInfo.player_list[i].username == GameInfo.player_1_id) then
                        arr_pos = i
                        temp_list[table.getn(temp_list) + 1] = GameInfo.player_list[i]
                    end
                end

                local current_arr = arr_pos + 1
                local run_loop = true
                while run_loop == true do
                    if ( current_arr > table.getn(GameInfo.player_list)) then
                        current_arr = 1
                    end

                    if (current_arr == arr_pos) then
                        run_loop = false
                    else
                        temp_list[table.getn(temp_list) + 1] = GameInfo.player_list[current_arr]
                    end 

                    current_arr = current_arr + 1
                end
                GameInfo.player_list = temp_list
                --for i=1, table.getn(temp_list) do
                --    print("temp_name " .. i .. ":" .. temp_list[i].username)
                --end
        		GameInfo.gamestate = GameInfo.gamestate + 1
            end,
        default = function () print( "ERROR - connection_state not within switch") end,
    }

    internal_count = internal_count + 1
    CheckState:case(connection_state)

    appWarpClient.Loop()

end
