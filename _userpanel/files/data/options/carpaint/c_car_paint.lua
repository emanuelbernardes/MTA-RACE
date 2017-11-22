local isCarpaint = false
local textureVol 
local textureCube
local myShader
local tec

function startCarpaint()
	if getVersion ().sortable < "1.1.0" then
		return
	end
	myShader, tec = dxCreateShader ( "files/data/options/carpaint/car_paint.fx" )
		if not myShader then
	else
		textureVol = dxCreateTexture ( "files/data/options/carpaint/images/smallnoise3d.dds" );
		textureCube = dxCreateTexture ( "files/data/options/carpaint/images/cube_env256.dds" );
		dxSetShaderValue ( myShader, "sRandomTexture", textureVol );
		dxSetShaderValue ( myShader, "sReflectionTexture", textureCube );
		engineApplyShaderToWorldTexture ( myShader, "vehiclegrunge256" )
		engineApplyShaderToWorldTexture ( myShader, "?emap*" )
	end
end

function stopCarpaint()
	if isElement( myShader ) then destroyElement( myShader ) end
	if isElement( textureVol ) then destroyElement( textureVol ) end
	if isElement( textureCube ) then destroyElement( textureCube ) end
end

function toggleCarpainShader()
	if not isCarpaint then
	    isCarpaint = true
		startCarpaint()
	else
	    isCarpaint = false
		stopCarpaint()
	end
end
