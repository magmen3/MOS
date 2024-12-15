-- Mannytko 2024
if SERVER then AddCSLuaFile() end
ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "LR-49"
ENT.Category = "M.A.N.N. Offense Solutions - Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/assault_rifles/falcon.mdl")
ENT.Mass = 55
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -90
ENT.RotateAttachment = -90
ENT.EjectType = "RifleShellEject"
-- Gun settings
ENT.Spread = .045
ENT.Damage = 35
ENT.Sound = Sound("jids/snd_jack_pilefire.wav")
ENT.ReloadSound = Sound("jids/snd_jack_coilgunreload.wav")
ENT.EmptySound = Sound("weapons/clipempty_rifle.wav")
ENT.RPM = 8 / 60
ENT.Recoil = 7
ENT.MaxClip = 30
ENT.ClipSize = 30
if CLIENT then language.Add("ent_mann_mos_gun_lr49", "LR-49") end