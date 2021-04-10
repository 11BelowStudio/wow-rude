-- YEAH IT'S BASICALLY RIPPED FROM HELPFUL INTIMIDATED OUTLINES


------------
-- Purpose: Hooks CopDamage:die() for unit deregistration and complaining upon unit death (server-side)
------------


-- This is called on the server whenever a unit dies, regardless of the attacker being the local player or AI
Hooks:PostHook( CopDamage , "die" , "WowRudeCopDamageDie" , function( self , attack_data )

	if WowRude.TrackedUnits[self._unit] then
		WowRude.TrackedUnits[self._unit] = nil

		WowRude:complain()
	end

end )