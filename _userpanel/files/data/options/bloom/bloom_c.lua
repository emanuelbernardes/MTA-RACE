local isBloom = false
local bAllValid
local scx, scy = guiGetScreenSize()
local mx, my
-----------------------------------------------------------------------------------
-- Le settings
-----------------------------------------------------------------------------------
local Settings = {}
Settings.var = {}
Settings.var.cutoff = 0.08
Settings.var.power = 1.88
Settings.var.bloom = 2.0
Settings.var.blendR = 204
Settings.var.blendG = 153
Settings.var.blendB = 130
Settings.var.blendA = 140
----------------------------------------------------------------
-- onClientResourceStart
----------------------------------------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		if getVersion ().sortable < "1.1.0" then
			return
		end
        myScreenSourceBloom = dxCreateScreenSource( scx/2, scy/2 )
        blurHShaderBloom,tecName = dxCreateShader( "files/data/options/bloom//blurH.fx" )
        blurVShaderBloom,tecName = dxCreateShader( "files/data/options/bloom//blurV.fx" )
        brightPassShaderBloom,tecName = dxCreateShader( "files/data/options/bloom//brightPass.fx" )
        addBlendShaderBloom,tecName = dxCreateShader( "files/data/options/bloom//addBlend.fx" )
		bAllValid = myScreenSourceBloom and blurHShaderBloom and blurVShaderBloom and brightPassShaderBloom and addBlendShaderBloom
		if not bAllValid then
		end
	end
)
-----------------------------------------------------------------------------------
-- onClientHUDRender
-----------------------------------------------------------------------------------
function doBloom()
	if not Settings.var then
		return
	end
    if bAllValid then
		RTPoolBloom.frameStart()
		dxUpdateScreenSource( myScreenSourceBloom )
		local current = myScreenSourceBloom
		current = applyBrightPassBloom( current, Settings.var.cutoff, Settings.var.power )
		current = applyDownsampleBloom( current )
		current = applyDownsampleBloom( current )
		current = applyGBlurHBloomForBloom( current, Settings.var.bloom )
		current = applyGBlurVBloomForBloom( current, Settings.var.bloom )
		dxSetRenderTarget()
		if current then
			dxSetShaderValue( addBlendShaderBloom, "TEX0", current )
			local col = tocolor(Settings.var.blendR, Settings.var.blendG, Settings.var.blendB, Settings.var.blendA)
			dxDrawImage( 0, 0, scx, scy, addBlendShaderBloom, 0,0,0, col )
		end
    end
end
function stopBloom()
	removeEventHandler( "onClientHUDRender", root, doBloom )
end
function startBloom()
	removeEventHandler( "onClientHUDRender", root, doBloom )
	addEventHandler( "onClientHUDRender", root, doBloom )
end
-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------
function applyDownsampleBloom( Src, amount )
	if not Src then return nil end
	amount = amount or 2
	local mx,my = dxGetMaterialSize( Src )
	mx = mx / amount
	my = my / amount
	local newRT = RTPoolBloom.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT )
	dxDrawImage( 0, 0, mx, my, Src )
	return newRT
end
function applyGBlurHBloomForBloom( Src, bloom )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPoolBloom.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurHShaderBloom, "TEX0", Src )
	dxSetShaderValue( blurHShaderBloom, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurHShaderBloom, "BLOOM", bloom )
	dxDrawImage( 0, 0, mx, my, blurHShaderBloom )
	return newRT
end
function applyGBlurVBloomForBloom( Src, bloom )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPoolBloom.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurVShaderBloom, "TEX0", Src )
	dxSetShaderValue( blurVShaderBloom, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurVShaderBloom, "BLOOM", bloom )
	dxDrawImage( 0, 0, mx,my, blurVShaderBloom )
	return newRT
end
function applyBrightPassBloom( Src, cutoff, power )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPoolBloom.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( brightPassShaderBloom, "TEX0", Src )
	dxSetShaderValue( brightPassShaderBloom, "CUTOFF", cutoff )
	dxSetShaderValue( brightPassShaderBloom, "POWER", power )
	dxDrawImage( 0, 0, mx,my, brightPassShaderBloom )
	return newRT
end
-----------------------------------------------------------------------------------
-- Pool of render targets
-----------------------------------------------------------------------------------
RTPoolBloom = {}
RTPoolBloom.list = {}
function RTPoolBloom.frameStart()
	for rt,info in pairs(RTPoolBloom.list) do
		info.bInUse = false
	end
end
function RTPoolBloom.GetUnused( mx, my )
	for rt,info in pairs(RTPoolBloom.list) do
		if not info.bInUse and info.mx == mx and info.my == my then
			info.bInUse = true
			return rt
		end
	end
	local rt = dxCreateRenderTarget( mx, my )
	if rt then
		RTPoolBloom.list[rt] = { bInUse = true, mx = mx, my = my }
	end
	return rt
end
local state = false
function toggleBloomShader()
	if not state then
	    state = true
		startBloom()
	else
	    state = false
		stopBloom()
	end
end