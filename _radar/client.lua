local sX, sY = guiGetScreenSize()
function resX(value)
    return (value/1920) * sX
end
function resY(value)
    return (value/1080) * sY
end
local digital = dxCreateFont("digital.ttf",32*(sX/1920))
local radarRec = true
local radarX, radarY = sX*0.03, sY*0.7
local size = resY(240)
local center = size/2
local blipSize = resY(20)
local range = 180
local progress = 0
local components = { "ammo", "area_name", "armour", "breath", "clock", "health", "money", "radar", "vehicle_name", "weapon", "radio", "wanted"}
local _localPlayer = localPlayer
local radarText = dxCreateTexture("img/radar.png", "argb", true, "clamp")
function playerPosition()
    local target = getCameraTarget()
    if target and getElementType(target) == "vehicle" then
        _localPlayer = getVehicleController(target)
    else
        _localPlayer = getLocalPlayer()
    end
end
setTimer(playerPosition,1000,0)
function Radar ()
    for _, component in ipairs( components ) do
		setPlayerHudComponentVisible( component, false )
	end
    --
	local alpha = getElementData(localPlayer,"xAlpha") or 1
    -- Basic
	if progress >= 360 then
        progress = 0
    end
	if not getElementData(localPlayer,"login") then return end
	-- Local Blip
	local playerX,playerY = getElementPosition(_localPlayer)
	if not playerX or not playerY then playerX,playery = 0,0 end
    local playerRotate = getPedRotation(localPlayer)
	local camX,camY,camZ,targetX,targetY = getCameraMatrix()
	local north = findRotation(camX,camY,targetX,targetY)
if radarRec then	
	local northX,northY = findNorthPosition(north,center-sY*0.003)
	-- Background + North
	_dxDrawRectangle(radarX,radarY,size,size,255,165,0,alpha)
    dxDrawRectangle(radarX+northX,radarY+northY,sY*0.006,sY*0.006,tocolor(255,255,255,255*alpha))
	-- shoot
	local projectiles = getElementsByType("projectile")
	if (#projectiles > 0) then
		for i,_shoot in ipairs(projectiles)do
		    local creator = getProjectileCreator(_shoot)
			local creator = getVehicleOccupant(creator)
		    local shootX,shootY,shootZ = getElementPosition(_shoot)
			local distance = getDistanceBetweenPoints2D(playerX,playerY,shootX,shootY)
			local angle = 180-north+findRotation(shootX,shootY,playerX,playerY)
			local localX,localY = getDistanceRotation(0,0,-center*math.sqrt(2)*math.min(distance/375,1),angle)
			local posX = math.max(-center,math.min(localX,center))
			local posY = math.max(-center,math.min(localY,center))
			local r,g,b = 255,0,0
			if getElementData(creator,"shotColor") then r,g,b = unpack(getElementData(creator,"shotColor")) end
			dxDrawImage(radarX+center+posX-(blipSize/2),radarY+center+posY-(blipSize/2),blipSize,blipSize,"img/shot.png",0,0,0,tocolor(r,g,b,255*alpha))
		end
	end
	-- Other's Player's Blip's
	for i,player in ipairs(getElementsByType("player")) do
		local vehiclePlayer = getPedOccupiedVehicle(player)
		if getElementData(player,"state")=="alive" and vehiclePlayer and player~=localPlayer then
			local _,_,rotateZ = getElementRotation(vehiclePlayer)
			local carX,carY,carZ = getElementPosition(vehiclePlayer)
			local distance = getDistanceBetweenPoints2D(playerX,playerY,carX,carY)
			local angle = 180-north+findRotation(carX,carY,playerX,playerY)
			local localX,localY = getDistanceRotation(0,0,-center*math.sqrt(2)*math.min(distance/375,1),angle)
			local posX = math.max(-center,math.min(localX,center))
			local posY = math.max(-center,math.min(localY,center))
			if getPlayerTeam(player) then
				r,g,b=getTeamColor(getPlayerTeam(player))
			else
			    r,g,b =255,255,255
			end
			if getElementModel(getPedOccupiedVehicle(player))==425 then
				progress = progress + 14
				dxDrawImage(radarX+center+posX-(blipSize/2),radarY+center+posY-(blipSize/2),blipSize,blipSize,"img/blip-heli.png",north-rotateZ,0,0,tocolor(r,g,b,255*alpha))
				dxDrawImage(radarX+center+posX-(blipSize/2),radarY+center+posY-(blipSize/2),blipSize,blipSize,"img/blip-rotor.png",progress,0,0,tocolor(r,g,b,255*alpha))
			else
			    dxDrawImage(radarX+center+posX-(blipSize/2),radarY+center+posY-(blipSize/2),blipSize,blipSize,"img/blip.png",north-rotateZ,0,0,tocolor(r,g,b,255*alpha))
			end
			pg = distance/200
			textAlpha = interpolateBetween(255,0,0,0,0,0,pg,"Linear")
			width = dxGetTextWidth(string.gsub(getPlayerName(player),"#%x%x%x%x%x%x",""),resY(1),"default-bold")
			dxDrawText(string.gsub(getPlayerName(player),"#%x%x%x%x%x%x",""),radarX+center+posX-(width/2),radarY+center+posY+sY*0.009,radarX+center+posX+(width/2),sY,tocolor(255,255,255,textAlpha*alpha),resY(0.8),"default-bold","center","top")
		end
		if getElementData(player,"state")=="training" and vehiclePlayer and player==localPlayer then
		   dxDrawImage(radarX+center-(blipSize/2),radarY+center-(blipSize/2),blipSize,blipSize,"img/local.png",north-playerRotate,0,0,tocolor(255,255,255,255*alpha))
		end
	end
else
    -- Background + North
    dxDrawImage(radarX,radarY,size,size,radarText,0,0,0,tocolor(255,255,255,255*alpha))
	dxDrawImage(radarX,radarY,size,size,"img/north.png",north,0,0,tocolor(255,255,255,255*alpha))
	-- shoot
	local projectiles = getElementsByType("projectile")
	if (#projectiles > 0) then
		for i,_shoot in ipairs(projectiles)do
		    local creator = getProjectileCreator(_shoot)
			local creator = getVehicleOccupant(creator)
		    local shootX,shootY,shootZ = getElementPosition(_shoot)
			local distance = getDistanceBetweenPoints2D(playerX,playerY,shootX,shootY)
			if distance > range then
				distance = tonumber(range)
			end
			local angle = 180-north+findRotation(shootX,shootY,playerX,playerY)
			local posX,posY = getDistanceRotation(0,0,size*(distance/range)/2,angle)
			local r,g,b = 255,0,0
			if getElementData(creator,"shotColor") then r,g,b = unpack(getElementData(creator,"shotColor")) end
			dxDrawImage(radarX+center-posX-(blipSize/2),radarY+center-posY-(blipSize/2),blipSize,blipSize,"img/shot.png",0,0,0,tocolor(r,g,b,255*alpha))
		end
	end
	-- Other's Player's Blip's
	for i,player in ipairs(getElementsByType("player")) do
		local vehiclePlayer = getPedOccupiedVehicle(player)
		if getElementData(player,"state")=="alive" and vehiclePlayer and player~=localPlayer then
			local _,_,rotateZ = getElementRotation(vehiclePlayer)
			local carX,carY,carZ = getElementPosition(vehiclePlayer)
			local distance = getDistanceBetweenPoints2D(playerX,playerY,carX,carY)
			if distance > range then
				distance = tonumber(range)
			end
			local angle = 180-north+findRotation(carX,carY,playerX,playerY)
			local posX,posY = getDistanceRotation(0,0,size*(distance/range)/2,angle)
			if getPlayerTeam(player) then
				r,g,b=getTeamColor(getPlayerTeam(player))
			else
			    r,g,b =255,255,255
			end
			if getElementModel(getPedOccupiedVehicle(player))==425 then
				progress = progress + 14
				dxDrawImage(radarX+center-posX-(blipSize/2),radarY+center-posY-(blipSize/2),blipSize,blipSize,"img/blip-heli.png",north-rotateZ,0,0,tocolor(r,g,b,255*alpha))
				dxDrawImage(radarX+center-posX-(blipSize/2),radarY+center-posY-(blipSize/2),blipSize,blipSize,"img/blip-rotor.png",progress,0,0,tocolor(r,g,b,255*alpha))
			else
			    dxDrawImage(radarX+center-posX-(blipSize/2),radarY+center-posY-(blipSize/2),blipSize,blipSize,"img/blip.png",north-rotateZ,0,0,tocolor(r,g,b,255*alpha))
			end
			pg = distance/range
			textAlpha = interpolateBetween(255,0,0,0,0,0,pg,"Linear")
			width = dxGetTextWidth(string.gsub(getPlayerName(player),"#%x%x%x%x%x%x",""),resY(1),"default-bold")
			dxDrawText(string.gsub(getPlayerName(player),"#%x%x%x%x%x%x",""),radarX+center-posX-(width/2),radarY+center-posY+sY*0.009,radarX+center-posX+(width/2),sY,tocolor(255,255,255,textAlpha*alpha),resY(0.8),"default-bold","center","top")
		end
		if getElementData(player,"state")=="training" and vehiclePlayer and player==localPlayer then
		   dxDrawImage(radarX+center-(blipSize/2),radarY+center-(blipSize/2),blipSize,blipSize,"img/local.png",north-playerRotate,0,0,tocolor(255,255,255,255*alpha))
		end
	end
end
	-- Local Blip
	if (getElementData(localPlayer,"state")=="alive") and getPedOccupiedVehicle(localPlayer) then
	    dxDrawImage(radarX+center-(blipSize/2),radarY+center-(blipSize/2),blipSize,blipSize,"img/local.png",north-playerRotate,0,0,tocolor(255,255,255,255*alpha))
	end
	local charW = dxGetTextWidth("8",1,digital)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
    	local vx,vy,vz = getElementVelocity(vehicle)
    	local speed = math.floor(math.sqrt(vx^2+vy^2+vz^2)*161)
    	dxDrawText("888",0,sY*0.935,sX*0.9875,sY,tocolor(124,124,124,150*alpha),1,digital,"right","top",true)
    	for i = 1,#tostring(speed) do
			dxDrawText(string.sub(string.reverse(tostring(speed)),i,i),0,sY*0.935,sX*0.9875-(i*charW)+charW,sY,tocolor(255,255,255,255*alpha),1,digital,"right","top",true)
    	end
		local vHealth = math.min((getElementHealth(vehicle)-250)/750,1)
		if vHealth <=0 then vHealth = 0 end
		dxDrawRectangle(sX*0.81,sY*0.965,sX*0.1,sY*0.01,tocolor(0,0,0,180*alpha))
		dxDrawRectangle(sX*0.81+1,sY*0.965+1,sX*0.1*vHealth-2,sY*0.01-2,tocolor(0,255,0,200*alpha))
		local nitro = getVehicleNitroLevel(vehicle)
		if nitro ~= false and nitro ~= nil and nitro > 0 then
			dxDrawRectangle(sX*0.81,sY*0.945,sX*0.1,sY*0.01,tocolor(0,0,0,180*alpha))
			dxDrawRectangle(sX*0.81+1,sY*0.945+1,sX*0.1*nitro-2,sY*0.01-2,tocolor(30,144,255,200*alpha))
		end
	end
end
addEventHandler("onClientRender",root,Radar)
function findRotation(x1,y1,x2,y2)
    local t = -math.deg(math.atan2(x2-x1,y2-y1))
    if t < 0 then 
        t = t + 360 
    end
    return t
end
function findNorthPosition(cameraRotation,halfSize)
	local northX = 0
	local northY = 0
	if cameraRotation >= 0 and cameraRotation < 45 then
		northX = halfSize+((cameraRotation/45)*halfSize)
		northY = 0
	elseif cameraRotation >= 45 and cameraRotation < 90 then
		northX = (halfSize*2)
		northY = (((cameraRotation-45)/45)*halfSize)
	elseif cameraRotation >= 90 and cameraRotation < 135 then
		northX = (halfSize*2)
		northY = halfSize+(((cameraRotation-90)/45)*halfSize)
	elseif cameraRotation >= 135 and cameraRotation < 180 then
		northX = (halfSize*2)-(((cameraRotation-135)/45)*halfSize)
		northY = (halfSize*2)
	elseif cameraRotation >= 180 and cameraRotation < 225 then
		northX = (halfSize*2)-(((cameraRotation-135)/45)*halfSize)
		northY = (halfSize*2)
	elseif cameraRotation >= 225 and cameraRotation < 270 then
		northX = 0
		northY = (halfSize*2)-(((cameraRotation-225)/45)*halfSize)
	elseif cameraRotation >= 270 and cameraRotation < 315 then
		northX = 0
		northY = halfSize-(((cameraRotation-270)/45)*halfSize)
	elseif cameraRotation >= 315 and cameraRotation < 360 then
		northX = (((cameraRotation-315)/45)*halfSize)
		northY = 0
	end
	return northX,northY
end
function getDistanceRotation(x, y, dist, angle)
	local a = math.rad(90 - angle)
	local dx = math.cos(a) * dist
	local dy = math.sin(a) * dist
	return x+dx, y+dy
end
function _dxDrawRectangle(x,y,w,h,r,g,b,a)
    dxDrawRectangle(x,y,w,h,tocolor(r,g,b,80*a))
	dxDrawRectangle(x+resX(2),y+resY(2),w-resX(4),h-resY(4),tocolor(0,0,0,170*a))
end
function radarCMD()
radarRec = not radarRec
end
addCommandHandler("vzradar",radarCMD)
fileDelete("client.lua")