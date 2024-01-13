-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

-- Riot Shield
ENT.Type = "anim"
ENT.PrintName = "Riot Shield"
ENT.Author = "Mannytko"
ENT.Category = "M.A.N.N. Offense Solutions - Misc"
ENT.Spawnable = true
ENT.JModPreferredCarryAngles = Angle(0, 90, -100)
ENT.NoSitAllowed = true
ENT.JModEZstorable = false
if SERVER then
	-- Thanks to JMod for SpawnFunction code
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 15
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(angle_zero)
		ent:SetPos(SpawnPos)
		JMod.SetEZowner(ent, ply)
		ent:Spawn()
		ent:Activate()

		return ent
	end

	local NextUseTime = 0
	function ENT:Initialize()
		self:SetModel(Model("models/mos/weapons/heavy_weapons/shield.mdl"))
		self:SetModelScale(1.25, 0)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local PhysObj = self:GetPhysicsObject()
		if PhysObj:IsValid() then
			PhysObj:Wake()
			PhysObj:SetMass(70)
			PhysObj:SetMaterial("Combine_metal")
		end

		self:SetUseType(SIMPLE_USE)
		self.Held = false
		NextUseTime = CurTime() + .5
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > .3 and data.Speed > 200 then
			self:EmitSound(Sound("SolidMetal.ImpactHard"))
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		dmginfo:SetDamageForce(dmginfo:GetDamageForce() / 10)
		dmginfo:SetDamage(dmginfo:GetDamage() / 10)
		self:TakePhysicsDamage(dmginfo)
		if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
			local SelfPos = self:GetPos()
			sound.Play(Sound("SolidMetal.BulletImpact"), SelfPos, 80, 100)
			sound.Play(Sound("Concrete.BulletImpact"), SelfPos, 90, 100)
			local EffJam = EffectData()
			EffJam:SetOrigin(self:GetPos() + VectorRand(-15, 15))
			EffJam:SetAngles(self:GetAngles())
			EffJam:SetScale(.1)
			EffJam:SetMagnitude(2)
			util.Effect("ElectricSpark", EffJam)
		end
	end

	function ENT:Use(activator, caller)
		if NextUseTime < CurTime() and activator:IsPlayer() then
			if not self:IsPlayerHolding() then
				local Vec = activator:GetAimVector()
				self:SetPos(activator:GetShootPos() + Vec * 30)
				self:EmitSound(Sound("SolidMetal.ImpactHard"))
				activator:PickupObject(self)
			end

			NextUseTime = CurTime() + .8
		end
	end

	function ENT:Think()
		if self:IsOnFire() then
			self:Extinguish()
		end

		self:NextThink(CurTime() + .5)

		return true
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_mann_mos_shield", "Ballistic Shield")
end