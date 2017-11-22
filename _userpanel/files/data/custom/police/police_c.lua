pga = 0
local tickCar = getTickCount()
function setPoliceLight()
    pga = pga + 0.003
    for i,player in ipairs(getElementsByType("player")) do
	    local vehicle = getPedOccupiedVehicle(player)
		if getElementData(player,"vehicleColor") and vehicle then
			local colorType = getElementData(player,"vehicleColor")
			local r,g,b = getVehicleColor(vehicle,true)
			if colorType == '1' then -- black to white
                r,g,b=interpolateBetween(0,0,0,255,255,255,pga,"SineCurve")
			elseif colorType == '2' then -- pink to blue
                r,g,b=interpolateBetween(0,0,255,255,0,255,pga,"SineCurve")
			elseif colorType == '3' then -- red to blue
				r,g,b=interpolateBetween(255,0,0,0,0,255,pga,"SineCurve")
			elseif colorType == '4' then -- green to blue
				r,g,b=interpolateBetween(0,255,0,0,0,255,pga,"SineCurve")
			end
			setVehicleColor(vehicle,r,g,b,r,g,b)
		end
		if getElementData(player,"HeadLightState") and vehicle then	
			local lightsType = getElementData(player,"HeadLightState")
			if lightsType == "1" then
            	if tickCar < getTickCount() then
		        	if getVehicleLightState(vehicle,0) == 1 then
					    setVehicleLightState(vehicle,0,0)
					    setVehicleLightState(vehicle,1,1)
					    setVehicleLightState(vehicle,2,1)
				    	setVehicleLightState(vehicle,3,0)
				    	setVehicleHeadLightColor(vehicle,255,0,0)
			    	else
				    	setVehicleLightState(vehicle,0,1)
				    	setVehicleLightState(vehicle,1,0)
				    	setVehicleLightState(vehicle,2,0)
				    	setVehicleLightState(vehicle,3,1)
				    	setVehicleHeadLightColor(vehicle,0,0,255)
			    	end
		    	end
			elseif lightsType == "2" then
			    if tickCar < getTickCount() then
				    if getVehicleLightState(vehicle,0) == 1 then
						setVehicleLightState(vehicle,0,0)
						setVehicleLightState(vehicle,1,0)
						setVehicleLightState(vehicle,2,1)
						setVehicleLightState(vehicle,3,1)
					else
						setVehicleLightState(vehicle,0,1)
						setVehicleLightState(vehicle,1,1)
						setVehicleLightState(vehicle,2,0)
						setVehicleLightState(vehicle,3,0)
					end
					setVehicleHeadLightColor(vehicle,math.random(0,255),math.random(0,255),math.random(0,255))
				end
			end
		end
    end
    if tickCar < getTickCount() then
		tickCar = getTickCount() + 500
	end	
end
addEventHandler("onClientPreRender",root,setPoliceLight)
makers = {}
function Shoots()
    creator = getProjectileCreator(source)
	creator = getVehicleOccupant(creator)
	if not creator or not getElementData(creator,"shotColor") then return end
    local x,y,z = getElementPosition(source)
	local r,g,b = unpack(getElementData(creator,"shotColor"))
	table.insert(makers,{maker=createMarker(x,y,z,"corona",4.0,r,g,b,255),shot=source,time=getTickCount()})
end
addEventHandler("onClientProjectileCreation",root,Shoots)
function Shoots_()
    local projectiles = getElementsByType("projectile")
	if(#projectiles > 0)then
		for i,_shoot in ipairs(projectiles)do
		    for i,info in ipairs(makers) do
		        if info.shot == _shoot then
		            local shootX,shootY,shootZ = getElementPosition(_shoot)
				    setElementPosition(info.maker,shootX,shootY,shootZ)
                end
			end
		end
	end
	for i,info in ipairs(makers) do
		local now = getTickCount() - info.time
		if now > 3000 or not isElement(info.shot) then
			destroyElement(info.maker)
			table.remove(makers,i)
		end
	end
end
addEventHandler("onClientPreRender",root,Shoots_)