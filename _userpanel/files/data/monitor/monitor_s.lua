monTimers = {}
function getInfosMonitor(player)
	local rows = {}
	local info = {}
	_,rows = getPerformanceStats("Server info")
	for i=1,5 do
		table.insert(info,{rows[i][1]..":",rows[i][2]})
	end
	table.insert(info,{rows[1][3],rows[1][4]})
	table.insert(info,{rows[2][3],rows[2][4]})
	table.insert(info,{rows[8][3],rows[8][4]})
	table.insert(info,{rows[1][5],rows[1][6]})
	callClientFunction(player,"monitorRefresh",info)
	monTimers[player] = setTimer(getInfosMonitor,1000,1,player)
end
function destroyTimeMonitor(player)
    if isTimer(monTimers[player]) then
		killTimer(monTimers[player])
		monTimers[player] = nil
	end
end