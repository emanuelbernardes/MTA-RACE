function onMapStarting(mapInfo)
	data = false
	if string.find(mapInfo.name,"DM",1,true) then
		data = "dm"
	elseif string.find(mapInfo.name,"DD",1,true) then
		data = "dd"
	elseif string.find(mapInfo.name,"FUN",1,true) then
	    data = "fun"
	end
	for _,player in pairs(getElementsByType("player")) do
		if isPlayerLogged(player) then
			addDataValue(player,data,"1")
			addDataValue(player,"mapsPlayed","1")
			onMissionDriveMaps(player)
		end
	end
	startBet()
end
addEvent("onMapStarting",true)
addEventHandler("onMapStarting",root,onMapStarting)
function changeNick(arg1,arg2)
	if arg2 and isPlayerLogged(source) then
		setDataValue(source,"playerName",arg2)
		updatePlayerNameInTeamTable(source,arg2)
	end
end
addEventHandler("onPlayerChangeNick",root,changeNick)
function getHunter(pickupID,pickupType,pickupModel)
	if pickupType == "vehiclechange" then
	    local model = getElementModel(getPedOccupiedVehicle(source))
	    if pickupModel == 425 and model ~= 425 and getElementData(source,"state") == "alive" then
		    addHunterBonus(source)
		end
	end
end
addEvent("onPlayerPickUpRacePickup",true)
addEventHandler("onPlayerPickUpRacePickup",root,getHunter)
function addHunterBonus(player)
	if isPlayerLogged(player) then
	    addDataValue(player,"cash","500")
		addDataValue(player,"points","5")
		addDataValue(player,"Hunter","1")
		_outputChatBox("_s[_wHunter_s] _wVoce ganhou $500 e 5 pontos por pegar hunter.",player,255,255,255,true)
	end
end
function getTopTime(player,newPosition)
    local newPosition = tonumber(newPosition)
	if isPlayerLogged(player) then
		if newPosition <= 8 then
			local cashToEarn = (11-newPosition)*50
			local expToEarn = (11-newPosition)
			addDataValue(player,"cash",cashToEarn)
		    addDataValue(player,"points",expToEarn)
			addDataValue(player,"topTime","1")
			_outputChatBox("_s[_wTopTime_s] _wVoce ganhou $"..cashToEarn.." e "..expToEarn.." pontos por pegar toptime.",player,255,255,255,true)
		end
	end
end
addEvent("onPlayerToptimeImprovement",true)
addEventHandler("onPlayerToptimeImprovement",root,getTopTime)
function earnMoneyForDeath(whatPosition,player)
    if isPlayerLogged(player) then
	    local posMin = 9
	    local playerCount = #getElementsByType("player")
		if playerCount < 8 then
		    posMin = playerCount + 1
		end
	    if infos.minPlayer >= playerCount then
			return _outputChatBox("_s[_wEarn_s] _wSistema pausado! Minimo "..infos.minPlayer.." jogadores para ativa-lo.",player,255,255,255,true)
		end 
	    if whatPosition == 1 then
		    local expToEarn = posMin
		    local cashToEarn = posMin*40
			addDataValue(player,"cash",cashToEarn)
		    addDataValue(player,"points",expToEarn)
			onMissionEarnCash(player,cashToEarn)
			earnTeamExpAndCash(player,expToEarn,cashToEarn)
			_outputChatBox("_s[_wEarn_s] _wVoce ganhou $"..cashToEarn.." e "..expToEarn.." pontos.",player,255,255,255,true)
		elseif whatPosition <= 8 then
		    local expToEarn = posMin-whatPosition
		    local cashToEarn = (posMin-whatPosition)*40
			addDataValue(player,"cash",cashToEarn)
		    addDataValue(player,"points",expToEarn)
			onMissionEarnCash(player,cashToEarn)
			earnTeamExpAndCash(player,expToEarn,cashToEarn)
			_outputChatBox("_s[_wEarn_s] _wVoce ganhou $"..cashToEarn.." e "..expToEarn.." pontos.",player,255,255,255,true)
		else
		    _outputChatBox("_s[_wEarn_s] _wSeja mais Rapido! Apenas os 8 primeiros ganham cash e pontos.",player,255,255,255,true)
		end
	end
end
addEvent("onPlayerDeadInRace",true)
addEventHandler("onPlayerDeadInRace",root,earnMoneyForDeath)
function earnTeamExpAndCash(player,exp,cash)
    if isPlayerLogged(player) then
	    if not getPlayerTeam(player) then return end
	    local teamName = getPlayerTeamName(player)
		addTeamData(teamName,"exp",exp)
		addTeamData(teamName,"cash",cash)
	end
end