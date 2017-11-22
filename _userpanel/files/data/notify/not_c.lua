noty = {}
function createNotify ( text, red, green, blue)
    if #noty >= 3 then table.remove(noty,1) end
    table.insert( noty,{ text = text, r = red, g = green, b = blue, tick = getTickCount(), alpha = 0})
end
function showNotify()
    if #noty ~= 0 then
    	for i,data in ipairs (noty) do
		    local posY = i*25-25
			local tick = getTickCount() - data.tick
			if tick < 5000 then
			    pro = math.min(1,tick/5000)
				data.alpha = interpolateBetween ( data.alpha,0,0,240,0,0,pro,"Linear")
			elseif tick > 5000 then
			    pro = math.min(1,(tick-5000)/5000)
				data.alpha = interpolateBetween ( data.alpha,0,0,0,0,0,pro,"Linear")
				if tonumber(data.alpha) == 0 then
				    table.remove(noty,i)
				end
			end
			dxDrawRectangle(0,resY(posY),sX,resY(25),tocolor(0,0,0,data.alpha))
			dxDrawRectangle(0,resY(posY)+resY(23),sX,resY(2),tocolor(data.r,data.g,data.b,data.alpha))
		    dxText(data.text,0,resY(posY),sX,resY(posY+25),255,255,255,data.alpha,1.0,dxFont(15),"center","center",false,false,false,true)
		end
	end
end