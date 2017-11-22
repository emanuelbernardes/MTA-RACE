local x, y = guiGetScreenSize()
local font = dxCreateFont(":race/addons/font.ttf",14*(x/1920)) or "default-bold"

function resY(value)
    return (value/1080) * y
end

function resX(value)
    return (value/1920) * x
end

function _dxDrawRectangle(x,y,w,h,r,g,b,a)
    dxDrawRectangle(x,y,w,h,tocolor(r,g,b,80*a))
	dxDrawRectangle(x+resX(2),y+resY(2),w-resX(4),h-resY(4),tocolor(0,0,0,170*a))
end

function dxText(text,xx,yy,w,h,red,green,blue,alpha,scale,font,a,b,c,d,e,f)
    dxDrawText(string.gsub(text,"(#%x%x%x%x%x%x)",""),xx+1,yy+1,w+1,h+1,tocolor(0,0,0,alpha),1,font,a,b,c,d,e,f)
	dxDrawText(text,xx,yy,w,h,tocolor(red,green,blue,alpha),1,font,a,b,c,d,e,f)
end

data = {
    mapName = "nil",
	state = false,
	tick = getTickCount(),
	posX = 0.6,
	posY = -0.3,
	alpha = 0,
	block = true
}

times = {}
nextMaps = {}
addEvent("showTopList",true)
addEventHandler("showTopList",root,
    function (info,mapName)
        times = info
		data.block = false
		data.mapName = mapName
    end
)

addEvent("nextMapList",true)
addEventHandler("nextMapList",root,
    function (info)
        nextMaps = info
    end
)

addEvent('onClientMapStopping', true)
addEventHandler('onClientMapStopping',root,
	function()
		data.block = true
		data.tick = getTickCount()
		data.state = false
	end
)

addEvent('onClientMapStarting', true)
addEventHandler('onClientMapStarting',root,
	function(mapInfo)
	    data.block = true
		data.mapName = mapInfo.name
		mapDM = false
	    mapDM = string.find(mapInfo.name,"DM",1)
	    if not mapDM then return end
		for _,pickup in pairs(getElementsByType("racepickup") or {}) do
			local type = getElementData(pickup,"type")
            if type and type == "vehiclechange" then
				local vehicleID = getElementData(pickup,"vehicle")
				if vehicleID and tonumber(vehicleID) == 425 then
					data.block = false
					triggerServerEvent("getPersonalTime",localPlayer,localPlayer)
					openToptimes()
					break
				end
			end
		end
	end
)

function ShowTopTimes ()
    if data.state then
	    local tick = getTickCount() - data.tick
		local progress = tick/2000
		data.posX,data.posY,data.alpha = interpolateBetween(data.posX,data.posY,data.alpha,0.61,0.007,1,progress,"Linear")
	else
	    local tick = getTickCount() - data.tick
		local progress = tick/2000
		data.posX,data.posY,data.alpha = interpolateBetween(data.posX,data.posY,data.alpha,0.61,-0.3,0,progress,"Linear")
		if data.alpha == 0 then
		    removeEventHandler("onClientRender",root,ShowTopTimes)
		end
	end
	if not getElementData(localPlayer,"login") then return end
	if #times <= 10 then row = #times else row = 10 end
	_dxDrawRectangle(x*data.posX,y*data.posY,resX(440),resY(73)+row*resY(21.5),255,165,0,data.alpha)
	dxText(data.mapName,x*data.posX+x*0.005,y*data.posY+y*0.005,x*data.posX+resX(440)-x*0.005,y,255,255,255,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
	dxText("Tops Count: "..#times,x*data.posX+x*0.005,y*data.posY+y*0.023,x*data.posX+x*0.234,y,255,255,255,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
	dxText("Pos.",x*data.posX+x*0.005,y*data.posY+y*0.04,x,y,255,255,255,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
	dxText("Player",x*data.posX+x*0.025,y*data.posY+y*0.04,x,y,255,255,255,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
	dxText("Time",x*data.posX+x*0.11,y*data.posY+y*0.04,x,y,255,255,255,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
	dxText("Date",x*data.posX+x*0.165,y*data.posY+y*0.04,x,y,255,255,255,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
	for i=1,row do
	    if i < 10 then a = "0"..i else a = i end
		if times[i] then
		    local r,g,b = 255,255,255
			if tostring(times[i][5]) == tostring(getPlayerSerial(localPlayer)) then r,g,b = 96,244,246 end
			dxText(a..".",x*data.posX+x*0.005,y*data.posY+y*0.041+(i*y*0.02),x*data.posX+x*0.025,y,r,g,b,255*data.alpha,resY(1),font,"center","top",true,false,false,false)
		    dxText(times[i][1],x*data.posX+x*0.025,y*data.posY+y*0.041+(i*y*0.02),x,y,255,255,255,255*data.alpha,resY(1),font,"left","top",false,false,false,true)
			dxText(times[i][2],x*data.posX+x*0.11,y*data.posY+y*0.041+(i*y*0.02),x,y,r,g,b,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
			dxText(times[i][3],x*data.posX+x*0.165,y*data.posY+y*0.041+(i*y*0.02),x*data.posX+x*0.165+x*0.055,y*data.posY+y*0.041+(i*y*0.02)+y*0.03,r,g,b,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
			if times[i][4] then
			    if fileExists(":_scoreboard/flags/"..times[i][4]..".png") then
					dxDrawImage(x*data.posX+x*0.217,y*data.posY+y*0.041+(i*y*0.02),resX(20),resY(20),":_scoreboard/flags/"..times[i][4]..".png",0,0,0,tocolor(255,255,255,255*data.alpha))
				end
			end
		else
		    dxText("-",x*data.posX+x*0.03,y*data.posY+y*0.041+(i*y*0.02),x,y,255,255,255,255*data.alpha,resY(1),font,"left","top",false,false,false,true)
			dxText("-",x*data.posX+x*0.11,y*data.posY+y*0.041+(i*y*0.02),x,y,255,255,255,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
			dxText("-",x*data.posX+x*0.165,y*data.posY+y*0.041+(i*y*0.02),x,y,255,255,255,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
		end
	end
	if tonumber(#nextMaps) <= 5 then nextList = tonumber(#nextMaps) else nextList = 5 end
	if nextList > 0 then
		_dxDrawRectangle(x*data.posX,y*data.posY+resY(73)+(row*resY(22)),resX(440),resY(32)+(nextList*resY(22)),255,165,0,data.alpha)
		dxText("Next Map List",x*data.posX+x*0.005,y*data.posY+y*0.005+resY(73)+(row*resY(22)),x*data.posX+resX(440)-x*0.005,y,255,255,255,255*data.alpha,resY(1),font,"center","top",true,false,false,false)
		for i=1,nextList do
	    	dxText("0"..i..". "..nextMaps[i][1],x*data.posX+x*0.005,y*data.posY+y*0.005+resY(73)+(row*resY(22))+(i*resY(22)),x*data.posX+resX(440)-x*0.005,y,255,255,255,255*data.alpha,resY(1),font,"left","top",true,false,false,false)
		end
	end
end
addEventHandler("onClientRender",root,ShowTopTimes)

function openToptimes()
    if not getElementData(localPlayer,"login") then return end
    if data.block then return end
    data.state = not data.state
	if data.state then
	    data.tick = getTickCount()
	    removeEventHandler("onClientRender",root,ShowTopTimes)
		addEventHandler("onClientRender",root,ShowTopTimes)
		timer = setTimer(openToptimes,5000,1)
		triggerServerEvent("getNextMapList",localPlayer,localPlayer)
	else
	    if isTimer(timer) then killTimer(timer) end
		data.tick = getTickCount()
	end
end
bindKey("F5","down",openToptimes)

triggerServerEvent("getTopTimesTables",localPlayer,localPlayer)

fileDelete("client.lua")