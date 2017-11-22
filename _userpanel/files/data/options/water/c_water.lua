local enabled = false
function checkWaterColor()
	if myShader then
		local r,g,b,a = getWaterColor()
		dxSetShaderValue ( myShader, "sWaterColor", r/255, g/255, b/255, a/255 );
	end
end
addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		if getVersion ().sortable < "1.1.0" then
			return
		end
		myShader, tec = dxCreateShader ( "files/data/options/water/water.fx" )
		if not myShader then
			outputChatBox( "Could not create shader. Please use debugscript 3" )
		else
			local textureVol = dxCreateTexture ( "files/data/options/water/images/smallnoise3d.dds" );
			local textureCube = dxCreateTexture ( "files/data/options/water/images/cube_env256.dds" );
			dxSetShaderValue ( myShader, "microflakeNMapVol_Tex", textureVol );
			dxSetShaderValue ( myShader, "showroomMapCube_Tex", textureCube );
		end
	end
)

function toggleWaterShader ( )
	if not enabled then
	    enabled = true
		waterTimer = setTimer ( checkWaterColor, 1000, 0 )
		engineApplyShaderToWorldTexture ( myShader, "waterclear256" )
	else
	    enabled = false
		killTimer ( waterTimer )
		engineRemoveShaderFromWorldTexture ( myShader, "waterclear256" )
	end
end