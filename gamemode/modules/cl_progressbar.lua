ProgressName = ProgressName || "N/A"
ProgressTime = ProgressTime || 0
ProgressRunning = ProgressRunning || false

local progressAnim = {
    scale = 0,
    alpha = 0,
    state = "hidden",
    bars = {}
}

function MakeProgressBar()
    ProgressName = BREACH.TranslateString(net.ReadString())
    ProgressTime = net.ReadFloat()
    ProgressIcon = net.ReadString()

    PaintProgress()
end
net.Receive("StartBreachProgressBar", MakeProgressBar)

net.Receive("progressbarstate", function()
    local client = LocalPlayer()
    
    if (!IsValid(client.progressbar)) then return end

    local state = net.ReadBool()

    if (state) then
        client.progressbar.progress_time = 100
        progressAnim.state = "success"
        progressAnim.successTime = CurTime()
    else
        client.progressbar.failed = true
        progressAnim.state = "failed"
        progressAnim.failedTime = CurTime()
    end
end)

local successclr = Color(0, 255, 0, 180)
local stopclr = Color(255, 0, 0)
local valuesicons = Material("nextoren_hud/ico_index2.png")
local newrr = Material("nextoren_hud/round_box_3_r.png")
local newrl = Material("nextoren_hud/round_box_3_l.png")

local function CreateProgressBar(client, screenwidth, screenheight, time)
    ProgressRunning = true

    progressAnim = {
        scale = 0,
        alpha = 0,
        state = "appearing",
        startTime = CurTime(),
        bars = {}
    }

    for i = 1, 29 do
        progressAnim.bars[i] = {
            scale = 0,
            alpha = 0,
            pop = 0,
            active = false
        }
    end

    client.progressbar = vgui.Create("DPanel")
    client.progressbar:SetSize(400, 45)
    client.progressbar:SetPos(screenwidth / 2 - 200, screenheight - 250)
    client.progressbar.name = ProgressName
    client.progressbar.Color = color_white
    client.progressbar.progress_time = 0
    client.progressbar.end_time = CurTime()
    client.progressbar.time_reach = time
    client.progressbar.complete = false
    client.progressbar.failed = false
    client.progressbar.alpha = 0
    client.progressbar.scale = 0

    client.progressbar.Think = function(self)
        local currentTime = CurTime()
        
        if progressAnim.state == "appearing" then
            local elapsed = currentTime - progressAnim.startTime
            if elapsed < 0.5 then
                progressAnim.scale = Lerp(FrameTime() * 12, progressAnim.scale, 1)
                progressAnim.alpha = Lerp(FrameTime() * 10, progressAnim.alpha, 1)
                self.alpha = progressAnim.alpha
                self.scale = progressAnim.scale
            else
                progressAnim.state = "visible"
                progressAnim.scale = 1
                progressAnim.alpha = 1
                self.alpha = 1
                self.scale = 1
            end
        end

        if progressAnim.state == "success" then
            local successElapsed = currentTime - progressAnim.successTime
            if successElapsed < 0.8 then
                progressAnim.scale = 1 + math.sin(successElapsed * 10) * 0.1
                if successElapsed > 0.5 then
                    progressAnim.state = "disappearing"
                    progressAnim.disappearStartTime = currentTime
                end
            end
        end

        if progressAnim.state == "failed" then
            local failedElapsed = currentTime - progressAnim.failedTime
            if failedElapsed < 0.8 then
                progressAnim.scale = 1 + math.sin(failedElapsed * 20) * 0.05
                if failedElapsed > 0.5 then
                    progressAnim.state = "disappearing"
                    progressAnim.disappearStartTime = currentTime
                end
            end
        end

        if progressAnim.state == "disappearing" then
            local disappearElapsed = currentTime - progressAnim.disappearStartTime
            if disappearElapsed < 0.5 then
                progressAnim.scale = Lerp(FrameTime() * 10, progressAnim.scale, 0)
                progressAnim.alpha = Lerp(FrameTime() * 8, progressAnim.alpha, 0)
                self.alpha = progressAnim.alpha
                self.scale = progressAnim.scale
            else
                self:SetVisible(false)
                if IsValid(client.progressbaricon) then
                    client.progressbaricon:SetVisible(false)
                end
            end
        end

        if (ProgressRunning) then
            self.progress_time = math.Clamp(-(self.end_time - CurTime()) / self.time_reach * 100, 0, 100)
        end

        local currentBars = math.Clamp(math.ceil(29 * (self.progress_time / 100)), 0, 29)
        
        for i = 1, 29 do
            local bar = progressAnim.bars[i]
            
            if i <= currentBars then
                if not bar.active then
                    bar.active = true
                    bar.scale = 0
                    bar.alpha = 0
                    bar.pop = 0
                end
                
                if bar.scale < 1 then
                    bar.scale = Lerp(FrameTime() * 15, bar.scale, 1)
                end
                if bar.alpha < 1 then
                    bar.alpha = Lerp(FrameTime() * 12, bar.alpha, 1)
                end
            else
                if bar.active then
                    bar.active = false
                    bar.pop = 0
                end
                
                if bar.scale > 0 then
                    bar.pop = Lerp(FrameTime() * 18, bar.pop, 1)
                    if bar.pop > 0.7 then
                        bar.scale = Lerp(FrameTime() * 20, bar.scale, 0)
                        bar.alpha = Lerp(FrameTime() * 15, bar.alpha, 0)
                    end
                end
            end
        end
    end

    client.progressbar.Paint = function(self, w, h)
        if (screenwidth != ScrW() || screenheight != ScrH()) then
            screenwidth = ScrW()
            screenheight = ScrH()
        end

        local currentAlpha = self.alpha * 255
        local currentScale = self.scale
        
        local scaledW = w * currentScale
        local scaledH = h * currentScale
        local offsetX = (w - scaledW) / 2
        local offsetY = (h - scaledH) / 2

        surface.SetDrawColor(255, 255, 255, currentAlpha)
        surface.SetMaterial(newrl)
        surface.DrawTexturedRect(5 + offsetX, h-30 + offsetY, 29 * currentScale, 29 * currentScale)

        if (ProgressRunning && self.progress_time == 100) then
            self.name = L"l:progress_done"
            self.Color = successclr
            ProgressRunning = nil

            if (!self.complete) then
                self.complete = true
                progressAnim.state = "success"
                progressAnim.successTime = CurTime()
            end

        elseif (ProgressRunning && self.failed) then
            self.name = BREACH.TranslateString("l:progress_stopped")
            self.Color = stopclr
            ProgressRunning = nil

            progressAnim.state = "failed"
            progressAnim.failedTime = CurTime()
        end

        local textColor = Color(self.Color.r, self.Color.g, self.Color.b, currentAlpha)
        draw.SimpleText(self.name, "DermaDefault", 5 + offsetX, 1 + offsetY, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        for i = 1, 29 do
            local bar = progressAnim.bars[i]
            if bar.alpha > 0.01 then
                local xPos = 8 + (i-1) * 13
                local yPos = h - 27
                
                local width = 12 * bar.scale * currentScale
                local height = 24 * bar.scale * currentScale
                local xOffset = (12 - width) / 2
                local yOffset = (24 - height) / 2
                
                if bar.pop > 0 then
                    local popScale = 1 + bar.pop * 0.4
                    width = 12 * bar.scale * currentScale * popScale
                    height = 24 * bar.scale * currentScale * popScale
                    xOffset = (12 - width) / 2
                    yOffset = (24 - height) / 2
                end

                local barColor = Color(255, 255, 255, 100 * bar.alpha * self.alpha)

                if bar.pop > 0.1 then
                    local popAlpha = (1 - bar.pop) * bar.alpha * self.alpha * 0.8
                    local popColor = Color(255, 50, 50, 120 * popAlpha)
                    local popSize = bar.pop * 8
                    
                    draw.RoundedBox(4, 
                        xPos + offsetX + xOffset - popSize/2, 
                        yPos + offsetY + yOffset - popSize/2, 
                        width + popSize, 
                        height + popSize, 
                        popColor)
                end

                draw.RoundedBox(2, 
                    xPos + offsetX + xOffset, 
                    yPos + offsetY + yOffset, 
                    width, height, barColor)
                
                if bar.active and bar.scale > 0.7 and bar.pop == 0 then
                    local glowAlpha = math.sin(RealTime() * 8) * 20 + 30
                    local glowColor = Color(255, 255, 255, glowAlpha * bar.alpha * self.alpha)
                    draw.RoundedBox(2, 
                        xPos + offsetX + xOffset - 1, 
                        yPos + offsetY + yOffset - 1, 
                        width + 2, height + 2, glowColor)
                end
            end
        end

        if progressAnim.state == "success" then
            local successElapsed = CurTime() - progressAnim.successTime
            local pulseAlpha = math.sin(successElapsed * 10) * 50 + 100
            draw.RoundedBox(4, 
                offsetX - 5, offsetY - 5, 
                scaledW + 10, scaledH + 10, 
                Color(0, 255, 0, pulseAlpha * self.alpha)
            )
        elseif progressAnim.state == "failed" then
            local failedElapsed = CurTime() - progressAnim.failedTime
            local shakeX = math.sin(failedElapsed * 30) * 3
            draw.RoundedBox(4, 
                offsetX - 5 + shakeX, offsetY - 5, 
                scaledW + 10, scaledH + 10, 
                Color(255, 0, 0, 50 * self.alpha)
            )
        end
    end

    client.progressbaricon = vgui.Create("DPanel")
    client.progressbaricon:SetSize(64, 64)
    client.progressbaricon:SetPos(screenwidth / 2 - 265, screenheight - 262)
    client.progressbaricon:SetBackgroundColor(color_black)
    client.progressbaricon.icon = Material(ProgressIcon)
    client.progressbaricon.alpha = 0
    client.progressbaricon.scale = 0

    client.progressbaricon.Think = function(self)
        self.alpha = progressAnim.alpha
        self.scale = progressAnim.scale
    end

    client.progressbaricon.Paint = function(self, w, h)
        if (!client.progressbar:IsVisible()) then
            self:SetVisible(false)
        end

        local currentAlpha = self.alpha * 255
        local currentScale = self.scale
        
        local scaledW = w * currentScale
        local scaledH = h * currentScale
        local offsetX = (w - scaledW) / 2
        local offsetY = (h - scaledH) / 2

        surface.SetDrawColor(255, 255, 255, currentAlpha)
        surface.SetMaterial(self.icon || "nextoren/gui/icons/notifications/breachiconfortips.png")
        surface.DrawTexturedRect(offsetX, offsetY, scaledW, scaledH)

        local borderColor = Color(0, 0, 0, currentAlpha)
        draw.RoundedBox(0, offsetX, offsetY, 10 * currentScale, 2 * currentScale, borderColor)
        draw.RoundedBox(0, offsetX, offsetY, 2 * currentScale, 10 * currentScale, borderColor)
        draw.RoundedBox(0, offsetX, offsetY + scaledH - 2 * currentScale, 10 * currentScale, 2 * currentScale, borderColor)
        draw.RoundedBox(0, offsetX, offsetY + scaledH - 10 * currentScale, 2 * currentScale, 10 * currentScale, borderColor)

        draw.RoundedBox(0, offsetX + scaledW - 10 * currentScale, offsetY, 10 * currentScale, 2 * currentScale, borderColor)
        draw.RoundedBox(0, offsetX + scaledW - 2 * currentScale, offsetY, 2 * currentScale, 10 * currentScale, borderColor)

        draw.RoundedBox(0, offsetX + scaledW - 10 * currentScale, offsetY + scaledH - 2 * currentScale, 10 * currentScale, 2 * currentScale, borderColor)
        draw.RoundedBox(0, offsetX + scaledW - 2 * currentScale, offsetY + scaledH - 10 * currentScale, 2 * currentScale, 10 * currentScale, borderColor)
    end
end

function PaintProgress()
    local name, time = ProgressName, ProgressTime
    local screenwidth, screenheight = ScrW(), ScrH()
    local client = LocalPlayer()

    if IsValid(client.progressbar) then
      client.progressbar:Remove()
    end

    if (!IsValid(client.progressbar)) then
        CreateProgressBar(client, screenwidth, screenheight, time)
    else
        progressAnim.state = "appearing"
        progressAnim.startTime = CurTime()
        
        client.progressbar.failed = false
        client.progressbar.complete = false
        client.progressbar.Color = color_white
        client.progressbar.progress_time = 0
        client.progressbar.name = name
        client.progressbar.time_reach = time
        client.progressbar.end_time = CurTime()
        client.progressbar:SetVisible(true)

        client.progressbaricon.icon = Material(ProgressIcon)
        client.progressbaricon:SetVisible(true)

        ProgressRunning = true
    end
end

function StopProgressBar()
    ProgressRunning = nil
    local client = LocalPlayer()

    if (client.progressbar && client.progressbar:IsValid()) then
        client.progressbar.name = BREACH.TranslateString("l:progress_stopped")
        client.progressbar.Color = stopclr
        client.progressbar.failed = true
        
        progressAnim.state = "failed"
        progressAnim.failedTime = CurTime()
    end
end

net.Receive("StopBreachProgressBar", StopProgressBar)

concommand.Add("stopprogress", function()
    StopProgressBar()
end)