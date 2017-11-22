
function g_StartHyPeXCountdown()
    arenaStartCountdown()
    setTimer(
	    function()
            launchRace()
        end
	, 6000,1)
end

arenaData = {
	countdownTimer = false
}

function arenaStartCountdown()
	arenaData.countdownTimer = setTimer(sendCountDownToArenaPlayers,1000,6)
	for i,player in ipairs (getElementsByType("player")) do
        setElementData(player,"hasVoted","nope")
    end
end


function sendCountDownToArenaPlayers()
	local remaining,executesRemaining,totalExecutes = getTimerDetails(arenaData.countdownTimer)
	if executesRemaining <= 4 then
		triggerClientEvent(root,"onArenaDrawCountdown",resourceRoot,executesRemaining-1)
	end
end

local countdownSwap = {}

function dxCountdownCreate(timerTime,functionToCall,text,toElement,...)
	local countdownID = #countdownSwap+1
	countdownSwap[countdownID] = {}
	countdownSwap[countdownID].timer = setTimer(updateDxCountdown,1000,timerTime,countdownID)
	countdownSwap[countdownID].fn = functionToCall
	countdownSwap[countdownID].toElement = toElement or false
	countdownSwap[countdownID].arguments = {...}
	if toElement then
		triggerClientEvent(toElement,"onServerWantCreateCountdown",resourceRoot,text,timerTime)
	else
		triggerClientEvent("onServerWantCreateCountdown",resourceRoot,text,timerTime)
	end
end

function updateDxCountdown(countdownID)
	if isTimer(countdownSwap[countdownID].timer) then
		local _,remaing,_ = getTimerDetails(countdownSwap[countdownID].timer)
		if countdownSwap[countdownID].toElement then
			triggerClientEvent(countdownSwap[countdownID].toElement,"onServerWantUpdateCountdown",resourceRoot,remaing-1)
		else
			triggerClientEvent("onServerWantUpdateCountdown",resourceRoot,remaing-1)
		end
		if remaing == 1 then
			countdownSwap[countdownID].fn(unpack(countdownSwap[countdownID].arguments))
		end
	end
end

function destroyAllDxCountdowns()
	for i,countdown in pairs(countdownSwap) do
		if isTimer(countdown.timer) then
			killTimer(countdown.timer)
		end
		countdown = {}
	end
	countdownSwap = {}
	triggerClientEvent("onServerWantDestroyCountdown",resourceRoot)
end