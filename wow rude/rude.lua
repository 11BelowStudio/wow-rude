-- YEAH IT'S BASICALLY RIPPED FROM HELPFUL INTIMIDATED OUTLINES

-- an object I guess
WowRude = {}

-- the dictionary(?) of intimidated cops
WowRude.TrackedUnits = {}

-- table for the responses we might use when someone kills our intimidated cop
WowRude.responses = {
	"rude",
	"smh my head",
	"you serious?",
	"kids these days...",
	"what the fuck",
	"bruh",
	"excuse me!?"
}
-- the size of the above table
WowRude.responseCount = 7

-- the cursor for the next response we'll be using from that table
WowRude.responseCursor = 1

-- and the code responsible for complaining
WowRude.complain = function()
	
	local text = WowRude.responses[WowRude.responseCursor]
	
	if WowRude.responseCursor == WowRude.responseCount then
		WowRude.responseCursor = 1
	else
		WowRude.responseCursor = WowRude.responseCursor + 1
	end
	
	if managers.chat then 
		if managers.network:session() and #managers.network:session()._peers_all <= 1 then 
			managers.chat:_receive_message(1,"basic human decency",text,Color.red)
		else
			managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or ">:(", ">:( " .. text)
		end
		return true
	else
		log("wow rude " .. text)
	end
	
end