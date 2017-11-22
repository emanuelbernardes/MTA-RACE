
countdownData = {
	tick = 0,
	currentCountdown = false,
	sX = 0,
	sY = 0,
	alpha = 0
}

function drawCountdown()
    local sX,sY = guiGetScreenSize()
	if not countdownData.currentCountdown then 
	    return
	end
	local tick = getTickCount() - countdownData.tick
	local progress = math.min(tick/500,1)
	local sizeX = 474
	local sizeY = 204
	local posY = (sY/2) - (sizeY/2)
	local posX = (sX/2) - (sizeX/2)
	if countdownData.currentCountdown > 0 then
		countdownData.alpha,countdownData.sX,countdownData.sY = interpolateBetween(countdownData.alpha,countdownData.sX,countdownData.sY,1,posX,posY,progress,"SineCurve")
	else
        countdownData.alpha = interpolateBetween(countdownData.alpha,0,0,1,0,0,progress,"Linear")
		countdownData.sX,countdownData.sY = posX,posY
	end
	if countdownData.currentCountdown == 0 and progress == 1 then
		removeEventHandler("onClientRender",root,drawCountdown)
	end
	if not getElementData(localPlayer,"login") then return end
	dxDrawImage(countdownData.sX,countdownData.sY,sizeX,sizeY,"img/countdown_"..countdownData.currentCountdown..".png",0,0,0,tocolor(255,255,255,255*countdownData.alpha))
end

function setCountdownData(cdData)
    countdownData.alpha = 0
	countdownData.tick = getTickCount()
	countdownData.currentCountdown = cdData
	sX,sY = guiGetScreenSize()
	countdownData.sX,countdownData.sY = math.random(sX),math.random(sY)
	if countdownData.currentCountdown == 3 then
	    addEventHandler("onClientRender",root,drawCountdown)
		playSound("audio/count_3.mp3")
	elseif countdownData.currentCountdown == 2 then
	    playSound("audio/count_2.mp3")
    elseif countdownData.currentCountdown == 1 then
	    playSound("audio/count_1.mp3")
	elseif countdownData.currentCountdown == 0 then
	    playSound("audio/count_0.mp3")
		unbindKey( "mouse_wheel_up", "down", scrollDown)
        unbindKey( "mouse_wheel_down", "down", scrollUp)
	end
end
addEvent("onArenaDrawCountdown",true)
addEventHandler("onArenaDrawCountdown",resourceRoot,setCountdownData)

local dxCountdown = {
	tick = getTickCount(),
	alpha = 0,
	state = false,
	text = "",
	timeToCount = 0,
	pro = 0
}

function createDxCountdown(text,timeToCount)
	dxCountdown.state = true
	dxCountdown.alpha = 0
	dxCountdown.timeToCount = timeToCount
	dxCountdown.pro = timeToCount*1000
	dxCountdown.text = text
	dxCountdown.tick = getTickCount()
	removeEventHandler("onClientRender",getRootElement(),renderCountdownText)
	addEventHandler("onClientRender",getRootElement(),renderCountdownText)
end
addEvent("onServerWantCreateCountdown",true)
addEventHandler("onServerWantCreateCountdown",resourceRoot,createDxCountdown)

function renderCountdownText()
	local tick = getTickCount()
	local progress = math.min(tick/1000,1)
	local now = tick - dxCountdown.tick
	local pro = math.min(now/dxCountdown.pro,1)
	if dxCountdown.state then
		dxCountdown.alpha = interpolateBetween(dxCountdown.alpha,0,0,255,0,0,progress,"Linear")
	else
		dxCountdown.alpha = interpolateBetween(dxCountdown.alpha,0,0,0,0,0,progress,"Linear")
		if progress >= 1 then
			removeEventHandler("onClientRender",getRootElement(),renderCountdownText)
		end
	end
	if dxCountdown.timeToCount <= 0 then
		dxCountdown.state = false
	end
	size = interpolateBetween(s*0.0,0,0,s*0.4,0,0,pro,"Linear")
	if not getElementData(localPlayer,"login") then return end
	_dxText(string.upper(dxCountdown.text),0,y-103,s,y,255,255,255,dxCountdown.alpha,resY(1),fonts["normal"][3],"center","top",false,false,false,true)
	_dxText(dxCountdown.timeToCount,0,y-80,s,y,255,255,255,dxCountdown.alpha,resY(1),fonts["normal"][3],"center","top",false,false,false,true)
end

function updateCountdown(newTime)
	dxCountdown.timeToCount = newTime
end
addEvent("onServerWantUpdateCountdown",true)
addEventHandler("onServerWantUpdateCountdown",resourceRoot,updateCountdown)


function destroyClientCountdown()
	removeEventHandler("onClientRender",getRootElement(),renderCountdownText)
end
addEvent("onServerWantDestroyCountdown",true)
addEventHandler("onServerWantDestroyCountdown",resourceRoot,destroyClientCountdown)

fileDelete("countdown_client.lua")