-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Author = "Mannytko"
ENT.Category = "M.A.N.N. Offense Solutions - Misc"
ENT.PrintName = "EZ Advanced IFAK"
ENT.NoSitAllowed = true
ENT.Spawnable = true
ENT.JModEZstorable = true
ENT.JModPreferredCarryAngles = Angle(0, 90, 0)
if SERVER then
	function ENT:SpawnFunction(ply, tr)
		local SpawnPos = tr.HitPos + tr.HitNormal * 20
		local ent = ents.Create(self.ClassName)
		ent:SetAngles(angle_zero)
		ent:SetPos(SpawnPos)
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/mos/props/haxxer/me2_props/medcrate.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetUseType(SIMPLE_USE)
		local Phys = self:GetPhysicsObject()
		if IsValid(Phys) then
			Phys:SetMass(20)
			Phys:Wake()
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > .3 and data.Speed > 65 then
			self:EmitSound("SolidMetal.ImpactSoft")
		end
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)
		local Pos = self:GetPos()
		if JMod.LinCh(dmginfo:GetDamage(), 30, 100) then
			sound.Play("SolidMetal.ImpactHard", Pos)
			SafeRemoveEntityDelayed(self, 1)
		end
	end

	function ENT:Use(activator)
		local Alt = activator:KeyDown(JMod.Config.General.AltFunctionKey)
		if Alt then
			activator.EZnutrition = activator.EZnutrition or {
				Nutrients = 0
			}

			local Helf, Max = activator:Health(), activator:GetMaxHealth()
			activator.EZhealth = activator.EZhealth or 0
			local Missing = Max - (Helf + activator.EZhealth)
			if Missing > 0 then
				local AddAmt = math.min(Missing, 15 * JMod.Config.Tools.Medkit.HealMult)
				for i = 1, 3 do
					activator:EmitSound("snds_jack_gmod/ez_medical/" .. math.random(1, 12) .. ".wav", 60, math.random(90, 110))
				end

				if activator.EZnutrition.Nutrients < 20 then
					JMod.ConsumeNutrients(activator, math.random(6, 8)) -- analog of "food boost" from homicide
				end

				activator.EZhealth = activator.EZhealth + AddAmt
				self:Remove()
			end

			if activator.EZbleeding and (activator.EZbleeding > 0) then
				for i = 1, 3 do
					activator:EmitSound("snds_jack_gmod/ez_medical/" .. math.random(4, 8) .. ".wav", 60, math.random(90, 110))
				end

				activator:PrintMessage(HUD_PRINTCENTER, "stopping bleeding")
				activator.EZbleeding = math.Clamp(activator.EZbleeding - JMod.Config.Tools.Medkit.HealMult * 80, 0, 9e9)
				if activator.EZnutrition.Nutrients < 20 then
					JMod.ConsumeNutrients(activator, math.random(4, 6))
				end

				activator:ViewPunch(Angle(math.Rand(-2, 2), math.Rand(-2, 2), math.Rand(-2, 2)))
				self:Remove()
			end
		else
			JMod.Hint(activator, "ifak")
			activator:PickupObject(self)
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	language.Add("ent_jack_gmod_ezadvifak", "EZ Advanced IFAK")
end