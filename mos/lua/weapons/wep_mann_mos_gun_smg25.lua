-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

SWEP.Base = "wep_mann_mos_gun_base"
SWEP.Category = "M.A.N.N. Offense Solutions - Weapons"
SWEP.PrintName = "SMG-25"
SWEP.Author = "M.A.N.N. Industries"
SWEP.DrawWeaponInfoBox = true
SWEP.Spawnable = true
--------------------------------------------------
SWEP.ViewModel = Model("models/weapons/v_cod4_mp5_c.mdl")
SWEP.WorldModel = Model("models/mos/weapons/smgs/hornet.mdl")
--------------------------------------------------
SWEP.IsZBaseWeapon = true
SWEP.NPCSpawnable = true -- Add to NPC weapon list
SWEP.Primary.Automatic = true
-- https://wiki.facepunch.com/gmod/Hold_Types
SWEP.HoldType = "smg1"
--------------------------------------------------
-- NPC Stuff
SWEP.NPCHoldType = "smg1"
SWEP.NPCCanPickUp = true -- Can NPCs pick up this weapon from the ground
SWEP.PrimaryDamage = 8 -- Damage of weapon when NPC equips it
SWEP.NPCFireRate = .06 -- Shoot delay in seconds
SWEP.NPCFireRestTimeMin = .03 -- Minimum amount of time the NPC rests between bursts in seconds
SWEP.NPCFireRestTimeMax = .13 -- Maximum amount of time the NPC rests between bursts in seconds
SWEP.NPCBulletSpreadMult = .8 -- Higher number = worse accuracy
SWEP.NPCReloadSound = Sound("jids/snd_jack_coilgunreload.wav") -- Sound when the NPC reloads the gun
--------------------------------------------------
-- Basic primary attack stuff
SWEP.Recoil = 2
SWEP.RPM = 4 / 60
SWEP.Primary.Damage = 15 -- Damage of weapon when player equips it
SWEP.Primary.ClipSize = 25
SWEP.PrimaryShootSound = Sound("mos/weapons/fwp_wattzlasergun/wattzlasergun/wattzshoot.wav")
SWEP.EmptySound = Sound("weapons/clipempty_rifle.wav")
SWEP.PrimarySpread = .06
SWEP.Primary.Ammo = "SMG1" -- https://wiki.facepunch.com/gmod/Default_Ammo_Types
--------------------------------------------------
SWEP.ENT = "ent_mann_mos_gun_smg25"
SWEP.UseSequences = false
SWEP.ShowReloadAnim = false
SWEP.RecoilHeatMul = .6
SWEP.VMRecoilMul = 1.2
SWEP.VMUp = .8
--------------------------------------------------
SWEP.VElements = {
	["smg25"] = {
		type = "Model",
		model = "models/mos/weapons/smgs/hornet.mdl",
		bone = "tag_weapon",
		rel = "",
		pos = Vector(-6.9, 0, -0.332),
		angle = Angle(3, 90, -4),
		size = Vector(1.2, 1.2, 1.2),
		color = color_white,
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}
}

SWEP.WElements = {}
SWEP.HoldType = "smg"
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
		scale = Vector(0.009, 0.009, 0.009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["tag_clip"] = {
		scale = Vector(0.009, 0.009, 0.009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["j_elbow_le"] = {
		scale = Vector(1.07, 1.07, 1.07),
		pos = Vector(3.197, -4.322, 0.921),
		angle = Angle(-17.449, 13.43, 0)
	}
}