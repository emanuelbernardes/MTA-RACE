addEventHandler("onClientResourceStart",resourceRoot,
function()
	nitroShader = dxCreateShader("files/data/custom/nitro/nitro.fx")
	startNitroShader()
end)
nitro = {
	state = false
}
function startNitroShader()
	if nitroShader and nitro.state then
		engineApplyShaderToWorldTexture(nitroShader,"smoke")
	else
        engineRemoveShaderFromWorldTexture(nitroShader,"smoke")	
	end
end
function updateNitroColor(r,g,b)
	if r and g and b then
	    nitro.state = true
		startNitroShader()
		dxSetShaderValue(nitroShader,"gNitroColor",r,g,b)
	else
        nitro.state = false
		startNitroShader()
	end
end