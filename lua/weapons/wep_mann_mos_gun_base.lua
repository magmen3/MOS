-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

-- M.A.N.N. Offense Solutions SWEP gun base
SWEP.Base = "weapon_zbase"
--------------------------------------------------
SWEP.Category = "M.A.N.N. Offense Solutions - Weapons"
SWEP.PrintName = "MOS Gun Base"
SWEP.Author = "M.A.N.N. Industries"
SWEP.DrawWeaponInfoBox = true
SWEP.Spawnable = false
--------------------------------------------------
SWEP.ViewModel = Model("models/weapons/v_cod4_g36.mdl")
SWEP.WorldModel = Model("models/mos/weapons/assault_rifles/argus.mdl")
SWEP.SwayScale = 2
SWEP.BobScale = 1
SWEP.ViewModelFOV = 60
SWEP.Slot = 2 -- 1 for handguns, 2 for rifles
SWEP.SlotPos = 1
SWEP.EnableSway = true
--------------------------------------------------
SWEP.IsZBaseWeapon = true
SWEP.NPCSpawnable = true -- Add to NPC weapon list
SWEP.Primary.Automatic = true
--------------------------------------------------
-- https://wiki.facepunch.com/gmod/Hold_Types
SWEP.HoldType = "ar2"
SWEP.RunHoldType = "passive"
--------------------------------------------------
-- NPC Stuff
SWEP.NPCHoldType = "ar2"
SWEP.NPCOnly = false -- Should only NPCs be able to use this weapon?
SWEP.NPCCanPickUp = true -- Can NPCs pick up this weapon from the ground
SWEP.NPCBurstMin = 1 -- Minimum amount of bullets the NPC can fire when firing a burst
SWEP.NPCBurstMax = 1 -- Maximum amount of bullets the NPC can fire when firing a burst
SWEP.PrimaryDamage = 8 -- Damage of weapon when NPC equips it
SWEP.NPCFireRate = .1 -- Shoot delay in seconds
SWEP.NPCFireRestTimeMin = .03 -- Minimum amount of time the NPC rests between bursts in seconds
SWEP.NPCFireRestTimeMax = .13 -- Maximum amount of time the NPC rests between bursts in seconds
SWEP.NPCBulletSpreadMult = .8 -- Higher number = worse accuracy
SWEP.NPCReloadSound = Sound("jids/snd_jack_icereload.wav") -- Sound when the NPC reloads the gun
SWEP.NPCShootDistanceMult = 1 -- Multiply the NPCs shoot distance by this number with this weapon
--------------------------------------------------
-- Basic primary attack stuff
SWEP.Recoil = 5
SWEP.RPM = 6 / 60
SWEP.Primary.Damage = 30 -- Damage of weapon when player equips it
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
SWEP.PrimaryShootSound = Sound("jids/snd_jack_iceshot.wav")
SWEP.EmptySound = Sound("weapons/clipempty_rifle.wav")
SWEP.PrimarySpread = .04
SWEP.Primary.Ammo = "AR2" -- https://wiki.facepunch.com/gmod/Default_Ammo_Types
SWEP.Primary.ShellEject = "heatsink_eject" -- Set to the name of an attachment to enable shell ejection
-- 1 - Regular muzzleflash
-- 5 - Combine muzzleflash
-- 7 - Regular muzzle but bigger
SWEP.Primary.MuzzleFlashFlags = 5
SWEP.Primary.MuzzleFlash = true -- Should it have a muzzleflash?
SWEP.Primary.TracerName = "AR2Tracer"
--------------------------------------------------
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
----------------------------------
SWEP.ENT = "ent_mann_mos_gun_base"
SWEP.UseSequences = false
SWEP.ReloadTime = 2
SWEP.DrawAnim = "draw1"
SWEP.ShootAnim = "shoot1"
SWEP.ReloadAnim = "reload_full"
SWEP.SprintVMDownAmt = 4
SWEP.ShowReloadAnim = true
SWEP.ReloadAnimRate = 1
--------------------------------------------------
SWEP.VElements = {}
SWEP.WElements = {}
SWEP.ViewModelBoneMods = {}
SWEP.RecoilHeat = 0
SWEP.MannCorp = true -- Sets holo light color to blue if true, also affects SNDPitch
SWEP.SNDPitch = math.random(95, 105) -- Affects interface sounds, fire sound, etc.
SWEP.RecoilHeatMul = 1
SWEP.EZdroppable = true
SWEP.Pwner = nil
SWEP.VMRecoilMul = 1 -- Multiply viewmodel recoil
SWEP.VMUp = 0 -- Up angle offset for viewmodel
SWEP.Light = true -- Enable holo light
--------------------------------------------------
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetReady(true)
	self:SetReloading(false)
	if self:GetOwner():IsPlayer() then
		self:SCKInitialize()
	end

	self.SNDPitch = self.MannCorp and self.SNDPitch or self.SNDPitch - 15
end

function SWEP:Deploy()
	self:SetSequence("idle") -- Fixes bug with worldmodels that have animations
	self.Pwner = self:GetOwner() -- self:GetOwner() returns NULL ENTITY in SWEP:OnDrop()...
end

--!! TODO
function SWEP:DrawHUD()
end

function SWEP:ViewModelDrawn()
	if not self:GetOwner():IsPlayer() then return end
	self:SCKViewModelDrawn()
end

function SWEP:CustomDrawWorldModel()
	if not self:GetOwner():IsPlayer() then return end
	self:SCKDrawWorldModel()
end

function SWEP:OnRemove()
	local Owner = self:GetOwner()
	if Owner:IsPlayer() then
		self:SCKHolster()
	end

	if IsValid(Owner) and CLIENT and Owner:IsPlayer() then
		local OwnerVM = Owner:GetViewModel()
		if IsValid(OwnerVM) then
			OwnerVM:SetMaterial("")
		end
	end

	-- ADDED :
	if CLIENT and Owner:IsPlayer() then
		-- Removes V Models
		if self.VElements and self.VElements ~= nil then
			for k, v in pairs(self.VElements) do
				local model = v.modelEnt
				if v.type == "Model" and IsValid(model) then
					model:Remove()
				end
			end
		end

		-- Removes W Models
		if self.WElements and self.WElements ~= nil then
			for k, v in pairs(self.WElements) do
				local model = v.modelEnt
				if v.type == "Model" and IsValid(model) then
					model:Remove()
				end
			end
		end
	end
end

function SWEP:Holster(wep)
	-- Not calling OnRemove to keep the models
	local Owner = self:GetOwner()
	if Owner:IsPlayer() then
		self:SCKHolster()
	end

	if IsValid(Owner) and CLIENT and Owner:IsPlayer() then
		local OwnerVM = Owner:GetViewModel()
		if IsValid(OwnerVM) then
			OwnerVM:SetMaterial("")
		end
	end

	return true
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Ready")
	self:NetworkVar("Bool", 1, "Reloading")
end

function SWEP:OnDrop()
	if CLIENT or not IsValid(self) then return end
	local Ent = ents.Create(self.ENT)
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:SetOwner(self.Pwner)
	JMod.SetEZowner(Ent, self.Pwner)
	Ent:Spawn()
	Ent:Activate()
	Ent.ClipSize = self:Clip1() or 0
	Ent:SetNWInt("MOS-ClipSize", self:Clip1() or 0)
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity() / 2)
	self:Remove()
end

function SWEP:DoVMAnimation(anim)
	if not (anim or self.UseSequences) then return end
	local Owner = self:GetOwner()
	if not Owner:IsPlayer() then return end
	local OwnerVM = Owner:GetViewModel()
	if IsValid(Owner) and IsValid(OwnerVM) then
		OwnerVM:SendViewModelMatchingSequence(OwnerVM:LookupSequence(anim))
	end
end

function SWEP:CustomShootEffects()
	local Owner = self:GetOwner()
	if Owner:IsPlayer() then
		-- Animations
		if self.UseSequences then
			self:DoVMAnimation(self.ShootAnim)
		else
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		end

		Owner:SetAnimation(PLAYER_ATTACK1)
		-- Muzzleflash
		local EffVMMuzzle = EffectData()
		local VMAtt = Owner:GetViewModel():GetAttachment(1)
		EffVMMuzzle:SetOrigin(VMAtt.Pos)
		EffVMMuzzle:SetAngles(VMAtt.Ang)
		local Muzlo = self.MannCorp and "AR2Impact" or "MuzzleEffect"
		util.Effect(Muzlo, EffVMMuzzle)
		-- Sound
		self:EmitSound(self.PrimaryShootSound, 100, self.SNDPitch, 1, CHAN_WEAPON)
		if CLIENT then
			local r, g, b = 220, 100, 50
			local MuzzleLight = DynamicLight(self:EntIndex())
			if MuzzleLight then
				MuzzleLight.pos = Owner:GetViewModel():GetPos()
				MuzzleLight.r = r
				MuzzleLight.g = g
				MuzzleLight.b = b
				MuzzleLight.brightness = 4
				MuzzleLight.size = 180
				MuzzleLight.decay = CurTime() + .3
				MuzzleLight.dietime = CurTime() + .3
				MuzzleLight.style = 0
			end
		end

		return true
	end

	if CLIENT and Owner:IsPlayer() and Owner ~= LocalPlayer() then return false end
end

function SWEP:CanPrimaryAttack()
	local Owner = self:GetOwner()
	if Owner:IsPlayer() then
		if self:GetReloading() or self:GetOwner():IsSprinting() or not self:GetReady() then return false end
	end

	if self:Clip1() <= 0 then
		self:EmitSound(self.EmptySound, 70, self.SNDPitch, 1, CHAN_AUTO)
		self:SetNextPrimaryFire(CurTime() + .3)

		return false
	end

	return true
end

local VMDownness = 0
function SWEP:OnPrimaryAttack()
	if not IsFirstTimePredicted() then return end
	local Owner = self:GetOwner()
	if not Owner:IsPlayer() then return end
	local CanAttack = self:CanPrimaryAttack()
	if CanAttack then
		local bullet = {
			Attacker = Owner,
			Inflictor = self,
			Damage = self.Primary.Damage or self.PrimaryDamage,
			AmmoType = self.Primary.Ammo,
			Src = Owner:GetShootPos(),
			Dir = Owner:GetAimVector(),
			Spread = Vector(self.PrimarySpread, self.PrimarySpread) * (Owner:OnGround() and 1 or 2),
			Tracer = self.Primary.TracerChance,
			TracerName = self.Primary.TracerName,
			Num = self.Primary.NumShots
		}

		self:FireBullets(bullet)
		if self.Primary.TakeAmmoPerShot > 0 then
			self:TakePrimaryAmmo(self.Primary.TakeAmmoPerShot)
		end

		if self.RecoilHeat >= 2 then
			self:SetNextPrimaryFire(CurTime() + self.RPM + 1)
		end

		if self.RecoilHeat <= 3 then
			self.RecoilHeat = self.RecoilHeat + .15 * (self.RecoilHeatMul or 1)
		end

		local FTSV = FrameTime()
		local VMRecoil = (-self.Recoil - (self.RecoilHeat / 2)) * (self.VMRecoilMul or 1) * (Owner:Ping() <= 30 and 2 or .8)
		VMDownness = Lerp(FTSV * 2, VMDownness, VMRecoil)
		local RecoilAng = (AngleRand(-self.Recoil / 7, self.Recoil / 7) + Angle(-self.RecoilHeat, 0, 0)) * (Owner:OnGround() and 1 or 4)
		Owner:ViewPunch(RecoilAng)
		self:ShootEffects()
		self:SetNextPrimaryFire(CurTime() + self.RPM)
	end
end

local NextThink = 0
function SWEP:CustomThink()
	local Owner = self:GetOwner()
	if not (IsValid(Owner) or Owner:IsPlayer()) then return end
	if self.RecoilHeat >= .01 then
		self.RecoilHeat = self.RecoilHeat - .01
	end

	if CLIENT and self.Light then
		local r, g, b = self.MannCorp and 0 or 190, self.MannCorp and 165 or 0, self.MannCorp and 255 or 0 -- funi
		local HoloLight = DynamicLight(self:EntIndex())
		if HoloLight then
			HoloLight.pos = Owner:GetViewModel():GetPos()
			HoloLight.r = r
			HoloLight.g = g
			HoloLight.b = b
			HoloLight.brightness = 1
			HoloLight.size = 120
			HoloLight.decay = CurTime() + .5
			HoloLight.dietime = CurTime() + .5
			HoloLight.style = 12
		end
	end

	if NextThink > CurTime() then return end
	local NotReady = Owner:IsSprinting() or Owner:KeyDown(IN_ZOOM)
	self:SetHoldType(NotReady and self.RunHoldType or self.HoldType)
	NextThink = CurTime() + .5
end

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end
	local Owner = self:GetOwner()
	if not Owner:IsPlayer() then return end
	if not (IsValid(self) and IsValid(Owner)) then return end
	if not self:GetReady() or self:GetReloading() then return end
	if (self:Clip1() < self.Primary.ClipSize) and (Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self:SetReady(false)
		self:SetReloading(true)
		Owner:SetAnimation(PLAYER_RELOAD)
		if self.UseSequences then
			self:DoVMAnimation(self.ReloadAnim)
		else
			self:SendWeaponAnim(ACT_VM_RELOAD)
		end

		Owner:GetViewModel():SetPlaybackRate(self.ReloadAnimRate)
		self:SetSequence("idle") -- Fixes bug with worldmodels that have animations
		self:EmitSound(self.NPCReloadSound, 65, self.SNDPitch, 1, CHAN_ITEM)
		timer.Simple(
			self.ReloadTime,
			function()
				if not (IsValid(self) and IsValid(Owner)) or Owner:GetActiveWeapon():GetClass() ~= self:GetClass() then
					self:SetReady(true)
					self:SetReloading(false)

					return
				end

				if self.RecoilHeat >= 0 then
					self.RecoilHeat = 0
				end

				self:SetReady(true)
				self:SetReloading(false)
				local Missing, Have = self.Primary.ClipSize - self:Clip1(), Owner:GetAmmoCount(self.Primary.Ammo)
				if Missing <= Have then
					Owner:RemoveAmmo(Missing, self.Primary.Ammo)
					self:SetClip1(self.Primary.ClipSize)
				elseif Missing > Have then
					self:SetClip1(self:Clip1() + Have)
					Owner:RemoveAmmo(Have, self.Primary.Ammo)
				end
			end
		)
	end
end

----------------------------------------------
function SWEP:GetViewModelPosition(pos, ang)
	local Owner = self:GetOwner()
	if not Owner:IsPlayer() then return end
	local FT = FrameTime()
	if not IsValid(Owner) then return end
	local NotReady = Owner:IsSprinting() or Owner:KeyDown(IN_ZOOM) or (not self.ShowReloadAnim and self:GetReloading())
	local DefOrigin = Owner:Crouching() and -.5 or 0
	VMDownness = Lerp(FT * 2, VMDownness, NotReady and self.SprintVMDownAmt or DefOrigin - (self.VMUp or 0))
	if not OldAng or OldAng == nil then
		OldAng = ang
	end

	if not AngDiff or AngDiff == nil then
		AngDiff = angle_zero
	end

	AngDiff = LerpAngle(FT * 2, AngDiff, ang - OldAng)
	OldAng = ang
	ang = ang - (AngDiff * (Owner:Ping() <= 30 and -4 or -3))
	ang:RotateAroundAxis(ang:Right(), -VMDownness * 5)

	return pos, ang
end

local alpha_black = Color(0, 16, 25, 65)
function SWEP:PrintWeaponInfo(x, y, alpha)
	if SERVER then return end
	if self.DrawWeaponInfoBox == false then return end
	if self.InfoMarkup == nil then
		local str
		local title_color = "<color=0, 165, 255, 255>"
		local text_color = "<color=0, 135, 220, 255>"
		str = "<font=MOS-HoloFontSmall>"
		if self.Author ~= "" then
			str = str .. title_color .. "Author:</color>\n" .. text_color .. self.Author .. "</color>\n\n"
		end

		if self.Purpose ~= "" then
			str = str .. title_color .. "Description:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n"
		end

		if self.Instructions ~= "" then
			str = str .. title_color .. "Instruction:</color>\n" .. text_color .. self.Instructions .. "</color>\n"
		end

		str = str .. "</font>"
		self.InfoMarkup = markup.Parse(str, 250)
	end

	draw.RoundedBox(5, x - 5, y - 6, 280, self.InfoMarkup:GetHeight() + 18, alpha_black)
	self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, 255)
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	if not IsValid(DrawModel) then
		DrawModel = ClientsideModel(self.WorldModel, RENDER_GROUP_OPAQUE_ENTITY)
		DrawModel:SetNoDraw(true)
	else
		DrawModel:SetModel(self.WorldModel)
		local vec = Vector(55, 55, 55)
		local ang = Vector(-48, -48, -48):Angle()
		cam.Start3D(vec, ang, 20, x, y + 35, wide, tall, 5, 4096)
		cam.IgnoreZ(true)
		render.SuppressEngineLighting(true)
		render.SetLightingOrigin(self:GetPos())
		render.ResetModelLighting(50 / 255, 50 / 255, 50 / 255)
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(255)
		render.SetModelLighting(4, 1, 1, 1)
		DrawModel:SetRenderAngles(Angle(0, RealTime() * 30 % 360, 0))
		DrawModel:DrawModel()
		DrawModel:SetRenderAngles()
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(1)
		render.SuppressEngineLighting(false)
		cam.IgnoreZ(false)
		cam.End3D()
	end

	self:PrintWeaponInfo(x + wide + 20, y + tall * .95, alpha)
end

----------------- SCK -------------------
function SWEP:SCKHolster()
	if CLIENT and IsValid(self:GetOwner()) then
		local vm = self:GetOwner():GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
end

function SWEP:SCKInitialize()
	if CLIENT then
		-- Create a new table for every weapon instance
		self.VElements = table.FullCopy(self.VElements)
		self.WElements = table.FullCopy(self.WElements)
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
		self:CreateModels(self.VElements) -- create viewmodels
		self:CreateModels(self.WElements) -- create worldmodels
		-- init view model bone build function
		if IsValid(self:GetOwner()) then
			local vm = self:GetOwner():GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end

			-- Init viewmodel visibility
			if self.ShowViewModel == nil or self.ShowViewModel then
				if IsValid(vm) then
					vm:SetColor(color_white)
				end
			else
				-- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
				vm:SetColor(Color(255, 255, 255, 1))
				-- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
				-- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
				vm:SetMaterial("Debug/hsv")
			end
		end
	end
end

if CLIENT then
	SWEP.vRenderOrder = nil
	function SWEP:SCKViewModelDrawn()
		local vm = self:GetOwner():GetViewModel()
		if not IsValid(vm) then return end
		if not self.VElements then return end
		self:UpdateBonePositions(vm)
		if not self.vRenderOrder then
			-- we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}
			for k, v in pairs(self.VElements) do
				if v.type == "Model" then
					table.insert(self.vRenderOrder, 1, k)
				elseif v.type == "Sprite" or v.type == "Quad" then
					table.insert(self.vRenderOrder, k)
				end
			end
		end

		for k, name in ipairs(self.vRenderOrder) do
			local v = self.VElements[name]
			if not v then
				self.vRenderOrder = nil
				break
			end

			if v.hide then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			if not v.bone then continue end
			local pos, ang = self:GetBoneOrientation(self.VElements, v, vm)
			if not pos then continue end
			if v.type == "Model" and IsValid(model) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix("RenderMultiply", matrix)
				if v.material == "" then
					model:SetMaterial("")
				elseif model:GetMaterial() ~= v.material then
					model:SetMaterial(v.material)
				end

				if v.skin and v.skin ~= model:GetSkin() then
					model:SetSkin(v.skin)
				end

				if v.bodygroup then
					for k, v in pairs(v.bodygroup) do
						if model:GetBodygroup(k) ~= v then
							model:SetBodygroup(k, v)
						end
					end
				end

				if v.surpresslightning then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				if v.surpresslightning then
					render.SuppressEngineLighting(false)
				end
			elseif v.type == "Sprite" and sprite then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif v.type == "Quad" and v.draw_func then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	SWEP.wRenderOrder = nil
	function SWEP:SCKDrawWorldModel()
		if self.ShowWorldModel == nil or self.ShowWorldModel then
			self:DrawModel()
		end

		if not self.WElements then return end
		if not self.wRenderOrder then
			self.wRenderOrder = {}
			for k, v in pairs(self.WElements) do
				if v.type == "Model" then
					table.insert(self.wRenderOrder, 1, k)
				elseif v.type == "Sprite" or v.type == "Quad" then
					table.insert(self.wRenderOrder, k)
				end
			end
		end

		local bone_ent
		if IsValid(self:GetOwner()) then
			bone_ent = self:GetOwner()
		else
			-- when the weapon is dropped
			bone_ent = self
		end

		for k, name in pairs(self.wRenderOrder) do
			local v = self.WElements[name]
			if not v then
				self.wRenderOrder = nil
				break
			end

			if v.hide then continue end
			local pos, ang
			if v.bone then
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent)
			else
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand")
			end

			if not pos then continue end
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			if v.type == "Model" and IsValid(model) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix("RenderMultiply", matrix)
				if v.material == "" then
					model:SetMaterial("")
				elseif model:GetMaterial() ~= v.material then
					model:SetMaterial(v.material)
				end

				if v.skin and v.skin ~= model:GetSkin() then
					model:SetSkin(v.skin)
				end

				if v.bodygroup then
					for k, v in pairs(v.bodygroup) do
						if model:GetBodygroup(k) ~= v then
							model:SetBodygroup(k, v)
						end
					end
				end

				if v.surpresslightning then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				if v.surpresslightning then
					render.SuppressEngineLighting(false)
				end
			elseif v.type == "Sprite" and sprite then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif v.type == "Quad" and v.draw_func then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	function SWEP:GetBoneOrientation(basetab, tab, ent, bone_override)
		local bone, pos, ang
		if tab.rel and tab.rel ~= "" then
			local v = basetab[tab.rel]
			if not v then return end
			-- Technically, if there exists an element with the same name as a bone
			-- you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation(basetab, v, ent)
			if not pos then return end
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		else
			bone = ent:LookupBone(bone_override or tab.bone)
			if not bone then return end
			pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
			local m = ent:GetBoneMatrix(bone)
			if m then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end

			if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and ent == self:GetOwner():GetViewModel() and self.ViewModelFlip then
				ang.r = -ang.r -- Fixes mirrored models
			end
		end

		return pos, ang
	end

	function SWEP:CreateModels(tab)
		if not tab then return end
		-- Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs(tab) do
			if v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and string.find(v.model, ".mdl") and file.Exists(v.model, "GAME") then
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if IsValid(v.modelEnt) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
			elseif v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) and file.Exists("materials/" .. v.sprite .. ".vmt", "GAME") then
				local name = v.sprite .. "-"
				local params = {
					["$basetexture"] = v.sprite
				}

				-- make sure we create a unique name based on the selected options
				local tocheck = {"nocull", "additive", "vertexalpha", "vertexcolor", "ignorez"}
				for i, j in pairs(tocheck) do
					if v[j] then
						params["$" .. j] = 1
						name = name .. "1"
					else
						name = name .. "0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
			end
		end
	end

	local allbones
	local hasGarryFixedBoneScalingYet = false
	function SWEP:UpdateBonePositions(vm)
		if self.ViewModelBoneMods then
			if not vm:GetBoneCount() then return end
			local loopthrough = self.ViewModelBoneMods
			if not hasGarryFixedBoneScalingYet then
				allbones = {}
				for i = 0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if self.ViewModelBoneMods[bonename] then
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = {
							scale = Vector(1, 1, 1),
							pos = Vector(0, 0, 0),
							angle = Angle(0, 0, 0)
						}
					end
				end

				loopthrough = allbones
			end

			for k, v in pairs(loopthrough) do
				local bone = vm:LookupBone(k)
				if not bone then continue end
				local s = Vector(v.scale.x, v.scale.y, v.scale.z)
				local p = Vector(v.pos.x, v.pos.y, v.pos.z)
				local ms = Vector(1, 1, 1)
				if not hasGarryFixedBoneScalingYet then
					local cur = vm:GetBoneParent(bone)
					while cur >= 0 do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end

				if vm:GetManipulateBoneScale(bone) ~= s then
					vm:ManipulateBoneScale(bone, s)
				end

				if vm:GetManipulateBoneAngles(bone) ~= v.angle then
					vm:ManipulateBoneAngles(bone, v.angle)
				end

				if vm:GetManipulateBonePosition(bone) ~= p then
					vm:ManipulateBonePosition(bone, p)
				end
			end
		else
			self:ResetBonePositions(vm)
		end
	end

	function SWEP:ResetBonePositions(vm)
		if not vm:GetBoneCount() then return end
		for i = 0, vm:GetBoneCount() do
			vm:ManipulateBoneScale(i, Vector(1, 1, 1))
			vm:ManipulateBoneAngles(i, Angle(0, 0, 0))
			vm:ManipulateBonePosition(i, Vector(0, 0, 0))
		end
	end
end