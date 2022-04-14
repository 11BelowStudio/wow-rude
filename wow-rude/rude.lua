if not HopLib then
	if managers.chat then 
		managers.chat:_receive_message(ChatManager.GAME,"wow rude [ERROR]","HopLib is required to use this mod! See mods/logs/{today}.txt for links to HopLib.",Color.red)
	end
	log("WOW RUDE: HopLib can be downloaded from https://modworkshop.net/mod/21431 or https://github.com/segabl/pd2-hoplib/archive/master.zip or ")
	return
end

--dofile(ModPath .. 'automenubuilder.lua')
dofile(ModPath .. 'wowRudeResponses.lua')



-- YEAH IT'S BASICALLY RIPPED FROM HELPFUL INTIMIDATED OUTLINES
-- and a bit from PocoHud3

if not WowRude then


	_G.WowRude = {}
	
	WowRude._settings = {
		isEnabled = true,
		hostOnly = false,
		complainHandsUp = true,
		complainCivilians = false,
		nameAndShame = true,
		
		logInChat = false,
		minLogInChat = 1
			
	}
	WowRude._values = {
		minLogInChat = {
			min = 0,
			max = 5,
			step = 1
		}
	}
	WowRude._order = {
		isEnabled = 100,
		hostOnly = 95,
		complainHandsUp = 90,
		complainCivilians = 85,
		nameAndShame = 80,
		logInChat = 2,
		minLogInChat = 1
	}
	
	local Complainer = class()
	
	WowRude.complainer = Complainer
	
	local tracked_units = {}
	
	Complainer.tracked_units = tracked_units
	
	
	
	
	-- utility function to reset the tracked units.
	function WowRude:reset()
		local units = Complainer.tracked_units
		for k in pairs(units) do
			units[k] = nil
		end
	end
	
	-- logging utility function that also logs stuff in chat
	function WowRude:rudeLog(logThis, importance)
		log("wow rude [" .. importance .. "] " .. logThis)
		
		if managers.chat and self._settings.logInChat and (importance >= self._settings.minLogInChat) then 
			managers.chat:_receive_message(ChatManager.GAME,"wow rude [".. importance .. "]",logThis,Color.orange)
			return true
		end
	end
	
	
	--[[
	Checks if wowRude is enabled or not.
	]]--
	function WowRude:isEnabled()
		if self._settings.isEnabled then
			--log("wow rude: is enabled")
			if self._settings.hostOnly then
				--log("wow rude: checking host only")
				return Network:is_server()
			end
			return true
		end
		self:rudeLog("is not enabled", 2)
		return false
	end
	
	-- should Wow Rude complain from when the enemy puts their hands up?
	function WowRude:complainHandsUp()
		return self._settings.complainHandsUp
	end
	
	function WowRude:complainCivilians()
		return self._settings.complainCivilians
	end
	
	function Complainer:getUnit(theUnit)
		return self.tracked_units[theUnit]
	end

	
	function Complainer:onIntimidate(unit)
		WowRude:rudeLog("on intimidate", 3)
		if WowRude:isEnabled() then
			WowRude:rudeLog("is enabled, checking if on table", 2)
			if self.tracked_units[unit] ~= nil then
				WowRude:rudeLog("already tracked", 3)
				return false
			end
			WowRude:rudeLog("starting tracking this unit", 2)
			self.tracked_units[unit] = true
			WowRude:rudeLog("unit added to trackedUnits!", 3)
			return true
		end
		return false
	end
	
	--[[
	Stop tracking a cop (removes it from the table).
	Happens regardless of whether or not WowRude is enabled or not.
	Returns true if cop was being tracked, false if not being tracked.
	]]--
	function Complainer:stopTracking(unit)
		--WowRude:rudeLog("stopping tracking")
		if tracked_units[unit] ~= nil then
			WowRude:rudeLog("no longer tracked", 3)
			tracked_units[unit] = nil
			return true
		end
		return false
	end
	
	function WowRude:stopTracking(unit)
		return self.complainer:stopTracking(unit)
	end
	
	
	-- handles the stopping tracking and the complaining.
	function Complainer:onKilled(damage_info, target)
		local target_info = HopLib:unit_info_manager():get_info(target)
		if not target_info or not WowRude:isEnabled() then
			return
		end
		
		if self:stopTracking(target) or (WowRude:complainCivilians() and target_info:is_civilian()) then
			
		
			if not alive(damage_info.attacker_unit) or not damage_info.attacker_unit:base() then
				return
			end
			
			
			WowRude:rudeLog("I shall now proceed to write a strongly-worded letter.", 2)
			--[[
			for i, v in ipairs(attack_data) do
				WowRude:rudeLog(i .. " : " .. v)
			end
			]]--
		
			local text = "PLACEHOLDER"
			
			if WowRude._settings.nameAndShame and (damage_info.attacker_unit ~= nil and alive(damage_info.attacker_unit) and damage_info.attacker_unit:base()) then
			
			
				local attacker_unit = damage_info.attacker_unit:base().thrower_unit and damage_info.attacker_unit:base():thrower_unit() or damage_info.attacker_unit
				local attacker_info = HopLib:unit_info_manager():get_info(attacker_unit)
		
				local attacker_name = attacker_info:name()
				
				text = WowRudeResponses:respond_named(attacker_name)
			
			else
				text = WowRudeResponses:respond_unnamed()
			end
			
			
			
			if managers.chat then 
				if managers.network:session() and #managers.network:session()._peers_all <= 1 then 
					managers.chat:_receive_message(ChatManager.GAME,"basic human decency",text,Color.red)
				else
					managers.chat:send_message(ChatManager.GAME, managers.network.account:username() or ">:(", ">:( " .. text)
				end
				return true
			else
				log("wow rude " .. text)
			end
			
			
			
			-- TODO
			
			-- see https://github.com/segabl/pd2-kill-feed/blob/master/mod.lua
			
		end
	
	end
	
	
	function WowRude:action_request(this_unit, action_desc)
	
		if action_desc.variant == "hands_back" or (action_desc.variant == "hands_up" and WowRude:complainHandsUp()) then
			
			WowRude:rudeLog("hands up or back", 1)
		
			if self.complainer:onIntimidate(this_unit) then
				WowRude:rudeLog("hands up or back: onIntimidate started", 0)
			else
				WowRude:rudeLog("hands up or back: already intimidated", 0)
			end
			return

			--[[
			if WowRude.TrackedUnits[this_unit] ~= nil then
				-- Already tracking this unit, do not add another contour as they are reference counted (i.e. every call to add()
				-- /must/ have a matching call to remove() with the same type, unless the contour type has a fadeout value). If you
				-- do not understand the concept of reference counting, read up on mutexes and deadlocks, the reason you should not
				-- call ContourExt:add() twice should then become obvious (albeit with far less severe consequences)
				-- This can occasionally happen when a unit surrenders twice (e.g. getting ignored the first time so it returns to
				-- its normal stance, but then surrendering again on a second domination attempt. This second attempt appears to
				-- bypass the "hands_up" action at random, so the above check catches both of them as a failsafe)
				return result
			end

			-- Don't bother with contour color changing, the friendly contour color is obvious enough for most players to know
			-- that they should stop shooting (field-tested and proven true). If anything, the hostage_trade contour color ends
			-- up confusing players more
			

			-- This unit needs to be tracked from now on since a contour has been placed on it by this mod
			WowRude.TrackedUnits[this_unit] = true
			]]--

		elseif action_desc.variant == "tied_all_in_one" then
			-- This will occur under two circumstances: 
			-- 1) When a guard is dominated in stealth (see CopLogicIntimidated._start_action_hands_up())
			-- 2) When a minion re-surrenders for a hostage trade (see CopLogicTrade.hostage_trade())

			-- Is this unit being tracked?
			if self.complainer:getUnit(this_unit) then
				WowRude:rudeLog("tracked unit tied_all_in_one", 1)
				-- This is a minion that has re-surrendered, remove the contour that was placed on it earlier so that the correct
				-- contour will be seen

				-- HACKHACK --
				-- Ignore this unit from now on, whatever happens to it from now on is no longer of concern
				self.complainer:stopTracking(this_unit)
				
			elseif managers.groupai:state():whisper_mode() then
				WowRude:rudeLog("intimidated during stehls", 1)
				-- This unit needs to be tracked since it has surrendered so that a contour can be applied on it if the heist
				-- goes loud
				self.complainer:onIntimidate(this_unit)
			end
			return

		else
			-- Okay, so it's not an intimidation-specific action. Is it being triggered on a tracked unit?
			if self.complainer:getUnit(this_unit) then
				-- This is a tracked unit that has not been converted to a minion. CopLogicIdle.on_new_objective() is not hooked as
				-- it only executes on the server, yet this mod must be capable of running independently on clients without any
				-- additional support from the server. Hence these checks being placed here, along with the enclosed code within
				if action_desc.variant == "idle" or action_desc.variant == "stand" then

	-- NOTE: Requires a fix in Moveable Intimidated Cop's CopBrain:on_hostage_move_interaction() hook to ensure it sets
	-- self._unit:base().mic_is_being_moved before calling action_request(), otherwise this mod will mistakenly untrack the unit

					-- Dominated units are not supposed to be moving around or otherwise doing anything, this unit must have been
					-- freed by a cop (or traded as a hostage). Remove its friendly contour - this unit is now an enemy (again)
					-- This is placed here because these actions can be performed by any active cop, so there is a need
					-- to filter out all the other untracked units. Other related actions (e.g. "run", "turn") could also be
					-- caught here, but there is not much point in doing so as the first thing a unit will do upon being freed is
					-- stand back up again
					-- Stop tracking this unit, whatever happens to it from now on is no longer of concern
					self.complainer:stopTracking(this_unit)
				end
			end		-- type(masterunit) == "boolean"
		end		-- action_desc.variant if-elseif-else checks
	end
	
	
	Hooks:Add(
		"HopLibOnUnitDied",
		"WowRude_HopLibOnUnitDied",
		function (unit, damage_info)
			if WowRude:isEnabled()  and unit:character_damage():dead() then
			
				WowRude:rudeLog("hoplip on died start", 0)
			
				WowRude.complainer:onKilled(damage_info, unit)
				WowRude:rudeLog("hoplip on died done", 0)
				
			end
		end
	)
	

	
	
end

WowRude:reset()

if RequiredScript == "lib/managers/menumanager" then

	local mpath = ModPath

	Hooks:Add(
		'LocalizationManagerPostInit',
		'LocalizationManagerPostInit_WowRude',
		function(loc)
			local lang, path = SystemInfo and SystemInfo:language(), 'loc/english.json'
			--[[
			if lang == Idstring('language') then
				path = 'loc/language.txt'
			end
			]]--
			loc:load_localization_file(mpath .. path)
		end
	)


	Hooks:Add(
		'MenuManagerBuildCustomMenus',
		'MenuManagerBuildCustomMenus_WowRude',
		function(menu_manager, nodes)
			AutoMenuBuilder:load_settings(WowRude._settings, 'wow_rude')
			AutoMenuBuilder:create_menu_from_table(
				nodes,
				WowRude._settings,
				'wow_rude',
				'blt_options',
				WowRude._values,
				WowRude._order
			)
		end
	)

elseif RequiredScript == "lib/units/enemies/cop/copmovement" then


	Hooks:PreHook(
		CopMovement,
		"action_request",
		"WowRude_CopMovement_action_request",
		function(self, action_desc)
			if WowRude:isEnabled() then
				local this_unit = self._unit
		
				if this_unit == nil then
					return
				end

				-- Ignore civilians (yes, they actually /are/ cops)
				if managers.enemy:is_civilian(this_unit) then
					return
				end

				-- Only interested in actions
				if action_desc.type == nil or action_desc.type ~= "act" then
					return
				end

				-- Compatibility with Movable Intimidated Cops (ignore all units being manipulated by it)
				if this_unit:base().mic_is_being_moved ~= nil then
					return
				end
				
				WowRude:action_request(this_unit, action_desc)
				
			end
		end
	)
	
	
elseif RequiredScript == "lib/managers/enemymanager" then

	Hooks:PreHook(
		EnemyManager,
		"on_enemy_destroyed",
		"WowRude_EnemyManager_on_enemy_destroyed",
		function(self, enemy)
			
			WowRude:rudeLog("manager on_enemy_destroyed start", 0)
			
			WowRude:stopTracking(enemy)
			
			WowRude:rudeLog("manager on_enemy_destroyed done!", 0)
			
		
		end
	)	

end




if WowRude ~= nil then
	log("wow rude exists!")
end
