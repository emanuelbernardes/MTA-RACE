setTimer(
    function()
        outputChatBox("Entre no nosso TS!!! ->>  ts3.mta.ninja",root,255,165,0,true)
    end,
150000,0)
------------------------------------------------------------------------------------------------------------------------------------------
-- Join Server
------------------------------------------------------------------------------------------------------------------------------------------
function JoinServer ()
	setElementData(source,'pmblock',"true")
end
addEventHandler ("onPlayerJoin", root, JoinServer)
------------------------------------------------------------------------------------------------------------------------------------------
-- Player Name System
------------------------------------------------------------------------------------------------------------------------------------------
function _getPlayerName(player)
	local playerTeam = getPlayerTeam(player)
	local id = getPlayerID(player)
	local cargo = getCargo(player)
	if playerTeam then
		local r,g,b = getTeamColor(playerTeam)
		local colorHex = RGBToHex(r,g,b)
		if getResourceFromName("_userpanel") and getResourceState(getResourceFromName("_userpanel")) == "running" then
		    local clanTag = call(getResourceFromName("_userpanel"),"getTeamTag",player)
		    if clanTag then
		        if not string.find(getPlayerName(player),clanTag,1) then
		            playerTag = clanTag
				else
				    playerTag = ""
				end
		    else
		        playerTag = ""
		    end
		else
		    playerTag = ""
		end
		playerName = colorHex..playerTag..getPlayerName(player)
	else
		playerName = "#FFFFFF"..getPlayerName(player)
	end
    if cargo then
	    playerName = cargo.."(ID:"..id..")"..playerName
	else
	    playerName = "(ID:"..id..")"..playerName
	end
	return playerName
end
function RGBToHex(r,g,b)
    local r = r or 0
	local g = g or 0
	local b = b or 0
	return string.format("#%.2X%.2X%.2X",r,g,b)
end
------------------------------------------------------------------------------------------------------------------------------------------
-- Show Serial System
------------------------------------------------------------------------------------------------------------------------------------------
function verSerial ( player, cmd, id)
    local toPlayer = getPlayerFromId ( id )
	if not id then
	    outputChatBox("[ERRO]#ffffffUse: /showserial [id]",player,255,0,0,true)
		return
	end	
	if not toPlayer then
	    outputChatBox("[ERRO]#ffffffJogador nao encontrado [ ID INVALID ]",player,255,0,0,true)
		return
	end	
	if player == toPlayer then
	    outputChatBox("*ME "..string.gsub(_getPlayerName(player),'#%x%x%x%x%x%x','').." - SERIAL:"..getPlayerSerial(player),player,255,99,99,true)
		return
	end
	outputChatBox("*ME "..string.gsub(_getPlayerName(player),'#%x%x%x%x%x%x','').." - SERIAL:"..getPlayerSerial(player),player,255,99,99,true)
	outputChatBox("*TO "..string.gsub(_getPlayerName(toPlayer),'#%x%x%x%x%x%x','').." - SERIAL:"..getPlayerSerial(toPlayer),player,255,99,99,true)
end
addCommandHandler("verserial",verSerial)
------------------------------------------------------------------------------------------------------------------------------------------
-- Enable/Disable Chat System
------------------------------------------------------------------------------------------------------------------------------------------
chat = true
function blockChat ( player, cmd)
    if not isPlayerOnGroup ( player ) then
		return
	end	
    if not chat then
        outputChatBox("[SERVER]#FFFFFFChat #00ff00Habilitado #FFFFFFby: ".._getPlayerName(player),root,255,99,99,true)
        chat = true
    else
        outputChatBox("[SERVER]#FFFFFFChat #FF0000Desabilitado #FFFFFFby: ".._getPlayerName(player),root,255,99,99,true)
        chat = false
	end
end
addCommandHandler( "chat", blockChat)
------------------------------------------------------------------------------------------------------------------------------------------
-- Chat System
------------------------------------------------------------------------------------------------------------------------------------------
local chatTime = {}
local lastChatMessage = {}
function ChatSystem ( text, msgType)
	local name = _getPlayerName( source )
	local text = string.gsub( text,'#%x%x%x%x%x%x', " ")
	if ( msgType == 1 ) then
	    cancelEvent(true)
		return
	end		
	if ( msgType == 2 ) then
		outputServerLog("CHAT TEAM:"..string.gsub(name,'#%x%x%x%x%x%x','')..":"..string.lower(text))
	end
    if ( msgType == 0 ) then
		cancelEvent(true)
		if chatTime[source] and chatTime[source] + tonumber(100) > getTickCount() then
			outputChatBox("Please dont spam.",source,255,0,0)
			return
		else
			chatTime[source] = getTickCount()
		end
		if lastChatMessage[source] and lastChatMessage[source] == text then
			outputChatBox("You can't repeat that message so soon.",source,255,0,0,true)
			return
		else
			lastChatMessage[source] = text
		end
		if isPlayerOnGroup(source) then
			cancelEvent(true)
			text = text:gsub("#","#1e90ff#")
			text = text:gsub("!","#FF0000!")
			text = text:gsub("@","#FFFF00@")
			text = text:gsub(" "," #ffffff")
			outputChatBox(name.."#FFFFFF: "..text,root,255,255,255,true)
			outputServerLog("CHAT:"..string.gsub(name,'#%x%x%x%x%x%x', '')..": "..string.lower(string.gsub(text,'#%x%x%x%x%x%x','')))
		else
			if ( chat == false ) then
				cancelEvent (true)
	    		outputChatBox("Chat is off.",source,255,0,0,true)
				return
			end
			cancelEvent(true)
			text = text:gsub("#","#1e90ff#")
			text = text:gsub(" "," #ffffff")
			outputChatBox(name.."#FFFFFF: "..text,root,255,255,255,true)
			outputServerLog("CHAT:"..string.gsub( name,'#%x%x%x%x%x%x','')..": "..string.lower(string.gsub(text,'#%x%x%x%x%x%x','')))	
		end
	end
end
addEventHandler ("onPlayerChat", root, ChatSystem)
------------------------------------------------------------------------------------------------------------------------------------------
-- Private Messenger System
------------------------------------------------------------------------------------------------------------------------------------------
function privateMessage(thePlayer,commandName,id,...)
    local pmMessage = nil for k,v in pairs({...}) do  if pmMessage == nil then pmMessage = v else pmMessage = pmMessage .. " " .. v end end
    local toPlayer = getPlayerFromId ( id )
    if not id then
	    outputChatBox("[ERRO]#FFFFFF Use: /pm [id] [text]",thePlayer,255,0,0,true)
		return
	end	
    if not toPlayer then
	    outputChatBox("[ERRO]#FFFFFF Jogador nao encontrado [ invalid ID ]",thePlayer,255,0,0,true)
		return
	end	
    if (toPlayer == thePlayer) then
	    outputChatBox("[ERRO]#FFFFFF Voce nao pode enviar mensagem para si mesmo.",thePlayer,255,0,0,true)
		return
	end	
	if ( getElementData(toPlayer,'pmblock') == "false" ) then
	    outputChatBox ("[ERRO]#FFFFFF O jogador esta com as pm's bloqueadas. (/pmblock)",thePlayer,255,0,0,true)
		return
	end	
	if (pmMessage == "") then
	    outputChatBox("[ERRO]#FFFFFF Comando errado. Use: /pm [id] [text]",thePlayer,255,0,0,true)
		return
	end	
	outputChatBox("*PM enviada #FFFFFF".._getPlayerName(toPlayer).."#DDA0DD: #FFFFFF"..pmMessage,thePlayer,221,160,221,true)
	outputChatBox("*PM recebida #FFFFFF".._getPlayerName(thePlayer).."#DDA0DD: #FFFFFF"..pmMessage,toPlayer,221,160,221,true)
	if ( not isPlayerOnGroup ( toPlayer ) ) and ( not isPlayerOnGroup ( thePlayer ) ) then
		for _,player in ipairs (getElementsByType("player")) do
			if ( isPlayerOnGroup(player)) then
				outputChatBox("*PM #ffffff".._getPlayerName(thePlayer).."#DDA0DD enviou para #ffffff".._getPlayerName(toPlayer).."#DDA0DD: #FFFFFF"..pmMessage,player,221,160,221,true)
			end
		end
	end
end
addCommandHandler("pm",privateMessage)

function blockPrivateMessages(player)
	if (getElementData(player,'pmblock')=="true") then
		setElementData(player,'pmblock',"false")
		outputChatBox ("[PM]#FFFFFF Voce bloquiou as Pm's..",player,255,99,99,true)
	else
		setElementData(player,'pmblock',"true")
		outputChatBox ("[PM]#FFFFFF Voce desbloqueou as Pm's.",player,255,99,99,true)
	end
end
addCommandHandler("pmblock",blockPrivateMessages)
------------------------------------------------------------------------------------------------------------------------------------------
-- Seguranca
------------------------------------------------------------------------------------------------------------------------------------------
function showSerial1()
    for _, player in ipairs ( getElementsByType ( "player" ) ) do
		if ( isPlayerOnGroup ( player ) ) then
            outputConsole("JOIN-"..string.gsub(getPlayerName(source),'#%x%x%x%x%x%x','').." - SERIAL:"..getPlayerSerial(source),player)
		end
	end	
end
function showSerial2()
    for _, player in ipairs ( getElementsByType ( "player" ) ) do
		if ( isPlayerOnGroup ( player ) ) then
            outputConsole("QUIT-"..string.gsub(getPlayerName(source),'#%x%x%x%x%x%x','').." - SERIAL:"..getPlayerSerial(source),player)
		end
	end	
end
addEventHandler ("onPlayerJoin", root, showSerial1)
addEventHandler ("onPlayerQuit", root, showSerial2)
------------------------------------------------------------------------------------------------------------------------------------------
-- ACL System
------------------------------------------------------------------------------------------------------------------------------------------

function isPlayerOnGroup(player)
    local account = getPlayerAccount ( player )
    local inGroup = false
    for _,group in ipairs ({"Console","Admin"}) do  
        if isObjectInACLGroup("user."..getAccountName(account ), aclGetGroup ( group ) )   then
            inGroup = true
            break
        end
    end
    return inGroup
end

function getPlayerID ( player )
    return  getElementData( player, "id")
end

function getPlayerFromId ( theID )
    if theID then
        local theID = tonumber(theID)
        local theplayer
        for index,player in ipairs(getElementsByType("player")) do
            if getElementData(player ,"id") == theID then
                theplayer = player
            end
        end
        return theplayer
    else 
	    return false 
	end
end

function adminChat(player,cmd,...)
    local pmMessage = nil for k,v in pairs({...}) do  if pmMessage == nil then pmMessage = v else pmMessage = pmMessage .. " " .. v end end
	if pmMessage == nil or pmMessage == "" then return end
	if getCargo(player) then
		for _,admin in ipairs(getElementsByType("player")) do
	    	if getCargo(admin) then
		    	outputChatBox("[Admin Chat]#ffffff".._getPlayerName(player)..": #DDA0DD"..pmMessage,admin,255,0,0,true)
			end
		end
	end
end
addCommandHandler("ac",adminChat)

function getCargo(player)
	local account = getAccountName(getPlayerAccount(player))
	if not account then 
	    return false
	end
	if isObjectInACLGroup("user."..account,aclGetGroup("Console")) then
		return "#FFAD08"
	elseif isObjectInACLGroup("user."..account,aclGetGroup("Admin")) then
		return "#FF0303"
	elseif isObjectInACLGroup("user."..account,aclGetGroup("SuperModerator")) then
		return "#9EFF00"
	elseif isObjectInACLGroup("user."..account,aclGetGroup("Moderator")) then
		return "#FCFF03"
    else
	    return false
	end
end
