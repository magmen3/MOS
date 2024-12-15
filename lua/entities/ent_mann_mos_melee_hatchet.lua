-- Mannytko 2024
if SERVER then AddCSLuaFile() end
ENT.Base = "ent_mann_mos_melee_base" -- Base
-- Info
ENT.Type = "anim"
ENT.PrintName = "Hatchet"
ENT.Category = "M.A.N.N. Offense Solutions - Melees"
ENT.Author = "Mannytko"
ENT.Spawnable = true
ENT.Scale = 1.4
ENT.Mass = 55
-- Entity settings
ENT.Model = Model("models/mos/weapons/melees/ps2_nso_melee_hatchet.mdl")
ENT.ImpactSound = Sound("physics/metal/metal_solid_impact_bullet" .. math.random(1, 4) .. ".wav")
ENT.AttackSound = Sound("physics/body/body_medium_break" .. math.random(3, 4) .. ".wav")
ENT.JModPreferredCarryAngles = Angle(30, 20, 30)
-- Melee settings
ENT.Damage = 34
ENT.DMGType = DMG_SLASH -- DMG_CLUB for blunt damage, DMG_SLASH for sharp damage
-------------------------------------
if CLIENT then language.Add("ent_mann_mos_melee_hatchet", "Hatchet") end