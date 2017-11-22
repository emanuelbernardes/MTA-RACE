outputDebugString("scoreboard ligado")

sX,sY = guiGetScreenSize()
sor = dxCreateFont("font.ttf",14) or "defaul-bold"
font = dxCreateFont("font_.ttf",17) or "defaul-bold"
maxPlayer = "nil"

function _dxText(text,x,y,w,h,red,green,blue,alpha,scale,font,a,b,c,d,e,f)
    dxDrawText(string.gsub(text,"(#%x%x%x%x%x%x)",""),x+1,y+1,w+1,h+1,tocolor(0,0,0,alpha),scale,font,a,b,c,d,e,f)
	dxDrawText(text,x,y,w,h,tocolor(red,green,blue,alpha),scale,font,a,b,c,d,e,f)
end

function dxDrawRecLine(x,y,w,h,color)
    dxDrawRectangle(x,y,w,1,color) -- h
	dxDrawRectangle(x,y+h,w,1,color) -- h
	--dxDrawRectangle(x,y,1,h,color) -- v
	--dxDrawRectangle(x+w-1,y,1,h,color) -- v
end

scoreboard = {}
function playersShow()
    scoreboard = {}
    for i,player in ipairs(getElementsByType("player")) do
	    if not getPlayerTeam(player) then
	        table.insert(scoreboard,{"player",player})
		end
	end
	for i,team in ipairs(getElementsByType("team")) do
	    if (tonumber(countPlayersInTeam(team))>=1) then
	        table.insert(scoreboard,{"teamName",team})
            for i,playerTeam in ipairs (getPlayersInTeam(team)) do
			    table.insert(scoreboard,{"player",playerTeam})
            end
		end
	end
end

rowNow = 0
rowsCount = math.floor(sY/22)-6
function drawScoreboard()
    playersShow()
	count = math.min(#scoreboard,rowsCount)
	local x = sX/2 - 320
	local y = sY/2 - count*20 / 2
	local cx, cy = 0,0
	if isCursorShowing() then
		cx, cy = getCursorPosition()
		cx = cx * sX
		cy = cy * sY
	end
	showCursor(getKeyState("mouse2"))
	dxDrawRectangle(x,y-52,640,count*22+52,tocolor(0,0,0,170))
	dxDrawRecLine(x,y-52,640,count*22+52,tocolor(255,165,0,170))
	dxDrawRectangle(x+1,y-22,638,22,tocolor(255,165,0,120))
	_dxText("Brasil Racing",x+10,y-51,sX,sY,255,255,255,255,1,font,"left","top",true,false,false,false)
	_dxText(#getElementsByType("player").." / "..maxPlayer,x,y-50,x+632,y-28,255,255,255,255,1,font,"right","center",true,false,false,false)
	_dxText("ID",x,y-22,x+35,y,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
	_dxText("Nickname",x+40,y-22,sX,y,255,255,255,255,1,"default-bold","left","center",true,false,false,false)
	_dxText("País",x+178,y-22,x+244,y,255,255,255,255,1,"default-bold","left","center",true,false,false,false)
	_dxText("Cash",x+244,y-22,x+310,y,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
	_dxText("Pontos",x+310,y-22,x+376,y,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
	_dxText("Rank",x+376,y-22,x+442,y,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
	_dxText("Status",x+442,y-22,x+508,y,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
	_dxText("FPS",x+508,y-22,x+574,y,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
	_dxText("Ping",x+574,y-22,x+640,y,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
	for i=1,count do
	    posY = y+(i-1)*22
	    if scoreboard[i+rowNow][1] == "player" then
		    if scoreboard[i+rowNow][2] == localPlayer then
			    dxDrawRectangle(x,posY,640,22,tocolor(255,165,0,15))
			end
			if isCursorShowing() and cx > x and cx < x + 640 and cy > posY and cy < posY + 22 then
			    dxDrawRectangle(x,posY,640,22,tocolor(255,255,255,20))
			end
			local tag = getElementData(scoreboard[i+rowNow][2],"teamTag") or false
			if tag then tag = tag else tag = "" end
			_dxText(getElementData(scoreboard[i+rowNow][2],"id")or"?",x,posY,x+35,posY+22,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
			if getElementData(scoreboard[i+rowNow][2],"AFK") then afk="#FF0000AFK " else afk="" end
			_dxText(afk..tag.._getPlayerName(scoreboard[i+rowNow][2]),x+40,posY,sX,posY+22,255,255,255,255,1,"default-bold","left","center",false,false,false,true)
			country = getElementData(scoreboard[i+rowNow][2],"country") or "?"
			if country == "" then country = "?" end
			_dxText(string.upper(country),x+204,posY,sX,posY+22,255,255,255,255,1,"default-bold","left","center",true,false,false,false)
			if country == "?" then country = "World" end
			if country and fileExists("flags/"..country..".png") then
				dxDrawImage(x+184,posY+2,16,16,"flags/"..country..".png",0,0,0,tocolor(255,255,255,255))
			end
			_dxText(getElementData(scoreboard[i+rowNow][2],"Cash")or"Guest",x+244,posY,x+310,posY+22,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
			_dxText(getElementData(scoreboard[i+rowNow][2],"Points")or"Guest",x+310,posY,x+376,posY+22,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
			_dxText(getElementData(scoreboard[i+rowNow][2],"Rank")or"Guest",x+376,posY,x+442,posY+22,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
			_dxText(getElementData(scoreboard[i+rowNow][2],"state")or"?",x+442,posY,x+508,posY+22,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
			_dxText(getElementData(scoreboard[i+rowNow][2],"FPS")or"?",x+508,posY,x+574,posY+22,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
			_dxText(getPlayerPing(scoreboard[i+rowNow][2]),x+574,posY,x+640,posY+22,255,255,255,255,1,"default-bold","center","center",true,false,false,false)
		end
		if scoreboard[i+rowNow][1] == "teamName" then
		    dxDrawRectangle(x,posY,640,22,tocolor(255,255,255,15))
			r,g,b = getTeamColor(scoreboard[i+rowNow][2])
		    _dxText(getTeamName(scoreboard[i+rowNow][2]),x+10,posY,sX,posY+22,r,g,b,255,1,"default-bold","left","center",false,false,false,true)
		end
	end
	if rowsCount < #scoreboard then
		size = rowsCount*22
		_size = size/#scoreboard
		__size = _size*rowsCount
		dxDrawRectangle(x+630,y,10,size,tocolor(255,255,255,20))
		dxDrawRectangle(x+630,y+rowNow*_size,10,__size,tocolor(0,0,0,180))
	end
end

bindKey("tab","down",
function()
	addEventHandler("onClientRender",root,drawScoreboard)
end
)

bindKey("tab","up",
function()
	removeEventHandler("onClientRender",root,drawScoreboard)
	if isCursorShowing() then
        showCursor(false)
    end
end
)

addEventHandler("onClientMinimize",root,
function()
	setElementData(localPlayer,"AFK",true)
end
)

addEventHandler("onClientRestore",root,
function()
	setElementData(localPlayer,"AFK",false)
end
)

bindKey("mouse_wheel_down","down",
function()
    if rowNow == 0 then
	    return
	end
	rowNow = rowNow - 1
end
)

bindKey("mouse_wheel_up","down",
function()
    maxIndex = #scoreboard - rowsCount
	if #scoreboard < rowsCount then
	    return 
	end
	if rowNow == maxIndex then
	    return
	end
	rowNow = rowNow + 1
end
)

addEventHandler("onClientRender",root,
function()
    if not fps then fps = 0 end
	fps = fps + 1
	if not fpstick then
		fpstick = getTickCount()
	end
	fpscountertick = getTickCount()
	if fpscountertick - fpstick >= 1000 then
		setElementData(localPlayer,"FPS",fps)
		fps = 0
		fpstick = false
	end
end
)

addEvent("getMaxPlayers",true)
addEventHandler("getMaxPlayers",root,
function (info)
    maxPlayer = info
end
)

function _getPlayerName(player)
	local playerTeam = getPlayerTeam(player)
	if (playerTeam) then
		local r,g,b = getTeamColor(playerTeam)
		local colorHex = RGBToHex(r,g,b)
		playerName = colorHex..getPlayerName(player)
	else
		playerName = "#FFFFFF"..getPlayerName(player)
	end
	return playerName
end

function RGBToHex(r,g,b)
    local r = r or 0
	local g = g or 0
	local b = b or 0
	return string.format("#%.2X%.2X%.2X",r,g,b)
end

triggerServerEvent("getMaxPlayer",localPlayer,localPlayer)

fileDelete("scoreboard_client.lua")