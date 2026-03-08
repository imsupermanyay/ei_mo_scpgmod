AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Think()
	if ( SERVER ) then
		self:NextThink( CurTime() )
        return true
	end
end

function ENT:Use(a,c)
    --local variable = (table.GetKeys(self.scp_list))
    --if self:GetItem() == "нил" then
    --    self:SetItem(table.Random(variable))
    --else
    --    self:SetItem("нил")
    --end
end

--table.LowerKeyNames