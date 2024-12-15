-- Mannytko 2024
SWEP.Base = "weapon_base"
--------------------------------------------------
SWEP.Category = "M.A.N.N. Offense Solutions - Weapons"
SWEP.PrintName = "Plasma Grenade"
SWEP.Author = "M.A.N.N. Industries"
--------------------------------------------------
SWEP.Spawnable = true
SWEP.ViewModel = Model("models/mos/weapons/ezplasmanade/v_xengrenade.mdl")
SWEP.WorldModel = "models/mos/weapons/halo/covenant/halo2a/weapons/plasmagrenade/plasmagrenade.mdl"
SWEP.SwayScale = 2
SWEP.BobScale = 1
SWEP.Slot = 2 -- 1 for handguns, 2 for rifles
SWEP.SlotPos = 1
SWEP.EnableSway = true
SWEP.ViewModelFOV = 60
SWEP.UseHands = true
SWEP.HoldType = "grenade"
SWEP.RunHoldType = "normal"
--------------------------------------------------
SWEP.DrawCrosshair = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
--------------------------------------------------
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
--------------------------------------------------
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
--------------------------------------------------
SWEP.ViewModelBoneMods = {
	["weapon"] = {
		scale = Vector(.009, .009, .009),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 0, 0)
	}
}

SWEP.VElements = {
	["plasmanade"] = {
		type = "Model",
		model = "models/mos/weapons/halo/covenant/halo2a/weapons/plasmagrenade/plasmagrenade.mdl",
		bone = "weapon",
		rel = "",
		pos = Vector(.805, .09, -.401),
		angle = Angle(0, 0, 0),
		size = Vector(.6, .6, .6),
		color = color_white,
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}
}

SWEP.WElements = {
	["plasmanade"] = {
		type = "Model",
		model = "models/mos/weapons/halo/covenant/halo2a/weapons/plasmagrenade/plasmagrenade.mdl",
		bone = "ValveBiped.Anim_Attachment_RH",
		rel = "",
		pos = Vector(1.643, 0, .986),
		angle = Angle(0, 0, 0),
		size = Vector(.899, .899, .899),
		color = color_white,
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	}
}

SWEP.Throwed = false
SWEP.Pwner = nil
SWEP.EZdroppable = true
SWEP.ENT = "ent_mann_gmod_ezplasmanade"
--------------------------------------------------
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	local Owner = self:GetOwner()
	if Owner:IsPlayer() then self:SCKInitialize() end
end

function SWEP:Deploy()
	if not IsFirstTimePredicted() then return end
	self:SetSequence("idle") -- Fixes bug with worldmodels that have animations
	self.Pwner = self:GetOwner() -- self:GetOwner() returns NULL ENTITY in SWEP:OnDrop()...
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:GetOwner():GetViewModel():SetPlaybackRate(.5)
	self:SetNextPrimaryFire(CurTime() + 1.4)
	timer.Simple(.3, function()
		if not (IsValid(self) or self:GetOwner():IsValid()) then return end
		self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
		self:GetOwner():GetViewModel():SetPlaybackRate(.8)
		timer.Simple(.3, function()
			if not (IsValid(self) or self:GetOwner():IsValid()) then return end
			self:EmitSound("jids/snd_jack_beginice.wav", 60, 100)
		end)
	end)
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
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity() / 2)
	self:Remove()
end

local nadeang = Angle(45, 45, 0)
function SWEP:ThrowNade()
	local Owner = self:GetOwner()
	if not (IsValid(self) or Owner:IsValid()) then return end
	if CLIENT then return end
	grenade = ents.Create("ent_mann_gmod_ezplasmanade")
	local v = Owner:GetShootPos()
	v = v + Owner:GetForward() * 10
	v = v + Owner:GetRight() * 10
	v = v + Owner:GetUp() * 10
	grenade:SetPos(v)
	grenade:SetAngles(Owner:EyeAngles() + nadeang)
	grenade:SetOwner(Owner)
	grenade:SetPhysicsAttacker(Owner)
	grenade:SetOwner(Owner)
	JMod.SetEZowner(grenade, Owner)
	grenade:Spawn()
	grenade:Arm()
	local phys = grenade:GetPhysicsObject()
	if not IsValid(phys) then
		grenade:Remove()
		return
	else
		phys:SetVelocity(Owner:GetVelocity() + Owner:GetAimVector() * 800)
		phys:AddAngleVelocity(VectorRand() * 200)
	end
end

local vpang = Angle(10, 10, 0)
function SWEP:Throw()
	local Owner = self:GetOwner()
	self:SendWeaponAnim(ACT_VM_THROW)
	Owner:GetViewModel():SetPlaybackRate(.9)
	self:EmitSound("snd_jack_grenadethrow.wav", 75, math.random(95, 105))
	Owner:SetAnimation(PLAYER_ATTACK1)
	Owner:ViewPunch(vpang)
	self:ThrowNade()
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	local Owner = self:GetOwner()
	local NotReady = Owner:IsSprinting() or Owner:KeyDown(IN_ZOOM)
	if NotReady or self.Throwed then return end
	self.Throwed = true
	self:Throw()
	Owner:SetAnimation(PLAYER_ATTACK1)
	timer.Simple(.6, function()
		if not (IsValid(self) or Owner:IsValid()) then return end
		if CLIENT then return end
		if Owner:HasWeapon("wep_jack_gmod_hands") then Owner:SelectWeapon("wep_jack_gmod_hands") end
		self:Remove()
	end)
end

function SWEP:SecondaryAttack()
	return false
end

local NextThink = 0
function SWEP:Think()
	if NextThink > CurTime() then return end
	local Owner = self:GetOwner()
	local NotReady = Owner:IsSprinting() or Owner:KeyDown(IN_ZOOM)
	self:SetHoldType(NotReady and self.RunHoldType or self.HoldType)
	NextThink = CurTime() + .5
end

----------------------------------------------
function SWEP:ViewModelDrawn()
	local Owner = self:GetOwner()
	if not Owner:IsPlayer() then return end
	self:SCKViewModelDrawn()
end

function SWEP:DrawWorldModel()
	local Owner = self:GetOwner()
	if not Owner:IsPlayer() then return end
	self:SetMaterial("engine/occlusionproxy")
	self:SCKDrawWorldModel()
end

function SWEP:OnRemove()
	local Owner = self:GetOwner()
	if Owner:IsPlayer() then self:SCKHolster() end
	if IsValid(Owner) and CLIENT and Owner:IsPlayer() then
		local OwnerVM = Owner:GetViewModel()
		if IsValid(OwnerVM) then OwnerVM:SetMaterial("") end
	end

	-- ADDED :
	if CLIENT and Owner:IsPlayer() then
		-- Removes V Models
		if self.VElements and self.VElements ~= nil then
			for k, v in pairs(self.VElements) do
				local model = v.modelEnt
				if v.type == "Model" and IsValid(model) then model:Remove() end
			end
		end

		-- Removes W Models
		if self.WElements and self.WElements ~= nil then
			for k, v in pairs(self.WElements) do
				local model = v.modelEnt
				if v.type == "Model" and IsValid(model) then model:Remove() end
			end
		end
	end
end

function SWEP:Holster(wep)
	local Owner = self:GetOwner()
	if Owner:IsPlayer() then
		self:SCKHolster() -- Not calling OnRemove to keep the models
	end

	if IsValid(Owner) and CLIENT and Owner:IsPlayer() then
		local OwnerVM = Owner:GetViewModel()
		if IsValid(OwnerVM) then OwnerVM:SetMaterial("") end
	end
	return true
end

local VMDownness = 0
function SWEP:GetViewModelPosition(pos, ang)
	local Owner = self:GetOwner()
	if not Owner:IsPlayer() then return end
	local FT = FrameTime()
	if not IsValid(Owner) then return end
	local NotReady = Owner:IsSprinting() or Owner:KeyDown(IN_ZOOM)
	local DefOrigin = Owner:Crouching() and -.5 or 0
	VMDownness = Lerp(FT * 2, VMDownness, NotReady and 4 or DefOrigin)
	if not OldAng or OldAng == nil then OldAng = ang end
	if not AngDiff or AngDiff == nil then AngDiff = angle_zero end
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
		if self.Author ~= "" then str = str .. title_color .. "Author:</color>\n" .. text_color .. self.Author .. "</color>\n\n" end
		if self.Purpose ~= "" then str = str .. title_color .. "Description:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
		if self.Instructions ~= "" then str = str .. title_color .. "Instruction:</color>\n" .. text_color .. self.Instructions .. "</color>\n" end
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
		if IsValid(vm) then self:ResetBonePositions(vm) end
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
			if IsValid(vm) then self:ResetBonePositions(vm) end
			-- Init viewmodel visibility
			if self.ShowViewModel == nil or self.ShowViewModel then
				if IsValid(vm) then vm:SetColor(color_white) end
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

				if v.skin and v.skin ~= model:GetSkin() then model:SetSkin(v.skin) end
				if v.bodygroup then
					for k, v in pairs(v.bodygroup) do
						if model:GetBodygroup(k) ~= v then model:SetBodygroup(k, v) end
					end
				end

				if v.surpresslightning then render.SuppressEngineLighting(true) end
				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				if v.surpresslightning then render.SuppressEngineLighting(false) end
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
		if self.ShowWorldModel == nil or self.ShowWorldModel then self:DrawModel() end
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

				if v.skin and v.skin ~= model:GetSkin() then model:SetSkin(v.skin) end
				if v.bodygroup then
					for k, v in pairs(v.bodygroup) do
						if model:GetBodygroup(k) ~= v then model:SetBodygroup(k, v) end
					end
				end

				if v.surpresslightning then render.SuppressEngineLighting(true) end
				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				if v.surpresslightning then render.SuppressEngineLighting(false) end
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
			if m then pos, ang = m:GetTranslation(), m:GetAngles() end
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

				if vm:GetManipulateBoneScale(bone) ~= s then vm:ManipulateBoneScale(bone, s) end
				if vm:GetManipulateBoneAngles(bone) ~= v.angle then vm:ManipulateBoneAngles(bone, v.angle) end
				if vm:GetManipulateBonePosition(bone) ~= p then vm:ManipulateBonePosition(bone, p) end
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