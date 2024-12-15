-- Mannytko 2024
if SERVER then AddCSLuaFile() end
SWEP.Base = "wep_mann_mos_gun_base"
SWEP.Category = "M.A.N.N. Offense Solutions - Weapons"
SWEP.PrintName = "AR-55"
SWEP.Author = "M.A.N.N. Industries"
SWEP.DrawWeaponInfoBox = true
SWEP.Spawnable = true
--------------------------------------------------
SWEP.ViewModel = Model("models/weapons/v_cod4_g36.mdl")
SWEP.WorldModel = Model("models/mos/weapons/assault_rifles/argus.mdl")
--------------------------------------------------
SWEP.IsZBaseWeapon = true
SWEP.NPCSpawnable = true -- Add to NPC weapon list
SWEP.Primary.Automatic = true
-- https://wiki.facepunch.com/gmod/Hold_Types
SWEP.HoldType = "ar2"
--------------------------------------------------
-- NPC Stuff
SWEP.NPCHoldType = "ar2"
SWEP.NPCCanPickUp = true -- Can NPCs pick up this weapon from the ground
SWEP.NPCBurstMin = 1 -- Minimum amount of bullets the NPC can fire when firing a burst
SWEP.NPCBurstMax = 1 -- Maximum amount of bullets the NPC can fire when firing a burst
SWEP.NPCFireRate = .1 -- Shoot delay in seconds
SWEP.NPCFireRestTimeMin = .01 -- Minimum amount of time the NPC rests between bursts in seconds
SWEP.NPCFireRestTimeMax = .1 -- Maximum amount of time the NPC rests between bursts in seconds
SWEP.NPCBulletSpreadMult = 1 -- Higher number = worse accuracy
SWEP.NPCReloadSound = Sound("jids/snd_jack_icereload.wav") -- Sound when the NPC reloads the gun
SWEP.NPCShootDistanceMult = 1 -- Multiply the NPCs shoot distance by this number with this weapon
--------------------------------------------------
-- Basic primary attack stuff
SWEP.Recoil = 4
SWEP.RPM = 6 / 60
SWEP.Primary.Damage = 30 -- Damage of weapon when player equips it
SWEP.Primary.ClipSize = 30
SWEP.PrimaryShootSound = Sound("jids/snd_jack_iceshot.wav")
SWEP.EmptySound = Sound("weapons/clipempty_rifle.wav")
SWEP.PrimarySpread = .04
SWEP.Primary.Ammo = "AR2" -- https://wiki.facepunch.com/gmod/Default_Ammo_Types
--------------------------------------------------
SWEP.ENT = "ent_mann_mos_gun_ar55"
SWEP.UseSequences = false
--------------------------------------------------
SWEP.VElements = {
	["ar55"] = {
		type = "Model",
		model = "models/mos/weapons/assault_rifles/argus.mdl",
		bone = "tag_weapon",
		rel = "",
		pos = Vector(1.689, .238, .349),
		angle = Angle(0, 91.632, -10),
		size = Vector(.85, .85, .85),
		color = color_white,
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
	["tag_weapon"] = {
		scale = Vector(.009, .009, .009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	}
}