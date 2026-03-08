AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



function ENT:Initialize()
    local modeltablec = {
    "models/gift/christmas_gift.mdl",
    "models/gift/christmas_gift_2.mdl", 
    "models/gift/christmas_gift_3.mdl",
    }
    self:SetModel(table.Random(modeltablec))
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType( SIMPLE_USE )
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end
--BREACH.ALPHA1GC = 0
function ENT:Think()
	if ( SERVER ) then
		self:NextThink( CurTime() )
        return true
	end
end

--BREACH.ALPHA1GC = 0
function ENT:Use(a,c)
    if a:GTeam() != TEAM_SPEC then
        a:BrProgressBar("l:progress_wait", 30, "nextoren/gui/icons/eat_gift.png", self, false, function()
            open_imperator_gift(a)
            ParticleEffect("gas_explosion_main", self:GetPos(), Angle(0,0,0), game.GetWorld())
            BroadcastLua("ParticleEffect(\"gas_explosion_main\", Vector("..tostring(self:GetPos().x)..", "..tostring(self:GetPos().y)..", "..tostring(self:GetPos().z).."), Angle(0,0,0), game.GetWorld())")
            self:Remove()
        end)
    end
end

