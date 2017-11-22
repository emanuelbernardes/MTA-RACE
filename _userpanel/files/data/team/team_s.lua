function onCreateTeam(player,...)
    local r, g ,b =  math.random(0,255),math.random(0,255),math.random(0,255)
	local playerTeam = getPlayerTeam(player)
	local mess = nil for k,v in pairs({...}) do if mess == nil then mess = v else mess = mess .. " " .. v end end
	mess = mess:gsub("(#%x%x%x%x%x%x)","")
	local playerUser = getAccountName(getPlayerAccount(player))
	if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not player or not mess then
		return callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
	if playerTeam then
		return callClientFunction(player,"createNotify","Voce nao pode criar uma equipe, voce ja esta em uma.",255,0,0)
	end
	if getPlayerTeamStatus(player) then
		return callClientFunction(player,"createNotify","Voce nao pode criar uma equipe, voce ja esta em uma.",255,0,0)
	end
	if string.len(mess) > 28 then
		return callClientFunction(player,"createNotify","Voce nao pode criar uma equipe, maximo de letras 28.",255,0,0)
	end
	if getTeamFromSearchName(mess) then
		callClientFunction(player,"createNotify","Voce nao pode criar uma equipe, ja existe uma com este nome.",255,0,0)
	else
		if getDonatorPlayer(player) or onTakeMoney(player,infos.teamPrice) then
			onCreateNewTeam(player,mess,r,g,b,playerUser,3)
		else
			callClientFunction(player,"createNotify","Voce nao tem dinheiro.",255,0,0)
        end
	end
end
function onDeleteTeam(player)
	local playerTeam = getPlayerTeam(player)
	if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not player then
		return callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
	if not playerTeam then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
	if not getPlayerTeamStatus(player) then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
    if getPlayerLevel(player) < 3 then
		return callClientFunction(player,"createNotify","Voce nao tem acesso para usar este comando.",255,0,0)
	end
	onDestroyTeam(player,getTeamName(playerTeam))
end
function onPlayerQuitTeam(player)
	local playerTeam = getPlayerTeam(player)
	if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not player then
		return callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
	if not playerTeam then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
	if not getPlayerTeamStatus(player) then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
    if getPlayerLevel(player) == 3 then
		return callClientFunction(player,"createNotify","Voce e o dono da equipe, para sair use o botao DELETAR.",255,0,0)
	end
	onQuitTeam(player)
end
function onPlayerKickFromTeam(player,toPlayer)
	local playerTeam = getPlayerTeam(player)
	if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not player or not toPlayer then
		return callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
	if not playerTeam then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
	if not getPlayerTeamStatus(player) then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
	if getPlayerLevel(player) < 3 then
		return callClientFunction(player,"createNotify","Voce nao tem acesso para usar este comando.",255,0,0)
	end
    if getPlayerLevelFromUser(toPlayer) == 3 then
		return callClientFunction(player,"createNotify","Voce e o dono da equipe, para sair use o botao DELETAR.",255,0,0)
	end
	onKickPlayerTeam(player,toPlayer)
end
function onSetPlayerLevelTeam(player,toPlayer,level)
	local playerTeam = getPlayerTeam(player)
	if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not player or not toPlayer or not level then
		return callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
	if not playerTeam then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
	if not getPlayerTeamStatus(player) then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
    if getPlayerLevel(player) < 3 then
		return callClientFunction(player,"createNotify","Voce nao tem acesso para usar este comando.",255,0,0)
	end
	if getPlayerLevelFromUser(toPlayer) == 3 then
		return callClientFunction(player,"createNotify","Voce nao pode alterar o acesso desse jogador.",255,0,0)
	end
	setPlayerLevelTeam(player,toPlayer,level)
end
function onPlayerInvite(player,toPlayer)
	if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
    local toPlayer = getPlayer(toPlayer)
	if not toPlayer then
		return callClientFunction(player,"createNotify","Jogador nao encontrado.",255,0,0)
	end
	if not getPlayerTeamStatus(player) then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
	if getPlayerTeamStatus(toPlayer) then
		return callClientFunction(player,"createNotify","O jogador ja esta em uma equipe.",255,0,0)
	end
	if player == toPlayer then
		return callClientFunction(player,"createNotify","Voce nao pode convidar a si mesmo.",255,0,0)
	end	
	if getElementData(toPlayer,"Invite") == "Enabled" then
		return callClientFunction(player,"createNotify","Este jogador tem um convite pendente.",255,0,0)
	end
	if getPlayerLevel(player) < 2 then
		return callClientFunction(player,"createNotify","Voce nao tem acesso para usar este comando.",255,0,0)
	end
	setElementData(toPlayer,"xInvite","Enabled")
	setElementData(toPlayer,"xTeamName",getTeamName(getPlayerTeam(player)))
	callClientFunction(player,"createNotify","Voce convidou com sucesso o jogador #ffffff"..getPlayerName(toPlayer),0,236,0)
	callClientFunction(toPlayer,"createNotify","Voce recebeu um convite para entrar na equipe "..getElementData(toPlayer,"xTeamName"),0,236,0)
	callClientFunction(toPlayer,"createNotify","Abra o Userpanel para responder!!!",0,236,0)
	_outputChatBox("_s[_wEquipe_s] _wVoce recebeu um convite para entrar na equipe _v"..getElementData(toPlayer,"xTeamName"),toPlayer,255,255,255,true)
    _outputChatBox("_s[_wEquipe_s] _wPara responder abra o Userpanel",toPlayer,255,255,255,true)
end
function onPlayerInvitePending(player,accept)
	if accept then
		if getPlayerTeamStatus(player) then
			return callClientFunction(player,"createNotify","Voce esta em uma equipe.",255,0,0)
	    end
		if getElementData(player,"xInvite") == "Disabled" then
			return callClientFunction(player,"createNotify","Voce nao tem convites pendentes.",255,0,0)
		end
		if getElementData(player,"xInvite") == "Enabled" then
			changePlayerTeam(player,getElementData(player,"xTeamName"),1)
			removeElementData(player,"xInvite")
            removeElementData(player,"xTeamName")
			callClientFunction(player,"createNotify","Voce entrou na equipe com sucesso.",0,236,0)
		end
	else
		if getPlayerTeamStatus(player) then
			return callClientFunction(player,"createNotify","Voce esta em uma equipe.",255,0,0)
	    end
		if getElementData(player,"xInvite") == "Disabled" then
			return callClientFunction(player,"createNotify","Voce nao tem convites pendentes.",255,0,0)
		end
		if getElementData(player,"xInvite") == "Enabled" then
			removeElementData(player,"xInvite")
            removeElementData(player,"xTeamName")
			callClientFunction(player,"createNotify","Voce recusou o convite com sucesso.",255,0,0)
		end
	end
end
function setNewColorTeam(player,type,r,g,b)
	local playerTeam = getPlayerTeam(player)
	if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not player or not type or not r or not g or not b then
		return callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
	if not playerTeam then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
	if not getPlayerTeamStatus(player) then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
    if getPlayerLevel(player) < 3 then
		return callClientFunction(player,"createNotify","Voce nao tem acesso para usar este comando.",255,0,0)
	end
	local teamName = getPlayerTeamName(player)
	if type == 1 then
	    if takeTeamData(teamName,"cash",infos.teamColorPrice1) then
		    onChangeColorTeam(player,1,r,g,b)
	    else
		    callClientFunction(player,"createNotify","A sua equipe nao tem dinheiro.",255,0,0)
	    end
	elseif type == 2 then
	    if takeTeamData(teamName,"cash",infos.teamColorPrice2) then
		    onChangeColorTeam(player,2,r,g,b)
	    else
		    callClientFunction(player,"createNotify","A sua equipe nao tem dinheiro.",255,0,0)
	    end
	end
end
function onSetNewTeamTag(player,tag)
	local playerTeam = getPlayerTeam(player)
	if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not player or not tag then
		return callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
	if not playerTeam then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
	if not getPlayerTeamStatus(player) then
		return callClientFunction(player,"createNotify","Voce nao esta em uma equipe.",255,0,0)
	end
    if getPlayerLevel(player) < 3 then
		return callClientFunction(player,"createNotify","Voce nao tem acesso para usar este comando.",255,0,0)
	end
	if string.len(tag) > 5 then
		return callClientFunction(player,"createNotify","A tag nao criada, maximo de 5 letras.",255,0,0)
	end
	local teamName = getPlayerTeamName(player)
	if takeTeamData(teamName,"cash",infos.teamTagPrice) then
		onChangeNewTeamTag(player,tag)
	else
		callClientFunction(player,"createNotify","A sua equipe nao tem dinheiro.",255,0,0)
	end
end