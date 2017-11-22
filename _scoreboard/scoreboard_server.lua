
function onCountryStart()
	for i,thePlayer in pairs(getElementsByType("player")) do
		getPlayerCountry(thePlayer)
	end
end
addEventHandler("onResourceStart",resourceRoot,onCountryStart)

function getPlayerCountry(thePlayer)
	if thePlayer then
		local playerIP = getPlayerIP(thePlayer)
		if playerIP then
			fetchRemote("http://www.geoplugin.net/json.gp?ip="..playerIP, setPlayerCountry, "", false, thePlayer )
		end
	end
end

function setPlayerCountry(countryTable,errorCode,thePlayer)
	if thePlayer and countryTable and errorCode == 0 then
		local countryTable = fromJSON("["..countryTable.."]")
		if countryTable then
			setElementData(thePlayer,"country",countryTable.geoplugin_countryCode)
			setElementData(thePlayer,"countryName",countryTable.geoplugin_countryName)
		end
	end	
end

function onPlayerJoinGetCountry()
	getPlayerCountry(source)
end
onPlayerJoinGetCountry()
addEventHandler("onPlayerJoin",root,onPlayerJoinGetCountry)

local ids = {}

function assignID()
	for i=1,getMaxPlayers() do
		if not ids[i] then
			ids[i] = source
			setElementData(source,"id",i)
			break
		end
	end
end
addEventHandler("onPlayerJoin",root,assignID)

function startup()
    ids = {}
	for k, v in ipairs(getElementsByType("player")) do
		local id = setElementData(v,"id",k)
		ids[k] = v 
	end
end
addEventHandler("onResourceStart",resourceRoot,startup)

function freeID()
	local id = getElementData(source,"id")
	if not id then return end
	ids[id] = nil
end
addEventHandler("onPlayerQuit",root,freeID)

addEvent("getMaxPlayer",true)
addEventHandler("getMaxPlayer",root,
function (player)
    max = getMaxPlayers()
    triggerClientEvent(player,"getMaxPlayers",root,max)
end
)