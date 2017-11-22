function resX(value)
 local min_ = math.floor(sY/500)
 local count = 1
 if min_ > 1 then
     count = count + 0.2*min_
 end
 return value*count
end
function resY(value)
 local min_ = math.floor(sY/500)
 local count = 1
 if min_ > 1 then
     count = count + 0.2*min_
 end
 return value*count
end
local progress = 0

function callServerFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key,value in next, arg do
            if (type(value)=="number") then arg[key] = tostring(value) end
        end
    end
    triggerServerEvent("onClientCallsServerFunction",resourceRoot,funcname,unpack(arg))
end

function callClientFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key,value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onServerCallsClientFunction",true)
addEventHandler("onServerCallsClientFunction",resourceRoot,callClientFunction)

function startUserpanel()
	callServerFunction("startDataValue",localPlayer)
	callServerFunction("getServerMaps",localPlayer)
	addEventHandler("onClientRender",root,showNotify)
end
addEventHandler("onClientResourceStart",resourceRoot,startUserpanel)

label = {
    mapshop = false,
	ranking = false,
	custom = false,
	options = false,
	stat = false,
	gang = false,
	music = false,
	donator = false,
	missions = false,
	monitor = false
}

function getState(index)
    if index == 1 then return label.mapshop
	elseif index == 2 then return label.ranking
	elseif index == 3 then return label.custom
	elseif index == 4 then return label.options
	elseif index == 5 then return label.stat
	elseif index == 6 then return label.gang
	elseif index == 7 then return label.music
	elseif index == 8 then return label.donator
	elseif index == 9 then return label.missions
	elseif index == 10 then return label.monitor
	end
end

menu = {
    panel = false,
	alpha = 0,
	r = 255,
	g = 165,
	b = 0,
	posX = (sX/2-resX(350))/sX,
	posY = (sY/2-resY(250))/sY,
	click = false,
	cX = 0,
	cY = 0,
	errX = 0,
	errY = 0
}

_label = {
    {name="Mapas",img="files/img/mapshop.png",count=0,fade=0},
    {name="Ranking",img="files/img/ranking.png",count=0,fade=0},
	{name="Custom",img="files/img/custom.png",count=0,fade=0},
	{name="Opcoes",img="files/img/options.png",count=0,fade=0},
	{name="Status",img="files/img/stat.png",count=0,fade=0},
	{name="Equipe",img="files/img/team.png",count=0,fade=0},
	{name="Musica",img="files/img/music.png",count=0,fade=0},
	{name="Donator",img="files/img/donator.png",count=0,fade=0},
	{name="Missoes",img="files/img/missions.png",count=0,fade=0},
	{name="VGA",img="files/img/monitor.png",count=0,fade=0}
}

function userpanelInterface()
    progress = progress+0.1
    if menu.panel == true then	    
		menu.alpha = interpolateBetween(menu.alpha,0,0,1,0,0,progress,"Linear")
		if progress >= 1 then
	        showCursor(true)
			showChat(false)
		end
	end
	if menu.panel == false then
	    showCursor(false)
		showChat(true)
	    menu.alpha = interpolateBetween(menu.alpha,0,0,0,0,0,progress,"Linear")
		if progress >= 1 then        
	        removeEventHandler("onClientRender",root,userpanelInterface)
		end
	end
	if boxClick then
        guiSetInputEnabled(true)
	else
        guiSetInputEnabled(false)
	end
	if menu.click then
	    local cX, cY = getCursorPosition()
		menu.errX = cX-menu.cX
		menu.errY = cY-menu.cY
	end
	_sX = sX*menu.posX+sX*menu.errX
	_sY = sY*menu.posY+sY*menu.errY
	_dxShadowRectangle(_sX-resX(2),_sY-resY(2),resX(704),resY(504),tocolor(0,0,0,170*menu.alpha),resY(25))
	dxDrawRectangle(_sX-resX(2),_sY-resY(2),resX(704),resY(504),tocolor(255,255,255,255*menu.alpha))
	dxDrawRectangle(_sX-resX(2),_sY-resY(2),resX(704),resY(504),tocolor(0,0,0,80*menu.alpha))
	dxDrawRectangle(_sX,_sY,resX(700),resY(500),tocolor(0,0,0,170*menu.alpha))
	dxDrawRectangle(_sX,_sY,resX(700),resY(30),tocolor(menu.r,menu.g,menu.b,20*menu.alpha))
	dxDrawImage(_sX+resX(34),_sY+resY(31),resX(666),resY(469),"files/img/background.png",0,0,0,tocolor(255,255,255,255*menu.alpha))
	dxDrawImage(_sX+resX(670),_sY+resY(1),resY(30),resY(30),"files/img/logo.png",0,0,0,tocolor(255,255,255,255*menu.alpha))
	dxText(_RealDateTime().."\n CREATE BY GW8 2017©",_sX,_sY+resY(2),_sX+resY(668),sY,230,230,230,255*menu.alpha,1.0,dxFont(9.5),"right","top",true,false,false,false)
    for i,info in ipairs (_label) do
	    local posY = _sY+resY(32)+(i*resY(31))-resY(31)
		local width = dxGetTextWidth(info.name:upper(),1.0,dxFont(18),false)+8
		if isMousePosition(_sX+resX(2),posY,resY(30),resY(30)) then
		    info.count = info.count + 0.1 if info.count >= 1.0 then info.count = 1 end
			dxDrawRectangle(_sX+resX(2),posY,resY(30),resY(30),tocolor(255,255,255,50*menu.alpha))
		else
		    info.count = info.count - 0.05 if info.count <= 0.0 then info.count = 0 end
		end
		if getState(i) then
		    info.fade = info.fade + 0.1 if info.fade >= 1.0 then info.fade = 1 end
		else
		    info.fade = info.fade - 0.1 if info.fade <= 0.0 then info.fade = 0 end
		end
		dxDrawRectangle(_sX+resX(2),posY,resY(30),resY(30),tocolor(0,0,0,i*15*menu.alpha))
		dxDrawImage(_sX+resX(2),posY,resY(30),resY(30),info.img,0,0,0,tocolor(255,255,255,255*menu.alpha))
		dxDrawRectangle(_sX+resX(2),posY,resY(30),resY(30),tocolor(menu.r,menu.g,menu.b,50*menu.alpha*info.fade))
		dxDrawRecLine(_sX+resX(2),posY,resY(30),resY(30),tocolor(menu.r,menu.g,menu.b,150*menu.alpha*info.fade))
		dxDrawRectangle(_sX-resX(2),posY,-width,resY(30),tocolor(255,255,255,255*menu.alpha*info.count))
		dxDrawRectangle(_sX-resX(2),posY,-width,resY(30),tocolor(0,0,0,160*menu.alpha*info.count))
		dxDrawRectangle(_sX-resX(4),posY+resY(2),-width+resX(4),resY(26),tocolor(255,255,255,40*menu.alpha*info.count))
		dxText(info.name:upper(),_sX-width,posY+resY(2),_sX-resX(4),posY+resY(2)+resY(26),220,220,220,200*menu.alpha*info.count,resY(1),dxFont(18),"left","center",true,false,false,false)
	end
	if getElementData(localPlayer,"xInvite")=="Enabled" then
		_dxShadowRectangle(0,sY-resY(42),sX,resY(42),tocolor(0,0,0,120*menu.alpha),resY(25))
		dxDrawRectangle(0,sY-resY(42),sX,resY(42),tocolor(255,255,255,255*menu.alpha))
		dxDrawRectangle(0,sY-resY(40),sX,resY(40),tocolor(0,0,0,150*menu.alpha))
		createButton(sX-resX(105),sY-resY(35),resX(100),resY(30),"RECUSAR",255,0,0,menu.alpha,dxFont(15))
		createButton(sX-resX(210),sY-resY(35),resX(100),resY(30),"ACEITAR",0,255,0,menu.alpha,dxFont(15))
		dxText("Deseja entrar na equipe "..getElementData(localPlayer,"xTeamName").." ?",1,sY-resY(35),sX-resX(210),sY,255,255,255,255*menu.alpha,1.0,dxFont(20),"left","top",true,false,false,false)
	end
	if isElement(sound.play) or isElement(_radio.play) then
	    _dxShadowRectangle(_sX-resX(2),_sY-resY(2)+resY(515),resX(704),resY(54),tocolor(0,0,0,120*menu.alpha),resY(25))
		dxDrawRectangle(_sX-resX(2),_sY-resY(2)+resY(515),resX(704),resY(54),tocolor(255,255,255,255*menu.alpha))
		dxDrawRectangle(_sX-resX(2),_sY-resY(2)+resY(515),resX(704),resY(54),tocolor(0,0,0,80*menu.alpha))
		dxDrawRectangle(_sX,_sY+resY(515),resX(700),resY(50),tocolor(0,0,0,170*menu.alpha))
		dxDrawRectangle(_sX+resY(50),_sY+resY(515)+resY(46),resX(700)-resY(50),resY(4),tocolor(0,0,0,170*menu.alpha))
		dxDrawRectangle(_sX,_sY+resY(515),resY(50),resY(50),tocolor(255,255,255,60*menu.alpha))
	    if isElement(sound.play) then
	        if getSoundPosition(sound.play) and getSoundLength(sound.play) then
	            local posMusic = math.max (0,getSoundPosition(sound.play))/getSoundLength(sound.play)
			    if sound.start then sound.bar = posMusic else sound.bar = 0 end
		    else
		        sound.bar = 0
		    end
		    dxDrawRectangleGradiente(_sX+resY(50),_sY+resY(515)+resY(46),(resX(700)-resY(50))*sound.bar,resY(4),0,255,0,160*menu.alpha,"right")
		    --if not sound.volume then
		       -- dxDrawImage( state.posX2 + sX*0.055, sY*0.965, sY*0.03, sY*0.03, "files/img/music/unmute.png")
		    --else
		       -- dxDrawImage( state.posX2 + sX*0.055, sY*0.965, sY*0.03, sY*0.03, "files/img/music/mute.png")
		    --end
		    if isElement(ArtWork) then
		        dxDrawImage(_sX,_sY+resY(515),resY(50),resY(50),ArtWork,0,0,0,tocolor(255,255,255,255*menu.alpha))
		    end
		    dxText(sound.name,_sX+resY(51),_sY+resY(515),_sX+resX(700),sY,255,255,255,255*menu.alpha,resY(1),dxFont(15),"left","top",true,false,false,false)
		    dxText("Request By "..sound.player,_sX+resY(51),_sY+resY(535),_sX+resX(700),sY,255,255,255,255*menu.alpha,resY(1),dxFont(13),"left","top",false,false,false,true)
		elseif isElement(_radio.play) then
		    dxDrawRectangleGradiente(_sX+resY(50),_sY+resY(515)+resY(46),resX(700)-resY(50),resY(4),0,255,0,160*menu.alpha,"right")
		    dxText("Radio Player",_sX+resY(51),_sY+resY(515),_sX+resX(700),sY,255,255,255,255*menu.alpha,resY(1),dxFont(15),"left","top",true,false,false,false)
		    dxText(_radio.name,_sX+resY(51),_sY+resY(535),_sX+resX(700),sY,255,255,255,255*menu.alpha,resY(1),dxFont(13),"left","top",false,false,false,true)
		end
	end
end

function labels(mapShop,Ranking,Custom,Options,Stat,Gang,Music,Donator,Missions,Monitor)
    clearRanking()
	clearStats()
	removeDxGridlist()
	__missions = {}
	text = {}
	for i,_ in ipairs(editBox) do
    	table.insert(text,{})
	end
	setElementData(localPlayer,"dxGridPosNow","1")
	setElementData(localPlayer,"dxGridLineSelec",nil)
	setElementData(localPlayer,"dxGridMaxLines",false)
	boxClick = false
    if mapShop == "on" then
	    label.mapshop = true
		mapshop.alpha = 0
	    mapshop.progress = 0
		startDxGridlist(maps,resX(1),resY(31),resX(665),resY(437),16,dxFont(14),"mapName")
		removeEventHandler("onClientRender",root,mapshopInterface)
		addEventHandler("onClientRender",root,mapshopInterface)
		removeEventHandler("onClientClick",root,buttonMapInterface)
		addEventHandler("onClientClick",root,buttonMapInterface)
	elseif mapShop == "off" then
	    label.mapshop = false
		removeEventHandler("onClientClick",root,buttonMapInterface)
	end
	if Ranking == "on" then
	    label.ranking = true
		ranking.alpha = 0
	    ranking.progress = 0
		removeEventHandler("onClientClick",root,buttonRankingInterface)
		addEventHandler("onClientClick",root,buttonRankingInterface)
		removeEventHandler("onClientRender",root,rankingInterface)
		addEventHandler("onClientRender",root,rankingInterface)
		callServerFunction("getRankingData",localPlayer,"points")
		buttons[1][3] = true
	elseif Ranking == "off" then
	    label.ranking = false
		ranking.subMenu = false
	    removeEventHandler("onClientClick",root,buttonRankingInterface)
	end
	if Custom == "on" then
	    label.custom = true
		custom.alpha = 0
	    custom.progress = 0
		removeEventHandler("onClientClick",root,buttonCustomInterface)
		addEventHandler("onClientClick",root,buttonCustomInterface)
		removeEventHandler("onClientRender",root,customInterface)
		addEventHandler("onClientRender",root,customInterface)
	elseif Custom == "off" then
	    label.custom = false
	    removeEventHandler("onClientClick",root,buttonCustomInterface)
	end
	if Options == "on" then
	    label.options = true
		options.alpha = 0
	    options.progress = 0
		removeEventHandler("onClientClick",root,buttonOptionsInterface)
		addEventHandler("onClientClick",root,buttonOptionsInterface)
		removeEventHandler("onClientRender",root,optionsInterface)
		addEventHandler("onClientRender",root,optionsInterface)
	elseif Options == "off" then
	    label.options = false
	    removeEventHandler("onClientClick",root,buttonOptionsInterface)
	end
	if Stat == "on" then
	    label.stat = true
		stat.alpha = 0
	    stat.progress = 0
		callServerFunction("getServerPlayers",localPlayer)
		startDxGridlist({},resX(1),resY(31),resX(180),resY(468),17,dxFont(15),"searchPlayer")
		removeEventHandler("onClientRender",root,statInterface)
		addEventHandler("onClientRender",root,statInterface)
		removeEventHandler("onClientClick",root,buttonStatInterface)
		addEventHandler("onClientClick",root,buttonStatInterface)
	elseif Stat == "off" then
	    removeEventHandler("onClientClick",root,buttonStatInterface)
	    label.stat = false
	end
	if Gang == "on" then
	    label.gang = true
		team.alpha = 0
	    team.progress = 0
		manage.team = false
		callServerFunction("getTeamRankingData",localPlayer)
		removeEventHandler("onClientRender",root,teamInterface)
		addEventHandler("onClientRender",root,teamInterface)
		removeEventHandler("onClientClick",root,buttonTeamInterface)
		addEventHandler("onClientClick",root,buttonTeamInterface)
	elseif Gang == "off" then
	    removeEventHandler("onClientClick",root,buttonTeamInterface)
		manage.state = false
	    label.gang = false
	end
	if Music == "on" then
	    label.music = true
		music.alpha = 0
	    music.progress = 0
		startDxGridlist({},resX(1),resY(62),resX(664),resY(300),12,dxFont(14),"searchMusic")
		if enableMusic.state then
		    callServerFunction("getMusicList",localPlayer)
		end
		removeEventHandler("onClientRender",root,musicInterface)
		addEventHandler("onClientRender",root,musicInterface)
		removeEventHandler("onClientClick",root,buttonMusicInterface)
		addEventHandler("onClientClick",root,buttonMusicInterface)
	elseif Music == "off" then
	    removeEventHandler("onClientClick",root,buttonMusicInterface)
	    label.music = false
	end
	if Donator == "on" then
	    label.donator = true
		donator.alpha = 0
	    donator.progress = 0
		removeEventHandler("onClientRender",root,donatorInterface)
		addEventHandler("onClientRender",root,donatorInterface)
		removeEventHandler("onClientClick",root,buttonDonatorInterface)
		addEventHandler("onClientClick",root,buttonDonatorInterface)
	elseif Donator == "off" then
	    removeEventHandler("onClientClick",root,buttonDonatorInterface)
	    label.donator = false
		donatorCustom.state = false
	end
	if Missions == "on" then
	    label.missions = true
		missions.alpha = 0
	    missions.progress = 0
		removeEventHandler("onClientRender",root,missionsInterface)
		addEventHandler("onClientRender",root,missionsInterface)
		removeEventHandler("onClientClick",root,buttonMissionsInterface)
		addEventHandler("onClientClick",root,buttonMissionsInterface)
		callServerFunction("getMissionsAllData",localPlayer)
	elseif Missions == "off" then
	    removeEventHandler("onClientClick",root,buttonMissionsInterface)
	    label.missions = false
		missions.state = false
	end
	if Monitor == "on" then
	    label.monitor = true
		monitor.alpha = 0
	    monitor.progress = 0
		removeEventHandler("onClientRender",root,monitorInterface)
		addEventHandler("onClientRender",root,monitorInterface)
		removeEventHandler("onClientClick",root,buttonMonitorInterface)
		addEventHandler("onClientClick",root,buttonMonitorInterface)
	elseif Monitor == "off" then
	    label.monitor = false
	    monitor.state = false
	    callServerFunction("destroyTimeMonitor",localPlayer)
	    removeEventHandler("onClientClick",root,buttonMonitorInterface)
	end
end

function buttonInterface(button,state)
	if ( button == "left" and state == "down" ) then
	    if isMousePosition(_sX,_sY,resX(700),resY(30)) then
		    menu.click = true
			menu.cX,menu.cY = getCursorPosition()
		end
		return false
    end
	local cmd = {}
	if isMousePosition(_sX+resX(2),_sY+resY(32),resY(30),#_label*resY(31)) then
		for i,info in ipairs (_label) do
	    	local posY = _sY+resY(32)+(i*resY(31))-resY(31)
			if isMousePosition(_sX+resX(2),posY,resY(30),resY(30)) then
    	    	if not getState(i) then
	    	    	cmd[i] = "on"
		    	else
	    	    	cmd[i] = "on"
		    	end
			else
            	cmd[i] = "off"
        	end
			if i == #_label then
		    	labels(unpack(cmd))
			end	
    	end
	end
	if getElementData(localPlayer,"xInvite")=="Enabled" then
		if isMousePosition(sX-resX(105),sY-resY(35),resX(100),resY(30)) then
		    callServerFunction("onPlayerInvitePending",localPlayer,false)
		end
		if isMousePosition(sX-resX(210),sY-resY(35),resX(100),resY(30)) then
		    callServerFunction("onPlayerInvitePending",localPlayer,true)
		end
	end
	menu.click = false
	menu.cX,menu.cY = 0,0
	menu.posX = menu.posX+menu.errX
	menu.posY = menu.posY+menu.errY
	menu.errX = 0
	menu.errY = 0
end

isPlayerLogIn = false
isPlayerAcl = false
teamState = false
donatePlayer = false
function setPlayerLoginStatus ( login, acl, team, donator)
    isPlayerLogIn = login
	isPlayerAcl = acl
	teamState = team
	donatePlayer = donator
	if isPlayerLogIn then
		if not menu.panel then
	    	progress = 0
	    	menu.panel = true
			addEventHandler("onClientClick",root,buttonInterface)
			removeEventHandler("onClientRender",root,userpanelInterface)
			addEventHandler("onClientRender",root,userpanelInterface)
	    	removeEventHandler("onClientRender",root,showNotify)
	    	addEventHandler("onClientRender",root,showNotify)
			removeEventHandler("onClientRender",root,DownloadBar)
			addEventHandler("onClientRender",root,DownloadBar)
			labels("on","off","off","off","off","off","off","off","off","off")
			setElementData(localPlayer,"login",false)
		else
		    labels("off","off","off","off","off","off","off","off","off","off")
	    	progress = 0
	    	menu.panel = false
			removeEventHandler("onClientClick",root,buttonInterface)
			setElementData(localPlayer,"login",true)
		end
	else
	    labels("off","off","off","off","off","off","off","off","off","off")
	    progress = 0
	    menu.panel = false
		removeEventHandler("onClientClick",root,buttonInterface)
		setElementData(localPlayer,"login",true)
	end
end

bindKey('u',"down",
function()
    if boxClick ~= false then return end
	callServerFunction("isPlayerLoggedClient",localPlayer)
end
)

fileDelete("user_c.lua")