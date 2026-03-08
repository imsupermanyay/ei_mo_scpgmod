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
    --self:SetTextColor(tostring(Color(math.random(1,255),math.random(1,255),math.random(1,255))))
    --self:SetItem("Я самый крутой!!!")
end

--table.LowerKeyNames