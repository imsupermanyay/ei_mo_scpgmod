AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("Changestatus_SCP914")
util.AddNetworkString("Activate_SCP914")

ENT.ActivationSound = Sound("nextoren/scp/914/refining.ogg")
ENT.PlayerKill = Sound("nextoren/scp/914/player_death.ogg")
ENT.DoorOpenSound = Sound("nextoren/doors/lhz_doors/open_start.ogg")
ENT.DoorCloseSound = Sound("nextoren/doors/lhz_doors/close_start.ogg")

ENT.DoorShouldBeOpened = true

ENT.UpgradeList = {


	["breach_keycard_1"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"breach_keycard_1", NULL},
		["1:1"] = {"breach_keycard_1", "breach_keycard_security_1", "breach_keycard_sci_1"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3"},
	},
	["breach_keycard_2"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5"},
	},
	["breach_keycard_3"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6"},
	},
	["breach_keycard_4"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6"},
	},
	["breach_keycard_security_1"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"breach_keycard_security_1", NULL},
		["1:1"] = {"breach_keycard_1", "breach_keycard_security_1", "breach_keycard_sci_1"},
		["Fine"] = {"breach_keycard_security_2", "breach_keycard_security_1"},
		["Very Fine"] = {"breach_keycard_security_1", "breach_keycard_security_2", "breach_keycard_security_3"},
	},
	["breach_keycard_security_2"] = {
		["Rough"] = {"breach_keycard_security_1"},
		["Coarse"] = {"breach_keycard_security_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2"},
		["Fine"] = {"breach_keycard_security_2", "breach_keycard_security_3", "breach_keycard_security_1"},
		["Very Fine"] = {"breach_keycard_security_1", "breach_keycard_security_2", "breach_keycard_security_3"},
	},
	["breach_keycard_security_3"] = {
		["Rough"] = {"breach_keycard_security_1"},
		["Coarse"] = {"breach_keycard_security_2", "breach_keycard_security_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3"},
		["Fine"] = {"breach_keycard_security_2", "breach_keycard_security_3", "breach_keycard_security_4", "breach_keycard_security_1"},
		["Very Fine"] = {"breach_keycard_security_1", "breach_keycard_security_2", "breach_keycard_guard_2", "breach_keycard_security_3", "breach_keycard_security_4"},
	},
	["breach_keycard_security_4"] = {
		["Rough"] = {"breach_keycard_security_1"},
		["Coarse"] = {"breach_keycard_security_2", "breach_keycard_security_3", "breach_keycard_security_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_security_2", "breach_keycard_security_3", "breach_keycard_security_4", "breach_keycard_guard_4", "breach_keycard_guard_3"},
		["Very Fine"] = {"breach_keycard_security_1", "breach_keycard_security_2", "breach_keycard_security_3", "breach_keycard_security_4", "breach_keycard_6", "breach_keycard_7"},
	},
	["breach_keycard_5"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6"},
	},
	["breach_keycard_6"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6", "breach_keycard_crack", "breach_keycard_7"},
	},
	["breach_keycard_7"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6", "breach_keycard_crack"},
	},


	["breach_keycard_guard_1"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"breach_keycard_1", "breach_keycard_guard_1", "breach_keycard_security_1", NULL},
		["1:1"] = {"breach_keycard_1", "breach_keycard_guard_1", "breach_keycard_security_1", "breach_keycard_sci_1"},
		["Fine"] = {"breach_keycard_guard_2", "breach_keycard_guard_1"},
		["Very Fine"] = {"breach_keycard_guard_1", "breach_keycard_1", "breach_keycard_guard_2", "breach_keycard_guard_3"},
	},
	["breach_keycard_guard_2"] = {
		["Rough"] = {"breach_keycard_guard_1"},
		["Coarse"] = {"breach_keycard_guard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_guard_1", "breach_keycard_guard_2"},
		["Fine"] = {"breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_1"},
		["Very Fine"] = {"breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_4", "breach_keycard_5"},
	},
	["breach_keycard_guard_3"] = {
		["Rough"] = {"breach_keycard_guard_1"},
		["Coarse"] = {"breach_keycard_guard_2", "breach_keycard_guard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_guard_1", "breach_keycard_guard_2", "breach_keycard_guard_3"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_4"},
	},
	["breach_keycard_guard_4"] = {
		["Rough"] = {"breach_keycard_guard_1"},
		["Coarse"] = {"breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4", "breach_keycard_guard_1", "breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_guard_2", "breach_keycard_guard_3", "breach_keycard_guard_4", "breach_keycard_6", "breach_keycard_crack"},
	},

	["breach_keycard_crack"] = {
		["Rough"] = {"breach_keycard_1"},
		["Coarse"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_1"},
		["Very Fine"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_3", "breach_keycard_4", "breach_keycard_5", "breach_keycard_6", "breach_keycard_7"},
	},


	["breach_keycard_sci_1"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"breach_keycard_1", NULL},
		["1:1"] = {"breach_keycard_1", "breach_keycard_security_1", "breach_keycard_sci_1"},
		["Fine"] = {"breach_keycard_sci_2", "breach_keycard_sci_1"},
		["Very Fine"] = {"breach_keycard_sci_1", "breach_keycard_sci_2", "breach_keycard_sci_3"},
	},
	["breach_keycard_sci_2"] = {
		["Rough"] = {"breach_keycard_1", "breach_keycard_sci_1"},
		["Coarse"] = {"breach_keycard_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2"},
		["Fine"] = {"breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_1"},
		["Very Fine"] = {"breach_keycard_sci_1", "breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_4"},
	},
	["breach_keycard_sci_3"] = {
		["Rough"] = {"breach_keycard_sci_1"},
		["Coarse"] = {"breach_keycard_sci_2", "breach_keycard_sci_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3"},
		["Fine"] = {"breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_4", "breach_keycard_sci_1"},
		["Very Fine"] = {"breach_keycard_sci_1", "breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_4", "breach_keycard_4"},
	},
	["breach_keycard_sci_4"] = {
		["Rough"] = {"breach_keycard_sci_1"},
		["Coarse"] = {"breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_1"},
		["1:1"] = {"breach_keycard_1", "breach_keycard_2", "breach_keycard_security_1", "breach_keycard_sci_1", "breach_keycard_security_2", "breach_keycard_sci_2", "breach_keycard_security_3", "breach_keycard_sci_3", "breach_keycard_security_4", "breach_keycard_sci_4"},
		["Fine"] = {"breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_4", "breach_keycard_5"},
		["Very Fine"] = {"breach_keycard_sci_2", "breach_keycard_sci_3", "breach_keycard_sci_4", "breach_keycard_5", "breach_keycard_crack"},
	},


	["item_medkit_1"] = {
		["Rough"] = {NULL},
		["Coarse"] = {NULL, "item_medkit_1"},
		["1:1"] = {"item_medkit_1", "item_medkit_3"},
		["Fine"] = {"item_medkit_1", "item_medkit_2"},
		["Very Fine"] = {"item_medkit_2", "item_medkit_3", "item_medkit_4","item_pills"},
	},

	["item_medkit_2"] = {
		["Rough"] = {NULL},
		["Coarse"] = {NULL, "item_medkit_1"},
		["1:1"] = {"item_medkit_2", "item_medkit_4","item_pills"},
		["Fine"] = {"item_medkit_2", "item_medkit_3","item_pills"},
		["Very Fine"] = {"item_medkit_2","item_medkit_3", "item_medkit_4","item_pills"},
	},

	["item_medkit_3"] = {
		["Rough"] = {NULL},
		["Coarse"] = {NULL, "item_medkit_1"},
		["1:1"] = {"item_medkit_3", "item_medkit_1","item_pills"},
		["Fine"] = {"item_medkit_3", "item_medkit_4","item_pills"},
		["Very Fine"] = {"item_medkit_2","item_medkit_3", "item_medkit_4","item_pills"},
	},

	["item_medkit_4"] = {
		["Rough"] = {NULL},
		["Coarse"] = {NULL, "item_medkit_1","item_pills"},
		["1:1"] = {"item_medkit_4", "item_medkit_2","item_pills"},
		["Fine"] = {"item_medkit_3", "item_medkit_4","item_pills"},
		["Very Fine"] = {"item_medkit_4","item_pills","item_adrenaline","item_syringe"},
	},


	["copper_coin"] = {
		["Rough"] = {NULL},
		["Coarse"] = {NULL, "copper_coin"},
		["1:1"] = {"copper_coin"},
		["Fine"] = {"copper_coin", "silver_coin"},
		["Very Fine"] = {"gold_coin", "copper_coin", "silver_coin"},
	},

	["silver_coin"] = {
		["Rough"] = {"copper_coin"},
		["Coarse"] = {"silver_coin", "copper_coin"},
		["1:1"] = {"copper_coin"},
		["Fine"] = {"copper_coin", "silver_coin", "gold_coin"},
		["Very Fine"] = {"gold_coin", "copper_coin", "silver_coin"},
	},

	["gold_coin"] = {
		["Rough"] = {"copper_coin"},
		["Coarse"] = {"silver_coin", "copper_coin"},
		["1:1"] = {"gold_coin"},
		["Fine"] = {"gold_coin"},
		["Very Fine"] = {"copper_coin"},
	},

	["weapon_pass_guard"] = {
		["Rough"] = {"NULL"},
		["Coarse"] = {"NULL"},
		["1:1"] = {"weapon_pass_guard"},
		["Fine"] = {"weapon_pass_sci","weapon_pass_medic","weapon_pass_guard"},
		["Very Fine"] = {"weapon_pass_sci","weapon_pass_medic","weapon_pass_guard","gasmask"},
	},

	["item_adrenaline"] = {
		["Rough"] = {NULL},
		["Coarse"] = {NULL},
		["1:1"] = {"item_adrenaline"},
		["Fine"] = {"item_adrenaline", "item_syringe"},
		["Very Fine"] = {"item_adrenaline", "item_syringe"},
	},

	["cw_kk_ins2_makarov"] = {
		["Rough"] = {NULL},
		["Coarse"] = {NULL, "cw_kk_ins2_makarov"},
		["1:1"] = {"cw_kk_ins2_m9", "cw_kk_ins2_arse_g17", "cw_kk_ins2_makarov"},
		["Fine"] = {"cw_kk_ins2_m1911", "cw_kk_ins2_makarov", "cw_kk_ins2_makarov"}, -- Шанс остаться с тем же
		["Very Fine"] = {"cw_kk_ins2_deagle", "cw_kk_ins2_usp", NULL},
	},
	["cw_kk_ins2_m9"] = {
		["Rough"] = {NULL},
		["Coarse"] = {NULL},
		["1:1"] = {"cw_kk_ins2_makarov", "cw_kk_ins2_arse_g17"},
		["Fine"] = {"cw_kk_ins2_cstm_g19", "cw_kk_ins2_m9"},
		["Very Fine"] = {"cw_kk_ins2_deagle", "cw_kk_ins2_cstm_cobra", "cw_kk_ins2_m9"},
	},
	["cw_kk_ins2_arse_g17"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"cw_kk_ins2_makarov"},
		["1:1"] = {"cw_kk_ins2_m9", "cw_kk_ins2_arse_g18"},
		["Fine"] = {"cw_kk_ins2_cstm_g19", "cw_kk_ins2_arse_g17"},
		["Very Fine"] = {"cw_kk_ins2_deagle", "cw_kk_ins2_usp"},
	},

	-- Tier 2: USP, M1911, G19, G18
	["cw_kk_ins2_m1911"] = {
		["Rough"] = {"cw_kk_ins2_makarov"},
		["Coarse"] = {"cw_kk_ins2_m9", NULL},
		["1:1"] = {"cw_kk_ins2_usp", "cw_kk_ins2_cstm_g19"},
		["Fine"] = {"cw_kk_ins2_deagle", "cw_kk_ins2_m1911", "cw_kk_ins2_m9"}, -- Риск даунгрейда
		["Very Fine"] = {"cw_kk_ins2_cstm_cobra", "cw_kk_ins2_m45", NULL},
	},
	["cw_kk_ins2_usp"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"cw_kk_ins2_m9"},
		["1:1"] = {"cw_kk_ins2_m1911", "cw_kk_ins2_cstm_g19"},
		["Fine"] = {"cw_kk_ins2_deagle", "cw_kk_ins2_usp", "cw_kk_ins2_makarov"},
		["Very Fine"] = {"cw_kk_ins2_cstm_cobra", "cw_kk_ins2_m45"},
	},

	-- Tier 3 (Top Pistols): Deagle, Cobra, M45
	["cw_kk_ins2_deagle"] = {
		["Rough"] = {"cw_kk_ins2_makarov"}, -- Сильный даунгрейд
		["Coarse"] = {"cw_kk_ins2_m1911", "cw_kk_ins2_usp"},
		["1:1"] = {"cw_kk_ins2_cstm_cobra", "cw_kk_ins2_m45"},
		["Fine"] = {"cw_kk_ins2_cstm_cobra", "cw_kk_ins2_deagle", "cw_kk_ins2_usp"}, -- Шанс потерять ствол
		["Very Fine"] = {"cw_kk_ins2_mp5k", "cw_kk_ins2_cstm_uzi", NULL}, -- Переход в класс ПП
	},
	["cw_kk_ins2_cstm_cobra"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"cw_kk_ins2_revolver"},
		["1:1"] = {"cw_kk_ins2_deagle"},
		["Fine"] = {"cw_kk_ins2_revolver", "cw_kk_ins2_cstm_cobra"},
		["Very Fine"] = {"cw_cultist_shotgun_ithaca37", "cw_kk_ins2_toz"}, -- Переход в дробовики
	},

	---------------------------------------------------------------------------
	-- ДРОБОВИКИ
	---------------------------------------------------------------------------
	-- Tier 1: Ithaca, TOZ, M500
	["cw_cultist_shotgun_ithaca37"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"cw_kk_ins2_makarov"}, -- В пистолет
		["1:1"] = {"cw_kk_ins2_toz", "cw_kk_ins2_cstm_m500"},
		["Fine"] = {"cw_kk_ins2_m590", "cw_cultist_shotgun_ithaca37", "cw_kk_ins2_toz"},
		["Very Fine"] = {"cw_kk_ins2_arse_m1014", "cw_kk_ins2_cstm_spas12", NULL},
	},
	["cw_kk_ins2_toz"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"cw_cultist_shotgun_ithaca37"},
		["1:1"] = {"cw_cultist_shotgun_ithaca37", "cw_kk_ins2_cstm_m500"},
		["Fine"] = {"cw_kk_ins2_m590", "cw_kk_ins2_toz"},
		["Very Fine"] = {"cw_kk_ins2_cstm_spas12", "cw_kk_ins2_arse_m1014"},
	},

	-- Tier 2: M1014, SPAS-12, KSG
	["cw_kk_ins2_arse_m1014"] = {
		["Rough"] = {"cw_kk_ins2_toz"},
		["Coarse"] = {"cw_kk_ins2_m590"},
		["1:1"] = {"cw_kk_ins2_cstm_spas12", "cw_kk_ins2_cstm_ksg"},
		["Fine"] = {"cw_kk_ins2_cstm_ksg", "cw_kk_ins2_arse_m1014", "cw_kk_ins2_m590"}, -- Риск
		["Very Fine"] = {"cw_kk_ins2_cstm_ksg", "cw_cultist_machinegun_minimi", NULL}, -- Шанс на пулемет
	},

	---------------------------------------------------------------------------
	-- ПИСТОЛЕТЫ-ПУЛЕМЕТЫ (SMG)
	---------------------------------------------------------------------------
	-- Tier 1: Sterling, MP40, Uzi
	["cw_kk_ins2_sterling"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"cw_kk_ins2_makarov"},
		["1:1"] = {"cw_kk_ins2_mp40", "cw_kk_ins2_cstm_uzi"},
		["Fine"] = {"cw_kk_ins2_mp5k", "cw_kk_ins2_sterling", "cw_kk_ins2_mp40"},
		["Very Fine"] = {"cw_kk_ins2_cstm_mp5a4", "cw_kk_ins2_ump45", NULL},
	},
	["cw_kk_ins2_mp40"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"cw_kk_ins2_sterling"},
		["1:1"] = {"cw_kk_ins2_sterling", "cw_kk_ins2_cstm_uzi"},
		["Fine"] = {"cw_kk_ins2_mp5k", "cw_kk_ins2_mp40"},
		["Very Fine"] = {"cw_kk_ins2_cstm_mp5a4", "cw_kk_ins2_ump45"},
	},

	-- Tier 2: MP5, UMP, PP-19 (Bizon logic if exists, else aks74u)
	["cw_kk_ins2_cstm_mp5a4"] = {
		["Rough"] = {"cw_kk_ins2_sterling"},
		["Coarse"] = {"cw_kk_ins2_mp40"},
		["1:1"] = {"cw_kk_ins2_ump45", "cw_kk_ins2_mp5k"},
		["Fine"] = {"cw_kk_ins2_cstm_mp7", "cw_kk_ins2_cstm_mp5a4", "cw_kk_ins2_mp5k"}, -- Риск даунгрейда
		["Very Fine"] = {"cw_kk_ins2_p90", "cw_kk_ins2_cstm_kriss", NULL},
	},
	["cw_kk_ins2_ump45"] = {
		["Rough"] = {"cw_kk_ins2_mp40"},
		["Coarse"] = {"cw_kk_ins2_cstm_uzi"},
		["1:1"] = {"cw_kk_ins2_cstm_mp5a4", "cw_kk_ins2_mp5k"},
		["Fine"] = {"cw_kk_ins2_cstm_mp7", "cw_kk_ins2_ump45"},
		["Very Fine"] = {"cw_kk_ins2_p90", "cw_kk_ins2_cstm_kriss"},
	},

	-- Tier 3: P90, MP7, Kriss Vector
	["cw_kk_ins2_p90"] = {
		["Rough"] = {"cw_kk_ins2_cstm_uzi"},
		["Coarse"] = {"cw_kk_ins2_cstm_mp5a4"},
		["1:1"] = {"cw_kk_ins2_cstm_mp7", "cw_kk_ins2_cstm_kriss"},
		["Fine"] = {"cw_kk_ins2_cstm_kriss", "cw_kk_ins2_p90", "cw_kk_ins2_ump45"}, -- Риск
		["Very Fine"] = {"cw_kk_ins2_m4a1", "cw_kk_ins2_ak74", NULL}, -- Переход в штурмовые
	},
	["cw_kk_ins2_cstm_kriss"] = {
		["Rough"] = {"cw_kk_ins2_ump45"},
		["Coarse"] = {"cw_kk_ins2_cstm_mp7"},
		["1:1"] = {"cw_kk_ins2_p90"},
		["Fine"] = {"cw_kk_ins2_aks74u", "cw_kk_ins2_cstm_kriss", "cw_kk_ins2_p90"},
		["Very Fine"] = {"cw_kk_ins2_asval", "cw_kk_ins2_groza", NULL}, -- Спец оружие
	},

	---------------------------------------------------------------------------
	-- ШТУРМОВЫЕ ВИНТОВКИ (Assault Rifles)
	---------------------------------------------------------------------------
	-- Tier 1: AKS-74U, Mini14, SKS, M1 Carbine
	["cw_kk_ins2_aks74u"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"cw_kk_ins2_cstm_mp5a4"}, -- Даунгрейд в ПП
		["1:1"] = {"cw_kk_ins2_mini14", "cw_kk_ins2_sks"},
		["Fine"] = {"cw_kk_ins2_ak74", "cw_kk_ins2_aks74u", "cw_cultist_submac_aks74u_modern"},
		["Very Fine"] = {"cw_kk_ins2_akm", "cw_kk_ins2_m16a4", NULL},
	},
	["cw_kk_ins2_sks"] = {
		["Rough"] = {NULL},
		["Coarse"] = {"cw_kk_ins2_m1a1"},
		["1:1"] = {"cw_kk_ins2_mini14", "cw_kk_ins2_l1a1"},
		["Fine"] = {"cw_kk_ins2_akm", "cw_kk_ins2_sks", "cw_kk_ins2_m1a1"},
		["Very Fine"] = {"cw_kk_ins2_svd", "cw_kk_ins2_mosin", NULL}, -- Уход в снайперки
	},

	-- Tier 2: AK-74, M16A4, M4A1, L85, Galil
	["cw_kk_ins2_ak74"] = {
		["Rough"] = {"cw_kk_ins2_aks74u"},
		["Coarse"] = {"cw_kk_ins2_sks", "cw_kk_ins2_mini14"},
		["1:1"] = {"cw_kk_ins2_m16a4", "cw_kk_ins2_akm", "cw_kk_ins2_galil"},
		["Fine"] = {"cw_kk_ins2_ak12", "cw_kk_ins2_ak74", "cw_kk_ins2_aks74u"}, -- Есть шанс получить "Ксюху"
		["Very Fine"] = {"cw_kk_ins2_rpk", "cw_kk_ins2_ak117", NULL},
	},
	["cw_kk_ins2_m16a4"] = {
		["Rough"] = {"cw_kk_ins2_mini14"},
		["Coarse"] = {"cw_kk_ins2_cstm_colt"},
		["1:1"] = {"cw_kk_ins2_ak74", "cw_kk_ins2_l1a1"},
		["Fine"] = {"cw_kk_ins2_m4a1", "cw_kk_ins2_m16a4", "cw_kk_ins2_mini14"},
		["Very Fine"] = {"cw_kk_ins2_hk416c", "cw_kk_ins2_acr", NULL},
	},
	["cw_kk_ins2_m4a1"] = {
		["Rough"] = {"cw_kk_ins2_cstm_colt"},
		["Coarse"] = {"cw_kk_ins2_m16a4"},
		["1:1"] = {"cw_kk_ins2_cstm_g36c", "cw_kk_ins2_arse_l85"},
		["Fine"] = {"cw_kk_ins2_acr", "cw_kk_ins2_m4a1", "cw_kk_ins2_m16a4"},
		["Very Fine"] = {"cw_kk_ins2_mk18", "cw_kk_ins2_cstm_aug", NULL},
	},

	-- Tier 3: AK-12, SCAR-H, FAL, ASVAL, Groza
	["cw_kk_ins2_ak12"] = {
		["Rough"] = {"cw_kk_ins2_ak74"},
		["Coarse"] = {"cw_kk_ins2_akm"},
		["1:1"] = {"cw_kk_ins2_ak117", "cw_kk_ins2_rpk"},
		["Fine"] = {"cw_kk_ins2_asval", "cw_kk_ins2_ak12", "cw_kk_ins2_ak74"},
		["Very Fine"] = {"cw_cultist_assrifle_volk", "cw_kk_ins2_groza", NULL},
	},
	["cw_kk_ins2_scar"] = {
		["Rough"] = {"cw_kk_ins2_m16a4"},
		["Coarse"] = {"cw_kk_ins2_l1a1"},
		["1:1"] = {"cw_kk_ins2_cstm_m14", "cw_kk_ins2_imbel"},
		["Fine"] = {"cw_cultist_semisniper_mk14", "cw_kk_ins2_scar", "cw_kk_ins2_l1a1"},
		["Very Fine"] = {"cw_cultist_goc_fate", "cw_kk_ins2_m14", NULL},
	},

	-- Special / High Tier: FATE, Freedom, Volk
	["cw_cultist_goc_fate"] = {
		["Rough"] = {"cw_kk_ins2_scar"},
		["Coarse"] = {"cw_kk_ins2_m4a1"},
		["1:1"] = {"cw_cultist_goc_freedom", "cw_cultist_assrifle_volk"},
		["Fine"] = {"cw_cultist_goc_fate", "cw_cultist_goc_freedom"}, -- Трудно улучшить
		["Very Fine"] = {"cw_kk_ins2_nv4", NULL, "cw_kk_ins2_scar"},
	},

	---------------------------------------------------------------------------
	-- СНАЙПЕРСКИЕ ВИНТОВКИ
	---------------------------------------------------------------------------
	["cw_kk_ins2_mosin"] = {
		["Rough"] = {"cw_cultist_shotgun_ithaca37"}, -- В дробовик
		["Coarse"] = {"cw_kk_ins2_sks"},
		["1:1"] = {"cw_kk_ins2_nazi", "cw_kk_ins2_m40a1"},
		["Fine"] = {"cw_kk_ins2_svd", "cw_kk_ins2_mosin", "cw_kk_ins2_sks"},
		["Very Fine"] = {"cw_kk_ins2_m200", "cw_kk_ins2_svd", NULL},
	},
	["cw_kk_ins2_svd"] = {
		["Rough"] = {"cw_kk_ins2_sks"},
		["Coarse"] = {"cw_kk_ins2_mosin"},
		["1:1"] = {"cw_cultist_semisniper_mk14", "cw_kk_ins2_m14"},
		["Fine"] = {"cw_kk_ins2_m200", "cw_kk_ins2_svd", "cw_kk_ins2_mosin"},
		["Very Fine"] = {"cw_kk_ins2_cultist_barrett", "cw_kk_ins2_m200", NULL},
	},
	["cw_kk_ins2_cultist_barrett"] = { -- Топ снайперка
		["Rough"] = {"cw_kk_ins2_mosin"},
		["Coarse"] = {"cw_kk_ins2_svd"},
		["1:1"] = {"cw_cultist_semisniper_mk14"},
		["Fine"] = {"cw_kk_ins2_cultist_barrett", "cw_kk_ins2_m200"},
		["Very Fine"] = {"cw_kk_ins2_cultist_barrett", NULL}, -- Улучшать некуда
	},

	---------------------------------------------------------------------------
	-- ПУЛЕМЕТЫ (LMG)
	---------------------------------------------------------------------------
	["cw_kk_ins2_m249"] = {
		["Rough"] = {"cw_kk_ins2_m4a1"}, -- В винтовку
		["Coarse"] = {"cw_kk_ins2_galil"},
		["1:1"] = {"cw_cultist_machinegun_minimi", "cw_kk_ins2_rpk"},
		["Fine"] = {"cw_cultist_machinegun_m60", "cw_kk_ins2_m249", "cw_kk_ins2_rpk"},
		["Very Fine"] = {"cw_kk_ins2_rkr", "cw_cultist_machinegun_mg36", NULL},
	},
	["cw_cultist_machinegun_m60"] = {
		["Rough"] = {"cw_kk_ins2_m16a4"},
		["Coarse"] = {"cw_kk_ins2_m249"},
		["1:1"] = {"cw_kk_ins2_rkr", "cw_cultist_machinegun_mg36"},
		["Fine"] = {"cw_cultist_machinegun_m60", "cw_cultist_machinegun_m60", "cw_kk_ins2_m249"}, -- Трудно улучшить
		["Very Fine"] = {"cw_kk_ins2_rkr", NULL},
	},

}

ENT.ModeTypes = {
	"Rough",
	"Coarse",
	"1:1",
	"Fine",
	"Very Fine"
}

function ENT:Initialize()

	self.CBG_Summon_Limit = math.random(10, 30)
	self.CBG_Summon_Current = 0

  	self:SetModel("models/next_breach/gas_monitor.mdl");

	self:PhysicsInit( SOLID_NONE )

	self:SetMoveType( MOVETYPE_NONE )

	self:SetSolid(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)



	--self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

	self:SetPos(Vector(9498.7158203125, -4766.1997070313, 59.6369972229))
	self:SetAngles( Angle(0, 89.961547851563, 0) )

	--self:UseTriggerBounds(true, 10)

end

net.Receive("Changestatus_SCP914", function( len, ply )
	local ent = net.ReadEntity()
	if !IsValid(ent) or ent:GetClass() != "entity_scp_914" then return end
	if ply:GTeam() == TEAM_SPEC then return end
	if ply:GTeam() == TEAM_SCP then return end
	if ent:GetWorking() then return end
	if ent.NextUse == nil then ent.NextUse = 0 end
	if ent.NextUse > CurTime() then return end
	ent.NextUse = CurTime() + 1
	if ent:GetStatus() >= 5 then 
		ent:SetStatus(1)
	else
		ent:SetStatus(ent:GetStatus() + 1)
	end

	ply:RXSENDNotify("l:scp914_change_mode "..ent.ModeTypes[ent:GetStatus()])
end)

net.Receive("Activate_SCP914", function( len, ply )

	local ent = net.ReadEntity()
	if !IsValid(ent) or ent:GetClass() != "entity_scp_914" then return end
	if ply:GTeam() == TEAM_SPEC then return end
	if ply:GTeam() == TEAM_SCP then return end
	if ent:GetWorking() then return end

	ent:SetWorking(true)
	ent:EmitSound(ent.ActivationSound)
	timer.Simple(2.5, function()

		for _, door in pairs(ents.FindInSphere(Vector(9546.245117, -4566.125488, 66.792221), 32)) do

			if IsValid(door) and door:GetClass() == "func_door" then
				door:Fire("Unlock")
				door:Fire("Close")
				door:Fire("Lock")
				door:EmitSound(ent.DoorCloseSound)
			end

		end

		for _, door in pairs(ents.FindInSphere(Vector(9537.967773, -5018.667480, 66.792221), 32)) do

			if IsValid(door) and door:GetClass() == "func_door" then
				door:Fire("Unlock")
				door:Fire("Close")
				door:Fire("Lock")
				door:EmitSound(ent.DoorCloseSound)
			end

		end

	end)

	timer.Simple(7, function()
		
		ent:GetItemsAndUpgrade(ent.ModeTypes[ent:GetStatus()], ply)
	end)

	timer.Simple(14, function()

		for _, door in pairs(ents.FindInSphere(Vector(9546.245117, -4566.125488, 66.792221), 40)) do

			if IsValid(door) and door:GetClass() == "func_door" then
				door:Fire("Unlock")
				door:Fire("Open")
				door:Fire("Lock")
				door:EmitSound(ent.DoorOpenSound)
			end

		end

		for _, door in pairs(ents.FindInSphere(Vector(9537.967773, -5018.667480, 66.792221), 40)) do

			if IsValid(door) and door:GetClass() == "func_door" then
				door:Fire("Unlock")
				door:Fire("Open")
				door:Fire("Lock")
				door:EmitSound(ent.DoorOpenSound)
			end

		end

		timer.Simple(1, function()
			ent:SetWorking(false)
		end)

	end)
end)

function ENT:GetItemsAndUpgrade(mode, activator)

	local Ents = ents.FindInBox( Vector(9552.1748046875, -4607.720703125, 0), Vector(9615.6962890625, -4480.3388671875, 113.26854705811) )
	local BastardsToKill = ents.FindInBox( Vector(9536.7724609375, -4911.8510742188, 114.65923309326), Vector(9629.798828125, -5070.6748046875, -22.197147369385) )
	local UpgradeList = self.UpgradeList

	local SoundPlayed = false
	for _, ply in pairs(BastardsToKill) do
		if IsValid(ply) and ply:IsPlayer() and ply:GTeam() != TEAM_SPEC then
			if !SoundPlayed then
				SoundPlayed = true
				sound.Play(self.PlayerKill, Vector(9587.307617, -4988.501953, 66.792221))
			end
			ply:AddToStatistics("l:scp914_death", -50 )
			ply:LevelBar()
			ply:SetupNormal()
			ply:SetSpectator()
		end
	end

	local SoundPlayed = false
	for _, ply in pairs(Ents) do
		if IsValid(ply) and ply:IsPlayer() and ply:GTeam() != TEAM_SPEC then
			if math.random(1,100) <= 10 then
				print("1")
				SoundPlayed = true
				sound.Play(self.PlayerKill, Vector(9587.307617, -4988.501953, 66.792221))
				ply:AddToStatistics("l:scp914_death", -50 )
			    ply:LevelBar()
			    ply:SetupNormal()
			    ply:SetSpectator()

			elseif math.random(1,100) <= 30 then
				print("2")
				ply:SetStaminaScale(ply:GetStaminaScale()+1)
			    ply:SetMaxHealth(255)
			    ply:SetHealth(255)

			elseif math.random(1,100) <= 50 then
				print("3")
				ply:SetMaxHealth(100)
			    ply:SetHealth(100)
            elseif math.random(1,100) <= 90 then
				print("4")
				ply:SetStaminaScale(ply:GetStaminaScale()+10)
			    ply:SetMaxHealth(114514)
			    ply:SetHealth(114514)
                ply:Dado( 4 )
 			else
				print("5")
			    ply:SetMaxHealth(1)
			    ply:SetHealth(1)
			end
		end
	end

	local itemtospawn = {}
	local spawnpoint = Vector(9582.87890625, -4988.6982421875, 2.7922210693359)

	for _, weapon in pairs(Ents) do
		if !weapon:GetPos():WithinAABox(Vector(9552.1748046875, -4607.720703125, 0), Vector(9615.6962890625, -4480.3388671875, 113.26854705811)) then --дополнительная проверка, чтобы байпаснуть криворукость разрабов гмода
			continue
		end

		if IsValid(weapon) and weapon:GetClass() == "prop_ragdoll" then
			table.insert(itemtospawn, {"item_hamburger", Vector(weapon:GetPos().x, weapon:GetPos().y - 450, weapon:GetPos().z + 30)})
		else
			if !IsValid(weapon) or !weapon:IsWeapon() then continue end
			if self.UpgradeList[weapon:GetClass()] == nil then continue end
			if self.UpgradeList[weapon:GetClass()][mode] == nil then continue end
			table.insert(itemtospawn, {table.Random(self.UpgradeList[weapon:GetClass()][mode]), Vector(weapon:GetPos().x, weapon:GetPos().y - 450, weapon:GetPos().z + 30)})
		end

	end

	for _, weapon in pairs(Ents) do
		if !weapon:GetPos():WithinAABox(Vector(9552.1748046875, -4607.720703125, 0), Vector(9615.6962890625, -4480.3388671875, 113.26854705811)) then --дополнительная проверка, чтобы байпаснуть криворукость разрабов гмода
			continue
		end

		if IsValid(weapon) and ( weapon:IsWeapon() or weapon:GetClass() == "prop_ragdoll" ) then weapon:Remove() end
	end

	if !table.IsEmpty(itemtospawn) then
		for k, v in pairs(itemtospawn) do
			local entclass = v[1]
			local entpos = v[2]
			timer.Simple(k / 10, function()
				if entclass == "breach_keycard_7" and IsValid(activator) then
					activator:CompleteAchievement("scp914")
				elseif entclass == "item_hamburger" and IsValid(activator) then
					activator:CompleteAchievement("scp914burger")
				end
		
				local item = ents.Create(entclass)
				item:SetPos(entpos)
				item:Spawn()
				--uracos():SetPos(entpos)
			end)
		end
	end

	self.CBG_Summon_Current = self.CBG_Summon_Current + 1
	if self.CBG_Summon_Current == self.CBG_Summon_Limit then
		BREACH.SummonCBGCultist()
	end

end

function ENT:Think()
	--[[
	if !self:GetWorking() then
		for _, door in pairs(ents.FindInSphere(Vector(9546.245117, -4566.125488, 66.792221), 40)) do

			if IsValid(door) and door:GetClass() == "func_door" then
				door:Fire("Open")
			end

		end

		for _, door in pairs(ents.FindInSphere(Vector(9537.967773, -5018.667480, 66.792221), 40)) do

			if IsValid(door) and door:GetClass() == "func_door" then
				door:Fire("Open")
			end

		end
	end]]
	self:NextThink(CurTime() + 0.5)
end

function ENT:Use(ply, caller)
	if ply:GTeam() == TEAM_SPEC or ply:GTeam() == TEAM_SCP then return end
	if !ply:Alive() or ply:Health() <= 0 then return end
	if ply:GetEyeTrace().Entity != self then return end
	local ent = self
	if ply:GTeam() == TEAM_CBG and ply:HasWeapon("kasanov_cbg_cog") and ent:GetStatus() ~= -1 then
		if timer.Exists("O5Warhead_Start") then return end
			if timer.Exists( "BG_UseCD" ) then return end
			if GetGlobalBool("Evacuation", false) then return end
			if preparing then return end
			if postround then return end
			if !timer.Exists("EvacuationWarhead") then return end
			if !timer.Exists("Evacuation") then return end
			BroadcastPlayMusic(BR_MUSIC_CRB_NUKE)
			-- if GetGlobalBool("Evacuation", false) then return end
			-- if preparing then return end
			-- if postround then return end
			-- if not timer.Exists("EvacuationWarhead") then return end
			-- if timer.Exists("O5Warhead_Start") then return end
			-- if not timer.Exists("Evacuation") then return end
			ply:GetWeapon('kasanov_cbg_cog'):Remove()
			ent:SetStatus(-1)
			net.Start( "ForcePlaySound" )
				net.WriteString( "nextoren/entities/intercom/start.mp3" )
			net.Broadcast()
			timer.Pause("Evacuation")
			timer.Pause("EvacuationWarhead")
			timer.Pause("RoundTime")
			timer.Pause("EndRound_Timer")
			SetGlobalBool( "Evacuation_HUD", true )
      		-- BroadcastPlayMusic(BR_MUSIC_DAK_NUKE)
			timer.Create("cbg_detonation", 140, 1, function()
				for i, v in pairs(player.GetAll()) do
					if v:GTeam() == TEAM_CBG then
			--			--ParticleEffectAttach("mr_portal_1a_ff", PATTACH_POINT_FOLLOW, v, v:LookupAttachment("waist"))
			--			net.Start("ThirdPersonCutscene")
			--			net.WriteUInt(3, 4)
			--			net.WriteBool(true)
			--			net.Send(v)
			--			v:SetForcedAnimation("0_cult_ritual", 4, function() v:GodEnable() end, function()
			--				v:GodDisable()
							v:AddToStatistics("l:escaped", 1060 * tonumber("1."..tostring(v:GetNLevel() * 2)) )
			--				v:LevelBar()
			--				v:SetupNormal()
			--				v:SetSpectator()
			--				--v:RXSENDNotify("l:your_current_exp ", Color(255,0,0), v:GetNEXP())
			--			end, nil)
					end
				end
				local pickedplayers = {}

				local pick = 0


				for _, ply in RandomPairs(GetActivePlayers()) do
					if ply:GTeam() != TEAM_SPEC then continue end
					if ply.SpawnAsSupport == false then continue end
					if ply:GetPenaltyAmount() > 0 then continue end
					--if LevelRequiredForSupport[pickedsupport] and ply:GetNLevel() < LevelRequiredForSupport[pickedsupport] then continue end
					--if table.HasValue(SPAWNEDPLAYERSASSUPPORT, ply) and !ply:IsDonator() then continue end
					pickedplayers[#pickedplayers + 1] = ply
				end
				local ply = table.Random(pickedplayers)
				ply:SetupNormal()
				ply:ApplyRoleStats( BREACH_ROLES.CBG.cbg.roles[4] )
				--if !notp then
				ply:SetPos( Vector(9586.2275390625, -4989.2490234375, 2.7922515869141) )
				net.Start( "ForcePlaySound" )
      				net.WriteString( "nextoren/ritual_start_"..math.random(1,3)..".ogg" )
    			net.Broadcast()
				SetGlobalBool( "Evacuation_HUD", false )
				timer.UnPause("Evacuation")
				timer.UnPause("EvacuationWarhead")
				timer.UnPause("RoundTime")
				timer.UnPause("EndRound_Timer")
				timer.Remove("cbg_detonation")
				--end
			--	timer.Simple(7, function()
			--		for i, v in pairs(player.GetAll()) do
			--			if v:GTeam() != TEAM_SPEC then
			--				v:EmitSound("nextoren/charactersounds/hurtsounds/male/gore_" .. math.random( 1, 4 ) .. ".mp3")
            --				v:Kill()
            --				ParticleEffect( "tank_gore_c", v:GetPos(), v:GetAngles() )
			--				v:GetNWEntity( "RagdollEntityNO" ):Remove()
			--			end
			--		end
			--		Breach_EndRound("Сборка Разбитого Бога")
			--	end)
			--	-- self:Detonate()
			--	--local cutsc = ents.Create("ntf_cutscene")
  			--	--cutsc:Spawn()
			--	--BREACH.Players:ChatPrint( player.GetAll(), true, true, "Пиздец" )
			end)
			BREACH.Players:ChatPrint( player.GetAll(), true, true, "ВНИМАНИЕ! Обнаружено вмешательство в работе энергооснащения комплекса!" )
			BREACH.Players:ChatPrint( player.GetAll(), true, true, "Всему персоналу немедленно предотвратить попытку взлома!" )
	elseif ply:GTeam() != TEAM_CBG and ent:GetStatus() == -1 then
		ent:SetStatus(1)
		BroadcastStopMusic()
		net.Start( "ForcePlaySound" )
			net.WriteString( "nextoren/entities/intercom/start.mp3" )
		net.Broadcast()
		SetGlobalBool( "Evacuation_HUD", false )
		timer.UnPause("Evacuation")
		timer.UnPause("EvacuationWarhead")
		timer.UnPause("RoundTime")
		timer.UnPause("EndRound_Timer")
		timer.Remove("cbg_detonation")
	else
		ply:SendLua("Open914Menu()")
	end

end