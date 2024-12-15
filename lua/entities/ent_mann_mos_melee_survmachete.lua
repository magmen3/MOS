-- Mannytko 2024
if SERVER then AddCSLuaFile() end
ENT.Base = "ent_mann_mos_melee_base" -- Base
-- Info
ENT.Type = "anim"
ENT.PrintName = "Survivalist Machete"
ENT.Category = "M.A.N.N. Offense Solutions - Melees"
ENT.Author = "Mannytko"
ENT.Spawnable = true
ENT.Scale = 1.3
-- Entity settings
ENT.Model = Model("models/mos/weapons/melees/ps2_ns_melee_tmc_01.mdl")
ENT.ImpactSound = Sound("physics/metal/metal_grenade_impact_hard" .. math.random(1, 3) .. ".wav")
ENT.AttackSound = Sound("weapons/knife/knife_hit" .. math.random(1, 4) .. ".wav")
ENT.JModPreferredCarryAngles = Angle(30, 20, 30)
-- Melee settings
ENT.Damage = 30
ENT.DMGType = DMG_SLASH -- DMG_CLUB for blunt damage, DMG_SLASH for sharp damage
-------------------------------------
if CLIENT then language.Add("ent_mann_mos_melee_survmachete", "Survivalist Machete") end