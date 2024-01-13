-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

SWEP.Base = "wep_mann_mos_gun_base"
SWEP.Category = "M.A.N.N. Offense Solutions - Weapons"
SWEP.PrintName = "HR-103"
SWEP.Author = "M.A.N.N. Industries"
SWEP.DrawWeaponInfoBox = true
SWEP.Spawnable = true
--------------------------------------------------
SWEP.ViewModel = Model("models/weapons/v_cod4_mp5_c.mdl")
SWEP.WorldModel = Model("models/mos/weapons/assault_rifles/revenant.mdl")
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
SWEP.NPCFireRate = .105 -- Shoot delay in seconds
SWEP.NPCFireRestTimeMin = .025 -- Minimum amount of time the NPC rests between bursts in seconds
SWEP.NPCFireRestTimeMax = .11 -- Maximum amount of time the NPC rests between bursts in seconds
SWEP.NPCBulletSpreadMult = 1 -- Higher number = worse accuracy
SWEP.NPCReloadSound = Sound("jids/snd_jack_icereload.wav") -- Sound when the NPC reloads the gun
SWEP.NPCShootDistanceMult = 1 -- Multiply the NPCs shoot distance by this number with this weapon
--------------------------------------------------
-- Basic primary attack stuff
SWEP.Recoil = 4
SWEP.RPM = 7 / 60
SWEP.Primary.Damage = 36 -- Damage of weapon when player equips it
SWEP.Primary.ClipSize = 31
SWEP.PrimaryShootSound = Sound("mos/weapons/fwp_10mmsmg/10mmsmg/10mmsmgshoot.wav")
SWEP.EmptySound = Sound("weapons/clipempty_rifle.wav")
SWEP.PrimarySpread = .06
SWEP.Primary.Ammo = "AR2" -- https://wiki.facepunch.com/gmod/Default_Ammo_Types
--------------------------------------------------
SWEP.ENT = "ent_mann_mos_gun_hr103"
SWEP.UseSequences = false
SWEP.RecoilHeatMul = .6
SWEP.ShowReloadAnim = false
SWEP.SprintVMDownAmt = 5
SWEP.VMRecoilMul = 1.2
SWEP.MannCorp = false
--------------------------------------------------
SWEP.VElements = {
	["hr103"] = {
		type = "Model",
		model = "models/mos/weapons/assault_rifles/revenant.mdl",
		bone = "tag_weapon",
		rel = "",
		pos = Vector(-4, -0.35, 0.647),
		angle = Angle(3, 90, -2),
		size = Vector(0.8, 0.8, 0.8),
		color = Color(190, 150, 150, 255),
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
	}
}