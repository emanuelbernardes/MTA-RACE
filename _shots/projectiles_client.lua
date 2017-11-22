local g_Me = getLocalPlayer();
local g_Rockets = {};
local resetTimer = false;
local MyKiller = false;
local DrawText = "";
local DrawingTime = 0;
local scrX,scrY = guiGetScreenSize();

addEventHandler("onClientPlayerWasted",root,
function()
	if (source == g_Me) then
		if isTimer(resetTimer) then
			killTimer(resetTimer);
		end
		if isElement(MyKiller) then
			triggerServerEvent("onPlayerRocketWasted", g_Me, MyKiller);
		end
	end
end)

addEventHandler("onClientRender",root,
function()
	for k,v in pairs(g_Rockets) do
		if (isElement(v[1])) then
			local x, y, z = getElementPosition(v[1]);
			setElementPosition(k, x, y, z);
		else
			destroyElement(k);
			g_Rockets[k] = nil;
		end
	end
end)

function resetKiller()
	if MyKiller then
		MyKiller = nil
	end
end

addEventHandler("onClientColShapeHit",root,
function(element)
	local MyVeh = getPedOccupiedVehicle(g_Me);
	if MyVeh and g_Rockets[source] and g_Rockets[source][2] and (element == MyVeh) and (g_Rockets[source][2] ~= MyVeh) then
		if isTimer(resetTimer) then
			killTimer(resetTimer);
		end
		MyKiller = getVehicleOccupant(g_Rockets[source][2]);
		setTimer(resetKiller, 10000, 1);
	end
end)

addEventHandler("onClientProjectileCreation",root,
function(creator)
	local x,y,z = getElementPosition(source);
	local detector = createColSphere(x, y, z, 15);
	g_Rockets[detector] = {source, creator};
end)

sx, sy = guiGetScreenSize()

function displayMessage(message, size)
	removeEventHandler("onClientRender", root, drawMessage)
	addEventHandler("onClientRender", root, drawMessage)
	drawnMessage = message
	drawProgress = 0
	drawnMessageSize = 1
	drawProgressState = 0
end
addEvent("onClientDrawMessage", true)
addEventHandler("onClientDrawMessage", root, displayMessage)

function drawMessage()
  if drawProgressState == 0 then
    drawProgress = drawProgress + 1
    if drawProgress > 200 then
      drawProgressState = 1
      drawProgress = 50
    end
  else
    drawProgress = drawProgress - 2
  end
  if drawProgress < 0 then
    return removeEventHandler("onClientRender", root, drawMessage)
  end
  local easingFunction = "OutElastic"
  if drawProgressState == 1 then
      easingFunction = "OutQuad"
  end
  local progress = getEasingValue(math.min(1, drawProgress / 50), easingFunction)
  dxDrawText(drawnMessage:gsub("#%x%x%x%x%x%x", ""), 1, sy / 3 + 150 + 1, sx + 1, sy + 1, tocolor(0, 0, 0, 255), 2 * drawnMessageSize * progress, "default-bold", "center", "center")
  dxDrawText(drawnMessage, 0, sy / 3 + 150, sx, sy, tocolor(255, 255, 255, 255), 2 * drawnMessageSize * progress, "default-bold", "center", "center", false, false, false, true)
end

local function drawText()
	DrawingTime = DrawingTime + 1;
	dxDrawText(DrawText:gsub("#%x%x%x%x%x%x", ""),-1,scrY-149,scrX-1,-1,tocolor(0,0,0,200),2,"default-bold","center","top",false,false,false,true);
	dxDrawText(DrawText,0,scrY-150,scrX,0,tocolor(255,255,255,255),2,"default-bold","center","top",false,false,false,true);
	if (DrawingTime == 340) then
		removeEventHandler("onClientRender",root,drawText);
		DrawText = "";
		DrawingTime = 0;
	end
end

addEvent("onClientPlayerRocketWasted",true);
addEventHandler("onClientPlayerRocketWasted",root,
function(text)
	DrawText = text;
	if (DrawingTime == 0) then
		addEventHandler("onClientRender",root,drawText);
	else
		DrawingTime = 1;
	end
end)