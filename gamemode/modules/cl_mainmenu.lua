  local MenuTable = {}
MenuTable.start = "Play"
MenuTable.Leave = "Leave"
MenuTable.OurGroup = "Wiki"
MenuTable.FAQ = "Information"
MenuTable.Settings = "Settings"

MenuTable.Current_Build = "1.1.4"

--INTRO_PANEL:Remove()


local dark_clr = Color(0,0,0,155)

local gray_clr = Color(27,27,27,255)

local gradient = Material("vgui/gradient-r")
local gradient2 = Material("vgui/gradient-l")
local gradients = Material("gui/center_gradient")
local grad1 = Material("vgui/gradient-u")
local grad2 = Material("vgui/gradient-d")
local backgroundlogo = Material("nextoren/menu")
local scp = Material("nextoren/gui/icons/notifications/breachiconfortips.png", "noclamp smooth")
local garland = Material("happy_new_year/happy_new_year.png", "noclamp smooth")
local donatelist = include("config/donatelist.lua")

local function drawmat(x,y,w,h,mat)

  surface.SetDrawColor(color_white)
  surface.SetMaterial(mat)
  surface.DrawTexturedRect(x,y,w,h)

end

concommand.Add("debug_reset_mainmenu", function()
  INTRO_PANEL:Remove()
  ShowMainMenu = false
end)

surface.CreateFont( "dev_desc", {
  font = "Univers LT Std 47 Cn Lt",
  size = 16,
  weight = 0,
  antialias = true,
  italic = false,
  extended = true,
  shadow = false,
  outline = false,
  
})

surface.CreateFont( "dev_name", {
  font = "Univers LT Std 47 Cn Lt",
  size = 21,
  weight = 0,
  antialias = true,
  extended = true,
  shadow = false,
  outline = false,
  
})

local PATCHIE = include("config/changelogs.lua")

function draw.RotatedText( text, x, y, font, color, ang )
  render.PushFilterMag( TEXFILTER.ANISOTROPIC )
  render.PushFilterMin( TEXFILTER.ANISOTROPIC )

  local m = Matrix()
  m:Translate( Vector( x, y, 0 ) )
  m:Rotate( Angle( 0, ang, 0 ) )

  surface.SetFont( font )
  local w, h = surface.GetTextSize( text )

  m:Translate( -Vector( w / 2, h / 2, 0 ) )

  cam.PushModelMatrix( m )
    draw.DrawText( text, font, 0, 0, color )
  cam.PopModelMatrix()

  render.PopFilterMag()
  render.PopFilterMin()
end

function createdonationmenu()

  if IsValid(MAIN_MENU_DERMA_DONATE) then MAIN_MENU_DERMA_DONATE:Remove() end

  if IsValid(INTRO_PANEL.donate) then
    INTRO_PANEL.donate:AlphaTo(0, 1, 0, function() INTRO_PANEL.donate:Remove() INTRO_PANEL.donate = nil end)
    return
  end

  local creditspanel = vgui.Create("DScrollPanel", INTRO_PANEL)
  local sbar = creditspanel:GetVBar()
  function sbar:Paint(w, h)
  end
  function sbar.btnUp:Paint(w, h)
  end
  function sbar.btnDown:Paint(w, h)
  end
  function sbar.btnGrip:Paint(w, h)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(0, 0, w-3, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(0, h/2, w-3, h/2)
  end
  INTRO_PANEL.donate = creditspanel
  INTRO_PANEL.donate:SetAlpha(0)
  INTRO_PANEL.donate:SetSize(400,400)
  INTRO_PANEL.donate:Center()
  INTRO_PANEL.donate:AlphaTo(255, 1)
  INTRO_PANEL.donate.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,dark_clr)
    DrawBlurPanel(INTRO_PANEL.donate)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(0, 0, 3, h/2)
    surface.DrawTexturedRect(w-3, 0, 3, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(0, h/2, 3, h/2)
    surface.DrawTexturedRect(w-3, h/2, 3, h/2)
    INTRO_PANEL.donate:MakePopup()
  end

  for i = 1, #donation_list do
    local data = donation_list[i]
    local label = vgui.Create("DLabel", creditspanel)
    label:Dock(TOP)
    label:SetSize(0,20)
    label:SetFont("ChatFont_new")
    label:SetText("  "..data.category)
  end

end



local button_lang = {
  play = "l:menu_play",

  resume = "l:menu_resume",

  disconnect = "l:menu_disconnect",

  credits = "l:menu_credits",

  kill = "l:suiside",

  settings = "l:menu_settings",

  guide = "l:menu_guide",

  discord = "l:discord",

  xmas = "l:xmas",

  donate = "l:menu_donate",

  wiki = "l:menu_wiki",

  rules = "l:menu_my_life_my_rules",
}

local function get_button_lang(str)

  --local mylang = langtouse

  --if !button_lang[str] then return "NOT FOUND" end

  --if button_lang[str][mylang] then return button_lang[str][mylang] end

  --if mylang == "ukraine" then return button_lang[str]["russian"] end

  return L(button_lang[str]) --["english"]

end

surface.CreateFont("MainMenuFont", {

  font = "Hitmarker Normal",
  size = 24,
  weight = 800,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false

})
--Conduit ITC
surface.CreateFont("MainMenuFontmini", {

  font = "Hitmarker Normal",
  size = 26,
  weight = 800,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = true,
  additive = false,
  outline = false

})

BREACH = BREACH || {}

ShowMainMenu = ShowMainMenu || false
local clr1 = Color( 128, 128, 128 )
local whitealpha = Color( 255, 255, 255, 90 )
local clrblackalpha = Color( 0, 0, 0, 220 )

local Material_To_Check = {

  "nextoren_hud/overlay/frost_texture",
  "weapons/weapon_flashlight",
  "cultist/door_1",
  "models/balaclavas/balaclava",
  "models/cultist/heads/zombie_face",
  "models/all_scp_models/shared/arms_new",
  "nextoren/gui/special_abilities/special_fbi_commander.png",
  "models/breach_items/ammo_box/ammocrate_smg1"

}

local function CreateMainMenuQuery(text,str1,func1,str2,func2)

  if IsValid(INTRO_PANEL.credits) then INTRO_PANEL.credits:Remove() end
  if IsValid(MAIN_MENU_DERMA_QUERY) then MAIN_MENU_DERMA_QUERY:Remove() end
  if IsValid(COLOR_PANEL_SETTINGS) then COLOR_PANEL_SETTINGS:Remove() end
  MAIN_MENU_DERMA_QUERY = vgui.Create("DPanel", INTRO_PANEL)
  MAIN_MENU_DERMA_QUERY:SetSize(400,70)
  MAIN_MENU_DERMA_QUERY:SetAlpha(0)
  MAIN_MENU_DERMA_QUERY:AlphaTo(255,1)
  local x, y = gui.MousePos()
  x = x + 10
  x = math.max(x, 170)
  if y > ScrH() - 70 then
    y = ScrH() - 80
  end
  MAIN_MENU_DERMA_QUERY:SetPos(x, y)
  MAIN_MENU_DERMA_QUERY.Paint = function(self,w,h)
    draw.RoundedBox(0,0,0,w,h,dark_clr)
    DrawBlurPanel(self)
    draw.DrawText(text, "MainMenuFontmini", w/2, 2, color_white, TEXT_ALIGN_CENTER)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(gradient)
    surface.DrawTexturedRect(0,0,w/2,1)
    surface.DrawTexturedRect(0,h-1,w/2,1)
    surface.SetMaterial(gradient2)
    surface.DrawTexturedRect(w/2,0,w/2,1)
    surface.DrawTexturedRect(w/2,h-1,w/2,1)
    --surface.DrawOutlinedRect(0,0,w,h,1)
    MAIN_MENU_DERMA_QUERY:MakePopup()
  end
  local butt1 = vgui.Create("DButton", MAIN_MENU_DERMA_QUERY)
  if !str2 then
    butt1:SetSize(400, 30)
  else
    butt1:SetSize(200, 30)
  end
  butt1:SetPos(0,40)
  butt1:SetText("")
  butt1.DoClick = function()
    if func1 then func1() end
    MAIN_MENU_DERMA_QUERY:Remove()
  end
  butt1.Paint = function(self, w, h)
    draw.DrawText(str1, "MainMenuFontmini", w/2, 0, color_white, TEXT_ALIGN_CENTER)
  end

  if str2 then
    local butt2 = vgui.Create("DButton", MAIN_MENU_DERMA_QUERY)
    butt2:SetSize(200, 30)
    butt2:SetPos(200,40)
    butt2:SetText("")
    butt2.DoClick = function()
      if func2 then func2() end
      MAIN_MENU_DERMA_QUERY:Remove()
    end
    butt2.Paint = function(self, w, h)
      draw.DrawText(str2, "MainMenuFontmini", w/2, 0, color_white, TEXT_ALIGN_CENTER)
    end
  end

end

local function CreateMainMenuQueryWithHover(text,str1,hoverstr1,func1,str2,hoverstr2,func2)

  local butt1hovered = false
  local butt2hovered = false

  if IsValid(INTRO_PANEL.credits) then INTRO_PANEL.credits:Remove() end
  if IsValid(MAIN_MENU_DERMA_QUERY) then MAIN_MENU_DERMA_QUERY:Remove() end
  if IsValid(COLOR_PANEL_SETTINGS) then COLOR_PANEL_SETTINGS:Remove() end
  MAIN_MENU_DERMA_QUERY = vgui.Create("DPanel", INTRO_PANEL)
  MAIN_MENU_DERMA_QUERY:SetSize(400,70)
  MAIN_MENU_DERMA_QUERY:SetAlpha(0)
  MAIN_MENU_DERMA_QUERY:AlphaTo(255,1)
  local x, y = gui.MousePos()
  x = x + 10
  x = math.max(x, 170)
  if y > ScrH() - 70 then
    y = ScrH() - 80
  end
  MAIN_MENU_DERMA_QUERY:SetPos(x, y)
  MAIN_MENU_DERMA_QUERY.Paint = function(self,w,h)
    draw.RoundedBox(0,0,0,w,h,dark_clr)
    DrawBlurPanel(self)
    draw.DrawText(text, "MainMenuFontmini", w/2, 2, color_white, TEXT_ALIGN_CENTER)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(gradient)
    surface.DrawTexturedRect(0,0,w/2,1)
    surface.DrawTexturedRect(0,h-1,w/2,1)
    surface.SetMaterial(gradient2)
    surface.DrawTexturedRect(w/2,0,w/2,1)
    surface.DrawTexturedRect(w/2,h-1,w/2,1)
    --surface.DrawOutlinedRect(0,0,w,h,1)
    MAIN_MENU_DERMA_QUERY:MakePopup()
  end
  local butt1 = vgui.Create("DButton", MAIN_MENU_DERMA_QUERY)
  if !str2 then
    butt1:SetSize(400, 30)
  else
    butt1:SetSize(200, 30)
  end
  butt1:SetPos(0,40)
  butt1:SetText("")
  butt1.DoClick = function()
    if func1 then func1() end
    MAIN_MENU_DERMA_QUERY:Remove()
    butt1hovered = false
    butt2hovered = false
  end
  butt1.Paint = function(self, w, h)
    draw.DrawText(str1, "MainMenuFontmini", w/2, 0, color_white, TEXT_ALIGN_CENTER)

    if self:IsHovered() then
      butt1hovered = true
    else
      butt1hovered = false
    end
  end

  if str2 then
    local butt2 = vgui.Create("DButton", MAIN_MENU_DERMA_QUERY)
    butt2:SetSize(200, 30)
    butt2:SetPos(200,40)
    butt2:SetText("")
    butt2.DoClick = function()
      if func2 then func2() end
      MAIN_MENU_DERMA_QUERY:Remove()
      butt1hovered = false
      butt2hovered = false
    end
    butt2.Paint = function(self, w, h)
      draw.DrawText(str2, "MainMenuFontmini", w/2, 0, color_white, TEXT_ALIGN_CENTER)

      if self:IsHovered() then
        butt2hovered = true
      else
        butt2hovered = false
      end
    end
  end

  local hovertextlabel = vgui.Create("DLabel", INTRO_PANEL)
  hovertextlabel:SetSize(ScrW(), ScrH())
  hovertextlabel:SetPos(0, 0)
  hovertextlabel:SetText("")
  hovertextlabel.Paint = function(self, w, h)
    local cx, cy = input.GetCursorPos()
    if butt1hovered and string.len(hoverstr1) > 0 then
      --hovertextlabel:SetPos(cx, cy)
      draw.DrawText(hoverstr1, "BudgetLabel", cx + ScrH()*0.03, cy + ScrH()*0.04, color_white, TEXT_ALIGN_CENTER)
    end

    if butt2hovered and string.len(hoverstr2) > 0 then
      --hovertextlabel:SetPos(cx, cy)
      draw.DrawText(hoverstr2, "BudgetLabel", cx + ScrH()*0.03, cy + ScrH()*0.04, color_white, TEXT_ALIGN_CENTER)
    end
  end

end

function GM:DrawDeathNotice( x,  y ) end

local intro_clr = Color( 200, 200, 200 )

local function StartIntro()

  local intropanel = vgui.Create( "DPanel" )
  intropanel:SetPos( ScrW() * .75, ScrH() * .7 )
  intropanel:SetSize( math.min( ScrW() * .35, 500 ), 128 )
  intropanel:SetText( "" )
  intropanel.Paint = function( self, w, h ) end

  local NextSymbolTime = RealTime()
  local count = 0
  local alpha = 255

  local TextPanel = vgui.Create( "DLabel", intropanel )
  TextPanel:SetPos( 5, 0 )
  TextPanel:SetFont( "SubScoreboardHeader" )
  TextPanel:SetText( "" )

  local roundstring

  if ( gamestarted ) then

    roundstring = "l:startintro_round_will_begin " .. string.ToMinutesSeconds( cltime )
    --BREACH.Round.GameStarted = true

  else

    roundstring = "l:startintro_no_round"

  end

  local teststring = tostring( L"l:startintro_welcome_pt1 " .. LocalPlayer():GetName() .. "!\n " .. L(roundstring) .. L" l:startintro_welcome_pt2" )
  local stringtable = utf8.Explode( "", teststring, false )
  surface.SetFont( "SubScoreboardHeader" )
  local stringw, stringh = surface.GetTextSize( teststring )
  TextPanel:SetSize( stringw, stringh )

  TextPanel.Paint = function( self, w, h )

    draw.DrawText( tostring( os.date( "%X" ) ), "SubScoreboardHeader", 0, 0, intro_clr, TEXT_ALIGN_LEFT )

    if ( NextSymbolTime <= RealTime() && count != #stringtable ) then

      NextSymbolTime = NextSymbolTime + 0.08

      count = count + 1
      if ( stringtable[count] != " " ) then

        surface.PlaySound( "common/talk.wav" )

      end

      if ( count == #stringtable ) then

        NextSymbolTime = NextSymbolTime + 10

      end

      TextPanel:SetText( TextPanel:GetText() .. stringtable[count] )

    end

    if ( NextSymbolTime <= RealTime() && count == #stringtable ) then

      alpha = math.Approach( alpha, 0, FrameTime() * 45 )
      TextPanel:SetAlpha( alpha )

      if ( TextPanel:GetAlpha() == 0 ) then

        intropanel:Remove()

      end

    end

  end

end

function music_menu()
  surface.PlaySound( "nextoren/unity/scpu_menu_theme_v3.01.ogg" )
end
concommand.Add( "music_menu", music_menu )

function Fluctuate(c) --used for flashing colors
  return (math.cos(CurTime()*c)+1)/2
end

function Pulsate(c) --Использование флешей
  return (math.abs(math.sin(CurTime()*c)))
end

weareprecaching = weareprecaching or false
if FIRSTTIME_MENU == nil then FIRSTTIME_MENU = true end

local credits = {
  "----------------------------------------------------------",
  "| Cultist_kun - Creator of 1.0, inspired to make this server",
  "| Ghelid - Creator of 1.0, inspired to make this server",
  "----------------------------------------------------------",
  "| You - thanks for playing on the server!",
  "----------------------------------------------------------",
}

local credits2 = {
  "----------------------------------------------------------",
  "| Покупка доната происходит в нашем дискорде",
  "----------------------------------------------------------",
  "| Покупка не моментальна однако в случае долгого ожидания!",
  "| Возможны компенсации в ввиде увеличеного товара!",
  "----------------------------------------------------------",
}

function OpenXmasMenu()

  if IsValid(MAIN_MENU_DERMA_QUERY) then MAIN_MENU_DERMA_QUERY:Remove() end

  if IsValid(INTRO_PANEL.credits) then
    INTRO_PANEL.credits:AlphaTo(0, 1, 0, function() INTRO_PANEL.credits:Remove() INTRO_PANEL.credits = nil end)
    return
  end

  local creditspanel = vgui.Create("DScrollPanel", INTRO_PANEL)
  local sbar = creditspanel:GetVBar()
  function sbar:Paint(w, h)
  end
  function sbar.btnUp:Paint(w, h)
  end
  function sbar.btnDown:Paint(w, h)
  end
  function sbar.btnGrip:Paint(w, h)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(0, 0, w-3, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(0, h/2, w-3, h/2)
  end
  INTRO_PANEL.credits = creditspanel
  INTRO_PANEL.credits:SetAlpha(0)
  INTRO_PANEL.credits:SetSize(550,800)
  INTRO_PANEL.credits:Center()
  INTRO_PANEL.credits:AlphaTo(255, 1)
  INTRO_PANEL.credits.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,dark_clr)
    DrawBlurPanel(INTRO_PANEL.credits)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(0, 0, 3, h/2)
    surface.DrawTexturedRect(w-3, 0, 3, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(0, h/2, 3, h/2)
    surface.DrawTexturedRect(w-3, h/2, 3, h/2)
    --INTRO_PANEL.credits:MakePopup()
    draw.DrawText("НОВОГОДНИЙ ИВЕНТ", "ImpactSmall", w/2, h/64, _, TEXT_ALIGN_CENTER)
    --draw.DrawText("Искатель конфет", "ImpactSmall", w/64, h/16, _, TEXT_ALIGN_LEFT)
    --draw.DrawText("По комплексу раскиданы конфеты ты должен их найти и собрать", "ImpactSmall2", w/64, h/10, _, TEXT_ALIGN_LEFT)
    --draw.DrawText(LocalPlayer():GetNWInt("event_xmas_candy").." / 75", "ImpactSmall", w/2, h/16, _, TEXT_ALIGN_LEFT)
    --surface.SetDrawColor(color_white)
    --surface.SetMaterial(Material("nextoren/gui/event_xmas_candy.jpg"))
    --surface.DrawTexturedRect(w/8, h/8, 400, 200)

    --draw.DrawText("Спаситель нового года", "ImpactSmall", w/64, h/7, _, TEXT_ALIGN_LEFT)
    --draw.DrawText("Примите участиве в спец. раунде выживите и убейте зло!", "ImpactSmall2", w/64, h/6, _, TEXT_ALIGN_LEFT)
    --surface.SetDrawColor(color_white)
    --surface.SetMaterial(Material("nextoren/gui/event_xmas_snowman.jpg"))
    --surface.DrawTexturedRect(w/8, h/2, 400, 200)
  end

  --for i = 1, #credits do
  --  local text = credits[i]
  local label = vgui.Create("DLabel", creditspanel)
  label:Dock(TOP)
  label:SetSize(0,300)
  label:SetFont("ChatFont_new")
  label:SetText("  ")
  label.Paint = function(self, w, h)
    draw.DrawText("Искатель конфет", "ImpactSmall", w/64, h/8, _, TEXT_ALIGN_LEFT)
    draw.DrawText("По комплексу раскиданы конфеты ты должен их найти и собрать", "ImpactSmall2", w/64, h/4.5, _, TEXT_ALIGN_LEFT)
    if tonumber(LocalPlayer():GetNWInt("event_xmas_candy")) >= 150 then
      draw.DrawText("✔ - "..LocalPlayer():GetNWInt("event_xmas_candy").." / 150", "ImpactSmall", w/1.05, h/8, Color(136,255,112), TEXT_ALIGN_RIGHT)
    else
      draw.DrawText(LocalPlayer():GetNWInt("event_xmas_candy").." / 150", "ImpactSmall", w/1.05, h/8, Color(253,122,122), TEXT_ALIGN_RIGHT)
    end
    surface.SetDrawColor(color_white)
    surface.SetMaterial(Material("nextoren/gui/event_xmas_candy.jpg"))
    surface.DrawTexturedRect(w/8, h/3.5, 400, 200)
  end

  local label = vgui.Create("DLabel", creditspanel)
  label:Dock(TOP)
  label:SetSize(0,300)
  label:SetFont("ChatFont_new")
  label:SetText("  ")
  label.Paint = function(self, w, h)
    draw.DrawText("Спаситель нового года", "ImpactSmall", w/64, h/8, _, TEXT_ALIGN_LEFT)
    draw.DrawText("Примите участиве в спец. раунде выживите и убейте зло!", "ImpactSmall2", w/64, h/4.5, _, TEXT_ALIGN_LEFT)
    if tonumber(LocalPlayer():GetNWInt("event_xmas_tvar")) >= 1 then
      draw.DrawText("✔ - "..LocalPlayer():GetNWInt("event_xmas_tvar").." / 1", "ImpactSmall", w/1.05, h/8, Color(136,255,112), TEXT_ALIGN_RIGHT)
    else
      draw.DrawText(LocalPlayer():GetNWInt("event_xmas_tvar").." / 1", "ImpactSmall", w/1.05, h/8, Color(253,122,122), TEXT_ALIGN_RIGHT)
    end
    surface.SetDrawColor(color_white)
    surface.SetMaterial(Material("nextoren/gui/event_xmas_snowman.jpg"))
    surface.DrawTexturedRect(w/8, h/3.5, 400, 200)
  end

  local label = vgui.Create("DLabel", creditspanel)
  label:Dock(TOP)
  label:SetSize(0,300)
  label:SetFont("ChatFont_new")
  label:SetText("  ")
  label.Paint = function(self, w, h)
    draw.DrawText("Новогодний марафон", "ImpactSmall", w/64, h/8, _, TEXT_ALIGN_LEFT)
    draw.DrawText("Соберите подарок под елкой 3 дня подряд", "ImpactSmall2", w/64, h/4.5, _, TEXT_ALIGN_LEFT)
    if tonumber(LocalPlayer():GetNWInt("event_xmas_gift")) >= 3 then
      draw.DrawText("✔ - "..LocalPlayer():GetNWInt("event_xmas_gift").." / 1", "ImpactSmall", w/1.05, h/8, Color(136,255,112), TEXT_ALIGN_RIGHT)
    else
      draw.DrawText(LocalPlayer():GetNWInt("event_xmas_gift").." / 3", "ImpactSmall", w/1.05, h/8, Color(253,122,122), TEXT_ALIGN_RIGHT)
    end
    surface.SetDrawColor(color_white)
    surface.SetMaterial(Material("nextoren/gui/event_xmas_gift.jpg"))
    surface.DrawTexturedRect(w/8, h/3.5, 400, 200)
  end

  local label2 = vgui.Create("DLabel", creditspanel)
  label2:Dock(TOP)
  label2:SetSize(0,200)
  label2:SetFont("ChatFont_new")
  label2:SetText("  ")
  label2.Paint = function(self, w, h)
    draw.DrawText("Награда за работу", "ImpactSmall", w/2, h/8, _, TEXT_ALIGN_CENTER)
    draw.DrawText("- 30 дней према", "ImpactSmall", w/64, h/4.5, Color(226,103,103), TEXT_ALIGN_LEFT)
    draw.DrawText("- Новогодние перчатки", "ImpactSmall", w/64, h/3.1, Color(226,103,103), TEXT_ALIGN_LEFT)
    --if tonumber(LocalPlayer():GetNWInt("event_xmas_gift")) >= 3 then
    --  draw.DrawText("✔ - "..LocalPlayer():GetNWInt("event_xmas_gift").." / 1", "ImpactSmall", w/1.05, h/8, Color(136,255,112), TEXT_ALIGN_RIGHT)
    --else
    --  draw.DrawText(LocalPlayer():GetNWInt("event_xmas_gift").." / 3", "ImpactSmall", w/1.05, h/8, Color(253,122,122), TEXT_ALIGN_RIGHT)
    --end
    --surface.SetDrawColor(color_white)
    --surface.SetMaterial(Material("nextoren/gui/event_xmas_gift.jpg"))
    --surface.DrawTexturedRect(w/8, h/3.5, 400, 200)
  end

  local finalbutton = vgui.Create("DButton", creditspanel)
  finalbutton:SetText("")
  finalbutton:SetSize(0, 100)
  finalbutton:Dock(TOP)
  --finalbutton:SetPos(100, 200)

  finalbutton.animPress = 0
  finalbutton.animHover = 0
  finalbutton.animHoverPress = 0

  local btnHover = false
  finalbutton.Paint = function(self, w, h)
  	local hoverPressScale = 1 - self.animHoverPress * 0.03
  	local pressScale = 1 - self.animPress * 0.05
  	local totalScale = hoverPressScale * pressScale
  
  	local scaledW = w * totalScale
  	local scaledH = h * totalScale
  	local offsetX = (w - scaledW) / 2
  	local offsetY = (h - scaledH) / 2
  
  	local colorLerp = self.animHover
  	local r = Lerp(colorLerp, 255, 255)
  	local g = Lerp(colorLerp, 255, 50)
  	local b = Lerp(colorLerp, 255, 50)

  	if timer.Exists("NewTG_SpanwTimer") then
  		r = Lerp(colorLerp, 255, 255)
  		g = Lerp(colorLerp, 255, 0)
  		b = Lerp(colorLerp, 255, 0)
  	end
  

  	draw.RoundedBox(6, offsetX, offsetY, scaledW, scaledH, Color(70, 70, 70, 200))
  
  	local textColor = Color(r, g, b, 255)
  	if timer.Exists("NewTG_SpanwTimer") then
  		draw.SimpleText(string.ToMinutesSeconds(timer.TimeLeft("NewTG_SpanwTimer")), "ImpactBig2", w * 0.5, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  	else
  		draw.SimpleText("Проверить", "ImpactBig2", w * 0.5, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  	end
  
  	surface.SetDrawColor(r, g, b, 50)
  	surface.DrawOutlinedRect(offsetX, offsetY, scaledW, scaledH, 2)
  end

  finalbutton.OnCursorEntered = function(self)
  	btnHover = true
  	self:LerpAnim("animHover", 1, 0.2)
  	self:LerpAnim("animHoverPress", 1, 0.15)
  end

  finalbutton.OnCursorExited = function(self)
  	btnHover = false
  	self:LerpAnim("animHover", 0, 0.2)
  	self:LerpAnim("animHoverPress", 0, 0.15)
  end

  function finalbutton:LerpAnim(animName, target, time)
  	if self[animName] == target then return end
  
  	local start = self[animName] or 0
  	local anim = self:NewAnimation(time, 0, -1, function()
  		self[animName] = target
  	end)
  
  	anim.Think = function(anim, panel, fraction)
  		self[animName] = Lerp(fraction, start, target)
  	end
  end

  function finalbutton:DoClickAnim()
  	self.animPress = 1
  	self:LerpAnim("animPress", 0, 0.3)
  end

  function finalbutton:DoClick()
  	self:DoClickAnim()

    if ( !FIRSTTIME_MENU ) then
      surface.PlaySound( "nextoren/gui/main_menu/confirm.wav" )
      INTRO_PANEL:SetVisible( false )
      if COLOR_PANEL_SETTINGS then COLOR_PANEL_SETTINGS:Remove() end
      if INTRO_PANEL.settings_frame then INTRO_PANEL.settings_frame:Remove() end
      if INTRO_PANEL.credits then INTRO_PANEL.credits:Remove() end
      if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
      gui.EnableScreenClicker( false )
      if mainmenumusic then
        mainmenumusic:Stop()
      end
      ShowMainMenu = false
    end

    net.Start("Breach:XMASCHECK")
    net.SendToServer()
  end

end

function OpenCreditsMenu()

  if IsValid(MAIN_MENU_DERMA_QUERY) then MAIN_MENU_DERMA_QUERY:Remove() end

  if IsValid(INTRO_PANEL.credits) then
    INTRO_PANEL.credits:AlphaTo(0, 1, 0, function() INTRO_PANEL.credits:Remove() INTRO_PANEL.credits = nil end)
    return
  end

  local creditspanel = vgui.Create("DScrollPanel", INTRO_PANEL)
  local sbar = creditspanel:GetVBar()
  function sbar:Paint(w, h)
  end
  function sbar.btnUp:Paint(w, h)
  end
  function sbar.btnDown:Paint(w, h)
  end
  function sbar.btnGrip:Paint(w, h)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(0, 0, w-3, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(0, h/2, w-3, h/2)
  end
  INTRO_PANEL.credits = creditspanel
  INTRO_PANEL.credits:SetAlpha(0)
  INTRO_PANEL.credits:SetSize(400,400)
  INTRO_PANEL.credits:Center()
  INTRO_PANEL.credits:AlphaTo(255, 1)
  INTRO_PANEL.credits.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,dark_clr)
    DrawBlurPanel(INTRO_PANEL.credits)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(0, 0, 3, h/2)
    surface.DrawTexturedRect(w-3, 0, 3, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(0, h/2, 3, h/2)
    surface.DrawTexturedRect(w-3, h/2, 3, h/2)
    INTRO_PANEL.credits:MakePopup()
  end

  for i = 1, #credits do
    local text = credits[i]
    local label = vgui.Create("DLabel", creditspanel)
    label:Dock(TOP)
    label:SetSize(0,20)
    label:SetFont("ChatFont_new")
    label:SetText("  "..text)
  end

end

function OpenCreditsMenu2()

  if IsValid(MAIN_MENU_DERMA_QUERY) then MAIN_MENU_DERMA_QUERY:Remove() end

  if IsValid(INTRO_PANEL.credits) then
    INTRO_PANEL.credits:AlphaTo(0, 1, 0, function() INTRO_PANEL.credits:Remove() INTRO_PANEL.credits = nil end)
    return
  end

  local creditspanel = vgui.Create("DScrollPanel", INTRO_PANEL)
  local sbar = creditspanel:GetVBar()
  function sbar:Paint(w, h)
  end
  function sbar.btnUp:Paint(w, h)
  end
  function sbar.btnDown:Paint(w, h)
  end
  function sbar.btnGrip:Paint(w, h)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(0, 0, w-3, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(0, h/2, w-3, h/2)
  end
  INTRO_PANEL.credits = creditspanel
  INTRO_PANEL.credits:SetAlpha(0)
  INTRO_PANEL.credits:SetSize(400,400)
  INTRO_PANEL.credits:Center()
  INTRO_PANEL.credits:AlphaTo(255, 1)
  INTRO_PANEL.credits.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,dark_clr)
    DrawBlurPanel(INTRO_PANEL.credits)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(0, 0, 3, h/2)
    surface.DrawTexturedRect(w-3, 0, 3, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(0, h/2, 3, h/2)
    surface.DrawTexturedRect(w-3, h/2, 3, h/2)
    INTRO_PANEL.credits:MakePopup()
  end

  for i = 1, #credits2 do
    local text = credits2[i]
    local label = vgui.Create("DLabel", creditspanel)
    label:Dock(TOP)
    label:SetSize(0,20)
    label:SetFont("ChatFont_new")
    label:SetText("  "..text)
  end

end

local function firsttimeshit(precache)
  RunConsoleCommand("stopsound")

  local __mainmenuspawn_dist = math.huge
  local __mainmenuspawn_found = BREACH.MainMenu_Spawns[1][2]

  for i, v in pairs(BREACH.MainMenu_Spawns) do
    local _d = LocalPlayer():GetPos():DistToSqr(v[1])
    if __mainmenuspawn_dist > _d then
      __mainmenuspawn_found = v[2]
      __mainmenuspawn_dist = _d
    end
  end

  LocalPlayer():SetEyeAngles(__mainmenuspawn_found)

  local whitescreen = vgui.Create("DPanel")

  whitescreen:SetSize(ScrW(), ScrH())
  whitescreen:AlphaTo(0, 2, 1, function()
    if IsValid(whitescreen) then whitescreen:Remove() end
  end)

  net.Start("Player_FullyLoadMenu", true)
  net.SendToServer()

  timer.Create("Player_FullyLoadMenu", 1, 0, function()
    if LocalPlayer():GetNWBool("Player_IsPlaying", false) then
      timer.Remove("Player_FullyLoadMenu")
      return
    end
    net.Start("Player_FullyLoadMenu")
    net.SendToServer()
  end)

  if precache then
    weareprecaching = true
  end

  timer.Simple(0.1, function()

    if precache then
      PrecachePlayerSounds()
      weareprecaching = false
    end

    FIRSTTIME_MENU = false
    surface.PlaySound( "nextoren/gui/main_menu/confirm.wav" )

    if ( mainmenumusic ) then

      mainmenumusic:Stop()

    end

    INTRO_PANEL:SetVisible( false )
    if COLOR_PANEL_SETTINGS then COLOR_PANEL_SETTINGS:Remove() end
    if INTRO_PANEL.settings_frame then INTRO_PANEL.settings_frame:Remove() end
    if INTRO_PANEL.credits then INTRO_PANEL.credits:Remove() end
    if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
    gui.EnableScreenClicker( false )
    --mainmenumusic:Stop()
    ShowMainMenu = false
    if mainmenumusic then
      mainmenumusic:Stop()
    end

    MenuTable.start = L"l:menu_resume"

    local ply = LocalPlayer()

    ply:CompleteAchievement("firsttime")

    surface.PlaySound( "nextoren/unity/scpu_objective_completed_v1.01.ogg" )


    ply:ConCommand( "r_decals 4096" )
    ply:ConCommand( "gmod_mcore_test 1" )

    ply:ConCommand( "cl_threaded_client_leaf_system 1" )
		ply:ConCommand( "mat_queue_mode -1" )
			
		ply:ConCommand( "cl_threaded_bone_setup 1" )
			
		ply:ConCommand( "gmod_mcore_test 1" )
			
		ply:ConCommand( "r_threaded_renderables 1" )
			
		ply:ConCommand( "r_threaded_particles 1" )
			
		ply:ConCommand( "r_queued_ropes 1" )
			
		ply:ConCommand( "studio_queue_mode 1" )

    ply:ConCommand("gmod_mcore_test", "1")
	  ply:ConCommand("mat_queue_mode", "2")
	  ply:ConCommand("cl_threaded_bone_setup", "1")
	  ply:ConCommand("cl_threaded_client_leaf_system", "1")
	  ply:ConCommand("r_threaded_client_shadow_manager", "1")
	  ply:ConCommand("r_threaded_particles", "1")
	  ply:ConCommand("r_threaded_renderables", "1")
	  ply:ConCommand("r_queued_ropes", "1")
	  ply:ConCommand("studio_queue_mode", "1")
	  ply:ConCommand("r_queued_props", "1")
	  ply:ConCommand("r_queued_ropes", "1")
	  ply:ConCommand("r_occludermincount", "1")

    --ApplyColorFX()

    StartIntro()

    ply:ConCommand( "lounge_chat_clear" )
  end)
end

function StartBreach( firsttime )

  local buttons = {
    {
      name = "play",
      notfirsttime_name = "play",
      func = function()

        if ( FIRSTTIME_MENU ) then
          CreateMainMenuQueryWithHover(L"l:menu_do_precache_or_nah",
            L"l:menu_yes", L"l:menu_precache_hover",
            function()
              firsttimeshit(true)
            end,

            L"l:menu_no", L"l:menu_no_precache_hover",
            function()
              firsttimeshit(false)
            end
            )

        else
          surface.PlaySound( "nextoren/gui/main_menu/confirm.wav" )
          INTRO_PANEL:SetVisible( false )
          if COLOR_PANEL_SETTINGS then COLOR_PANEL_SETTINGS:Remove() end
          if INTRO_PANEL.settings_frame then INTRO_PANEL.settings_frame:Remove() end
          if INTRO_PANEL.credits then INTRO_PANEL.credits:Remove() end
          if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
          gui.EnableScreenClicker( false )
          if mainmenumusic then
            mainmenumusic:Stop()
          end
          ShowMainMenu = false

        end
      end
    },
    {
      name = "settings",
      func = function()
        OpenConfigMenu()
        surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
      end,
    },
    --{
    --  name = "guide",
    --  func = function()
    --    --OpenConfigMenu()
    --    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    --    gui.OpenURL("https://www.youtube.com/watch?v=fk24jILzFaw&t=214s")
    --  end,
    --},
    --{
    --  name = "discord",
    --  func = function()
    --    --OpenConfigMenu()
    --    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    --    gui.OpenURL("https://discord.gg/4KmXXWcZFp")
    --  end,
    --},
    --{
    --  name = "xmas",
    --  func = function()
    --    --OpenConfigMenu()
    --    OpenXmasMenu()
    --    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    --    --gui.OpenURL("https://discord.gg/4KmXXWcZFp")
    --  end,
    --},
    --{
    --  name = "donate",
    --  func = function()
    --    --OpenDonateMenu()
    --    --OpenCreditsMenu2()
    --    OpenDonateMenu()
    --    surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    --  end,
    --},
    -- {
    --   name = "rules",
    --   func = function()
    --     INTRO_PANEL:OpenUrl("https://steamcommunity.com/groups/cnrxsend/discussions/0/4289188948009545620/")
    --     surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
    --   end,
    -- },
    --[[
    {
      name = "donate",
      func = function()
        surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
        createdonationmenu()
      end,
    },]]
    {
      name = "credits",
      func = function()
        OpenCreditsMenu()
        surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
      end,
    },
    {
      name = "kill",
      func = function()
        --OpenCreditsMenu()
        if ( !FIRSTTIME_MENU ) then
        surface.PlaySound( "nextoren/gui/main_menu/confirm.wav" )
        INTRO_PANEL:SetVisible( false )
        if COLOR_PANEL_SETTINGS then COLOR_PANEL_SETTINGS:Remove() end
        if INTRO_PANEL.settings_frame then INTRO_PANEL.settings_frame:Remove() end
        if INTRO_PANEL.credits then INTRO_PANEL.credits:Remove() end
        if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
        gui.EnableScreenClicker( false )
        if mainmenumusic then
          mainmenumusic:Stop()
        end
        ShowMainMenu = false
        net.Start("Breach:Kill")
        net.SendToServer()
        surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
        end
      end,
    },
    {
      name = "disconnect",
      func = function()
        CreateMainMenuQuery(L"l:menu_sure", L"l:menu_yes", function()
          LocalPlayer():ConCommand("disconnect")
        end, L"l:menu_no",function() surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" ) end)
        surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
      end,
    }
  }

  local scrw, scrh = ScrW(), ScrH()

  INTRO_PANEL = vgui.Create( "DPanel" );
  INTRO_PANEL:SetSize( scrw, scrh );
  INTRO_PANEL:SetPos( 0, 0 )
  INTRO_PANEL.OpenTime = RealTime()

  --local button = vgui.Create("DButton", INTRO_PANEL)
  --button:SetSize(110,25)
  --button:SetText("")
  --button:SetPos(0,15)
  --button:CenterHorizontal()
  --button.lerp = 0
  --local clr_butt = Color(255,255,255,115)
  --button.Paint = function(self, w, h)
--
  --    drawmat(0,0,w,1,gradients)
  --    drawmat(0,h-1,w,1,gradients)
--
  --    surface.SetDrawColor(color_white)
  --    surface.SetMaterial(grad2)
  --    surface.DrawTexturedRect(1, 0, 1, h/2)
  --    surface.SetMaterial(grad1)
  --    surface.DrawTexturedRect(1, h/2, 1, h/2)
--
  --    surface.SetDrawColor(color_white)
  --    surface.SetMaterial(grad2)
  --    surface.DrawTexturedRect(w-1, 0, 1, h/2)
  --    surface.SetMaterial(grad1)
  --    surface.DrawTexturedRect(w-1, h/2, 1, h/2)
--
  --    if self:IsHovered() then
  --      draw.RoundedBox(0,1,1,w-2,h-2,ColorAlpha(color_white, 100))
  --    end
--
  --    draw.DrawText(BREACH.TranslateString"l:menu_changelog", "ScoreboardContent", w/2, 6, nil, TEXT_ALIGN_CENTER)
--
  --end

  local PATCHIE_PANEL = vgui.Create("DScrollPanel", INTRO_PANEL)

  local sbar = PATCHIE_PANEL:GetVBar()
  function sbar:Paint(w, h)
  end
  function sbar.btnUp:Paint(w, h)
  end
  function sbar.btnDown:Paint(w, h)
  end
  function sbar.btnGrip:Paint(w, h)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(6, 0, 6, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(6, h/2, 6, h/2)
  end

  function PATCHIE_PANEL:UpdatePatchie()

    self:Clear()

    local last

    for _, text in ipairs(PATCHIE) do
      if !text.type then
        --[[
        local str = vgui.Create("DLabel", PATCHIE_PANEL)
        str:Dock(TOP)
        str:SetSize(0,30)
        str:SetText("- "..text.str)
        str:SetTextColor(color_white)
        str:SetFont("ChatFont_new")]]

        local str = BREACH.AdminLogs.UI:CreateRichText(BREACH.AdminLogs.UI:ExplodeText("- "..text.str), 0, 0, PATCHIE_PANEL:GetWide()-15, 5, nil, "ChatFont_new", color_white)
       -- str:Dock(TOP)
        str:PositionLabels(true)

        local bg = vgui.Create("DPanel", PATCHIE_PANEL)
        bg:Dock(TOP)
        bg:SetSize(0,str:GetTall()+15)
        bg.Paint = function() end

        str:SetParent(bg)
        str:SetPos(10,15)

        last = bg
      elseif text.type == "title" then
        local titlepanel = vgui.Create("DPanel", PATCHIE_PANEL)
        titlepanel:Dock(TOP)
        titlepanel:SetSize(0,30)
        titlepanel.Paint = function(self, w, h)
          drawmat(0,h-1,w,1,gradients)
        end
        local title = vgui.Create("DLabel", titlepanel)
        title:SetText(text.str)
        title:SetFont("ScoreboardHeader")
        title:SizeToContentsX()
        title:SetPos(PATCHIE_PANEL:GetWide()/2-title:GetWide()/2, 3)
      end
    end

    last:SetTall(last:GetTall()+25)

  end

  --button.opened = false
  --button.DoClick = function(self)
  --  if !self.opened then
  --    PATCHIE_PANEL:UpdatePatchie()
  --    self.opened = !self.opened
  --    button:MoveTo(button:GetX(), PATCHIE_PANEL:GetTall() + 30, 1)
  --    PATCHIE_PANEL:MoveTo(PATCHIE_PANEL:GetX(), 15, 1)
  --  else
  --    self.opened = !self.opened
  --    button:MoveTo(button:GetX(), 15, 1)
  --    PATCHIE_PANEL:MoveTo(PATCHIE_PANEL:GetX(), -500, 1)
  --  end
  --end

  PATCHIE_PANEL:SetSize(500,500)
  PATCHIE_PANEL:SetPos(0,-500)
  PATCHIE_PANEL:CenterHorizontal()
  PATCHIE_PANEL.Paint = function(self, w, h)

      surface.SetDrawColor(color_white)
      surface.SetMaterial(grad2)
      surface.DrawTexturedRect(1, 0, 1, h/2)
      surface.SetMaterial(grad1)
      surface.DrawTexturedRect(1, h/2, 1, h/2)

      surface.SetDrawColor(color_white)
      surface.SetMaterial(grad2)
      surface.DrawTexturedRect(w-1, 0, 1, h/2)
      surface.SetMaterial(grad1)
      surface.DrawTexturedRect(w-1, h/2, 1, h/2)

  end



  function INTRO_PANEL:OpenUrl(url)

    if jit.arch == "x86" then
      gui.OpenURL(url)
    else

      if IsValid(INTRO_PANEL.HTML_PANEL) then
        INTRO_PANEL.HTML_PANEL:Remove()
        return
      end

      local HTML_PANEL = vgui.Create("DPanel", self)

      INTRO_PANEL.HTML_PANEL = HTML_PANEL
      
      HTML_PANEL:SetSize(450, scrh-100)
      HTML_PANEL:SetPos(scrw-500, 50)

      HTML_PANEL:SetAlpha(0)
      HTML_PANEL:AlphaTo(255,1)

       local html = vgui.Create("DHTML", HTML_PANEL)
      html:Dock(FILL)
      html:OpenURL(url)

      HTML_PANEL.Paint = function(self, w, h)
        if html:IsLoading() then
          draw.RoundedBox(0,0,0,w,h,dark_clr)
          DrawBlurPanel(self)
          surface.SetDrawColor(color_white)
          surface.SetMaterial(grad2)
          surface.DrawTexturedRect(0, 0, 3, h/2)
          surface.DrawTexturedRect(w-3, 0, 3, h/2)
          surface.SetMaterial(grad1)
          surface.DrawTexturedRect(0, h/2, 3, h/2)
          surface.DrawTexturedRect(w-3, h/2, 3, h/2)
          draw.DrawText("Loading...", "ScoreboardHeader", w/2, h/2, _, TEXT_ALIGN_CENTER)
       end
    end

    end

  end

  INTRO_PANEL.ButtonsList = vgui.Create("DScrollPanel", INTRO_PANEL)
  INTRO_PANEL.ButtonsList:SetSize(600,37*#buttons+5)
  INTRO_PANEL.ButtonsList:SetPos(24, scrh-(37*#buttons+29))
  INTRO_PANEL.ButtonsList.PaintOver = function(self, w, h)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(0, 0, 2, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(0, h/2, 2, h/2)
  end

  local button_animation_speed = 0.15
  
  local function AnimateButtonPress(btn)
      if not IsValid(btn) then return end
      
      btn.press_lerp = 1
      
      timer.Create("ButtonPressReset_" .. tostring(btn), button_animation_speed * 0.3, 1, function()
          if IsValid(btn) then
              btn.press_lerp = 0
          end
      end)
  end

  for _, but_data in pairs(buttons) do
    local button = vgui.Create("DButton", INTRO_PANEL.ButtonsList)
    button:Dock(TOP)
    button:SetSize(0,37)
    button:SetText("")
    button.lerp = 0
    button.hover_lerp = 0
    button.press_lerp = 0
    button.pulse_lerp = 0
    button.pulse_dir = 1
    button.glow_lerp = 0
    button.glow_dir = 1
    
    if but_data.name == "donate" or but_data.name == "play" or but_data.name == "xmas" then
        timer.Create("ButtonPulse_" .. but_data.name, 3, 0, function()
            if IsValid(button) and not button:IsHovered() then
                button.pulse_dir = button.pulse_dir == 1 and -1 or 1
            end
        end)
    end
    
    local clr_butt = Color(255,255,255,115)
    local add_x = 0
    
    button.Paint = function(self, w, h)
      if self:IsHovered() then
          add_x = math.Approach(add_x, 17, FrameTime()*350)
          self.hover_lerp = math.Approach(self.hover_lerp, 1, FrameTime()*5)
          self.pulse_lerp = 0
      else
          add_x = math.Approach(add_x, 0, FrameTime()*150)
          self.hover_lerp = math.Approach(self.hover_lerp, 0, FrameTime()*3)
      end
      
      if self.press_lerp > 0 then
          self.press_lerp = math.Approach(self.press_lerp, 0, FrameTime()*15)
      end
      
      if not self:IsHovered() and (but_data.name == "donate" or but_data.name == "play" or but_data.name == "xmas") then
          self.pulse_lerp = math.Approach(self.pulse_lerp, self.pulse_dir == 1 and 1 or 0, FrameTime()*0.3)
          if (self.pulse_dir == 1 and self.pulse_lerp >= 1) or (self.pulse_dir == -1 and self.pulse_lerp <= 0) then
              self.pulse_dir = self.pulse_dir * -1
          end
      end
      
      if self:IsHovered() then
          self.glow_lerp = math.Approach(self.glow_lerp, 1, FrameTime()*10)
      else
          self.glow_lerp = math.Approach(self.glow_lerp, 0, FrameTime()*5)
      end
      
      local font = "MainMenuFont_new"
      if langtouse == "russian" or langtouse == "ukraine" then
        font = "MainMenuFont_new_russian"
      end
      
      surface.SetFont(font)
      local text = get_button_lang(but_data.name)
      if but_data.notfirsttime_name and !FIRSTTIME_MENU then text = get_button_lang(but_data.notfirsttime_name) end
      if donatelist.discount > 0 and but_data.name == "donate" then text = text..BREACH.TranslateString"l:menu_discount %"..donatelist.discount..")" end
      local text_length = surface.GetTextSize(text)
      
      if self.hover_lerp > 0 then

          local bg_alpha = 10 + (15 * self.hover_lerp)
          draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, bg_alpha))
          

          local bar_width = 3 * self.hover_lerp
          draw.RoundedBox(0, 0, h/2 - 10, bar_width, 20, Color(255, 255, 255, 200 * self.hover_lerp))
      end
      

      if self.glow_lerp > 0 then
          local glow_alpha = 50 * self.glow_lerp
          for i = 1, 3 do
              local glow_offset = i * 0.5
              draw.DrawText(text, font, 10+add_x + glow_offset, glow_offset, 
                           Color(255, 255, 255, glow_alpha / (i * 2)), TEXT_ALIGN_LEFT)
          end
      end
      

      if self.press_lerp > 0 then
          local press_alpha = 30 * self.press_lerp
          draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, press_alpha))
          

          local wave_radius = w * self.press_lerp
          local wave_alpha = 50 * (1 - self.press_lerp)
          surface.SetDrawColor(255, 255, 255, wave_alpha)
          surface.DrawOutlinedRect(w/2 - wave_radius/2, h/2 - 10, wave_radius, 20)
      end
      

      local underline_width = text_length * self.hover_lerp
      if underline_width > 0 then
          local underline_x = 10 + add_x * 0.5
          local underline_y = h - 4
          draw.RoundedBox(0, underline_x, underline_y, underline_width, 2, 
                         Color(255, 255, 255, 200 * self.hover_lerp))
      end
      

      local text_y_offset = 0
      if self.press_lerp > 0 then
          text_y_offset = 1 * (1 - self.press_lerp)
      end
      
      local text_alpha = 115 + (140 * (self.hover_lerp * 3))
      local text_color = ColorAlpha(color_white, text_alpha)
      

      if self.pulse_lerp > 0 and (but_data.name == "donate" or but_data.name == "play" or but_data.name == "xmas") then
          local pulse_alpha = 30 * math.abs(math.sin(self.pulse_lerp * math.pi))
          text_color = Color(255, 255, 200, text_alpha + pulse_alpha * 100)
          

          if but_data.name == "donate" and donatelist.discount > 0 then
              text_color = Color(255, 215, 0, text_alpha + pulse_alpha * 100)
          end
          if but_data.name == "xmas" then
              text_color = Color(212, 103, 103, text_alpha + pulse_alpha * 100)
          end
      end
      

      if self:IsHovered() then
          local arrow_x = 5 + (add_x * 0.3)
          local arrow_alpha = 115 + (140 * (self.hover_lerp * 3))
          

          local arrow_offset = 0
          if self.hover_lerp > 0.5 then
              arrow_offset = math.sin(CurTime() * 8) * 2 * self.hover_lerp
          end
          
          draw.DrawText(">", font, arrow_x + arrow_offset, 0 + text_y_offset, 
                       ColorAlpha(color_white, arrow_alpha), TEXT_ALIGN_LEFT)
      end
      

      draw.DrawText(text, font, 10+add_x, 0 + text_y_offset, text_color, TEXT_ALIGN_LEFT)
      

      if self.hover_lerp > 0.5 then
          local gradient_alpha = 20 * (self.hover_lerp - 0.5) * 2
          surface.SetDrawColor(255, 255, 255, gradient_alpha)
          surface.SetMaterial(grad2)
          surface.DrawTexturedRect(0, 0, w * self.hover_lerp, h)
      end
    end
    
    button.DoClick = function(self)

        AnimateButtonPress(self)
        

        sound.PlayFile("sound/nextoren/gui/main_menu/button_click.wav", "noplay", function(station, errCode, errStr)
            if IsValid(station) then
                station:SetVolume(0.3)
                station:Play()
            end
        end)
        
        but_data.func()
    end
    

    button.OnCursorEntered = function(self)
        if self.sound_cooldown and self.sound_cooldown > CurTime() then return end
        self.sound_cooldown = CurTime() + 0.3
        
        sound.PlayFile("sound/nextoren/gui/main_menu/button_hover.wav", "noplay", function(station, errCode, errStr)
            if IsValid(station) then
                station:SetVolume(0.2)
                station:Play()
            end
        end)
    end
    

    button:SetAlpha(0)
    button:AlphaTo(255, 0.3, (tonumber(_) or 0) * 0.1)
    

    button.Think = function(self)
        if not self.init_alpha_done and self:GetAlpha() >= 255 then
            self.init_alpha_done = true
        end
    end
  end
  

  INTRO_PANEL.ButtonsList:SetAlpha(0)
  INTRO_PANEL.ButtonsList:AlphaTo(255, 0.5, 0.1)

  local clr_black = color_black
  local ico = Material("nextoren/forge_logo_cumtent.png", "noclamp smooth")

  local Backgrounds = {}

  local function updatebackgrounds()
    --if !GetConVar("breach_config_mge_mode"):GetBool() then
      Backgrounds = {
        "rxsend/mainmenu/ntf_sniper.png",
        "rxsend/mainmenu/goc_commander.png",
        "rxsend/mainmenu/is_agent.png",
        "rxsend/mainmenu/scp.png",
        "rxsend/mainmenu/scp_096.png",
        "rxsend/mainmenu/scp_294.png",
        "rxsend/mainmenu/scp_303.png",
        "rxsend/mainmenu/scp_106.png",
        "rxsend/mainmenu/scp_items.png",
        "rxsend/mainmenu/uiu_soldier.png",
        "rxsend/mainmenu/uiu_inflitrator.png",
        "rxsend/mainmenu/dz_portal.png",
        "rxsend/mainmenu/uiu_agents.png",
      }

      for i, v in pairs(Backgrounds) do
          Backgrounds[i] = Material(v, "noclamp smooth")
      end

      table.Shuffle(Backgrounds)
    --else
    --  Backgrounds = {}
    --  for i = 1, 8 do
    --    table.insert(Backgrounds, Material("rxsend/hard_pics/hard_pic_"..i..".png", "noclamp smooth"))
    --  end
    --end
  end
  updatebackgrounds()

  local lerp = 0

  local curbg = math.random(1, #Backgrounds)
  local nextbg = curbg + 1
  if nextbg > #Backgrounds then nextbg = 1 end

  local function CreateBackgroundImage(firsttime)
    if !IsValid(INTRO_PANEL) then return end
    if IsValid(INTRO_PANEL.bg_img) then
      INTRO_PANEL.bg_img:MoveTo(25, 0, 1.5, 0, -1)
      INTRO_PANEL.bg_img:AlphaTo(0, 1.5, 0, function(_, self)
        self:Remove()
      end)
    end
    INTRO_PANEL.bg_img = vgui.Create("DImage", INTRO_PANEL)
    INTRO_PANEL.bg_img:SetSize(scrw, scrh)
    INTRO_PANEL.bg_img:SetMaterial(Backgrounds[curbg])
    INTRO_PANEL.bg_img:SetZPos(-255)

    if !firsttime then
      INTRO_PANEL.bg_img:SetPos(15,0)
      INTRO_PANEL.bg_img:MoveTo(0, 0, 1.5, 1.5, 0.5)
      INTRO_PANEL.bg_img:SetAlpha(0)
      INTRO_PANEL.bg_img:AlphaTo(255,1.5, 1.5)      
    end

  end

  local offset_height = 0

  INTRO_PANEL.OverrideDraw = vgui.Create("DImage", INTRO_PANEL)
  INTRO_PANEL.OverrideDraw:SetSize(scrw, scrh)
  INTRO_PANEL.OverrideDraw.Paint = function(self, w, h)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(ico)
    surface.DrawTexturedRect(5,0+offset_height,100,100)

    draw.DrawText("Legacy Breach", "ScoreboardHeader", 105, 45+offset_height)
    --draw.DrawText("build "..MenuTable.Current_Build, "BudgetLabel", w-5, h-20, color_white, TEXT_ALIGN_RIGHT)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(gradients)
    surface.DrawTexturedRect(100, 80+offset_height, 305, 3)

    --draw.RoundedBox(0, 100, 60, 305, 3, color_white)
    --draw.DrawText("Created by Cyox", "ScoreboardContent", 105, 65)

    if weareprecaching then
       draw.RoundedBox(0, scrw * 0.44, scrh * 0.487, scrw * 0.12, scrh * 0.03, Color(0, 0, 0))
      draw.SimpleText(L"l:precaching_resources", "MainMenuFont", scrw * 0.5, scrh * 0.5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
  end

  local creatorlist = vgui.Create("DPanel", INTRO_PANEL)
  creatorlist:SetSize(300,395)
  creatorlist:SetPos(20,100+offset_height)
  creatorlist.Paint = function() end
  local spisok = {
    --{defaultname = "UracosVereches", id = "76561197997716528", who = "Кумир миллионов"},
    --{defaultname = "Shaky", id = "76561198869328954", who = "Вы знаете кто он"},
    {defaultname = "Imperator", id = "76561198966614836", who = "开发者"},
    {defaultname = "恶魔", id = "76561198377045227", who = "服主"},
    {defaultname = "Tarvention_TTA", id = "76561199389358627", who = "技术专家"},
    --{defaultname = "Fisher", id = "76561199144351466", who = "Организатор"},
    --{defaultname = "Layman", id = "76561199220664368", who = "Соорганизатор"},
    --{defaultname = "h3v//", id = "76561198047951509", who = "Комьюнити менеджер"},
    --{defaultname = "Humasun", id = "76561198110769981", who = "Главный Администратор"},
  }

  local sin, cos, rad = math.sin, math.cos, math.rad
  local rad0 = rad(0)
  local function DrawCircle(x, y, radius, seg)
    local cir = {
      {x = x, y = y}
    }

    for i = 0, seg do
      local a = rad((i / seg) * -360)
      table.insert(cir, {x = x + sin(a) * radius, y = y + cos(a) * radius})
    end

    table.insert(cir, {x = x + sin(rad0) * radius, y = y + cos(rad0) * radius})
    surface.DrawPoly(cir)
  end

  for i = 1 , #spisok do
    local v = spisok[i]
    local a = vgui.Create("DPanel", creatorlist)
    a:Dock(TOP)
    a:SetSize(0,80)
    local hsiz = 44/2
    a.Paint = function(w,h)       

    end

    local avatar = vgui.Create("AvatarImage", a)
    avatar:SetSteamID(v.id, 64)
    avatar:SetSize(44,44)
    avatar:SetPaintedManually(true)

    local name = vgui.Create("DLabel", a)
    name:SetSize(300,20)
    name:SetPos(50, 5)
    name:SetFont("dev_name")
    name:SetTextColor(color_white)

    local who = vgui.Create("DLabel", a)
    who:SetSize(300,20)
    who:SetPos(50, 25)
    who:SetFont("dev_desc")
    who:SetTextColor(color_white)
    who:SetText(v.who)

    local bootun = vgui.Create("DButton", a)
    bootun:SetSize(300,44)
    bootun:SetText("")
    local hoverclr = Color(255,255,255,20)
    bootun.Paint = function(self,w, h)

    end

    a.Paint = function(self, w,h)

      if bootun:IsHovered() then
        draw.RoundedBoxEx(100,0,0,bootun:GetWide(),bootun:GetTall(),hoverclr, true, false, true, false)
      end
      render.ClearStencil()
      render.SetStencilEnable(true)

      render.SetStencilWriteMask(1)
      render.SetStencilTestMask(1)

      render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
      render.SetStencilPassOperation(STENCILOPERATION_ZERO)
      render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
      render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
      render.SetStencilReferenceValue(1)

      draw.NoTexture()
      surface.SetDrawColor(color_black)
      DrawCircle(hsiz, hsiz, hsiz, hsiz)

      render.SetStencilFailOperation(STENCILOPERATION_ZERO)
      render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
      render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
      render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
      render.SetStencilReferenceValue(1)

      avatar:PaintManual()

      render.SetStencilEnable(false)
      render.ClearStencil()
      surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
	    surface.SetMaterial( Material( "nextoren_hud/hat_r.png" ) ) -- Use our cached material
	    surface.DrawTexturedRect( -10,-5,w/4,w/8 ) -- Actually draw the rectangle 
      --if !bootun:IsHovered() then
      --  surface.SetDrawColor(color_black)
      --  surface.SetMaterial(gradient2)
      --  surface.DrawTexturedRect(-10,0,w/2,h)
      --end
    end

    bootun.DoClick = function(self)

      if v.link then
        gui.OpenURL(v.link)
        return
      end

      gui.OpenURL("https://steamcommunity.com/profiles/"..v.id)

    end


    local namer = v.defaultname
    name:SetText(namer)


    steamworks.RequestPlayerInfo( v.id, function( steamName )
      namer = steamName
      if v.defaultname:lower() != string.lower(steamName) and !string.lower(steamName):find(string.lower(v.defaultname)) then
        namer = namer.." ("..v.defaultname..")"
      end
      name:SetText(namer)
    end )
 
  end

  --CreateBackgroundImage(true)
--
  --timer.Create("MainMenu_UpdateBackground", 6, 0, function()
  --  curbg = nextbg
  --  nextbg = curbg + 1
  --  if nextbg > #Backgrounds then nextbg = 1 end
  --  CreateBackgroundImage()
  --end)



  INTRO_PANEL.Paint = function(self, w, h)
    if (FIRSTTIME_MENU) then
        draw.RoundedBox(0, 0, 0, w, h, clr_black)
    else
        DrawBlurPanel(self)
    end
    
    if (input.IsKeyDown(KEY_ESCAPE) && INTRO_PANEL.OpenTime < RealTime() - .2 && !FIRSTTIME_MENU) then
        ShowMainMenu = CurTime() + .1
        gui.HideGameUI()
        INTRO_PANEL:SetVisible(false)
        gui.EnableScreenClicker(false)
        if mainmenumusic then
            mainmenumusic:Stop()
        end
        if COLOR_PANEL_SETTINGS then COLOR_PANEL_SETTINGS:Remove() end
        if INTRO_PANEL.settings_frame then INTRO_PANEL.settings_frame:Remove() end
        if IsValid(INTRO_PANEL.HTML_PANEL) then INTRO_PANEL.HTML_PANEL:Remove() end
        if INTRO_PANEL.credits then INTRO_PANEL.credits:Remove() end
        if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
    end
end

  local MenuNews = vgui.Create("DPanel", INTRO_PANEL)
		MenuNews:SetSize(ScrW() / 3, ScrH() / 3)
		MenuNews:SetPos(ScrW() / 1.55, ScrH() / 12)
		MenuNews.Paint = function(self)
			surface.SetDrawColor( Color(255,255,255) )
			MenuNews:DrawOutlinedRect( 0, 0, MenuNews:GetWide(), MenuNews:GetTall())
    	end
    --local image = vgui.Create("DWebImage", MenuNews)
    --image:Dock(FILL)
    --image:SetImageURL("https://cdn.discordapp.com/attachments/1098129871198240790/1431254793506263101/image.png?ex=68fcbf66&is=68fb6de6&hm=cefa632af9d3b503b1eb90da848172a4e9274cb6d97f348e18e9cb5a74d9d7fb&")
		local MenuDesc = vgui.Create("DPanel", INTRO_PANEL)
		MenuDesc:SetSize(ScrW() / 3, ScrH() / 3)
		MenuDesc:SetPos(ScrW() / 1.55, ScrH() / 12)
		MenuDesc.Paint = function(self,w,h)
			surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
	    surface.SetMaterial( Material( "nextoren/onp_monitor.png" ) ) -- Use our cached material
	    surface.DrawTexturedRect( 0, 0, MenuDesc:GetWide(), MenuDesc:GetTall() ) -- Actually draw the rectangle
			surface.SetDrawColor( Color(255,255,255) )
			MenuDesc:DrawOutlinedRect( 0, 0, MenuDesc:GetWide(), MenuDesc:GetTall())
			draw.DrawText("2026",     "LuctusScoreFontBigest", ScrW() / 128, ScrH()/4, COLOR_WHITE)
			draw.DrawText("正在积极进行程序生成的工作",     "LuctusScoreFontSmall", ScrW() / 128, ScrH()/3.45, COLOR_WHITE)
			draw.DrawText("今年还没有新增内容", "LuctusScoreFontSmall", ScrW() / 128, ScrH()/3.3, COLOR_WHITE)
  end

  local DermaButton = vgui.Create( "DButton", MenuDesc ) // Create the button and parent it to the frame
  DermaButton:SetText( " " )					// Set the text on the button
  DermaButton:Dock(FILL)
  DermaButton:SetSize( MenuDesc:GetWide(), MenuDesc:GetTall() )					// Set the size
  DermaButton.DoClick = function()				// A custom function run when clicked ( note the . instead of : )
      surface.PlaySound( "nextoren/gui/main_menu/main_menu_select_1.wav" )
      gui.OpenURL("https://discord.gg/4KmXXWcZFp")
  end
  DermaButton.Paint = function(self,w,h)
  end

end

--[[
do

  local client = LocalPlayer()

  if ( !( client.GetActive && client:GetActive() ) && !IsValid( INTRO_PANEL ) ) then

    timer.Create( "StartMainMenu", 0, 0, function()

      local client = LocalPlayer()

      if ( client && client:IsValid() ) then

        --StartBreach( true )
        timer.Remove( "StartMainMenu" )

      end

    end )

  end

end
--]]

function send_prefix_data()

  local data = util.JSONToTable(file.Read("breach_prefix_settings.txt", "DATA"))

  net.Start("SendPrefixData")
  net.WriteString(data.prefix)
  net.WriteBool(data.enabled)
  net.WriteString(data.color)
  net.WriteBool(data.rainbow)
  net.SendToServer()

end

hook.Add("InitPostEntity", "StartBreachIntro", function()
  StartBreach(true)
  if !file.Exists("breach_prefix_settings.txt", "DATA") then
    file.Write("breach_prefix_settings.txt", util.TableToJSON({
      enabled = false,
      prefix = "my prefix",
      color = "255,255,255",
      rainbow = false,
    }, true))
  end
  send_prefix_data()
end)

concommand.Add("send_prefix_data", send_prefix_data)

--breach config
CreateConVar("breach_config_cw_viewmodel_fov", 70, FCVAR_ARCHIVE, "Change CW 2.0 weapon viewmodel FOV", 50, 100)
CreateConVar("breach_config_cw_viewmodel_offset_z", 0, FCVAR_ARCHIVE, "Change CW 2.0 weapon viewmodel FOV", 0, 30)
CreateConVar("breach_config_announcer_volume", GetConVar("volume"):GetFloat() * 100, FCVAR_ARCHIVE, "Change announcer's volume", 0, 100)

CreateConVar("breach_config_language", GetConVar("cvar_br_language"):GetString() or "english", FCVAR_ARCHIVE, "Change gamemode language")
CreateConVar("breach_config_name_color", "255,255,255", FCVAR_ARCHIVE, "Change your nick color in chat. Example: 150,150,150. Premium or higher only")
CreateConVar("breach_config_mge_mode", 0, FCVAR_ARCHIVE, "MGE MODE", 0, 1)

CreateConVar("breach_config_hair_color", "255,255,255", FCVAR_ARCHIVE, "Change your nick color in chat. Example: 150,150,150. Premium or higher only")


CreateConVar("breach_config_overall_music_volume", 100, FCVAR_ARCHIVE, "Change music volume", 0, 200)

CreateConVar("breach_config_music_ambient_volume", 25, FCVAR_ARCHIVE, "Change music volume", 0, 100)
CreateConVar("breach_config_music_spawn_volume", 100, FCVAR_ARCHIVE, "Change music volume", 0, 100)
CreateConVar("breach_config_music_panic_volume", 100, FCVAR_ARCHIVE, "Change music volume", 0, 100)
CreateConVar("breach_config_music_misc_volume", 100, FCVAR_ARCHIVE, "Change music volume", 0, 100)


CreateConVar("breach_config_event_mode", 0, FCVAR_NONE, "Completely disables HUD. Can be buggy", 0, 1)
CreateConVar("breach_config_screenshot_mode", 0, FCVAR_NONE, "Completely disables HUD. Can be buggy", 0, 1)
CreateConVar("breach_config_blur", 1, FCVAR_NONE, "Blur or not", 0, 1)
CreateConVar("breach_config_snow", 0, FCVAR_NONE, "Snow or not", 0, 1)
CreateConVar("breach_config_screen_effects", 1, FCVAR_ARCHIVE, "Enables bloom and toytown", 0, 1)
CreateConVar("breach_config_filter_textures", 1, FCVAR_ARCHIVE, "Disabling this will decrease texture quality. Alias: mat_filtertextures", 0, 1)
CreateConVar("breach_config_filter_lightmaps", 1, FCVAR_ARCHIVE, "Disabling this will decrease lightmap(shadows) quality. Alias: mat_filterlightmaps", 0, 1)
CreateConVar("breach_config_display_premium_icon", 1, FCVAR_ARCHIVE, "Disabling display on scoreboard/chat/voice", 0, 1)
CreateConVar("breach_config_spawn_female_only", 0, FCVAR_ARCHIVE, "Spawn only as female characters", 0, 1)
CreateConVar("breach_config_prem_gloves", 1, FCVAR_ARCHIVE, "Spawn only as female characters", 0, 1)
CreateConVar("breach_config_xmas_gloves", 1, FCVAR_ARCHIVE, "Spawn only as female characters", 0, 1)
CreateConVar("breach_config_spawn_male_only", 0, FCVAR_ARCHIVE, "Spawn only as male characters", 0, 1)
CreateConVar("breach_config_no_role_description", 0, FCVAR_ARCHIVE, "Disables role description", 0, 1)
CreateConVar("breach_config_scp_red_screen", 1, FCVAR_ARCHIVE, "Enables the red screen for SCP", 0, 1)
CreateConVar("breach_config_spawn_support", 1, FCVAR_ARCHIVE, "Spawn as support", 0, 1)
CreateConVar("breach_config_hud_style", 0, FCVAR_ARCHIVE, "Changes your HUD style", 0, 1)
CreateConVar("breach_config_contrast", 0, FCVAR_ARCHIVE, "contrast screen", 0, 1)
--menu_screen_contrast
--CreateConVar("breach_config_holsters", 1, FCVAR_ARCHIVE, "Very resource intensive, not recommended", 0, 1)
CreateConVar("breach_config_filter_yellow", 0, FCVAR_ARCHIVE, "Patrolling the Site-19 makes you wish for a nuclear winter.", 0, 1)
CreateConVar("breach_config_filter_blue", 0, FCVAR_ARCHIVE, "Enables blue color filter", 0, 1)
CreateConVar("breach_config_filter_outside", 0, FCVAR_ARCHIVE, "Enables color filter outside", 0, 1)
CreateConVar("breach_config_filter_intensity", 0, FCVAR_ARCHIVE, "Changes intensity of color filter", 1, 10)
CreateConVar("breach_config_hide_title", 0, FCVAR_ARCHIVE, "Disable bottom title", 0, 1)
CreateConVar("breach_config_sexual_chemist", 1, FCVAR_ARCHIVE, "Sexy Chemist", 0, 1)
CreateConVar("breach_config_disable_voice_spec", 0, FCVAR_NONE, "You won't hear other spectators as a spectator", 0, 1)
CreateConVar("breach_config_disable_voice_alive", 0, FCVAR_NONE, "You won't hear alive people as a spectator", 0, 1)
CreateConVar("breach_config_useability", KEY_H, FCVAR_ARCHIVE, "number you will use ability with")
CreateConVar("breach_config_openinventory", KEY_Q, FCVAR_ARCHIVE, "number you will open inventory with")
CreateConVar("breach_config_leanright", KEY_3, FCVAR_ARCHIVE, "Leans to the right")
CreateConVar("breach_config_leanleft", KEY_1, FCVAR_ARCHIVE, "Leans to the left")
CreateConVar("breach_config_quickchat", KEY_C, FCVAR_ARCHIVE, "Quick chat menu")
CreateConVar("breach_config_draw_legs", 1, FCVAR_ARCHIVE, "Draw legs")
CreateConVar("breach_config_killfeed", 1, FCVAR_ARCHIVE, "Show killfeed")
CreateConVar("breach_config_scphudleft", 0, FCVAR_ARCHIVE, "SCP Ability style")

--announcer helper function
function GetAnnouncerVolume()
  return GetConVar("breach_config_announcer_volume"):GetInt() or 50
end

--filter shit
RunConsoleCommand("mat_filtertextures", GetConVar("breach_config_filter_textures"):GetInt())
RunConsoleCommand("mat_filterlightmaps", GetConVar("breach_config_filter_lightmaps"):GetInt())

cvars.AddChangeCallback("breach_config_filter_textures", function(cvar, old, new)
  RunConsoleCommand("mat_filtertextures", tonumber(new))
end)

cvars.AddChangeCallback("breach_config_filter_lightmaps", function(cvar, old, new)
  RunConsoleCommand("mat_filterlightmaps", tonumber(new))
end)

cvars.AddChangeCallback("breach_config_contrast", function(cvar, old, new)
  --ApplyColorFX()
end)

cvars.AddChangeCallback("breach_config_screenshot_mode", function(_,_, new)
  
end)

--language
RunConsoleCommand("breach_config_language", GetConVar("breach_config_language"):GetString())

cvars.AddChangeCallback("breach_config_language", function(cvar, old, new)
  RunConsoleCommand("cvar_br_language", new)
end)

BREACH.AllowedNameColorGroups = {
  ["superadmin"] = true,
  ["spectator"] = true,
  ["admin"] = true,
  ["premium"] = true,
}

--name color
function NameColorSend(cvar, old, new)
if LocalPlayer():IsPremium() then
  if !new:find(",") then return end
    local color_tbl = string.Explode(",", new)

    if isnumber(tonumber(color_tbl[1])) and isnumber(tonumber(color_tbl[2])) and isnumber(tonumber(color_tbl[3])) then
      color = Color(tonumber(color_tbl[1]), tonumber(color_tbl[2]), tonumber(color_tbl[3]))
      if IsColor(color) then
        color.a = 255 --xyecocs
        --don't even fucking try to exploit it or you will suck my dick or BAN
        net.Start("NameColor")
          net.WriteColor(color)
        net.SendToServer()
      end
    end
  end
end
cvars.AddChangeCallback("breach_config_name_color", NameColorSend)

function HairColorSend(cvar, old, new)
if LEGACY_HAIRCOLOR[LocalPlayer():SteamID64()] then
  if !new:find(",") then return end
    local color_tbl = string.Explode(",", new)

    if isnumber(tonumber(color_tbl[1])) and isnumber(tonumber(color_tbl[2])) and isnumber(tonumber(color_tbl[3])) then
      color = Color(tonumber(color_tbl[1]), tonumber(color_tbl[2]), tonumber(color_tbl[3]))
      if IsColor(color) then
        color.a = 255 --xyecocs
        --don't even fucking try to exploit it or you will suck my dick or BAN
        net.Start("HairColor")
          net.WriteColor(color)
        net.SendToServer()
      end
    end
  end
end
cvars.AddChangeCallback("breach_config_hair_color", HairColorSend)

local function ChangeServerValue(id, bool)

  net.Start("Change_player_settings")
  net.WriteUInt(id, 12)
  net.WriteBool(bool)
  net.SendToServer()

end

local function ChangeServerValueInt(id, int)

  net.Start("Change_player_settings_id")
  net.WriteUInt(id, 12)
  net.WriteUInt(int, 32)
  net.SendToServer()

end

cvars.AddChangeCallback("breach_config_disable_voice_spec", function(_, _, new)
  ChangeServerValue(5,tobool(new))
end)

cvars.AddChangeCallback("breach_config_sexual_chemist", function(_, _, new)
  ChangeServerValue(7,tobool(new))
end)

cvars.AddChangeCallback("breach_config_disable_voice_alive", function(_, _, new)
  ChangeServerValue(6,tobool(new))
end)

cvars.AddChangeCallback("breach_config_spawn_female_only", function(_, _, new)

  ChangeServerValue(2, tobool(new))

end)

cvars.AddChangeCallback("breach_config_prem_gloves", function(_, _, new)

  ChangeServerValue(8, tobool(new))

end)

cvars.AddChangeCallback("breach_config_xmas_gloves", function(_, _, new)

  ChangeServerValue(9, tobool(new))

end)

cvars.AddChangeCallback("breach_config_useability", function(_, _, new)

  LocalPlayer().AbilityKey = string.upper(input.GetKeyName(new))
  LocalPlayer().AbilityKeyCode = new
  ChangeServerValueInt(1, new)

end)

cvars.AddChangeCallback("breach_config_spawn_male_only", function(_, _, new)

  ChangeServerValue(3, tobool(new))

end)

cvars.AddChangeCallback("breach_config_spawn_support", function(_, _, new)

  ChangeServerValue(1, tobool(new))

end)

cvars.AddChangeCallback("breach_config_display_premium_icon", function(_, _, new)

  ChangeServerValue(4, tobool(new))

end)

hook.Add("InitPostEntity", "NameColorSend", function()
  timer.Simple(30, function()
    local tab = {
      spawnsupport = GetConVar("breach_config_spawn_support"):GetBool(),
      spawnmale = GetConVar("breach_config_spawn_male_only"):GetBool(),
      spawnfemale = GetConVar("breach_config_spawn_female_only"):GetBool(),
      displaypremiumicon = GetConVar("breach_config_display_premium_icon"):GetBool(),
      useability = GetConVar("breach_config_useability"):GetInt(),
      sexychemist = GetConVar("breach_config_sexual_chemist"):GetBool(),
      premgloves = GetConVar("breach_config_prem_gloves"):GetBool(),
      xmasgloves = GetConVar("breach_config_xmas_gloves"):GetBool(),
    }
    net.Start("Load_player_data")
    net.WriteTable(tab)
    net.SendToServer()
    NameColorSend("pidr", "pidr", GetConVar("breach_config_name_color"):GetString())
    HairColorSend("pidr", "pidr", GetConVar("breach_config_hair_color"):GetString())
  end)
end)

hook.Add("HUDShouldDraw", "Breach_Screenshot_Mode", function(name)
  if GetConVar("breach_config_screenshot_mode"):GetInt() == 0 then return end

  -- So we can change weapons
  --if ( name == "CHudWeaponSelection" ) then return true end
  --if ( name == "CHudChat" ) then return true end

  return false

end)

--cvars.AddChangeCallback("breach_config_optimize", function(cvar, old, new)
  --BREACHOptimize = GetConVar("breach_config_optimize"):GetBool()
--end)

--cvars.AddChangeCallback("breach_config_potato", function(cvar, old, new)
  --BREACHPotato = GetConVar("breach_config_potato"):GetBool()
--end)

local yellow = GetConVar("breach_config_filter_yellow")
local blue = GetConVar("breach_config_filter_blue")
local mult = GetConVar("breach_config_filter_intensity")
local noutisde = GetConVar("breach_config_filter_outside")
local colormodify_yellow = {
  ["$pp_colour_addr"] = 0,
  ["$pp_colour_addg"] = 0,
  ["$pp_colour_addb"] = 0,
  ["$pp_colour_brightness"] = 0,
  ["$pp_colour_contrast"] = 1,
  ["$pp_colour_colour"] = 1,
  ["$pp_colour_mulr"] = 0,
  ["$pp_colour_mulg"] = 0,
  ["$pp_colour_mulb"] = 0,
}

local colormodify_blue = {
  ["$pp_colour_addr"] = 0,
  ["$pp_colour_addg"] = 0,
  ["$pp_colour_addb"] = 0,
  ["$pp_colour_brightness"] = 0,
  ["$pp_colour_contrast"] = 1,
  ["$pp_colour_colour"] = 1,
  ["$pp_colour_mulr"] = 0,
  ["$pp_colour_mulg"] = 0,
  ["$pp_colour_mulb"] = 0,
}

local _DrawColorModify = DrawColorModify

local translate_translations = {
  ["english"] = "English",
  ["russian"] = "Русский",
  ["chinese"] = "中文"
}

BREACH.Options = {
  {
    name = "l:menu_settings",
    settings = {
      {
        name = "SEXY CHEMIST",
        checkplayer = RXSEND_SEXY_CHEMISTS,
        cvar = "breach_config_sexual_chemist",
        type = "bool",
      },
      {
        name = "l:menu_weapon_fov",
        cvar = "breach_config_cw_viewmodel_fov",
        type = "slider",
        min = 50,
        max = 100,
      },
      {
        name = "l:menu_weapon_z_offset",
        cvar = "breach_config_cw_viewmodel_offset_z",
        type = "slider",
        min = 0,
        max = 30,
      },
      {
        name = "l:menu_no_role_desc",
        cvar = "breach_config_no_role_description",
        type = "bool",
      },
      {
        name = "l:menu_spawn_as_sup",
        cvar = "breach_config_spawn_support",
        type = "bool",
      },
      {
        name = "l:menu_useability",
        cvar = "breach_config_useability",
        type = "bind",
      },
      {
        name = "l:menu_inventory_key",
        cvar = "breach_config_openinventory",
        type = "bind",
      },
      {
        name = "l:menu_quickchat",
        cvar = "breach_config_quickchat",
        type = "bind",
      },
      {
        name = "l:menu_lang",
        cvar = "breach_config_language",
        type = "choice",
        value = {
          "english",
          "russian",
          "chinese",
        },
      },
    },
  },
  {
    name = "l:menu_chat_voice",
    settings = {
      {
        name = "l:menu_gradient_voice",
        cvar = "br_gradient_voice_chat",
        type = "bool"
      },
      {
        name = "l:menu_voice_show_alive",
        cvar = "br_voicechat_showalive",
        type = "bool"
      },
      {
        name = "l:menu_disable_flashes",
        cvar = "lounge_chat_disable_flashes",
        type = "bool"
      },
      {
        name = "l:menu_disable_avatars",
        cvar = "lounge_chat_hide_avatars",
        type = "bool"
      },
      {
        name = "l:menu_roundavatars",
        cvar = "lounge_chat_roundavatars",
        type = "bool"
      },
      {
        name = "l:menu_clearemoji",
        cvar = "br_voicechat_showalive",
        type = "unique",
        createpanel = function(panel)

          local siz = 0

          local pa = LOUNGE_CHAT.ImageDownloadFolder .. "/"
          local fil = file.Find(pa .. "*.png", "DATA")
          for _, f in pairs (fil) do
            siz = siz + file.Size(pa .. f, "DATA")
          end

          local clear_dpanel = vgui.Create("DPanel", panel)
          clear_dpanel:Dock(TOP)
          clear_dpanel:SetSize(0,30)
          clear_dpanel.Paint = function() end
          local clear_panel = vgui.Create("DButton", clear_dpanel)
          clear_panel:Dock(FILL)
          clear_panel:DockMargin(3,3,3,3)
          clear_panel:SetText("")
          clear_panel.Text = "l:menu_clear_downloaded_images ("..string.NiceSize(siz)..")"
          local col = Color(255,255,255,100)
          clear_panel.Paint = function(self, w, h)
            if self:IsHovered() then
              draw.RoundedBox(0,0,0,w,h,col)
            end
            drawmat(5,0,w-10,1,gradients)
            drawmat(5,h-1,w-10,1,gradients)

            draw.DrawText(L(self.Text), "ScoreboardContent", w/2,4, nil, TEXT_ALIGN_CENTER)
          end

          clear_panel.DoClick = function(self)
            local pa = LOUNGE_CHAT.ImageDownloadFolder .. "/"
            local fil = file.Find(pa .. "*.png", "DATA")
            for _, f in pairs (fil) do
              file.Delete(pa .. f)
            end
            self.Text = "l:menu_clear_downloaded_images ("..string.NiceSize(0)..")"
          end

        end
      },
    },
  },
  {
    name = "l:menu_audio",
    settings = {
      {
        name = "l:menu_mute_spec",
        cvar = "breach_config_disable_voice_spec",
        type = "bool",
      },
      {
        name = "l:menu_mute_spec_if_alive",
        cvar = "breach_config_disable_voice_alive",
        type = "bool",
      },
      {
        name = "l:menu_announcer_volume",
        cvar = "breach_config_announcer_volume",
        type = "slider",
        min = 0,
        max = 100,
      },
    },
  },
  {
    name = "l:menu_music_title",
    settings = {
      {
        name = "l:menu_overall_music_volume",
        cvar = "breach_config_overall_music_volume",
        type = "slider",
        min = 0,
        max = 200,
      },
      {
        name = "l:menu_spawn_music_volume",
        cvar = "breach_config_music_spawn_volume",
        type = "slider",
        min = 0,
        max = 100,
      },
      {
        name = "l:menu_panic_music_volume",
        cvar = "breach_config_music_panic_volume",
        type = "slider",
        min = 0,
        max = 100,
      },
      {
        name = "l:menu_ambience_music_volume",
        cvar = "breach_config_music_ambient_volume",
        type = "slider",
        min = 0,
        max = 100,
      },
      {
        name = "l:menu_misc_music_volume",
        cvar = "breach_config_music_misc_volume",
        type = "slider",
        min = 0,
        max = 100,
      },
    },
  },
  {
    name = "l:menu_visual_settings",
    settings = {
      
      {
        name = "l:menu_drawlegs",
        cvar = "breach_config_draw_legs",
        type = "bool"
      },
      {
        name = "l:menu_killfeed",
        cvar = "breach_config_killfeed",
        type = "bool"
      },
      {
        name = "l:menu_hide_title",
        cvar = "breach_config_hide_title",
        type = "bool"
      },
      {
        name = "l:menu_scp_red_vision",
        cvar = "breach_config_scp_red_screen",
        type = "bool"
      },
      {
        name = "l:menu_screenshot_mode",
        cvar = "breach_config_screenshot_mode",
        type = "bool",
      },
      {
        name = "l:menu_screen_effects",
        cvar = "breach_config_screen_effects",
        type = "bool",
      },
      {
        name = "l:menu_filter_textures",
        cvar = "breach_config_filter_textures",
        type = "bool",
      },
      {
        name = "l:menu_filter_lightmaps",
        cvar = "breach_config_filter_lightmaps",
        type = "bool",
      },
      --{
      --  name = "l:menu_screen_contrast",
      --  cvar = "breach_config_contrast",
      --  type = "bool",
      --},
      {
        name = "l:menu_snow",
        cvar = "breach_config_snow",
        type = "bool",
      },
      {
        name = "l:menu_blur",
        cvar = "breach_config_blur",
        type = "bool",
      },
      --menu_screen_contrast
    }
  },
  --{
  --  name = "l:menu_special_settings",
  --  prefix = true,
  --  settings = {
  --    {
  --      name = "l:menu_chat_prefix",
  --      cvar = "breach_config_name_color",
  --      type = "prefix",
  --    },
  --  }
  --},
  {
    name = "l:menu_premium_settings",
    premium = true,
    settings = {
      {
        name = "l:menu_nick_grb_color",
        cvar = "breach_config_name_color",
        type = "color",
        premium = true,
      },
      {
        name = "l:menu_display_premium_icon",
        cvar = "breach_config_display_premium_icon",
        type = "bool",
        premium = true,
      },
      {
        name = "l:menu_spawn_male_only",
        cvar = "breach_config_spawn_male_only",
        type = "bool",
        premium = true,
      },
      {
        name = "l:menu_spawn_female_only",
        cvar = "breach_config_spawn_female_only",
        type = "bool",
        premium = true,
      },
      {
        name = "l:menu_gloves_use",
        cvar = "breach_config_prem_gloves",
        type = "bool",
        premium = true,
      },
    }
  },
  {
    name = "l:other",
    settings = {
      {
        name = "l:haircolor",
        cvar = "breach_config_hair_color",
        type = "color",
        hair = true,
      },
      {
        name = "l:menu_gloves_use_xmas",
        cvar = "breach_config_xmas_gloves",
        type = "bool",
        xmasgloves = true,
      },
    }
  },
  {
    name = "Ивентерам",
    settings = {
      {
        name = "Включить ивент меню",
        cvar = "breach_config_event_mode",
        type = "bool"
      },
    }
  }
  --[[
  [10] = {
    name = "HUD Style",
    cvar = "breach_config_hud_style",
    type = "bool",
  },]]
}

local TEXTENTRY_FRAME --[[
  [10] = {
    name = "HUD Style",
    cvar = "breach_config_hud_style",
    type = "bool",
  },]]
local function niceSum(i, iFallback)
    return math.Truncate(tonumber(i) or iFallback, 2)
end

function Deposit2(iRealSum)
    iRealSum = tonumber(iRealSum)
    local scrw, scrh = ScrW(), ScrH()
    if IsValid(INTRO_PANEL.settings_frame) then
        INTRO_PANEL.settings_frame:AlphaTo(0, 1, 0, function()
            INTRO_PANEL.settings_frame:Remove()
            INTRO_PANEL.settings_frame = nil
            Deposit2()
        end)
        return
    end

    local settings_frame = vgui.Create("EditablePanel", INTRO_PANEL)
    INTRO_PANEL.settings_frame = settings_frame
    settings_frame:SetSize(scrw * 0.3, scrh * 0.3)
    settings_frame:Center()
    settings_frame:SetAlpha(0)
    settings_frame:SetKeyboardInputEnabled(true)
    settings_frame:SetMouseInputEnabled(true)
    settings_frame:AlphaTo(255, 1)
    settings_frame:MoveToFront()
    local padding = 20
    local inner_width = settings_frame:GetWide() - padding * 2
    settings_frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, dark_clr)
        DrawBlurPanel(self)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(grad2)
        surface.DrawTexturedRect(0, 0, 3, h / 2)
        surface.DrawTexturedRect(w - 3, 0, 3, h / 2)
        surface.SetMaterial(grad1)
        surface.DrawTexturedRect(0, h / 2, 3, h / 2)
        surface.DrawTexturedRect(w - 3, h / 2, 3, h / 2)
        settings_frame:MakePopup()
    end

    hook.Run("IGS.OnDepositWinOpen", iRealSum)
    local realSum = math.max(IGS.GetMinCharge(), niceSum(iRealSum, 0))
    local dlabel = vgui.Create("DLabel", settings_frame)
    dlabel:SetSize(inner_width, 25)
    dlabel:SetPos(padding, padding)
    dlabel:SetText("Введи сумму на которую хочешь пополнить")
    dlabel:SetFont("donate_text")
    dlabel:SetTextColor(color_white)
    dlabel:SetContentAlignment(5)
    local real_m = vgui.Create("DTextEntry", settings_frame)
    real_m:SetPos(padding, padding + 30)
    real_m:SetSize(inner_width, 32)
    real_m:SetNumeric(true)
    real_m:SetTextColor(color_white)
    real_m:SetValue(realSum)
    real_m:RequestFocus()
    real_m.Paint = function(self2, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(35, 35, 35, 255))
        self2:DrawTextEntryText(self2:GetTextColor(), self2:GetHighlightColor(), self2:GetCursorColor())
        if self2:GetText() == "" and not self2:HasFocus() then draw.SimpleText(self2:GetPlaceholderText() or "", "donate_text", 5, h / 2, ColorAlpha(color_white, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
    end

    real_m.PaintOver = nil
    local purchase = vgui.Create("DButton", settings_frame)
    purchase:SetSize(inner_width, 40)
    purchase:SetPos(padding, padding + 75)
    purchase:SetText("Пополнить счет")
    purchase:SetFont("donate_text")
    purchase:SetTextColor(color_white)
    purchase.Paint = function(self2, w, h)
        local clr = self2:IsHovered() and Color(60, 60, 60) or Color(45, 45, 45)
        draw.RoundedBox(4, 0, 0, w, h, clr)
    end

    purchase.DoClick = function()
        local want_money = niceSum(real_m:GetValue())
        if not want_money then return end
        if want_money < realSum then return end
        IGS.GetPaymentURL(want_money, function(url)
            IGS.OpenURL(url)
            if not IsValid(m) then return end
        end)
    end

    real_m.Think = function()
        local sum = tonumber(real_m:GetValue())
        if sum then
            purchase:SetText("Пополнить счет на " .. niceSum(sum, 0) .. " руб")
            purchase:SetEnabled(sum > 0)
        else
            purchase:SetText("Пополнить счет")
            purchase:SetEnabled(false)
        end
    end
end



surface.CreateFont( "donate_text", {
  font = "Univers LT Std 47 Cn Lt",
  size = 22,
  weight = 0,
  antialias = true,
  extended = true,
  shadow = false,
  outline = false,
  
})

function OpenDonateMenu()
    local tbl_italia_brainrot = {
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "рублей",
        "бр-бр патапимов",
        "тралалело тралалей",
        "примогемов",
        "тенге",
        "тубриков",
        "анонимусов"
    }
    local curency = table.Random(tbl_italia_brainrot)
    local scrw, scrh = ScrW(), ScrH()
    if IsValid(INTRO_PANEL.settings_frame) then
        INTRO_PANEL.settings_frame:AlphaTo(0, 1, 0, function()
            INTRO_PANEL.settings_frame:Remove()
            INTRO_PANEL.settings_frame = nil
        end)
        return
    end
    local doante_now = GetGlobalInt("DonateCount")
    local settings_frame = vgui.Create("DPanel", INTRO_PANEL)
    INTRO_PANEL.settings_frame = settings_frame
    INTRO_PANEL.settings_frame:SetSize(scrw * .6, scrh * .6)
    INTRO_PANEL.settings_frame:Center()
    settings_frame:SetAlpha(0)
    settings_frame:AlphaTo(255, 1)
    settings_frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, dark_clr)
        DrawBlurPanel(self)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(grad2)
        surface.DrawTexturedRect(0, 0, 3, h / 2)
        surface.DrawTexturedRect(w - 3, 0, 3, h / 2)
        surface.SetMaterial(grad1)
        surface.DrawTexturedRect(0, h / 2, 3, h / 2)
        surface.DrawTexturedRect(w - 3, h / 2, 3, h / 2)
        draw.DrawText("У вас " .. LocalPlayer():IGSFunds() .. " " .. curency, "donate_text", w * 0.99 , 0, clr_category, TEXT_ALIGN_RIGHT)

        local max_donate = 25000
        --local doante_now = 15000

        --surface.SetDrawColor(255, 255, 255, 75)
	      --surface.DrawOutlinedRect(w * 0.4, h * 0.9, w / 2, h * 0.1)

        --draw.RoundedBox(0,w * 0.4, h * 0.9, (w / 2) * (tonumber(doante_now)/max_donate), h * 0.1, Color(255,255,255,255))
        --draw.DrawText("На обновление Легкой Зоны", "donate_text", w * 0.65, h * 0.85, clr_category, TEXT_ALIGN_CENTER)
        --draw.DrawText(doante_now.."/"..max_donate, "ScoreboardHeader", w * 0.65, h * 0.92, Color(255,81,0), TEXT_ALIGN_CENTER)
      end
    local w, h = settings_frame:GetSize()

    

    Don = vgui.Create("DButton",settings_frame)
	  Don:SetSize(w / 8, h / 24)
	  Don:SetText("")
	  Don:SetPos(w * 0.87 , 20)
    Don:SetZPos(32767)
	  Don.defaultColor = Color(255, 255, 255)
	  Don.hoverColor = Color(0, 0, 0)
	  Don.currentColor =  Color(Don.defaultColor.r, Don.defaultColor.g, Don.defaultColor.b)
	  Don.currentColor2 = Color(Don.hoverColor.r ,  Don.hoverColor.g  , Don.hoverColor.b)
	  function Don:DoClick()
	  	--self:GetParent().ActiveCat = self.Cat
	  	--NewF4SelectCat(self:GetParent().ActiveCat)
      Deposit2()
      --    local item = INTRO_PANEL.infos[infopanel.currentstart]
      --    if not item then return end
      --    if item.islevelcock then
      --        net.Start("fastbuymehouse")
      --        net.WriteUInt(curlevel, 8)
      --        net.SendToServer()
      --    elseif item.ispremcock then
      --      net.Start("fastbuymehouse1")
      --        net.WriteUInt(curlevel, 8)
      --      net.SendToServer()
      --    elseif item.uid ~= nil then
      --        print(item.uid)
      --        IGS.Purchase(item.uid)
      --    else
      --        print("шота фурри басота не напастила донаты так шо терпи не хочу покупаца")
      --    end
      --    if IsValid(INTRO_PANEL.settings_frame) then
      --        INTRO_PANEL.settings_frame:AlphaTo(0, 1, 0, function()
      --            INTRO_PANEL.settings_frame:Remove()
      --            INTRO_PANEL.settings_frame = nil
      --        end)
      --        return
      --    end
	  end
	  function Don:Paint(w, h)
		  self.colorChangeSpeed = 12
		  self.defaultColor = Color(255, 255, 255)
		  self.hoverColor = Color(0, 0, 0)
	    self.targetColor = self:IsHovered() and self.hoverColor or self.defaultColor
		  self.targetColor2 = self:IsHovered() and self.defaultColor or self.hoverColor
	
	    self.currentColor.r = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor.r, self.targetColor.r)
	    self.currentColor.g = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor.g, self.targetColor.g)
	    self.currentColor.b = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor.b, self.targetColor.b)

		  self.currentColor2.r = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor2.r, self.targetColor2.r)
	    self.currentColor2.g = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor2.g, self.targetColor2.g)
	    self.currentColor2.b = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor2.b, self.targetColor2.b)
		
	    draw.RoundedBox(0, 0, 0, w, h, self.currentColor)
		  draw.SimpleText("Пополнить", 'donate_text', w /2, h / 2, self.currentColor2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		  --draw.SimpleText("Основные взаимодействия", 'LuctusScoreFontSmallest', w /128, h / 1.4, self.currentColor2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		--surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
		--surface.SetMaterial( Material( "donate/tab_fon.png" ) ) -- Use our cached material
		--surface.DrawTexturedRect( 0, 0, w, h ) -- Actually draw the rectangle
	  end


    local list = vgui.Create("DScrollPanel", settings_frame)
    list:SetSize(w * .3, h)
    list:SetX(10)
    local sbar = list:GetVBar()
    function sbar:Paint(w, h)
    end

    function sbar.btnUp:Paint(w, h)
    end

    function sbar.btnDown:Paint(w, h)
    end

    function sbar.btnGrip:Paint(w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(grad2)
        surface.DrawTexturedRect(6, 0, 6, h / 2)
        surface.SetMaterial(grad1)
        surface.DrawTexturedRect(6, h / 2, 6, h / 2)
    end
    local clr_gray = Color(0, 0, 0, 100)
    local clr_text = color_white
    local clr_category = Color(255, 140, 0)
    settings_frame.discount = donatelist.discount
    INTRO_PANEL.infos = {}
    local theid = 0
    local infopanel = vgui.Create("DPanel", settings_frame)
    infopanel:SetSize(w - list:GetWide() - 20, h)
    infopanel:SetPos(list:GetWide() + list:GetX(), 0)
    infopanel.Paint = function() end

    --settings_frame.gimemone = BREACH.AdminLogs.UI:CreateRichText(BREACH.AdminLogs.UI:ExplodeText("У вас " .. LocalPlayer():IGSFunds() .. " " .. table.Random(tbl_italia_brainrot)), 0, 0, settings_frame:GetWide() - 30, 5, nil, "donate_text", color_white, TEXT_ALIGN_RIGHT)
    --settings_frame.gimemone:PositionLabels(true)
    --settings_frame.gimemone:SetParent(settings_frame)
    --settings_frame.gimemone:SetPos(settings_frame:GetWide(), 40)
    --local gimemonebuten = vgui.Create("DButton", contacts.gimemone)
    --gimemonebuten:Dock(FILL)
    --gimemonebuten.Paint = function(self) end
    --gimemonebuten:SetText("")
    --gimemonebuten.DoClick = function(self) Deposit2() end
    local contacts = vgui.Create("DPanel", infopanel)
    contacts:SetPos(0, infopanel:GetTall() / 2)
    contacts:SetSize(infopanel:GetWide(), infopanel:GetTall() / 2)
    contacts.Paint = function(self, w, h)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(gradient2)
        surface.DrawTexturedRect(w / 2, 0, w / 2, 3)
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect(0, 0, w / 2, 3)

    end

    --contacts.str = BREACH.AdminLogs.UI:CreateRichText(BREACH.AdminLogs.UI:ExplodeText(L(donatelist.Info)), 0, 0, contacts:GetWide() - 30, 5, nil, "donate_text", color_white)
    --contacts.str:PositionLabels(true)
    --contacts.str:SetParent(contacts)
    --contacts.str:SetPos(15, 15)
    --local buten = vgui.Create("DButton", contacts.str)
    --buten:Dock(FILL)
    --buten.Paint = function() end
    --buten:SetText("")
    --buten.DoClick = function(self)
    --    local item = INTRO_PANEL.infos[infopanel.currentstart]
    --    if not item then return end
    --    if item.islevelcock then
    --        net.Start("fastbuymehouse")
    --        net.WriteUInt(curlevel, 8)
    --        net.SendToServer()
    --    elseif item.ispremcock then
    --      net.Start("fastbuymehouse1")
    --        net.WriteUInt(curlevel, 8)
    --      net.SendToServer()
    --    elseif item.uid ~= nil then
    --        print(item.uid)
    --        IGS.Purchase(item.uid)
    --    else
    --        print("шота фурри басота не напастила донаты так шо терпи не хочу покупаца")
    --    end
  --
    --    if IsValid(INTRO_PANEL.settings_frame) then
    --        INTRO_PANEL.settings_frame:AlphaTo(0, 1, 0, function()
    --            INTRO_PANEL.settings_frame:Remove()
    --            INTRO_PANEL.settings_frame = nil
    --        end)
    --        return
    --    end
    --end

    contacts.str = vgui.Create("DButton",contacts)
	  contacts.str:SetSize(contacts:GetWide(), h / 24)
	  contacts.str:SetText("")
	  contacts.str:SetPos(10 , 10)
    --BuyBut:SetZPos(32767)
	  contacts.str.defaultColor = Color(255, 255, 255)
	  contacts.str.hoverColor = Color(0, 0, 0)
	  contacts.str.currentColor =  Color(contacts.str.defaultColor.r, contacts.str.defaultColor.g, contacts.str.defaultColor.b)
	  contacts.str.currentColor2 = Color(contacts.str.hoverColor.r ,  contacts.str.hoverColor.g  , contacts.str.hoverColor.b)
	  function contacts.str:DoClick()
	  	--self:GetParent().ActiveCat = self.Cat
	  	--NewF4SelectCat(self:GetParent().ActiveCat)
      --Deposit2()
          local item = INTRO_PANEL.infos[infopanel.currentstart]
          if not item then return end
          if item.islevelcock then
              net.Start("fastbuymehouse")
              net.WriteUInt(curlevel, 8)
              net.SendToServer()
          elseif item.ispremcock then
            if curlevel == 0 then
              print("неа")
            else
            net.Start("fastbuymehouse1")
              net.WriteUInt(curlevel, 8)
            net.SendToServer()
            end
          elseif item.uid ~= nil then
              print(item.uid)
              IGS.Purchase(item.uid)
          else
              print("шота фурри басота не напастила донаты так шо терпи не хочу покупаца")
          end
          if IsValid(INTRO_PANEL.settings_frame) then
              INTRO_PANEL.settings_frame:AlphaTo(0, 1, 0, function()
                  INTRO_PANEL.settings_frame:Remove()
                  INTRO_PANEL.settings_frame = nil
              end)
              return
          end
	  end
	  function contacts.str:Paint(w, h)
		  self.colorChangeSpeed = 12
		  self.defaultColor = Color(255, 255, 255)
		  self.hoverColor = Color(0, 0, 0)
	    self.targetColor = self:IsHovered() and self.hoverColor or self.defaultColor
		  self.targetColor2 = self:IsHovered() and self.defaultColor or self.hoverColor
	
	    self.currentColor.r = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor.r, self.targetColor.r)
	    self.currentColor.g = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor.g, self.targetColor.g)
	    self.currentColor.b = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor.b, self.targetColor.b)

		  self.currentColor2.r = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor2.r, self.targetColor2.r)
	    self.currentColor2.g = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor2.g, self.targetColor2.g)
	    self.currentColor2.b = Lerp(FrameTime() * self.colorChangeSpeed, self.currentColor2.b, self.targetColor2.b)
		
	    draw.RoundedBox(0, 0, 0, w, h, self.currentColor)
		  draw.SimpleText(L(donatelist.Info), 'donate_text', w /2, h / 2, self.currentColor2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		  --draw.SimpleText("Основные взаимодействия", 'LuctusScoreFontSmallest', w /128, h / 1.4, self.currentColor2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		--surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
		--surface.SetMaterial( Material( "donate/tab_fon.png" ) ) -- Use our cached material
		--surface.DrawTexturedRect( 0, 0, w, h ) -- Actually draw the rectangle
	  end



    --contacts.gimemone = BREACH.AdminLogs.UI:CreateRichText(BREACH.AdminLogs.UI:ExplodeText("> У вас " .. LocalPlayer():IGSFunds() .. " " .. table.Random(tbl_italia_brainrot) .. " (Нажми чтобы пополнить) <"), 0, 0, contacts:GetWide() - 30, 5, nil, "donate_text", color_white)
    --contacts.gimemone:PositionLabels(true)
    --contacts.gimemone:SetParent(contacts)
    --contacts.gimemone:SetPos(15, 40)
    --local gimemonebuten = vgui.Create("DButton", contacts.gimemone)
    --gimemonebuten:Dock(FILL)
    --gimemonebuten.Paint = function(self) end
    --gimemonebuten:SetText("")
    --gimemonebuten.DoClick = function(self) Deposit2() end
    local item_desc = vgui.Create("DPanel", infopanel)
    item_desc:SetPos(0, 0)
    item_desc:SetSize(infopanel:GetWide(), infopanel:GetTall() / 2)
    item_desc.Paint = function() end
    infopanel.desc = item_desc
    function infopanel:ShowStat(id)
        if self.currentstart == id then return end
        if IsValid(self.levelcoolshit) then self.levelcoolshit:Remove() end
        if IsValid(self.levelcoolshit_pan) then self.levelcoolshit_pan:Remove() end
        local islevelcock = INTRO_PANEL.infos[id].islevelcock
        local ispremcock = INTRO_PANEL.infos[id].ispremcock
        self.currentstart = id
        if not self.uid then contacts.str.data_text = "idi naxuy" end
        local tutle = L(INTRO_PANEL.infos[id].category .. " | " .. INTRO_PANEL.infos[id].name)
        local prce = INTRO_PANEL.infos[id].price
        if isfunction(prce) then prce = prce(LocalPlayer():GetNLevel()) end
        local pruce = L("l:donate_price " .. prce)
        self.desc.Paint = function(self, w, h)
            draw.DrawText(tutle, "donate_text", 15, 1, color_white, TEXT_ALIGN_LEFT)
            if not islevelcock and not ispremcock then draw.DrawText(pruce, "donate_text", 15, 30, color_white, TEXT_ALIGN_LEFT) end
        end

        if ispremcock then
            local mylevelcoooock = 0
            curlevel = 1
            local dragme = L"l:donate_dragme"
            self.levelcoolshit = vgui.Create("DButton", self)
            self.levelcoolshit:SetText("")
            self.levelcoolshit.Paint = function(self, w, h)
                surface.SetDrawColor(color_white)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
                draw.DrawText(dragme, "donate_text", w / 2, 5, color_white, TEXT_ALIGN_CENTER)
            end

            self.levelcoolshit:SetSize(200, 30)
            self.levelcoolshit:SetPos(10, 30)
            self.levelcoolshit.OnMousePressed = function(self)
                self.pressed = true -- почему щаки так помешан на членах??
                self.mx = gui.MouseX()
                self.s = mylevelcoooock
            end

            self.levelcoolshit.Think = function(me)
                if me.pressed then
                    if not input.IsMouseDown(MOUSE_LEFT) then
                        me.pressed = false
                        return
                    end

                    mylevelcoooock = math.floor(math.max(0, me.s - (me.mx - gui.MouseX()) * 0.1))
                    if mylevelcoooock ~= curlevel then
                        curlevel = mylevelcoooock
                        self.levelcoolshit_pan:UpdateLevel(curlevel)
                    end
                end
            end

            self.levelcoolshit_pan = vgui.Create("DPanel", self)
            local t1 = L"l:donate_howmanylevels2"
            local t2 = L"l:donate_willcostyou2"
            self.levelcoolshit_pan:SetSize(400, 200)
            self.levelcoolshit_pan:SetPos(10, 60)
            self.levelcoolshit_pan.myleeevooool = curlevel
            function self.levelcoolshit_pan:UpdateLevel(l)
                self.myleeevooool = l
                self.myprice = CalculateRequiredMoneyForLevel2(LocalPlayer():GetNLevel(), self.myleeevooool)
            end

            self.levelcoolshit_pan:UpdateLevel(curlevel)
            self.levelcoolshit_pan.Paint = function(me, w, h)
                draw.DrawText(t1, "donate_text", 0, 0, color_white, TEXT_ALIGN_LEFT)
                draw.DrawText(curlevel .. " " .. t2 .. " " .. self.levelcoolshit_pan.myprice .. "₽", "donate_text", 0, 30, color_white, TEXT_ALIGN_LEFT)
            end
        end

        if islevelcock then
            local mylevelcoooock = 0
            curlevel = 1
            local dragme = L"l:donate_dragme"
            self.levelcoolshit = vgui.Create("DButton", self)
            self.levelcoolshit:SetText("")
            self.levelcoolshit.Paint = function(self, w, h)
                surface.SetDrawColor(color_white)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
                draw.DrawText(dragme, "donate_text", w / 2, 5, color_white, TEXT_ALIGN_CENTER)
            end

            self.levelcoolshit:SetSize(200, 30)
            self.levelcoolshit:SetPos(10, 30)
            self.levelcoolshit.OnMousePressed = function(self)
                self.pressed = true -- почему щаки так помешан на членах??
                self.mx = gui.MouseX()
                self.s = mylevelcoooock
            end

            self.levelcoolshit.Think = function(me)
                if me.pressed then
                    if not input.IsMouseDown(MOUSE_LEFT) then
                        me.pressed = false
                        return
                    end

                    mylevelcoooock = math.floor(math.max(0, me.s - (me.mx - gui.MouseX()) * 0.1))
                    if mylevelcoooock ~= curlevel then
                        curlevel = mylevelcoooock
                        self.levelcoolshit_pan:UpdateLevel(curlevel)
                    end
                end
            end

            self.levelcoolshit_pan = vgui.Create("DPanel", self)
            local t1 = L"l:donate_howmanylevels"
            local t2 = L"l:donate_willcostyou"
            self.levelcoolshit_pan:SetSize(400, 200)
            self.levelcoolshit_pan:SetPos(10, 60)
            self.levelcoolshit_pan.myleeevooool = curlevel
            function self.levelcoolshit_pan:UpdateLevel(l)
                self.myleeevooool = l
                self.myprice = CalculateRequiredMoneyForLevel(LocalPlayer():GetNLevel(), self.myleeevooool)
            end

            self.levelcoolshit_pan:UpdateLevel(curlevel)
            self.levelcoolshit_pan.Paint = function(me, w, h)
                draw.DrawText(t1, "donate_text", 0, 0, color_white, TEXT_ALIGN_LEFT)
                draw.DrawText(curlevel .. " " .. t2 .. " " .. self.levelcoolshit_pan.myprice .. "₽", "donate_text", 0, 30, color_white, TEXT_ALIGN_LEFT)
            end
        end

        if IsValid(self.str) then self.str:Remove() end
        if INTRO_PANEL.infos[id].desc then
            self.str = BREACH.AdminLogs.UI:CreateRichText(BREACH.AdminLogs.UI:ExplodeText(L(INTRO_PANEL.infos[id].desc)), 0, 0, self:GetWide() - 30, 5, nil, "donate_text", color_white)
            self.str:PositionLabels(true) -- str:Dock(TOP)
            self.str:SetParent(self)
            self.str:SetPos(15, 70)
        end
    end

    for i = 1, #donatelist.categories do
        local item = donatelist.categories[i]
        local panel = vgui.Create("DPanel", list)
        panel:Dock(TOP)
        panel:SetSize(0, 25)
        local name = L(item.name)
        panel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, clr_gray)
            drawmat(0, 0, w, 1, gradients)
            drawmat(0, h - 1, w, 1, gradients)
            draw.DrawText(name, "ScoreboardContent", w / 2, 5, clr_category, TEXT_ALIGN_CENTER)
        end

        for i1 = 1, #item.items do
            local item1 = item.items[i1]
            local panel = vgui.Create("DPanel", list)
            panel:Dock(TOP)
            panel:SetSize(0, 100)
            local uniqid = theid + 1
            theid = uniqid
            local discount = donatelist.discount
            local price = item1.price
            local prce = item1.price
            if isfunction(prce) then prce = prce(LocalPlayer():GetNLevel()) end
            local discountedprice = math.Round(prce * ((100 - discount) / 100), 2)
            local minusprice = prce - discountedprice
            if item1.multiply then
                discountedprice = discountedprice * item1.multiply
                minusprice = item1.price * item1.multiply - discountedprice
            end

            local text = discountedprice .. "₽"
            if discount > 0 then
                text = text .. "(выгода " .. minusprice .. "₽)" -- яйца лизни с выгодый 14/88 процентов
            end

            INTRO_PANEL.infos[uniqid] = {
                name = L(item1.name),
                desc = item1.desc,
                uid = item1.uid or nil,
                price = text,
                category = L(item.name),
                islevelcock = item1.islevelcock,
                ispremcock = item1.ispremcock,
            }

            panel.id = uniqid
            local trigger = vgui.Create("DButton", panel)
            trigger:Dock(FILL)
            trigger:SetText("")
            trigger.Paint = function() end
            panel.lerp = 0
            local add_x = 0
            local sex_name = L(item1.name)
            local sex_icon = item1.icon
            local sex_price = item1.predesc
            panel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, clr_gray)
                drawmat(0, 0, w, 1, gradients)
                drawmat(0, h - 1, w, 1, gradients)
                if trigger:IsHovered() then infopanel:ShowStat(self.id) end
                surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
	              surface.SetMaterial( sex_icon ) -- Use our cached material
	              surface.DrawTexturedRect( 0 + add_x, 10, h , h ) -- Actually draw the rectangle
                if infopanel.currentstart == uniqid then
                    draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(color_white, 10))
                    add_x = math.Approach(add_x, 13, FrameTime() * 350)
                    self.lerp = math.Approach(self.lerp, 1, FrameTime())
                    draw.DrawText(">", "donate_text", 10, h / 2, ColorAlpha(color_white, 115 + (140 * (self.lerp * 3))))
                else
                    add_x = math.Approach(add_x, 0, FrameTime() * 150)
                    self.lerp = math.Approach(self.lerp, 0, FrameTime())
                end
                draw.DrawText(sex_price, "donate_text", w , h * 0.8, ColorAlpha(clr_category, 115 + (140 * (self.lerp * 3))), TEXT_ALIGN_RIGHT) --draw.DrawText(text, font, 10+add_x, 0, ColorAlpha(color_white, 115 + (140*(button.lerp*3))))
                draw.DrawText(sex_name, "donate_text", 10 + add_x, 1, ColorAlpha(color_white, 115 + (140 * (self.lerp * 3))), TEXT_ALIGN_LEFT) --draw.DrawText(text, font, 10+add_x, 0, ColorAlpha(color_white, 115 + (140*(button.lerp*3))))
            end
        end
    end
end

function OpenConfigMenu()
  local scrw, scrh = ScrW(), ScrH()


  local animation_duration = 0.3
  local button_press_offset = 2
  

  local function AnimateButtonPress(btn)
      if not IsValid(btn) then return end
      
      local origX, origY = btn:GetPos()
      local origW, origH = btn:GetSize()
      

      btn:SetPos(origX, origY + button_press_offset)
      btn:SetSize(origW, origH - button_press_offset)
      
      timer.Simple(animation_duration * 0.3, function()
          if IsValid(btn) then
              btn:SetPos(origX, origY)
              btn:SetSize(origW, origH)
          end
      end)
  end
  

  local function SetupButtonHoverAnimation(btn, scale)
      scale = scale or 1.05
      local origW, origH = btn:GetSize()
      local isHovered = false
      local animTime = 0.1
      
      btn.Think = function(self)
          local hover = self:IsHovered()
          
          if hover ~= isHovered then
              isHovered = hover
              local targetW = hover and origW * scale or origW
              local targetH = hover and origH * scale or origH
              

              if hover then
                  self:SizeTo(targetW, targetH, animTime, 0, -1)
              else
                  self:SizeTo(targetW, targetH, animTime, 0, -1)
              end
          end
      end
  end

  if IsValid(INTRO_PANEL.settings_frame) then

    INTRO_PANEL.settings_frame:MoveTo(scrw, 50, animation_duration, 0, -1, function()
        if IsValid(INTRO_PANEL.settings_frame) then
            INTRO_PANEL.settings_frame:Remove()
            INTRO_PANEL.settings_frame = nil
        end
    end)
    INTRO_PANEL.settings_frame:AlphaTo(0, animation_duration)
    return
  end

  local settings_frame = vgui.Create("DScrollPanel", INTRO_PANEL)
  INTRO_PANEL.settings_frame = settings_frame
  local sbar = settings_frame:GetVBar()
  function sbar:Paint(w, h)
  end
  function sbar.btnUp:Paint(w, h)
  end
  function sbar.btnDown:Paint(w, h)
  end
  function sbar.btnGrip:Paint(w, h)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(6, 0, 6, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(6, h/2, 6, h/2)
  end
  

  settings_frame:SetAlpha(0)
  settings_frame:SetSize(450, scrh-100)
  settings_frame:SetPos(scrw/1.5, 50)
  settings_frame:MoveTo(scrw/1.5-500, 50, animation_duration, 0, -1)
  settings_frame:AlphaTo(255, animation_duration)
  
  settings_frame.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,dark_clr)
    DrawBlurPanel(self)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(grad2)
    surface.DrawTexturedRect(0, 0, 3, h/2)
    surface.DrawTexturedRect(w-3, 0, 3, h/2)
    surface.SetMaterial(grad1)
    surface.DrawTexturedRect(0, h/2, 3, h/2)
    surface.DrawTexturedRect(w-3, h/2, 3, h/2)
  end

  local function choicepanel(choices, convar)
    if IsValid(choices_panel_settings) then choices_panel_settings:Remove() end
    choices_panel_settings = vgui.Create("DScrollPanel", INTRO_PANEL)
    local x, y = gui.MousePos()
    x = math.min(x, INTRO_PANEL.settings_frame:GetX())

    choices_panel_settings:SetSize(80,200)
    choices_panel_settings:SetPos(x-100, y)
    choices_panel_settings:SetAlpha(0)
    

    choices_panel_settings:AlphaTo(255, animation_duration)
    choices_panel_settings:SetSize(80, 0)
    choices_panel_settings:SizeTo(80, 200, animation_duration, 0, -1)

    for _, value in pairs(choices) do
      local apply = vgui.Create("DButton", choices_panel_settings)
      apply:Dock(TOP)
      apply:SetSize(80, 30)
      apply:SetPos(90,300-40)
      apply:SetText("")
      

      SetupButtonHoverAnimation(apply, 1.02)
      
      apply.Paint = function(self, w, h)
        drawmat(0,0,w,1,gradients)
        drawmat(0,h-1,w,1,gradients)

        if translate_translations[value] then
          draw.DrawText(translate_translations[value], "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
        else
          draw.DrawText(value, "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
        end
      end

      apply.DoClick = function(self)
        AnimateButtonPress(self)
        GetConVar(convar):SetString(value)
        choices_panel_settings:AlphaTo(0, animation_duration, 0, function()
          if IsValid(choices_panel_settings) then
            choices_panel_settings:Remove()
          end
        end)
      end
    end
  end

  local function create_prefix_panel(data)
    if IsValid(COLOR_PANEL_SETTINGS) then 
        COLOR_PANEL_SETTINGS:AlphaTo(0, animation_duration, 0, function()
            if IsValid(COLOR_PANEL_SETTINGS) then
                COLOR_PANEL_SETTINGS:Remove()
            end
        end)
        return
    end

    COLOR_PANEL_SETTINGS = vgui.Create("DFrame", INTRO_PANEL)
    COLOR_PANEL_SETTINGS:SetSize(300,400)
    COLOR_PANEL_SETTINGS:Center()
    COLOR_PANEL_SETTINGS:SetAlpha(0)
    COLOR_PANEL_SETTINGS:AlphaTo(255, animation_duration)
    COLOR_PANEL_SETTINGS:ShowCloseButton(false)
    

    COLOR_PANEL_SETTINGS:SetSize(10, 10)
    COLOR_PANEL_SETTINGS:SetPos(scrw/2 - 5, scrh/2 - 5)
    COLOR_PANEL_SETTINGS:MoveTo(scrw/2 - 150, scrh/2 - 200, animation_duration, 0, -1)
    COLOR_PANEL_SETTINGS:SizeTo(300, 400, animation_duration, 0, -1)

    EDITABLEBAPENL = vgui.Create("DTextEntry", COLOR_PANEL_SETTINGS)
    EDITABLEBAPENL:SetPos(10, 325)
    EDITABLEBAPENL:SetSize(280, 20)
    EDITABLEBAPENL:SetFont("ChatFont_new")
    EDITABLEBAPENL:SetText(data.prefix)
    EDITABLEBAPENL:SetAlpha(0)
    EDITABLEBAPENL:AlphaTo(255, animation_duration, animation_duration * 0.2)

    local visible_panel = vgui.Create("DPanel", COLOR_PANEL_SETTINGS)
    visible_panel:SetPos(10, 300)
    visible_panel:SetSize(100,25)
    visible_panel:SetAlpha(0)
    visible_panel:AlphaTo(255, animation_duration, animation_duration * 0.3)
    visible_panel.Paint = function() draw.DrawText("Enabled", "ChatFont_new", 30, 4) end
    local visible = vgui.Create("DCheckBox", visible_panel)
    visible:SetSize(25,25)
    visible:SetValue(data.enabled)

    visible.OnChange = function(self, val) data.enabled = val end

    local rainbow_panel = vgui.Create("DPanel", COLOR_PANEL_SETTINGS)
    rainbow_panel:SetPos(110, 300)
    rainbow_panel:SetSize(100,25)
    rainbow_panel:SetAlpha(0)
    rainbow_panel:AlphaTo(255, animation_duration, animation_duration * 0.4)
    rainbow_panel.Paint = function() draw.DrawText("Rainbow", "ChatFont_new", 30, 4) end
    local rainbow = vgui.Create("DCheckBox", rainbow_panel)
    rainbow:SetSize(25,25)
    rainbow:SetValue(data.rainbow)

    rainbow.OnChange = function(self, val) data.rainbow = val end

    EDITABLEBAPENL.OnTextChanged = function(self)
      local val = self:GetText()
      if utf8.len(val) > 20 then
        self:SetText(utf8.sub(val, 0, 20))
      end
    end

    local colt = string.Explode(",", data.color)
    local color = Color(tonumber(colt[1]),tonumber(colt[2]),tonumber(colt[3]))

    local col = vgui.Create("DColorCombo", COLOR_PANEL_SETTINGS)
    col:SetSize(300,250)
    col:SetColor(color)
    col:SetAlpha(0)
    col:AlphaTo(255, animation_duration, animation_duration * 0.1)

    COLOR_PANEL_SETTINGS.Paint = function(self, w, h)
      local mycol = col:GetColor()
      draw.DrawText("RGB: "..mycol.r..","..mycol.g..","..mycol.b, "BudgetLabel", w,3, mycol, TEXT_ALIGN_RIGHT)
      COLOR_PANEL_SETTINGS:MakePopup()
    end

    local apply = vgui.Create("DButton", COLOR_PANEL_SETTINGS)
    apply:SetSize(80, 30)
    apply:SetPos(50,350)
    apply:SetText("")
    apply:SetAlpha(0)
    apply:AlphaTo(255, animation_duration, animation_duration * 0.5)
    

    SetupButtonHoverAnimation(apply, 1.05)
    
    apply.Paint = function(self, w, h)
      drawmat(0,0,w,1,gradients)
      drawmat(0,h-1,w,1,gradients)
      draw.DrawText("APPLY", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
    end

    apply.DoClick = function(self)
      AnimateButtonPress(self)
      
      local color = col:GetColor()
      data.color = tostring(color.r)..","..tostring(color.g)..","..tostring(color.b)
      data.prefix = EDITABLEBAPENL:GetText()
      file.Write("breach_prefix_settings.txt", util.TableToJSON(data, true))
      send_prefix_data()
      pub_text_panel.prefix:SizeToContents()
      

      COLOR_PANEL_SETTINGS:AlphaTo(0, animation_duration)
      COLOR_PANEL_SETTINGS:SizeTo(10, 10, animation_duration, 0, -1, function()
        if IsValid(COLOR_PANEL_SETTINGS) then
          COLOR_PANEL_SETTINGS:Remove()
        end
      end)
      timer.Simple(0.1, function() 
        if IsValid(pub_text_panel) and IsValid(pub_text_panel.prefix) then
          pub_text_panel.prefix:SizeToContents() 
        end
      end)
    end

    local cancel = vgui.Create("DButton", COLOR_PANEL_SETTINGS)
    cancel:SetSize(80, 30)
    cancel:SetPos(300-80-50,350)
    cancel:SetText("")
    cancel:SetAlpha(0)
    cancel:AlphaTo(255, animation_duration, animation_duration * 0.6)
    

    SetupButtonHoverAnimation(cancel, 1.05)
    
    cancel.Paint = function(self, w, h)
      drawmat(0,0,w,1,gradients)
      drawmat(0,h-1,w,1,gradients)
      draw.DrawText("CANCEL", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
    end

    cancel.DoClick = function(self)
      AnimateButtonPress(self)

      COLOR_PANEL_SETTINGS:AlphaTo(0, animation_duration)
      COLOR_PANEL_SETTINGS:SizeTo(10, 10, animation_duration, 0, -1, function()
        if IsValid(COLOR_PANEL_SETTINGS) then
          COLOR_PANEL_SETTINGS:Remove()
        end
      end)
    end
  end

  local function create_color_panel(color)
    if IsValid(COLOR_PANEL_SETTINGS) then 
        COLOR_PANEL_SETTINGS:AlphaTo(0, animation_duration, 0, function()
            if IsValid(COLOR_PANEL_SETTINGS) then
                COLOR_PANEL_SETTINGS:Remove()
            end
        end)
        return
    end

    COLOR_PANEL_SETTINGS = vgui.Create("DPanel", INTRO_PANEL)
    COLOR_PANEL_SETTINGS:SetSize(300,300)
    COLOR_PANEL_SETTINGS:Center()
    COLOR_PANEL_SETTINGS:SetAlpha(0)
    COLOR_PANEL_SETTINGS:AlphaTo(255, animation_duration)
    

    COLOR_PANEL_SETTINGS:SetSize(10, 10)
    COLOR_PANEL_SETTINGS:SetPos(scrw/2 - 5, scrh/2 - 5)
    COLOR_PANEL_SETTINGS:MoveTo(scrw/2 - 150, scrh/2 - 150, animation_duration, 0, -1)
    COLOR_PANEL_SETTINGS:SizeTo(300, 300, animation_duration, 0, -1)

    local convar = GetConVar("breach_config_name_color")

    local col = vgui.Create("DColorCombo", COLOR_PANEL_SETTINGS)
    col:SetSize(300,250)
    col:SetColor(color)
    col:SetAlpha(0)
    col:AlphaTo(255, animation_duration, animation_duration * 0.2)

    COLOR_PANEL_SETTINGS.Paint = function(self, w, h)
      local mycol = col:GetColor()
      draw.RoundedBox(0,5,h-45,40,40,mycol)
      draw.DrawText("RGB: "..mycol.r..","..mycol.g..","..mycol.b, "BudgetLabel", w,3, mycol, TEXT_ALIGN_RIGHT)
    end

    local apply = vgui.Create("DButton", COLOR_PANEL_SETTINGS)
    apply:SetSize(80, 30)
    apply:SetPos(90,260)
    apply:SetText("")
    apply:SetAlpha(0)
    apply:AlphaTo(255, animation_duration, animation_duration * 0.4)
    
    SetupButtonHoverAnimation(apply, 1.05)
    
    apply.Paint = function(self, w, h)
      drawmat(0,0,w,1,gradients)
      drawmat(0,h-1,w,1,gradients)
      draw.DrawText("APPLY", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
    end

    apply.DoClick = function(self)
      AnimateButtonPress(self)
      local col = col:GetColor()
      convar:SetString(tostring(col.r)..","..tostring(col.g)..","..tostring(col.b))
      

      COLOR_PANEL_SETTINGS:AlphaTo(0, animation_duration)
      COLOR_PANEL_SETTINGS:SizeTo(10, 10, animation_duration, 0, -1, function()
        if IsValid(COLOR_PANEL_SETTINGS) then
          COLOR_PANEL_SETTINGS:Remove()
        end
      end)
    end

    local cancel = vgui.Create("DButton", COLOR_PANEL_SETTINGS)
    cancel:SetSize(80, 30)
    cancel:SetPos(180,260)
    cancel:SetText("")
    cancel:SetAlpha(0)
    cancel:AlphaTo(255, animation_duration, animation_duration * 0.5)
    
    SetupButtonHoverAnimation(cancel, 1.05)
    
    cancel.Paint = function(self, w, h)
      drawmat(0,0,w,1,gradients)
      drawmat(0,h-1,w,1,gradients)
      draw.DrawText("CANCEL", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
    end

    cancel.DoClick = function(self)
      AnimateButtonPress(self)
      COLOR_PANEL_SETTINGS:AlphaTo(0, animation_duration)
      COLOR_PANEL_SETTINGS:SizeTo(10, 10, animation_duration, 0, -1, function()
        if IsValid(COLOR_PANEL_SETTINGS) then
          COLOR_PANEL_SETTINGS:Remove()
        end
      end)
    end
  end

  local function hair_color_panel(color)
    if IsValid(COLOR_PANEL_SETTINGS) then 
        COLOR_PANEL_SETTINGS:AlphaTo(0, animation_duration, 0, function()
            if IsValid(COLOR_PANEL_SETTINGS) then
                COLOR_PANEL_SETTINGS:Remove()
            end
        end)
        return
    end

    COLOR_PANEL_SETTINGS = vgui.Create("DPanel", INTRO_PANEL)
    COLOR_PANEL_SETTINGS:SetSize(300,300)
    COLOR_PANEL_SETTINGS:Center()
    COLOR_PANEL_SETTINGS:SetAlpha(0)
    COLOR_PANEL_SETTINGS:AlphaTo(255, animation_duration)
    

    COLOR_PANEL_SETTINGS:SetSize(10, 10)
    COLOR_PANEL_SETTINGS:SetPos(scrw/2 - 5, scrh/2 - 5)
    COLOR_PANEL_SETTINGS:MoveTo(scrw/2 - 150, scrh/2 - 150, animation_duration, 0, -1)
    COLOR_PANEL_SETTINGS:SizeTo(300, 300, animation_duration, 0, -1)

    local convar = GetConVar("breach_config_hair_color")

    local col = vgui.Create("DColorCombo", COLOR_PANEL_SETTINGS)
    col:SetSize(300,250)
    col:SetColor(color)
    col:SetAlpha(0)
    col:AlphaTo(255, animation_duration, animation_duration * 0.2)

    COLOR_PANEL_SETTINGS.Paint = function(self, w, h)
      local mycol = col:GetColor()
      draw.RoundedBox(0,5,h-45,40,40,mycol)
      draw.DrawText("RGB: "..mycol.r..","..mycol.g..","..mycol.b, "BudgetLabel", w,3, mycol, TEXT_ALIGN_RIGHT)
    end

    local apply = vgui.Create("DButton", COLOR_PANEL_SETTINGS)
    apply:SetSize(80, 30)
    apply:SetPos(90,260)
    apply:SetText("")
    apply:SetAlpha(0)
    apply:AlphaTo(255, animation_duration, animation_duration * 0.4)
    
    SetupButtonHoverAnimation(apply, 1.05)
    
    apply.Paint = function(self, w, h)
      drawmat(0,0,w,1,gradients)
      drawmat(0,h-1,w,1,gradients)
      draw.DrawText("APPLY", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
    end

    apply.DoClick = function(self)
      AnimateButtonPress(self)
      local col = col:GetColor()
      convar:SetString(tostring(col.r)..","..tostring(col.g)..","..tostring(col.b))
      

      COLOR_PANEL_SETTINGS:AlphaTo(0, animation_duration)
      COLOR_PANEL_SETTINGS:SizeTo(10, 10, animation_duration, 0, -1, function()
        if IsValid(COLOR_PANEL_SETTINGS) then
          COLOR_PANEL_SETTINGS:Remove()
        end
      end)
    end

    local cancel = vgui.Create("DButton", COLOR_PANEL_SETTINGS)
    cancel:SetSize(80, 30)
    cancel:SetPos(180,260)
    cancel:SetText("")
    cancel:SetAlpha(0)
    cancel:AlphaTo(255, animation_duration, animation_duration * 0.5)
    
    SetupButtonHoverAnimation(cancel, 1.05)
    
    cancel.Paint = function(self, w, h)
      drawmat(0,0,w,1,gradients)
      drawmat(0,h-1,w,1,gradients)
      draw.DrawText("CANCEL", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
    end

    cancel.DoClick = function(self)
      AnimateButtonPress(self)
      COLOR_PANEL_SETTINGS:AlphaTo(0, animation_duration)
      COLOR_PANEL_SETTINGS:SizeTo(10, 10, animation_duration, 0, -1, function()
        if IsValid(COLOR_PANEL_SETTINGS) then
          COLOR_PANEL_SETTINGS:Remove()
        end
      end)
    end
  end


  local category_delay = 0
  for _, category in pairs(BREACH.Options) do
    if category.premium and !LocalPlayer():IsPremium() then continue end
    if category.prefix and !LocalPlayer():GetNWBool("have_prefix") then continue end

    local category_panel = vgui.Create("DPanel",settings_frame)

    local clr_gray = Color(0,0,0,100)
    local clr_text = color_white

    if category.premium then
      clr_text = Color(255,215,0)
      clr_gray = Color(255,215,0,5)
    end

    category_panel.Paint = function(self, w, h)
      draw.RoundedBox(0,0,0,w,h,clr_gray)
      drawmat(0,0,w,1,gradients)
      drawmat(0,h-1,w,1,gradients)
      draw.DrawText(L(category.name), "ScoreboardContent", w/2, 5, clr_text, TEXT_ALIGN_CENTER)
    end

    category_panel:Dock(TOP)
    category_panel:SetSize(0,25)
    category_panel:SetAlpha(0)
    category_panel:AlphaTo(255, animation_duration, category_delay)
    category_delay = category_delay + 0.05

    for _, data in pairs(category.settings) do
      if data.premium and !LocalPlayer():IsPremium() then continue end
      if data.checkplayer and !data.checkplayer[LocalPlayer():SteamID64()] and !LocalPlayer():IsSuperAdmin() then continue end
      if data.hair and !LEGACY_HAIRCOLOR[LocalPlayer():SteamID64()] then continue end
      if data.xmasgloves and LocalPlayer():GetNWInt("gloves_xmas") == 0 then continue end
      local convar = GetConVar(data.cvar)

      if data.type == "unique" then
        data.createpanel(settings_frame)
      elseif data.type == "bind" then
        local panel = vgui.Create("DPanel",settings_frame)
        local swap = vgui.Create("DBinder", panel)
        panel:Dock(TOP)
        panel:SetSize(0,40)
        panel:SetAlpha(0)
        panel:AlphaTo(255, animation_duration, category_delay)
        
        panel.Paint = function(self, w, h)
          draw.DrawText(L(data.name), "ScoreboardContent", 140, 5)
          if swap.editmode then
            draw.DrawText(BREACH.TranslateString"l:menu_cancel", "ScoreboardContent", 140, 20)
          end
        end

        swap:SetSize(120, 30)
        swap:SetPos(10,5)
        swap:SetText("")
        swap:SetAlpha(0)
        swap:AlphaTo(255, animation_duration, category_delay + 0.1)
        
        --SetupButtonHoverAnimation(swap, 1.05)
        
        swap.Paint = function(self, w, h)
          drawmat(0,0,w,1,gradients)
          drawmat(0,h-1,w,1,gradients)

          surface.SetDrawColor(color_white)
          surface.SetMaterial(grad2)
          surface.DrawTexturedRect(1, 0, 1, h/2)
          surface.SetMaterial(grad1)
          surface.DrawTexturedRect(1, h/2, 1, h/2)

          surface.SetDrawColor(color_white)
          surface.SetMaterial(grad2)
          surface.DrawTexturedRect(w-1, 0, 1, h/2)
          surface.SetMaterial(grad1)
          surface.DrawTexturedRect(w-1, h/2, 1, h/2)

          if self.editmode then
            draw.DrawText(BREACH.TranslateString"l:menu_press_any_key", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
          elseif self:IsHovered() then
            draw.DrawText(BREACH.TranslateString"l:menu_swap", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
          else
            draw.DrawText(input.GetKeyName(convar:GetInt()):upper(), "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
          end
        end

        swap.DoClick = function(self)
          AnimateButtonPress(self)
          swap.editmode = true
          input.StartKeyTrapping()
          swap.Trapping = true
        end

        swap.OnChange = function(self, new)
          swap.editmode = false
          swap:SetText("")
          if new != KEY_END and isstring(input.GetKeyName(new)) then
            convar:SetInt(new)
          end
        end
      elseif data.type == "slider" then
        local panel = vgui.Create("DPanel",settings_frame)
        panel.lerp = (convar:GetInt()-data.min)/(data.max - data.min)
        panel:SetAlpha(0)
        panel:AlphaTo(255, animation_duration, category_delay)
        
        panel.Paint = function(self, w, h)
          draw.DrawText(L(data.name), "ScoreboardContent", w/2, 2, nil, TEXT_ALIGN_CENTER)
          draw.DrawText(tostring(math.floor(convar:GetInt())), "ScoreboardContent", 35, 2, nil, TEXT_ALIGN_CENTER)

          local value = (convar:GetInt()-data.min)/(data.max - data.min)
          draw.RoundedBox(0, 20, h-17, w-40, 10, gray_clr)
          draw.RoundedBox(0, 20, h-17, (w-40)*value, 10, color_white)
          surface.SetDrawColor(color_white)
          surface.DrawOutlinedRect(18, h-19, w-36, 14, 1)
        end

        panel:Dock(TOP)
        panel:SetSize(0,40)

        local button = vgui.Create("DButton",panel)
        timer.Simple(0, function()
          if IsValid(button) then button:SetSize(panel:GetSize()) end
        end)
        button:SetText("")
        button.Paint = function() end
        button.Activated = false

        button.OnMousePressed = function(self)
          self.savex, self.savey = gui.MousePos()
          self:SetCursor("blank")
          self.CurValue = convar:GetInt()
          self.Activated = true
        end

        button.OnMouseReleased = function(self)
          self:SetCursor("hand")
          self.Activated = false
        end

        button.Think = function(self)
          if !self:IsHovered() and self.Activated and !input.IsMouseDown(MOUSE_LEFT) then self:OnMouseReleased() end
          if self.Activated then
            self.CurValue = self.CurValue - (self.savex - gui.MousePos())*0.05
            if math.floor(convar:GetInt()) != math.floor(math.Clamp(self.CurValue, data.min, data.max)) and (!button.sndcd or button.sndcd <= SysTime()) then
              button.sndcd = SysTime() + 0.05
              sound.PlayFile( "sound/nextoren/gui/main_menu/numslider_change_1.wav", "noplay", function( station, errCode, errStr )
                if ( IsValid( station ) ) then
                  station:Play()
                else
                  print( "Error playing sound!", errCode, errStr )
                end
              end )
            end
            convar:SetInt(math.Clamp(self.CurValue, data.min, data.max))
            gui.SetMousePos(self.savex, self.savey)
          end
        end
      elseif data.type == "choice" then
        local panel = vgui.Create("DPanel",settings_frame)
        panel:Dock(TOP)
        panel:SetSize(0,40)
        panel:SetAlpha(0)
        panel:AlphaTo(255, animation_duration, category_delay)
        
        panel.Paint = function(self, w, h)
          draw.DrawText(L(data.name), "ScoreboardContent", 100, 5)
          local translation = translate_translations[convar:GetString()] or "unknown"
          draw.DrawText(BREACH.TranslateString"l:menu_current_lang "..translation, "ScoreboardContent", 100, 20)
        end

        local swap = vgui.Create("DButton", panel)
        swap:SetSize(80, 30)
        swap:SetPos(10,5)
        swap:SetText("")
        swap:SetAlpha(0)
        swap:AlphaTo(255, animation_duration, category_delay + 0.1)
        
        SetupButtonHoverAnimation(swap, 1.05)
        
        swap.Paint = function(self, w, h)
          drawmat(0,0,w,1,gradients)
          drawmat(0,h-1,w,1,gradients)
          draw.DrawText(BREACH.TranslateString"l:menu_swap", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
        end

        swap.DoClick = function(self)
          AnimateButtonPress(self)
          choicepanel(data.value, data.cvar)
        end
      elseif data.type == "prefix" then
        local panel = vgui.Create("DPanel",settings_frame)
        panel:Dock(TOP)
        panel:SetSize(0,40)
        panel:SetAlpha(0)
        panel:AlphaTo(255, animation_duration, category_delay)
        
        panel.Paint = function(self, w, h)
        end

        local text_panel = vgui.Create("DPanel", panel)
        text_panel:SetSize(200, 20)
        text_panel:SetPos(100,7)
        text_panel:SetAlpha(0)
        text_panel:AlphaTo(255, animation_duration, category_delay + 0.1)
        text_panel.Paint = function() end
        local prefix = vgui.Create("DLabel", text_panel)
        prefix:SetText("["..LocalPlayer():GetNWString("prefix_title", "").."]")
        prefix:SetFont("ChatFont_new")
        prefix:SizeToContents()
        prefix:Dock(LEFT)
        prefix.m_iHue = 0
        prefix.m_iRate = 72
        text_panel.prefix = prefix
        pub_text_panel = text_panel
        local name = vgui.Create("DLabel", text_panel)
        name:SetText(" "..LocalPlayer():Name())
        name:SetFont("ChatFont_new")
        name:SetColor(color_white)
        name:SizeToContents()
        name:Dock(LEFT)
        text_panel.name = name

        panel.Think = function(self)
          local data = util.JSONToTable(file.Read("breach_prefix_settings.txt", "DATA"))
          local coltab = string.Explode(",", data.color)
          local color = Color(tonumber(coltab[1]), tonumber(coltab[2]), tonumber(coltab[3]))

          if !data.rainbow then
            prefix:SetTextColor(color)
          else
            prefix.m_iHue = (prefix.m_iHue + FrameTime() * math.min(720, prefix.m_iRate)) % 360
            prefix:SetTextColor(HSVToColor(prefix.m_iHue, 1, 1))
          end
          prefix:SetText("["..data.prefix.."]")
        end

        local edit = vgui.Create("DButton", panel)
        edit:SetSize(80, 30)
        edit:SetPos(10,5)
        edit:SetText("")
        edit:SetAlpha(0)
        edit:AlphaTo(255, animation_duration, category_delay + 0.2)
        
        SetupButtonHoverAnimation(edit, 1.05)
        
        edit.Paint = function(self, w, h)
          drawmat(0,0,w,1,gradients)
          drawmat(0,h-1,w,1,gradients)
          draw.DrawText("EDIT", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
        end

        edit.DoClick = function(self)
          AnimateButtonPress(self)
          create_prefix_panel(util.JSONToTable(file.Read("breach_prefix_settings.txt", "DATA")))
        end
      elseif data.type == "color" then
        local panel = vgui.Create("DPanel",settings_frame)
        panel:Dock(TOP)
        panel:SetSize(0,40)
        panel:SetAlpha(0)
        panel:AlphaTo(255, animation_duration, category_delay)
        
        panel.Paint = function(self, w, h)
          draw.DrawText(L(data.name), "ScoreboardContent", 100, 5)
          local currentcolor = convar:GetString()
          local tab = string.Split(currentcolor, ",")
          local color = Color(tonumber(tab[1]),tonumber(tab[2]),tonumber(tab[3]))
          self.curcolor = color
          draw.RoundedBox(0,225,5,30,30,color)
        end

        local edit = vgui.Create("DButton", panel)
        edit:SetSize(80, 30)
        edit:SetPos(10,5)
        edit:SetText("")
        edit:SetAlpha(0)
        edit:AlphaTo(255, animation_duration, category_delay + 0.1)
        
        SetupButtonHoverAnimation(edit, 1.05)
        
        edit.Paint = function(self, w, h)
          drawmat(0,0,w,1,gradients)
          drawmat(0,h-1,w,1,gradients)
          draw.DrawText("EDIT", "ScoreboardContent", w/2,7, nil, TEXT_ALIGN_CENTER)
        end

        edit.DoClick = function(self)
          AnimateButtonPress(self)
          if data.name == "l:haircolor" then
            hair_color_panel(panel.curcolor)
          else
            create_color_panel(panel.curcolor)
          end
        end
      elseif data.type == "bool" then
        local panel = vgui.Create("DPanel",settings_frame)
        panel:Dock(TOP)
        panel:SetSize(0,40)
        panel:SetAlpha(0)
        panel:AlphaTo(255, animation_duration, category_delay)
        
        panel.Paint = function(self, w, h)
          draw.DrawText(L(data.name), "ScoreboardContent", 50, 5)
        end
        
        local but = vgui.Create("DButton",panel)
        but:SetSize(30,30)
        but:SetPos(10,5)
        but:SetText("")
        but:SetAlpha(0)
        but:AlphaTo(255, animation_duration, category_delay + 0.1)
        
        SetupButtonHoverAnimation(but, 1.1)
        
        but.DoClick = function(self)
          AnimateButtonPress(self)
          convar:SetBool(!convar:GetBool())
        end
        
        but.lerp = 0
        but.Paint = function(self, w, h)
          surface.SetDrawColor(color_white)
          surface.DrawOutlinedRect(0,0,w,h,1)
          if convar:GetBool() then
            but.lerp = math.Approach(but.lerp, 1, FrameTime()*5)
          else
            but.lerp = math.Approach(but.lerp, 0, FrameTime()*5)
          end
          draw.RoundedBox(0,2,2,w-4,h-4,ColorAlpha(color_white, but.lerp*255))
        end
      end
      category_delay = category_delay + 0.02
    end
    category_delay = category_delay + 0.1
  end
end

function GM:PreRender()

  local ply = LocalPlayer()

  if IsValid(INTRO_PANEL) && !gui.IsGameUIVisible() then INTRO_PANEL:MakePopup() end

  if ( input.IsKeyDown( KEY_ESCAPE ) && gui.IsGameUIVisible()  ) then
    if ( isnumber( ShowMainMenu ) ) then

      gui.HideGameUI()
        if ( ShowMainMenu < CurTime() ) then

          ShowMainMenu = false

        end

        return
    end

    if ( !ShowMainMenu ) then

      gui.HideGameUI()

      if ( INTRO_PANEL && INTRO_PANEL:IsValid() ) then

        INTRO_PANEL.OpenTime = RealTime()
        INTRO_PANEL:SetVisible( true )
        ShowMainMenu = true
        if !(BREACH.Music and BREACH.Music and BREACH.Music.MusicPatch and BREACH.Music.MusicPatch:IsValid() ) then
          mainmenumusic = CreateSound( ply, "nextoren/unity/scpu_menu_theme_v3.01.ogg" )
      mainmenumusic:Play()
    end

      else

        StartBreach(false) -- syka
        ShowMainMenu = true
        if !(BREACH.Music and BREACH.Music and BREACH.Music.MusicPatch and BREACH.Music.MusicPatch:IsValid() ) then
          mainmenumusic = CreateSound( ply, "nextoren/unity/scpu_menu_theme_v3.01.ogg" )
      mainmenumusic:Play()
    end

      end

    end

  end

end