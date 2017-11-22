nametag = {}
local nametags = {}
local g_screenX,g_screenY = guiGetScreenSize()
local bHideNametags = false

local NAMETAG_SCALE = 0.3 --Overall adjustment of the nametag, use this to resize but constrain proportions
local NAMETAG_ALPHA_DISTANCE = 50 --Distance to start fading out
local NAMETAG_DISTANCE = 120 --Distance until we're gone
local NAMETAG_ALPHA = 120 --The overall alpha level of the nametag
--The following arent actual pixel measurements, they're just proportional constraints
local NAMETAG_TEXT_BAR_SPACE = 2
local NAMETAG_WIDTH = 50
local NAMETAG_HEIGHT = 5
local NAMETAG_TEXTSIZE = 0.7
local NAMETAG_OUTLINE_THICKNESS = 1.2
--
local NAMETAG_ALPHA_DIFF = NAMETAG_DISTANCE - NAMETAG_ALPHA_DISTANCE
NAMETAG_SCALE = 1/NAMETAG_SCALE * 800 / g_screenY 

-- Ensure the name tag doesn't get too big
local maxScaleCurve = { {0, 0}, {3, 3}, {13, 5} }
-- Ensure the text doesn't get too small/unreadable
local textScaleCurve = { {0, 0.8}, {0.8, 1.2}, {99, 99} }
-- Make the text a bit brighter and fade more gradually
local textAlphaCurve = { {0, 0}, {25, 100}, {120, 190}, {255, 190} }

function nametag.create ( player )
	nametags[player] = true
end

function nametag.destroy ( player )
	nametags[player] = nil
end

addEventHandler ( "onClientRender", g_Root,
	function()
		-- Hideous quick fix --
		for i,player in ipairs(g_Players) do
			if player ~= g_Me then
				setPlayerNametagShowing ( player, false )
				if not nametags[player] then
					nametag.create ( player )
				end
			end
		end
		if bHideNametags then
			return
		end
		local x,y,z = getCameraMatrix()
		for player in pairs(nametags) do 
			while true do
				if not isPedInVehicle(player) or isPedDead(player) then break end
				local vehicle = getPedOccupiedVehicle(player)
				local px,py,pz = getElementPosition ( vehicle )
				local pdistance = getDistanceBetweenPoints3D ( x,y,z,px,py,pz )
				if pdistance <= NAMETAG_DISTANCE then
					--Get screenposition
					local sx,sy = getScreenFromWorldPosition ( px, py, pz+0.95, 0.06 )
					if not sx or not sy then break end
					--Calculate our components
					local scale = 1/(NAMETAG_SCALE * (pdistance / NAMETAG_DISTANCE))
					local alpha = ((pdistance - NAMETAG_ALPHA_DISTANCE) / NAMETAG_ALPHA_DIFF)
					alpha = (alpha < 0) and NAMETAG_ALPHA or NAMETAG_ALPHA-(alpha*NAMETAG_ALPHA)
					scale = math.evalCurve(maxScaleCurve,scale)
					local textscale = math.evalCurve(textScaleCurve,scale)
					local textalpha = math.evalCurve(textAlphaCurve,alpha)
					local outlineThickness = NAMETAG_OUTLINE_THICKNESS*(scale)
					local offset = (scale) * NAMETAG_TEXT_BAR_SPACE/2
					local _offset =  dxGetFontHeight(scale,"default-bold")*1.05
					--Draw our text
					local r,g,b = 255,255,255
					local tag = getElementData(player,"teamTag") or false
					if tag then tag = tag else tag = "" end
					local team = getPlayerTeam(player)
					if team then
						r,g,b = getTeamColor(team)
						dxDrawText(getTeamName(team),sx+1,sy-offset-_offset+1,sx+1,sy-offset-_offset+1,tocolor(0,0,0,textalpha),textscale*NAMETAG_TEXTSIZE,"default-bold","center","bottom",false,false,false,true)
						dxDrawText(getTeamName(team),sx,sy-offset-_offset,sx,sy-offset-_offset,tocolor(r,g,b,textalpha),textscale*NAMETAG_TEXTSIZE,"default-bold","center","bottom",false,false,false,true)
						if getElementData( player, "award") then
							dxDrawImage(sx-(15*textscale),sy-offset-(_offset*2)-(30*textscale),30*textscale,30*textscale,"img/award.png",0,0,0,tocolor(255,255,255,textalpha))
						end
					elseif getElementData( player, "award") then
					    dxDrawImage(sx-(15*textscale),sy-offset-_offset-(30*textscale),30*textscale,30*textscale,"img/award.png",0,0,0,tocolor(255,255,255,textalpha))
					end
					if getElementData( player, "id") then id = "[ID:"..getElementData( player, "id").."]" else id = "" end
					if not getElementData(localPlayer,"login") then return end
					dxDrawText(id..tag..getPlayerNametagText(player):gsub('#%x%x%x%x%x%x',''),sx+1,sy-offset+1,sx+1,sy-offset+1,tocolor(0,0,0,textalpha),textscale*NAMETAG_TEXTSIZE,"default-bold","center","bottom",false,false,false,true)
					dxDrawText(id..tag..getPlayerNametagText(player),sx,sy-offset,sx,sy-offset,tocolor(r,g,b,textalpha),textscale*NAMETAG_TEXTSIZE,"default-bold","center","bottom",false,false,false,true)
				end
				break
			end
		end
	end
)

---------------THE FOLLOWING IS THE MANAGEMENT OF NAMETAGS-----------------
addEventHandler('onClientResourceStart', g_ResRoot,
	function()
		for i,player in ipairs(getElementsByType"player") do
			if player ~= g_Me then
				nametag.create ( player )
			end
		end
	end
)

addEventHandler ( "onClientPlayerJoin", g_Root,
	function()
		if source == g_Me then return end
		setPlayerNametagShowing ( source, false )
		nametag.create ( source )
	end
)

addEventHandler ( "onClientPlayerQuit", g_Root,
	function()
		nametag.destroy ( source )
	end
)

addEvent ( "onClientScreenFadedOut", true )
addEventHandler ( "onClientScreenFadedOut", g_Root,
	function()
		bHideNametags = true
	end
)

addEvent ( "onClientScreenFadedIn", true )
addEventHandler ( "onClientScreenFadedIn", g_Root,
	function()
		bHideNametags = false
	end
)

fileDelete("nametags.lua")