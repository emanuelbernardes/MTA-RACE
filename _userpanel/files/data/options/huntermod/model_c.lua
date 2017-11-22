local state = false
hunterTXD = false
hunterDFF = false
function hunterModel()
	if not state then
	    state = true
		hunterTXD = engineLoadTXD ( "files/data/options/huntermod/hunter.txd", 425 )
		engineImportTXD ( hunterTXD, 425 )
		hunterDFF = engineLoadDFF ( "files/data/options/huntermod/hunter.dff", 425 )
		engineReplaceModel ( hunterDFF, 425 )
	else
	    state = false
		if isElement(hunterTXD) then
			destroyElement(hunterTXD)
		end
		if isElement(hunterDFF) then
			destroyElement(hunterDFF)
		end
	end
end