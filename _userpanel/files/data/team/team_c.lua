team = {
    alpha = 0,
	progress = 0
}
manage = {
	team = false
}
teamInformation = {}
teamCashRank ={}
teamRepuRank ={}
function updateTeamAllInfos(info,info2)
	cache = info
	data = info
	teamInformation = info2
end
function refreshTeamRanking(tab1,tab2)
    teamCashRank = tab1
    teamRepuRank = tab2
end
function teamInterface()
    team.progress = team.progress+0.005
    if label.gang  == true then
	    team.alpha = interpolateBetween(team.alpha,0,0,1,0,0,team.progress,"Linear")
		if team.alpha == 1 then
		    team.progress = 0
		end
	end
	if label.gang  == false then
	    team.alpha = interpolateBetween(team.alpha,0,0,0,0,0,team.progress,"Linear")
		if team.alpha == 0 then
		    team.progress = 0
		    removeEventHandler("onClientRender",root,teamInterface)
		end  
	end
	dxDrawImage(_sX,_sY,resY(30),resY(30),"files/img/team.png",0,0,0,tocolor(232,232,232,255*team.alpha))
	dxText("Equipe",_sX+resY(30),_sY+resY(2),sX,sY,230,230,230,255*team.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
	if not manage.team then
		createButton(_sX+resX(500),_sY+resY(32),resX(198),resY(28),"Editar Equipe",70,130,180,team.alpha,dxFont(15))
		dxText("Aqui voce pode comprar a sua equipe..",_sX+resX(34),_sY+resY(410),sX,sY,menu.r,menu.g,menu.b,100*team.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
		createEditBox(_sX+resX(36),_sY+resY(438),resX(664),resY(28),team.alpha,dxFont(15),"editTeamName","Nome da Equipe")
		createButton(_sX+resX(267),_sY+resY(469),resX(200),resY(28),"Comprar - $50000",0,255,0,team.alpha,dxFont(15))
		dxText("Ranking Reputacao da Equipe",_sX+resX(34),_sY+resY(65),_sX+resX(700),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"center","top",true,false,false,false)
		dxText("Ranking Dinheiro da Equipe",_sX+resX(34),_sY+resY(240),_sX+resX(700),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"center","top",true,false,false,false)
		for i=1,7 do
		    local posY = _sY+resY(71)+(i*resY(21))
			if #teamRepuRank ~= 0 and teamRepuRank[i] then
			    dxText(i..". "..teamRepuRank[i].name.." ("..teamRepuRank[i].countPlayers.." players)",_sX+resX(36),posY,sX,sY,255,255,255,255*team.alpha,1.0,dxFont(13),"left","top",true,false,false,false)
				dxText(teamRepuRank[i].data,_sX,posY,_sX+resX(696),sY,255,255,255,255*team.alpha,1.0,dxFont(13),"right","top",true,false,false,false)
			else
			    dxText(i..". - Nao encontrado.",_sX+resX(36),posY,sX,sY,255,255,255,255*team.alpha,1.0,dxFont(13),"left","top",true,false,false,false)
			end
			posY = posY+resY(175)
			if #teamCashRank ~= 0 and teamCashRank[i] then
			    dxText(i..". "..teamCashRank[i].name.." ("..teamCashRank[i].countPlayers.." players)",_sX+resX(36),posY,sX,sY,255,255,255,255*team.alpha,1.0,dxFont(13),"left","top",true,false,false,false)
				dxText(teamCashRank[i].data,_sX,posY,_sX+resX(696),sY,255,255,255,255*team.alpha,1.0,dxFont(13),"right","top",true,false,false,false)
			else
			    dxText(i..". - Nao encontrado.",_sX+resX(36),posY,sX,sY,255,255,255,255*team.alpha,1.0,dxFont(13),"left","top",true,false,false,false)
			end
		end
	else
	    dxGrid.posX = _sX+resX(34)
	    dxGrid.posY = _sY+resY(31)
	    showDxGridlist(team.alpha)
	    createButton(_sX+resX(500),_sY+resY(32),resX(198),resY(28),"Voltar",255,0,0,team.alpha,dxFont(15))
		if #teamInformation ~= 0 then
		    dxText(teamInformation[1][4].." "..teamInformation[1][1],_sX+resX(204),_sY+resY(65),_sX+resX(698),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"center","top",true,false,false,false)
			dxText("Reputacao",_sX+resX(204),_sY+resY(85),sX,sY,255,255,255,255*team.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
			dxText(teamInformation[1][2],_sX+resX(204),_sY+resY(85),_sX+resX(698),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"right","top",true,false,false,false)
			dxText("Dinheiro",_sX+resX(204),_sY+resY(105),sX,sY,255,255,255,255*team.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
			dxText("$"..teamInformation[1][3],_sX+resX(204),_sY+resY(105),_sX+resX(698),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"right","top",true,false,false,false)
		end
		createButton(_sX+resX(204),_sY+resY(130),resX(494),resY(25),"Selecione a cor aqui antes de comprar!",pickColor.r,pickColor.g,pickColor.b,team.alpha,dxFont(15))
		dxText("Cor da Equipe",_sX+resX(204),_sY+resY(155),sX,sY,255,255,255,255*team.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
		dxText("Comprar Rainbow.",_sX+resX(204),_sY+resY(175),sX,sY,255,255,255,255*team.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
		createButton(_sX+resX(515),_sY+resY(157),resX(183),resY(24),"1St Comprar - $40000",0,236,0,team.alpha,dxFont(15))
		createButton(_sX+resX(515),_sY+resY(182),resX(183),resY(24),"2St Comprar - $500000",0,236,0,team.alpha,dxFont(15))
		dxText("TAG da Equipe",_sX+resX(204),_sY+resY(200),_sX+resX(698),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"center","top",true,false,false,false)
		createEditBox(_sX+resX(285),_sY+resY(226),resX(166),resY(24),team.alpha,dxFont(14),"teamTag","Nova TAG")
		createButton(_sX+resX(457),_sY+resY(226),resX(166),resY(24),"Comprar - $20000",0,236,0,team.alpha,dxFont(15))
		dxText("Convidar Jogador",_sX+resX(204),_sY+resY(250),_sX+resX(698),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"center","top",true,false,false,false)
		for i, data in ipairs(editBox) do if data.editName == "getNick" then data.text = table.concat(text[i],"") player = getPlayer(data.text) if player and data.text ~= "" then name = getPlayerName(player) else name = "None" end end end
		createEditBox(_sX+resX(285),_sY+resY(278),resX(166),resY(24),team.alpha,dxFont(14),"getNick","Procurar..")
		dxText("Select : "..string.gsub(name,"(#%x%x%x%x%x%x)",""),_sX+resX(280),_sY+resY(303),sX,sY,255,255,255,255*team.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
		createButton(_sX+resX(457),_sY+resY(292),resX(166),resY(24),"Convidar",0,236,0,team.alpha,dxFont(15))
		createButton(_sX+resX(364),_sY+resY(474),resX(166),resY(24),"Sair",255,0,0,team.alpha,dxFont(15))
		createButton(_sX+resX(532),_sY+resY(474),resX(166),resY(24),"Deletar",255,0,0,team.alpha,dxFont(15))
		local select = getElementData(localPlayer,"dxGridLineSelec")
		if select and #data > 0 and team.alpha >= 0.9 then
		    dxText("Editar Acesso",_sX+resX(204),_sY+resY(332),_sX+resX(698),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"center","top",true,false,false,false)
			dxText("Selecionado : "..string.gsub(data[select][1],"(#%x%x%x%x%x%x)",""),_sX+resX(204),_sY+resY(352),_sX+resX(698),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"center","top",true,false,false,false)
			dxText("Acesso do Jogador : "..data[select][3],_sX+resX(204),_sY+resY(372),_sX+resX(698),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"center","top",true,false,false,false)
			dxText("Adicionar Previlegio",_sX+resX(204),_sY+resY(392),_sX+resX(698),sY,255,255,255,255*team.alpha,1.0,dxFont(15),"center","top",true,false,false,false)
			createButton(_sX+resX(285),_sY+resY(420),resX(166),resY(24),"1 - Membro",70,130,180,team.alpha,dxFont(15))
		    createButton(_sX+resX(457),_sY+resY(420),resX(166),resY(24),"2 - Recrutador",70,130,180,team.alpha,dxFont(15))
		    createButton(_sX+resX(532),_sY+resY(447),resX(166),resY(24),"Remover Jogador",255,0,0,team.alpha,dxFont(15))
		end
	end
end
function closeTeamPage2(argument)
    if argument then
	    teamState = true
	else
    	manage.team = false
		teamState = false
	end
end
function buttonTeamInterface(button,state)
	if ( button == "left" and state == "down" ) then
		boxClick = false
		return false
    end
	if isMousePosition(_sX+resX(500),_sY+resY(32),resX(198),resY(28)) then
	    text = {}
	    for i,_ in ipairs(editBox) do
    	    table.insert(text,{})
	    end
	    if teamState then
	        if not manage.team then
		        manage.team = true
				startDxGridlist({},_sX,_sY,resX(164),resY(467),17,dxFont(15),"searchMember")
				callServerFunction("getTeamAllStatus",localPlayer)
		    else
		        manage.team = false
		    end
		else
            createNotify("Voce nao tem equipe.",255,0,0)
	    end
	end
	if not manage.team then
		for i,box in ipairs(editBox) do
	    	if isMousePosition(_sX+resX(36),_sY+resY(438),resX(664),resY(28)) then
			    if box.editName == "editTeamName" then
				    boxClick = i
				end
	   	    end
			if isMousePosition(_sX+resX(267),_sY+resY(469),resX(200),resY(28)) then
			    if box.editName == "editTeamName" then
		    	    if box.text ~= "" then
	        	        callServerFunction("onCreateTeam",localPlayer,box.text)
					end
				end
			end	
		end
	else
	    for i,box in ipairs(editBox) do	
	    	if isMousePosition(_sX+resX(285),_sY+resY(226),resX(166),resY(24)) then
			    if box.editName == "teamTag" then
				    boxClick = i
				end
	   	    end
		    if isMousePosition(_sX+resX(457),_sY+resY(226),resX(166),resY(24)) then
		    	if box.editName == "teamTag" then
		    	    if box.text ~= "" then
	        	        callServerFunction("onSetNewTeamTag",localPlayer,box.text)
					end	
				end
			end
			if isMousePosition(_sX+resX(285),_sY+resY(278),resX(166),resY(24)) then
			    if box.editName == "getNick" then
				    boxClick = i
				end
	   	    end
			if isMousePosition(_sX+resX(457),_sY+resY(292),resX(166),resY(24)) then
		    	if box.editName == "getNick" then
		    	    if box.text ~= "" then
	        	        callServerFunction("onPlayerInvite",localPlayer,box.text)
					end	
				end
			end
		end
		if isMousePosition(_sX+resX(204),_sY+resY(130),resX(494),resY(25)) then
	        colorPicker.create("1","#FFFFFF","Selecionar cor")
	    end
		if isMousePosition(_sX+resX(515),_sY+resY(157),resX(183),resY(24)) then
		    callServerFunction("setNewColorTeam",localPlayer,1,pickColor.r,pickColor.g,pickColor.b)
		end
		if isMousePosition(_sX+resX(515),_sY+resY(182),resX(183),resY(24)) then
		    callServerFunction("setNewColorTeam",localPlayer,2,pickColor.r,pickColor.g,pickColor.b)
		end
		if isMousePosition(_sX+resX(364),_sY+resY(474),resX(166),resY(24)) then
		    callServerFunction("onPlayerQuitTeam",localPlayer)
		end
		if isMousePosition(_sX+resX(532),_sY+resY(474),resX(166),resY(24)) then
		    callServerFunction("onDeleteTeam",localPlayer)
		end
		local select = getElementData(localPlayer,"dxGridLineSelec")
		if select then
		    if isMousePosition(_sX+resX(532),_sY+resY(447),resX(166),resY(24)) then
			    callServerFunction("onPlayerKickFromTeam",localPlayer,data[select][2])
			end
			if isMousePosition(_sX+resX(285),_sY+resY(420),resX(166),resY(24)) then
			    callServerFunction("onSetPlayerLevelTeam",localPlayer,data[select][2],1)
			end
			if isMousePosition(_sX+resX(457),_sY+resY(420),resX(166),resY(24)) then
			    callServerFunction("onSetPlayerLevelTeam",localPlayer,data[select][2],2)
			end
		end
	end
end