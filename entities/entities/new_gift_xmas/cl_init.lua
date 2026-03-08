include("shared.lua")

function ENT:Draw()
    self:DrawModel()
    --if LocalPlayer():GetNWBool("can_sea_gaus") then
        outline.Add(self,Color(221,76,76),2)
    --end
end
