function DonateManager(player,cmd,subcmd,toPlayer,days)
    if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not isPlayerOnGroup(player) then
	    return callClientFunction(player,"createNotify","Voce nao e administrador.",255,0,0)
	end
	if not toPlayer then
	    return callClientFunction(player,"createNotify","Comando errado, use /donator [add/remove] [nick] [dias]",255,0,0)
	end
	local toPlayer = getPlayer(toPlayer)
	if not toPlayer then
		return callClientFunction(player,"createNotify","Jogador nao encontrado.",255,0,0)
	end
	if not isPlayerLogged(toPlayer) then
		return callClientFunction(player,"createNotify","O jogador nao esta logado.",255,0,0)
	end
	if subcmd == "add" then
	    local days = tonumber(days)
	    if not days then
	        return callClientFunction(player,"createNotify","Numero de dias nao informado.",255,0,0)
	    end
		addPlayerDonator(toPlayer,days)
		callClientFunction(player,"createNotify","Voce adicionou o jogador "..getPlayerName(toPlayer).." #ffffffao donator com sucesso.",0,236,0)
	elseif subcmd == "remove" then
	    removePlayerDonator(toPlayer,getPlayerName(player))
	    callClientFunction(player,"createNotify","Voce removeu o donator do jogador "..getPlayerName(toPlayer).." #ffffff com sucesso.",0,236,0)
	else
	    callClientFunction(player,"createNotify","Comando errado, use /donator [add/remove] [nick] [dias]",255,0,0)
	end
end
addCommandHandler("donator",DonateManager)
function buyDonatorDay(player,days)
    if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not player or not days then
		return callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
	if onTakeMoney(player,infos.donator) then
        addPlayerDonator(player,days)
	else
		callClientFunction(player,"createNotify","Voce nao tem dinheiro",255,0,0)
	end
end
function secoundsToDays(secound)
	if secound then
		local value,state
		if secound >= 86400 then
			value = math.floor(secound/86400)
			if secound - (value*86400) > (60*60) then
				value = value.." dias e "..math.floor((secound - (value*86400))/(60*60)).." horas"
			else
				value = value.." dias"
			end
			state = 1
		else
			value = 0 .." dias e "..math.floor(secound/(60*60)).." horas"
			state = 2
		end
		return value
	else
		return false
	end
end