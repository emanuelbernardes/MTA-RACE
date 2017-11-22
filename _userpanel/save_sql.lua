local db = dbConnect( "mysql", "dbname=userpanel;host=127.0.0.1", "root", "A1s2d3f4g5@", "share=1" )

if db then
	outputDebugString( "A conexão com o MySQL funcionou" )
else
	outputDebugString( "A conexão com o MySQL não funcionou" )
end

function createTables()
    dbExec(db,"CREATE TABLE IF NOT EXISTS tableUserpanel ( playerUser TEXT, playerName TEXT, points TEXT, cash TEXT, dm TEXT, dd TEXT, fun TEXT, mapsPlayed TEXT, carColor TEXT, lightColor TEXT, nitroColor TEXT, policeHeadLight TEXT, Hunter TEXT, topTime TEXT, bet TEXT, spin TEXT, online TEXT, shotColor TEXT)")
	dbExec(db,"CREATE TABLE IF NOT EXISTS tableColors ( playerUser TEXT, color1 TEXT, color2 TEXT, color3 TEXT, color4 TEXT, color5 TEXT, color6 TEXT, color7 TEXT, color8 TEXT, color9 TEXT, color10 TEXT, color11 TEXT, color12 TEXT)")
	dbExec(db,"CREATE TABLE IF NOT EXISTS tableMusic ( musicName TEXT, musicLink TEXT)")
	dbExec(db,"CREATE TABLE IF NOT EXISTS systemTeam (teamName TEXT, teamColor1 TEXT, teamColor2 TEXT, teamColor3 TEXT, reputation TEXT, cash TEXT, tag TEXT, rainbow TEXT, teamColor4 TEXT, teamColor5 TEXT, teamColor6 TEXT)")
    dbExec(db,"CREATE TABLE IF NOT EXISTS playerTeam (playerUser TEXT, teamName TEXT, playerLevel TEXT, playerName TEXT)")
	dbExec(db,"CREATE TABLE IF NOT EXISTS donator (playerUser TEXT, time TEXT)")
	dbExec(db,"CREATE TABLE IF NOT EXISTS missions (playerUser TEXT, time TEXT, miss1 TEXT, miss2 TEXT, miss3 TEXT, miss4 TEXT, miss5 TEXT, miss6 TEXT, miss7 TEXT, miss8 TEXT, congruation TEXT, miss9 TEXT)")
	outputDebugString("*Started Userpanel by Gw8, Version Fixed 0.1.2")
end
addEventHandler("onResourceStart",resourceRoot,createTables)
--#Delete
function delete(player,cmd)
    local account = getAccountName(getPlayerAccount(player))
	if not isObjectInACLGroup("user." .. account,aclGetGroup("Console")) then
	    return
	end
	dbExec(db,"DROP TABLE tableMusic" )
	dbExec(db,"DROP TABLE tableUserpanel" )
	dbExec(db,"DROP TABLE tableColors" )
	dbExec(db,"DROP TABLE systemTeam" )
	dbExec(db,"DROP TABLE playerTeam" )
	dbExec(db,"DROP TABLE donator" )
	dbExec(db,"DROP TABLE missions" )
	outputDebugString("*Restarting data base by console: "..account)
	createTables()
	restartResource(getThisResource())
end
addCommandHandler("reloadtab",delete)
--#Add data value
function addDataValue(player,data,value)
    local user = getAccountName(getPlayerAccount(player))
	local selectUser = dbQuery(db,"SELECT "..data.." FROM tableUserpanel WHERE playerUser=? LIMIT 1",user)
	local result = dbPoll(selectUser,-1) or {}
	for _,info in ipairs(result) do
        if data == "points" then
		    local setValue = info.points+value
		    dbExec(db,"UPDATE tableUserpanel SET points=? WHERE playerUser=?",setValue,user)
	    elseif data == "cash" then
		    local setValue = info.cash+value
		    dbExec(db,"UPDATE tableUserpanel SET cash=? WHERE playerUser=?",setValue,user)
	    elseif data == "dm" then
		    local setValue = info.dm+value
		    dbExec(db,"UPDATE tableUserpanel SET dm=? WHERE playerUser=?",setValue,user)
	    elseif data == "dd" then
		    local setValue = info.dd+value
		    dbExec(db,"UPDATE tableUserpanel SET dd=? WHERE playerUser=?",setValue,user)
	    elseif data == "fun" then
		    local setValue = info.fun+value
		    dbExec(db,"UPDATE tableUserpanel SET fun=? WHERE playerUser=?",setValue,user)
		elseif data == "mapsPlayed" then
		    local setValue = info.mapsPlayed+value
		    dbExec(db,"UPDATE tableUserpanel SET mapsPlayed=? WHERE playerUser=?",setValue,user)
	    elseif data == "carColor" then
		    local setValue = info.carColor+value
		    dbExec(db,"UPDATE tableUserpanel SET carColor=? WHERE playerUser=?",setValue,user)
	    elseif data == "lightColor" then
		    local setValue = info.lightColor+value
		    dbExec(db,"UPDATE tableUserpanel SET lightColor=? WHERE playerUser=?",setValue,user)
	    elseif data == "nitroColor" then
		    local setValue = info.nitroColor+value
		    dbExec(db,"UPDATE tableUserpanel SET nitroColor=? WHERE playerUser=?",setValue,user)
		elseif data == "policeHeadLight" then
		    local setValue = info.policeHeadLight+value
		    dbExec(db,"UPDATE tableUserpanel SET policeHeadLight=? WHERE playerUser=?",setValue,user)	
		elseif data == "Hunter" then
		    local setValue = info.Hunter+value
		    dbExec(db,"UPDATE tableUserpanel SET Hunter=? WHERE playerUser=?",setValue,user)
		elseif data == "topTime" then
		    local setValue = info.topTime+value
		    dbExec(db,"UPDATE tableUserpanel SET topTime=? WHERE playerUser=?",setValue,user)
		elseif data == "bet" then
		    local setValue = info.bet+value
		    dbExec(db,"UPDATE tableUserpanel SET bet=? WHERE playerUser=?",setValue,user)
		elseif data == "spin" then
		    local setValue = info.spin+value
		    dbExec(db,"UPDATE tableUserpanel SET spin=? WHERE playerUser=?",setValue,user)
		elseif data == "online" then
		    local setValue = info.online+value
		    dbExec(db,"UPDATE tableUserpanel SET online=? WHERE playerUser=?",setValue,user)
		elseif data == "shotColor" then
		    local setValue = info.shotColor+value
		    dbExec(db,"UPDATE tableUserpanel SET shotColor=? WHERE playerUser=?",setValue,user)		
		end	
	end
	refreshNowDatas(player)
end
--#Get data value
function getDataValue(player,data)
    local user = getAccountName(getPlayerAccount(player))
	local selectUser = dbQuery(db,"SELECT * FROM tableUserpanel WHERE playerUser=?",user)
	local result = dbPoll(selectUser,-1) or {}
	for _,info in ipairs(result) do
        if data == "playerName" then
		    return info.playerName
		elseif data == "points" then
		    return formatValue(info.points)
	    elseif data == "cash" then
		    return formatValue(info.cash)
	    elseif data == "dm" then
		    return formatValue(info.dm)
	    elseif data == "dd" then
		    return formatValue(info.dd)
	    elseif data == "fun" then
		    return formatValue(info.fun)
		elseif data == "mapsPlayed" then
		    return formatValue(info.mapsPlayed)
	    elseif data == "carColor" then
		    return info.carColor
	    elseif data == "lightColor" then
		    return info.lightColor
	    elseif data == "nitroColor" then
		    return info.nitroColor
		elseif data == "policeHeadLight" then
		    return info.policeHeadLight
		elseif data == "Hunter" then
		    return formatValue(info.Hunter)
		elseif data == "topTime" then
		    return formatValue(info.topTime)
		elseif data == "bet" then
		    return formatValue(info.bet)
		elseif data == "spin" then
		    return formatValue(info.spin)
		elseif data == "online" then
		    return formatValue(info.online)
		elseif data == "shotColor" then
		    return info.shotColor
		end	
	end
end
--#Set data value
function setDataValue(player,data,value)
    local user = getAccountName(getPlayerAccount(player))
	local selectUser = dbQuery(db,"SELECT * FROM tableUserpanel WHERE playerUser=?",user)
	local result = dbPoll(selectUser,-1) or {}
	if #result == 0 then return end
    if data == "playerName" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `playerName`=? WHERE `playerUser`=?",value,user)
	elseif data == "points" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `points`=? WHERE `playerUser`=?",value,user)	
	elseif data == "cash" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `cash`=? WHERE `playerUser`=?",value,user)
	elseif data == "dm" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `dm`=? WHERE `playerUser`=?",value,user)
	elseif data == "dd" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `dd`=? WHERE `playerUser`=?",value,user)
	elseif data == "fun" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `fun`=? WHERE `playerUser`=?",value,user)
	elseif data == "mapsPlayed" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `mapsPlayed`=? WHERE `playerUser`=?",value,user)	
	elseif data == "carColor" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `carColor`=? WHERE `playerUser`=?",value,user)
	elseif data == "lightColor" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `lightColor`=? WHERE `playerUser`=?",value,user)
	elseif data == "nitroColor" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `nitroColor`=? WHERE `playerUser`=?",value,user)
	elseif data == "policeHeadLight" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `policeHeadLight`=? WHERE `playerUser`=?",value,user)
	elseif data == "Hunter" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `Hunter`=? WHERE `playerUser`=?",value,user)
	elseif data == "topTime" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `topTime`=? WHERE `playerUser`=?",value,user)
	elseif data == "bet" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `bet`=? WHERE `playerUser`=?",value,user)
	elseif data == "spin" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `spin`=? WHERE `playerUser`=?",value,user)
	elseif data == "online" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `online`=? WHERE `playerUser`=?",value,user)
	elseif data == "shotColor" then
	    dbExec(db,"UPDATE `tableUserpanel` SET `shotColor`=? WHERE `playerUser`=?",value,user)	
	end
	refreshNowDatas(player)
end
--#Save colors data
function setNewColor(player,id,r,g,b)
    local user = getAccountName(getPlayerAccount(player))
	local selectUser = dbQuery(db,"SELECT * FROM tableColors WHERE playerUser=?",user)
	local result = dbPoll(selectUser,-1) or {}
	if #result == 0 then return end
    if id == 1 then
	    dbExec(db,"UPDATE `tableColors` SET `color1`=?,`color2`=?,`color3`=? WHERE `playerUser`=?",r,g,b,user)
	elseif id == 2 then
	    dbExec(db,"UPDATE `tableColors` SET `color4`=?,`color5`=?,`color6`=? WHERE `playerUser`=?",r,g,b,user)
	elseif id == 3 then
	    dbExec(db,"UPDATE `tableColors` SET `color7`=?,`color8`=?,`color9`=? WHERE `playerUser`=?",r,g,b,user)
	elseif id == 4 then
	    dbExec(db,"UPDATE `tableColors` SET `color10`=?,`color11`=?,`color12`=? WHERE `playerUser`=?",r,g,b,user)	
	end
end
--#Get colors data
function getNewColor(player,id)
    local user = getAccountName(getPlayerAccount(player))
	local selectUser = dbQuery(db,"SELECT * FROM tableColors WHERE playerUser=?",user)
	local result = dbPoll(selectUser,-1) or {}
	if #result == 0 then return end
	for _,info in ipairs(result) do
        if id == 1 then
	        return info.color1,info.color2,info.color3
	    elseif id == 2 then
	        return info.color4,info.color5,info.color6
	    elseif id == 3 then
	        return info.color7,info.color8,info.color9
		elseif id == 4 then
	        return info.color10,info.color11,info.color12	
	    end
	end
end
--Joined Player
function startDataValue(player)
    if isPlayerLogged(player) then
        local user = getAccountName(getPlayerAccount(player))
	    local selectUser = dbQuery(db,"SELECT * FROM tableUserpanel WHERE playerUser=?",user)
		local result = dbPoll(selectUser,-1) or {}
	    if #result == 0 then
	        dbExec(db,"INSERT INTO `tableUserpanel`(`playerUser`,`playerName`,`points`,`cash`,`dm`,`dd`,`fun`,`mapsPlayed`,`carColor`,`lightColor`,`nitroColor`,`policeHeadLight`,`Hunter`,`topTime`,`bet`,`spin`,`online`,`shotColor`) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",user,getPlayerName(player),"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0")
		    dbExec(db,"INSERT INTO `tableColors`(`playerUser`,`color1`,`color2`,`color3`,`color4`,`color5`,`color6`,`color7`,`color8`,`color9`,`color10`,`color11`,`color12`) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",user,"0","0","0","0","0","0","0","0","0","0","0","0")
		    outputDebugString("New Data Added by "..string.gsub(getPlayerName(player),"(#%x%x%x%x%x%x)",""))
	    end
		callClientFunction(player,"startSettings")
		setElementData(player,"playerOnline",getTickCount())
		setColorInLogin(player)
		setDataValue(player,"playerName",getPlayerName(player))
		onRecallTeam(player)
		loginDonator(player)
		loginMissions(player)
		refreshNowDatas(player)
	end
end
--#Take money
function onTakeMoney(player,price)
	local playerCash = tonumber(getDataValue(player,"cash"))
	if playerCash >= tonumber(price) then
		setDataValue(player,"cash",playerCash-price)
		refreshNowDatas(player)
		return true
	else
        return false
	end
end
--#Get ranking player
function getRankingData(player,data)
	local select = dbQuery(db,"SELECT * FROM tableUserpanel")
	local result = dbPoll(select,-1) or {}
	local RankingData = {}
	for _, info in ipairs(result) do
	    local getData = false
        if data == "points" then getData = info.points end
		if data == "cash" then getData = info.cash end
		if data == "dm" then getData = info.dm end
		if data == "dd" then getData = info.dd end
		if data == "fun" then getData = info.fun end
		if data == "mapsPlayed" then getData = info.mapsPlayed end
		if data == "Hunter" then getData = info.Hunter end
		if data == "topTime" then getData = info.topTime end
		if data == "bet" then getData = info.bet end
		if data == "spin" then getData = info.spin end
		if data == "online" then getData = info.online end
        if info.playerName and getData then
		    getData = formatValue(getData)
		    table.insert(RankingData,{name=info.playerName,data=getData})
		end
	end
	table.sort(RankingData,function(a,b) return(tonumber(a.data) or 0 ) > ( tonumber(b.data) or 0 ) end )
	if data == "cash" then for i,data in ipairs (RankingData) do data.data = "$"..data.data end end
	if data == "online" then for i,data in ipairs (RankingData) do data.data = msToTimeString(data.data) end end
	callClientFunction(player,"refreshRanking",RankingData)
end
--#Get player stats
function getPlayerAllData(player,getPlayer)
	local user = getAccountName(getPlayerAccount(getPlayer))
	local selectUser = dbQuery(db,"SELECT * FROM tableUserpanel WHERE playerUser=?",user)
	local result = dbPoll(selectUser,-1) or {}
	local RankingData = {}
	if #result == 0 then return end
	for _, info in ipairs(result) do
	    local name = info.playerName
        local points = formatValue(info.points)
		local cash = "$"..formatValue(info.cash)
		local dm = formatValue(info.dm)
		local dd = formatValue(info.dd)
		local fun = formatValue(info.fun)
		local mapsPlayed = formatValue(info.mapsPlayed)
		local Hunter = formatValue(info.Hunter)
		local topTime = formatValue(info.topTime)
		local bet = formatValue(info.bet)
		local spin = formatValue(info.spin)
		local online = msToTimeString(info.online)
		local missoes = getDataMissonsValue(player,"congruation")
		table.insert(RankingData,{name,points,cash,dm,dd,fun,mapsPlayed,Hunter,topTime,bet,spin,online,missoes})
    end
	callClientFunction(player,"refreshPlayerStats",RankingData)
end
--#Music
function getMusicList(player)
    local infoMusic = {}
    local getInfoMusic = dbQuery(db,"SELECT * FROM tableMusic")
	local result = dbPoll(getInfoMusic,-1) or {}
	for _,info in ipairs(result) do
	    table.insert(infoMusic,{info.musicName,info.musicLink})
	end
	if player then
	    callClientFunction(player,"updateMusicList",infoMusic)
	else
        callClientFunction(root,"updateMusicList",infoMusic)
    end	
end
function musicRemove( player, ...)
	local mess = nil for k,v in pairs({...}) do if mess == nil then mess = v else mess = mess .. " " .. v end end
	local getMusic = dbQuery(db,"SELECT * FROM tableMusic WHERE musicName=?",mess)
	local result = dbPoll(getMusic,-1) or {}
	if not isPlayerOnGroup(player) then
	    return
	end
	if not mess then
	    return
	end
	if #result == 0 or not getMusic then
		callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	else
		dbExec(db,"DELETE FROM `tableMusic` WHERE `musicName`=?",mess)
		callClientFunction(root,"createNotify","Musica "..mess.." deletada por "..getPlayerName(player),0,144,200)
		for _,playerx in ipairs(getElementsByType("player")) do
		    getMusicList(playerx)
		end
	end
end
function addMusic( player, cmd, link, ...)
	local mess = nil for k,v in pairs({...}) do if mess == nil then mess = v else mess = mess .. " " .. v end end
	local getMusic = dbQuery(db,"SELECT * FROM tableMusic WHERE musicName=?", mess)
	local result = dbPoll(getMusic,-1) or {}
	if not isPlayerOnGroup ( player ) then
	    return
	end
	if not link or not mess then
	    callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	    return
	end
	if #result == 0 or not getMusic then
		dbExec(db,"INSERT INTO `tableMusic`(`musicName`,`musicLink`) VALUES(?,?)", mess, link)
		callClientFunction(player,"createNotify","Musica "..mess.." adicionada a biblioteca por "..getPlayerName( player ),0,236,0)
		getMusicList()
	else
		callClientFunction(player,"createNotify","Esta musica ja esta na biblioteca.",255,0,0)
	end
end
addCommandHandler("musicAdd",addMusic)
-- team
function onCreateNewTeam( player, teamName, r, g, b, Owner, Level)
    if player and teamName and r and g and b and Owner and Level then
        local newTeam = createTeam ( teamName )
	    if ( newTeam ) then
		    setPlayerTeam ( player, newTeam )
		    setTeamColor ( newTeam, r, g ,b)
		    dbExec(db,"INSERT INTO `systemTeam`(`teamName`,`teamColor1`,`teamColor2`,`teamColor3`,`reputation`,`cash`,`tag`,`rainbow`,`teamColor4`,`teamColor5`,`teamColor6`) VALUES(?,?,?,?,?,?,?,?,?,?,?)", teamName, r, g, b, 0, 0,"","",0,0,0)
			dbExec(db,"INSERT INTO `playerTeam`(`playerUser`,`teamName`,`playerLevel`,`playerName`) VALUES(?,?,?,?)", Owner, teamName, Level,getPlayerName(player))
			callClientFunction(root,"createNotify","Nova equipe criada - Nome "..teamName..", Dono "..getPlayerName( player ),0,236,0)
			callClientFunction(player,"closeTeamPage2",true)
	    end
	end
end
function getPlayerLevel( player )
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local playerTeam = dbQuery(db,"SELECT * FROM playerTeam WHERE playerUser=?", playerUser)
	local result = dbPoll(playerTeam,-1) or {}
	for _,info in ipairs(result) do
	    return tonumber(info.playerLevel)
	end
	return false
end
function getPlayerLevelFromUser( player )
	local playerTeam = dbQuery(db,"SELECT * FROM playerTeam WHERE playerUser=?", player)
	local result = dbPoll(playerTeam,-1) or {}
	for _,info in ipairs(result) do
	    return tonumber(info.playerLevel)
	end
	return false
end
function getPlayerTeamName( player )
    local user = getAccountName(getPlayerAccount(player))
	local playerTeam = dbQuery(db,"SELECT * FROM playerTeam WHERE playerUser=?", user)
	local result = dbPoll(playerTeam,-1) or {}
	for _,info in ipairs(result) do
	    return info.teamName
	end
	return false
end
function setPlayerLevelTeam( player, toPlayer, level)
    if player and toPlayer and level then
	    dbExec(db,"UPDATE `playerTeam` SET `playerLevel`=? WHERE `playerUser`=?", level, toPlayer)
		callClientFunction(player,"createNotify","Voce atualizou os previlegios do jogador.",0,236,0)
		getTeamAllStatus( player )
	end
end
function onChangeColorTeam(player,type,r,g,b)
    if player and r and g and b then
        setTeamColor(getPlayerTeam(player),r,g,b)
		if type == 1 then
			dbExec(db,"UPDATE `systemTeam` SET `teamColor1`=?, `teamColor2`=?, `teamColor3`=? WHERE `teamName`=?", r, g, b, getTeamName(getPlayerTeam ( player )))
		elseif type == 2 then
		    dbExec(db,"UPDATE `systemTeam` SET `rainbow`=?, `teamColor4`=?, `teamColor5`=?, `teamColor6`=? WHERE `teamName`=?", "1",r, g, b, getTeamName(getPlayerTeam ( player )))
		end
		callClientFunction(player,"createNotify","Voce comprou uma nova cor para equipe.",0,236,0)
	end
end
function onChangeNewTeamTag ( player, tag)
    if player and tag then
		dbExec(db,"UPDATE `systemTeam` SET `tag`=? WHERE `teamName`=?", tag, getTeamName(getPlayerTeam ( player )))
		callClientFunction(player,"createNotify","Voce comprou uma nova TAG para equipe.",0,236,0)
	end
end
function onDestroyTeam ( player, teamName)
    if player and teamName then
        dbExec(db,"DELETE FROM `systemTeam` WHERE `teamName`=?", teamName)
		dbExec(db,"DELETE FROM `playerTeam` WHERE `teamName`=?", teamName)
		for i,players in ipairs(getPlayersInTeam(getTeamFromName(teamName))) do
		    callClientFunction(players,"closeTeamPage2",false)
		end
        callClientFunction(root,"createNotify","Equipe - Nome "..teamName.." deletada pelo dono "..getPlayerName( player ),0,144,200)
		destroyElement( getTeamFromName(teamName) )
	end
end
function onRecallTeam( player )
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local playerTeam = dbQuery(db,"SELECT * FROM playerTeam WHERE playerUser=?", playerUser)
	local result = dbPoll(playerTeam,-1) or {}
	if #result == 0 then
	    return
	end
	for _,info in ipairs(result) do
	    local search = dbQuery(db,"SELECT * FROM systemTeam WHERE teamName=?", info.teamName)
		local _result = dbPoll(search,-1) or {}
		local getTeam = getTeamFromName( info.teamName )
		for _,team in ipairs(_result) do
		    if getTeam then
			    for i,players in ipairs(getPlayersInTeam(getTeam)) do
					_outputChatBox("_s[_wEquipe_s] _wO jogador "..getPlayerName( player ).." #ffffffentrou na sua equipe.",players,255,255,255,true)
				end
				_outputChatBox("_s[_wEquipe_s] _wVoce entro na equipe "..info.teamName,player,255,255,255,true)
		        setPlayerTeam(player,getTeam)
		    else
                local newTeam = createTeam(info.teamName,team.teamColor1,team.teamColor2,team.teamColor3)
				if newTeam then
			        setPlayerTeam(player,newTeam)
					_outputChatBox("_s[_wEquipe_s] _wVoce entro na equipe "..info.teamName,player,255,255,255,true)
				end
		    end
		end
	end
	updatePlayerNameInTeamTable(player,false)
end
function getTeamAllStatus( player )
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local playerTeam = dbQuery(db,"SELECT * FROM playerTeam WHERE playerUser=?", playerUser)
	local result = dbPoll(playerTeam,-1) or {}
	if #result == 0 then return end
	for _, info in ipairs(result) do
	    infoTea = getTeamInfo(info.teamName)
	    infoMem = getPlayerInTeam(info.teamName,infoTea[1][4])
	end
	callClientFunction(player,"updateTeamAllInfos",infoMem,infoTea)
end
function getTeamInfo( teamName )
    local info = {}
    local getInfo = dbQuery(db,"SELECT * FROM systemTeam WHERE teamName=?", teamName)
	local result = dbPoll(getInfo,-1) or {}
    for _, team in ipairs(result) do
	    repu = formatValue(team.reputation)
		cash = formatValue(team.cash)
		tag = team.tag
		table.insert(info,{team.teamName,repu,cash,tag})
	end
	return info
end
function getPlayerInTeam( teamName ,tag)
    local info = {}
    local getInfo = dbQuery(db,"SELECT * FROM playerTeam WHERE teamName=?", teamName)
	local result = dbPoll(getInfo,-1) or {}
    for _,player in ipairs(result) do
		table.insert(info,{tag..player.playerName,player.playerUser,formatValue(player.playerLevel)})
	end
	return info
end
function addTeamData( teamName, data, value)
    local getInfo = dbQuery(db,"SELECT * FROM systemTeam WHERE teamName=?", teamName)
	local result = dbPoll(getInfo,-1) or {}
    for _, team in ipairs(result) do
	    if data == "exp" then
	        new = team.reputation + value
			dbExec(db,"UPDATE `systemTeam` SET `reputation`=? WHERE `teamName`=?", new, teamName)
		elseif data == "cash" then
		    new = team.cash + value
			dbExec(db,"UPDATE `systemTeam` SET `cash`=? WHERE `teamName`=?", new, teamName)
		end
	end
end
function takeTeamData(teamName,data,value)
    local getInfo = dbQuery(db,"SELECT * FROM systemTeam WHERE teamName=?", teamName)
	local result = dbPoll(getInfo,-1) or {}
    for _, team in ipairs( result ) do
	    if data == "exp" then
		    local repu = tonumber(team.reputation)
		    if repu > tonumber(value) then
	            new = repu - value
			    dbExec(db,"UPDATE `systemTeam` SET `reputation`=? WHERE `teamName`=?", new, teamName)
				return true
			else
                return false  
			end
		elseif data == "cash" then
		    local cash = tonumber(team.cash)
		    if cash > tonumber(value) then
		        new = cash - value
			    dbExec(db,"UPDATE `systemTeam` SET `cash`=? WHERE `teamName`=?", new, teamName)
				return true
			else
                return false  
			end
		end
	end
end
function getTeamRankingData( player )
	local select = dbQuery(db,"SELECT * FROM systemTeam ")
	local result = dbPoll(select,-1) or {}
	local RankingData1 = {}
	local RankingData2 = {}
	for _,info in ipairs(result) do
        if info.teamName and info.reputation and info.cash then
		    exp = formatValue(info.reputation)
			cash = formatValue(info.cash)
			countPlayers = countPlayerInTeamData(info.teamName)
		    table.insert( RankingData1,{ name = info.teamName, data = cash, countPlayers = countPlayers})
			table.insert( RankingData2,{ name = info.teamName, data = exp, countPlayers = countPlayers})
		end
	end
	table.sort(RankingData1,function(a,b) return(tonumber(a.data) or 0 ) > ( tonumber(b.data) or 0 ) end )
	table.sort(RankingData2,function(a,b) return(tonumber(a.data) or 0 ) > ( tonumber(b.data) or 0 ) end )
	for i,data in ipairs (RankingData1) do data.data = "$"..data.data end
	callClientFunction(player,"refreshTeamRanking",RankingData1,RankingData2)
end
function updatePlayerNameInTeamTable(player,argument)
	local playerUser = getAccountName( getPlayerAccount( player ) )
	local playerTeam = dbQuery(db,"SELECT * FROM playerTeam WHERE playerUser=?", playerUser)
	local result = dbPoll(playerTeam,-1) or {}
	if #result ~= 0 then
	    if argument then
	        dbExec(db,"UPDATE `playerTeam` SET `playerName`=? WHERE `playerUser`=?", argument, playerUser)
		else
            dbExec(db,"UPDATE `playerTeam` SET `playerName`=? WHERE `playerUser`=?", getPlayerName(player), playerUser)
        end		
	end
end
function countPlayerInTeamData(teamName)
    local playerTeam = dbQuery(db,"SELECT * FROM playerTeam WHERE teamName=?", teamName)
	local result = dbPoll(playerTeam,-1) or {}
	return #result
end
function getPlayerTeamStatus( player )
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local playerTeam = dbQuery(db,"SELECT * FROM playerTeam WHERE playerUser=?", playerUser)
	local result = dbPoll(playerTeam,-1) or {}
	if #result == 0 then
	    return false
	else
        return true	
	end
end
function onQuitTeam ( player )
    local playerUser = getAccountName( getPlayerAccount( player ) )
    if player then
		dbExec(db,"DELETE FROM `playerTeam` WHERE `playerUser`=?",playerUser)
		setPlayerTeam(player,nil)
		callClientFunction(player,"createNotify","Voce saiu da equipe com sucesso.",0,236,0)
	end
	callClientFunction(player,"closeTeamPage2",false)
end
function getTeamFromSearchName( name )
    local search = dbQuery(db,"SELECT * FROM systemTeam WHERE teamName=?", name)
	local result = dbPoll(search,-1) or {}
    if #result == 0 then
	    return false
	else
        return true	
	end
end
function onKickPlayerTeam( player, toPlayer)
    if player and toPlayer then
		dbExec(db,"DELETE FROM `playerTeam` WHERE `playerUser`=?", toPlayer)
		callClientFunction(player,"createNotify","Voce removeu o jogador com sucesso.",0,236,0)
	end
	for i,players in ipairs (getElementsByType("player")) do
	    if isPlayerLogged ( players ) then
		    local playerUser = getAccountName( getPlayerAccount( players ) )
			if toPlayer == playerUser then
	            if not getPlayerTeamStatus( players ) then
		            setPlayerTeam( players, nil)
					callClientFunction(players,"closeTeamPage2",false)
	                _outputChatBox("_s[_wEquipe_s] _wVoce foi expulso da equipe pelo Dono.",players,255,255,255,true)
		        end
			end
		end
	end
end
function changePlayerTeam ( player, teamName , Level)
    local playerUser = getAccountName( getPlayerAccount( player ) )
    if  player and playerUser and teamName and Level then
        dbExec(db,"INSERT INTO `playerTeam`(`playerUser`,`teamName`,`playerLevel`,`playerName`) VALUES(?,?,?,?)", playerUser, teamName, Level, getPlayerName(player))
		onRecallTeam( player )
	end
end
function onPlayerQuitServer(player)
    local Team = getPlayerTeam(player)
	if Team then
        if ( tonumber ( countPlayersInTeam ( Team ) ) == 1 ) then
            destroyElement( Team )
        end
	end
end
-- Export Functions
function getQueueLists()
    return mapQueue,saveSound
end
function getTeamTag( player )
    local tag = false
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local playerTeam = dbQuery(db,"SELECT * FROM playerTeam WHERE playerUser=?", playerUser)
	local result = dbPoll(playerTeam,-1) or {}
	if #result == 0 then
	    tag = false
	else
        for _, info in ipairs(result) do
	        local search = dbQuery(db,"SELECT * FROM systemTeam WHERE teamName=?", info.teamName)
			local _result = dbPoll(search,-1) or {}
		    for _, team in ipairs(_result) do
			    tag = team.tag
			end
		end	
	end
	return tag
end
-- donator
function addPlayerDonator ( player, days)
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local donatorPlayer = dbQuery(db,"SELECT * FROM donator WHERE playerUser=?", playerUser)
	local result = dbPoll(donatorPlayer,-1) or {}
    if playerUser and tonumber(days) then
		if #result == 0 then
		    local currentTime = getRealTime()
		    local oneDay = 86400
		    local daysToDonate = oneDay * days
		    local time = currentTime.timestamp + daysToDonate
            dbExec(db,"INSERT INTO `donator`(`playerUser`,`time`) VALUES(?,?)", playerUser, time)
		else
		    for _,info in ipairs(result) do
		        local oneDay = 86400
		        local daysToDonate = oneDay * days
                new = info.time + daysToDonate
			    dbExec(db,"UPDATE `donator` SET `time`=? WHERE `playerUser`=?", new, playerUser)
			end
		end
		callClientFunction(player,"createNotify","Voce recebeu "..days.." de Donator!",0,236,0)
		callClientFunction(player,"createNotify","Obrigado por nos ajudar! =D",0,236,0)
		callClientFunction(player,"closeDonator",true)
    end
end
function removePlayerDonator ( player, byPlayer)
    local playerUser = getAccountName( getPlayerAccount( player ) )
    if playerUser and byPlayer then
	    dbExec(db,"DELETE FROM `donator` WHERE `playerUser`=?", playerUser)
		callClientFunction(player,"createNotify",byPlayer.."#ffffff removeu voce dos Donator's.",230,0,0)
    end
end
function loginDonator( player )
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local donatorPlayer = dbQuery(db,"SELECT * FROM donator WHERE playerUser=?", playerUser)
	local result = dbPoll(donatorPlayer,-1) or {}
	if #result ~= 0 then
	    for _, info in ipairs(result) do
		    local donatorTime = tonumber(info.time)
			local currentTime = getRealTime()
			if donatorTime > currentTime.timestamp then
			    local time = secoundsToDays(donatorTime-currentTime.timestamp)
				callClientFunction(player,"createNotify","O seu Donator termina em "..time..". Obrigado por nos ajudar! =D",0,236,0)
			else
			    removePlayerDonator ( player, "Console")
			    callClientFunction(player,"createNotify","O seu Donator acabou.",255,0,0)
			end
		end
	end
end
function refreshDonator( player )
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local donatorPlayer = dbQuery(db,"SELECT * FROM donator WHERE playerUser=?", playerUser)
	local result = dbPoll(donatorPlayer,-1) or {}
	if #result ~= 0 then
	    for _, info in ipairs(result) do
		    local donatorTime = tonumber(info.time)
			local currentTime = getRealTime()
			if donatorTime < currentTime.timestamp then
			    removePlayerDonator ( player, "Console")
			    callClientFunction(player,"createNotify","O seu Donator acabou.",255,0,0)
				callClientFunction(player,"closeDonator",false)
			end
		end
	end
end
function getDonatorPlayer( player )
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local donatorPlayer = dbQuery(db,"SELECT * FROM donator WHERE playerUser=?", playerUser)
	local result = dbPoll(donatorPlayer,-1) or {}
	if #result == 0 then
	    return false
	else
        return true	
	end
end
-- missions
function loginMissions(player)
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local missionsPlayer = dbQuery(db,"SELECT * FROM missions WHERE playerUser=?", playerUser)
	local result = dbPoll(missionsPlayer,-1) or {}
	if #result ~= 0 then
	    for _, info in ipairs(result) do
		    local missionsTime = tonumber(info.time)
			local currentTime = getRealTime()
			if missionsTime > currentTime.timestamp then
			    local time = secoundsToDays(missionsTime-currentTime.timestamp)
				callClientFunction(player,"createNotify","O tempo para completar as missoes termina em "..time..".",0,236,0)
			else
			    local time = currentTime.timestamp + 86400
				dbExec(db,"DELETE FROM `missions` WHERE `playerUser`=?", playerUser)
				dbExec(db,"INSERT INTO `missions`(`playerUser`,`time`,`miss1`,`miss2`,`miss3`,`miss4`,`miss5`,`miss6`,`miss7`,`miss8`,`congruation`,`miss9`) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)", playerUser, time, "0", "0", "0", "0", "0", "0", "0", "0", "0", "0")
			    callClientFunction(player,"createNotify","Suas missoes foram resetadas.",0,236,0)
			end
		end
	else
        local currentTime = getRealTime()
		local time = currentTime.timestamp + 86400
		dbExec(db,"INSERT INTO `missions`(`playerUser`,`time`,`miss1`,`miss2`,`miss3`,`miss4`,`miss5`,`miss6`,`miss7`,`miss8`,`congruation`,`miss9`) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)", playerUser, time, "0", "0", "0", "0", "0", "0", "0", "0", "0", "0")
        callClientFunction(player,"createNotify","Sistema de missoes iniciado para voce!",0,236,0)	
	end
end
function refreshMissions(player)
    local playerUser = getAccountName( getPlayerAccount( player ) )
	local missionsPlayer = dbQuery(db,"SELECT * FROM missions WHERE playerUser=?", playerUser)
	local result = dbPoll(missionsPlayer,-1) or {}
	if #result ~= 0 then
	    for _, info in ipairs(result) do
		    local missionsTime = tonumber(info.time)
			local currentTime = getRealTime()
			if missionsTime < currentTime.timestamp then
			    local time = currentTime.timestamp + 86400
				dbExec(db,"DELETE FROM `missions` WHERE `playerUser`=?", playerUser)
				dbExec(db,"INSERT INTO `missions`(`playerUser`,`time`,`miss1`,`miss2`,`miss3`,`miss4`,`miss5`,`miss6`,`miss7`,`miss8`,`congruation`,`miss9`) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)", playerUser, time, "0", "0", "0", "0", "0", "0", "0", "0", "0", "0")
			    callClientFunction(player,"createNotify","Suas missoes foram resetadas.",0,236,0)
			end
		end
	end
end
function addDataMissionsValue(player,data,value)
    local value = value or 1
	local user = getAccountName(getPlayerAccount(player))
	local selectUser = dbQuery(db,"SELECT * FROM missions WHERE playerUser=?",user)
	local result = dbPoll(selectUser,-1) or {}
	if #result == 0 then return end
	for _, info in ipairs(result) do
        if data == "miss1" then
		    local setValue = info.miss1+value
		    dbExec(db,"UPDATE `missions` SET `miss1`=? WHERE `playerUser`=?",setValue,user)
	    elseif data == "miss2" then
		    local setValue = info.miss2+value
		    dbExec(db,"UPDATE `missions` SET `miss2`=? WHERE `playerUser`=?",setValue,user)
		elseif data == "miss3" then
		    local setValue = info.miss3+value
		    dbExec(db,"UPDATE `missions` SET `miss3`=? WHERE `playerUser`=?",setValue,user)
	    elseif data == "miss4" then
		    local setValue = info.miss4+value
		    dbExec(db,"UPDATE `missions` SET `miss4`=? WHERE `playerUser`=?",setValue,user)
	    elseif data == "miss5" then
		    local setValue = info.miss5+value
		    dbExec(db,"UPDATE `missions` SET `miss5`=? WHERE `playerUser`=?",setValue,user)
	    elseif data == "miss6" then
		    local setValue = info.miss6+value
		    dbExec(db,"UPDATE `missions` SET `miss6`=? WHERE `playerUser`=?",setValue,user)
		elseif data == "miss7" then
		    local setValue = info.miss7+value
		    dbExec(db,"UPDATE `missions` SET `miss7`=? WHERE `playerUser`=?",setValue,user)
	    elseif data == "miss8" then
		    local setValue = info.miss8+value
		    dbExec(db,"UPDATE `missions` SET `miss8`=? WHERE `playerUser`=?",setValue,user)
		elseif data == "congruation" then
		    local setValue = info.congruation+value
		    dbExec(db,"UPDATE `missions` SET `congruation`=? WHERE `playerUser`=?",setValue,user)
		elseif data == "miss9" then
		    local setValue = info.miss9+value
		    dbExec(db,"UPDATE `missions` SET `miss9`=? WHERE `playerUser`=?",setValue,user)		
		end	
	end
end
function getDataMissonsValue(player,data)
    local user = getAccountName(getPlayerAccount(player))
	local selectUser = dbQuery(db,"SELECT * FROM missions WHERE playerUser=?", user)
	local result = dbPoll(selectUser,-1) or {}
	if #result == 0 then return end
	for _, info in ipairs(result) do
        if data == "miss1" then
		    return info.miss1
		elseif data == "miss2" then
		    return info.miss2
	    elseif data == "miss3" then
		    return info.miss3
	    elseif data == "miss4" then
		    return info.miss4
	    elseif data == "miss5" then
		    return info.miss5
	    elseif data == "miss6" then
		    return info.miss6
		elseif data == "miss7" then
		    return info.miss7
	    elseif data == "miss8" then
		    return info.miss8
		elseif data == "congruation" then
		    return info.congruation
		elseif data == "miss9" then
		    return info.miss9	
		end	
	end
end
function getMissionsAllData(player)
	local user = getAccountName(getPlayerAccount(player))
	local selectUser = dbQuery(db,"SELECT * FROM missions WHERE playerUser=?",user)
	local result = dbPoll(selectUser,-1) or {}
	local MissionsData = {}
	if #result == 0 then return end
	for _, info in ipairs(result) do
	    local miss1 = formatValue(info.miss1)
		local miss2 = formatValue(info.miss2)
		local miss3 = formatValue(info.miss3)
		local miss4 = formatValue(info.miss4)
		local miss5 = formatValue(info.miss5)
		local miss6 = formatValue(info.miss6)
		local miss7 = formatValue(info.miss7)
		local miss8 = formatValue(info.miss8)
		local miss9 = formatValue(info.miss9)
		table.insert(MissionsData,{miss1,miss2,miss3,miss4,miss5,miss6,miss7,miss8,miss9})
    end
	callClientFunction(player,"refreshMissionsStats",MissionsData)
end
--ranking tab
function updatePlayerRank()
    players = #getElementsByType("player")
	if players == 0 then return end
    for i,player in ipairs (getElementsByType("player")) do
	    local user = getAccountName(getPlayerAccount(player))
	    local select = dbQuery(db,"SELECT * FROM tableUserpanel ")
		local result = dbPoll(select,-1) or {}
	    if isPlayerLogged(player) then
		    local playerCash = getDataValue(player,"cash") or "0"
			local playerPoints = getDataValue(player,"points") or "0"
			setElementData(player,"Cash","$"..playerCash)
			setElementData(player,"Points",playerPoints)
		    local rankTable = {}
			for _, info in ipairs(result) do
			    table.insert(rankTable,{name=info.playerUser,data=info.points})
	        end
			table.sort(rankTable,function(a,b) return(tonumber(a.data) or 0 ) > (tonumber(b.data) or 0 ) end )
			for i=1,#rankTable do
				if rankTable[i].name == user then
					setElementData(player,"Rank",i)
					break
				end
		    end
			local playerOnline = getTickCount()-getElementData(player,"playerOnline")
			addDataValue(player,"online",playerOnline)
			setElementData(player,"playerOnline",getTickCount())
			refreshDonator(player)
			refreshMissions(player)
			local teamTag = getTeamTag( player )
			setElementData(player,"teamTag",teamTag)
		else
		    setElementData(player,"Cash","Guest")
			setElementData(player,"Points","Guest")
			setElementData(player,"Rank","?")
	    end
	end
	outputDebugString("Updating rank for all player",0,236,63,144)
end
setTimer(updatePlayerRank,60000,0)
--team rainbow
local __pro = 0
function teamRainbow()
    __pro = __pro + 0.01
	if __pro >= 1 then __pro = 0 end
    local select = dbQuery(db,"SELECT * FROM systemTeam ")
	local result = dbPoll(select,-1) or {}
    for _,info in ipairs(result) do
	    local getTeam = getTeamFromName(info.teamName)
	    if info.rainbow == "1" and getTeam then
		    r,g,b = interpolateBetween(info.teamColor1,info.teamColor2,info.teamColor3,info.teamColor4,info.teamColor5,info.teamColor6,__pro,"SineCurve")
			setTeamColor(getTeam,r,g,b)
		end
    end
end	
setTimer(teamRainbow,50,0)