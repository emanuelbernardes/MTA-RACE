local maxDead = 5
function afkKill()
	setElementHealth(source, 0)
	if not getElementData(source,"afkCount") then
	    setElementData(source,"afkCount",0)
	end
	setElementData(source,"afkCount",getElementData(source,"afkCount")+1)
	if getElementData(source,"afkCount") > maxDead then
	    outputChatBox("[AFK-SYSTEM] #ffffff"..getPlayerName(source).. " #ffffffhas kicked by AFK",root,255,106,106,true)
		kickPlayer(source,"AFK for "..maxDead.." rounds")
	else
	    outputChatBox("[AFK-SYSTEM] #ffffff"..getPlayerName(source).. " #ffffffhas killed by AFK ("..getElementData(source,"afkCount").."/"..maxDead..")",root,255,106,106,true)
	end
end
addEvent( "afkSlap", true )
addEventHandler( "afkSlap", getRootElement(), afkKill)