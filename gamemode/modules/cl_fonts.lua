local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player
BREACH.FontsCreated = BREACH.FontsCreated or false

if BREACH.FontsCreated then
	return
end

BREACH.FontsCreated = true
surface.CreateFont("ClassName", {font = "Trebuchet24",
                                    size = 28,
                                    weight = 1000})
surface.CreateFont("TimeLeft",     {font = "Trebuchet24",
                                    size = 24,
                                    weight = 800})
surface.CreateFont("HealthAmmo",   {font = "Trebuchet24",
                                    size = 24,
                                    weight = 750})

surface.CreateFont( "LuctusScoreFontBigest", { font = "Montserrat",extended = true, size = ScreenScale(17), weight = 800, antialias = true, bold = true })
surface.CreateFont( "LuctusScoreFontBig", { font = "Montserrat",extended = true, size = ScreenScale(12), weight = 800, antialias = true, bold = true })
surface.CreateFont( "LuctusScoreFontMiniBig", { font = "Montserrat",extended = true, size = ScreenScale(9), weight = 800, antialias = true, bold = true })
surface.CreateFont( "LuctusScoreFontSmall", { font = "Montserrat",extended = true, size = ScreenScale(7), weight = 700, antialias = true, bold = true })
surface.CreateFont( "LuctusScoreFontSmall2218", { font = "Montserrat",extended = true, size = ScreenScale(7), weight = 700, antialias = false, bold = true })
surface.CreateFont( "LuctusScoreFontSmallest", { font = "Montserrat",extended = true, size = ScreenScale(6), weight = 700, antialias = false, bold = true })
surface.CreateFont( "LuctusScoreFontSmallest2", { font = "Montserrat",extended = true, size = ScreenScale(5), weight = 400, antialias = false, bold = true })
surface.CreateFont( "LuctusScoreFontSmallest3", { font = "Montserrat",extended = true, size = ScreenScale(4), weight = 400, antialias = false, bold = true })

surface.CreateFont( "Event_Terminal", {
	font = "Courier New",
	extended = false,
	size = ScreenScale(5.5),
	weight = 500,
	blursize = 0,
	scanlines = 2,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )