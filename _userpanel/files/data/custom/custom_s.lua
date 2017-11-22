local info = {
["carColor"] = "Cor do carro",
["lightColor"] = "Cor das luzes",
["nitroColor"] = "Cor do nitro",
["shotColor"] = "Cor do tiro"
}
function buyCarColor(player,id,r,g,b)
    if not player or not r or not g or not b then
	    return callClientFunction(player,"createNotify","Argumentos invalidos",255,0,0)
	end
	local price = 0
	local data = ""
    if id == 1 then 
	    price = infos.carColor 
		data = "carColor"	
	elseif id == 2 then 
	    price = infos.lightColor 
		data = "lightColor"
	elseif id == 3 then 
	    price = infos.nitroColor 
		data = "nitroColor"
	elseif id == 4 then 
	    price = infos.shotColor 
		data = "shotColor"	
	end
    if not isPlayerLogged(player) then
	    return callClientFunction(player,"createNotify","Voce nao esta logado",255,0,0)
	end
	if getDonatorPlayer(player) or onTakeMoney(player,price) then
	    setDataValue(player,data,"1")
		setNewColor(player,id,r,g,b)
		refreshColor(player,id,r,g,b)
		callClientFunction(player,"createNotify","Voce comprou um novo custom. ("..info[data]..")",0,236,0)
	else
	    callClientFunction(player,"createNotify","Voce nao tem dinheiro",255,0,0)
	end
end
function buyPoliceHeadlight(player)
    if not player then
	    return callClientFunction(player,"createNotify","Argumentos invalidos",255,0,0)
	end
    if not isPlayerLogged(player) then
	    return callClientFunction(player,"createNotify","Voce nao esta logado",255,0,0)
	end
	if getDonatorPlayer(player) or onTakeMoney(player,infos.policeHeadLight) then
	    setDataValue(player,"policeHeadLight","1")
		setElementData(player,"policeHeadLight","true")
		callClientFunction(player,"createNotify","Voce comprou um novo custom. (Luzes da policia)",0,236,0)
	else
	    callClientFunction(player,"createNotify","Voce nao tem dinheiro",255,0,0)
	end
end
function refreshColor(player,id,r,g,b)
    if id == 1 then
	    local vehicle = getPedOccupiedVehicle(player)
		if vehicle then
		    setVehicleColor(vehicle,r,g,b,r,g,b)
		end
	elseif id == 2 then 
	    local vehicle = getPedOccupiedVehicle(player)
		if vehicle then
		    setVehicleHeadLightColor(vehicle,r,g,b)
		end
	elseif id == 3 then 
		callClientFunction(player,"updateNitroColor",r/255,g/255,b/255)
	elseif id == 4 then
	    setElementData(player,"shotColor",{r,g,b})
	end
end
function setColorInLogin(player)
    setColor(player)
	if getDataValue(player,"nitroColor") == "1" then
		local r, g, b = getNewColor(player,3)
		callClientFunction(player,"updateNitroColor",r/255,g/255,b/255)
	end
	if getDataValue(player,"shotColor") == "1" then
	    r,g,b = getNewColor(player,4)
		setElementData(player,"shotColor",{r,g,b})
	end
	if getDataValue(player,"policeHeadLight") == "1" then
	    setElementData(player,"policeHeadLight","true")
	else
	    setElementData(player,"policeHeadLight","false")
	end	
end
function checkPickupedPickup(pickupID,pickupType,pickupModel)
	if pickupType == "vehiclechange" then
	    setColor(source)
	end
end
addEvent("onPlayerPickUpRacePickup",true)
addEventHandler("onPlayerPickUpRacePickup",root,checkPickupedPickup)
function onPlayerReady()
	setColor( source )
end
addEvent("onNotifyPlayerReady",true)
addEventHandler("onNotifyPlayerReady",root,onPlayerReady)
function setColor(player)
    if not isPlayerLogged(player) then
	    return
	end	
    local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then
	    return
	end	
	if getDataValue(player,"carColor") == "1" then
		local r, g, b = getNewColor(player,1)
		setVehicleColor(vehicle,r,g,b,r,g,b)
	end
	if getDataValue(player,"lightColor") == "1" then
		local r, g, b = getNewColor(player,2)
		setVehicleHeadLightColor(vehicle,r,g,b)	
	end
	if getDonatorPlayer(player) then
	    callClientFunction(player,"changeWheel")
	end
	if getDataValue(player,"shotColor") == "1" then
	    r,g,b = getNewColor(player,4)
		setElementData(player,"shotColor",{r,g,b})
	end
end