
function safestring( s )
    return s:gsub( "(['])", "''" )
end

function qsafestring( s )
    return "'" .. safestring(s) .. "'"
end

function qsafetablename( s )
    return qsafestring(s)
end

function onMapStartingHandler(mapInfo)
    getMap = getResourceFromName(mapInfo.resname)
	mapDM = false
	mapDM = string.find(mapInfo.name,"DM",1)
	getNextList()
	if not mapDM then return triggerClientEvent(root,"showTopList",root,{},getResourceInfo(getMap,"name")) end
	if getMap then
	    executeSQLQuery('CREATE TABLE IF NOT EXISTS ' .. qsafetablename( 'race maptimes '..mapInfo.modename..' '..getResourceInfo(getMap, "name"))..' ( playerName TEXT, playerSerial TEXT, timeMs TEXT, timeText TEXT, dateRecorded TEXT, extra TEXT)')
	    query = executeSQLQuery('SELECT * FROM ' .. qsafetablename( 'race maptimes '..mapInfo.modename..' '..getResourceInfo(getMap, "name") ))
		if not query then
			return outputDebugString("table this map failed")
		end
        getMapTopTimes(getResourceInfo(getMap,"name"),mapInfo.modename)
	end
end
addEvent("onMapStarting",true)
addEventHandler("onMapStarting",root,onMapStartingHandler)

function getMapTopTimes(info,mode)
    local query = executeSQLQuery(' SELECT * FROM '..qsafetablename('race maptimes '..mode..' '..info))
	local toptimes = {}
	if info and mode then
		if #query ~= 0  then
			for i=1,#query do
				table.insert(toptimes,{query[i]["playerName"],query[i]["timeText"],query[i]["dateRecorded"],query[i]["extra"],query[i]["playerSerial"],data=query[i]["timeMs"]})
			end
			table.sort(toptimes,function(a,b) return(tonumber(a.data) or 0 ) < ( tonumber(b.data) or 0 ) end )
		end
		triggerClientEvent(root,"showTopList",root,toptimes,info)
	end
end

function getNextList(source)
    if not source then
    	local mapList,songsList = call(getResourceFromName("_userpanel"),"getQueueLists")
		if mapList and songsList then
			triggerClientEvent(root,"nextMapList",root,mapList)
		else
		    triggerClientEvent(root,"nextMapList",root,{})
		end
		return
	end
	local mapList,songsList = call(getResourceFromName("_userpanel"),"getQueueLists")
	if mapList and songsList then
		triggerClientEvent(source,"nextMapList",root,mapList)
	else
		triggerClientEvent(source,"nextMapList",root,{})
	end
end
addEvent("getNextMapList",true)
addEventHandler("getNextMapList",root,getNextList)


addEvent('onPlayerPickUpRacePickup',true)
addEventHandler('onPlayerPickUpRacePickup', root,
	function(number, sort, model)
	    if sort == "vehiclechange" then
	  	    if model == 425 then
			    if not mapDM then return end
				newTopTime(source,exports.race:getTimePassed())
			end
		end
	end
)

function newTopTime(player,newTime)
    if getElementData ( player, "state" ) ~= "alive" then
		return
	end
	if not mapDM then return end
    if isGuestAccount(getPlayerAccount(player)) then
		return
	end
    playerName = getPlayerName(player)
    serial = tostring(getPlayerSerial(player))
    timeMs = tonumber(newTime)
    timeText = tostring(convertMS(newTime))
    dateRecorded = tostring(getRealDateTimeNowString())
	extra = call(getResourceFromName("admin"),"getPlayerCountry",player) or ""
	local raceInfo = getRaceInfo()
	select = executeSQLQuery('SELECT * FROM ' .. qsafetablename( 'race maptimes '..raceInfo.mapInfo.modename..' '..raceInfo.mapInfo.name )..' WHERE playerSerial=?', serial)
    if #select == 0 then
	    executeSQLQuery('INSERT INTO ' .. qsafetablename( 'race maptimes '..raceInfo.mapInfo.modename..' '..raceInfo.mapInfo.name )..' ( playerName, playerSerial, timeMs, timeText, dateRecorded, extra) VALUES(?,?,?,?,?,?)',playerName,serial,timeMs,timeText,dateRecorded,extra)
		position, _ = getPlayerPosition(player)
		if position then
		    if position <= 10 then onMapStartingHandler(raceInfo.mapInfo) end
			outputChatBox("[TOPTIME] #FFFFFF"..playerName.." #FFFFFFGet a new Toptime in #FF6363"..position.." #ffffffwith time #FF6363"..timeText,root,255,106,106,true)
		end
		triggerEvent('onMissionGetTopTime',getRootElement(),player)
		triggerEvent('onPlayerToptimeImprovement',getRootElement(),player,position)
	else
	    for _,info in ipairs( select ) do
		    if timeMs < tonumber(info.timeMs) then
				executeSQLQuery('DELETE FROM ' .. qsafetablename( 'race maptimes '..raceInfo.mapInfo.modename..' '..raceInfo.mapInfo.name )..' WHERE playerSerial=?',serial)
        		executeSQLQuery('INSERT INTO ' .. qsafetablename( 'race maptimes '..raceInfo.mapInfo.modename..' '..raceInfo.mapInfo.name )..' ( playerName, playerSerial, timeMs, timeText, dateRecorded, extra) VALUES(?,?,?,?,?,?)',playerName,serial,timeMs,timeText,dateRecorded,extra)
				position, _ = getPlayerPosition(player)
				if position then
				    if position <= 10 then onMapStartingHandler(raceInfo.mapInfo) end
					outputChatBox("[TOPTIME] #FFFFFF"..playerName.." #FFFFFFGet a new Toptime in #FF6363"..position.." #ffffffwith time #FF6363"..timeText,root,255,106,106,true)
				end
			end
			triggerEvent('onMissionGetTopTime',getRootElement(),player)
			triggerEvent('onPlayerToptimeImprovement',getRootElement(),player,position)
		end
	end
end

function getPlayerPosition(player)
    local raceInfo = getRaceInfo()
    local query = executeSQLQuery(' SELECT * FROM ' .. qsafetablename( 'race maptimes '..raceInfo.mapInfo.modename..' '..raceInfo.mapInfo.name ))
	local toptimes = {}
	local index = false
	local time = false
	if player then
		if #query ~= 0 then
			for i=1,#query do
				table.insert(toptimes,{query[i]["playerSerial"],query[i]["timeText"],data=query[i]["timeMs"]})
			end
			table.sort(toptimes,function(a,b) return(tonumber(a.data) or 0 ) < ( tonumber(b.data) or 0 ) end )
		end
		if #toptimes ~= 0 then
		    for i=1,#toptimes do
			    if toptimes[i][1] == tostring(getPlayerSerial(player)) then
				    index = i
					time = toptimes[i][2]
				end
			end
		end
		return index, time
	end
end

function deleteTime(player,cmd,id)
    local account = getAccountName(getPlayerAccount(player))
	if not isObjectInACLGroup("user." .. account,aclGetGroup("Admin")) then
	    return 
	end
    local raceInfo = getRaceInfo()
	local info = {}
    local query = executeSQLQuery(' SELECT * FROM ' .. qsafetablename( 'race maptimes '..raceInfo.mapInfo.modename..' '..raceInfo.mapInfo.name ))
	if not player or not id then
	    return outputChatBox("[TOPTIME] #FFFFFFERROR. Use /deletetime positionTime.",player,255,106,106,true )
	end
	local id = tonumber(id)
	if #query == 0 then
	    return outputChatBox("[TOPTIME] #FFFFFFThis Map not have Toptimes.",player,255,106,106,true )
	end
	for i=1,#query do
	    table.insert(info,{query[i]["playerSerial"],query[i]["playerName"],data=query[i]["timeMs"]})
	end
	table.sort(info,function(a,b) return(tonumber(a.data) or 0 ) < ( tonumber(b.data) or 0 ) end )
	if info[id] then
		executeSQLQuery('DELETE FROM ' .. qsafetablename( 'race maptimes '..raceInfo.mapInfo.modename..' '..raceInfo.mapInfo.name )..' WHERE playerSerial=?',info[id][1])
		if id <= 10 then onMapStartingHandler(raceInfo.mapInfo) end
		placeText = id and "#" .. tostring(id) or ""
		outputChatBox( "[TOPTIME] #FFFFFFToptime #FF6363"..placeText.." #ffffffof " .. info[id][2] .. " #ffffffDeleted by " .. getPlayerName(player),root,255,106,106,true )
	else
        outputChatBox("[TOPTIME] #FFFFFFPosition not exists.",player,255,106,106,true )
	end
end
addCommandHandler( "deletetime", deleteTime)

function renameTime(player,cmd,id,text)
    local account = getAccountName(getPlayerAccount(player))
	if not isObjectInACLGroup("user." .. account,aclGetGroup("Admin")) then
	    return 
	end
    local raceInfo = getRaceInfo()
	local info = {}
    local query = executeSQLQuery(' SELECT * FROM ' .. qsafetablename( 'race maptimes '..raceInfo.mapInfo.modename..' '..raceInfo.mapInfo.name ))
	if not player or not id or not text then
	    return outputChatBox("[TOPTIME] #FFFFFFERROR. Use /renametop positionTime newNick.",player,255,106,106,true )
	end
	local id = tonumber(id)
	if #query == 0 then
	    return outputChatBox("[TOPTIME] #FFFFFFThis Map not have Toptimes.",player,255,106,106,true )
	end
	for i=1,#query do
	    table.insert(info,{query[i]["playerSerial"],query[i]["playerName"],data=query[i]["timeMs"]})
	end
	table.sort(info,function(a,b) return(tonumber(a.data) or 0 ) < ( tonumber(b.data) or 0 ) end )
	if info[id] then
	    text = tostring(text)
		executeSQLQuery('UPDATE ' .. qsafetablename( 'race maptimes '..raceInfo.mapInfo.modename..' '..raceInfo.mapInfo.name )..' SET playerName=? WHERE playerSerial=?',text,info[id][1])
		if id <= 10 then onMapStartingHandler(raceInfo.mapInfo) end
		placeText = id and "#" .. tostring(id) or ""
		outputChatBox( "[TOPTIME] #FFFFFFToptime #FF6363"..placeText.." #ffffffrename to " ..text.. " #ffffffby " .. getPlayerName(player),root,255,106,106,true )
	else
        outputChatBox("[TOPTIME] #FFFFFFPosition not exists.",player,255,106,106,true )
	end
end
addCommandHandler( "renametop", renameTime)

addEvent('getPersonalTime',true)
addEventHandler('getPersonalTime', root,
	function(player)
	    position, time = getPlayerPosition(player)
		if position and time then
            outputChatBox("[TOPTIME] #FFFFFFYour have a toptime in this map , in #FF6363#"..position.." #FFFFFFposition with time #FF6363"..time,player,255,106,106,true)
		end
	end
)

addEvent('getTopTimesTables',true)
addEventHandler('getTopTimesTables', root,
	function(player)
	    local raceInfo = getRaceInfo()
	    onMapStartingHandler(raceInfo.mapInfo)
	end
)

function getRaceInfo()
	local raceResRoot = getResourceRootElement( getResourceFromName( "race" ) )
	return raceResRoot and getElementData( raceResRoot, "info" )
end

function convertMS( timeMs )
	local minutes	= math.floor( timeMs / 60000 )
	local timeMs	= timeMs - minutes * 60000;
	local seconds	= math.floor( timeMs / 1000 )
	local ms		= timeMs - seconds * 1000;
	return string.format( '%02d:%02d:%03d', minutes, seconds, ms );
end

function getRealDateTimeNowString()
	return getRealDateTimeString( getRealTime() )
end

function getRealDateTimeString( time )
	return string.format( '%04d-%02d-%02d'
						,time.year + 1900
						,time.month + 1
						,time.monthday
						)
end