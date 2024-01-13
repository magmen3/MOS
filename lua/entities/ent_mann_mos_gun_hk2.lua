-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "HKII MGN"
ENT.Category = "M.A.N.N. Offense Solutions - Hacked Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/smgs/collector.mdl")
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -140
ENT.Attachment = "muzzle"
ENT.RotateAttachment = -90
ENT.MannCorp = false -- false disables authorization and sets holo color to red
ENT.EjectAttachment = ""
ENT.EjectType = ""
-- Gun settings
ENT.Spread = .075
ENT.Damage = 52
ENT.Sound = Sound("mos/weapons/fwp_laserrifle/laserrifle/laserrifleshoot.wav")
ENT.ReloadSound = Sound("jids/snd_jack_sniperturretcycle.wav")
ENT.EmptySound = Sound("weapons/clipempty_pistol.wav")
ENT.RPM = 42 / 60
ENT.Recoil = 12
ENT.MaxClip = 8
ENT.ClipSize = 8
if CLIENT then
	language.Add("ent_mann_mos_gun_hk2", "HKII Magnum")
end