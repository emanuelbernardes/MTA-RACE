options = {
    alpha = 0,
	progress = 0
}
opLoops = {
    { img = "files/img/options/water.png", title = "Agua", text1 = "Deixar a agua mais realista.", text2 = "Desativar este efeito.", state = false},
	{ img = "files/img/options/car_mod.png", title = "Infernus MOD by Micra", text1 = "Modificar o infernus por um carro mais legal.", text2 = "Desativar esta modificacao.", state = false},
	{ img = "files/img/options/car_paint.png", title = "Cor dos carros", text1 = "Deixa as cores dos carros mais bonitas.", text2 = "Desativar este efeito.", state = false},
	{ img = "files/img/options/bloom.png", title = "Bloom SHADER", text1 = "Modificacao grafica.", text2 = "Desativar este efeito.", state = false},
	{ img = "files/img/options/hdr.png", title = "HDR SHADER", text1 = "Modificacao Grafica.", text2 = "Desativar este efeito.", state = false},
	{ img = "files/img/options/skid.png", title = "Derrapada Colorida", text1 = "Ative para deixas as marcas do freio coloridas.", text2 = "Desativar este efeito.", state = false},
	{ img = "files/img/options/snow.png", title = "Neve", text1 = "Ative para deixas os objetos com neve.", text2 = "Desativar este efeito.", state = false},
	{ img = "files/img/options/hunter.png", title = "Hunter MOD by D0GGy", text1 = "Modificar o hunter por um mais legal.", text2 = "Desativar esta modificacao.", state = false},
	{ img = "files/img/options/road.png", title = "Pistas MOD by Pipo", text1 = "Ative para modificar a aparencia das pistas.", text2 = "Desativar esta modificacao.", state = false}
}
function optionsInterface()
    options.progress = options.progress+0.005
    if label.options  == true then
	    options.alpha = interpolateBetween(options.alpha,0,0,1,0,0,options.progress,"Linear")
		if options.alpha == 1 then
		    options.progress = 0
		end
	end
	if label.options  == false then
	    options.alpha = interpolateBetween(options.alpha,0,0,0,0,0,options.progress,"Linear")
		if options.alpha == 0 then
		    options.progress = 0
		    removeEventHandler("onClientRender",root,optionsInterface)
		end  
	end
	dxDrawImage(_sX,_sY,resY(30),resY(30),"files/img/options.png",0,0,0,tocolor(232,232,232,255*options.alpha))
	dxText("Opcoes",_sX+resY(30),_sY+resY(2),sX,sY,230,230,230,255*options.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
	for i,info in ipairs(opLoops) do
	    posY = _sY+resY(31)+(i*resY(50))-resY(50)
		if not isMousePosition(_sX+resX(34),posY,resX(664),resY(49)) then
			dxDrawRectangle(_sX+resX(34),posY,resX(664),resY(49),tocolor(menu.r,menu.g,menu.b,30*options.alpha))
		end
		dxDrawImage(_sX+resX(35),posY+resY(1),resY(47),resY(47),info.img,0,0,0,tocolor(255,255,255,255*options.alpha))
		dxText(info.title,_sX+resY(85),posY-resY(2),sX,sY,255,255,255,255*options.alpha,1.0,dxFont(18),"left","top",true,false,false,false)
		if not info.state then
		    dxText(info.text1,_sX+resY(85),posY+resY(20),sX,sY,255,255,255,255*options.alpha,1.0,dxFont(18),"left","top",true,false,false,false)
		    createButton(_sX+resX(547),posY+resY(12),resX(150),resY(26),"Ativar",0,236,0,options.alpha,dxFont(15))
		else
		    dxText(info.text2,_sX+resY(85),posY+resY(20),sX,sY,255,255,255,255*options.alpha,1.0,dxFont(18),"left","top",true,false,false,false)
			createButton(_sX+resX(547),posY+resY(12),resX(150),resY(26),"Desativar",255,0,0,options.alpha,dxFont(15))
		end
	end
end
function buttonOptionsInterface(button,state)
	if ( button == "left" and state == "down" ) then
		return false
    end
	for i,info in ipairs(opLoops) do
	    posY = _sY+resY(30)+(i*resY(50))-resY(50)
        if isMousePosition(_sX+resX(547),posY+resY(12),resX(150),resY(26)) then
		    if i == 1 then
		        if not opLoops[i].state then
			        opLoops[i].state = true
			    else
			        opLoops[i].state = false
			    end
				toggleWaterShader()
				setNodeValue("water",tostring(opLoops[i].state))
			end
			if i == 2 then
		        if not opLoops[i].state then
			        opLoops[i].state = true
			    else
			        opLoops[i].state = false
			    end
				infernusModel()
				setNodeValue("carmod",tostring(opLoops[i].state))
			end
			if i == 3 then
		        if not opLoops[i].state then
			        opLoops[i].state = true
			    else
			        opLoops[i].state = false
			    end
				toggleCarpainShader()
				setNodeValue("carpaint",tostring(opLoops[i].state))
			end
			if i == 4 then
		        if not opLoops[i].state then
			        opLoops[i].state = true
					if opLoops[5].state then
					    opLoops[5].state = false
						toggleHDRShader()
						setNodeValue("hdr",tostring(false))
					end	
			    else
			        opLoops[i].state = false
			    end
				setNodeValue("bloom",tostring(opLoops[i].state))
				toggleBloomShader()
			end
			if i == 5 then
		        if not opLoops[i].state then
			        opLoops[i].state = true
					if opLoops[4].state then
					    opLoops[4].state = false
						toggleBloomShader()
						setNodeValue("bloom",tostring(false))
					end	
			    else
			        opLoops[i].state = false
			    end
				setNodeValue("hdr",tostring(opLoops[i].state))
				toggleHDRShader()
			end
			if i == 6 then
		        if not opLoops[i].state then
			        opLoops[i].state = true
			    else
			        opLoops[i].state = false
			    end
				toggleSkidMarks()
				setNodeValue("skid",tostring(opLoops[i].state))
			end
			if i == 7 then
			    if not opLoops[i].state then
			        opLoops[i].state = true
			    else
			        opLoops[i].state = false
			    end
				setNodeValue("snow",tostring(opLoops[i].state))
			    toggleSnowShader(opLoops[i].state)
			end
			if i == 8 then
			    if not opLoops[i].state then
			        opLoops[i].state = true
			    else
			        opLoops[i].state = false
			    end
				setNodeValue("huntermod",tostring(opLoops[i].state))
			    hunterModel()
			end
			if i == 9 then
			    if not opLoops[i].state then
			        opLoops[i].state = true
			    else
			        opLoops[i].state = false
			    end
				setNodeValue("road",tostring(opLoops[i].state))
			    loadRoadMod()
			end
		end
	end
end