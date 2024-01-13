-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "SMG-25"
ENT.Category = "M.A.N.N. Offense Solutions - Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/smgs/hornet.mdl")
ENT.Mass = 45
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -90
ENT.RotateAttachment = -90
ENT.SWEP = "wep_mann_mos_gun_smg25"
-- Gun settings
ENT.Spread = .06
ENT.Damage = 15
ENT.Sound = Sound("mos/weapons/fwp_wattzlasergun/wattzlasergun/wattzshoot.wav")
ENT.ReloadSound = Sound("jids/snd_jack_coilgunreload.wav")
ENT.EmptySound = Sound("weapons/clipempty_rifle.wav")
ENT.RPM = 4 / 60
ENT.Recoil = 6
ENT.MaxClip = 25
ENT.ClipSize = 25
if CLIENT then
	language.Add("ent_mann_mos_gun_smg25", "SMG25")
end