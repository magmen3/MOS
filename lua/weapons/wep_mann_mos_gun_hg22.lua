-- Mannytko 2024
if SERVER then AddCSLuaFile() end
SWEP.Base = "wep_mann_mos_gun_base"
SWEP.Category = "M.A.N.N. Offense Solutions - Weapons"
SWEP.PrintName = "HG-22"
SWEP.Author = "M.A.N.N. Industries"
SWEP.DrawWeaponInfoBox = true
SWEP.Spawnable = true
--------------------------------------------------
SWEP.ViewModel = Model("models/weapons/c_bo2_b23r_1.mdl")
SWEP.WorldModel = Model("models/mos/weapons/pistols/eagle.mdl")
SWEP.Slot = 1 -- 1 for handguns, 2 for rifles
SWEP.SlotPos = 1
SWEP.ViewModelFOV = 70
--------------------------------------------------
SWEP.IsZBaseWeapon = true
SWEP.NPCSpawnable = true -- Add to NPC weapon list
SWEP.Primary.Automatic = true
-- https://wiki.facepunch.com/gmod/Hold_Types
SWEP.HoldType = "revolver"
SWEP.RunHoldType = "normal"
--------------------------------------------------
-- NPC Stuff
SWEP.NPCHoldType = "pistol"
SWEP.NPCCanPickUp = true -- Can NPCs pick up this weapon from the ground
SWEP.NPCBurstMin = 1 -- Minimum amount of bullets the NPC can fire when firing a burst
SWEP.NPCBurstMax = 1 -- Maximum amount of bullets the NPC can fire when firing a burst
SWEP.NPCFireRate = .25 -- Shoot delay in seconds
SWEP.NPCFireRestTimeMin = .06 -- Minimum amount of time the NPC rests between bursts in seconds
SWEP.NPCFireRestTimeMax = .3 -- Maximum amount of time the NPC rests between bursts in seconds
SWEP.NPCBulletSpreadMult = 1 -- Higher number = worse accuracy
SWEP.NPCReloadSound = Sound("jids/snd_jack_icereload.wav") -- Sound when the NPC reloads the gun
SWEP.NPCShootDistanceMult = 1 -- Multiply the NPCs shoot distance by this number with this weapon
--------------------------------------------------
-- Basic primary attack stuff
SWEP.Recoil = 5
SWEP.RPM = 18 / 60
SWEP.Primary.Damage = 17 -- Damage of weapon when player equips it
SWEP.Primary.ClipSize = 16
SWEP.PrimaryShootSound = Sound("jids/snd_jack_electrolaserfire.wav")
SWEP.EmptySound = Sound("weapons/clipempty_rifle.wav")
SWEP.PrimarySpread = .03
SWEP.Primary.Ammo = "Pistol" -- https://wiki.facepunch.com/gmod/Default_Ammo_Types
--------------------------------------------------
SWEP.ENT = "ent_mann_mos_gun_hg22"
SWEP.UseSequences = false
SWEP.ReloadAnimRate = .5
SWEP.ReloadTime = 2.3
SWEP.RecoilHeatMul = 2
SWEP.VMRecoilMul = 3
--------------------------------------------------
SWEP.VElements = {
	["hg22"] = {
		type = "Model",
		model = "models/mos/weapons/pistols/eagle.mdl",
		bone = "tag_weapon",
		rel = "",
		pos = Vector(-.727, .082, .45),
		angle = Angle(0, 90, 0),
		size = Vector(1.05, 1.05, .95),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}
}

SWEP.WElements = {}
SWEP.ViewModelBoneMods = {
	-- funny cod rig
	["ValveBiped.Bip01_L_Forearm"] = {
		scale = Vector(1.1, 1.1, 1.1),
		pos = vector_origin,
		angle = angle_zero
	},
	["ValveBiped.Bip01_R_Forearm"] = {
		scale = Vector(1.1, 1.1, 1.1),
		pos = vector_origin,
		angle = angle_zero
	},
	["j_bolt"] = {
		scale = Vector(.009, .009, .009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["j_press_rear"] = {
		scale = Vector(.009, .009, .009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["tag_clip"] = {
		scale = Vector(.89, .89, .89),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["tag_weapon"] = {
		scale = Vector(.009, .009, .009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["j_selector"] = {
		scale = Vector(.009, .009, .009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	}
}