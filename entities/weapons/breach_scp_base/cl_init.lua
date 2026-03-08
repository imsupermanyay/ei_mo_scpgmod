
include( "shared.lua" )

--BREACH.Abilities = BREACH.Abilities || {}

local clrgray = Color( 198, 198, 198 )
local clrgray2 = Color( 180, 180, 180 )
local clrred = Color( 255, 0, 0 )
local clrred2 = Color( 198, 0, 0 )
local blackalpha = Color( 0, 0, 0, 180 )

local function ForbidTalant()

  local is_forbidden = net.ReadBool()
  local talant_id = net.ReadUInt( 4 )

  if ( !IsValid( BREACH.Abilities ) || #BREACH.Abilities.Buttons == 0 ) then return end

  LocalPlayer():GetActiveWeapon().AbilityIcons[ talant_id ].Forbidden = is_forbidden


end
net.Receive( "ForbidTalant", ForbidTalant )

local function Ability_ClientsideCooldown()

  local abilityid = net.ReadUInt( 4 )
  local cooldown = net.ReadFloat()
  local wep = net.ReadEntity()

  wep.AbilityIcons[ abilityid ].CooldownTime = CurTime() + cooldown

end
net.Receive( "Ability_ClientsideCooldown", Ability_ClientsideCooldown )

local function ShowAbilityDesc( name, text, cooldown, x, y )

  if ( IsValid( BREACH.Abilities.TipWindow ) ) then

    BREACH.Abilities.TipWindow:Remove()

  end

  surface.SetFont( "HUDFont" )
  local stringwidth, stringheight = surface.GetTextSize( text )
  BREACH.Abilities.TipWindow = vgui.Create( "DPanel" )
  BREACH.Abilities.TipWindow:SetAlpha( 0 )
  BREACH.Abilities.TipWindow:SetPos( x + 10, ScrH() - 80  )
  BREACH.Abilities.TipWindow:SetSize( 180, stringheight + 76 )
  BREACH.Abilities.TipWindow:SetText( "" )
  BREACH.Abilities.TipWindow:MakePopup()
  BREACH.Abilities.TipWindow.Paint = function( self, w, h )

    if ( !vgui.CursorVisible() ) then

      self:Remove()

    end

    self:SetPos( gui.MouseX() + 15, gui.MouseY() )
    if ( self && self:IsValid() && self:GetAlpha() <= 0 ) then

      self:SetAlpha( 255 )

    end
    DrawBlurPanel( self )
    draw.OutlinedBox( 0, 0, w, h, 2, clrgray2 )
    drawMultiLine( name, "HUDFont", w, 16, 5, 0, clrred, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

    local namewidth, nameheight = surface.GetTextSize( name )
    drawMultiLine( text, "HUDFont", 170, 16, 5, nameheight + 5, clrgray, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )

    local line_height = nameheight * 1.15

    surface.DrawLine( 0, line_height, w, line_height )
    surface.DrawLine( 0, line_height + 1, w, line_height + 1 )

    draw.SimpleTextOutlined( cooldown, "HUDFont", w - 8, 3, clrred2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT, 1, blackalpha )

  end

end

local scp_team_index = TEAM_SCP
local darkgray = Color( 105, 105, 105 )

local scp_team_index = TEAM_SCP
local darkgray = Color(105, 105, 105)
local scpAbilityAnims = {}

function SWEP:ChooseAbility(table)
    if (IsValid(BREACH.Abilities)) then
        BREACH.Abilities:Remove()
    end

    BREACH.Abilities = vgui.Create("DPanel")
    BREACH.Abilities.AbilityIcons = table
    local numAbilities = #BREACH.Abilities.AbilityIcons
    
    -- Инициализация анимаций для каждой способности
    scpAbilityAnims = {}
    for i = 1, numAbilities do
        scpAbilityAnims[i] = {
            press = 0,
            cooldown = 0,
            hover = 0,
            readyPulse = 0,
            scale = 1,
            appear = 0
        }
    end

    BREACH.Abilities:SetPos(ScrW() / 2 - (32 * numAbilities), ScrH() / 1.2)
    BREACH.Abilities:SetSize(64 * numAbilities, 64)
    BREACH.Abilities:SetText("")
    BREACH.Abilities.SCP_Name = LocalPlayer():GetRoleName()
    BREACH.Abilities.Alpha = 0
    BREACH.Abilities.CreationTime = CurTime()

    BREACH.Abilities.Think = function(self)
        local currentTime = CurTime()
        
        -- Анимация появления всей панели
        if self.CreationTime < (currentTime - 4) then
            for i = 1, numAbilities do
                scpAbilityAnims[i].appear = Lerp(FrameTime() * 6, scpAbilityAnims[i].appear, 1)
            end
            self.Alpha = scpAbilityAnims[1].appear * 255
            self:SetAlpha(self.Alpha)
        end
    end

    BREACH.Abilities.Paint = function(self, w, h)
        local client = LocalPlayer()

        if (client:Health() <= 0 || client:GetRoleName() != self.SCP_Name) then
            self:Remove()
            return
        end
    end

    BREACH.Abilities.OnRemove = function()
        gui.EnableScreenClicker(false)
        if (IsValid(BREACH.Abilities) && IsValid(BREACH.Abilities.TipWindow)) then
            BREACH.Abilities.TipWindow:Remove()
        end
    end

    for i = 1, numAbilities do
        BREACH.Abilities.Buttons = BREACH.Abilities.Buttons || {}
        BREACH.Abilities.Buttons[i] = vgui.Create("DButton", BREACH.Abilities)
        BREACH.Abilities.Buttons[i]:SetPos(64 * (i - 1), 0)
        BREACH.Abilities.Buttons[i]:SetSize(64, 64)
        BREACH.Abilities.Buttons[i]:SetText("")
        BREACH.Abilities.Buttons[i].ID = i
        BREACH.Abilities.Buttons[i]:SetAlpha(0) -- Начальная невидимость

        -- Think функция для анимаций каждой кнопки
        BREACH.Abilities.Buttons[i].Think = function(self)
            local client = LocalPlayer()
            local abilityData = BREACH.Abilities.AbilityIcons[i]
            local anim = scpAbilityAnims[i]
            local currentTime = CurTime()

            -- Устанавливаем альфу кнопки в зависимости от анимации появления
            self:SetAlpha(anim.appear * 255)

            -- Определение нажатия клавиши
            local press = false
            local c_key = abilityData.KEY
            
            if (isnumber(c_key) && input.IsKeyDown(c_key) && !client:IsTyping()) then
                press = true
            end

            if (c_key == "RMB" or c_key == 108) and input.IsMouseDown(MOUSE_RIGHT) then
                press = true
            end

            if (c_key == "LMB" or c_key == 107) and input.IsMouseDown(MOUSE_LEFT) then
                press = true
            end

            -- Анимация нажатия
            if press then
                anim.press = Lerp(FrameTime() * 15, anim.press, 1)
                anim.scale = Lerp(FrameTime() * 20, anim.scale, 0.85)
            else
                anim.press = Lerp(FrameTime() * 8, anim.press, 0)
                anim.scale = Lerp(FrameTime() * 12, anim.scale, 1)
            end

            -- Анимация наведения
            if self:IsHovered() then
                anim.hover = Lerp(FrameTime() * 8, anim.hover, 1)
            else
                anim.hover = Lerp(FrameTime() * 6, anim.hover, 0)
            end

            -- Анимация отката КД
            local cdTime = (abilityData.CooldownTime || 0) - currentTime
            if cdTime > 0 then
                anim.cooldown = Lerp(FrameTime() * 6, anim.cooldown, 1)
            else
                anim.cooldown = Lerp(FrameTime() * 4, anim.cooldown, 0)
            end

            -- Пульсация когда способность готова
            if cdTime <= 0 and abilityData.Using and not abilityData.Forbidden then
                anim.readyPulse = math.sin(currentTime * 2) * 0.3 + 0.7
            else
                anim.readyPulse = Lerp(FrameTime() * 5, anim.readyPulse, 1)
            end
        end

        BREACH.Abilities.Buttons[i].OnCursorEntered = function(self)
            -- Не показывать подсказку, если кнопка еще не появилась
            if scpAbilityAnims[i].appear < 0.9 then return end
            
            ShowAbilityDesc(BREACH.Abilities.AbilityIcons[i].Name, 
                          BREACH.Abilities.AbilityIcons[i].Description, 
                          BREACH.Abilities.AbilityIcons[i].Cooldown, 
                          gui.MouseX(), (gui.MouseY() || 5))
        end

        BREACH.Abilities.Buttons[i].OnCursorExited = function()
            if (BREACH.Abilities.TipWindow && BREACH.Abilities.TipWindow:Remove()) then
                BREACH.Abilities.TipWindow:Remove()
            end
        end

        BREACH.Abilities.Buttons[i].DoClick = function() end

        local iconmaterial = Material(BREACH.Abilities.AbilityIcons[i].Icon)
        local key = BREACH.Abilities.AbilityIcons[i].KEY
        local c_key

        if (isnumber(key)) then
            c_key = key
            key = string.upper(input.GetKeyName(key))
        end

        surface.SetFont("ImpactSmall2n")
        local text_sizew = surface.GetTextSize(key) + 16

        BREACH.Abilities.Buttons[i].Paint = function(self, w, h)
            local client = LocalPlayer()
            local abilityData = BREACH.Abilities.AbilityIcons[i]
            local anim = scpAbilityAnims[i]

            if (!BREACH.Abilities || !abilityData) then
                self:Remove()
                return
            end

            local currentAlpha = anim.appear
            local currentScale = anim.scale
            
            -- Если анимация появления еще не завершена, используем масштабирование для эффекта появления
            local appearScale = 0.3 + anim.appear * 0.7 -- Начинаем с 30% размера
            local finalScale = currentScale * appearScale
            
            local finalW = w * finalScale
            local finalH = h * finalScale
            local finalX = (w - finalW) / 2
            local finalY = (h - finalH) / 2

            -- Фон с обводкой (тоже анимируем появление)
            local bgAlpha = 200 * currentAlpha
            local bgColor = Color(40, 40, 40, bgAlpha)
            draw.RoundedBox(8, finalX, finalY, finalW, finalH, bgColor)

            -- Обводка при наведении (только когда полностью появилась)
            if anim.hover > 0 and currentAlpha > 0.9 then
                local outlineColor = Color(255, 255, 255, 80 * anim.hover * currentAlpha)
                draw.RoundedBox(8, finalX - 2, finalY - 2, finalW + 4, finalH + 4, outlineColor)
            end

            -- Эффект готовности (только когда полностью появилась)
            if anim.readyPulse < 1 and abilityData.Using and not abilityData.Forbidden and currentAlpha > 0.9 then
                local readyColor = Color(255, 255, 255, 30 * (1 - anim.readyPulse) * currentAlpha)
                draw.RoundedBox(8, finalX - 1, finalY - 1, finalW + 2, finalH + 2, readyColor)
            end

            -- Основная иконка (альфа зависит от анимации появления)
            local iconAlpha = 255 * currentAlpha
            if anim.press > 0 then
                surface.SetDrawColor(200, 200, 200, iconAlpha)
            else
                surface.SetDrawColor(255, 255, 255, iconAlpha)
            end
            
            surface.SetMaterial(iconmaterial)
            surface.DrawTexturedRect(finalX, finalY, finalW, finalH)

            -- Overlay нажатия
            if anim.press > 0 then
                local pressAlpha = 80 * anim.press * currentAlpha
                draw.RoundedBox(8, finalX, finalY, finalW, finalH, Color(0, 0, 0, pressAlpha))
            end

            -- Откат КД или заблокированная способность
            local cdTime = (abilityData.CooldownTime || 0) - CurTime()
            if cdTime > 0 || abilityData.Forbidden then
                local cdAlpha = 190 * anim.cooldown * currentAlpha
                draw.RoundedBox(8, finalX, finalY, finalW, finalH, ColorAlpha(darkgray, cdAlpha))

                -- Текст с откатом
                if cdTime > 0 then
                    local cdText = math.Round(cdTime, 1)
                    draw.SimpleTextOutlined(
                        cdText, 
                        "ImpactSmall2n", 
                        w / 2, 
                        h / 2, 
                        Color(255, 255, 255, 255 * currentAlpha), 
                        TEXT_ALIGN_CENTER, 
                        TEXT_ALIGN_CENTER, 
                        2, 
                        Color(0, 0, 0, 150 * currentAlpha)
                    )
                end
            end

            -- Клавиша активации (появляется вместе с иконкой)
            if currentAlpha > 0.5 then -- Показываем клавишу только когда иконка достаточно видима
                local keyAlpha = 255 * currentAlpha
                draw.SimpleTextOutlined(
                    key, 
                    "ImpactSmall2n", 
                    w - 6, 
                    8, 
                    Color(255, 255, 255, keyAlpha), 
                    TEXT_ALIGN_RIGHT, 
                    TEXT_ALIGN_TOP, 
                    1, 
                    Color(0, 0, 0, 150 * currentAlpha)
                )
            end

            -- Специальная логика для SCP973
            if abilityData.Forbidden and currentAlpha > 0.5 then
                if (client:GetRoleName() != "SCP973") then return end

                local primary_wep = client:GetWeapon("weapon_scp_973")
                if (!(primary_wep && primary_wep:IsValid())) then return end

                local number_cooldown = tonumber(abilityData.Cooldown)
                if ((primary_wep:GetRage() || 0) < number_cooldown) then
                    local value = math.Round(number_cooldown - primary_wep:GetRage())
                    draw.SimpleTextOutlined(
                        value, 
                        "ImpactSmall2n", 
                        w / 2, 
                        h / 2, 
                        Color(255, 255, 255, 210 * currentAlpha), 
                        TEXT_ALIGN_CENTER, 
                        TEXT_ALIGN_CENTER, 
                        2, 
                        Color(0, 0, 0, 150 * currentAlpha)
                    )
                end
            end

            -- Кастомная отрисовка
            if (self.PaintOverride && isfunction(self.PaintOverride)) then
                self:PaintOverride(w, h)
                return
            end
        end
    end
end

function SWEP:OnRemove()

  if ( self.RemoveCustomFunc && isfunction( self.RemoveCustomFunc ) ) then

    self.RemoveCustomFunc()

  end

end

function SWEP:Holster()

  if ( self.RemoveCustomFunc && isfunction( self.RemoveCustomFunc ) ) then

    self.RemoveCustomFunc()

  end

end

function SWEP:DrawHUD()

  if ( !IsValid( BREACH.Abilities ) ) then

    self:ChooseAbility( self.AbilityIcons )

  end

  if ( input.IsKeyDown( KEY_F3 ) && ( self.NextPush || 0 ) <= CurTime() ) then

    self.NextPush = CurTime() + .5
    gui.EnableScreenClicker( !vgui.CursorVisible() )

  end

end
