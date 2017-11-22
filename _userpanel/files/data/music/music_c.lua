music = {
    alpha = 0,
	progress = 0,
	search = false
}
enableMusic = {
	state = false
}
radios = {
    {img = "files/img/music/radio_1.png", state = false, ip = "http://streaming.shoutcast.com/RadioHunter-TheHitzChannel"},
	{img = "files/img/music/radio_2.png", state = false, ip = "http://de-hz-fal-stream01.rautemusik.fm/techhouse"},
	{img = "files/img/music/radio_3.png", state = false, ip = "http://jam-high.rautemusik.fm/stream.mp3?ref=rmpage"},
	{img = "files/img/music/radio_4.png", state = false, ip = "http://servidor31.brlogic.com:8054/live"}
}
_radio = {
	name = "RADIO",
	play = false
}
function updateMusicList(info)
    if not label.music then return end
	music.search = false
	cache = info
    data = info
end
function setWebList(info)
    music.search = true
	setElementData(localPlayer,"dxGridPosNow",1)
    setElementData(localPlayer,"dxGridLineSelec",nil)
	cache = info
    data = info
end
function musicInterface()
    music.progress = music.progress+0.005
    if label.music  == true then
	    music.alpha = interpolateBetween(music.alpha,0,0,1,0,0,music.progress,"Linear")
		if music.alpha == 1 then
		    music.progress = 0
		end
	end
	if label.music  == false then
	    music.alpha = interpolateBetween(music.alpha,0,0,0,0,0,music.progress,"Linear")
		if music.alpha == 0 then
		    music.progress = 0
		    removeEventHandler("onClientRender",root,musicInterface)
		end  
	end
	dxDrawImage(_sX,_sY,resY(30),resY(30),"files/img/music.png",0,0,0,tocolor(232,232,232,255*music.alpha))
	dxText("Musica",_sX+resY(30),_sY+resY(2),sX,sY,230,230,230,255*music.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
	if not enableMusic.state then
		dxText("Ola "..getPlayerName(localPlayer).." #ffffff!!! \n \n Para escutar as musicas, \n voce precisa ativar o sistema.. \n Para isso clique no botao abaixo.",_sX+resX(34),_sY+resY(145),_sX+resX(698),sY,255,255,255,255*music.alpha,1.0,dxFont(15),"center","top",false,false,false,true)
		createButton(_sX+resX(268),_sY+resY(300),resX(198),resY(28),"Ativar",70,130,180,music.alpha,dxFont(15))
	else
	    createEditBox(_sX+resX(34),_sY+resY(31),resX(499),resY(30),music.alpha,dxFont(14),"webSearch","Procurar na Web..")
		createButton(_sX+resX(535),_sY+resY(31),resX(30),resY(30),"",70,130,180,music.alpha,dxFont(15))
		dxDrawImage(_sX+resX(540),_sY+resY(36),resX(20),resX(20),"files/img/music/search.png",0,0,0,tocolor(255,255,255,255*music.alpha))
		createButton(_sX+resX(567),_sY+resY(31),resX(132),resY(30),"Desativar",255,0,0,music.alpha,dxFont(15))
		dxGrid.posX = _sX+resX(34)
	    dxGrid.posY = _sY+resY(62)
	    showDxGridlist(music.alpha)
		if isPlayerAcl then
		    if not music.search then
			    createButton(_sX+resX(34),_sY+resY(365),resX(221),resY(24),"Remover",70,130,180,music.alpha,dxFont(14))
			end
			createButton(_sX+resX(256),_sY+resY(365),resX(221),resY(24),"Pular",70,130,180,music.alpha,dxFont(14))
			createButton(_sX+resX(478),_sY+resY(365),resX(221),resY(24),"Iniciar",0,236,0,music.alpha,dxFont(14))
		else
			createButton(_sX+resX(34),_sY+resY(365),resX(664),resY(24),"Comprar - $1000",0,236,0,music.alpha,dxFont(15))
	    end
		for i,radio in ipairs (radios) do
			local posX = _sX+resX(34)+((i-1)*resX(166))
			if not isMousePosition(posX,_sY+resY(391),resX(165),resY(107)) then
			    dxDrawRectangle(posX,_sY+resY(391),resX(165),resY(107),tocolor(255,255,255,20*music.alpha))
			end
			dxDrawImage(posX+resX(1),_sY+resY(392),resX(163),resX(78),radio.img,0,0,0,tocolor(255,255,255,255*music.alpha))
			if not radio.state then
			    createButton(posX+resX(12),_sY+resY(472),resX(140),resY(24),"Ouvir",0,236,0,music.alpha,dxFont(14))
			else
			    createButton(posX+resX(12),_sY+resY(472),resX(140),resY(24),"Parar",255,0,0,music.alpha,dxFont(14))
			end
		end
	end
end
function buttonMusicInterface(button,state)
	if ( button == "left" and state == "down" ) then
		return false
    end
	if not enableMusic.state then
	    if isMousePosition(_sX+resX(268),_sY+resY(300),resX(198),resY(28)) then
		    if not enableMusic.state then
			    enableMusic.state = true
				callServerFunction("getMusicList",localPlayer)
				callServerFunction("enableMusicTabEvent",localPlayer)
			end
		end
	else
	    if isMousePosition(_sX+resX(567),_sY+resY(31),resY(132),resY(30)) then
		    if enableMusic.state then
			    enableMusic.state = false
				destroySound()
				if isElement(_radio.play) then
			        destroyElement(_radio.play)
			    end
				sound.start = false
				for index = 1,3 do
                    radios[index].state = false
				end
				for i,song in ipairs(getElementsByType("sound")) do
					setSoundVolume(song,1)
				end
			end
		end
		for i,box in ipairs(editBox) do
	    	if isMousePosition(_sX+resX(34),_sY+resY(31),resX(499),resY(30)) then
			    if box.editName == "webSearch" then
				    boxClick = i
				end
	   	    end
			if isMousePosition(_sX+resX(535),_sY+resY(31),resY(30),resY(30)) then
			    if box.editName == "webSearch" then
		    	    if box.text ~= "" then
	        	        callServerFunction("webSearhMusic",localPlayer,box.text)
					end
				end
			end	
		end
		if isPlayerAcl then
			if isMousePosition(_sX+resX(256),_sY+resY(365),resX(221),resY(24)) then
	   	    	sound.start = false
	    		callServerFunction("onSkipMusic",localPlayer)
			end
			if isMousePosition(_sX+resX(34),_sY+resY(365),resX(221),resY(24)) and not music.search then
	    		local music = getElementData(localPlayer,"dxGridLineSelec")
				if not music then return end
	    		callServerFunction("musicRemove",localPlayer,data[music][1])
			    cache = {}
				data = {}
			end
			if isMousePosition(_sX+resX(478),_sY+resY(365),resX(221),resY(24)) then
	    		local ok = getElementData(localPlayer,"dxGridLineSelec")
				if not ok then return end
				if music.search then
	    			callServerFunction("onSaveMusic",localPlayer,data[ok][2],data[ok][3],data[ok][1])
				else
					callServerFunction("onSaveMusic",localPlayer,data[ok][2],false,data[ok][1])
				end
			end
        else
			if isMousePosition(_sX+resX(34),_sY+resY(365),resX(664),resY(24)) then
	    		local ok = getElementData(localPlayer,"dxGridLineSelec")
				if not ok then return end
				if music.search then
	    			callServerFunction("onSaveMusic",localPlayer,data[ok][2],data[ok][3],data[ok][1])
				else
					callServerFunction("onSaveMusic",localPlayer,data[ok][2],false,data[ok][1])
				end
			end
		end
		for i,radio in ipairs (radios) do
			local posX = _sX+resX(34)+((i-1)*resX(166))
		    if isMousePosition(posX+resX(12),_sY+resY(472),resX(140),resY(24)) then
				if not radio.state then
					if isElement(_radio.play) then
			            destroyElement(_radio.play)
			        end
					for i,song in ipairs(getElementsByType("sound")) do
						setSoundVolume(song,0)
					end
					_radio.play = playSound(radio.ip)
					radio.state = true
					destroySound()
				else
					if isElement(_radio.play) then
			            destroyElement(_radio.play)
			        end
					_radio.play = false
					for i,song in ipairs(getElementsByType("sound")) do
						setSoundVolume(song,1)
					end
                    radio.state = false	
				end
				for index = 1,#radios do
					if index ~= i then
                        radios[index].state = false
					end
				end
			end
		end
	end
end
-- Radio System
addEventHandler("onClientSoundChangedMeta",root,
function(streamTitle)
    if source == _radio.play then
        if isElement(_radio.play) then
			_radio.name = streamTitle
	    end
	end
end
)
-- Music System
sound = {
    play = false,
	player = "",
	name = "",
	link = "",
	volume = true,
	bar = 0,
	start = false,
	img = false
}
function startSound(player,link,soundName,img)
    if player and link and soundName and img then
	    if not enableMusic.state then return end
		for i=1,#radios do
		    if radios[i].state then return end
		end	
	    if isElement (sound.play) then
		    destroyElement(sound.play)
		end
	    sound.player = player
		sound.link = link
		sound.name = soundName
		sound.play = playSound(sound.link)
		sound.img = img
    end
end
function OnSoundStream ( stream )
    if source == sound.play then
	    setElementData(localPlayer,"Musica","enable")
	    if stream then
		    sound.start = true
			for i,song in ipairs(getElementsByType("sound")) do
			    if song ~= isElement(sound.play) then
				    setSoundVolume(song,0)
				end
			end
			createNotify("A musica "..sound.name.." comecou a tocar.",0,144,200)
			callServerFunction("getPlayersStartedSound",localPlayer,true)
			callServerFunction("getArtWork",localPlayer,sound.img)
			updateVolume()
		else
			destroyElement(sound.play)
			sound.play = false
			createNotify("Erro ao iniciar a musica para voce.",255,0,0)
			callServerFunction("getPlayersStartedSound",localPlayer,false)
		end
    end
end
addEventHandler("onClientSoundStream",root,OnSoundStream)
function onSoundStarted(reason)
    if ( reason == "play" ) then
	    if getSoundLength(source) < 2 then return end
		if sound.play or _radio.play then
			setSoundVolume(source,0)
		end
		if source == sound.play then
			setSoundVolume(source,1)
		end
		if source == _radio.play then
			setSoundVolume(source,1)
		end
    end
end
addEventHandler("onClientSoundStarted",root,onSoundStarted)
function onSoundStopped()
    if source == sound.play then
	    sound.start = false
		destroyElement(sound.play)
		sound.play = false
		if isElement(ArtWork) then
            destroyElement(ArtWork)
        end
		for i,song in ipairs(getElementsByType("sound")) do
			setSoundVolume(song,1)
		end
		callServerFunction("onStopMusic",localPlayer,true)
	end
end
addEventHandler("onClientSoundStopped",root,onSoundStopped)
function destroySound()
	if isElement(sound.play) then
		destroyElement(sound.play)
	end
	sound.play = false
	if isElement(ArtWork) then
        destroyElement(ArtWork)
    end
end
--[[function stateMusic ()
    if not isElement (sound.play) then return end
    if not sound.volume then
	    sound.volume = true
		createNotify("Sound unMuted",0,236,0)
    else
	    sound.volume = false
		createNotify("Sound Muted",255,0,0)
    end
	updateVolume()
end]]
function updateVolume()
    if sound.volume then
	    setSoundVolume(sound.play,1)
    else
	    setSoundVolume(sound.play,0)
    end
end
function saveArtWork(pixels)
    if isElement(ArtWork) then
        destroyElement(ArtWork)
    end
    ArtWork = dxCreateTexture(pixels)
end