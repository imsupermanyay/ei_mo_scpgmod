include("shared.lua")

function ENT:Draw()
    --return
    if 1 > 2 then
        self:DrawModel()
    end
    --if LocalPlayer():GetNWBool("can_sea_gaus") then
    --    outline.Add(self,Color(255,255,255),1)
    --end
end
