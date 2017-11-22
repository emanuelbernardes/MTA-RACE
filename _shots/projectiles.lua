
addEvent("onPlayerRocketWasted",true)
addEventHandler("onPlayerRocketWasted",root,
function(killer)
	local MyName = getPlayerName(source);
	local KillerName = getPlayerName(killer);
	if (killer ~= source) then
		-- exports["ht-userpanel"]:givePlayerPoints(killer, reward.points);
		-- givePlayerMoney(killer, reward.money);
		triggerClientEvent(source, "onClientDrawMessage", root,"#ffffffVocê foi #FF0000morto #ffffffpor #ffffff"..KillerName)
		triggerClientEvent(killer, "onClientDrawMessage", root,"#ffffffVocê #00FF00matou #ffffff"..MyName)
		-- outputChatBox("#4800FF[Shooter] #FFFFFFVocê matou "..MyName.."#FFFFFF! Ganhou #008500$"..reward.money.." #FFFFFFe #4800FF"..reward.points.." #FFFFFFpontos.", killer, 255, 255, 255, true)
		local vehicle = getPedOccupiedVehicle(killer)
		if (vehicle) then
			--local speedX, speedY, speedZ = getElementVelocity(vehicle)
			--setElementVelocity(vehicle, speedX, speedY, speedZ + 0.15)
			fixVehicle(vehicle)
		end
	end
end)