local function BreachAchiv_GetTable()
	net.Start("GetAchievementTable")
	net.SendToServer()
end

hook.Add("InitPostEntity", "BreachAchiv_GetTable", BreachAchiv_GetTable)

BreachAchievements = BreachAchievements || {}
BreachAchievements.AchievementTable = BreachAchievements.AchievementTable || {}

local mply = FindMetaTable("Player")

net.Receive("GetAchievementTable", function()

	local _t = net.ReadTable()
	BreachAchievements = BreachAchievements || {}
	BreachAchievements.AchievementTable = _t

end)

function OpenAchievementTab(ply)
	
	if !IsValid(ply) or !ply:IsPlayer() then return end
	net.Start("OpenAchievementMenu")
	net.WriteEntity(ply)
	net.SendToServer()

end

function mply:GetAchievementsNum()
	return self:GetNWInt("CompletedAchievements", 0)
end

function mply:CompleteAchievement(achivname)
	net.Start("CompleteAchievement_Clientside")
	net.WriteString(achivname)
	net.SendToServer()
end

local FUNNYACHIEVEMENTS = {
	{
		achievements_name = "开发团队",
		desc = "",
		image = "nextoren/achievements/ahive5.jpg",
		owners = {},
		ownersusergroup = {"headadmin", "MaxTechnologist_NN"},
	},
	{
		achievements_name = "管理组",
		desc = "欢迎来到种植园",
		image = "nextoren/achievements/ahive146.jpg",
		owners = {},
		ownersusergroup = {"spectator", "admin", "headadmin", "Helper", "Maxadmin", "oldadmin", "ExpertHeadAdmin", "plusEHadmin", "donate_adminn", "losadmin", "adminn", "HEadmin"},
	},
	{
		achievements_name = "Alpha-Tester",
		desc = "",
		image = "nextoren/achievements/ahive2.jpg",
		owners = {},
		ownersusergroup = {},
		customcheck = function(ply) return ply:GetNWBool("AlphaTester") end,
	},
	{
		achievements_name = "Застройщик",
		desc = "Помощь в застройке карты",
		image = "nextoren/achievements/ahive147.jpg",
		owners = {"STEAM_0:1:451986387" --[[алишерка]], "STEAM_0:0:453237891" --[[BOOM it's me]],"STEAM_0:0:34907980" --[[Narkis]], "76561198359356778" --[[eqvena]] },
		ownersusergroup = {},
	},
	{
		achievements_name = "Мастер",
		desc = "Собрал все ачивки первее всех",
		image = "nextoren/achievements/ahive5.jpg",
		owners = {"76561198180995835"},
		ownersusergroup = {}
	}
}

local bgmat = Material("nextoren_hud/inventory/menublack.png")
local bgmat2 = Material("nextoren_hud/inventory/texture_blanc.png")
local gradient = Material("vgui/gradient-l")
function OpenAchievementList(ply, tab, completedtab)

	BreachAchievements.GUI = BreachAchievements.GUI || {}

	if IsValid(BreachAchievements.GUI.Panel) then BreachAchievements.GUI.Panel:Remove() end

	BreachAchievements.GUI.Panel = vgui.Create("DFrame")
	BreachAchievements.GUI.Panel:SetDraggable(false)
	BreachAchievements.GUI.Panel:SetSize(600, ScrH() - 150)
	BreachAchievements.GUI.Panel:Center()
	BreachAchievements.GUI.Panel:SetTitle(ply:Name().."'s Achievements")
	BreachAchievements.GUI.Panel:SetBackgroundBlur(true)
	BreachAchievements.GUI.Panel.Paint = function(self, w, h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(bgmat)
		surface.DrawTexturedRect(0,0,w,h)
		return true
	end

	local AchievementList = vgui.Create( "DScrollPanel", BreachAchievements.GUI.Panel )
	AchievementList.Paint = function(self, w, h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(bgmat2)
		surface.DrawTexturedRect(0,0,w,h)
	end
	AchievementList:Dock( FILL )

	BreachAchievements.GUI.Panel.Think = function(self)
		gui.EnableScreenClicker(true)
		self:MakePopup()
	end

	BreachAchievements.GUI.Panel.OnRemove = function(self)
		gui.EnableScreenClicker(false)
	end


	local achievementlist = tab

	for i = 1, #FUNNYACHIEVEMENTS do
		local tabl = FUNNYACHIEVEMENTS[i]
		if !table.HasValue(tabl.owners, ply:SteamID()) and !table.HasValue(tabl.owners, ply:SteamID64()) and !table.HasValue(tabl.ownersusergroup, ply:GetUserGroup()) and !tabl.customcheck then continue end
		if ( isfunction(tabl.customcheck) and !tabl.customcheck(ply) ) then continue end
		local iscompleted = true
		local panel = AchievementList:Add("DPanel")
		panel:SetSize(260, 50)
		panel:Dock(TOP)
		local image = Material(tabl.image)
		local gradientcol = Color(0,125,125)
		panel.Paint = function(self, w, h)

			draw.RoundedBox(0, 0, 0, w, h, gradientcol)
			surface.SetDrawColor(0,0,0, 255)
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			surface.SetMaterial(gradient)
			surface.SetDrawColor(255,255,255,150)
			surface.DrawTexturedRect(0,0,w,h)

			draw.RoundedBox(0, 0, 0, 50, 50, color_black)

			surface.SetFont("TargetID")
			local x, y = surface.GetTextSize("\""..tabl.achievements_name.."\"")
			surface.SetDrawColor(0,0,0)
			surface.SetMaterial(gradient)
			surface.DrawTexturedRect(0, 5, w, y)

			surface.SetMaterial(image)
			surface.SetDrawColor(0,255,255,255)
			surface.DrawTexturedRect(2,2,46,46)

			draw.DrawText("\""..tabl.achievements_name.."\"", "TargetID", 55, 5, color_white)
			draw.DrawText(tabl.desc, "DebugFixed", 55, 22, color_black)

			return true

		end
	end

	for i = 1, #achievementlist do
		local tabl = achievementlist[i]
		local iscompleted = false
		local cnt = 0
		for i, v in pairs(completedtab) do
			if v.achivid == tabl.name then
				cnt = tonumber(v.count) || 0
				if !tabl.countable then
					iscompleted = true
				else
					if tabl.countnum <= tonumber(v.count) then
						iscompleted = true
					end
				end
				break
			end
		end
		if tabl.secret and !iscompleted then continue end
		local panel = AchievementList:Add("DPanel")
		panel:SetSize(260, 50)
		panel:Dock(TOP)
		local image = Material(tabl.image)
		local gradientcol = Color(70,70,70)
		if !iscompleted then gradientcol = Color(90,0,0) end
		local addon = ""
		if tabl.countable then
			addon = tostring(cnt).."/"..tabl.countnum
		end
		panel.Paint = function(self, w, h)

			draw.RoundedBox(0, 0, 0, w, h, gradientcol)
			surface.SetDrawColor(0,0,0, 255)
			surface.DrawOutlinedRect(0, 0, w, h, 1)

			surface.SetMaterial(gradient)
			surface.SetDrawColor(255,255,255,150)
			surface.DrawTexturedRect(0,0,w,h)

			draw.RoundedBox(0, 0, 0, 50, 50, color_black)

			surface.SetFont("TargetID")
			local x, y = surface.GetTextSize("\""..tabl.achievements_name.."\"")
			surface.SetDrawColor(0,0,0)
			surface.SetMaterial(gradient)
			surface.DrawTexturedRect(0, 5, w, y)

			surface.SetMaterial(image)
			if iscompleted then
				surface.SetDrawColor(255,255,255,255)
			else
				surface.SetDrawColor(255,0,0,255)
			end
			surface.DrawTexturedRect(2,2,46,46)
			local additionaltext = ""
			draw.DrawText("\""..tabl.achievements_name.."\"", "TargetID", 55, 5, color_white)
			draw.DrawText(addon, "TargetID", 55 + x + 5, 5, color_white)
			draw.DrawText(tabl.desc, "DebugFixed", 55, 22, color_black)

			return true

		end
	end



end

local AchievementQuery = AchievementQuery or {}
local nextsound = nextsound or 0

-- Материал для размытия
local blurMaterial = Material("pp/blurscreen")

-- Функция для рисования размытого фона
local function DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local w, h = panel:GetSize()
    
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(blurMaterial)
    
    for i = 1, 3 do
        blurMaterial:SetFloat("$blur", (i / 3) * (amount or 5))
        blurMaterial:Recompute()
        
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
end

function AchievementNotification(data)
    local multiplier = #AchievementQuery + 1
    
    if nextsound < CurTime() then
        if data.secret then
            surface.PlaySound("rxsend/achievement/secret_achievement_unlock.ogg")
        else
            surface.PlaySound("rxsend/achievement/achievement_unlock.ogg")
        end
        nextsound = CurTime() + 2
    end
    
    local AchievementPanel = vgui.Create("DPanel")
    AchievementPanel:SetSize(260, 50)
    
    -- Начальная позиция за экраном
    local targetX = ScrW() - 264
    local targetY = ScrH() / 2 - 50 * multiplier - 5
    AchievementPanel:SetPos(ScrW(), targetY)
    
    -- Устанавливаем Z позицию для отображения поверх других элементов
    AchievementPanel:SetZPos(32767)
    
    local image = Material(data.image)
    local gradientcol = Color(70, 70, 70, 200)
    if data.secret then gradientcol = Color(0, 0, 0, 200) end
    
    AchievementPanel.dietime = CurTime() + 7
    AchievementPanel.animStage = 0
    AchievementPanel.shakeOffset = 0
    AchievementPanel.shakeDirection = 1
    AchievementPanel.targetX = targetX
    AchievementPanel.targetY = targetY
    AchievementPanel.enterStart = CurTime()  -- Время начала появления
    AchievementPanel.exitStart = nil         -- Время начала ухода
    AchievementPanel.shakeTime = CurTime()   -- Время следующего дрожания
    
    AchievementPanel.Paint = function(self, w, h)
        if self.dietime <= CurTime() and self.animStage == 2 then
            self:Remove()
            return
        end
        
        -- Рисуем размытый фон
        DrawBlur(self, 5)
        
        -- Полупрозрачный темный фон поверх размытия
        draw.RoundedBox(0, 0, 0, w, h, gradientcol)
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        
        -- Иконка достижения
        draw.RoundedBox(0, 0, 0, 50, 50, color_black)
        surface.SetMaterial(image)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(2, 2, 46, 46)
        
        -- Текст
        draw.DrawText("Открыто новое достижение:", "TargetID", 55, 5, color_white)
        draw.DrawText("\"" .. data.achievements_name .. "\"", "TargetID", 55, 22, color_white)
        
        return true
    end
    
    -- Сложная анимация появления
    AchievementPanel.Think = function(self)
        if self.animStage == 0 then
            -- Этап 0: Плавный вход (1.5 секунды)
            local progress = (CurTime() - self.enterStart) / 1.5
            
            if progress >= 1 then
                -- Достигли целевой позиции
                self:SetPos(self.targetX, self.targetY)
                self.animStage = 1
                self.shakeTime = CurTime() + 0.1
                self.shakeCount = 0
                self.shakeOffset = 2
                return
            end
            
            -- Кубическое замедление в конце (ease-out)
            local easeOut = progress * progress * progress
            
            -- Дрожание во время движения (увеличивается к концу)
            local shakeIntensity = progress * 2  -- Увеличивается к концу движения
            local shakeX = math.sin(CurTime() * 20) * shakeIntensity
            local shakeY = math.cos(CurTime() * 15) * shakeIntensity
            
            -- Плавное движение с дрожанием
            local startX = ScrW()
            local newX = startX + (self.targetX - startX) * easeOut
            local newY = self.targetY + shakeY
            
            self:SetPos(newX + shakeX, newY)
            
        elseif self.animStage == 1 then
            -- Этап 1: Дрожание после появления
            if CurTime() < self.shakeTime then return end
            
            local currentX = self.targetX
            local currentY = self.targetY
            
            if self.shakeCount < 3 then
                -- Дрожание в разные стороны
                local offsetX = math.random(-self.shakeOffset, self.shakeOffset)
                local offsetY = math.random(-self.shakeOffset, self.shakeOffset)
                
                self:SetPos(currentX + offsetX, currentY + offsetY)
                self.shakeCount = self.shakeCount + 1
                self.shakeTime = CurTime() + 0.05
                self.shakeOffset = self.shakeOffset * 0.7 -- Уменьшаем амплитуду дрожания
            else
                -- Возвращаем на место и переходим к паузе
                self:SetPos(currentX, currentY)
                self.animStage = 2
                self.pauseEnd = CurTime() + 3 -- Пауза перед уходом (3 секунды)
            end
            
        elseif self.animStage == 2 then
            -- Этап 2: Пауза перед уходом
            if CurTime() >= self.pauseEnd then
                self.animStage = 3
                self.shakeTime = CurTime() + 0.1
                self.shakeCount = 0
                self.shakeOffset = 1
            end
            
        elseif self.animStage == 3 then
            -- Этап 3: Дрожание перед уходом
            if CurTime() < self.shakeTime then return end
            
            local currentX = self.targetX
            local currentY = self.targetY
            
            if self.shakeCount < 2 then
                -- Легкое дрожание
                local offsetX = math.random(-self.shakeOffset, self.shakeOffset)
                local offsetY = math.random(-self.shakeOffset, self.shakeOffset)
                
                self:SetPos(currentX + offsetX, currentY + offsetY)
                self.shakeCount = self.shakeCount + 1
                self.shakeTime = CurTime() + 0.08
            else
                -- Начинаем уход
                self:SetPos(currentX, currentY)
                self.animStage = 4
                self.exitStart = CurTime()
            end
            
        elseif self.animStage == 4 then
            -- Этап 4: Плавный уход с дрожанием (1.5 секунды, симметрично появлению)
            local progress = (CurTime() - self.exitStart) / 1.5
            
            if progress >= 1 then
                self:Remove()
                return
            end
            
            -- Кубическое ускорение в конце (ease-in)
            local easeIn = progress * progress * progress
            
            -- Дрожание во время движения (уменьшается к концу)
            local shakeIntensity = (1 - progress) * 2  -- Уменьшается по мере движения
            local shakeX = math.sin(CurTime() * 20) * shakeIntensity
            local shakeY = math.cos(CurTime() * 15) * shakeIntensity
            
            -- Плавное движение вправо с дрожанием
            local endX = ScrW()
            local newX = self.targetX + (endX - self.targetX) * easeIn
            local newY = self.targetY + shakeY
            
            self:SetPos(newX + shakeX, newY)
        end
    end
    
    local tyb = {
        dietime = CurTime() + 7,
        panel = AchievementPanel,
    }
    table.insert(AchievementQuery, tyb)
end

-- Хук для очистки невалидных панелей
local nextcheck = 0
hook.Add("Think", "BreachAchievement_Think", function()
    if nextcheck < CurTime() then
        for i = #AchievementQuery, 1, -1 do
            local achievementtable = AchievementQuery[i]
            if not achievementtable or not IsValid(achievementtable.panel) then
                table.remove(AchievementQuery, i)
            end
        end
        nextcheck = CurTime() + 1
    end
end)

net.Receive("OpenAchievementMenu", function()
	local readentity = net.ReadEntity()
	local readtable = net.ReadTable()
	local completedtable = net.ReadTable()
	OpenAchievementList(readentity, readtable, completedtable)
end)

net.Receive("AchievementBar", function()

	local tab = net.ReadTable()
	AchievementNotification(tab)

end)