donator = {
    alpha = 0,
	progress = 0,
	subMenu = false
}
donatorCustom = {
    state = false
}
wheelManager = {
	id = 1,
	state = false,
	pg = 0,
	to = "right"
}
subMenu = {
    { state = true, name = "Rodas"},
	{ state = false, name = "Rainbow"},
	{ state = false, name = "Luzes"}
}
wheels = {
	{"files/img/donator/wheels/original/1025.jpg","default",1025,false},
	{"files/img/donator/wheels/original/1073.jpg","default",1073,false},
	{"files/img/donator/wheels/original/1074.jpg","default",1074,false},
	{"files/img/donator/wheels/original/1075.jpg","default",1075,false},
	{"files/img/donator/wheels/original/1076.jpg","default",1076,false},
	{"files/img/donator/wheels/original/1077.jpg","default",1077,false},
	{"files/img/donator/wheels/original/1078.jpg","default",1078,false},
	{"files/img/donator/wheels/original/1079.jpg","default",1079,false},
	{"files/img/donator/wheels/original/1080.jpg","default",1080,false},
	{"files/img/donator/wheels/original/1081.jpg","default",1081,false},
	{"files/img/donator/wheels/original/1082.jpg","default",1082,false},
	{"files/img/donator/wheels/original/1083.jpg","default",1083,false},
	{"files/img/donator/wheels/original/1084.jpg","default",1084,false},
	{"files/img/donator/wheels/original/1085.jpg","default",1085,false},
	{"files/img/donator/wheels/original/1096.jpg","default",1096,false},
	{"files/img/donator/wheels/original/1097.jpg","default",1097,false},
	{"files/img/donator/wheels/original/1098.jpg","default",1098,false},
	{"files/img/donator/wheels/custom/1025.jpg","custom",1025,"wheel_or1"},
	{"files/img/donator/wheels/custom/1073.jpg","custom",1073,"wheel_sr6"},
	{"files/img/donator/wheels/custom/1074.jpg","custom",1074,"wheel_sr3"},
	{"files/img/donator/wheels/custom/1075.jpg","custom",1075,"wheel_sr2"},
	{"files/img/donator/wheels/custom/1076.jpg","custom",1076,"wheel_lr4"},
	{"files/img/donator/wheels/custom/1077.jpg","custom",1077,"wheel_lr1"},
	{"files/img/donator/wheels/custom/1078.jpg","custom",1078,"wheel_lr3"},
	{"files/img/donator/wheels/custom/1079.jpg","custom",1079,"wheel_sr1"},
	{"files/img/donator/wheels/custom/1080.jpg","custom",1080,"wheel_sr5"},
	{"files/img/donator/wheels/custom/1081.jpg","custom",1081,"wheel_sr4"},
	{"files/img/donator/wheels/custom/1082.jpg","custom",1082,"wheel_gn1"},
	{"files/img/donator/wheels/custom/1083.jpg","custom",1083,"wheel_lr2"},
	{"files/img/donator/wheels/custom/1084.jpg","custom",1084,"wheel_lr5"},
	{"files/img/donator/wheels/custom/1085.jpg","custom",1085,"wheel_gn2"},
	{"files/img/donator/wheels/custom/1096.jpg","custom",1096,"wheel_gn3"},
	{"files/img/donator/wheels/custom/1097.jpg","custom",1097,"wheel_gn4"},
	{"files/img/donator/wheels/custom/1098.jpg","custom",1098,"wheel_gn5"}
}
wheelsSize = {}
rainbow = {{text="Branco para Preto"},{text="Rosa para Azul"},{text="Vermelho para Azul"},{text="Verde para Azul"}}
lights = {{text="Policia"},{text="Disco"}}
function donatorInterface()
    donator.progress = donator.progress+0.005
    if label.donator == true then
	    donator.alpha = interpolateBetween(donator.alpha,0,0,1,0,0,donator.progress,"Linear")
		if donator.alpha == 1 then
		    donator.progress = 0
		end
	end
	if label.donator  == false then
	    donator.alpha = interpolateBetween(donator.alpha,0,0,0,0,0,donator.progress,"Linear")
		if donator.alpha == 0 then
		    donator.progress = 0
		    removeEventHandler("onClientRender",root,donatorInterface)
		end  
	end
	dxDrawImage(_sX,_sY,resY(30),resY(30),"files/img/donator.png",0,0,0,tocolor(232,232,232,255*donator.alpha))
	dxText("Donator",_sX+resY(30),_sY+resY(2),sX,sY,230,230,230,255*donator.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
	if not donatorCustom.state then
	    dxText("Oi "..getPlayerName(localPlayer).." #ffffff!!! \n Esta parte e so para os Donator's.\n Se voce quiser ser um donator..\n Entre e contato com a Staff\n para mais infomacoes.",_sX+resX(34),_sY+resY(31),_sX+resX(698),_sY+resY(400),255,255,255,255*donator.alpha,1.0,dxFont(15),"center","center",false,false,false,true)
		createButton(_sX+resX(267),_sY+resY(310),resX(200),resY(28),"Abrir",0,255,0,donator.alpha,dxFont(15))
	else
		createButton(_sX+resX(567),_sY+resY(31),resX(132),resY(30),"Fechar",255,0,0,donator.alpha,dxFont(15))
		dxDrawRectangle(_sX+resX(34),_sY+resY(31),resX(531),resY(30),tocolor(0,0,0,60*donator.alpha))
		for i,value in ipairs(subMenu) do
		    if isMousePosition(_sX+resX(34),_sY+resY(31),resX(531),resY(30)) and value.state then
				dxDrawRectangle(_sX+resX(34),_sY+resY(31),resX(531),resY(30),tocolor(255,255,255,40*donator.alpha))
			    dxDrawRectangle(_sX+resX(35),_sY+resY(32),resX(529),resY(28),tocolor(0,0,0,120*donator.alpha))
		    end
		    if value.state then
		        dxText(value.name,_sX+resX(34),_sY+resY(31),_sX+resX(531),_sY+resY(61),255,255,255,255*donator.alpha,1.0,dxFont(18),"center","center",true,false,false,false)
		    end
		end
		if donator.subMenu then
		    for i=1,#subMenu do
				local posY = _sY+resY(32)+(i*resY(30))
				dxDrawRectangle(_sX+resX(35),posY,resX(663),resY(29),tocolor(menu.r,menu.g,menu.b,40*donator.alpha))
				dxDrawRectangle(_sX+resX(35),posY,resX(663),resY(29),tocolor(0,0,0,80*donator.alpha))
				if isMousePosition(_sX+resX(35),posY,resX(700),resY(29)) then
					dxDrawRectangle(_sX+resX(36),posY+resY(1),resX(661),resY(28),tocolor(255,255,255,10*donator.alpha))
				end
				dxText(subMenu[i].name,_sX+resX(35),posY+resY(1),_sX+resX(698),posY+resY(27),255,255,255,255*donator.alpha,1.0,dxFont(17),"center","center",true,false,false,false)
	    	end
		else
		    for i,value in ipairs (subMenu) do
			    if value.name == "Rodas" and value.state then
				    dxText("Selecione o modelo!",_sX+resX(35),_sY+resY(100),_sX+resX(700),sY,255,255,255,240*donator.alpha,1.0,dxFont(22),"center","top",true,false,false,false)
					for i,wheel in ipairs(wheels) do
					    wheelManager.pg = wheelManager.pg+0.005
					    if wheelManager.id > 1 and i == (wheelManager.id-1) then
						    if wheelManager.to == "right" then
							    x,y,s = 157,190,120
							end
							if wheelManager.to == "left" then
							    x,y,s = interpolateBetween(297,180,140,157,190,120,wheelManager.pg,"Linear")
							end
					        dxDrawImage(_sX+resX(x),_sY+resY(y),resX(s),resY(s),wheel[1],0,0,0,tocolor(255,255,255,180*donator.alpha))
					    end
					    if wheelManager.id < #wheels and i == (wheelManager.id+1) then
						    if wheelManager.to == "right" then
							    x,y,s = interpolateBetween(297,180,140,457,190,120,wheelManager.pg,"Linear")
							end
							if wheelManager.to == "left" then
							    x,y,s = 457,190,120
							end
					        dxDrawImage(_sX+resX(x),_sY+resY(y),resX(s),resY(s),wheel[1],0,0,0,tocolor(255,255,255,180*donator.alpha))
					    end
						if i == wheelManager.id then
						    if wheelManager.to == "right" then
							    x,y,s = interpolateBetween(157,190,120,297,180,140,wheelManager.pg,"Linear")
							end
							if wheelManager.to == "left" then
							    x,y,s = interpolateBetween(457,190,120,297,180,140,wheelManager.pg,"Linear")
							end
							dxDrawImage(_sX+resX(x),_sY+resY(y),resX(s),resY(s),wheel[1],0,0,0,tocolor(255,255,255,255*donator.alpha))
					    end
				    end
					dxText("("..wheelManager.id.."/"..#wheels..")",_sX+resX(35),_sY+resY(330),_sX+resX(700),sY,255,255,255,240*donator.alpha,1.0,dxFont(15),"center","top",true,false,false,false)
					createButton(_sX+resX(267),_sY+resY(380),resX(200),resY(28),"Mudar",70,130,180,donator.alpha,dxFont(15))
					createButton(_sX+resX(498),_sY+resY(451),resX(200),resY(28),"Resetar",205,92,92,donator.alpha,dxFont(15))
				end
				if value.name == "Rainbow" and value.state then
				    dxText("Selecione o Rainbow( Cor do Carro )!",_sX+resX(35),_sY+resY(63),sX,sY,255,255,255,240*donator.alpha,1.0,dxFont(18),"left","top",true,false,false,false)
					for i,info in ipairs(rainbow) do
					    local posY = _sY+resY(64)+(i*resY(30))
						if tonumber(getElementData(localPlayer,"vehicleColor")) == i then
					    	createButton(_sX+resX(35),posY,resX(664),resY(29),info.text,0,236,0,donator.alpha,dxFont(15))
						else
                        	createButton(_sX+resX(35),posY,resX(664),resY(29),info.text,70,130,180,donator.alpha,dxFont(15))
				    	end
					end
					dxText("Selecione o Rainbow( Cor dos Farois )!",_sX+resX(35),_sY+resY(215),sX,sY,255,255,255,240*donator.alpha,1.0,dxFont(18),"left","top",true,false,false,false)
					for i,info in ipairs(lights) do
					    local posY = _sY+resY(215)+(i*resY(30))
						if tonumber(getElementData(localPlayer,"HeadLightState")) == i then
					    	createButton(_sX+resX(35),posY,resX(664),resY(29),info.text,0,236,0,donator.alpha,dxFont(15))
						else
                        	createButton(_sX+resX(35),posY,resX(664),resY(29),info.text,70,130,180,donator.alpha,dxFont(15))
				    	end
					end
					createButton(_sX+resX(498),_sY+resY(451),resX(200),resY(28),"Resetar",205,92,92,donator.alpha,dxFont(15))
				end
				if value.name == "Luzes" and value.state then
					dxText("Selecione a Luz Traseira!",_sX+resX(34),_sY+resY(100),_sX+resX(700),sY,255,255,255,240*donator.alpha,1.0,dxFont(22),"center","top",true,false,false,false)
					for i=1,6 do
					    local posX=_sX+resX(150)+(i*resX(142))-resX(142)
					    local posY=_sY+resY(170)
						if i > 3 then
						    posX=posX-(3*resX(142))
						    posY=posY+resY(82)
						end
					    dxDrawImageSection(posX,posY,resX(140),resY(80),256,0,256,127,'files/data/donator/lights/'..i..'.png',0,0,0,tocolor(255,255,255,255*donator.alpha))
						local image = getElementData(localPlayer,"vehiclelight")
						if i == image then
						    dxDrawRecLine(posX,posY,resX(140),resY(80),tocolor(0,255,0,150*donator.alpha))
						else
						    dxDrawRecLine(posX,posY,resX(140),resY(80),tocolor(255,0,0,150*donator.alpha))
						end
					end
					createButton(_sX+resX(498),_sY+resY(451),resX(200),resY(28),"Resetar",205,92,92,donator.alpha,dxFont(15))
				end
			end
		end
	end
end
function buttonDonatorInterface(button,state)
	if (button=="left" and state=="down") then
		return false
    end
    if not donatorCustom.state then
	    if isMousePosition(_sX+resX(267),_sY+resY(310),resX(200),resY(28)) then
	        if not donatePlayer then
		        createNotify("Voce nao e Donator",255,0,0)
		    else
			    donatorCustom.state = true
				callServerFunction("getWheelsSize",localPlayer)
		    end
		end	
	else
	    if isMousePosition(_sX+resX(567),_sY+resY(31),resX(132),resY(30)) then
		    donatorCustom.state = false
		end
		if donator.subMenu then
		    for i=1,#subMenu do
		        posY = _sY+resY(32)+(i*resY(30))
			    if isMousePosition(_sX,posY,resX(700),resY(29)) then
			        for but=1,#subMenu do
		                subMenu[but].state = false
		            end
		            subMenu[i].state = true
				    donator.subMenu = false
				    break
			    else
                    if isMousePosition(_sX+resX(1),_sY+resY(31),resX(565),resY(30)) or i == #subMenu then
                        donator.subMenu = false
				    end
                end
		    end
		else
			if isMousePosition(_sX+resX(34),_sY+resY(31),resX(531),resY(30)) then
	        	donator.subMenu = true
	    	end
			for i,value in ipairs (subMenu) do
			    if value.name == "Rodas" and value.state then
				    if wheelManager.id > 1 then
						if isMousePosition(_sX+resX(157),_sY+resY(190),resX(120),resY(120)) then
						    wheelManager.pg = 0
							wheelManager.to = "right"
					    	wheelManager.id = wheelManager.id-1
						end
					end
					if wheelManager.id < #wheels then
						if isMousePosition(_sX+resX(457),_sY+resY(190),resX(120),resY(120)) then
						    wheelManager.pg = 0
							wheelManager.to = "left"
					    	wheelManager.id = wheelManager.id+1
						end
					end
					if isMousePosition(_sX+resX(267),_sY+resY(380),resX(200),resY(28)) then
				        wheelManager.state = true
				        loadWheel(wheels[wheelManager.id][2],wheels[wheelManager.id][3],wheels[wheelManager.id][4])
					    createNotify("Voce mudou a Roda do carro.",0,144,200)
			        end
					if isMousePosition(_sX+resX(498),_sY+resY(451),resX(200),resY(28)) then
				        wheelManager.state = false
					    if isElement(wheelTXD) then
						    destroyElement(wheelTXD)
				        end
				        if isElement(wheelDFF) then
						    destroyElement(wheelDFF)
				        end
					    createNotify("Escolha restaurada para a padrao.",0,255,0)
				    end
				end
				if value.name == "Rainbow" and value.state then
				    for i,info in ipairs(rainbow) do
					    posY = _sY+resY(63)+(i*resY(30))
						if isMousePosition(_sX+resX(1),posY,resX(698),resY(29)) then
					        setElementData(localPlayer,"vehicleColor",tostring(i))
						    createNotify("Voce colocou um Rainbow. ("..info.text..")",0,144,200)
					    end
					end
					for i,info in ipairs(lights) do
					    posY = _sY+resY(215)+(i*resY(30))
						if isMousePosition(_sX+resX(1),posY,resX(698),resY(29)) then
					        setElementData(localPlayer,"HeadLightState",tostring(i))
						    createNotify("Voce colocou um estilo de luzes. ("..info.text..")",0,144,200)
					    end
					end
					if isMousePosition(_sX+resX(498),_sY+resY(451),resX(200),resY(28)) then
					    setElementData(localPlayer,"vehicleColor","false")
				        setElementData(localPlayer,"HeadLightState","false")
					    createNotify("Escolha restaurada para a padrao.",0,255,0)
					end
				end
				if value.name == "Luzes" and value.state then
				    for i=1,6 do
					    posX=_sX+resX(150)+(i*resX(142))-resX(142)
					    posY=_sY+resY(170)
						if i > 3 then
						    posX=posX-(3*resX(142))
						    posY=posY+resY(82)
						end
						if isMousePosition (posX,posY,resX(140),resY(80)) then
                            setElementData(localPlayer,"vehiclelight",i)
						    createNotify("Voce selecionou a luz "..i,0,255,0)
						end
					end
					if isMousePosition(_sX+resX(498),_sY+resY(451),resX(200),resY(28)) then
					    unloadVehicleLights(localPlayer)
					    createNotify("Escolha restaurada para a padrao.",0,255,0)
					end
				end
			end
		end
	end
end
function closeDonator(info)
    if not info then
        donatePlayer = info
	    setElementData(localPlayer,"vehicleColor","false")
        setElementData(localPlayer,"HeadLightState","false")
	    wheelManager.state = false
	else
	    donatePlayer = info
	end
end