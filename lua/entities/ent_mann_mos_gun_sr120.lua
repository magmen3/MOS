-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "SR-120"
ENT.Category = "M.A.N.N. Offense Solutions - Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/sniper_rifles/widow.mdl")
ENT.Mass = 70
ENT.JModPreferredCarryAngles = Angle(0, 87.6, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -90
ENT.RotateAttachment = -90
ENT.EjectType = "RifleShellEject"
-- Gun settings
ENT.Spread = .015
ENT.Damage = 120
ENT.Sound = Sound("mos/weapons/fwp_lasermusket/lasermusket/lasermusketshoot.wav")
ENT.ReloadSound = Sound("jids/snd_jack_microwavevent.wav")
ENT.EmptySound = Sound("weapons/clipempty_rifle.wav")
ENT.RPM = 80 / 60
ENT.Recoil = 15
ENT.MaxClip = 1
ENT.ClipSize = 1
if CLIENT then
	language.Add("ent_mann_mos_gun_sr120", "SR-120")
end