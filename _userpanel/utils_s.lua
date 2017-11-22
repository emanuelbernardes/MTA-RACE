function getPlayer(playerPart)
	local pl = getPlayerFromName(playerPart)
	if isElement(pl) then
		return pl
	else
		for i,v in ipairs (getElementsByType("player")) do
			if (string.find(getPlayerName(v):lower(),playerPart:lower())) then
				return v
			elseif (string.find(string.gsub(getPlayerName(v),"#%x%x%x%x%x%x",""):lower(),playerPart:lower())) then
				return v
			end
		end
	end
end
function GiveCash(player,cmd,toPlayer,amount)
    local amount = tonumber(amount)
    if not player or not toPlayer or not amount then
	    return _outputChatBox("_s[_rERRO_s] _wComando valido '/give nick valor'.",player,255,255,255,true)
	end
	local toPlayer = getPlayer(toPlayer)
	if not toPlayer then
	    return _outputChatBox("_s[_rERRO_s] _wJogador nao encontrado.",player,255,255,255,true)
	end
	if not isPlayerLogged(player) then
	    return _outputChatBox("_s[_rERRO_s] _wVoce nao esta logado.",player,255,255,255,true)
	end
	if not isPlayerLogged(toPlayer) then
	    return _outputChatBox("_s[_rERRO_s] _wJogador nao esta logado.",player,255,255,255,true)
	end
	if player == toPlayer then
	    return _outputChatBox("_s[_rERRO_s] _wVoce nao pode doar para si mesmo.",player,255,255,255,true)
	end
	if ( amount < 1 ) then
		return _outputChatBox("_s[_rERRO_s] _wValor invalido.",player,255,255,255,true)
	end
	if onTakeMoney(player,amount) then
	    addDataValue(toPlayer,"cash",amount)
		_outputChatBox("_s[_wGive_s] _wVoce doou $"..amount.." para o jogador "..getPlayerName(toPlayer),player,255,255,255,true)
		_outputChatBox("_s[_wGiveE_s] _wVoce recebeu $"..amount.." do jogador "..getPlayerName(player),toPlayer,255,255,255,true)
	else
	    _outputChatBox("_s[_rERRO_s] _wVoce nao tem dinheiro.",player,255,255,255,true)
	end
end	
addCommandHandler("give",GiveCash)
playerSpin = {}
function spinEvent(player,cmd,amount)
    local amount = tonumber(amount)
	if not player or not amount then
	    return _outputChatBox("_s[_rERRO_s] _wComando valido '/spin valor'.",player,255,255,255,true)
	end
	if not isPlayerLogged(player) then
	    return _outputChatBox("_s[_rERRO_s] _wVoce nao esta logado.",player,255,255,255,true)
	end
	if ( amount < 1 ) or ( amount >  tonumber (infos.maxSpin) ) then
	    return _outputChatBox("_s[_rERRO_s] _wValor da aposta deve ser entre $1 a $"..infos.maxSpin..".",player,255,255,255,true)
	end
	if playerSpin[player] then
	    local remaining = getTimerDetails(playerSpin[player])
		return _outputChatBox("_s[_rERRO_s] _wVoce nao pode apostar agora! Espere "..math.floor(remaining/1000).." segundos.",player,255,0,0,true)
	end
	if onTakeMoney(player,amount) then
	    local playerLuck = math.random(1,2)
		if playerLuck == 1 then
		    amount = amount*2
		    addDataValue(player,"cash",amount)
		    _outputChatBox("_s[_wSpin_s] _wVoce apostou e _vganhou _w$"..amount,player,255,255,255,true)
		else
		    _outputChatBox("_s[_wSpin_s] _wVoce apostou e _rperdeu _w$"..amount,player,255,255,255,true)
		end
		addDataValue(player,"spin",1)
		playerSpin[player] = setTimer(resetSpin,30000,1,player)
	else
	    _outputChatBox("_s[_rERRO_s] _wVoce nao tem dinheiro.",player,255,255,255,true)
	end
end
addCommandHandler("spin",spinEvent)
function resetSpin(player)
	if isTimer(playerSpin[player]) then 
	    killTimer(playerSpin[player]) 
	end
	playerSpin[player] = nil
end
local betTick = false
function betEvent(player,cmd,toPlayer,amount)
    local amount = tonumber(amount)
    if not player or not toPlayer or not amount then
	    return _outputChatBox("_s[_rERRO_s] _wComando valido /bet nick valor.",player,255,255,255,true)
	end
	if not isPlayerLogged(player) then
	    return _outputChatBox("_s[_rERRO_s] _wVoce nao esta logado.",player,255,255,255,true)
	end
	toPlayer = getPlayer(toPlayer)
	if not toPlayer then
	    return _outputChatBox("_s[_rERRO_s] _wJogador nao encontrado.",player,255,255,255,true)
	end
	if player == toPlayer then
	    return _outputChatBox("_s[_rERRO_s] _wVoce nao pode apostar em si mesmo.",player,255,255,255,true)
	end
	if infos.minPlayer >= getPlayerCount() then
	    return _outputChatBox("_s[_wBet_s] _wSistema pausado! Minimo "..infos.minPlayer.." jogadores para ativa-lo.",player,255,0,0,true)
	end
	if ( amount < 1 ) or ( amount > tonumber ( infos.maxBet ) ) then
	    return _outputChatBox("_s[_rERRO_s] _wValor do bet deve ser entre $1 a $"..infos.maxBet..".",player,255,255,255,true)
	end
	if betTick < getTickCount() then
		return _outputChatBox("_s[_rERRO_s] _wTempo para aposta ja foi esgotado.",player,255,0,0,true)
	end
	if getElementData(player,'playerBet') then
		return _outputChatBox("_s[_rERRO_s] _wVoce ja fez uma aposta.",player,255,255,255,true)
	end
	if onTakeMoney(player,amount) then
		local betTable = {}
		betTable.cash = amount*2
		betTable.toPlayer = toPlayer
		setElementData(player,'playerBet',betTable)
		addDataValue(player,"bet",1)
		_outputChatBox("_s[_wBet_s] _w"..getPlayerName(player).."_w apostou $"..amount.." no jogador "..getPlayerName(toPlayer),root,255,255,255,true)
	else
		_outputChatBox("_s[_rERRO_s] _wVoce nao tem dinheiro.",player,255,255,255,true)
	end
end
addCommandHandler("bet",betEvent)
function startBet()
	betTick = getTickCount()+30000
	_outputChatBox("_s[_wBet_s] _wFaçam suas apostas!",root,255,255,255,true)
	setTimer(function() _outputChatBox("_s[_wBet_s] _wTempo para realizar a aposta foi esgotado!",root,255,255,255,true) end, 30000,1)
	for _,player in pairs(getElementsByType("player")) do
		setElementData(player,'playerBet',false)
	end
end
function checkBetWinner(playerWon)
	for _,player in pairs(getElementsByType("player")) do
		if getElementData( player, 'playerBet') then
			local betTable = getElementData( player, 'playerBet')
			if betTable.toPlayer == playerWon then
			    addDataValue(player,"cash",betTable.cash)
				_outputChatBox("_s[_wBet_s] _w"..getPlayerName(player).." _vganho _w$"..betTable.cash.." by Bet!",root,255,255,255,true)
			end
			setElementData(player,'playerBet',false)
		end
	end
end
addEvent("onPlayerDeadWinBet",true)
addEventHandler("onPlayerDeadWinBet",root,checkBetWinner)
function dataEdit (player,cmd,toPlayer,type,data,value)
    value = tonumber(value)
    if not isPlayerLogged(player) then
	    return _outputChatBox("_s[_rERRO_s] _wVoce nao esta logado.",player,255,255,255,true)
	end
    local account = getAccountName( getPlayerAccount( player ) )
	if not isObjectInACLGroup("user." .. account, aclGetGroup("Admin")) then
	    return _outputChatBox("_s[_rERRO_s] _wVoce nao e administrador.",player,255,255,255,true)
	end
	if not toPlayer and not type and not data and not value then
	    _outputChatBox("_s[_rERRO_s] _wComando valido /data nick [add/set] [data] [valor].",player,255,255,255,true)
		_outputChatBox("_s[_rERRO_s] _wTipos de data: points,cash,dm,dd,dun,mapsPlayed,Hunter,topTime,bet,spin.",player,255,255,255,true)
	    return
	end
	toPlayer = getPlayer(toPlayer)
	if not toPlayer then
	    return _outputChatBox("_s[_rERRO_s] _wJogador nao encontrado.",player,255,255,255,true)
	end
	if not isPlayerLogged(toPlayer) then
	    return _outputChatBox("_s[_rERRO_s] _wJogador nao esta logado.",player,255,255,255,true)
	end
	if type == "add" then
	    if veData(player,data) then
		    if not value then return _outputChatBox("_s[_rERRO_s] _wValor invalido.",player,255,255,255,true) end
		    addDataValue(toPlayer,data,value)
			_outputChatBox("_s[_bDb_s] _wVoce adicionou o valor "..tostring(value).." na data "..data.." do jogador "..getPlayerName(toPlayer),player,255,255,255,true)
		end
	elseif type == "set" then
	    if veData(player,data) then
		    if not value then return _outputChatBox("_s[_rERRO_s] _wValor invalido.",player,255,255,255,true) end
		    setDataValue(toPlayer,data,value)
			_outputChatBox("_s[_bDb_s] _wVoce mudou o valor para "..tostring(value).." na data "..data.." do jogador "..getPlayerName(toPlayer),player,255,255,255,true)
		end
	else
	    _outputChatBox("_s[_rERRO_s] _wComando invalido.",player,255,255,255,true)
	end
end
addCommandHandler("db",dataEdit)
function veData(player,data)
    if data == "points" or data == "cash" or data == "dm" or data == "dd" or data == "fun" or data == "mapsPlayed" or data == "Hunter" or data == "topTime" or data == "bet" or data == "spin" then
    	return true
    else
        _outputChatBox("_s[_rERRO_s] _wDatas validas: points,cash,dm,dd,dun,mapsPlayed,Hunter,topTime,bet,spin.",player,255,255,255,true)
        return false
    end
end
local msValues = {
	day = 86400000,
	hour = 3600000,
	minute = 60000,
}
function msToTimeString(playedTime)
	if playedTime then
		local days = math.floor(playedTime/msValues.day)
		local playedTime = playedTime - (msValues.day*days)
		local hours = math.floor(playedTime/msValues.hour)
		local playedTime = playedTime - (msValues.hour*hours)
		local minutes = math.floor(playedTime/msValues.minute)
		return days.." dias, "..hours.." horas, "..minutes.." minutos"
	end
end
function formatValue( value)
    return tonumber(string.format("%."..(0).."f",value))
end