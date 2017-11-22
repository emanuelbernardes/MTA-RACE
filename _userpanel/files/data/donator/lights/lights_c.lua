local shaders = {}
addEventHandler("onClientResourceStart",resourceRoot,
	function ()
		setElementData(localPlayer,"vehiclelight",false)
	end
)
addEventHandler("onClientElementStreamIn",root,
	function ()
		if getElementType(source) == "vehicle" then
			loadVehicleLights(source)
		end
	end
)
addEventHandler("onClientVehicleEnter",root,
	function ()
		loadVehicleLights(source)
	end
)		
function loadVehicleLights(vehicle)
	local controller = getVehicleController(vehicle)
	if not controller then return end
	local image = getElementData(controller,"vehiclelight")
	if not image then return end
	if not shaders[image] then
		local texture = dxCreateTexture("files/data/donator/lights/"..image..".png","dxt3")
		local shader = dxCreateShader("files/data/donator/lights/lights.fx")
		dxSetShaderValue(shader,"gTexture",texture)
		shaders[image] = shader
	end
	engineApplyShaderToWorldTexture(shaders[image],"vehiclelights128",vehicle)
	engineApplyShaderToWorldTexture(shaders[image],"vehiclelightson128",vehicle)
end
function unloadVehicleLights(controller)
	setElementData(controller,"vehiclelight",false)
end