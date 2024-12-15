-- Mannytko 2024
if SERVER then AddCSLuaFile() end
-- M.A.N.N. Offense Solutions Melee Base
-- Info
ENT.Type = "anim"
ENT.PrintName = "MOS Melee Base"
ENT.Category = "M.A.N.N. Offense Solutions - Melees"
ENT.Author = "Mannytko"
ENT.Spawnable = false
ENT.IconOverride = "vgui/gfx/vgui/market_sticker_category"
-- Entity settings
ENT.Model = Model("models/weapons/w_crowbar.mdl")
ENT.ImpactSound = Sound("weapons/crowbar/crowbar_impact" .. math.random(1, 2) .. ".wav")
ENT.AttackSound = Sound("weapons/knife/knife_hit" .. math.random(1, 4) .. ".wav")
ENT.Mass = 50
ENT.Scale = 1.25
-- Sets the holdtype when we are holding entity
ENT.HoldType = "pistol" -- https://wiki.facepunch.com/gmod/Hold_Types
-- Melee settings
ENT.Damage = 20
ENT.DMGType = DMG_CLUB -- DMG_CLUB for blunt damage, DMG_SLASH for sharp damage
-- JMod compatibility settings
ENT.NoSitAllowed = true
ENT.JModPreferredCarryAngles = angle_zero
ENT.JModEZstorable = false
-------------------------------------
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

	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetModelScale(self.Scale or 1, 0)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		local PhysObj = self:GetPhysicsObject()
		if IsValid(PhysObj) then
			PhysObj:SetMass(self.Mass or 50)
			PhysObj:Wake()
		end

		if not JMod.GetEZowner(self) then
			local own = self:GetOwner() or self or game.GetWorld()
			JMod.SetEZowner(self, own)
		end
	end

	local oldholdtype
	function ENT:Use(ply, caller)
		if not self:IsPlayerHolding() then
			local Vec = ply:GetAimVector()
			self:SetPos(ply:GetShootPos() + Vec * 30)
			ply:PickupObject(self)
			JMod.SetEZowner(self, ply)
		end

		local Owner = JMod.GetEZowner(self)
		if not IsValid(Owner) or not Owner:IsPlayer() or Owner == nil then return end
		oldholdtype = IsValid(Owner:GetActiveWeapon()) and Owner:GetActiveWeapon():GetHoldType()
	end

	function ENT:Think()
		if self:IsOnFire() then self:Extinguish() end
		local Owner = JMod.GetEZowner(self)
		if not IsValid(Owner) or not Owner:IsPlayer() or Owner == nil then return end
		local IsGrabbing = self:IsPlayerHolding() or (IsValid(Owner:GetActiveWeapon()) and Owner:GetActiveWeapon():GetClass() == "wep_jack_gmod_hands" and Owner:GetActiveWeapon().CarryEnt == self)
		if not IsGrabbing then oldholdtype = IsValid(Owner:GetActiveWeapon()) and Owner:GetActiveWeapon():GetHoldType() end
		if IsValid(Owner:GetActiveWeapon()) and IsGrabbing then
			Owner:GetActiveWeapon():SetHoldType(self.HoldType or "pistol")
		elseif IsValid(Owner:GetActiveWeapon()) and not IsGrabbing then
			Owner:GetActiveWeapon():SetHoldType(oldholdtype or "normal")
		end

		self:NextThink(CurTime() + .5)
		return true
	end

	local dmgmul = GetConVar("MOS_DamageMul"):GetInt()
	function ENT:DamageEnt(victim)
		local Owner = JMod.GetEZowner(self)
		if not IsValid(Owner) or not Owner:IsPlayer() or Owner == nil then Owner = self:GetOwner() or self or game.GetWorld() end
		-- Damage
		local DMG = DamageInfo()
		DMG:SetDamage(self.Damage * dmgmul)
		DMG:SetAttacker(Owner or self or game.GetWorld())
		DMG:SetInflictor(self)
		DMG:SetDamageType(self.DMGType or DMG_CLUB)
		victim:TakeDamageInfo(DMG)
		-- Attack Effect
		if IsValid(victim) and (victim:IsPlayer() or victim:IsNPC() or victim:IsRagdoll()) then
			local EffBlood = EffectData()
			EffBlood:SetOrigin(self:GetPos() + (vector_up * 8))
			EffBlood:SetAngles(self:GetAngles())
			EffBlood:SetFlags(3)
			EffBlood:SetScale(4)
			if (self.Damage * dmgmul) >= (30 * dmgmul) then
				EffBlood:SetScale(6)
				util.Effect("BloodImpact", EffBlood)
			end

			util.Effect("bloodspray", EffBlood)
		end

		-- Sound
		local Snd = self.AttackSound or Sound("weapons/knife/knife_hit" .. math.random(1, 4) .. ".wav")
		self:EmitSound(Snd, 80, math.random(95, 105), 1, CHAN_WEAPON)
	end

	local NextAttack = 0
	function ENT:PhysicsCollide(data, physobj)
		local Owner = JMod.GetEZowner(self)
		if not IsValid(Owner) or not Owner:IsPlayer() or Owner == nil then Owner = self:GetOwner() or self or game.GetWorld() end
		if NextAttack > CurTime() then return end
		if data.DeltaTime > .3 and data.Speed >= 400 then
			local Snd = self.ImpactSound or Sound("weapons/crowbar/crowbar_impact" .. math.random(1, 2) .. ".wav")
			self:EmitSound(Snd, 65, math.random(95, 105), 1, CHAN_ITEM)
			NextAttack = CurTime() + .5
		end

		if data.DeltaTime > .3 and data.Speed >= 600 then
			if IsValid(data.HitEntity) and data.HitEntity ~= Owner then
				self:DamageEnt(data.HitEntity)
				NextAttack = CurTime() + .8
			elseif data.HitEntity == game.GetWorld() then
				-- World Attack Effect
				local EffWrld = EffectData()
				EffWrld:SetOrigin(self:GetPos() + (vector_up * 8))
				EffWrld:SetAngles(self:GetAngles())
				EffWrld:SetMagnitude(1.15)
				EffWrld:SetScale(.5)
				util.Effect("ElectricSpark", EffWrld)
				NextAttack = CurTime() + .5
			end
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_mann_mos_melee_base", "MOS Melee Base")
end

if SERVER then MOS.Print(ENT.PrintName .. " Initialized!") end