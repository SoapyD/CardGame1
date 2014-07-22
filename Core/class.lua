--===========================
--THE SETCLASS FUNCTION IS IN THE INC_CLASS FILE. WHICH IS A METHOD IS INITIALISING CLASSES

cGameInfo=setclass("GameInfo")

function cGameInfo.methods:init(gamestate) 
	self.gamestate = gamestate
	self.fps = 60
	self.frame_num = 0
	self.myButtons = {}
	self.cards = {}
	self.table_cards = {}
	self.height = display.actualContentHeight
	self.width = display.actualContentWidth
	self.world_width = 10
	self.world_height = 10
	self.current_card_int = -1
	self.previous_card_int = -1
	self.faceoff_int = -1
	self.selected_card = {}

	self.zoom = 0.75
	self.portrait_start = 400; --NEEDED FOR THE POSITIONING OF PLAYER HAND BUTTONS
	self.username = ""
	self.touches  = {}
	self.zoom_dis  = 0
	self.zoom_saved  = 0
	self.new_camera_pos = {}

	self.screen_elements = {}
	self.screen_elements2 = {}

	self.table_items = {}
	self.faceoff_screen = {}
	self.counter_screen = {}
	self.draw_screen = {}
	self.discard_screen = {}
	self.limb_screen = {}
	self.or_screen = {}

	self.temp_card = {}

	self.quads = {}

	--MULTIPLAYER VALUES
	self.player_list = {}
	self.opponent_ready = false
	self.attacker_ready = false
	self.player_1_id = ""
	self.current_player = 1

	self.print_string = ""
	self.print_string2 = ""
	self.print_string3= ""

	self.actions = {}
	self.saved_actions = {}
	self.switch1 = false
	self.pause_main = false
	self.pause_add = 0

	self.finalise_state = 1	--recently changed, didn't have a self. intil 20/07/14

	self.end_game = false
	self.winner = -1
	self.loser = -1
	self.end_round = false
	--self.round_damage = 0

	self.card_group = display.newGroup()
end

--{ x=50, y=10, w=100, h=100, r=10, red=255, green=0, blue=128, id = 1 },

cButtonClass=setclass("ButtonClass")

function cButtonClass.methods:init(x,y,w,h,r,red,green,blue,id) 
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.r = r
	self.red = red
	self.green = green
	self.blue = blue
	self.id = id
end