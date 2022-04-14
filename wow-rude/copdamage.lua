-- YEAH IT'S BASICALLY RIPPED FROM HELPFUL INTIMIDATED OUTLINES


------------
-- Purpose: Hooks CopDamage:die() for unit deregistration and complaining upon unit death (server-side)
------------


-- This is called on the server whenever a unit dies, regardless of the attacker being the local player or AI
Hooks:PostHook(
	CopDamage,
	"die" ,
	"WowRudeCopDamageDie",
	function( self , attack_data )
	
		--WowRude:rudeLog("cop damage die")

		--WowRude:onCopKilled(self._unit, attack_data)

		--[[

		if WowRude.TrackedUnits[self._unit] then
			WowRude.TrackedUnits[self._unit] = nil

			WowRude:complain()
		end
		]]--

	end
)

--[[
Hooks:PostHook(
	CopDamage,
	"_on_damage_received",
	"WowRudeCopDamage_on_damage_received",
	function(self, damage_info)
)
--]]

Hooks:PreHook(
	EnemyManager,
	"on_enemy_died",
	"WowRude_EnemyManager_on_enemy_died",
	function(self, dead_unit, damage_info)
	
		--local u_key = dead_unit:key()
		--local enemy_data = self._enemy_data
		--local enemy_u_data = enemy_data.unit_data
		
		WowRude:rudeLog("manager on_enemy_died start")
		
		WowRude:onCopKilled(dead_unit, damage_info)
		
		WowRude:rudeLog("manager on_enemy_died done!")
	
	end
)

Hooks:PreHook(
	EnemyManager,
	"on_enemy_destroyed",
	"WowRude_EnemyManager_on_enemy_destroyed",
	function(self, enemy)
		
		WowRude:rudeLog("manager on_enemy_destroyed start")
		
		WowRude:stopTracking(enemy)
		
		WowRude:rudeLog("manager on_enemy_destroyed done!")
		
	
	end
)