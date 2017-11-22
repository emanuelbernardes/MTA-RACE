local state = false
txd_1 = false
txd_2 = false
txd_3 = false
function loadRoadMod()
    state = not state
    if state then
	    state = true
        txd_1 = engineLoadTXD("files/data/options/road/8558.txd",8557)
        engineImportTXD(txd_1,8557)
        txd_2 = engineLoadTXD("files/data/options/road/3458.txd",3458)
        engineImportTXD(txd_2,3458)
		txd_3 = txd_1
		engineImportTXD(txd_3,8558)
    else
	    state = false
		if isElement(txd_1) then
			destroyElement(txd_1)
		end
		if isElement(txd_2) then
			destroyElement(txd_2)
		end
		if isElement(txd_3) then
			destroyElement(txd_3)
		end
    end
end	