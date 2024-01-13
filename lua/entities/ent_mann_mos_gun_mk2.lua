-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "MKII MGN"
ENT.Category = "M.A.N.N. Offense Solutions - Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/shotguns/reegar.mdl")
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -140
ENT.Attachment = "muzzle"
ENT.RotateAttachment = -90
ENT.EjectAttachment = ""
ENT.EjectType = ""
-- Gun settings
ENT.Spread = .055
ENT.Damage = 45
ENT.Sound = Sound("mos/weapons/fwp_10mmsmg/10mmsmg/10mmsmgshoot.wav")
ENT.ReloadSound = Sound("jids/snd_jack_sniperturretcycle.wav")
ENT.EmptySound = Sound("weapons/clipempty_pistol.wav")
ENT.RPM = 38 / 60
ENT.Recoil = 9
ENT.MaxClip = 8
ENT.ClipSize = 8
if CLIENT then
	language.Add("ent_mann_mos_gun_mk2", "MKII Magnum")
end