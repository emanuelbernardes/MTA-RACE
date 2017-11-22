wheelTXD = false
wheelDFF = false
nowSize = 0
wheelsSize = {}
downloads = {}
function setWheelsSize(info)
    wheelsSize = info
end
function loadWheel(model,id,mod)
	if isElement(wheelTXD) then
		destroyElement(wheelTXD)
	end
	if isElement(wheelDFF) then
		destroyElement(wheelDFF)
	end
    if model == "default" then
	    local vehicle = getPedOccupiedVehicle(localPlayer)
		if vehicle then
			addVehicleUpgrade(vehicle,tonumber(id))
		end
	elseif model == "custom" then
	    local fileName = "files/data/donator/wheels/"..mod..".dff"
	    if not fileExists(fileName) then
		    for i,file in ipairs (wheelsSize) do
			    if file.name == fileName then
					table.insert(downloads,{size=file.size,path=fileName,id=id,mod=mod})
				end
			end
		    downloadFile(fileName)
		else
			wheelTXD = engineLoadTXD("files/data/donator/wheels/J2_wheels.txd")
			downloadFile(fileName)
			engineImportTXD(wheelTXD,tonumber(id))
			wheelDFF = engineLoadDFF(fileName,0)
			engineReplaceModel(wheelDFF,tonumber(id))
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if vehicle then
				addVehicleUpgrade(vehicle,tonumber(id))
			end
		end
	end
end
function DownloadBar()
	if #downloads > 0 then
	    for i,file in ipairs (downloads) do
	    	if fileExists(file.path) then
		    	if not tick then
					tick = getTickCount()
				end
				if getTickCount()- tick >= 200 then
					local _file = fileOpen(file.path)
					currentSize = fileGetSize(_file)
					fileClose(_file)
					size = file.size
					nowSize = currentSize/size
					if nowSize >= 1 then
					    nowSize = 1
						loadWheel("custom",file.id,file.mod)
						table.remove(downloads,i)
					end
					tick = getTickCount()
				end
				if menu.panel == true then
			        dxDrawRectangle(sX/2-resX(150),sY-resY(150),resX(300),resY(30),tocolor(0,0,0,150*menu.alpha))
				    dxDrawRectangle(sX/2-resX(150),sY-resY(150),resX(300)*nowSize,resY(30),tocolor(menu.r,menu.g,menu.b,70*menu.alpha))
	                dxText("Download: "..sizeFormat(currentSize).." of ".. sizeFormat(size),sX/2-resX(150),sY-resY(150),sX/2+resX(150),sY-resY(120),255,255,255,255*menu.alpha,1.0,dxFont(14),"center","center",true,false,false,false)
				    dxDrawRecLine(sX/2-resX(150),sY-resY(150),resX(300),resY(30),tocolor(0,0,0,200*menu.alpha))
				end
			end
		end
	end
end
addEventHandler("onClientRender",root,DownloadBar)
function sizeFormat(size)
	local size = tostring(size)
	if size:len() >= 4 then		
		if size:len() >= 7 then
			if size:len() >= 9 then
				local returning = size:sub(1, size:len()-9)
				if returning:len() <= 1 then
					returning = returning.."."..size:sub(2, size:len()-7)
				end
				return returning.." GB";
			else				
				local returning = size:sub(1, size:len()-6)
				if returning:len() <= 1 then
					returning = returning.."."..size:sub(2, size:len()-4)
				end
				return returning.." MB";
			end
		else		
			local returning = size:sub(1, size:len()-3)
			if returning:len() <= 1 then
				returning = returning.."."..size:sub(2, size:len()-1)
			end
			return returning.." KB";
		end
	else
		return size.." B";
	end
end
function changeWheel()
    if not wheelManager.state then return end
    loadWheel(wheels[wheelManager.id][2],wheels[wheelManager.id][3],wheels[wheelManager.id][4])
end
function onDownloadFinish(file,success)
    if not success then
	    return
	end
end
addEventHandler("onClientFileDownloadComplete",root,onDownloadFinish)