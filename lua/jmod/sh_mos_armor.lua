-- Mannytko 2024
local HeavyArmorProfile = {
	[DMG_BUCKSHOT] = .95,
	[DMG_CLUB] = .95,
	[DMG_SLASH] = .99,
	[DMG_BULLET] = .98,
	[DMG_BLAST] = .98,
	[DMG_SNIPER] = .9,
	[DMG_AIRBOAT] = .85,
	[DMG_CRUSH] = .6,
	[DMG_VEHICLE] = .65,
	[DMG_BURN] = .9,
	[DMG_PLASMA] = .85,
	[DMG_ACID] = .55
}

local MediumArmorProfile = {
	[DMG_BUCKSHOT] = .7,
	[DMG_CLUB] = .75,
	[DMG_SLASH] = .85,
	[DMG_BULLET] = .75,
	[DMG_BLAST] = .75,
	[DMG_SNIPER] = .8,
	[DMG_AIRBOAT] = .7,
	[DMG_CRUSH] = .5,
	[DMG_VEHICLE] = .45,
	[DMG_BURN] = .8,
	[DMG_PLASMA] = .75,
	[DMG_ACID] = .45
}

JMod.MOSArmorTable = JMod.MOSArmorTable or {}
------------------------------------------------------------------------------
JMod.MOSArmorTable["RegularSoldier-Armor"] = {
	PrintName = "Regular Soldier Armor",
	Category = "M.A.N.N. Offense Solutions - Misc",
	Spawnable = true,
	AdminOnly = false,
	--------------------------------
	mdl = "models/lt_c/sci_fi/box_crate.mdl",
	slots = {
		head = 1,
		eyes = 1,
		mouthnose = 1,
		abdomen = 1,
		pelvis = 1,
		leftthigh = 1,
		leftcalf = 1,
		rightthigh = 1,
		rightcalf = 1,
		rightshoulder = 1,
		rightforearm = 1,
		leftshoulder = 1,
		leftforearm = 1
	},
	snds = {
		eq = "snds_jack_gmod/ez_robotics/11.wav",
		uneq = "snds_jack_gmod/ez_robotics/12.wav"
	},
	def = HeavyArmorProfile,
	plymdl = "models/mos/npcs/frosty/sparbine_players/mos_regularsoldier_pm.mdl",
	sndlop = "", -- "snds_jack_gmod/mask_breathe.wav"
	wgt = 60,
	dur = 600,
	ent = "ent_jack_gmod_ezarmor_mosregulararmor"
}

JMod.MOSArmorTable["RebelSoldier-Armor"] = {
	PrintName = "Rebel Soldier Armor",
	Category = "M.A.N.N. Offense Solutions - Misc",
	Spawnable = true,
	AdminOnly = false,
	--------------------------------
	mdl = "models/lt_c/sci_fi/box_crate.mdl",
	clrForced = true,
	slots = {
		head = 1,
		eyes = 1,
		mouthnose = 1,
		abdomen = 1,
		pelvis = 1,
		leftthigh = 1,
		leftcalf = 1,
		rightthigh = 1,
		rightcalf = 1,
		rightshoulder = 1,
		rightforearm = 1,
		leftshoulder = 1,
		leftforearm = 1
	},
	snds = {
		eq = "snds_jack_gmod/ez_robotics/11.wav",
		uneq = "snds_jack_gmod/ez_robotics/12.wav"
	},
	def = HeavyArmorProfile,
	plymdl = "models/mos/npcs/frosty/sparbine_players/mos_rebelsoldier_pm.mdl",
	sndlop = "", -- "snds_jack_gmod/mask_breathe.wav"
	wgt = 65,
	dur = 750,
	ent = "ent_jack_gmod_ezarmor_mosrebelarmor"
}

JMod.MOSArmorTable["Security-Armor"] = {
	PrintName = "Security Armor",
	Category = "M.A.N.N. Offense Solutions - Misc",
	Spawnable = true,
	AdminOnly = false,
	--------------------------------
	mdl = "models/lt_c/sci_fi/box_crate.mdl",
	clrForced = true,
	slots = {
		head = 1,
		eyes = 1,
		mouthnose = 1,
		abdomen = 1,
		pelvis = 1,
		leftthigh = 1,
		leftcalf = 1,
		rightthigh = 1,
		rightcalf = 1,
		rightshoulder = 1,
		rightforearm = 1,
		leftshoulder = 1,
		leftforearm = 1
	},
	snds = {
		eq = "snds_jack_gmod/ez_robotics/11.wav",
		uneq = "snds_jack_gmod/ez_robotics/12.wav"
	},
	def = MediumArmorProfile,
	plymdl = "models/mos/npcs/frosty/sparbine_players/mos_security_pm.mdl",
	sndlop = "", -- "snds_jack_gmod/mask_breathe.wav"
	wgt = 40,
	dur = 500,
	ent = "ent_jack_gmod_ezarmor_mossecurityarmor"
}

------------------------------------------------------------------------------
JMod.GenerateArmorEntities(JMod.MOSArmorTable)
local function LoadMOSArmor()
	if JMod.MOSArmorTable then
		table.Merge(JMod.ArmorTable, JMod.MOSArmorTable)
		JMod.GenerateArmorEntities(JMod.MOSArmorTable)
	end
end

hook.Add("Initialize", "JMod_LoadMOSArmor", LoadMOSArmor)
LoadMOSArmor()