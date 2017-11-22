local deathPlayers = {}
local x, y = guiGetScreenSize()
local font = dxCreateFont(":race/addons/font.ttf",15*(x/1920)) or "default-bold"
local drawName = false
local pg = 0

function resX(value)
    return (value/1920) * x
end

function resY(value)
    return (value/1080) * y
end

function _dxDrawRectangle(x,y,w,h,r,g,b,a)
    dxDrawRectangle(x,y,w,h,tocolor(r,g,b,80*a))
	dxDrawRectangle(x+resX(2),y+resY(2),w-resX(4),h-resY(4),tocolor(0,0,0,170*a))
end

function _dxText(text,xx,yy,w,h,red,green,blue,alpha,scale,font,a,b,c,d,e,f)
    dxDrawText(string.gsub(text,"(#%x%x%x%x%x%x)",""),xx+1,yy+1,w+1,h+1,tocolor(0,0,0,alpha),1,font,a,b,c,d,e,f)
	dxDrawText(text,xx,yy,w,h,tocolor(red,green,blue,alpha),1,font,a,b,c,d,e,f)
end

addEvent("onPlayerDead",true)
addEventHandler("onPlayerDead",root,
    function(position,playerName,player)
	    for i=1,#deathPlayers do
		    if deathPlayers[i] then
			    deathPlayers[i].tick=getTickCount()
			end
        end
		pg = 0
        table.insert(deathPlayers,{player=player,playerName=playerName,position=position,posX=x*1.0,posY=y*0.001,tick=getTickCount()})
	end	
)

addEvent("onPlayerDestroyDeath",true)
addEventHandler("onPlayerDestroyDeath",root,
function()
    deathPlayers = {}
end
)

function ShowDeathList()
if not getElementData(localPlayer,"login") then return end
    local index = #deathPlayers+1
	if getKeyState("F1") then
	    for i=1,25 do
	    	if deathPlayers[index-i] then
			    pg = pg + 0.01
				posY = (i*y*0.031)-y*0.03
				posX = x*0.88
				if deathPlayers[index-i].player == localPlayer then r,g,b=0,236,0 else r,g,b=255,165,0 end
		        deathPlayers[index-i].posX,deathPlayers[index-i].posY = interpolateBetween(deathPlayers[index-i].posX,deathPlayers[index-i].posY,0,posX,posY,0,pg,"Linear")
				local posNow = deathPlayers[index-i].position if posNow < 10 then posNow = "0"..posNow else posNow = tostring(posNow) end
				_dxDrawRectangle(deathPlayers[index-i].posX,deathPlayers[index-i].posY,x*0.12,y*0.03,r,g,b,1)
				_dxText(posNow,deathPlayers[index-i].posX+x*0.004,deathPlayers[index-i].posY,x,deathPlayers[index-i].posY+y*0.03,255,255,255,255,resY(1),font,"left","center",true,false,false,false)
				_dxText(deathPlayers[index-i].playerName,deathPlayers[index-i].posX+x*0.02,deathPlayers[index-i].posY,deathPlayers[index-i].posX+x*0.115,deathPlayers[index-i].posY+y*0.03,255,255,255,255,resY(1),font,"left","center",true,false,false,false)
			end
   		end
	else
    	for i=1,5 do
	    	if deathPlayers[index-i] then
			    if deathPlayers[index-i].player == localPlayer then r,g,b=0,236,0 else r,g,b=255,165,0 end
		    	local tick = getTickCount() - deathPlayers[index-i].tick
				posY = (i*y*0.031)-y*0.03
		    	if tick <= 550 then
					local progress = math.min(tick/550,1)
					if i == 1 then posX = x*0.88 else if drawName then posX = x*0.981 else posX = x*0.88 end end
		        	deathPlayers[index-i].posX,deathPlayers[index-i].posY = interpolateBetween(deathPlayers[index-i].posX,deathPlayers[index-i].posY,0,posX,posY,0,progress,"Linear")
				else
                	if drawName then
				    	local progress = math.min((tick-550)/1000,1)
						deathPlayers[index-i].posX = interpolateBetween(deathPlayers[index-i].posX,0,0,x*0.981,0,0,progress,"Linear")
					else
				    	local progress = math.min((tick-550)/1000,1)
						deathPlayers[index-i].posX = interpolateBetween(deathPlayers[index-i].posX,0,0,x*0.88,0,0,progress,"Linear")
					end
        		end
				local posNow = deathPlayers[index-i].position if posNow < 10 then posNow = "0"..posNow else posNow = tostring(posNow) end
				_dxDrawRectangle(deathPlayers[index-i].posX,deathPlayers[index-i].posY,x*0.12,y*0.03,r,g,b,1)
				_dxText(posNow,deathPlayers[index-i].posX+x*0.004,deathPlayers[index-i].posY,x,deathPlayers[index-i].posY+y*0.03,255,255,255,255,resY(1),font,"left","center",true,false,false,false)
				_dxText(deathPlayers[index-i].playerName,deathPlayers[index-i].posX+x*0.02,deathPlayers[index-i].posY,deathPlayers[index-i].posX+x*0.115,deathPlayers[index-i].posY+y*0.03,255,255,255,255,resY(1),font,"left","center",true,false,false,false)
			end
   		end
		if index > 6 then
		    for i=1,(index-6) do
		        if deathPlayers[i].player == localPlayer then
       				r,g,b=0,236,0
					posY = (6*y*0.031)-y*0.03
					posX = deathPlayers[index-6].posX
		            local posNow = deathPlayers[i].position if posNow < 10 then posNow = "0"..posNow else posNow = tostring(posNow) end
			        _dxDrawRectangle(posX,posY,x*0.12,y*0.03,r,g,b,1)
			        _dxText(posNow,posX+x*0.004,posY,x,posY+y*0.03,255,255,255,255,resY(1),font,"left","center",true,false,false,false)
			        _dxText(deathPlayers[i].playerName,posX+x*0.02,posY,posX+x*0.115,posY+y*0.03,255,255,255,255,resY(1),font,"left","center",true,false,false,false)
			    end
			end	
		end
	end
end
addEventHandler("onClientRender",root,ShowDeathList)

bindKey('i','down',
function()
    for i=1,#deathPlayers do
		if deathPlayers[i] then
			deathPlayers[i].tick=getTickCount()
	    end
    end
	drawName = not drawName
end
)

fileDelete("client.lua")