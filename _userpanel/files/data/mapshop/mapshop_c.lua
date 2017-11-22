mapshop = {
    alpha = 0,
	progress = 0
}
maps = {}
function updateMapList(info)
    maps = info
end
function mapshopInterface()
    mapshop.progress = mapshop.progress+0.005
    if label.mapshop  == true then
	    mapshop.alpha = interpolateBetween(mapshop.alpha,0,0,1,0,0,mapshop.progress,"Linear")
		if mapshop.alpha == 1 then
		    mapshop.progress = 0
		end
	end
	if label.mapshop  == false then
	    mapshop.alpha = interpolateBetween(mapshop.alpha,0,0,0,0,0,mapshop.progress,"Linear")
		if mapshop.alpha == 0 then
		    mapshop.progress = 0
		    removeEventHandler("onClientRender",root,mapshopInterface)
		end
	end
	dxGrid.posX = _sX+resX(34)
	dxGrid.posY = _sY+resY(31)
	dxDrawImage(_sX,_sY,resY(30),resY(30),"files/img/mapshop.png",0,0,0,tocolor(232,232,232,255*mapshop.alpha))
	dxText("Mapas",_sX+resY(30),_sY+resY(2),sX,sY,230,230,230,255*mapshop.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
	showDxGridlist(mapshop.alpha)
	createButton(_sX+resX(300),_sY+resY(469),resX(198),resY(28),"Comprar Redo - $6000",0,255,0,mapshop.alpha,dxFont(15))
	createButton(_sX+resX(500),_sY+resY(469),resX(198),resY(28),"Comprar Mapa - $3000",0,255,0,mapshop.alpha,dxFont(15))
end
function buttonMapInterface(button,state)
	if ( button == "left" and state == "down" ) then
		return false
    end
	if isMousePosition(_sX+resX(500),_sY+resY(469),resX(198),resY(28)) then
	    local map = getElementData(localPlayer,"dxGridLineSelec")
		if not map then return end
	    callServerFunction("buyMap",localPlayer,data[map][2])
	end
	if isMousePosition(_sX+resX(300),_sY+resY(469),resX(198),resY(28)) then
		callServerFunction("buyRedo",localPlayer)
	end
end