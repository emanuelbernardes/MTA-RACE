function getServerPlayers(player)
    local info = {}
    for _,players in pairs(getElementsByType("player")) do
	    if isPlayerLogged(players) then
		    table.insert(info,{getPlayerName(players),players})
		end
	end
	callClientFunction(player,"updatePlayerList",info)
end