custom = {
    alpha = 0,
	progress = 0
}
pickColor = {
	r = 255,
	g = 255,
	b = 255
}
customLoops = {
    { img = "files/img/custom/car_color.png", title = "Cor Do Carro", subTitle = "Comprar nova cor do carro.", butText = "Comprar - $40000"},
	{ img = "files/img/custom/car_lights.png", title = "Cor Do Farol", subTitle = "Comprar nova cor do farol.", butText = "Comprar - $30000"},
	{ img = "files/img/custom/car_nitro.png", title = "Cor Do Nitro", subTitle = "Comprar nova cor do nitro.", butText = "Comprar - $35000"},
	{ img = "files/img/custom/police.png", title = "Luzes da Policia", subTitle = "Comprar luzes da policia.", butText = "Comprar - $350000", text1 = "Ligar luzes da policia.", text2 = "Desligar luzes da policia.", state = false},
	--{ img = "files/img/custom/soon.png", title = "Donator", subTitle = "Buy for 1 day donate", butText = "Buy - $15000"},
	{ img = "files/img/custom/rocket.png", title = "Cor do Tiro", subTitle = "Comprar cor do tiro.", butText = "Comprar - $100000"}
}
function customInterface()
    custom.progress = custom.progress+0.005
    if label.custom  == true then 
	    custom.alpha = interpolateBetween(custom.alpha,0,0,1,0,0,custom.progress,"Linear")
		if custom.alpha == 1 then
		    custom.progress = 0
		end
	end
	if label.custom  == false then
	    custom.alpha = interpolateBetween(custom.alpha,0,0,0,0,0,custom.progress,"Linear")
		if custom.alpha == 0 then
		    custom.progress = 0
		    removeEventHandler("onClientRender",root,customInterface)
		end  
	end
	dxDrawImage(_sX,_sY,resY(30),resY(30),"files/img/custom.png",0,0,0,tocolor(232,232,232,255*custom.alpha))
	dxText("Custom",_sX+resY(30),_sY+resY(2),sX,sY,230,230,230,255*custom.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
	createButton(_sX+resX(34),_sY+resY(31),resX(664),resY(30),"Selecione a cor aqui antes de comprar!",pickColor.r,pickColor.g,pickColor.b,custom.alpha,dxFont(15))
	for i,info in ipairs(customLoops) do
	    local posY = _sY+resY(62)+(i*resY(50))-resY(50)
		if not isMousePosition(_sX+resX(34),posY,resX(698),resY(49)) then
			dxDrawRectangle(_sX+resX(34),posY,resX(664),resY(49),tocolor(menu.r,menu.g,menu.b,30*custom.alpha))
		end
		dxDrawImage(_sX+resX(35),posY+resY(1),resY(47),resY(47),info.img,0,0,0,tocolor(255,255,255,255*custom.alpha))
		dxText(info.title,_sX+resY(85),posY-resY(2),sX,sY,255,255,255,255*custom.alpha,1.0,dxFont(18),"left","top",true,false,false,false)
		if i ~= 4 then
		    dxText(info.subTitle,_sX+resY(85),posY+resY(22),sX,sY,255,255,255,255*custom.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
			createButton(_sX+resX(547),posY+resY(12),resX(150),resY(26),info.butText,0,236,0,custom.alpha,dxFont(14))
		else
			if getElementData(localPlayer,"policeHeadLight") == "false" then
				dxText(info.subTitle,_sX+resY(85),posY+resY(22),sX,sY,255,255,255,255*custom.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
			    createButton(_sX+resX(547),posY+resY(12),resX(150),resY(26),info.butText,0,236,0,custom.alpha,dxFont(14))
			else
				if not info.state then
				    dxText(info.text1,_sX+resY(85),posY+resY(22),sX,sY,255,255,255,255*custom.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
			        createButton(_sX+resX(547),posY+resY(12),resX(150),resY(26),"Ativar",0,236,0,custom.alpha,dxFont(14))
				else
				    dxText(info.text2,_sX+resY(85),posY+resY(22),sX,sY,255,255,255,255*custom.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
			        createButton(_sX+resX(547),posY+resY(12),resX(150),resY(26),"Desativar",255,0,0,custom.alpha,dxFont(14))
				end
			end
		end
	end
end
function buttonCustomInterface(button,state)
	if ( button == "left" and state == "down" ) then
		return false
    end
	if isMousePosition(_sX+resX(34),_sY+resY(31),resX(664),resY(30)) then
	    colorPicker.create("1","#FFFFFF","Selecionar Cor")
	end
	for i,info in ipairs(customLoops) do
	    local posY = _sY+resY(61)+(i*resY(50))-resY(50)
        if isMousePosition(_sX+resX(547),posY+resY(12),resX(150),resY(26)) then
		    if i == 1 then
                callServerFunction("buyCarColor",localPlayer,1,pickColor.r,pickColor.g,pickColor.b)
			end
			if i == 2 then
                callServerFunction("buyCarColor",localPlayer,2,pickColor.r,pickColor.g,pickColor.b)
			end
			if i == 3 then
                callServerFunction("buyCarColor",localPlayer,3,pickColor.r,pickColor.g,pickColor.b)
			end
			if i == 4 then
                if getElementData(localPlayer,"policeHeadLight") == "false" then
			        callServerFunction("buyPoliceHeadlight",localPlayer)
		        end
				if getElementData(localPlayer,"policeHeadLight") == "true" then
				    if not customLoops[i].state then
					    setElementData(localPlayer,"HeadLightState","1")
			            customLoops[i].state = true
			        else
					    setElementData(localPlayer,"HeadLightState","false")
			            customLoops[i].state = false
			        end
				end
			end
			if i == 5 then
			    --callServerFunction("buyDonatorDay",localPlayer,"1")
			--end
			--if i == 6 then
                callServerFunction("buyCarColor",localPlayer,4,pickColor.r,pickColor.g,pickColor.b)
			end
		end
	end
end