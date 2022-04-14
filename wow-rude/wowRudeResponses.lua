WowRudeResponses = WowRudeResponses or {

	_responses_named = {
		"that's rude, %s",
		"smh my head, %s",
		"%s, you serious?",
		"what the fuck %s",
		"excuse me, %s!?",
		"%s wtf",
		"now that's just uncalled for, %s",
		"stop it, %s",
		"%s, it's time to stop.",
		"%s what the fuck",
		"what is wrong with you, %s?",
		"for fucks sake, %s",
		"%s is a bitch-ass motherfucker they shot my fucking hostage"
	},
	
	_responseCursor_named = 1,
	
	_responseCursor_unnamed = 1,
	
	_responses_unnamed = {
		"rude",
		"smh my head",
		"you serious?",
		"kids these days...",
		"what the fuck",
		"bruh",
		"excuse me!?"
	}
}



WowRudeResponses._responseCount_named = table.maxn(WowRudeResponses._responses_named)
WowRudeResponses._responseCount_unnamed = table.maxn(WowRudeResponses._responses_unnamed)

function WowRudeResponses:respond_named(nameAndShame)


	local response = string.format(self._responses_named[self._responseCursor_named], nameAndShame)
	
	self._responseCursor_named = self._responseCursor_named + 1
	if self._responseCursor_named > self._responseCount_named then
		self._responseCursor_named = 1
	end

	return response
	
end

function WowRudeResponses:respond_unnamed()

	local response = self._responses_unnamed[self._responseCursor_unnamed]
	
	self._responseCursor_unnamed = self._responseCursor_unnamed + 1
	if self._responseCursor_unnamed > self._responseCount_unnamed then
		self._responseCursor_unnamed = 1
	end

	return response
end