-- YEAH IT'S BASICALLY RIPPED FROM HELPFUL INTIMIDATED OUTLINES


------------
-- Purpose: Hooks HuskCopDamage:die() for unit deregistration and complaining upon unit death (client-side)
------------

-- This is called on the client whenever a unit dies, regardless of the attacker being the local player or AI
Hooks:PostHook( HuskCopDamage , "die" , "WowRudeHuskCopDamageDie" , function( self , variant )

	
	--if WowRude:isEnabled() then
	
	--	WowRude:rudeLog("husk cop damage die")
	
	--	WowRude:onCopKilled(self._unit, variant)
		
		--[[
	
		local attacker = variant.attacker_unit
		attacker = alive(attacker) and attacker or nil

		if attacker then
			local base_ext = attacker:base()

			if base_ext and base_ext.thrower_unit then
				attacker = base_ext:thrower_unit()
				attacker = alive(attacker) and attacker or nil
			end
		end
	
		WowRude:onCopKilled(self._unit, variant and variant.attacker_unit)
		
		]]--
	
	--else
	--	WowRude:stopTracking(self._unit)
	--end
		
	--[[
	if WowRude.TrackedUnits[self._unit] then
		WowRude.TrackedUnits[self._unit] = nil

		WowRude:complain()

	end
	]]--

end )
