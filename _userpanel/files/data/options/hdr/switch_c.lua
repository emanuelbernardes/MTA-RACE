--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
--addEventHandler( "onClientResourceStart", resourceRoot,
--	function()
--		triggerEvent( "switchContrast", resourceRoot, true )
--	end
--)

--------------------------------
-- Command handler
--		Toggle via command
--------------------------------
--addCommandHandler( "contrast",
--	function()
--		triggerEvent( "switchContrast", resourceRoot, not bEffectEnabled )
--	end
--)


--------------------------------
-- Switch effect on or off
--------------------------------

local state = false
function toggleHDRShader()
	if not state then
	    state = true
		enableContrast()
	else
	    state = false
		disableContrast()
	end
end


