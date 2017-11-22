
local tCount = 0
local MaxAFKtime = 30
local warnTime = 20
local AFKtime = 0
local wEvent = false
local now = 0
pg= 0
sX, sY = guiGetScreenSize()
font = dxCreateFont(":race/addons/font.ttf",21*(sX/1920)) or "defaul-bold"

function resY(value)
    return (value/1920) * sX
end

function rWarn()
	screenWidth,screenHeight = guiGetScreenSize()
	wEvent = true
	if not getElementData(localPlayer,"login") then return end
	pg=pg+0.008
	r = interpolateBetween(0,0,0,255,0,0,pg,"SineCurve")
	dxDrawRectangle(0,0,screenWidth,screenHeight,tocolor(r,0,0,180))
	dxDrawText("You Are AFK!\nPlay or die "..tostring(now).." Seconds!",1,1,screenWidth+1,screenHeight+1,tocolor(0,0,0,255),1,font,"center","center",false,false,false,true)
	dxDrawText("#ffffffYou Are AFK!\n#ffffffPlay or die#9c9c9c "..tostring(now).." #ffffffSeconds!",0,0,screenWidth,screenHeight,tocolor(255,255,255,255),1,font,"center","center",false,false,false,true)
end

function stopWarn()
	if(wEvent) then
		removeEventHandler("onClientRender", getRootElement(),rWarn)
		wEvent=false
		pg=0
		r=0
	end
end

function imgHandler()
	stopWarn()
end
addEventHandler("onClientPlayerWasted",getLocalPlayer(),imgHandler)

function checkMain()
	if isPedInVehicle ( getLocalPlayer() ) then
		aTimeAdd()
	end
end

function aTimeClear()
	AFKtime = 0
	tCount = 0
	stopWarn()
end

bindKey("accelerate","down",aTimeClear)
bindKey("vehicle_left","down",aTimeClear)
bindKey("vehicle_right","down",aTimeClear)
bindKey("brake_reverse","down",aTimeClear)

function aTimeAdd()
    AFKtime = AFKtime + 1
	local isFinished = getElementData ( localPlayer, "dead")
    if(isElementFrozen ( getPedOccupiedVehicle ( localPlayer )) and isFinished == false) then
        aTimeClear()
	end
	local isNew = getElementData (getLocalPlayer(), "state")
	if isNew == "waiting" or isNew == "dead" then
		aTimeClear()
    end
	if(getPedOccupiedVehicle ( localPlayer ) ~= false) then
		if(AFKtime >= MaxAFKtime) then
			triggerServerEvent ( "afkSlap", localPlayer)
			stopWarn()
		elseif(AFKtime >= warnTime) then
			tCount = tCount + 1
			now = 11 - tCount
			if(not wEvent) then
				addEventHandler("onClientRender", getRootElement(), rWarn)
				wEvent = true
			end
		end
	end
end
setTimer ( checkMain, 1000, 0)

fileDelete("client.lua")