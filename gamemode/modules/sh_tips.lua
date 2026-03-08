if CLIENT then
  surface.CreateFont( "Cyb_HudTEXT",
  {
    font = "Segoe UI",
    size = 25,
    weight = 550,
  })
  local UpdateDelay = 0

  net.Receive( "Shaky_TipSend", function()

    local icontype = net.ReadUInt( 2 )
    local str1 = net.ReadString()
    local col1 = net.ReadColor()
    local str2 = net.ReadString()
    local col2 = net.ReadColor()
	
	   str2 = BREACH.TranslateString(str2)

    timer.Simple( UpdateDelay, function()

      MakeTip( icontype, str1, col1, str2, col2 )

      if ( UpdateDelay != 1 ) then

        UpdateDelay = math.Clamp( UpdateDelay - 1, 0, 100 )

      end

    end )

    UpdateDelay = UpdateDelay + 1

  end)

  local TipPanels = TipPanels or {}

-- Материал для размытия
local blurMaterial = Material("pp/blurscreen")

-- Материалы иконок (можно добавить другие типы)
local iconMaterials = {
    default = Material("nextoren/gui/icons/notifications/breachiconfortips.png"),
    -- Добавьте другие типы иконок по мере необходимости
    -- warning = Material("path/to/warning_icon.png"),
    -- error = Material("path/to/error_icon.png"),
    -- info = Material("path/to/info_icon.png"),
}

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

function MakeTip(icontype, str1, col1, str2, col2)
    local lang1 = str1 or ""
    local lang2 = str2 or ""
    
    -- Получаем иконку по типу или используем дефолтную
    local maticon = iconMaterials[icontype] or iconMaterials.default
    
    surface.SetFont("Cyb_HudTEXT")
    local s1 = surface.GetTextSize(lang1)
    local s2 = surface.GetTextSize(lang2)
    
    if lang2 == "" then
        s2 = 0
    end
    
    -- Рассчитываем размер панели
    local minWidth = 260
    local calculatedWidth = s1 + s2 + 100
    local panelWidth = calculatedWidth < minWidth and minWidth or calculatedWidth
    local panelHeight = 64
    
    -- Создаем панель
    local tippanel = vgui.Create("DPanel")
    TipPanels[#TipPanels + 1] = tippanel
    
    tippanel:SetSize(panelWidth, panelHeight)
    tippanel:SetZPos(32767) -- Высокий Z-позиция для отображения поверх
    
    -- Позиционирование с учетом других уведомлений
    local screenwidth = ScrW()
    local screenheight = ScrH()
    
    -- Вычисляем целевую позицию с учетом стека уведомлений
    local multiplier = #TipPanels
    local targetX = screenwidth - panelWidth - 10
    local targetY = screenheight / 1.2 - panelHeight * multiplier - 10 * (multiplier - 1)
    
    -- Начальная позиция за экраном справа
    tippanel:SetPos(screenwidth, targetY)
    
    -- Переменные для анимации
    tippanel.dietime = CurTime() + 5
    tippanel.animStage = 0
    tippanel.shakeOffset = 0
    tippanel.targetX = targetX
    tippanel.targetY = targetY
    tippanel.enterStart = CurTime()
    tippanel.exitStart = nil
    tippanel.shakeTime = CurTime()
    tippanel.originalY = targetY -- Сохраняем оригинальную Y позицию для корректировки
    
    -- Цвета
    col1 = col1 or color_white
    col2 = col2 or color_white
    local gradientcol = Color(48, 49, 54, 155) -- Сохраняем оригинальный цвет
    local iconBgColor = Color(0, 0, 0, 135)
    
    -- Обновляем позиции всех панелей при появлении новой
    tippanel.Think = function(self)
        -- Анимация появления/исчезновения
        if self.animStage == 0 then
            -- Этап 0: Плавный вход (0.8 секунды)
            local progress = (CurTime() - self.enterStart) / 0.8
            
            if progress >= 1 then
                -- Достигли целевой позиции
                self:SetPos(self.targetX, self.targetY)
                self.animStage = 1
                self.shakeTime = CurTime() + 0.05
                self.shakeCount = 0
                self.shakeOffset = 1
                return
            end
            
            -- Кубическое замедление в конце
            local easeOut = progress * progress * progress
            
            -- Легкое дрожание при появлении
            local shakeIntensity = progress * 1.5
            local shakeX = math.sin(CurTime() * 25) * shakeIntensity
            local shakeY = math.cos(CurTime() * 20) * shakeIntensity
            
            -- Плавное движение с дрожанием
            local startX = screenwidth
            local newX = startX + (self.targetX - startX) * easeOut
            local newY = self.targetY + shakeY
            
            self:SetPos(newX + shakeX, newY)
            
        elseif self.animStage == 1 then
            -- Этап 1: Дрожание после появления
            if CurTime() < self.shakeTime then return end
            
            local currentX = self.targetX
            local currentY = self.targetY
            
            if self.shakeCount < 2 then
                -- Легкое дрожание
                local offsetX = math.random(-self.shakeOffset, self.shakeOffset)
                local offsetY = math.random(-self.shakeOffset, self.shakeOffset)
                
                self:SetPos(currentX + offsetX, currentY + offsetY)
                self.shakeCount = self.shakeCount + 1
                self.shakeTime = CurTime() + 0.03
                self.shakeOffset = self.shakeOffset * 0.5
            else
                -- Возвращаем на место и переходим к паузе
                self:SetPos(currentX, currentY)
                self.animStage = 2
                self.pauseEnd = CurTime() + 3 -- Пауза 3 секунды
            end
            
        elseif self.animStage == 2 then
            -- Этап 2: Пауза перед уходом
            if CurTime() >= self.pauseEnd then
                self.animStage = 3
                self.shakeTime = CurTime() + 0.08
                self.shakeCount = 0
                self.shakeOffset = 0.5
            end
            
            -- Сдвигаем другие уведомления вниз
            local myIndex = table.KeyFromValue(TipPanels, self)
            if myIndex then
                for i = myIndex + 1, #TipPanels do
                    local otherPanel = TipPanels[i]
                    if IsValid(otherPanel) then
                        local otherX, otherY = otherPanel:GetPos()
                        local targetY = self.originalY + panelHeight + 10
                        
                        if otherPanel.animStage == 2 and math.abs(otherY - targetY) > 1 then
                            otherPanel:MoveTo(otherX, targetY, 0.3, 0, 0.5)
                        end
                    end
                end
            end
            
        elseif self.animStage == 3 then
            -- Этап 3: Дрожание перед уходом
            if CurTime() < self.shakeTime then return end
            
            local currentX = self.targetX
            local currentY = self.targetY
            
            if self.shakeCount < 1 then
                -- Очень легкое дрожание
                local offsetX = math.random(-self.shakeOffset, self.shakeOffset)
                local offsetY = math.random(-self.shakeOffset, self.shakeOffset)
                
                self:SetPos(currentX + offsetX, currentY + offsetY)
                self.shakeCount = self.shakeCount + 1
                self.shakeTime = CurTime() + 0.05
            else
                -- Начинаем уход
                self:SetPos(currentX, currentY)
                self.animStage = 4
                self.exitStart = CurTime()
            end
            
        elseif self.animStage == 4 then
            -- Этап 4: Плавный уход (0.8 секунды)
            local progress = (CurTime() - self.exitStart) / 0.8
            
            if progress >= 1 then
                table.RemoveByValue(TipPanels, self)
                self:Remove()
                return
            end
            
            -- Кубическое ускорение
            local easeIn = progress * progress * progress
            
            -- Легкое дрожание при уходе
            local shakeIntensity = (1 - progress) * 1
            local shakeX = math.sin(CurTime() * 25) * shakeIntensity
            local shakeY = math.cos(CurTime() * 20) * shakeIntensity
            
            -- Плавное движение вправо
            local endX = screenwidth
            local newX = self.targetX + (endX - self.targetX) * easeIn
            local newY = self.targetY + shakeY
            
            self:SetPos(newX + shakeX, newY)
            
            -- Сдвигаем другие уведомления вверх
            local myIndex = table.KeyFromValue(TipPanels, self)
            if myIndex then
                for i = myIndex + 1, #TipPanels do
                    local otherPanel = TipPanels[i]
                    if IsValid(otherPanel) then
                        local otherX, otherY = otherPanel:GetPos()
                        local targetY = otherPanel.originalY - panelHeight - 10
                        
                        if otherPanel.animStage == 2 and math.abs(otherY - targetY) > 1 then
                            otherPanel:MoveTo(otherX, targetY, 0.3, 0, 0.5)
                        end
                    end
                end
            end
        end
    end
    
    -- Таймер для автоудаления
    timer.Simple(6, function()
        if IsValid(tippanel) and tippanel.animStage == 2 then
            tippanel.animStage = 3
            tippanel.shakeTime = CurTime() + 0.08
            tippanel.shakeCount = 0
            tippanel.shakeOffset = 0.5
        end
    end)
    
    -- Отрисовка панели
    tippanel.Paint = function(self, w, h)
        if not self or not self:IsValid() then return end
        
        -- Рисуем размытый фон
        DrawBlur(self, 3) -- Меньшее размытие для лучшей производительности
        
        -- Основной фон (полупрозрачный)
        draw.RoundedBox(8, 0, 7, w, 50, gradientcol)
        
        -- Фон для иконки (с закруглением слева)
        draw.RoundedBoxEx(8, 0, 7, 55, 50, iconBgColor, true, false, true, false)
        
        -- Черная обводка
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawOutlinedRect(0, 7, w, 50, 1)
        
        -- Текст
        draw.SimpleText(lang1, "Cyb_HudTEXT", 65, 32, col1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        
        if lang2 ~= "" then
            draw.SimpleText(" " .. lang2, "Cyb_HudTEXT", 65 + s1, 32, col2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        return true
    end
    
    -- Иконка
    local tipicon = vgui.Create("DImage", tippanel)
    tipicon:SetMaterial(maticon)
    tipicon:SetSize(54, 54)
    tipicon:SetPos(0, 6)
end

-- Функция для поиска ключа по значению в таблице
if not table.KeyFromValue then
    function table.KeyFromValue(tbl, value)
        for k, v in pairs(tbl) do
            if v == value then
                return k
            end
        end
        return nil
    end
end

-- Хук для очистки невалидных панелей
local nextcheck = 0
hook.Add("Think", "TipPanels_Cleanup", function()
    if nextcheck < CurTime() then
        for i = #TipPanels, 1, -1 do
            if not TipPanels[i] or not IsValid(TipPanels[i]) then
                table.remove(TipPanels, i)
            end
        end
        nextcheck = CurTime() + 1
    end
end)
else
  util.AddNetworkString("Shaky_TipSend")
  local mply = FindMetaTable("Player")
  function mply:BrTip(icontype, str1, col1, str2, col2)
    net.Start("Shaky_TipSend", true)
      net.WriteUInt(icontype, 2)
      net.WriteString(str1)
      net.WriteColor(col1)
      net.WriteString(str2)
      net.WriteColor(col2)
    net.Send(self)
  end
end