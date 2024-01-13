-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "HG-22"
ENT.Category = "M.A.N.N. Offense Solutions - Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/pistols/eagle.mdl")
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -80
ENT.RotateAttachment = -90
ENT.JModEZstorable = true -- Set true for handguns that should be storable
ENT.SWEP = "wep_mann_mos_gun_hg22"
-- Gun settings
ENT.Spread = .03
ENT.Damage = 17
ENT.Sound = Sound("jids/snd_jack_electrolaserfire.wav")
ENT.ReloadSound = Sound("jids/snd_jack_icereload.wav")
ENT.EmptySound = Sound("weapons/clipempty_pistol.wav")
ENT.RPM = 19 / 60
ENT.Recoil = 5
ENT.MaxClip = 16
ENT.ClipSize = 16
if CLIENT then
	language.Add("ent_mann_mos_gun_hg22", "HG-22")
end