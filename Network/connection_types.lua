
function QuickMatch_Connection()
	print("QUICK MATCH CONNECTION")
	networkSetup();
	networkConnection(); 
	GameInfo.gamestate = GameInfo.gamestate + 1
end