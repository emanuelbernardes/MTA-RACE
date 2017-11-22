function callServerFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onClientCallsServerFunction", true)
addEventHandler("onClientCallsServerFunction", resourceRoot , callServerFunction)
function callClientFunction(client, funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    triggerClientEvent(client, "onServerCallsClientFunction", resourceRoot, funcname, unpack(arg or {}))
end
function isPlayerLogged ( player )
    if isGuestAccount ( getPlayerAccount ( player ) ) then
		return false
	else
	    return true
	end
end
function isPlayerOnGroup ( player )
    local account = getPlayerAccount ( player )
    local inGroup = false
    for _, group in ipairs ( { "Console", "Admin", "SuperModerator", "Moderator"} ) do  
        if isObjectInACLGroup ( "user.".. getAccountName ( account ), aclGetGroup ( group ) )   then
            inGroup = true
            break
        end
    end
    return inGroup
end
function isPlayerLoggedClient ( player )
    if isGuestAccount ( getPlayerAccount ( player ) ) then
		callClientFunction(player,"setPlayerLoginStatus",false,false,false,false)
	else
	    local acl = false
		local teamState = false
		local donator = false
	    if isPlayerOnGroup ( player ) then
		    acl = true
		end
		if getPlayerTeamStatus ( player ) then
		    teamState = true
		end
		if getDonatorPlayer( player ) then
		    donator = true
		end
	    callClientFunction(player,"setPlayerLoginStatus",true,acl,teamState,donator)
	end
end
_r,_g,_b = getColorFromString("#2E9AFE")
colorCode = "#87CEFF"
infos = {
    timerAgain = 35,
	mapPrice = "3000",
	carColor = "40000",
	lightColor = "30000",
	nitroColor = "35000",
	shotColor = "100000",
	minPlayer = 3,
	policeHeadLight = "350000",
	maxSpin = "3000",
	maxBet = "200",
	musicPrice = "1000",
	teamPrice = "50000",
	teamTagPrice = "20000",
	teamColorPrice1 = "40000",
	teamColorPrice2 = "500000",
	donator = "25000"
}
function _outputChatBox(text,element,r,g,b,a)
    local str = text:gsub("_w","#ffffff")
	str = str:gsub("_v","#7CFC00")
	str = str:gsub("_b","#00BFFF")
	str = str:gsub("_s","#FA8072")
	str = str:gsub("_r","#FF0000")
	return outputChatBox(str,element,r,g,b,a)
end
function onUserStart()
	--callScoreboard()
	refreshScoreboard()
end
addEventHandler("onResourceStart",resourceRoot,onUserStart)
function callScoreboard()
	call(getResourceFromName("scoreboard"),"scoreboardAddColumn","Cash",getRootElement(),70)
	call(getResourceFromName("scoreboard"),"scoreboardAddColumn","Points",getRootElement(),70)
	call(getResourceFromName("scoreboard"),"scoreboardAddColumn","Rank",getRootElement(),70)
end
function refreshScoreboard()
    for i,player in ipairs(getElementsByType("player")) do
		if isPlayerLogged(player) then
			local playerCash = getDataValue ( player, "cash")
			local playerPoints = getDataValue ( player, "points")
			setElementData(player,"Cash","$"..playerCash)
			setElementData(player,"Points",playerPoints)
			setElementData(player,"Rank","?")
		else
			setElementData(player,"Cash","Guest")
			setElementData(player,"Points","Guest")
			setElementData(player,"Rank","?")
		end
	end
end
function refreshNowDatas(player)
	if isPlayerLogged(player) then
		local playerCash = getDataValue ( player, "cash") or "0"
		local playerPoints = getDataValue ( player, "points") or "0"
		setElementData(player,"Cash","$"..playerCash)
		setElementData(player,"Points",playerPoints)
	else
		setElementData(player,"Cash","Guest")
		setElementData(player,"Points","Guest")
		setElementData(player,"Rank","?")
	end
end
function playerJoin ()
	setElementData(source,"Cash","Guest")
	setElementData(source,"Points","Guest")
	setElementData(source,"Rank","?")
end
addEventHandler("onPlayerJoin",root,playerJoin)
function playerLogout ()
    if isPlayerLogged(source) then
        local playerOnline = getTickCount()-getElementData(source,"playerOnline")
	    addDataValue(source,"online",playerOnline)
	end	
	setElementData(source,"playerOnline","0")
	callClientFunction(source,"updateNitroColor")
	callClientFunction(source,"setPlayerLoginStatus",false,false)
	onPlayerQuitServer(source)
	refreshNowDatas(source)
end
addEventHandler("onPlayerLogout",root,playerLogout)
addEventHandler("onPlayerQuit",root,playerLogout)
function playerLogin ()
    startDataValue(source)
end
addEventHandler("onPlayerLogin",root,playerLogin)
function resStop()
    for i,player in ipairs(getElementsByType("player")) do
        setElementData(player,"teamTag",false)
    end
end
addEventHandler("onResourceStop",resourceRoot,resStop)