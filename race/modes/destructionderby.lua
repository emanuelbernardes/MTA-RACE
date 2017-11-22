DestructionDerby = setmetatable({}, RaceMode)
DestructionDerby.__index = DestructionDerby

DestructionDerby:register('Destruction derby')

function DestructionDerby:isApplicable()
	return not RaceMode.checkpointsExist() and RaceMode.getMapOption('respawn') == 'none'
end

function DestructionDerby:getPlayerRank(player)
	return #getActivePlayers()
end

-- Copy of old updateRank
function DestructionDerby:updateRanks()
	for i,player in ipairs(g_Players) do
		if not isPlayerFinished(player) then
			local rank = self:getPlayerRank(player)
			if not rank or rank > 0 then
				setElementData(player, 'race rank', rank)
			end
		end
	end
	-- Make text look good at the start
	if not self.running then
		for i,player in ipairs(g_Players) do
			setElementData(player, 'race rank', '' )
			setElementData(player, 'checkpoint', '' )
		end
	end
end

function DestructionDerby:onPlayerWasted(player)
	if isActivePlayer(player) then
		self:handleFinishActivePlayer(player)
		local activePlayers = getActivePlayers()
		if getActivePlayerCount() <= 1 and (not isMapDM()) or (getActivePlayerCount() <= 0) then
			RaceMode.endMap()
		else
			TimerManager.createTimerFor("map",player):setTimer(clientCall, 2000, 1, player, 'Spectate.start', 'auto')
		end
		if getActivePlayerCount() == 1 then
		    if getElementModel(getPedOccupiedVehicle(activePlayers[1])) == 425 then
				setElementHealth(activePlayers[1],0)
			end	
			triggerEvent("onPlayerDeadWinBet",getRootElement(),activePlayers[1])
		end
	end
	RaceMode.setPlayerIsFinished(player)
	showBlipsAttachedTo(player, false)
end

function DestructionDerby:onPlayerQuit(player)
	if isActivePlayer(player) then
		self:handleFinishActivePlayer(player)
		if getActivePlayerCount() <= 1 and (not isMapDM()) or (getActivePlayerCount() <= 0) then
			RaceMode.endMap()
		end
	end
end

function DestructionDerby:handleFinishActivePlayer(player)
	-- Update ranking board for player being removed
	--if not self.rankingBoard then
		--self.rankingBoard = RankingBoard:create()
		--self.rankingBoard:setDirection( 'up', getActivePlayerCount() )
	--end
	local timePassed = self:getTimePassed()
	local rank = self:getPlayerRank(player)
	if rank == 1 then
		if not getResourceFromName( "sor_podium" ) or getResourceFromName( "sor_podium" ) and getResourceState( getResourceFromName( "sor_podium" )) ~= "running" then
			triggerClientEvent("winnerMessage",resourceRoot,"Winner!!!", getPlayerNametagText(player))
		else
            triggerClientEvent("winnerMessage",resourceRoot,"","")
		end
		triggerEvent("onMissionWinDM",getRootElement(),player)
	--else
		--self.rankingBoard:add(player, timePassed, rank)
	end
	-- Do remove
	finishActivePlayer(player)
	if rank and rank > 1 then
		triggerEvent( "onPlayerFinishDD",player,tonumber( rank ) )
	end
	-- Update ranking board if one player left
	local activePlayers = getActivePlayers()
	triggerEvent("onPlayerDeadInRace",getRootElement(),rank,player)
	if #activePlayers == 1 then
		--self.rankingBoard:add(activePlayers[1], timePassed, #activePlayers)
		if (not isMapDM()) then 
		    if getResourceState( getResourceFromName( "podium" )) ~= "running" then
		        triggerClientEvent("winnerMessage",resourceRoot,"Winner!!!", getPlayerNametagText(activePlayers[1]))
			else
                triggerClientEvent("winnerMessage",resourceRoot,"","")	
				setElementHealth(activePlayers[1],0)
			end	
			triggerEvent("onMissionWinDM",getRootElement(),activePlayers[1])
		end
		if getElementModel(getPedOccupiedVehicle(activePlayers[1])) == 425 then
			setElementHealth(activePlayers[1],0)
		end
		triggerEvent( "onPlayerWinDD",activePlayers[1] )
	end
end

function detectHunterWhileAutoB(_,type,vehicleID)
	if type == "vehiclechange" and vehicleID == 425 then
		local activePlayers = getActivePlayers()
		if getElementData ( source, "state" ) ~= "alive" then
		    return
	    end
		addOneMoreHunter()
		if #activePlayers == 1 then
			if getElementModel(getPedOccupiedVehicle(activePlayers[1])) == 425 then
			    setElementHealth(activePlayers[1],0)
		    end
		end
	end
end
addEvent("onPlayerPickUpRacePickup",true)
addEventHandler("onPlayerPickUpRacePickup",getRootElement(),detectHunterWhileAutoB)

------------------------------------------------------------
-- activePlayerList stuff
--

function isActivePlayer( player )
	return table.find( g_CurrentRaceMode.activePlayerList, player )
end

function addActivePlayer( player )
	table.insertUnique( g_CurrentRaceMode.activePlayerList, player )
end

function removeActivePlayer( player )
	table.removevalue( g_CurrentRaceMode.activePlayerList, player )
end

function finishActivePlayer( player )
	table.removevalue( g_CurrentRaceMode.activePlayerList, player )
	table.insertUnique( g_CurrentRaceMode.finishedPlayerList, _getPlayerName(player) )
end

function getFinishedPlayerCount()
	return #g_CurrentRaceMode.finishedPlayerList
end

function getActivePlayerCount()
	return #g_CurrentRaceMode.activePlayerList
end

function getActivePlayers()
	return g_CurrentRaceMode.activePlayerList
end

local GameModeGhost = false
function onMapStarting(mapInfo)
	GameModeGhost = false
	if string.find(mapInfo.name,"DM",1) then
		GameModeGhost = true
	end
end
addEvent("onMapStarting",true)
addEventHandler("onMapStarting",getRootElement(),onMapStarting)

function isMapDM ()
    return GameModeGhost
end
