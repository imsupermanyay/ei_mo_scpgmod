
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

SWEP.Weight			= 5		-- Decides whether we should switch from/to this
SWEP.AutoSwitchTo	= true	-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom	= true	-- Auto switch from if you pick up a better weapon

util.AddNetworkString("advmelee:PlayWeightedGestureOnPlayer")
util.AddNetworkString("advmelee:PlayerParried")
util.AddNetworkString("advmelee:PlayerHitSomething")
util.AddNetworkString("advmelee:ConfigureGestures")
util.AddNetworkString("advmelee:PlayFlinchOnPlayer")

function SWEP:BroadcastAndPlayGesture(ply, gesture, weight, speed)
	ply:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence(gesture), 0, true)
	ply:AnimSetGestureWeight(GESTURE_SLOT_ATTACK_AND_RELOAD, weight)
	ply:SetLayerDuration(GESTURE_SLOT_ATTACK_AND_RELOAD, speed)

	local filter = RecipientFilter(true) --idk if it works the same way with nets
	filter:AddPVS(ply:GetPos())
	filter:RemovePlayer(ply) --client is playing gestures on himself already

	net.Start("advmelee:PlayWeightedGestureOnPlayer", true) --we need to send animation as fast as possible
		net.WriteEntity(ply)
		net.WriteString(gesture)
		net.WriteFloat(weight)
		net.WriteFloat(speed)
	net.Send(filter)
end

function SWEP:CalculateSwingDamage(ent, hitpos)
	local dmginfo = DamageInfo()
	dmginfo:SetDamage(self.SwingDamage)
	dmginfo:SetDamageType(self.SwingDamageType)
	dmginfo:SetDamagePosition(hitpos)
	dmginfo:SetAttacker(self:GetOwner())
	dmginfo:SetInflictor(self)
	ent:TakeDamageInfo(dmginfo)
end

function SWEP:CalculateStabDamage(ent, hitpos)
	local dmginfo = DamageInfo()
	dmginfo:SetDamage(self.StabDamage)
	dmginfo:SetDamageType(self.StabDamageType)
	dmginfo:SetDamagePosition(hitpos)
	dmginfo:SetAttacker(self:GetOwner())
	dmginfo:SetInflictor(self)
	ent:TakeDamageInfo(dmginfo)
end

function SWEP:DoParryEffect(ent, ent_weapon)
	local filter = RecipientFilter(true) --idk if it works the same way with nets
	filter:AddPVS(ent:GetPos())
	filter:RemovePlayer(ent) --client is playing the effect already

	net.Start("advmelee:PlayerParried", true) --we need to send effect as fast as possible
		net.WriteEntity(ent) --the player who parried
		net.WriteEntity(ent_weapon) --his weapon
	net.Send(filter)
end

function SWEP:EmitGoreSounds(ent, owner, ent_weapon, swinging, stabbing)
	if swinging then
		local damage = self.SwingDamage
		local dmgtype = self.SwingDamageType
		local blunt = dmgtype == DMG_CLUB

		ent:EmitSound("mordhau/weapons/meleeenvironment/sw_heavyarmormeleehit0"..math.random(1, 5)..".wav", 55, math.random(98, 102), 1)
		ent:EmitSound(self.GoreSwingSounds[math.random(1, #self.GoreSwingSounds)], 75, math.random(98, 102), 1)
	end

	if stabbing then
		local damage = self.SwingDamage
		local dmgtype = self.SwingDamageType
		local blunt = dmgtype == DMG_CLUB

		ent:EmitSound("mordhau/weapons/meleeenvironment/sw_heavyarmormeleestab0"..math.random(1, 4)..".wav", 55, math.random(98, 102), 1)
		ent:EmitSound(self.GoreStabSounds[math.random(1, #self.GoreStabSounds)], 75, math.random(98, 102), 1)
	end
end

function SWEP:DoHitEffect(bool, ent, pos, ent_weapon, hitnormal)
	local filter = RecipientFilter(true) --idk if it works the same way with nets
	local owner = IsValid(ent_weapon) and ent_weapon:GetOwner()
	if !IsValid(owner) then
		owner = ent
	end
	filter:AddPVS(owner:GetPos())
	filter:RemovePlayer(owner) --client is playing the effect already
	net.Start("advmelee:PlayerHitSomething", true) --we need to send effect as fast as possible
		net.WriteBool(bool) --true - hit alive, false - hit solid
		if IsValid(ent_weapon) then
			net.WriteEntity(owner) --player
		else
			net.WriteEntity(ent)
		end
		net.WriteVector(pos)
		if !bool then
			net.WriteEntity(ent_weapon)
			net.WriteNormal(hitnormal)
		end
	net.Send(filter)
	if self:IsAliveEnt(ent) then
		self:EmitGoreSounds(ent, owner, ent_weapon, ent_weapon:GetSwinging(), ent_weapon:GetStabbing())
	else
		self:EmitSound(self.HitSolidSounds[math.random(1, #self.HitSolidSounds)], 75, math.random(50, 100), 1, CHAN_WEAPON)
	end
end

function SWEP:BroadcastAndConfigureGestures(ply, weight, speed)
	ply:AnimSetGestureWeight(GESTURE_SLOT_ATTACK_AND_RELOAD, weight)
	ply:SetLayerDuration(GESTURE_SLOT_ATTACK_AND_RELOAD, speed)

	local filter = RecipientFilter(true) --idk if it works the same way with nets
	filter:AddPVS(ply:GetPos())
	filter:RemovePlayer(ply) --client is playing gestures on himself already

	net.Start("advmelee:ConfigureGestures", true) --we need to send animation as fast as possible
		net.WriteEntity(ply)
		net.WriteFloat(weight)
		net.WriteFloat(speed)
	net.Send(filter)
end

function SWEP:BroadcastAndPlayFlinch(ply, gesture, weight, speed)
	ply:AnimResetGestureSlot(GESTURE_SLOT_FLINCH)
	ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_FLINCH, ply:LookupSequence(gesture), 0, true)
	ply:AnimSetGestureWeight(GESTURE_SLOT_FLINCH, weight)
	ply:SetLayerDuration(GESTURE_SLOT_FLINCH, speed)

	local filter = RecipientFilter(true) --idk if it works the same way with nets
	filter:AddPVS(ply:GetPos())
	filter:RemovePlayer(ply) --client is playing gestures on himself already

	net.Start("advmelee:PlayFlinchOnPlayer", true) --we need to send animation as fast as possible
		net.WriteEntity(ply)
		net.WriteString(gesture)
		net.WriteFloat(weight)
		net.WriteFloat(speed)
	net.Send(filter)
end

--[[---------------------------------------------------------
	Name: OnRestore
	Desc: The game has just been reloaded. This is usually the right place
		to call the GetNW* functions to restore the script's values.
-----------------------------------------------------------]]

function SWEP:OnRestore()
end

--[[---------------------------------------------------------
	Name: AcceptInput
	Desc: Accepts input, return true to override/accept input
-----------------------------------------------------------]]
function SWEP:AcceptInput( name, activator, caller, data )
	return false
end

--[[---------------------------------------------------------
	Name: KeyValue
	Desc: Called when a keyvalue is added to us
-----------------------------------------------------------]]
function SWEP:KeyValue( key, value )
end

--[[---------------------------------------------------------
	Name: Equip
	Desc: A player or NPC has picked the weapon up
-----------------------------------------------------------]]
function SWEP:Equip( newOwner )
end

--[[---------------------------------------------------------
	Name: EquipAmmo
	Desc: The player has picked up the weapon and has taken the ammo from it
		The weapon will be removed immidiately after this call.
-----------------------------------------------------------]]
function SWEP:EquipAmmo( newOwner )
end


--[[---------------------------------------------------------
	Name: OnDrop
	Desc: Weapon was dropped
-----------------------------------------------------------]]
function SWEP:OnDrop()
end

--[[---------------------------------------------------------
	Name: ShouldDropOnDie
	Desc: Should this weapon be dropped when its owner dies?
-----------------------------------------------------------]]
function SWEP:ShouldDropOnDie()
	return true
end

--[[---------------------------------------------------------
	Name: GetCapabilities
	Desc: For NPCs, returns what they should try to do with it.
-----------------------------------------------------------]]
function SWEP:GetCapabilities()

	return CAP_WEAPON_RANGE_ATTACK1

end

--[[---------------------------------------------------------
	Name: NPCShoot_Secondary
	Desc: NPC tried to fire secondary attack
-----------------------------------------------------------]]
function SWEP:NPCShoot_Secondary( shootPos, shootDir )

	self:SecondaryAttack()

end

--[[---------------------------------------------------------
	Name: NPCShoot_Secondary
	Desc: NPC tried to fire primary attack
-----------------------------------------------------------]]
function SWEP:NPCShoot_Primary( shootPos, shootDir )

	self:PrimaryAttack()

end

-- These tell the NPC how to use the weapon
AccessorFunc( SWEP, "fNPCMinBurst",		"NPCMinBurst" )
AccessorFunc( SWEP, "fNPCMaxBurst",		"NPCMaxBurst" )
AccessorFunc( SWEP, "fNPCFireRate",		"NPCFireRate" )
AccessorFunc( SWEP, "fNPCMinRestTime",	"NPCMinRest" )
AccessorFunc( SWEP, "fNPCMaxRestTime",	"NPCMaxRest" )
