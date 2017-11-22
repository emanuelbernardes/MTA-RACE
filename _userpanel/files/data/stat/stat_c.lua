stat = {
    alpha = 0,
	progress = 0
}
personalStats = {}
nameStats = {"Pontos","Dinheiro","DM Jogados","DD Jogados","FUN Jogados","Total Jogados","Hunter","Top Times","Bet","Spin","Online","Missoes Completas"}
function updatePlayerList(info)
    cache = info
    data = info
end
function refreshPlayerStats(info)
    personalStats = info
end
function clearStats()
    personalStats = {}
end
function statInterface()
    stat.progress = stat.progress+0.005
    if label.stat  == true then
	    stat.alpha = interpolateBetween(stat.alpha,0,0,1,0,0,stat.progress,"Linear")
		if stat.alpha == 1 then
		    stat.progress = 0
		end
	end
	if label.stat  == false then
	    stat.alpha = interpolateBetween(stat.alpha,0,0,0,0,0,stat.progress,"Linear")
		if stat.alpha == 0 then
		    stat.progress = 0
		    removeEventHandler("onClientRender",root,statInterface)
		end
	end
	dxGrid.posX = _sX+resX(34)
	dxGrid.posY = _sY+resY(31)
	dxDrawImage(_sX,_sY,resY(30),resY(30),"files/img/stat.png",0,0,0,tocolor(232,232,232,255*stat.alpha))
	dxText("Status",_sX+resY(30),_sY+resY(2),sX,sY,230,230,230,255*stat.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
	showDxGridlist(stat.alpha)
	if #personalStats ~= 0 then
	    for i=1,#personalStats do
			dxDrawRectangle(_sX+resX(218),_sY+resY(65),resX(480),resY(36),tocolor(menu.r,menu.g,menu.b,20*stat.alpha))
			dxText("Voce selecionou..",_sX+resX(202),_sY+resY(31),_sX+resX(700),_sY+resY(61),255,255,255,255*stat.alpha,1.0,dxFont(18),"center","center",true,false,false,false)
			dxText(personalStats[i][1]:gsub("#%x%x%x%x%x%x",""),_sX+resX(202),_sY+resY(63),_sX+resX(700),_sY+resY(98),255,255,255,255*stat.alpha,1.0,dxFont(22),"center","center",true,false,false,false)
			dxText("Status do jogador",_sX+resX(220),_sY+resY(120),sX,sY,255,255,255,255*stat.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
			for index=2,13 do
			    posY = _sY+resY(137)+((index-1)*resY(23))
			    dxText(nameStats[index-1],_sX+resX(220),posY,_sX+resX(700),posY+resY(20),255,255,255,255*stat.alpha,1.0,dxFont(15),"left","center",true,false,false,false)
				dxText(personalStats[i][index],_sX+resX(220),posY,_sX+resX(696),posY+resY(20),255,255,255,255*stat.alpha,1.0,dxFont(15),"right","center",true,false,false,false)
			end
		end
		for i=1,6 do
		    posY = _sY+resY(137)+(i*resY(46))-resY(23)
			dxDrawRectangle(_sX+resX(218),posY,resX(480),resY(20),tocolor(menu.r,menu.g,menu.b,20*stat.alpha))
		end
	else
		dxDrawImage(_sX+resX(450)-resY(100),_sY+resY(235)-resY(100),resY(200),resY(200),"files/img/stat.png",0,0,0,tocolor(255,255,255,255*stat.alpha))
	end
end
function buttonStatInterface(button,state)
	if ( button == "left" and state == "down" ) then
		return false
    end
	for i=1,getElementData(localPlayer,"dxGridMaxLines") do
		if isMousePosition(dxGrid.posX,dxGrid.posY+(i*dxGrid.rowSize),dxGrid.sizeX-11,dxGrid.rowSize) then
		    local gridList = getElementData(localPlayer,"dxGridPosNow")
		    setElementData(localPlayer,"dxGridLineSelec",((gridList-1)+i))
			callServerFunction("getPlayerAllData",localPlayer,data[(getElementData(localPlayer,"dxGridPosNow")-1)+i][2])
		end
	end
end