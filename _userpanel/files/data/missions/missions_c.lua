missions = {
    alpha = 0,
	progress = 0
}
__missions = {}
function refreshMissionsStats(table)
    __missions = table
end
_missions = {
    { img = "files/img/missions/survivor.png", title = "Ganhar 10 mapas", count = 10 },
	{ img = "files/img/missions/2top.png", title = "Pegar Top times 2 vezes", count = 2 },
	{ img = "files/img/missions/hunter.png", title = "Pegar Hunter 10 vezes", count = 10 },
	{ img = "files/img/missions/waterdie.png", title = "Morrer na agua 20 vezes", count = 20 },
	{ img = "files/img/missions/change.png", title = "Mudar de veiculo 50 vezes", count = 50 },
	{ img = "files/img/missions/earn.png", title = "Ganhar $4.000", count = 4000 },
	{ img = "files/img/missions/drive.png", title = "Jogar 15 mapas", count = 15 },
	{ img = "files/img/missions/2row.png", title = "Ganhar 2 mapas seguidos", count = 2 },
	{ img = "files/img/missions/explode.png", title = "Explodir 20 vezes", count = 20 }
}
function missionsInterface()
    missions.progress = missions.progress+0.005
    if label.missions  == true then
	    missions.alpha = interpolateBetween(missions.alpha,0,0,1,0,0,missions.progress,"Linear")
		if missions.alpha == 1 then
		    missions.progress = 0
		end
	end
	if label.missions  == false then
	    missions.alpha = interpolateBetween(missions.alpha,0,0,0,0,0,missions.progress,"Linear")
		if missions.alpha == 0 then
		    missions.progress = 0
		    removeEventHandler("onClientRender",root,missionsInterface)
		end
	end
	dxDrawImage(_sX,_sY,resY(30),resY(30),"files/img/missions.png",0,0,0,tocolor(232,232,232,255*missions.alpha))
	dxText("Missoes",_sX+resY(30),_sY+resY(2),sX,sY,230,230,230,255*missions.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
	for i,info in ipairs(_missions) do
	    local posY = _sY+resY(31)+(i*resY(50))-resY(50)
		if not isMousePosition(_sX+resX(34),posY,resX(698),resY(49)) then
			dxDrawRectangle(_sX+resX(34),posY,resX(664),resY(49),tocolor(menu.r,menu.g,menu.b,30*missions.alpha))
		end
		dxDrawImage(_sX+resY(35),posY+resY(4),resY(42),resY(42),info.img,0,0,0,tocolor(255,255,255,255*missions.alpha))
		dxText(info.title,_sX+resX(80),posY-resY(2),sX,sY,255,255,255,255*missions.alpha,1.0,dxFont(18),"left","top",true,false,false,false)
		dxText("Progresso",_sX+resX(83),posY+resY(22),sX,sY,255,255,255,255*missions.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
		dxDrawRectangle(_sX+resX(170),posY+resY(35),resX(470),resY(5),tocolor(0,0,0,50*missions.alpha))
		local progress = 0
		if __missions[1] and __missions[1][i] then
		    progress = __missions[1][i]/info.count or 0
			if progress > 1 then progress = 1 end
		    dxDrawRectangle(_sX+resX(170),posY+resY(35),resX(470)*progress,resY(5),tocolor(0,236,0,180*missions.alpha))
		end
		if progress == 1 then
		    dxDrawImage(_sX+resX(660),posY+resY(10),resY(30),resY(30),"files/img/missions/accept.png",0,0,0,tocolor(0,236,0,255*missions.alpha))
		else
            dxDrawImage(_sX+resX(660),posY+resY(10),resY(30),resY(30),"files/img/missions/accept.png",0,0,0,tocolor(0,0,0,160*missions.alpha))
		end
	end
end
function buttonMissionsInterface(button,state)
	if ( button == "left" and state == "down" ) then
		return false
    end
end