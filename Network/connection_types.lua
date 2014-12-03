
function Setup_Connection()
	networkSetup(); --NEEDED FOR ALL CONNECTIONS
	networkConnection(); --NEEDED FOR ALL CONNECTIONS
	GameInfo.gamestate = GameInfo.gamestate + 1
end