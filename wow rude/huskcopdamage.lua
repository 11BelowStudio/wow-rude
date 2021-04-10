-- YEAH IT'S BASICALLY RIPPED FROM HELPFUL INTIMIDATED OUTLINES


------------
-- Purpose: Hooks HuskCopDamage:die() for unit deregistration and complaining upon unit death (client-side)
------------

-- This is called on the client whenever a unit dies, regardless of the attacker being the local player or AI
Hooks:PostHook( HuskCopDamage , "die" , "WowRudeHuskCopDamageDie" , function( self , variant )

	if WowRude.TrackedUnits[self._unit] then
		WowRude.TrackedUnits[self._unit] = nil

		WowRude:complain()

	end

end )
