timerAgain = {}
mapQueue = {}
_mapState = {
    state = true,
	count = 0
}
function getServerMaps(player)
    if player then
	    local info = {}
		for i,resource in pairs(getResources()) do
			if getResourceInfo(resource,"type") == "map" and getResourceInfo(resource,"gamemodes") == "race" then
				local mapName = getResourceInfo(resource,"name") or getResourceName(resource)
				local resName = getResourceName(resource)
				table.insert(info,{mapName,resName})
			end
	    end
		table.sort(info,sortCompareFunction)
        callClientFunction(player,"updateMapList",info)
	end
end
function refreshAllPlayersMaps(player)
    if not isPlayerLogged(player) then
	    return
	end	
    if not isPlayerOnGroup(player) then
	    return
	end
	for i,players in ipairs(getElementsByType("player")) do
	    getServerMaps(players)
	end
	callClientFunction(player,"createNotify","Lista de mapas atualizada para todos jogadores.",144,190,255)
end
addCommandHandler("mapsrefresh",refreshAllPlayersMaps)	
function buyMap(player,resourceName)
    local map = getResourceFromName(resourceName)
	local mapName = getResourceInfo(map,"name") or resourceName
	if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not player or not resourceName then
		return callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
	local mapBlock = getResourceName(exports.mapmanager:getRunningGamemodeMap())
	if mapBlock == resourceName then
	    return callClientFunction(player,"createNotify","Este mapa esta bloqueado para compra no momento.",255,0,0)
	end
	if #mapQueue ~= 0 then
		for i, map in ipairs (mapQueue) do
	    	if mapName == map[1] then
				return callClientFunction(player,"createNotify","Este mapa esta na lista de espera.",255,0,0)
			end
			if player == map[3] then
				return callClientFunction(player,"createNotify","Voce atingiu o limite de compra de mapas.",255,0,0)
			end
		end
	end
	if timerAgain[mapName] then
	    local remaining = getTimerDetails(timerAgain[mapName])
		return callClientFunction(player,"createNotify","Este mapa ja foi comprado, espere "..math.floor(remaining/60000).." minutos para comprar novamente.",255,0,0)
	end
	if getDonatorPlayer(player) or onTakeMoney(player,infos.mapPrice) then
		timerAgain[mapName] = setTimer(timerAgainReset,1000*60*infos.timerAgain,1,mapName)
		table.insert(mapQueue,{mapName,resourceName,player})
		if not setNext then
			if #mapQueue == 1 then
				triggerEvent("onUserpanelWantNextmap",root,mapQueue[1])
			end
		end
		_outputChatBox("_s[_wMapShop_s]_w "..getPlayerName(player).." _wcomprou o mapa _v"..mapName,root,255,255,255,true)
		callClientFunction(root,"createNotify",getPlayerName(player).." #FFFFFFcomprou o mapa "..mapName,0,236,0)
	else
		callClientFunction(player,"createNotify","Voce nao tem dinheiro suficiente.",255,0,0)
	end
end
function buyRedo(player)
	if not isPlayerLogged(player) then
		return callClientFunction(player,"createNotify","Voce nao esta logado.",255,0,0)
	end
	if not player then
		return callClientFunction(player,"createNotify","Argumentos invalidos.",255,0,0)
	end
	local arg,_arg = call(getResourceFromName("race"),"getMapInfoForRedo",true)
	if not arg then
	    return callClientFunction(player,"createNotify","Desculpa, este mapa ja foi reiniciado.",255,0,0)
	end
	if _arg then
	    return callClientFunction(player,"createNotify","Este mapa ja sera reiniciado automaticamente.",255,0,0)
	end
	if getDonatorPlayer(player) or onTakeMoney(player,infos.mapPrice*2) then
	    call(getResourceFromName("race"),"getMapInfoForRedo",false)
		nextByRedo = true
		local mapName = getMapName(exports.mapmanager:getRunningGamemodeMap())
		_outputChatBox("_s[_wMapShop_s]_w "..getPlayerName(player).." _wcomprou redo no mapa _v"..mapName,root,255,255,255,true)
		callClientFunction(root,"createNotify",getPlayerName(player).." #FFFFFFcomprou redo no mapa "..mapName,0,236,0)
	else
		callClientFunction(player,"createNotify","Voce nao tem dinheiro.",255,0,0)
	end
end
addCommandHandler('br',
    function(player,cmd)
	    buyRedo(player)
	end
)
function timerAgainReset(mapName)
	if timerAgain[mapName] then 
		timerAgain[mapName] = nil
		_outputChatBox("_s[_wMapShop_s]_v "..mapName.." _wja pode ser comprado novamente.",root,255,255,255,true)
	end
end
setNext = false
nextByRedo = false
addEvent("nextMapByRace",true)
addEventHandler("nextMapByRace",root,
function(bool)
    setNext = bool
end
)
addEvent("redoByRace",true)
addEventHandler("redoByRace",root,
function(bool)
	nextByRedo = bool
end
)
function resetMapSetStatus()
    if nextByRedo then
		nextByRedo = false
        if not setNext then
		    if #mapQueue ~= 0 then
			    triggerEvent("onUserpanelWantNextmap",root,mapQueue[1])
		    end
		end
	else
	    if not setNext then
		    if #mapQueue == 1 then
			    table.remove(mapQueue,1)
		    elseif #mapQueue > 1 then
			    triggerEvent("onUserpanelWantNextmap",root,mapQueue[2])
			    table.remove(mapQueue,1)
		    end
		else
            setNext = false
			if #mapQueue ~= 0 then
			    triggerEvent("onUserpanelWantNextmap",root,mapQueue[1])
		    end
		end
	end
end
addEvent("onMapStarting",true)
addEventHandler("onMapStarting",root,resetMapSetStatus)
function sortCompareFunction(s1,s2)
    if type(s1) == "table" and type(s2) == "table" then
        s1, s2 = s1[1], s2[1]
    end
    s1, s2 = s1:lower(), s2:lower()
    if s1 == s2 then
        return false
    end
    local byte1, byte2 = string.byte(s1:sub(1,1)), string.byte(s2:sub(1,1))
    if not byte1 then
        return true
    elseif not byte2 then
        return false
    elseif byte1 < byte2 then
        return true
    elseif byte1 == byte2 then
        return sortCompareFunction(s1:sub(2), s2:sub(2))
    else
        return false
    end
end
function findMap(query)
    local maps = findMaps(query)
    if #maps == 1 then
        return maps[1],""
	else
	    if #maps == 0 then
		    return nil,"Mapa nao encontrado."
		else
		    return nil,#maps.." mapas encontrados, Compra cancelada."
		end
    end
end
function findMaps(query)
    local results = {}
    query = string.gsub(query, "([%*%+%?%.%(%)%[%]%{%}%\%/%|%^%$%-])","%%%1")
    for i,resource in ipairs(call(getResourceFromName("mapmanager"),"getMapsCompatibleWithGamemode",getResourceFromName("race"))) do
        local resName = getResourceName( resource )
        local infoName = getMapName( resource  )
        if query == resName or query == infoName then
		    table.insert( results, resource )
            break
        end
        if string.find( infoName:lower(), query:lower() ) then
            table.insert( results, resource )
        end
    end
    return results
end
function getMapName(map)
    return getResourceInfo(map,"name") or getResourceName(map) or "unknown"
end
addCommandHandler('bm',
    function(player,command,...)
        local query = #{...}>0 and table.concat({...},' ') or nil
		if query == "" or query == nil then
		    return _outputChatBox("_s[_rERROR_s] _wuse: '/bm [NomeDoMapa]'",player,255,255,255,true)
		end
        local map, errormsg = findMap( query )
        if not map then
            return _outputChatBox("_s[_rERROR_s] _w"..errormsg,player,255,255,255,true)
        end
		buyMap(player,getResourceName(map))
    end
)