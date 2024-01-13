-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "DB-4"
ENT.Category = "M.A.N.N. Offense Solutions - Hacked Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/pistols/bloodpack.mdl")
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -80
ENT.RotateAttachment = -90
ENT.Attachment = "muzzle"
ENT.Light = true
ENT.MannCorp = false -- false disables authorization and sets holo color to red
ENT.EjectAttachment = "heatsink_eject"
ENT.EjectType = "EjectBrass_12Gauge"
ENT.JModEZstorable = true -- Set true for handguns that should be storable
-- Gun settings
ENT.Spread = .085
ENT.Damage = 18
ENT.Sound = Sound("mos/weapons/fwp_combatshotgun/combatshotgun/combatshotgunshoot.wav")
ENT.ReloadSound = Sound("jids/snd_jack_icereload.wav")
ENT.EmptySound = Sound("weapons/clipempty_pistol.wav")
ENT.RPM = 28 / 60
ENT.Recoil = 9
ENT.MaxClip = 4
ENT.ClipSize = 4
ENT.Bullets = 6
if CLIENT then
	language.Add("ent_mann_mos_gun_db4", "DB-4")
end