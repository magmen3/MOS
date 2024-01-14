-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "SUPP-18"
ENT.Category = "M.A.N.N. Offense Solutions - Hacked Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/pistols/suppressor.mdl")
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -80
ENT.RotateAttachment = -90
ENT.Attachment = "muzzle"
ENT.Light = false
ENT.MannCorp = false -- false disables authorization and sets holo color to red
ENT.AllowMuzzleFlash = false
ENT.JModEZstorable = true -- Set true for handguns that should be storable
-- Gun settings
ENT.Spread = .05
ENT.Damage = 23
ENT.Sound = Sound("mos/weapons/fwp_laserpistol/laserpistol/laserpistolshoot.wav")
ENT.ReloadSound = Sound("jids/snd_jack_icereload.wav")
ENT.EmptySound = Sound("weapons/clipempty_pistol.wav")
ENT.RPM = 23 / 60
ENT.Recoil = 6
ENT.MaxClip = 17
ENT.ClipSize = 17
if CLIENT then
	language.Add("ent_mann_mos_gun_supp18", "SUPP-18")
end