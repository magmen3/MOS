-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_mann_mos_gun_base" -- Base
-- Info
ENT.PrintName = "M3 Mortar"
ENT.Category = "M.A.N.N. Offense Solutions - Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = true
-- Entity settings
ENT.Model = Model("models/mos/weapons/heavy_weapons/avalanche.mdl")
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
ENT.HudAngle = Vector(0, 180, 90)
ENT.HudAddRight = -160
ENT.RotateAttachment = -90
ENT.CustomShootFunction = true -- for developers
ENT.AllowReload = true
-- Gun settings
ENT.Sound = Sound("mos/weapons/fwp_laserrifle/laserrifle/laserrifleshoot.wav")
ENT.ReloadSound = Sound("jids/snd_jack_microwavevent.wav")
ENT.EmptySound = Sound("weapons/clipempty_rifle.wav")
ENT.RPM = 90 / 60
ENT.Recoil = 35
ENT.MaxClip = 1
ENT.ClipSize = 1
if CLIENT then
	language.Add("ent_mann_mos_gun_m3mortar", "M3 Mortar")
end

function ENT:Projectile_SpawnPos()
	local att = self.Attachment
	local pos
	if isstring(att) then
		pos = self:GetAttachment(self:LookupAttachment(att)).Pos
	elseif isnumber(att) then
		pos = self:GetAttachment(att).Pos
	else
		pos = self:WorldSpaceCenter()
	end

	if self.RangeProjectile_Offset then
		pos = pos + self:GetForward()
	end

	return pos
end

function ENT:RangeAttackProjectileVelocity()
	local Attachment = self:GetAttachment(self:LookupAttachment(self.Attachment or "muzzle_flash" or 1))
	local startPos = Attachment.Pos
	if self.Spread > 0 then
		startPos = startPos + VectorRand() * self.Spread or 0
	end

	return (startPos + self:GetRight() * 1000 - startPos):GetNormalized() * 2500
end

-------------------------------------
function ENT:CustomShoot()
	local Owner = JMod.GetEZowner(self)
	if not IsValid(Owner) or not Owner:IsPlayer() or Owner == nil then
		Owner = self:GetOwner() or self or game.GetWorld()
	end

	if math.random(1, 6) == 4 then
		self:Jam("electric", Owner)

		return
	end

	-- Attachment
	local Attachment = self:GetAttachment(self:LookupAttachment(self.Attachment or "muzzle_flash" or 1))
	if not Attachment then return end
	local shootOrigin = Attachment.Pos
	local shootAngles = self:GetAngles()
	shootAngles:RotateAroundAxis(shootAngles:Up(), self.RotateAttachment or 0)
	-- Bullet
	local proj = ents.Create("zb_mortar")
	proj:SetPos(shootOrigin)
	proj:SetAngles(shootAngles)
	proj:SetOwner(Owner)
	proj:Spawn()
	local proj_phys = proj:GetPhysicsObject()
	if IsValid(proj_phys) then
		proj_phys:SetVelocity(self:RangeAttackProjectileVelocity())
		proj_phys:EnableGravity(false)
	end

	-- Recoil
	local Frc = shootAngles:Forward() * -1000 + shootAngles:Right() * VectorRand(-90, 90) + shootAngles:Up() * 1500
	self:GetPhysicsObject():ApplyForceCenter(Frc)
	if self:IsPlayerHolding() then
		local ang = self:GetAngles() + AngleRand(-self.Recoil, self.Recoil) - Angle(0, 0, self.Recoil * 10)
		self:SetAngles(ang)
	end

	-- Muzzleflash
	local EffMuzzle = EffectData()
	EffMuzzle:SetOrigin(shootOrigin)
	EffMuzzle:SetAngles(Attachment.Ang)
	EffMuzzle:SetEntity(self)
	EffMuzzle:SetAttachment(1)
	util.Effect("ChopperMuzzleFlash", EffMuzzle)
	-- Sound
	self:EmitSound(self.Sound, 100, self.SNDPitch, 1, CHAN_WEAPON)
	if self.ClipSize <= 1 and self.MaxClip > 1 then
		self:EmitSound(Sound("jids/snd_jack_arcgunwarn.wav"), 75, self.SNDPitch, 1, CHAN_ITEM)
	end

	if Owner:IsPlayer() then
		Owner:ViewPunch(AngleRand(-self.Recoil / 4, self.Recoil / 4))
	end

	if self.ClipSize > 0 then
		self.ClipSize = self.ClipSize - 1
		self:SetNWInt("MOS-ClipSize", self.ClipSize)
	end

	self:EmitSound("snd_jack_plasmaburst.wav", 100, math.random(85, 95))
	self:EmitSound("snd_jack_impulse.wav", 110, math.random(85, 95))
end