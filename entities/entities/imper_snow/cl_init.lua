include("shared.lua")

function ENT:Draw()
    if GetConVar("breach_config_snow"):GetInt() == 0 or LocalPlayer():GetPos():Distance(self:GetPos()) > 1000 then return end
    self:DrawModel()
    --if LocalPlayer():GetNWBool("can_sea_gaus") then
        --outline.Add(self,Color(206,175,175),2)
    --end
end
