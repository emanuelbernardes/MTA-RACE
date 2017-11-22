local deathList = {}
local MapIsRunning = false

function getRaceState (stateName)
	if stateName == "NoMap" then
		deathList = {}
		triggerClientEvent("onPlayerDestroyDeath",root)
		MapIsRunning = false
	elseif stateName == "Running" then
		MapIsRunning = true
	end
end
addEvent("onRaceStateChanging",true)
addEventHandler("onRaceStateChanging",root,getRaceState)

function addPlayerToDeathList(player)
	for _,data in ipairs (deathList) do
		if data[3] == source then
		    return
		end
	end
	if MapIsRunning then
	    local PlayerCount = getCountAlivePlayers(player)
	    if PlayerCount == 0 then return end
        table.insert(deathList,{PlayerCount+1,string.gsub(getPlayerName(player),'#%x%x%x%x%x%x',''),player})
		triggerClientEvent("onPlayerDead",root,PlayerCount+1,string.gsub(getPlayerName(player),'#%x%x%x%x%x%x',''),player)
		if PlayerCount == 1 then
		    local getPlayer = getAlivePlayers(player)
			table.insert(deathList,{PlayerCount,string.gsub(getPlayerName(getPlayer[1][1]),'#%x%x%x%x%x%x',''),getPlayer[1][1]})
			triggerClientEvent("onPlayerDead",root,PlayerCount,string.gsub(getPlayerName(getPlayer[1][1]),'#%x%x%x%x%x%x',''),getPlayer[1][1])
		end	
	end	
end

function downPlayer()
    element = getElementData(source,"state")
    if ( element == "alive" ) or ( element == "not ready" ) or ( element == "joined" ) or ( element == "dead" ) then
	    addPlayerToDeathList(source)
	end
end
addEventHandler("onPlayerQuit",root,downPlayer)
addEventHandler("onPlayerWasted",root,downPlayer)

function getAlivePlayers(source)
    local alivePlayers = {}
    for _,player in ipairs (getElementsByType("player")) do
	    if source ~= player then
			if ( getElementData(player,"state") == "alive" ) or ( getElementData(player,"state") == "not ready" ) or ( getElementData(player,"state") == "joined" ) then
            	table.insert(alivePlayers,{player})
			end
		end
    end
    return alivePlayers
end

function getCountAlivePlayers(source)
	local AliveCount = getAlivePlayers(source)
	return #AliveCount
end