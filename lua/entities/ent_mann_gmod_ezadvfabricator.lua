-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.PrintName = "EZ Advanced Fabricator"
ENT.Author = "Mannytko"
ENT.Category = "M.A.N.N. Offense Solutions - Misc"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Model = "models/mos/props/lt_c/holograms/console_hr.mdl"
ENT.Mass = 1500
ENT.JModPreferredCarryAngles = Angle(0, 180, 0)
ENT.EZconsumes = {JMod.EZ_RESOURCE_TYPES.BASICPARTS, JMod.EZ_RESOURCE_TYPES.WATER, JMod.EZ_RESOURCE_TYPES.GAS, JMod.EZ_RESOURCE_TYPES.CHEMICALS, JMod.EZ_RESOURCE_TYPES.POWER}
ENT.Base = "ent_jack_gmod_ezmachine_base"
ENT.StaticPerfSpecs = {
	MaxDurability = 150,
	Armor = .8,
	MaxElectricity = 300,
	MaxGas = 300,
	MaxChemicals = 100,
	MaxWater = 100
}

local STATE_FINE = 0
function ENT:CustomSetupDataTables()
	self:NetworkVar("Float", 1, "Gas")
	self:NetworkVar("Float", 2, "Water")
	self:NetworkVar("Float", 3, "Chemicals")
end

if SERVER then
	function ENT:CustomInit()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetBuoyancyRatio(.1)
			phys:SetMaterial("Combine_metal")
		end

		if not self.EZowner then
			self:SetColor(Color(45, 101, 153))
		end

		self:UpdateConfig()
		if self.SpawnFull then
			self:SetGas(self.MaxGas)
			self:SetChemicals(self.MaxChemicals)
			self:SetWater(self.MaxWater)
		else
			self:SetGas(0)
			self:SetChemicals(0)
			self:SetWater(0)
		end

		JMod.SetEZowner(self, self.EZowner)
	end

	function ENT:UpdateConfig()
		self.Craftables = {}
		for name, info in pairs(JMod.Config.Craftables) do
			if (istable(info.craftingType) and table.HasValue(info.craftingType, "fabricator")) or (info.craftingType == "fabricator") then
				-- we store this here for client transmission later
				-- because we can't rely on the client having the config
				local infoCopy = table.FullCopy(info)
				infoCopy.name = name
				self.Craftables[name] = info
			end
		end
	end

	function ENT:Use(activator)
		if self:GetState() == STATE_FINE then
			if (self:GetElectricity() >= 10) and (self:GetGas() >= 8) and (self:GetWater() >= 4) and (self:GetChemicals() >= 4) then
				net.Start("JMod_EZworkbench")
				net.WriteEntity(self)
				net.WriteTable(self.Craftables)
				net.WriteFloat(1)
				net.Send(activator)
			else
				JMod.Hint(activator, "refillfab")
			end
		else
			JMod.Hint(activator, "destroyed")
		end
	end

	function ENT:TryBuild(itemName, ply)
		local ItemInfo = self.Craftables[itemName]
		if not (self:GetElectricity() >= 10) or not (self:GetGas() >= 8) or not (self:GetWater() >= 4) or not (self:GetChemicals() >= 4) then
			JMod.Hint(ply, "refill")

			return
		end

		if JMod.HaveResourcesToPerformTask(nil, nil, ItemInfo.craftingReqs, self) then
			local override, msg = hook.Run("JMod_CanWorkbenchBuild", ply, workbench, itemName)
			if override == false then
				ply:PrintMessage(HUD_PRINTCENTER, msg or "cannot build")

				return
			end

			local Pos, Ang, BuildSteps = self:GetPos() + self:GetUp() * 75 - self:GetForward() * 10 - self:GetRight() * 5, self:GetAngles(), 10
			JMod.ConsumeResourcesInRange(ItemInfo.craftingReqs, Pos, nil, self, true)
			timer.Simple(
				1,
				function()
					if IsValid(self) then
						for i = 1, BuildSteps do
							timer.Simple(
								i / 100,
								function()
									if IsValid(self) then
										if i < BuildSteps then
											sound.Play("snds_jack_gmod/ez_robotics/" .. math.random(1, 42) .. ".wav", Pos, 60, math.random(80, 120))
										else
											JMod.BuildRecipe(ItemInfo.results, ply, Pos, Ang, ItemInfo.skin)
											JMod.BuildEffect(Pos)
											self:SetElectricity(math.Clamp(self:GetElectricity() - 15, 0.0, self.MaxElectricity))
											self:SetGas(math.Clamp(self:GetGas() - 10, 0.0, self.MaxGas))
											self:SetWater(math.Clamp(self:GetWater() - 5, 0.0, self.MaxWater))
											self:SetChemicals(math.Clamp(self:GetChemicals() - 5, 0.0, self.MaxChemicals))
										end
									end
								end
							)
						end
					end
				end
			)
		else
			JMod.Hint(ply, "missing supplies")
		end
	end
elseif CLIENT then
	function ENT:CustomInit()
		self.ZipZoop = JMod.MakeModel(self, "models/mos/props/lt_c/sci_fi/ground_locker_small.mdl", "", .8)
		if not self.EZowner then
			self.ZipZoop:SetColor(Color(45, 101, 153))
		else
			JMod.Colorify(self.ZipZoop) -- does not work
		end

		self:SetBodygroup(4, 2)
		self:SetBodygroup(5, 1)
	end

	function ENT:DrawTranslucent()
		local SelfPos, SelfAng = self:GetPos(), self:GetAngles()
		local Up, Right, Forward = SelfAng:Up(), SelfAng:Right(), SelfAng:Forward()
		local BasePos = SelfPos + Up * 60
		local Obscured = false
		--[[
			util.TraceLine({
			start = EyePos(),
			endpos = BasePos,
			filter = {LocalPlayer(), self},
			mask = MASK_OPAQUE
		}).Hit
		]]
		local Closeness = LocalPlayer():GetFOV() * EyePos():Distance(SelfPos)
		local DetailDraw = Closeness < 36000 -- cutoff point is 400 units when the fov is 90 degrees
		if (not DetailDraw) and Obscured then return end
		-- if player is far and sentry is obscured, draw nothing
		-- if obscured, at least disable details
		if Obscured then
			DetailDraw = false
		end

		if self:GetState() < 0 then
			DetailDraw = false
		end

		self:DrawModel()
		if DetailDraw then
			if self:GetElectricity() > 0 then
				local Opacity = math.random(50, 200)
				local ElecFrac, GasFrac, ChemFrac, WaterFrac = self:GetElectricity() / self.MaxElectricity, self:GetGas() / self.MaxGas, self:GetChemicals() / self.MaxChemicals, self:GetWater() / self.MaxWater
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(Forward, 90)
				DisplayAng:RotateAroundAxis(Up, 90)
				cam.Start3D2D(BasePos + Up * 16 - Right * 3 - Forward * 0, DisplayAng, .1)
				draw.SimpleTextOutlined("POWER " .. math.Round(ElecFrac * 100) .. "%", "JMod-Display", 0, 60, JMod.GoodBadColor(ElecFrac, true, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				draw.SimpleTextOutlined("GAS " .. math.Round(GasFrac * 100) .. "%", "JMod-Display", 0, 100, JMod.GoodBadColor(GasFrac, true, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				draw.SimpleTextOutlined("CHEMICALS " .. math.Round(ChemFrac * 100) .. "%", "JMod-Display", 0, 140, JMod.GoodBadColor(ChemFrac, true, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				draw.SimpleTextOutlined("WATER " .. math.Round(WaterFrac * 100) .. "%", "JMod-Display", 0, 180, JMod.GoodBadColor(WaterFrac, true, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				cam.End3D2D()
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(Forward, 90)
				DisplayAng:RotateAroundAxis(Up, 90)
				cam.Start3D2D(BasePos - Up * 9 - Right * 15 - Forward * 0, DisplayAng, .07)
				draw.SimpleTextOutlined("POWER " .. math.Round(ElecFrac * 100) .. "%", "JMod-Display", -550, 10, JMod.GoodBadColor(ElecFrac, true, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				draw.SimpleTextOutlined("GAS " .. math.Round(GasFrac * 100) .. "%", "JMod-Display", -335, 10, JMod.GoodBadColor(GasFrac, true, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				draw.SimpleTextOutlined("CHEMICALS " .. math.Round(ChemFrac * 100) .. "%", "JMod-Display", -80, 10, JMod.GoodBadColor(ChemFrac, true, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				draw.SimpleTextOutlined("WATER " .. math.Round(WaterFrac * 100) .. "%", "JMod-Display", 190, 10, JMod.GoodBadColor(WaterFrac, true, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				cam.End3D2D()
				local DisplayAng = SelfAng:GetCopy()
				DisplayAng:RotateAroundAxis(Forward, 90)
				DisplayAng:RotateAroundAxis(Up, 90)
				cam.Start3D2D(BasePos + Up * 26 - Right * 41 - Forward * 0, DisplayAng, .12)
				draw.SimpleTextOutlined(self.PrintName, "JMod-Display", -550, 10, JMod.GoodBadColor(ElecFrac, true, Opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, Opacity))
				cam.End3D2D()
				self:SetBodygroup(1, 0)
				self:SetBodygroup(2, 0)
				self:SetBodygroup(3, 0)
				self:SetBodygroup(4, 2)
				self:SetBodygroup(5, 1)
			else
				self:SetBodygroup(1, 1)
				self:SetBodygroup(2, 1)
				self:SetBodygroup(3, 1)
				self:SetBodygroup(4, 2)
				self:SetBodygroup(5, 1)
			end

			local DisplayAng = SelfAng:GetCopy()
			DisplayAng:RotateAroundAxis(Up, 0)
			DisplayAng:RotateAroundAxis(Right, 0)
			DisplayAng:RotateAroundAxis(Forward, 0)
			JMod.RenderModel(self.ZipZoop, BasePos - Forward * 12 - Right * 56 - Up * 60, DisplayAng)
		end
	end

	language.Add("ent_jack_gmod_ezfabricator", "EZ Fabricator")
end