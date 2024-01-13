-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

-- M.A.N.N. Offense Solutions Entity gun base
-- Info
ENT.Type = "anim"
ENT.PrintName = "MOS Gun Base"
ENT.Category = "M.A.N.N. Offense Solutions - Firearms"
ENT.Author = "Mannytko"
ENT.Spawnable = false
ENT.IconOverride = "vgui/gfx/vgui/market_sticker_category"
-- Entity settings
ENT.Model = Model("models/weapons/w_pist_glock18.mdl")
ENT.ImpactSound = Sound("physics/metal/weapon_impact_hard" .. math.random(1, 3) .. ".wav")
ENT.Mass = 45
ENT.Scale = 1.2
ENT.HudAngle = Vector(90, -90, 0)
ENT.RotateAttachment = 0
ENT.Light = true
ENT.MannCorp = true -- False disables authorization and sets holo color to red and affects SNDPitch
ENT.SNDPitch = math.random(95, 105) -- Affects interface sounds, fire sound, etc.
ENT.HoldType = "duel" -- Sets the holdtype when we are holding entity
ENT.CustomShootFunction = false -- For developers
ENT.SWEP = nil
ENT.Color = color_white
-- Gun settings
ENT.Bullets = 1
ENT.Spread = .015
ENT.Damage = 15
ENT.Attachment = "muzzle_flash"
ENT.Sound = "weapons/pistol/pistol_fire2.wav"
ENT.ReloadSound = "weapons/pistol/pistol_reload1.wav"
ENT.ReloadTime = 2
ENT.EmptySound = "weapons/clipempty_pistol.wav"
ENT.RPM = 10 / 60
ENT.Recoil = 10
ENT.MaxClip = 18
ENT.ClipSize = 18
ENT.EjectAttachment = "heatsink_eject"
ENT.EjectType = "ShellEject"
ENT.AllowMuzzleFlash = true
ENT.AllowReload = false
-- JMod compatibility settings
ENT.NoSitAllowed = true
ENT.JModPreferredCarryAngles = angle_zero
ENT.JModEZstorable = false -- Set true for handguns that should be storable
ENT.EZscannerDanger = true
-------------------------------------
ENT.Reloading = false
ENT.IsFirstTimeUsed = true
ENT.RecoilHeat = 0
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

	local NextUse = 0
	local RPM = 0
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetModelScale(self.Scale or 1, 0)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetColor(self.Color or color_white)
		self.SNDPitch = self.MannCorp and self.SNDPitch or self.SNDPitch - 15
		RPM = CurTime() + 1.5
		NextUse = CurTime() + .5
		local PhysObj = self:GetPhysicsObject()
		if PhysObj:IsValid() then
			PhysObj:SetMass(self.Mass or 45)
			PhysObj:Wake()
		end

		if not JMod.GetEZowner(self) then
			local own = self:GetOwner() or self or game.GetWorld()
			JMod.SetEZowner(self, own)
			SafeRemoveEntityDelayed(self, 10)
		end

		JMod.Hint(JMod.GetEZowner(self), "pickup")
		self:SetSequence("collapsed")
	end

	function ENT:CustomShoot()
	end

	local dmgmul = GetConVar("MOS_DamageMul"):GetInt()
	function ENT:Shoot()
		if self.CustomShootFunction then
			self:CustomShoot() -- For developers

			return
		end

		local Owner = JMod.GetEZowner(self)
		if not IsValid(Owner) or not Owner:IsPlayer() or Owner == nil then
			Owner = self:GetOwner() or self or game.GetWorld()
		end

		-- Attachment
		local Attachment = self:GetAttachment(self:LookupAttachment(self.Attachment or "muzzle_flash" or 1))
		if not Attachment then return end
		local shootOrigin = Attachment.Pos
		local shootAngles = self:GetAngles()
		shootAngles:RotateAroundAxis(shootAngles:Up(), self.RotateAttachment or 0)
		local shootDir = shootAngles:Forward()
		-- Bullet
		local bullet = {}
		bullet.Num = self.Bullets or 1
		bullet.Src = shootOrigin
		bullet.Dir = shootDir
		bullet.Spread = Vector(self.Spread or 0, self.Spread or 0, 0)
		local Trac = self.MannCorp and "AR2Tracer" or "Tracer"
		bullet.TracerName = Trac
		bullet.Force = (self.Damage * dmgmul) / 10
		bullet.Damage = self.Damage * dmgmul
		bullet.Attacker = Owner or self or game.GetWorld()
		self:FireBullets(bullet)
		-- Recoil
		local Frc = shootAngles:Forward() * -1000 + shootAngles:Right() * VectorRand(-90, 90) + shootAngles:Up() * 1500
		self:GetPhysicsObject():ApplyForceCenter(Frc)
		if self:IsPlayerHolding() then
			local ang = self:GetAngles() + AngleRand(-self.Recoil, self.Recoil) - Angle(0, 0, self.Recoil * 10)
			self:SetAngles(ang)
			local Vec = Owner:GetAimVector()
			self:SetPos(Owner:GetShootPos() + Vec * 25)
		end

		-- Muzzleflash
		if self.AllowMuzzleFlash then
			local EffMuzzle = EffectData()
			EffMuzzle:SetOrigin(shootOrigin)
			EffMuzzle:SetAngles(Attachment.Ang)
			local Muzlo = self.MannCorp and "AR2Impact" or "MuzzleEffect"
			util.Effect(Muzlo, EffMuzzle)
		end

		-- Shell eject
		if self.EjectAttachment and self.EjectAttachment ~= "" and self.EjectType and self.EjectType ~= "" then
			local EjectAttachment = self:GetAttachment(self:LookupAttachment(self.EjectAttachment or "heatsink_eject" or 2))
			local EffEject = EffectData()
			EffEject:SetOrigin(EjectAttachment.Pos)
			EffEject:SetAngles(EjectAttachment.Ang)
			EffEject:SetFlags(50) -- Acts as velocity for CSS shells
			EffEject:SetMagnitude(50)
			local Ejector3000 = self.EjectType or "ShellEject"
			util.Effect(Ejector3000, EffEject)
		end

		-- Sound
		self:EmitSound(self.Sound, 100, self.SNDPitch, 1, CHAN_WEAPON)
		if self.ClipSize <= 1 and self.MaxClip > 1 then
			self:EmitSound(Sound("jids/snd_jack_arcgunwarn.wav"), 75, self.SNDPitch, 1, CHAN_ITEM)
		end

		if self.RecoilHeat >= 2 then
			RPM = CurTime() + self.RPM + 1
		end

		if self.RecoilHeat <= 3 then
			self.RecoilHeat = self.RecoilHeat + .15
		end

		if Owner:IsPlayer() and self:IsPlayerHolding() then
			Owner:ViewPunch(AngleRand(-self.Recoil / 7, self.Recoil / 7) + Angle(-self.RecoilHeat, 0, 0))
		end

		if self.ClipSize > 0 then
			self.ClipSize = self.ClipSize - 1
			self:SetNWInt("MOS-ClipSize", self.ClipSize)
		end
	end

	function ENT:Reload()
		if not self.AllowReload then return end
		local Owner = JMod.GetEZowner(self)
		local IsGrabbing = self:IsPlayerHolding() or (Owner:GetActiveWeapon():IsValid() and Owner:GetActiveWeapon():GetClass() == "wep_jack_gmod_hands" and Owner:GetActiveWeapon().CarryEnt == self)
		if not IsGrabbing then return end
		self.Reloading = true
		if self.RecoilHeat >= 0 then
			self.RecoilHeat = 0
		end

		self:EmitSound(self.ReloadSound or Sound("weapons/pistol/pistol_reload1.wav"), 60, self.SNDPitch, 1, CHAN_WEAPON)
		timer.Simple(
			self.ReloadTime or 2,
			function()
				if not self:IsValid() or not IsGrabbing then return end
				self.ClipSize = self.MaxClip
				self:SetNWInt("MOS-ClipSize", self.ClipSize)
				self.Reloading = false
				if self.RecoilHeat >= 1 then
					self.RecoilHeat = self.RecoilHeat - 1
				end
			end
		)
	end

	function ENT:Jam(type, ply)
		local Type = type or "shoot"
		if Type == "shoot" then
			local Snd = self.ImpactSound or Sound("physics/metal/weapon_impact_hard" .. math.random(1, 3) .. ".wav")
			self:EmitSound(Snd, 55, self.SNDPitch, 1, CHAN_ITEM)
			-- Shoot with chance
			if math.random(1, 6) == 4 and self.ClipSize > 0 and not self.IsFirstTimeUsed then
				self:Shoot()
				DropEntityIfHeld(self)
				local EjectAttachment = self:GetAttachment(self:LookupAttachment("heatsink_eject" or 2))
				local EffJam = EffectData()
				EffJam:SetOrigin(EjectAttachment.Pos)
				EffJam:SetAngles(EjectAttachment.Ang)
				EffJam:SetScale(.1)
				EffJam:SetMagnitude(2)
				util.Effect("ElectricSpark", EffJam)
			end
		elseif Type == "electric" then
			local DMG = DamageInfo()
			DMG:SetDamage(math.random(4, 8))
			DMG:SetAttacker(ply or self or game.GetWorld())
			DMG:SetInflictor(self)
			DMG:SetDamageType(DMG_SHOCK)
			ply:TakeDamageInfo(DMG)
			ply:EmitSound(Sound("Breakable.Spark"), 55, self.SNDPitch, 1, CHAN_ITEM)
			JMod.DamageSpark(self)
			if self.RecoilHeat <= 3 then
				self.RecoilHeat = self.RecoilHeat + 1
			end

			timer.Simple(
				.1,
				function()
					if not self:IsValid() then return end
					DropEntityIfHeld(self)
					NextUse = CurTime() + 2
					self:EmitSound(Sound("snd_jack_denied.wav"), 75, 85, 1, CHAN_VOICE)
				end
			)

			self.IsFirstTimeUsed = true
		end
	end

	-- Taken from JMod
	function ENT:UserIsAuthorized(ply)
		if not IsValid(ply) then return false end
		if not ply:IsPlayer() then return false end
		if self.EZowner and (ply == self.EZowner) then return true end
		local Allies = (self.EZowner and self.EZowner.JModFriends) or {}
		if table.HasValue(Allies, ply) then return true end
		if not (engine.ActiveGamemode() == "sandbox" and ply:Team() == TEAM_UNASSIGNED) then
			local OurTeam = nil
			if IsValid(self.EZowner) then
				OurTeam = self.EZowner:Team()
			end

			return (OurTeam and ply:Team() == OurTeam) or false
		end

		return false
	end

	local function PoshliVseNaher(ent, ply)
		if not (ent or ply or ent.SWEP) then
			MOS.Print("Poshel ti naher kozel")

			return
		end

		local Alt = ply:KeyDown(JMod.Config.General.AltFunctionKey)
		local SWEP = ent.SWEP
		if not SWEP then return end
		if Alt then
			if not ply:HasWeapon(ent.SWEP) then
				ply:PickupObject(ent)
				ply:Give(SWEP)
				ply:GetWeapon(SWEP):SetClip1(ent.ClipSize or 0)
				ent:Remove()
				ply:SelectWeapon(SWEP)
			else
				ply:SelectWeapon(SWEP)
				ply:PickupObject(ent)
			end
		end
	end

	local dev = GetConVar("developer")
	local oldholdtype
	function ENT:Use(ply, caller)
		if CurTime() < NextUse then return end
		if not self:IsPlayerHolding() then
			local Vec = ply:GetAimVector()
			self:SetPos(ply:GetShootPos() + Vec * 30)
			ply:PickupObject(self)
		end

		if self.IsFirstTimeUsed then
			self:SetSequence("idle")
			self:EmitSound(Sound("jids/snd_jack_sniperturretcycle.wav"), 70, self.SNDPitch)
		end

		local Owner = JMod.GetEZowner(self)
		--[[if not IsValid(Owner) or not Owner:IsPlayer() or Owner == nil then
			-- JMod.SetEZowner(self, ply)

			return
		end]]
		RPM = CurTime() + .6
		if IsValid(Owner) then
			oldholdtype = Owner:GetActiveWeapon():IsValid() and Owner:GetActiveWeapon():GetHoldType()
		end

		if self.MannCorp then
			if not (self:UserIsAuthorized(ply) or IsValid(Owner)) then
				self:Jam("electric", ply)
			elseif self:UserIsAuthorized(ply) then
				if self.IsFirstTimeUsed then
					self:EmitSound(Sound("snd_jack_granted.wav"), 75, 85, 1, CHAN_VOICE)
					NextUse = CurTime() + 1
					self.IsFirstTimeUsed = false
				end

				PoshliVseNaher(self, ply)
			end
		elseif not self.MannCorp then
			if self.IsFirstTimeUsed then
				if math.random(1, 4) == 2 then
					self:EmitSound(Sound("snd_jack_granted.wav"), 75, 60, 1, CHAN_VOICE)
				end

				self.IsFirstTimeUsed = false
			end

			PoshliVseNaher(self, ply)
		end
	end

	function ENT:Think()
		if self.IsFirstTimeUsed then return end
		if self:IsOnFire() then
			self:Extinguish()
		end

		local Owner = JMod.GetEZowner(self)
		if not IsValid(Owner) or not Owner:IsPlayer() or Owner == nil then return end
		local Time = CurTime()
		local IsGrabbing = self:IsPlayerHolding() or (Owner:GetActiveWeapon():IsValid() and Owner:GetActiveWeapon():GetClass() == "wep_jack_gmod_hands" and Owner:GetActiveWeapon().CarryEnt == self)
		self:SetNWBool("MOS-IsHolding", IsGrabbing)
		if not IsGrabbing then
			oldholdtype = Owner:GetActiveWeapon():IsValid() and Owner:GetActiveWeapon():GetHoldType()
		end

		if not self:IsInWorld() then
			local Vec = Owner:GetAimVector()
			self:SetPos(Owner:GetShootPos() + Vec)
		end

		if IsValid(Owner:GetActiveWeapon()) and IsGrabbing then
			Owner:GetActiveWeapon():SetHoldType(self.HoldType or "duel")
		elseif IsValid(Owner:GetActiveWeapon()) and not IsGrabbing then
			Owner:GetActiveWeapon():SetHoldType(oldholdtype or "normal")
		end

		if self.RecoilHeat >= .008 then
			self.RecoilHeat = self.RecoilHeat - .008
		end

		if self.RecoilHeat > 2.7 then
			for i = 1, self.ClipSize do
				self:Jam("shoot")
			end

			self:EmitSound(Sound("jids/snd_jack_microwavevent.wav"), 80, self.SNDPitch + 5)
		end

		if dev:GetInt() == 1 and self.RecoilHeat > .1 and IsGrabbing then
			MOS.Print(self.PrintName .. " Heat: " .. tostring(math.Round(self.RecoilHeat, 2)))
		end

		if not IsGrabbing then return end
		-- Shoot
		if RPM < Time and IsGrabbing and Owner:KeyDown(IN_ALT1 + IN_ALT2) and not self.Reloading then
			local rate = self.RPM
			if self.ClipSize > 0 then
				self:Shoot()
				RPM = Time + rate
			else
				self:EmitSound(self.EmptySound or Sound("weapons/clipempty_pistol.wav"), 60, math.random(85, 95), 1, CHAN_WEAPON)
				RPM = Time + .35
			end
		end

		-- Debug
		if dev:GetInt() >= 2 and RPM > Time and IsGrabbing then
			MOS.Print(self.PrintName .. " RPM: " .. tostring(math.Round(RPM - Time, 2)))
		end

		-- Reload
		if self.AllowReload and IsGrabbing and Owner:KeyDown(IN_RELOAD) and self.ClipSize < self.MaxClip and RPM < Time and not self.Reloading then
			self:Reload()
		end

		-- Water Jam
		if self:WaterLevel() >= 1 then
			self:Jam("electric", Owner)
		end

		self:NextThink(CurTime() + .01)

		return true
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)
		if dmginfo:GetDamage() >= 6 then
			self:Jam("shoot")
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		if data.DeltaTime > .3 and data.Speed >= 200 then
			local Snd = self.ImpactSound or Sound("physics/metal/weapon_impact_hard" .. math.random(1, 3) .. ".wav")
			self:EmitSound(Snd, 55, math.random(95, 105), 1, CHAN_ITEM)
			-- Shoot with chance
			if data.Speed >= 600 then
				self:Jam("shoot")
			end
		end
	end
else
	function ENT:Think()
		-- Dynamic Holo Light
		local r, g, b = self.MannCorp and 0 or 190, self.MannCorp and 165 or 0, self.MannCorp and 255 or 0 -- funi
		if self:GetNWBool("MOS-IsHolding", false) then
			local HoloLight1 = DynamicLight(self:EntIndex())
			if HoloLight1 then
				HoloLight1.pos = self:GetPos()
				HoloLight1.r = r
				HoloLight1.g = g
				HoloLight1.b = b
				HoloLight1.brightness = 1
				HoloLight1.size = 128
				HoloLight1.decay = CurTime() + .5
				HoloLight1.dietime = CurTime() + .5
				HoloLight1.style = 12
			end
		elseif not self:GetNWBool("MOS-IsHolding", false) and self.Light then
			local HoloLight2 = DynamicLight(self:EntIndex())
			if HoloLight2 then
				HoloLight2.pos = self:GetPos()
				HoloLight2.r = r
				HoloLight2.g = g
				HoloLight2.b = b
				HoloLight2.brightness = 1
				HoloLight2.size = 64
				HoloLight2.decay = CurTime() + .5
				HoloLight2.dietime = CurTime() + .5
				HoloLight2.style = 12
			end
		end
	end

	function ENT:DrawHUD()
		local Attachment = self:GetAttachment(self:LookupAttachment(self.Attachment or "muzzle_flash" or 1))
		if not Attachment then return end
		local shootOrigin = Attachment.Pos
		local dist = (LocalPlayer():GetPos() - self:GetPos()):Length() - 50
		if dist > 255 then return end
		local ledcolor = self.MannCorp and Color(0, 165, 255, math.Remap(dist, 0, 255, 255, 0) - math.random(50, 100)) or Color(190, 0, 0, math.Remap(dist, 0, 255, 255, 0) - math.random(50, 100))
		local ledcolor2 = self.MannCorp and Color(0, 100, 150, math.Remap(dist, 0, 80, 80, 0) - math.random(15, 30)) or Color(160, 0, 0, math.Remap(dist, 0, 80, 80, 0) - math.random(15, 30))
		local TargetPos = shootOrigin + (self:GetRight() * -10)
		local FixAngles = self:GetAngles()
		local FixRotation = self.HudAngle or Vector(90, -90, 0)
		FixAngles:RotateAroundAxis(FixAngles:Right(), FixRotation.x)
		FixAngles:RotateAroundAxis(FixAngles:Up(), FixRotation.y)
		FixAngles:RotateAroundAxis(FixAngles:Forward(), FixRotation.z)
		local Clip = self:GetNWInt("MOS-ClipSize", self.ClipSize)
		local MaxClip = self.MaxClip
		local leftdist = -30 + (self.HudAddRight or 0)
		local updist1 = -25 + (self.HudAddUp1 or 0)
		local updist2 = 20 + (self.HudAddUp2 or 0)
		cam.Start3D2D(TargetPos, FixAngles, .065)
		draw.RoundedBox(14, leftdist - 100, updist1 - 25, 200, 100, ledcolor2)
		draw.SimpleText(self.PrintName, "MOS-HoloFontBlur", leftdist or 0, updist1, ledcolor, 1, 1)
		draw.SimpleText(Clip .. " / " .. MaxClip, "MOS-HoloFontBlur", leftdist, updist2, ledcolor, 1, 1)
		draw.SimpleText(self.PrintName, "MOS-HoloFont", leftdist, updist1, ledcolor, 1, 1)
		draw.SimpleText(Clip .. " / " .. MaxClip, "MOS-HoloFont", leftdist, updist2, ledcolor, 1, 1)
		cam.End3D2D()
	end

	local dev = GetConVar("developer")
	local devvector = Vector(.5, .5, .5)
	local devtime = 0
	function ENT:Draw()
		self:DrawModel()
		if not self:GetNWBool("MOS-IsHolding", false) then return end
		self:DrawHUD()
		if dev:GetInt() <= 0 or CurTime() < devtime or LocalPlayer():GetPos():DistToSqr(self:GetPos()) >= 40000 then return end
		local Attachment = self:GetAttachment(self:LookupAttachment(self.Attachment))
		debugoverlay.Box(Attachment.Pos, devvector, -devvector, .051, color_white)
		debugoverlay.Text(Attachment.Pos, "Att: " .. self.Attachment, .051, false)
		devtime = CurTime() + .05
	end

	language.Add("ent_mann_mos_gun_base", "MOS Gun Base")
end

if SERVER then
	MOS.Print(ENT.PrintName .. " Initialized!")
end