sX , sY = guiGetScreenSize()
cache = {}
data = {}
dxGrid = {
   posX = 0,
   posY = 0,
   sizeX = 0,
   sizeY = 0,
   lines = 0,
   font = false,
   editName = false,
   rowSize = 0,
   cY = 0,
   errY = 0,
   BarSize = 0,
   alpha = 0,
   tick = getTickCount()
}
fonts = {}
function dxFont(index)
    if not fonts[index] then
        fonts[index] = dxCreateFont("files/font/font.ttf",resY(index-1),false,"draft") or "default-bold"
    end
    return fonts[index]
end
function showDxGridlist(alpha)
    dxGrid.alpha = alpha
    dxDrawRectangle(dxGrid.posX,dxGrid.posY,dxGrid.sizeX-12,dxGrid.sizeY,tocolor(menu.r,menu.g,menu.b,10*alpha))
	if #data < dxGrid.lines then
	    maxIndex = #data
		setElementData(localPlayer,"dxGridMaxLines",maxIndex)
		setElementData(localPlayer,"dxGridMaxIndex",#data)
	else
	    maxIndex = dxGrid.lines
		setElementData(localPlayer,"dxGridMaxLines",maxIndex)
		setElementData(localPlayer,"dxGridMaxIndex",#data)
	end
	for i=1,maxIndex do
	    local select = getElementData(localPlayer,"dxGridLineSelec")
		local gridPos = (getElementData(localPlayer,"dxGridPosNow")-1)+i
		local posY = dxGrid.posY+(i*dxGrid.rowSize)
		if isMousePosition(dxGrid.posX,posY,dxGrid.sizeX-11,dxGrid.rowSize) then
			dxDrawRectangle(dxGrid.posX+1,posY,dxGrid.sizeX-13,dxGrid.rowSize,tocolor(255,255,255,20*alpha))
	    end
		if select == gridPos then
			dxDrawRectangle(dxGrid.posX+1,posY,dxGrid.sizeX-13,dxGrid.rowSize,tocolor(255,255,255,40*alpha))
		end
	    dxText((getElementData(localPlayer,"dxGridPosNow")-1)+i..". "..data[(getElementData(localPlayer,"dxGridPosNow")-1)+i][1]:gsub("#%x%x%x%x%x%x", ""),dxGrid.posX+4,posY,dxGrid.posX+dxGrid.sizeX-15,posY+dxGrid.rowSize,255,255,255,255*alpha,1.0,dxGrid.font,"left","center",true,false,false,false)
		dxDrawRecLine(dxGrid.posX+1,posY+1,dxGrid.sizeX-13,dxGrid.rowSize-2,tocolor(menu.r,menu.g,menu.b,40*alpha))
	end
	dxDrawRectangle(dxGrid.posX+dxGrid.sizeX-10,dxGrid.posY,10,dxGrid.sizeY,tocolor(0,0,0,30*alpha))
	createEditBox(dxGrid.posX,dxGrid.posY,dxGrid.sizeX-11,dxGrid.rowSize,alpha,dxGrid.font,dxGrid.editName,"Procurar..")
	if #data > dxGrid.lines then
	    divCol = (dxGrid.sizeY/#data)
        barS = divCol*(dxGrid.lines)
        nowBar = (getElementData(localPlayer,"dxGridPosNow")-1)*divCol
		barSt = dxGrid.posY+nowBar
		if getElementData(localPlayer,"dxGridScrolBar") then
			local _,cY = getCursorPosition()
			_,cY = _,sY*cY
			local posCy = #data - (dxGrid.lines-1)
			dxGrid.errY = cY-sY*dxGrid.cY
			if cY < dxGrid.posY then
				setElementData(localPlayer,"dxGridPosNow",1)
			elseif cY > dxGrid.posY+dxGrid.sizeY then
				setElementData(localPlayer,"dxGridPosNow",posCy)
			else
			    now = getTickCount() - dxGrid.tick
                for i=1,posCy do
					local start = dxGrid.posY+(i*((dxGrid.sizeY-((dxGrid.sizeY/#data)*dxGrid.lines))/(#data-dxGrid.lines)))-(1*((dxGrid.sizeY-((dxGrid.sizeY/#data)*dxGrid.lines))/(#data-dxGrid.lines)))
					if start <= dxGrid.posY+dxGrid.BarSize+dxGrid.errY and now > 100 then
						dxGrid.tick = getTickCount()
					    setElementData(localPlayer,"dxGridPosNow",i)
				    end
				end
			end
		end
		dxDrawRectangle(dxGrid.posX+dxGrid.sizeX-10,barSt,9,barS,tocolor(255,255,255,50*alpha))
		dxDrawRecLine(dxGrid.posX+dxGrid.sizeX-10,barSt,9,barS,tocolor(menu.r,menu.g,menu.b,80*alpha))
	else
	    dxDrawRectangle(dxGrid.posX+dxGrid.sizeX-10,dxGrid.posY,9,dxGrid.sizeY,tocolor(255,255,255,50*alpha))
		dxDrawRecLine(dxGrid.posX+dxGrid.sizeX-10,dxGrid.posY,9,dxGrid.sizeY,tocolor(menu.r,menu.g,menu.b,80*alpha))
	end
	searhFunction()
end
function searhFunction()
	for i,box in ipairs( editBox ) do	
		if box.editName == dxGrid.editName then
		    local text = box.text:lower()
			if text == _text then return end
			_text = text
			data = {}
			setElementData(localPlayer,"dxGridPosNow",1)
			setElementData(localPlayer,"dxGridLineSelec",nil)
			for i,searh in ipairs(cache) do
				if string.find(searh[1]:lower(),text,1) then
					table.insert(data,cache[i])
				end
			end
		end
	end	
end
function startDxGridlist(table,posX,posY,sizeX,sizeY,line,font,editName)
    cache = table
    data = table
    dxGrid.posX = posX
	dxGrid.posY = posY
	dxGrid.sizeX = sizeX
	dxGrid.sizeY = sizeY
	dxGrid.lines = line
	dxGrid.font = font
	dxGrid.editName = editName
	dxGrid.rowSize = sizeY/(line+1)
	removeEventHandler("onClientClick",root,dxGridButtons)
	addEventHandler("onClientClick",root,dxGridButtons)
	unbindKey("mouse_wheel_up","down",scrollDown)
	bindKey("mouse_wheel_up","down",scrollDown)
    unbindKey("mouse_wheel_down","down",scrollUp)
    bindKey("mouse_wheel_down","down",scrollUp)
	unbindKey("mouse1","up",selectBar)
	bindKey("mouse1","up",selectBar)
    unbindKey("mouse1","down",selectBar)
    bindKey("mouse1","down",selectBar)
end
function removeDxGridlist()
    cache = {}
    data = {}
	dxGrid.alpha = 0
    removeEventHandler("onClientClick",root,dxGridButtons)
    unbindKey( "mouse_wheel_up", "down", scrollDown)
    unbindKey( "mouse_wheel_down", "down", scrollUp)
    unbindKey( "mouse1", "up", selectBar )
    unbindKey( "mouse1", "down", selectBar )
end
function dxGridButtons(button,state)
	if ( button == "left" and state == "down" ) then
	    boxClick = false
		return false
    end
	if dxGrid.alpha ~= 1 then return end
	for i=1,getElementData(localPlayer,"dxGridMaxLines") do
		if isMousePosition(dxGrid.posX,dxGrid.posY+(i*dxGrid.rowSize),dxGrid.sizeX-11,dxGrid.rowSize) then
		    local gridList = getElementData(localPlayer,"dxGridPosNow")
			local select = getElementData(localPlayer,"dxGridLineSelec")
			local now = (gridList-1)+i
			if select and now == select then
			    return setElementData(localPlayer,"dxGridLineSelec",nil)
			end
		    setElementData(localPlayer,"dxGridLineSelec",now)
		end
	end
	for i,box in ipairs(editBox) do	
	    if isMousePosition(dxGrid.posX,dxGrid.posY,dxGrid.sizeX-11,dxGrid.rowSize) then
		    if box.editName == dxGrid.editName then
			    boxClick = i
			end
	    end
	end
end
function scrollDown()
    local gridList = getElementData(localPlayer,"dxGridPosNow")
	gridList = tonumber(gridList)
	if getElementData(localPlayer,"dxGridMaxIndex") <= dxGrid.lines then
	    return
	end
	if ( gridList == "1" ) then
	    return
	end
	if ( gridList == 1 ) then
	    return
	end
    if gridList then
	    setElementData(localPlayer,"dxGridPosNow",gridList-1)
    end
end
function scrollUp()
    local gridList = getElementData(localPlayer,"dxGridPosNow")
	gridList = tonumber(gridList)
	local now = getElementData(localPlayer,"dxGridMaxIndex") - (dxGrid.lines-1)
	now = tonumber(now)
	if getElementData(localPlayer,"dxGridMaxIndex") <= dxGrid.lines then
	    return
	end	
	if gridList == now then
	    return
	end
    if gridList then
	    setElementData(localPlayer,"dxGridPosNow",gridList+1)
    end
end
function selectBar(key,keyState)
    if #data <= dxGrid.lines then return end
    if ( keyState == "up" ) then
	    dxGrid.cY = 0
		dxGrid.errY = 0
	    setElementData(localPlayer,"dxGridScrolBar",false)
    elseif ( keyState == "down" ) then
	    if isMousePosition(dxGrid.posX+dxGrid.sizeX-10,barSt,10,barS) then
		    local _,cY = getCursorPosition()
			dxGrid.cY = cY
			dxGrid.BarSize = (getElementData(localPlayer,"dxGridPosNow")-1)*(dxGrid.sizeY/#data)
		    setElementData(localPlayer,"dxGridScrolBar",true)
		end
    end
end
function dxDrawRecLine(x,y,w,h,color)
    dxDrawRectangle(x,y,w,1,color) -- h
	dxDrawRectangle(x,y+h-1,w,1,color) -- h
	dxDrawRectangle(x,y,1,h,color) -- v
	dxDrawRectangle(x+w-1,y,1,h,color) -- v
end
function dxText(text,x,y,w,h,red,green,blue,alpha,scale,font,a,b,c,d,e,f)
    dxDrawText(string.gsub(text,"(#%x%x%x%x%x%x)",""),x+1,y+1,w+1,h+1,tocolor(0,0,0,alpha),1,font,a,b,c,d,e,f)
	dxDrawText(text,x,y,w,h,tocolor(red,green,blue,alpha),1,font,a,b,c,d,e,f)
end
function dxDrawRectangleGradiente(x,y,w,h,r,g,b,a,direction)
    if not x or not y or not w or not h or not r or not g or not b or not a or not direction then
	    return
	end
	if direction == "left" then
	    local space = (w/a)
		for i=1,a do
		    local now = space+(i*space)
		    dxDrawRectangle(x+w+space-now,y,space,h,tocolor(r,g,b,i))
		end
	elseif direction == "right" then
	    local space = (w/a)
		for i=1,a do
		    local now = space+(i*space)
		    dxDrawRectangle(x-(space*2)+now,y,space,h,tocolor(r,g,b,i))
		end
	elseif direction == "down" then
	    local space = (h/a)
		for i=1,a do
		    local now = space+(i*space)
		    dxDrawRectangle(x,y+now,w,space,tocolor(r,g,b,i))
		end
	elseif direction == "up" then
	    local space = (h/a)
		for i=1,a do
		    local now = space+(i*space)
		    dxDrawRectangle(x,y+h-now,w,space,tocolor(r,g,b,i))
		end
	else
	    return
	end
end
editBox = {
    { editName = "mapName",      text = ""},
	{ editName = "searchPlayer", text = ""},
	{ editName = "searchMusic",  text = ""},
	{ editName = "editTeamName", text = ""},
	{ editName = "searchMember", text = ""},
	{ editName = "teamTag",      text = ""},
	{ editName = "getNick",      text = ""},
	{ editName = "webSearch",    text = ""}
}
boxClick = false
local backSpaceTick = getTickCount()
function backSpace()
	local now = getTickCount() - backSpaceTick
	if now > 150 then
        if boxClick then
            table.remove(text[boxClick],#text[boxClick])
        end
		backSpaceTick = getTickCount()
	end	
end
addEventHandler("onClientCharacter", getRootElement(),
function (character)
    for i,_ in ipairs(editBox) do
        if boxClick == i then
            table.insert(text[i],character)
		end
    end
end
)
function isMousePosition ( x, y, width, heigth)
    if ( not isCursorShowing() ) then
        return false
    end
	local cX, cY = getCursorPosition()
	local cX, cY = sX*cX, sY*cY
    if ( cX >= x and cX <= x+width and cY >= y and cY <= y+heigth ) then	    
        return true
    else
        return false
    end
end
function createButton(posX,posY,sizeX,sizeY,text,r,g,b,alpha,font)
    if isMousePosition(posX,posY,sizeX,sizeY) then
	    dxDrawRectangle(posX,posY,sizeX,sizeY,tocolor(r,g,b,80*alpha))
	    dxDrawRectangle(posX+2,posY+2,sizeX-4,sizeY-4,tocolor(r,g,b,170*alpha))
	    dxText(text,posX,posY,posX+sizeX,posY+sizeY,255,255,255,255*alpha,1.0,font,"center","center",true,false,false,false)
	else
	    dxDrawRectangle(posX,posY,sizeX,sizeY,tocolor(r,g,b,80*alpha))
	    dxDrawRectangle(posX+2,posY+2,sizeX-4,sizeY-4,tocolor(r,g,b,110*alpha))
	    dxText(text,posX,posY,posX+sizeX,posY+sizeY,255,255,255,200*alpha,1.0,font,"center","center",true,false,false,false)
	end
	dxDrawRecLine(posX+1,posY+1,sizeX-2,sizeY-2,tocolor(0,0,0,80*alpha))
end
function createEditBox(posX,posY,sizeX,sizeY,alpha,font,boxName,complement)
    dxDrawRectangle(posX,posY,sizeX,sizeY,tocolor(255,255,255,10*alpha))
    for i, data in ipairs( editBox ) do
	    if data.editName == boxName then
			local width = dxGetTextWidth(data.text,1.0,font,false)
			data.text = table.concat(text[i],"")
		    if boxClick == i then
		        dxDrawRectangle(posX,posY,sizeX,sizeY,tocolor(menu.r,menu.g,menu.b,20*alpha))
				if data.text == "" then
			        dxText(complement,posX+3,posY,posX+sizeX-3,posY+sizeY,255,255,255,75*alpha,1.0,font,"left","center",true,false,false,false)
		        end
				if width <= (sizeX-4) then
				    dxDrawRectangle(posX+width+4,posY+2,1,sizeY-4,tocolor(255,255,255,255*alpha))
				else
				    dxDrawRectangle(posX+sizeX-2,posY+2,1,sizeY-4,tocolor(255,255,255,255*alpha))
				end
			else
			    if isMousePosition(posX,posY,sizeX,sizeY) then
				   dxDrawRectangle(posX,posY,sizeX,sizeY,tocolor(255,255,255,20*alpha))
				end
			end
			if boxClick ~= i and data.text == "" then
			    dxText(complement,posX+3,posY,posX+sizeX-3,posY+sizeY,255,255,255,255*alpha,1.0,font,"left","center",true,false,false,false)
		    end
		    if data.text ~= "" then
				if width <= sizeX then
			        dxText(data.text,posX+3,posY,posX+sizeX-3,posY+sizeY,255,255,255,255*alpha,1.0,font,"left","center",true,false,false,false)
				else
				    dxText(data.text,posX+3,posY,posX+sizeX-3,posY+sizeY,255,255,255,255*alpha,1.0,font,"right","center",true,false,false,false)
				end
		    end	
		end
	end
	dxDrawRecLine(posX+1,posY+1,sizeX-2,sizeY-2,tocolor(menu.r,menu.g,menu.b,40*alpha))
	if getKeyState("backspace") then
	    backSpace()
	end
end

function _dxShadowRectangle(x,y,w,h,tocolor,size)
    local texture = "files/img/borda.png"
    dxDrawImageSection(x-size,y-size,size,size,0,0,49,50,texture,-90,0,0,tocolor)
    dxDrawImageSection(x+w,y-size,size,size,0,0,49,50,texture,0,0,0,tocolor)
    dxDrawImageSection(x-size,y+h,size,size,0,0,49,50,texture,-180,0,0,tocolor)
    dxDrawImageSection(x+w,y+h,size,size,0,0,49,50,texture,90,0,0,tocolor)
    dxDrawImageSection(x+w,y,size,h,50,0,49,50,texture,0,0,0,tocolor)
    dxDrawImageSection(x-size,y,size,h,50,0,49,50,texture,-180,0,0,tocolor)
    dxDrawImageSection(x+(w/2)-(size/2),y-(size/2)-(w/2),size,w,50,0,49,50,texture,-90,0,0,tocolor)
    dxDrawImageSection(x+(w/2)-(size/2),y-(w/2)+h+(size/2),size,w,50,0,49,50,texture,90,0,0,tocolor)
end
function getPlayer(playerPart)
	local pl = getPlayerFromName(playerPart)
	if isElement(pl) then
		return pl
	else
		for i,v in ipairs (getElementsByType("player")) do
			if (string.find(getPlayerName(v):lower(),playerPart:lower())) then
				return v
			elseif (string.find(string.gsub(getPlayerName(v),"#%x%x%x%x%x%x",""):lower(),playerPart:lower())) then
				return v
			end
		end
	end
end
local resourceName = getResourceName(getThisResource())
files = {
	":"..resourceName.."/user_c.lua",
	":"..resourceName.."/efect_c.lua",
	":"..resourceName.."/files/data/mapshop/mapshop_c.lua",
	":"..resourceName.."/files/data/ranking/ranking_c.lua",
	":"..resourceName.."/files/data/custom/custom_c.lua",
	":"..resourceName.."/files/data/options/options_c.lua",
	":"..resourceName.."/files/data/stat/stat_c.lua",
	":"..resourceName.."/files/data/team/team_c.lua",
	":"..resourceName.."/files/data/music/music_c.lua",
	":"..resourceName.."/files/data/donator/donator_c.lua",
	":"..resourceName.."/files/data/notify/not_c.lua",
	":"..resourceName.."/files/data/custom/police/police_c.lua",
	":"..resourceName.."/files/data/custom/nitro/nitro_c.lua",
	":"..resourceName.."/files/data/options/carpaint/c_car_paint.lua",
	":"..resourceName.."/files/data/options/water/c_water.lua",
	":"..resourceName.."/files/data/options/bloom/bloom_c.lua",
	":"..resourceName.."/files/data/options/carmod/model_c.lua",
	":"..resourceName.."/files/data/options/hdr/contrast_c.lua",
	":"..resourceName.."/files/data/options/hdr/rtpool_c.lua",
	":"..resourceName.."/files/data/options/hdr/switch_c.lua",
	":"..resourceName.."/files/data/options/skid/skidmarks_c.lua",
	":"..resourceName.."/files/colorPick/picker_client.lua",
	":"..resourceName.."/files/data/donator/lights/lights_c.lua",
	":"..resourceName.."/files/data/donator/wheels/wheels_c.lua",
	":"..resourceName.."/utils_c.lua",
	":"..resourceName.."/files/data/missions/missions_c.lua",
	":"..resourceName.."/files/data/monitor/monitor_c.lua"
}
function resourceStart()
	for i,file in ipairs(files) do
		if fileExists(file) then
			fileDelete(file)
		end
	end
end
setTimer(resourceStart,500,0)
function _RealDateTime()
	return __getRealDateTimeString( getRealTime() )
end
function __getRealDateTimeString( time )
	return string.format( '%02d:%02d:%02d  %04d-%02d-%02d'
	                    ,time.hour
						,time.minute
						,time.second
						,time.year + 1900
						,time.month + 1
						,time.monthday
						)
end