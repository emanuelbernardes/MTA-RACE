monitor = {
    alpha = 0,
	progress = 0,
	state = false
}
__monitor = {}
dxStatus = {
    {dxGetStatus().VideoCardName,"Name of the graphics card:"},
	{dxGetStatus().VideoCardRAM,"Installed memory in MB:"},
	{dxGetStatus().VideoCardPSVersion,"Maximum pixel shader:"},
	{dxGetStatus().VideoCardNumRenderTargets,"Maximum number of simultaneous RenderTargets:"},
	{dxGetStatus().VideoMemoryFreeForMTA,"Amount of memory in MB available for MTA:"},
	{dxGetStatus().VideoMemoryUsedByFonts,"Amount of memory in MB used by Custom Fonts:"},
	{dxGetStatus().VideoMemoryUsedByTextures,"Amount of memory in MB used by Textures:"},
	{dxGetStatus().VideoMemoryUsedByRenderTargets,"Amount of memory in MB used by RenderTargets:"},
	{dxGetStatus().VideoCardMaxAnisotropy,"Maximum anisotropic filtering:"},
	{dxGetStatus().SettingWindowed,"The windowed setting:"},
	{dxGetStatus().SettingFXQuality,"The FX Quality:"},
	{dxGetStatus().SettingDrawDistance,"The draw distance setting:"},
	{dxGetStatus().SettingVolumetricShadows,"The volumetric shadows setting:"},
	{dxGetStatus().SettingStreamingVideoMemoryForGTA,"The usable graphics memory setting:"},
	{dxGetStatus().SettingAnisotropicFiltering,"The anisotropic filtering setting:"},
	{dxGetStatus().SettingAntiAliasing,"The anti-aliasing setting:"},
	{dxGetStatus().SettingHeatHaze,"The heat haze setting:"},
	{dxGetStatus().SettingGrassEffetc,"The grass effect setting:"},
	{dxGetStatus().Setting32BitColor,"The color depth of the screen:"},
	{dxGetStatus().SettingHUDMatchAspectRatio,"The hud match aspect ratio setting:"},
	{dxGetStatus().SettingAspectRatio,"The aspect ratio setting:"},
	{dxGetStatus().SettingFOV,"The FOV setting:"},
	{dxGetStatus().AllowScreenUpload,"The allows screen uploads setting:"},
	{dxGetStatus().DepthBufferFormat,"The format of the shader readable depth buffer:"},
	{dxGetStatus().TestMode,"The current dx test mode:"}
}
__monitor = {}
function monitorRefresh(info)
    __monitor = info
end
function monitorInterface()
    monitor.progress = monitor.progress + 0.005
    if label.monitor == true then
	    monitor.alpha = interpolateBetween(monitor.alpha,0,0,1,0,0,monitor.progress,"Linear")
		if monitor.alpha == 1 then
		    monitor.progress = 0
		end
	end
	if label.monitor  == false then
	    monitor.alpha = interpolateBetween(monitor.alpha,0,0,0,0,0,monitor.progress,"Linear")
		if monitor.alpha == 0 then
		    monitor.progress = 0
		    removeEventHandler("onClientRender",root,monitorInterface)
		end
	end
	dxDrawImage(_sX,_sY,resY(30),resY(30),"files/img/monitor.png",0,0,0,tocolor(232,232,232,255*monitor.alpha))
	dxText("VGA",_sX+resY(30),_sY+resY(2),sX,sY,230,230,230,255*monitor.alpha,1.0,dxFont(15),"left","top",true,false,false,false)
	if monitor.state then
	    for i=1,#__monitor do
			posY = _sY+resY(31)+(i*resY(17))-resY(17)
			dxText(__monitor[i][1].." "..tostring(__monitor[i][2]),_sX+resX(34),posY,_sX+resX(698),sY,255,255,255,255*monitor.alpha,1.0,dxFont(13),"left","top",true,false,false,false)
	    end
	    createButton(_sX+resX(300),_sY+resY(469),resX(198),resY(27),"Client",207,207,207,monitor.alpha,dxFont(15))
	    createButton(_sX+resX(500),_sY+resY(469),resX(198),resY(27),"Server",0,255,0,monitor.alpha,dxFont(15))
	else
	    for i=1,#dxStatus do
			posY = _sY+resY(31)+(i*resY(17))-resY(17)
			dxText(dxStatus[i][2].." "..tostring(dxStatus[i][1]),_sX+resX(34),posY,_sX+resX(698),sY,255,255,255,255*monitor.alpha,1.0,dxFont(13),"left","top",true,false,false,false)
	    end
	    createButton(_sX+resX(300),_sY+resY(469),resX(198),resY(27),"Client",0,255,0,monitor.alpha,dxFont(15))
	    createButton(_sX+resX(500),_sY+resY(469),resX(198),resY(27),"Server",207,207,207,monitor.alpha,dxFont(15))
	end
end
function buttonMonitorInterface(button,xstate)
	if ( button == "left" and xstate == "down" ) then
		return false
    end
	if isMousePosition(_sX+resX(500),_sY+resY(469),resX(198),resY(27)) then
	    callServerFunction("getInfosMonitor",localPlayer)
		monitor.state = true
	end
	if isMousePosition(_sX+resX(300),_sY+resY(469),resX(198),resY(27)) then
	    monitor.state = false
	    callServerFunction("destroyTimeMonitor",localPlayer)
	end
end