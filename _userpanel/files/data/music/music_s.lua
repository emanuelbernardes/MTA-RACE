saveSound = {}
timerAgain2 = {}
function onSaveMusic(player,link,img,...)
    local mess = nil for k,v in pairs({...}) do  if mess == nil then mess = v else mess = mess .. " " .. v end end
	if not isPlayerLogged( player ) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if timerAgain2[mess] then
	    local remaining = getTimerDetails(timerAgain2[mess])
	    return callClientFunction(player,"createNotify","Esta musica ja foi comprada, espere "..math.floor(remaining/60000).." minutos para comprar novamente.",255,0,0)
	end
	img = img or "http://www.alpha.in2gadgets.com.au/wp-content/uploads/2014/11/music-icon-300x300.png"
	if link and mess and img then
		if #saveSound ~= 0 then
		    for index,sound in ipairs (saveSound) do
			    if sound.mess == mess then
				    return callClientFunction(player,"createNotify","Esta musica ja esta na lista para ser tocada.",255,0,0)
				end
				if player == sound.player then
				    return callClientFunction(player,"createNotify","Voce atingiu o limite para comprar musicas.",255,0,0)
				end
			end
		end
		if isPlayerOnGroup(player) or getDonatorPlayer(player) then
		    table.insert(saveSound,{name=getPlayerName(player),link=link,mess=mess,img=img})
		    timerAgain2[mess] = setTimer(timerAgain2Reset2,1000*60*infos.timerAgain,1,mess)
	        if #saveSound == 1 then
		        callClientFunction(root,"startSound",getPlayerName(player),link,mess,img)
	        end
	        _outputChatBox("_s[_wMusica_s] _w"..getPlayerName(player).."_w comprou a musica _v"..mess,root,255,255,255,true)
	        callClientFunction(root,"createNotify","Musica "..mess.." foi adicionada a lista por "..getPlayerName(player),0,236,0)
		else
		    if onTakeMoney(player,infos.musicPrice) then
		        table.insert(saveSound,{name=getPlayerName(player),link=link,mess=mess,img=img})
		        timerAgain2[mess] = setTimer(timerAgain2Reset2,1000*60*infos.timerAgain,1,mess)
		        if #saveSound == 1 then
			        callClientFunction(root,"startSound",getPlayerName(player),link,mess,img)
		        end
		        _outputChatBox("_s[_wMusica_s] _w"..getPlayerName(player).."_w comprou a musica _v"..mess,root,255,255,255,true)
	            callClientFunction(root,"createNotify","Musica "..mess.." foi adicionada a lista por "..getPlayerName(player),0,236,0)
		    else
		        callClientFunction(player,"createNotify","Voce nao tem dinheiro.",255,0,0)
	        end
		end
	else
		callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
end
function timerAgain2Reset2(mess)
	if timerAgain2[mess] then 
		timerAgain2[mess] = nil
		_outputChatBox("_s[_wMusica_s] _v"..mess.."_w ja pode ser comprada novamente.",root,255,255,255,true)
	end
end
function getPlayersStartedSound(player,state)
    if state == true then
	    setElementData(player,"musicState","Ready")
	elseif state == false then
	    setElementData(player,"musicState","notReady")
	end
	if isTimer (randomTimer) then
	    killTimer(randomTimer)
	end
	randomTimer = setTimer ( 
	function()
	    local Ready = {}
		local notReady = {}
		for i,player in pairs (getElementsByType("player")) do
	        if (getElementData(player,"musicState")=="Ready") then
				table.insert(Ready,{player})
			end
			if (getElementData(player,"musicState")=="notReady") then
			    table.insert(notReady,{player})
			end
		end
		if (#Ready > #notReady) or (#Ready == #notReady) then
		    return 
	    end 
		for i,player in pairs (getElementsByType("player")) do
		    setElementData(player,"musicState","")
		end
		callClientFunction(root,"createNotify","Esta musica foi pulada pelo sistema.",0,144,200)
		callClientFunction(root,"destroySound")
		musicRandom()
    end
	, 5000, 1 )
end
function musicRandom()
    for index,sound in ipairs (saveSound) do
		if index == 1 then
        	table.remove(saveSound,index)
		end	
	end
	if #saveSound ~= 0 then
	    for index,sound in ipairs (saveSound) do
			if index == 1 then
				callClientFunction(root,"startSound",sound.name,sound.link,sound.mess,sound.img)
		    end
		end
	end
end
function onStopMusic(player)
    if (getElementData(player,"Musica")=="enable") then
	    for i,player in pairs (getElementsByType("player")) do
	        setElementData(player,"Musica","disable")
			setElementData(player,"musicState","")
		end
	    musicRandom()
	end
end
function onSkipMusic(player)
    if isPlayerOnGroup(player) then
	    if #saveSound >= 2 then
		    musicRandom()
			callClientFunction(root,"createNotify","Musica pulada por "..getPlayerName(player),0,144,200)
		else
		    musicRandom()
			callClientFunction(root,"destroySound")
			callClientFunction(root,"createNotify","Musica resumida por "..getPlayerName(player),0,144,200)
		end
	end
end
function enableMusicTabEvent(player)
    if player then
        if #saveSound ~= 0 then
		    for index,sound in ipairs(saveSound) do
				if index == 1 then
					callClientFunction(player,"startSound",sound.name,sound.link,sound.mess,sound.img)
		    	end
			end
	    end
    end
end
function webSearhMusic(client,text)
	fetchRemote("http://palcoxmp3.com/search/"..(text:gsub(" ","-")),readData,"",false,client)
end
function readData(data,err,player)
    if err == 0 then
		parseFile(data,player)
	end
end
function parseFile(strFile,player)
    local finalResult = {}
	local count = 0
    strBuffer = strFile
    if not (strFile) then
        return false
    end
    strBuffer = string.gsub(strBuffer,"\n"," ")
    strBuffer = string.gsub(strBuffer," < ","<")
    strBuffer = string.gsub(strBuffer," > ",">")
    strBuffer = string.gsub(strBuffer,"(<[^ >]+)",string.lower)
	strBuffer = string.gsub(strBuffer,"-","AA")
	for strText in string.gmatch(strBuffer,'<div class="colAAlgAA11 colAAmdAA11 colAAsmAA11 padding0" style="paddingAAleft:5px">.-</div>') do
	    name = false
	    link = false
	    for strTitle in string.gmatch(strText,'<h2 class="songAAtitle pullAAleft">(.-)</h2>') do
		    name = tostring(string.gsub(strTitle,"AA","-"))
		end
		for strLink in string.gmatch(strText,'<div class="btnAAgroup pullAAright" role=".-" dataAAauthdownload=".-" dataAAauthentication=".-" dataAAtrackAAlink="(.-)" dataAAtitle=".-">') do
		   link = tostring(string.gsub(strLink,"AA","-"))
		end
		finalResult[#finalResult+1] = {name,link}
    end
	for strText in string.gmatch(strBuffer,'<div class="row searchAAresults">(.-)</div>') do
		local img = false
		local i,f,img = string.find(strText,'<img alt=".-" width=".-" src="(.-)" class=".-" />')
		img = string.gsub(img,"AA","-")
		count = count+1
		finalResult[count][3] = img
    end
	if #finalResult == 0 then
	    finalResult[1] = {"Not Found Results",false,false}
	end
    callClientFunction(player,"setWebList",finalResult)
end
function getArtWork(playerToReceive,link)
    fetchRemote(link,myCallback,"",false,playerToReceive)
end
function myCallback(responseData,errno,playerToReceive)
    if errno == 0 then
	    callClientFunction(playerToReceive,"saveArtWork",responseData)
	else
        getArtWork(playerToReceive,"http://downloadicons.net/sites/default/files/video-play-button-icon-76432.png")	
    end
end