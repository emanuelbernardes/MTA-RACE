-- Create table of Maps
function createTable()
    mapRating = executeSQLQuery("CREATE TABLE IF NOT EXISTS mapRating (mapName TEXT, likes TEXT, dislikes TEXT)")
	playerRating = executeSQLQuery("CREATE TABLE IF NOT EXISTS playerRating (mapName TEXT, playerSerial TEXT)")
    if ( mapRating == false ) then
	    outputDebugString( "*Error Table mapRating" )
    else
	    outputDebugString( "*Create/Load Table mapRating" )
    end
	if ( playerRating == false ) then
	    outputDebugString( "*Error Table playerRating" )
    else
	    outputDebugString( "*Create/Load Table playerRating" )
    end
end
addEventHandler("onResourceStart",resourceRoot,createTable)
function delete(player,cmd)
    local account = getAccountName(getPlayerAccount(player))
	if not isObjectInACLGroup("user." .. account,aclGetGroup("Console")) then
	    return
	end
	executeSQLQuery("DROP TABLE mapRating")
	executeSQLQuery("DROP TABLE playerRating")
	outputDebugString("*Restarting race data base by console: "..account)
	createTable()
end
addCommandHandler("reloadrace",delete)
-- Insert in table mapRating(RandomMap)
function newMapRating(mapName)
    local select = executeSQLQuery("SELECT * FROM mapRating WHERE mapName=?", mapName.resname)
    if #select == 0 then
	    executeSQLQuery("INSERT INTO `mapRating`(`mapName`,`likes`,`dislikes`) VALUES(?,?,?)", mapName.resname,"0","0")
    end
end
addEvent("onMapStarting",true)
addEventHandler("onMapStarting",root,newMapRating)
-- Manager Table mapRating
function getMapRate(mapName)
    local select = executeSQLQuery("SELECT * FROM mapRating WHERE mapName=?", mapName)
	local like, dislike = "0", "0"
	for _, info in ipairs( select ) do
		like = formatValue(info.likes)
        dislike = formatValue(info.dislikes)
    end
	return like, dislike
end
function addMapRate(mapName,data,value)
    local select = executeSQLQuery("SELECT * FROM mapRating WHERE mapName=?", mapName)
	if #select == 0 then return end
	for _, info in ipairs( select ) do
        if data == "likes" then
		    newValue = info.likes + value
			executeSQLQuery("UPDATE `mapRating` SET `likes`=? WHERE `mapName`=?", newValue, mapName)
        end
		if data == "dislikes" then
		    newValue = info.dislikes + value
			executeSQLQuery("UPDATE `mapRating` SET `dislikes`=? WHERE `mapName`=?", newValue, mapName)
        end
    end
end
-- Manager Table playerRating
function getPlayerVoteMap(mapName,playerSerial)
    local select = executeSQLQuery("SELECT * FROM playerRating WHERE mapName=? AND playerSerial=?", mapName, playerSerial)
	if #select ~= 0 then
	    return true
	else
        return false
	end	
end
function addPlayerVoteMap(mapName,playerSerial)
    if mapName and playerSerial then
        executeSQLQuery("INSERT INTO `playerRating`(`mapName`,`playerSerial`) VALUES(?,?)", mapName, playerSerial)
	end	
end
-- add Like System
function addLike(player,cmd)
    local playerSerial = getPlayerSerial(player)
	local Map = exports.mapmanager:getRunningGamemodeMap()
	local currentMap = getResourceName(Map)
    if getPlayerVoteMap(currentMap,playerSerial) then
	    return outputChatBox("[ERRO]#FFFFFFVoce já votou neste mapa.",player,255,0,0,true)
	end
	addPlayerVoteMap(currentMap,playerSerial)
	addMapRate(currentMap,"likes",1)
	outputChatBox("[LIKE]#FFFFFFVoce deu like neste mapa.",player,0,236,0,true)
end
addCommandHandler("like",addLike)
-- add disLike System
function addDisLike(player,cmd)
    local playerSerial = getPlayerSerial(player)
	local Map = exports.mapmanager:getRunningGamemodeMap()
	local currentMap = getResourceName(Map)
    if getPlayerVoteMap(currentMap,playerSerial) then
	    return outputChatBox("[ERRO]#FFFFFFVoce ja votou neste mapa.",player,255,0,0,true)
	end
	addPlayerVoteMap(currentMap,playerSerial)
	addMapRate(currentMap,"dislikes",1)
	outputChatBox("[DISLIKE]#FFFFFFVoce deu Dislike neste mapa.",player,0,236,0,true)
end
addCommandHandler("dislike",addDisLike)
-- others
function formatValue( value)
    return tonumber(string.format("%."..(0).."f",value))
end
addEvent("onMapStarting",true)
addEventHandler("onMapStarting",root,
function(mapInfo,mapOptions,gameOptions)
	if (ismapDM(mapInfo.name) == 1) then
		for theKey,thePlayer in ipairs(getElementsByType("player")) do
			setElementData( thePlayer, "overrideCollide.uniqueblah", 0, false )
		end
	elseif (ismapDM(mapInfo.name) == 2) then
		for theKey,thePlayer in ipairs(getElementsByType("player")) do
			setElementData(thePlayer, "overrideCollide.uniqueblah", nil, false )
		end
	elseif (ismapDM(mapInfo.name) == 3) then
		for theKey,thePlayer in ipairs(getElementsByType("player")) do
			setElementData(thePlayer, "overrideCollide.uniqueblah", nil, false )
		end
	end
end
)
function ismapDM(isim)
	if string.find(isim,"[DM]",1,true) then
		return 1
	elseif string.find(isim,"[DD]",1,true) then
		return 2
	elseif string.find(isim,"[FUN]",1,true) then
		return 3
	end
end