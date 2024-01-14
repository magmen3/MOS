-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Base = "ent_jack_gmod_ezgrenade"
ENT.Author = "Mannytko"
ENT.Category = "M.A.N.N. Offense Solutions - Misc"
ENT.PrintName = "EZ Plasma Grenade"
ENT.Spawnable = true
ENT.Model = "models/mos/weapons/halo/covenant/halo2a/weapons/plasmagrenade/plasmagrenade.mdl"
local BaseClass = baseclass.Get(ENT.Base)
if SERVER then
	function ENT:Prime()
		self:SetState(JMod.EZ_STATE_PRIMED)
		self:EmitSound("jids/snd_jack_beginice.wav", 60, 100)
	end

	function ENT:Arm()
		self:SetState(JMod.EZ_STATE_ARMING)
		timer.Simple(
			.2,
			function()
				if not IsValid(self) then return end
				self:SetState(JMod.EZ_STATE_ARMED)
				util.SpriteTrail(self, 0, color_white, true, 5, 0, .3, 10, "trails/plasma")
			end
		)
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > .2 and data.Speed > 100 and self:GetState() == JMod.EZ_STATE_ARMED then
			self:Detonate()
		else
			BaseClass.PhysicsCollide(self, data, physobj)
		end
	end

	function ENT:Detonate()
		if self.Exploded then return end
		self:EmitSound("snds_jack_gmod/mine_warn.wav", 80, math.random(95, 105))
		JMod.EmitAIsound(self:GetPos(), 500, 3, 8)
		self.Exploded = true
		timer.Simple(
			.25,
			function()
				if not IsValid(self) then return end
				local SelfPos = self:GetPos()
				JMod.Sploom(JMod.GetEZowner(self), SelfPos, 120)
				self:EmitSound("snd_jack_plasmaburst.wav", 100, math.random(95, 105))
				self:EmitSound("snd_jack_impulse.wav", 110, math.random(95, 105))
				local Blam = EffectData()
				Blam:SetOrigin(SelfPos)
				Blam:SetScale(.5)
				util.Effect("eff_jack_plastisplosion", Blam, true, true)
				util.ScreenShake(SelfPos, 20, 20, 1, 800)
				self:Remove()
			end
		)
	end
else
	language.Add("ent_mann_gmod_mos_ezplasmanade", "EZ Plasma Grenade")
end