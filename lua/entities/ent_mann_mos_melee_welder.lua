-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_melee_base" -- Base
-- Info
ENT.Type = "anim"
ENT.PrintName = "Welder"
ENT.Category = "M.A.N.N. Offense Solutions - Melees"
ENT.Author = "Mannytko"
ENT.Spawnable = true
ENT.Scale = 1.4
-- Entity settings
ENT.Model = "models/mos/weapons/melees/ps2_ns_melee_firebug.mdl"
ENT.ImpactSound = Sound("physics/metal/metal_solid_impact_soft" .. math.random(1, 3) .. ".wav")
ENT.AttackSound = Sound("player/pl_burnpain1.wav")
ENT.JModPreferredCarryAngles = Angle(30, 20, 30)
-- Melee settings
ENT.Damage = 16
ENT.DMGType = DMG_BURN -- DMG_CLUB for blunt damage, DMG_SLASH for sharp damage
-------------------------------------
if CLIENT then
	language.Add("ent_mann_mos_melee_welder", "Welder")
end