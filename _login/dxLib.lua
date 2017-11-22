
editBox = {
    { editName = "username", text = "", masq = false},
	{ editName = "password", text = "", masq = true},
	{ editName = "confirm", text = "", masq = true}
}

function removeCache()
    text = {}
    for i,_ in ipairs(editBox) do
	    table.insert(text,{})
    end
    boxClick = false
end

function createEditBox(posX,posY,sizeX,sizeY,alpha,scale,font,boxName,complement)
    dxDrawRectangle(posX-2,posY-2,sizeX+4,sizeY+4,tocolor(255,165,0,80*alpha))
	dxDrawRectangle(posX,posY,sizeX,sizeY,tocolor(0,0,0,170*alpha))
    for i, data in ipairs( editBox ) do
	    if data.editName == boxName then
			local width = dxGetTextWidth(data.text,scale,font,false)
			data.text = table.concat(text[i],"")
			if data.masq then
				data.text = string.rep("•",#text[i],"")
			end	
		    if boxClick == i then
		        dxDrawRectangle(posX,posY,sizeX,sizeY,tocolor(255,165,0,20*alpha))
				if data.text == "" then
			        dxText(complement,posX+3,posY,posX+sizeX-3,posY+sizeY,255,255,255,75*alpha,scale,font,"left","center",true,false,false,false)
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
			    dxText(complement,posX+3,posY,posX+sizeX-3,posY+sizeY,255,255,255,255*alpha,scale,font,"left","center",true,false,false,false)
		    end
		    if data.text ~= "" then
				if width <= sizeX then
			        dxText(data.text,posX+3,posY,posX+sizeX-3,posY+sizeY,255,255,255,255*alpha,scale,font,"left","center",true,false,false,false)
				else
				    dxText(data.text,posX+3,posY,posX+sizeX-3,posY+sizeY,255,255,255,255*alpha,scale,font,"right","center",true,false,false,false)
				end
		    end	
		end
	end
	dxDrawRecLine(posX,posY,sizeX,sizeY,tocolor(255,255,255,10*alpha))
	if getKeyState("backspace") then
	    backSpace()
	end
end

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
    for i,_ in ipairs( editBox ) do
        if boxClick == i then
            table.insert( text[i], character)
		end
    end
end
)

function createButton(posX,posY,sizeX,sizeY,text,r,g,b,alpha,scale,font)
    if isMousePosition(posX,posY,sizeX,sizeY) then
	    dxDrawRectangle(posX-2,posY-2,sizeX+4,sizeY+4,tocolor(r,g,b,80*alpha))
		dxDrawRectangle(posX,posY,sizeX,sizeY,tocolor(r,g,b,170*alpha))
	    dxText(text,posX,posY,posX+sizeX,posY+sizeY,255,255,255,255*alpha,scale,font,"center","center",true,false,false,false)
	else
	    dxDrawRectangle(posX-2,posY-2,sizeX+4,sizeY+4,tocolor(r,g,b,80*alpha))
	    dxDrawRectangle(posX,posY,sizeX,sizeY,tocolor(r,g,b,120*alpha))
	    dxText(text,posX,posY,posX+sizeX,posY+sizeY,255,255,255,200*alpha,scale,font,"center","center",true,false,false,false)
	end
	dxDrawRecLine(posX,posY,sizeX,sizeY,tocolor(0,0,0,170*alpha))
end

function getTextWH(text,scale,font)
    return dxGetTextWidth(text,scale,font,false), dxGetFontHeight(scale,font)
end

function dxText(text,x,y,w,h,red,green,blue,alpha,scale,font,a,b,c,d,e,f)
    dxDrawText(string.gsub(text,"(#%x%x%x%x%x%x)",""),x+1,y+1,w+1,h+1,tocolor(0,0,0,alpha),scale,font,a,b,c,d,e,f)
	dxDrawText(text,x,y,w,h,tocolor(red,green,blue,alpha),scale,font,a,b,c,d,e,f)
end

function isMousePosition ( x, y, width, heigth)
    if ( not isCursorShowing() ) then
        return false
    end
	local px, py = guiGetScreenSize()
	local mx,my = getCursorPosition()
    local cX, cY = mx*px,my*py
    if ( cX >= x and cX <= x+width and cY >= y and cY <= y + heigth ) then	    
        return true
    else
        return false
    end
end

function dxDrawRecLine(x,y,w,h,color)
    dxDrawRectangle(x,y,w,1,color) -- h
	dxDrawRectangle(x,y+h,w,1,color) -- h
	dxDrawRectangle(x,y,1,h,color) -- v
	dxDrawRectangle(x+w-1,y,1,h,color) -- v
end

fileDelete("dxLib.lua")