-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_melee_base" -- Base
-- Info
ENT.Type = "anim"
ENT.PrintName = "War Dagger"
ENT.Category = "M.A.N.N. Offense Solutions - Melees"
ENT.Author = "Mannytko"
ENT.Spawnable = true
ENT.Scale = 1.4
-- Entity settings
ENT.Model = Model("models/mos/weapons/melees/ps2_vs_melee_force_blade.mdl")
ENT.ImpactSound = Sound("weapons/knife/knife_hitwall1.wav")
ENT.AttackSound = Sound("weapons/knife/knife_stab.wav")
ENT.JModPreferredCarryAngles = Angle(30, 20, 30)
-- Melee settings
ENT.Damage = 26
ENT.DMGType = DMG_SLASH -- DMG_CLUB for blunt damage, DMG_SLASH for sharp damage
-------------------------------------
if CLIENT then
	language.Add("ent_mann_mos_melee_wardagger", "War Dagger")
end