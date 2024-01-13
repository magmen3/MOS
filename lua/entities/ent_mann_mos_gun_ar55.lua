-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "AR-55"
ENT.Category = "M.A.N.N. Offense Solutions - Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/assault_rifles/argus.mdl")
ENT.Mass = 55
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -90
ENT.RotateAttachment = -90
ENT.EjectType = "RifleShellEject"
ENT.SWEP = "wep_mann_mos_gun_ar55"
-- Gun settings
ENT.Spread = .065
ENT.Damage = 30
ENT.Sound = Sound("jids/snd_jack_iceshot.wav")
ENT.ReloadSound = Sound("jids/snd_jack_icereload.wav")
ENT.EmptySound = Sound("weapons/clipempty_rifle.wav")
ENT.RPM = 6 / 60
ENT.Recoil = 5
ENT.MaxClip = 30
ENT.ClipSize = 30
if CLIENT then
	language.Add("ent_mann_mos_gun_ar55", "AR-55")
end