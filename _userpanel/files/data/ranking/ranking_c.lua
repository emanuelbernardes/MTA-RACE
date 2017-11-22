ranking = {
    alpha = 0,
	progress = 0,
	subMenu = false
}
showRanking = {}
buttons = {
    {"Pontos","points",true},
	{"Dinheiro","cash",false},
	{"Hunter","Hunter",false},
	{"Top Times","topTime",false},
	{"Mapas Jogados","mapsPlayed",false},
	{"DM Jogados","dm",false},
	{"DD Jogados","dd",false},
	{"FUN Jogados","fun",false},
	{"Online","online",false},
	{"Spin","spin",false},
	{"Bet","bet",false}
}
function clearRanking()
    for i=1,11 do
		buttons[i][3] = false
	end
    showRanking = {}
end
function refreshRanking(info)
    showRanking = info
end
function rankingInterface()
    ranking.progress = ranking.progress+0.005
    if label.ranking  == true then
	    ranking.alpha = interpolateBetween(ranking.alpha,0,0,1,0,0,ranking.progress,"Linear")
		if ranking.alpha == 1 then
		    ranking.progress = 0
		end
	end
	if label.ranking  == false then
	    ranking.alpha = interpolateBetween(ranking.alpha,0,0,0,0,0,ranking.progress,"Linear")
		if ranking.alpha == 0 then
		    ranking.progress = 0
		    removeEventHandler("onClientRender",root,rankingInterface)
		end  
	end
	dxDrawImage(_sX,_sY,resY(30),resY(30),"files/img/ranking.png",0,0,0,tocolor(232,232,232,255*ranking.alpha))
	dxText("Ranking",_sX+resY(30),_sY+resY(2),sX,sY,230,230,230,255*ranking.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
	dxDrawRectangle(_sX+resX(34),_sY+resY(32),resX(664),resY(30),tocolor(0,0,0,60*ranking.alpha))
	for i,info in ipairs(buttons) do
	    if isMousePosition(_sX+resX(34),_sY+resY(32),resX(664),resY(30)) and info[3] then
		    dxDrawRectangle(_sX+resX(35),_sY+resY(33),resX(662),resY(28),tocolor(255,255,255,40*ranking.alpha))
		end
	    if info[3] then
		    dxText(info[1],_sX+resX(34),_sY+resY(31),_sX+resX(34)+resX(664),_sY+resY(61),255,255,255,255*ranking.alpha,1.0,dxFont(17),"center","center",true,false,false,false)
		end
	end
	if ranking.subMenu then
	    for i=1,11 do
		    local posY = _sY+resY(32)+(i*resY(30))
			dxDrawRectangle(_sX+resX(34),posY,resX(664),resY(29),tocolor(0,0,0,60*ranking.alpha))
			dxDrawRectangle(_sX+resX(35),posY+resY(1),resX(662),resY(27),tocolor(255,255,255,40*ranking.alpha))
			if isMousePosition(_sX+resX(34),posY,resX(664),resY(29)) then
				dxDrawRectangle(_sX+resX(35),posY+resY(1),resX(662),resY(27),tocolor(menu.r,menu.g,menu.b,30*ranking.alpha))
			end
			dxText(buttons[i][1],_sX+resX(35),posY+resY(2),_sX+resX(698),posY+resY(26),255,255,255,255*ranking.alpha,1.0,dxFont(17),"center","center",true,false,false,false)
	    end
    else
		for i=1,14 do
	    	local posY = _sY+resY(32)+(i*resY(30))
			dxDrawRectangle(_sX+resX(34),posY,resX(664),resY(29),tocolor(menu.r,menu.g,menu.b,40*ranking.alpha))
			dxDrawRectangle(_sX+resX(35),posY+resY(1),resX(662),resY(27),tocolor(0,0,0,80*ranking.alpha))
			if isMousePosition(_sX+resX(34),posY,resX(664),resY(29)) then
				dxDrawRectangle(_sX+resX(35),posY+resY(1),resX(662),resY(27),tocolor(255,255,255,10*ranking.alpha))
			end
		    if #showRanking ~= 0 and showRanking[i] then
				dxText(i..". "..showRanking[i].name,_sX+resX(36),posY,sX,posY+resY(29),255,255,255,255*ranking.alpha,1.0,dxFont(15),"left","center",false,false,false,true)
				dxText(showRanking[i].data,0,posY,_sX+resX(697),posY+resY(29),255,255,255,255*ranking.alpha,1.0,dxFont(15),"right","center",false,false,false,true)
		    else
			    dxText(i..". - Nao encontrado.",_sX+resX(36),posY,sX,posY+resY(29),255,255,255,255*ranking.alpha,1.0,dxFont(15),"left","center",true,false,false,false)
			end
		end
	end
end
function buttonRankingInterface(button,state)
	if ( button == "left" and state == "down" ) then
		return false
    end
	if ranking.subMenu then
	    for i=1,11 do
		    local posY = _sY+resY(32)+(i*resY(30))
			if isMousePosition(_sX+resX(34),posY,resX(698),resY(29)) then
			    for but=1,11 do
		            buttons[but][3] = false
		        end
		        buttons[i][3] = true
				ranking.subMenu = false
		        callServerFunction("getRankingData",localPlayer,buttons[i][2])
				break
			else
                if isMousePosition(_sX+resX(34),_sY+resY(31),resX(698),resY(30)) or i == 11 then
                    ranking.subMenu = false
				end
            end
		end
		return
	end
	if isMousePosition(_sX+resX(34),_sY+resY(32),resX(664),resY(30)) then
	    ranking.subMenu = true
	end
end