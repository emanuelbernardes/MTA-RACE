--deadInWater
addEvent('onMissionDeadInWater',true)
addEventHandler('onMissionDeadInWater',root,
function(player)
    if not isPlayerLogged(player) then return end
	if tonumber(getDataMissonsValue(player,"miss4")) >= 20 then return end
	addDataMissionsValue(player,"miss4",1)
	if tonumber(getDataMissonsValue(player,"miss4")) == 20 then
	    addDataMissionsValue(player,"congruation",1)
		winMissions(player)
	end
end	
)
--vehicleChange&Hunter missions
addEvent('onPlayerPickUpRacePickup',true)
addEventHandler('onPlayerPickUpRacePickup',root,
	function(number,sort,model)
	    if getElementData(source,"state") ~= "alive" then
		    return
	    end
	    if sort == "vehiclechange" then
	  	    if model == 425 then
			    if not isPlayerLogged(source) then return end
			    if tonumber(getDataMissonsValue(source,"miss3")) >= 10 then return end
			    addDataMissionsValue(source,"miss3",1)
			    if tonumber(getDataMissonsValue(source,"miss3")) == 10 then
	    		    addDataMissionsValue(source,"congruation",1)
					winMissions(source)
			    end
			else
			    if not isPlayerLogged(source) then return end
			    if tonumber(getDataMissonsValue(source,"miss5")) >= 50 then return end
			    addDataMissionsValue(source,"miss5",1)
			    if tonumber(getDataMissonsValue(source,"miss5")) == 50 then
	    		    addDataMissionsValue(source,"congruation",1)
					winMissions(source)
			    end
			end
		end
	end
)
--cashMission
function onMissionEarnCash(player,value)
    if not isPlayerLogged(player) then return end
	if tonumber(getDataMissonsValue(player,"miss6")) >= 4000 then return end
	addDataMissionsValue(player,"miss6",value)
	if tonumber(getDataMissonsValue(player,"miss6")) >= 4000 then
	    addDataMissionsValue(player,"congruation",1)
		winMissions(player)
	end

end
--playedMapsMissions
function onMissionDriveMaps(player)
    if not isPlayerLogged(player) then return end
	if tonumber(getDataMissonsValue(player,"miss7")) >= 15 then return end
	addDataMissionsValue(player,"miss7",value)
	if tonumber(getDataMissonsValue(player,"miss7")) == 15 then
	    addDataMissionsValue(player,"congruation",1)
		winMissions(player)
	end
end
--topTimesMissions
addEvent('onMissionGetTopTime',true)
addEventHandler('onMissionGetTopTime',root,
function(player)
    if not isPlayerLogged(player) then return end
	if tonumber(getDataMissonsValue(player,"miss2")) >= 2 then return end
	addDataMissionsValue(player,"miss2",1)
	if tonumber(getDataMissonsValue(player,"miss2")) == 2 then
	    addDataMissionsValue(player,"congruation",1)
		winMissions(player)
	end
end	
)
--lastSurvivor&2Row Missions
oldPlayer = false
addEvent('onMissionWinDM',true)
addEventHandler('onMissionWinDM',root,
function(player)
    if oldPlayer == player then
	    if not isPlayerLogged(player) then return end
		if tonumber(getDataMissonsValue(player,"miss8")) >= 2 then return end
		addDataMissionsValue(player,"miss8",1)
		if tonumber(getDataMissonsValue(player,"miss8")) == 2 then
	    	addDataMissionsValue(player,"congruation",1)
			winMissions(player)
		end
		oldPlayer = false
		return
	end
	oldPlayer = player
	if not isPlayerLogged(player) then return end
	if tonumber(getDataMissonsValue(player,"miss1")) >= 10 then return end
	addDataMissionsValue(player,"miss1",1)
	if tonumber(getDataMissonsValue(player,"miss1")) == 10 then
	    addDataMissionsValue(player,"congruation",1)
		winMissions(player)
	end
end	
)
--WinMissions
function winMissions(player)
    number = tonumber(getDataMissonsValue(player,"congruation"))
	if number == 3 then
	    addDataValue(player,"cash","15000")
		addDataValue(player,"points","300")
		callClientFunction(player,"createNotify","Voce completou 3 missoes e ganhou $15000 e 300 EXP.",0,236,0)
	end
	if number == 6 then
	    addDataValue(player,"cash","30000")
		addDataValue(player,"points","600")
		callClientFunction(player,"createNotify","Voce completou 6 missoes e ganhou $30000 e 600 EXP.",0,236,0)
	end
	if number == 9 then
	    addDataValue(player,"cash","45000")
		addDataValue(player,"points","900")
		callClientFunction(player,"createNotify","Voce completou todas as missoes e ganhou $45000 e 900 EXP.",0,236,0)
	end
end
-- explodeVehicle
addEventHandler('onVehicleExplode',root,
function ()
    local player = getVehicleOccupant(source)
	if not player then return end
    if not isPlayerLogged(player) then return end
	if tonumber(getDataMissonsValue(player,"miss9")) >= 20 then return end
	addDataMissionsValue(player,"miss9",1)
	if tonumber(getDataMissonsValue(player,"miss9")) == 20 then
	    addDataMissionsValue(player,"congruation",1)
		winMissions(player)
	end
end
)