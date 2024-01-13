-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "HR-103"
ENT.Category = "M.A.N.N. Offense Solutions - Hacked Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/assault_rifles/revenant.mdl")
ENT.Mass = 55
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -120
ENT.RotateAttachment = -90
ENT.MannCorp = false -- false disables authorization and sets holo color to red
ENT.EjectType = "RifleShellEject"
ENT.SWEP = "wep_mann_mos_gun_hr103"
ENT.Color = Color(190, 150, 150, 255)
-- Gun settings
ENT.Spread = .075
ENT.Damage = 36
ENT.Sound = Sound("mos/weapons/fwp_10mmsmg/10mmsmg/10mmsmgshoot.wav")
ENT.ReloadSound = Sound("jids/snd_jack_icereload.wav")
ENT.EmptySound = Sound("weapons/clipempty_rifle.wav")
ENT.RPM = 7 / 60
ENT.Recoil = 7
ENT.MaxClip = 31
ENT.ClipSize = 31
if CLIENT then
	language.Add("ent_mann_mos_gun_hr103", "HR-103")
end