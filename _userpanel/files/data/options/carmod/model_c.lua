local state = false
function infernusModel()
	if not state then
	    state = true
		infernusTexture = engineLoadTXD ( "files/data/options/carmod/infernus.txd" )
		engineImportTXD ( infernusTexture, 411 )
		infernusTexture = engineLoadDFF ( "files/data/options/carmod/infernus.dff", 411 )
		engineReplaceModel ( infernusTexture, 411 )
	else
	    state = false
		engineRestoreModel(411)
	end
	changeWheel()
end