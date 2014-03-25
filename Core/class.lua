--===========================
--THE SETCLASS FUNCTION IS IN THE INC_CLASS FILE. WHICH IS A METHOD IS INITIALISING CLASSES

cGameInfo=setclass("GameInfo")

function cGameInfo.methods:init(gamestate) 
	self.gamestate = gamestate
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

	self.pause_main = false

	self.zoom = 0.75
	self.portrait_start = 400; --NEEDED FOR THE POSITIONING OF PLAYER HAND BUTTONS
	self.username = ""
	self.touches  = {}
	self.zoom_dis  = 0
	self.zoom_saved  = 0
	self.table_items = {}
	self.faceoff_screen = {}
	self.draw_screen = {}
	self.temp_card = {}

	self.quads = {}

	--MULTIPLAYER VALUES
	self.player_list = {}
	self.opponent_ready = false
	self.attacker_ready = false
	self.player_1_id = ""
	self.current_player = 1

	self.print_string = ""

	self.switch1 = false

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