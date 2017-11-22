local sX,sY = guiGetScreenSize()
fonts = {}
fonts["normal"] = {
    dxCreateFont("addons/font.ttf",8*(sX/1920)) or "defaul-bold",
	dxCreateFont("addons/font.ttf",10*(sX/1920)) or "defaul-bold",
	dxCreateFont("addons/font.ttf",14*(sX/1920)) or "defaul-bold",
	dxCreateFont("addons/font.ttf",16*(sX/1920)) or "defaul-bold",
	dxCreateFont("addons/font.ttf",18*(sX/1920)) or "defaul-bold",
	dxCreateFont("addons/font.ttf",20*(sX/1920)) or "defaul-bold",
	dxCreateFont("addons/font.ttf",22*(sX/1920)) or "defaul-bold"
}
function _dxDrawRectangle(x,y,w,h,r,g,b,a)
    dxDrawRectangle(x,y,w,h,tocolor(0,0,0,80*a))
	dxDrawRectangle(x+resY(2),y+resY(2),w-resY(4),h-resY(4),tocolor(0,0,0,170*a))
end
function _dxText(text,x,y,w,h,red,green,blue,alpha,scale,font,a,b,c,d,e,f)
    dxDrawText(string.gsub(text,"(#%x%x%x%x%x%x)",""),x+1,y+1,w+1,h+1,tocolor(0,0,0,alpha),1,font,a,b,c,d,e,f)
	dxDrawText(text,x,y,w,h,tocolor(red,green,blue,alpha),1,font,a,b,c,d,e,f)
end
-- Fonts

-- Loading Windows 8.1
--[[local sX,sY = guiGetScreenSize()
function WindowsLoading ()
	for i, Data in pairs( loading ) do
	    local tick = getTickCount() - Data[1]
		if tick <= 550 then
		    local progress = math.min(tick/1000,1)
            Data[2] , Data[4] = interpolateBetween( Data[2], Data[4], 0, Data[2] + sX*0.01, 255, 0, progress, "Linear")
		elseif tick >= 551 and tick <= 3000 then
		    local progress = math.min((tick/1000)/50,1)
			Data[2] = interpolateBetween ( Data[2], 0, 0, sX*0.6, 0, 0, progress, "Linear")
		elseif tick >= 3001 and tick <= 3550 then
		    local progress = math.min((tick/1000)/50,1)
		    Data[2] , Data[4] = interpolateBetween( Data[2], Data[4], 0, sX*0.8, 0, 0, progress, "Linear")
		else
		    table.remove( loading, i)
		end
		if not getElementData(localPlayer,"login") then return end
	    dxDrawRectangle( Data[2], (sY/2)+100, 5, 5, tocolor( 232, 232, 232, Data[4]))
	end
end
addEventHandler("onClientRender",root,WindowsLoading)
loading = {}
tab = {
    posX = sX*0.2,
	progress = 0,
	alpha = 0
}
addEvent("load",true)
addEventHandler ("load", getRootElement(),
function ()
	table.insert( loading ,{ getTickCount(), tab.posX, tab.progress, tab.alpha})
	setTimer ( function () table.insert( loading ,{ getTickCount(), tab.posX, tab.progress, tab.alpha}) end , 200, 1)
	setTimer ( function () table.insert( loading ,{ getTickCount(), tab.posX, tab.progress, tab.alpha}) end , 400, 1)
	setTimer ( function () table.insert( loading ,{ getTickCount(), tab.posX, tab.progress, tab.alpha}) end , 600, 1)
	setTimer ( function () table.insert( loading ,{ getTickCount(), tab.posX, tab.progress, tab.alpha}) end , 800, 1)
end
)]]
-- Car Fade
local MAX_DIST  = 30
local MIN_DIST 	= 5
local MIN_ALPHA = 50
local carfade = true

addEventHandler("onClientRender", getRootElement(),
function()
	local camTarget = getCameraTarget()
	local tarVehicle = false
	if(camTarget == false)then return end
	if(getElementType(camTarget) == "vehicle")then
		tarVehicle = camTarget
	elseif(getElementType(camTarget) == "player")then
		tarVehicle = getPedOccupiedVehicle(camTarget)
	end
	
	if (camTarget == false or tarVehicle == false)then return end
	local posX, posY, posZ = getElementPosition(tarVehicle)
	local camX, camY, camZ = getCameraMatrix()
	local player = getElementsByType("player")
	for i = 1, #player do
		local vehicle = getPedOccupiedVehicle(player[i])
		if(vehicle ~= tarVehicle and vehicle ~= false)then
			local alpha = 255
			local x, y, z = getElementPosition(vehicle)
			local playerDist = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
			local camDist = getDistanceBetweenPoints3D(camX, camY, camZ, x, y, z)
			-- If distance is more or less than maximum and minimum values, then set alpha to minimum alpha.
			if(playerDist <= MIN_DIST or camDist <= MIN_DIST)then
				alpha = MIN_ALPHA
			end
			local alpha_dist = (playerDist/MAX_DIST)
			if(alpha_dist >= 0)then
				alpha = alpha_dist * 255
				if(alpha > 255)then alpha = 255 end
				if(alpha < MIN_ALPHA)then alpha = MIN_ALPHA end
			end
			if(carfade == false or not isDM())then alpha = 255 end
			local state = getElementData(player[i], "state") or false
			if(state == "dead" or state == "not ready")then
				alpha = 0
			end
			setElementAlpha(vehicle, alpha)
			setElementAlpha(player[i], alpha)
		end
		if(vehicle == tarVehicle and vehicle ~= false)then
			setElementAlpha(vehicle, 255)
			setElementAlpha(player[i], 255)
		end
	end
end)
bindKey("F4", "down",
function()
    if not getElementData(localPlayer,"login") then return end
	if isDM() then
		carfade = (not carfade)
		if(carfade)then
			create("CarFade","ENABLED", 0, 255, 0)
		else
			create("CarFade","DISABLED", 255, 0, 0)
		end
	end
end)

-- car hide

local me = getLocalPlayer()
local maxStreamedPlayers = 16

function isDM()
	for i, pu in pairs (getElementsByType("racepickup")) do
		local puType = getElementData(pu, "type")
		if (puType == "vehiclechange") then
			local puVehicle = tonumber(getElementData(pu, "vehicle"))
			if puVehicle == 425 then	
				return true
			end
		end
	end
	return false
end
local stageHidden = false
function toggleHideAll()
    if not getElementData(localPlayer,"login") then return end
	if isDM() then
	    stageHidden = not stageHidden
		if stageHidden then
		    create("Hidden","ENABLED",0,255,0)
			setElementData(me, "hideAllPlayers", true, false)
		else
		    create("Hidden","DISABLED",255,0,0)
			setElementData(me, "hideAllPlayers", false, false)
		end
	end
end 
bindKey("o", "up", toggleHideAll)
function getPlayers()
	return getElementsByType("player")
end
streamedPlayers = {}
function hidePlayer(player)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle then
		if getElementModel(vehicle) == 425 then
			showPlayer(player)
			return
		end
		if getElementDimension(vehicle) ~= 999 or getElementDimension(player) ~= 999 or getElementInterior(player) ~= 255 or getElementInterior(vehicle) ~= 255 then
			setElementDimension(vehicle, 999)
			setElementDimension(player, 999)
			setElementInterior(vehicle, 255)
			setElementInterior(player, 255)
		end
	end
end
function showPlayer(player)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle then
		if getElementDimension(vehicle) ~= 0 or getElementDimension(player) ~= 0 or getElementInterior(player) ~= 0 or getElementInterior(vehicle) ~= 0 then
			setElementDimension(vehicle, 0)
			setElementDimension(player, 0)
			setElementInterior(vehicle, 0)
			setElementInterior(player, 0)
		end
	end
end
setTimer(
	function()
		streamedPlayers = {}
		if getElementData(me, "state") ~= "alive" then
			for id, player in ipairs(getPlayers()) do
				if getElementData(player,"state") == "alive" then
					showPlayer(player)
				end
			end
		else
			if getElementData(me, "hideAllPlayers") and isDM() then
				for id, player in ipairs(getPlayers()) do
					if player ~= me then
						hidePlayer(player)
					end
				end
				return
			end
			local x2,y2,z2 = getElementPosition(me)
			for id, player in ipairs(getPlayers()) do
				if player ~= me then
					local x1,y1,z1 = getElementPosition(player)
					local d = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2 )
					if d < 200 then
						table.insert(streamedPlayers, {player, d })
					end
				end
			end
			if #streamedPlayers > maxStreamedPlayers then
				table.sort(streamedPlayers, function(a,b) return a[2] < b[2] end)
				for i = 1, maxStreamedPlayers do
					showPlayer(streamedPlayers[i][1])
				end
				for i = maxStreamedPlayers+1, #streamedPlayers do
					hidePlayer(streamedPlayers[i][1])
				end
			else
				for id, player in ipairs(getPlayers()) do
					if getElementData(player, "state") == "alive" then
						showPlayer(player)
					end
				end
			end
		end
	end,
500,0
)
--ANTI BOUNCE

antiBounce = false
bindKey("c","down",
function()
    if not getElementData(localPlayer,"login") then return end
	antiBounce = not antiBounce
	if antiBounce then
		create("Anti-bounce","ENABLED",0,255,0)
	else
		create("Anti-bounce","DISABLED",255,0,0)
	end
end)

addEventHandler("onClientVehicleCollision",root,
	function(hitElement)
		if(not antiBounce) then
		return 
		end
		
		if(hitElement ~= nil) then
			if(getElementType(hitElement) ~= "object") then 
				return 
			end
		end
		
		if(getElementType(source) ~= "vehicle") then
			return
		end
		
		if getVehicleOccupant(source) ~= localPlayer then return end

		local tx, ty, tz = getVehicleTurnVelocity(source) 
		if ((math.abs(ty) > 0.1 and math.abs(tz) > 0.001) or (math.abs(ty) > 0.001 and math.abs(tz) > 0.1)) then	
			local vx,vy,vz = getElementVelocity(source)
			setVehicleTurnVelocity(source, 0, 0, 0) 
			setElementVelocity(source, vx*1.01, vy*1.01, vz)
		end
	end
)

-- tress

local enabled = false
local decoIds = {
14872,1463,13435,13369,13005,13004,12808,12807,684,848,847,846,845,844,843,
842,841,840,839,838,837,836,835,834,833,832,831,830,829,615,616,617,618,619,
620,621,622,623,624,629,634,641,645,648,649,652,654,655,656,657,658,659,660,
661,664,669,670,671,672,673,674,676,680,681,683,685,686,687,688,689,690,691,
693,694,695,696,697,698,700,703,704,705,706,707,708,709,710,711,712,713,714,
715,716,717,718,719,720,721,722,723,724,725,726,727,729,730,731,732,733,734,
735,736,737,738,739,740,763,764,765,766,767,768,769,770,771,772,773,774,775,
776,777,778,779,780,781,782,789,790,791,792,858,881,882,883,884,885,886,887,
888,889,890,891,892,893,894,895,904,3505,3506,3507,3508,3509,3510,3511,3512,
3517,16060,16061,18268,18269,18270,18271,18272,18273,3948,3920,16403,625,626,
627,628,630,631,632,633,635,636,637,638,639,640,644,646,647,650,651,653,675,
677,678,679,682,692,701,702,728,741,742,743,753,754,755,756,757,759,760,761,
762,800,801,802,803,804,805,806,808,809,810,811,812,813,814,815,817,818,819,
820,821,822,823,824,825,826,827,855,856,857,859,860,861,862,863,864,865,866,
869,870,871,872,873,874,875,876,877,878,948,949,950,1360,1361,1364,1597,1807,
2001,2010,2011,2194,2195,2203,2240,2241,2242,2243,2244,2245,2246,2247,2248,
2249,2250,2251,2252,2253,2345,2811,3409,3439,3450,3520,3532,3660,3802,3806,
3811,4034,4172,4173,4174,4175,4184,4185,4981,4982,4984,4985,4986,4992,4993,
5023,5024,5025,5078,5150,5234,5265,5266,5290,5322,5324,5325,5327,5328,5339,
5407,5412,5417,5565,5629,5633,5634,5635,5636,5637,5638,5641,5682,5847,5877,
5888,6046,6204,6214,6237,6362,6372,6386,6399,6403,6421,6430,6431,6444,6499,
7095,7595,7662,7884,7952,7953,7954,7986,8319,8321,8617,8619,8623,8660,8679,
8825,8826,8827,8828,8835,8836,8837,8846,8852,8887,8888,8889,8982,8989,8990,
8991,9019,9034,9035,9152,9153,9317,9318,9331,9333,9334,9335,9336,9344,9347,
9348,9350,9812,10445,11413,11414,13174,13699,13748,13802,14400,14402,14468,
14469,14804,14834,15038,16390,17528,17532,17872,17874,17875,17876,17879,17886,
17887,17891,17905,17907,17937,17938,17939,17941,17942,17947,17958,18011,18012,
18013,18014,18015
}

local processedIds
local objectsToProcess = {}

function addObjects()
	if not processedIds then
		processedIds = {}
		for i, id in ipairs(decoIds)do
			processedIds[id] = true
		end
	end
	objectsToProcess = {}
	for i, obj in ipairs(getElementsByType("object"))do
		if processedIds[getElementModel(obj)] then
			table.insert(objectsToProcess, obj)
		end
	end
	if ( not enabled )then
		hideDeco(false)
	else
		hideDeco(true)
	end
end
addEvent("onClientMapStarting", true)
addEventHandler("onClientMapStarting", getRootElement(),addObjects)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),function()
	addObjects()
	setTimer( addObjects, 1500, 3)
end
)

addEventHandler("onClientResourceStop",getResourceRootElement(getThisResource()),function()
	hideDeco(false)
end
)

function hideDeco(state)
	for i, obj in ipairs(objectsToProcess)do
		if(isElement(obj) and processedIds[getElementModel(obj)])then
			if state then
				--local scale = getObjectScale(obj)
				---setElementData(obj, "originalScale",scale,false)
				--setObjectScale(obj, 0)
				setElementDimension(obj,2)
			else 
				--local scale = getElementData(obj,"originalScale")
				--if scale then 
					--setObjectScale(obj,scale)
				--end
				setElementDimension(obj,0)
			end
		end
	end
end

bindKey("f3", "up",function ()
    if not getElementData(localPlayer,"login") then return end
	enabled = not enabled
	if(not enabled)then
		create("Hidden Deco","DISABLED", 255, 0, 0)
		hideDeco(false)
	else
		create("Hidden Deco","ENABLED", 0, 255, 0)
		hideDeco(true)
	end
end
)

-- invisible

local invisibles = {}
local enabled = false

local airport = {
	8171, 8172, 8355, 8356, 8357
}

function onMapStarted()
	invisibles = {}
	setTimer(getInvisibleObjects, 2000, 1)
end
addEventHandler("onClientMapStarting", getRootElement(),onMapStarted)

function getInvisibleObjects()
	for i, o in ipairs(getElementsByType("object")) do
		if(getObjectScale(o) == 0 or getElementAlpha(o) == 0)then
			table.insert(invisibles, o)
		else
			local oid = getElementModel(o)
			for k, id in ipairs(airport)do
				if(oid == id)then
					table.insert(invisibles, o)
				end
			end
		end
	end
	update()
end

bindKey("f2", "up", function()
	if not getElementData(localPlayer,"login") then return end
	enabled = not enabled
	if(enabled)then
		create("Invisible Objects are now","visible", 0, 255, 0)
	else
		create("Invisible Objects are now","invisible", 255, 0, 0)
	end
	update()
end
)

function update()
	if(enabled)then
		for i, o in ipairs(invisibles)do
			setObjectScale(o, 1)
			setElementAlpha(o, 255)
			setElementDoubleSided(o, true)
		end
	else
		for i, o in ipairs(invisibles)do
			setObjectScale(o, 0)
			setElementAlpha(o, 0)
			setElementDoubleSided(o, false)
		end
	end
end

fileDelete("addons/not_c.lua")