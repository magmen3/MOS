-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_melee_base" -- Base
-- Info
ENT.Type = "anim"
ENT.PrintName = "Electric Baton"
ENT.Category = "M.A.N.N. Offense Solutions - Melees"
ENT.Author = "Mannytko"
ENT.Spawnable = true
ENT.Scale = 0.25
-- Entity settings
ENT.Model = "models/mos/props/lt_c/sci_fi/pipe_128.mdl" -- literally resized pipe model 💀
ENT.ImpactSound = Sound("weapons/stunstick/stunstick_impact1.wav")
ENT.AttackSound = Sound("weapons/stunstick/stunstick_fleshhit2.wav")
ENT.JModPreferredCarryAngles = Angle(30, 20, 30)
-- Melee settings
ENT.Damage = 16
ENT.DMGType = DMG_SHOCK -- DMG_CLUB for blunt damage, DMG_SLASH for sharp damage
-------------------------------------
if CLIENT then
	language.Add("ent_mann_mos_melee_welder", "Welder")
end