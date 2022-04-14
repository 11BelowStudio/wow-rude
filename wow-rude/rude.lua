dofile(ModPath .. 'automenubuilder.lua')
dofile(ModPath .. 'wowRudeResponses.lua')

-- YEAH IT'S BASICALLY RIPPED FROM HELPFUL INTIMIDATED OUTLINES
-- and a bit from PocoHud3

local _conv = {
--[[
    city_swat	=	'_mob_city_swat',
    cop	=	'_mob_cop',
    fbi	=	'_mob_fbi',
    fbi_heavy_swat	=	'_mob_fbi_heavy_swat',
    fbi_swat	=	'_mob_fbi_swat',
    gangster	=	'_mob_gangster',
    gensec	=	'_mob_gensec',
    heavy_swat	=	'_mob_heavy_swat',
    security	=	'_mob_security',
    shield	=	'_mob_shield',
    sniper	=	'_mob_sniper',
    spooc	=	'_mob_spooc',
    swat	=	'_mob_swat',
    tank	=	'_mob_tank',
    taser	=	'_mob_taser',
]]--
	city_swat	=	'ingame_wow_rude_an_enemy',
    cop	=	'ingame_wow_rude_an_enemy',
    fbi	=	'ingame_wow_rude_an_enemy',
    fbi_heavy_swat	=	'ingame_wow_rude_an_enemy',
    fbi_swat	=	'ingame_wow_rude_an_enemy',
    gangster	=	'ingame_wow_rude_an_enemy',
    gensec	=	'ingame_wow_rude_an_enemy',
    heavy_swat	=	'ingame_wow_rude_an_enemy',
    security	=	'ingame_wow_rude_an_enemy',
    shield	=	'ingame_wow_rude_an_enemy',
    sniper	=	'ingame_wow_rude_an_enemy',
    spooc	=	'ingame_wow_rude_an_enemy',
    swat	=	'ingame_wow_rude_an_enemy',
    tank	=	'ingame_wow_rude_an_enemy',
    taser	=	'ingame_wow_rude_an_enemy',
}


WowRude = 
	WowRude or 
	{
		_settings = {
			isEnabled = true,
			hostOnly = false,
			nameAndShame = true,
			--complainCivilians = true
			
		},
		_values = {
			nameAndShame = {
				callback = function () WowRudeResponses:resetCursor() end
			}
		},
		_order = {
            isEnabled = 100,
			nameAndShame = 90,
			--complainCivilians = 80
		}
		
		--[[
		-- table for the responses we might use when someone kills our intimidated cop
		_responses = {
			"rude",
			"smh my head",
			"you serious?",
			"kids these days...",
			"what the fuck",
			"bruh",
			"excuse me!?"
		},
		
		-- the size of the above table
		_responseCount = 7,
		--]]
		-- the cursor for the next response we'll be using from that table
		--_responseCursor = 1,
		
	}



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

-- the dictionary(?) of intimidated cops
WowRude._trackedUnits = {}




local function get_keys(t)
  local keys={}
  for key,_ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end




-- nicked from PocoHud3
function WowRude:pidToPeer(pid)
    local session = managers.network:session()
    return session and session:peer(pid)
end

-- nicked from PocoHud3
 function WowRude:_peer(something)
    local t = type(something)
    if t == 'userdata' then
        return alive(something) and something:network() and something:network():peer()
    end
    if t == 'number' then
        return WowRude:pidToPeer(something)
    end
    if t == 'string' then
        return WowRude:_peer(managers.criminals:character_peer_id_by_name( something ))
    end
end

-- nicked from PocoHud3
function WowRude:_pos(something,head)
    local t, unit = type(something)
    if t == 'number' and managers.network and managers.network:session() then
        local peer = managers.network:session():peer(something)
        unit = peer and peer:unit() or nil
    else
        unit = something
    end
    if not (unit and alive(unit)) then return Vector3() end
    local pos = Vector3()
    mvector3.set(pos,unit:position())
    if head and unit.movement and unit:movement() and unit:movement():m_head_pos() then
        mvector3.set_z(pos,unit:movement():m_head_pos().z+(type(head)=='number' and head or 0))
    end
    return pos
end

-- nicked from PocoHud3
function WowRude:_name(something)
	if something == nil then
		return "????"
	end
	local str = type_name(something)
	if str == 'Unit' then
        if something:base() then
			WowRude:rudeLog("something:base() exists! keys: ")
			WowRude:rudeLog(table.concat(get_keys(something:base()), ", "))
			if something:base()._tweak_table then
				return WowRude:_name(something:base() and something:base()._tweak_table)
			end
        end
        return "?????"
    elseif str == 'string' then -- tweak_table name
        local pName = managers.criminals:character_peer_id_by_name( something )
        if pName then
            return WowRude:_name(pName)
        else
            local conv = _conv
            return L(conv[something]) or "AI"
        end
    --end
	elseif str == 'number' then
		local peer = WowRude:_peer(something)
		local name = peer and peer:name() or 'Someone'
		name = name:gsub('{','['):gsub('}',']')
		return name
	else
		return 'someone'
	end
	return "OH GOD OH FUCK IT BROKE"
	--[[
    local hDot,fDot
    local truncated = name:gsub('^%b[]',''):gsub('^%b==',''):gsub('^%s*(.-)%s*$','%1')
    if O:get('game','truncateTags') and utf8.len(truncated) > 0 and name ~= truncated then
        name = truncated
        hDot = true
    end
    local tLen = O:get('game','truncateNames')
    if tLen > 1 then
        tLen = (tLen - 1) * 3
        if tLen < utf8.len(name) then
            name = utf8.sub(name,1,tLen)
            fDot = true
        end
    end
    return (hDot and Icon.Dot or '')..name..(fDot and Icon.Dot or '')
	--]]
end

--[[
Checks if wowRude is enabled or not.
]]--
function WowRude:isEnabled()
	if WowRude._settings.isEnabled then
		--log("wow rude: is enabled")
		if WowRude._settings.hostOnly then
			--log("wow rude: checking host only")
			return Network:is_server()
		end
		return true
	end
	WowRude:rudeLog("is not enabled")
	return false
end


--[[
Stop tracking a cop (removes it from the table).
Happens regardless of whether or not WowRude is enabled or not.
Returns true if cop was being tracked, false if not being tracked.
]]--
function WowRude:stopTracking(copToStopTracking)
	--WowRude:rudeLog("stopping tracking")
	if WowRude._trackedUnits[copToStopTracking] then
		WowRude:rudeLog("no longer tracked")
		WowRude._trackedUnits[copToStopTracking] = nil
		return true
	end
	return false
end


--[[ 
attempts to add an intimidatedCop to the table of cops to track.
	If the cop could be added, return true.
	If the cop could not be added (already in the table, or the mod is disabled), return false.
]]--
function WowRude:onIntimidate(intimidateMe)
	WowRude:rudeLog("on intimidate")
	if WowRude:isEnabled() then
		WowRude:rudeLog("is enabled, checking if on table")
		if WowRude._trackedUnits[intimidateMe] ~= nil then
			WowRude:rudeLog("already tracked")
			return false
		end
		WowRude:rudeLog("starting tracking this unit")
		WowRude._trackedUnits[intimidateMe] = true
		WowRude:rudeLog("unit added to trackedUnits!")
		return true
	end
	return false
end

function WowRude:getUnit(theUnit)
	return WowRude._trackedUnits[theUnit]
end


function WowRude:complainCivilians()
	return WowRude._settings.complainCivilians
end




--[[
Call this whenever a unit is killed.
Attempts to remove that unit from the table. If it could be removed, and the mod is enabled, complain.
]]--
function WowRude:onCopKilled(killedUnit, attack_data)

	if WowRude:isEnabled() then
		WowRude:rudeLog("onCopKilled called")
		if WowRude:stopTracking(killedUnit) == true then
			--or (WowRude:complainCivilians() and managers.enemy:is_civilian(killedUnit)) then
			WowRude:rudeLog("time to complain!")
			WowRude:complain(attack_data)
		end
	
	else
		WowRude:stopTracking(killedUnit)
	end

	--[[
	if WowRude:stopTracking(killedUnit) and WowRude:isEnabled() then
		WowRude:complain(attacker_unit)
	end
	--]]
end

WowRude.logInChat = false;

function WowRude:rudeLog(logThis)
	log("wow rude " .. logThis)
	
	if WowRude.logInChat and managers.chat then 
		managers.chat:_receive_message(1,"wow rude logged",logThis,Color.orange)
		return true
	end
end


-- and the code responsible for complaining
function WowRude:complain(attack_data)

	if WowRude:isEnabled() then
	
		WowRude:rudeLog("I shall now proceed to write a strongly-worded letter.")
		--[[
		for i, v in ipairs(attack_data) do
			WowRude:rudeLog(i .. " : " .. v)
		end
		]]--
	
		local text = "PLACEHOLDER"
		
		if WowRude._settings.nameAndShame and (attack_data.attacker_unit ~= nil) then
		
		
			local attacker_unit = attack_data.attacker_unit
	
			local attacker_name = "???"
		
			if alive(attacker_unit) and attacker_unit:base() then
				if attacker_unit:base().thrower_unit then
					attacker_unit = attacker_unit:base():thrower_unit()
				elseif attacker_unit:base().sentry_gun then
					attacker_unit = attacker_unit:base():get_owner()
				end
				
				attacker_name = WowRude:_name(attacker_unit)
			else
				WowRude:rudeLog("UNKNOWN ATTACKER " .. attacker_unit)
			end
			
			text = WowRudeResponses:respond_named(attacker_name)
		
		else
			text = WowRudeResponses:respond_unnamed()
		end
		
		
		--local text = WowRudeResponses:respond_named(attacker_name)
		
		
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
	
end

if WowRude ~= nil then
	log("wow rude exists!")
end


--[[
-- an object I guess
--WowRude = {}

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

]]--