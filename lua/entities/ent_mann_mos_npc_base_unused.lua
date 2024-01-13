-- Mannytko 2024
if SERVER then
	AddCSLuaFile()
end

-- I'm too lazy to complete this
-- UPD 04.01.2024 - It's completely useless now, since ZBase by Zippy is out, and i'll be making npcs based on it. i'll leave it here for future developments.
ENT.Base = "base_nextbot"
ENT.PrintName = "MOS NPC Base"
ENT.Category = "M.A.N.N. Offense Solutions - NPCs"
ENT.Author = "Mannytko"
ENT.Spawnable = false
ENT.SoundCD = 5
ENT.Panic = false
local models = {}
for i = 1, 9 do
	table.insert(models, "models/Humans/Group01/Male_0" .. i .. ".mdl")
end

local panicvoice = {"vo/npc/male01/help01.wav", "vo/npc/male01/runforyourlife01.wav", "vo/npc/male01/runforyourlife02.wav", "vo/npc/male01/runforyourlife03.wav", "vo/npc/male01/watchout.wav", "vo/npc/male01/gethellout.wav", "vo/npc/male01/headsup01.wav", "vo/npc/male01/headsup02.wav", "vo/npc/male01/thehacks01.wav", "vo/npc/male01/no01.wav", "vo/npc/male01/no02.wav", "vo/npc/male01/strider_run.wav"}
function ENT:Initialize()
	if CLIENT or self:Health() >= 1 then return end
	self:SetModel(table.Random(models))
	for _, bg in ipairs(self:GetBodyGroups()) do
		self:SetBodygroup(bg.id, math.random(0, bg.num))
	end

	self:SetHealth(100)
	self:SetCollisionBounds(Vector(-6, -6, 0), Vector(6, 6, 64))
	self.HullType = HULL_HUMAN
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	self.lastZPosition = self:GetPos().z
end

function ENT:RunBehaviour()
	while true do
		if self.Panic then
			self:StartActivity(ACT_RUN_PANICKED or 2053)
			self.loco:SetDesiredSpeed(300)
		else
			self:StartActivity(ACT_WALK or 6)
			self.loco:SetDesiredSpeed(100)
		end

		self.loco:SetStepHeight(35)
		self.loco:SetDeceleration(100)
		self.loco:SetAvoidAllowed(true)
		self.loco:SetDeathDropHeight(100)
		self.loco:SetJumpHeight(200)
		self.loco:SetGravity(700)
		self.loco:SetJumpGapsAllowed(true)
		local targetPos = self:GetPos() + Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0) * 5000
		local area = navmesh.GetNearestNavArea(targetPos)
		if IsValid(area) then
			targetPos = area:GetClosestPointOnArea(targetPos)
		end

		if targetPos then
			self:MoveToPos(targetPos)
		end

		if self.Panic then
			local pos = self:FindSpot(
				"random",
				{
					type = "hiding",
					radius = 5000
				}
			)

			if pos then
				-- self:PlayScene("scenes/npc/male01/watchout.vcd")
				self:MoveToPos(pos)
				self:PlaySequenceAndWait("fear_reaction")
				self:StartActivity(ACT_CROUCH_PANICKED or 2055)
			end
		end

		coroutine.yield()
	end
end

function ENT:Think()
	if CLIENT then return end
	local currentZPosition = self:GetPos().z
	local fallHeight = self.lastZPosition - currentZPosition
	if self:IsOnGround() then
		self.lastZPosition = currentZPosition
		if fallHeight > 300 then
			local damageAmount = fallHeight / 5
			self:StopSound("vo/npc/male01/no02.wav")
			self:EmitSound("player/pl_fallpain3.wav", 80, math.random(95, 110))
			self:TakeDamage(damageAmount, game.GetWorld())
		end
	else
		if fallHeight > 450 and self.SoundCD < CurTime() then
			self:EmitSound("vo/npc/male01/no02.wav", 120, math.random(100, 110))
			self.SoundCD = CurTime() + 5
			self:StartActivity(ACT_JUMP or 30)
		end
	end

	if timer.TimeLeft("imms_torgash_idlesounddelay" .. self:EntIndex()) == nil and self.SoundCD < CurTime() then
		self.SoundCD = CurTime() + 1
		if self.Panic then
			self:EmitSound(table.Random(panicvoice), 100, math.random(95, 105))
		else
			self:EmitSound("ambient/voices/cough" .. math.random(1, 4) .. ".wav", 75, math.random(95, 105))
		end

		timer.Create("imms_torgash_idlesounddelay" .. self:EntIndex(), math.random(15, 30), 1, function() end)
	end
end

function ENT:OnInjured()
	if CLIENT or self.SoundCD > CurTime() then return end
	self.SoundCD = CurTime() + 1
	self:EmitSound("vo/npc/male01/pain0" .. math.random(1, 9) .. ".wav", 90, math.random(95, 105))
	if not self.Panic then
		self:StartActivity(ACT_RUN_PANICKED or 2053)
		self.loco:SetDesiredSpeed(300)
		self.Panic = true
		timer.Simple(
			math.random(25, 45),
			function()
				if not IsValid(self) then return end
				self.Panic = false
			end
		)
	end
end

function ENT:Use()
	if self.SoundCD < CurTime() and not self.Panic then
		self.SoundCD = CurTime() + 5
		--self:EmitSound("vo/npc/male01/answer" .. math.random(10, 40) .. ".wav", 80, math.random(95, 105))
		self:PlayScene("scenes/npc/male01/answer" .. math.random(10, 40) .. ".vcd")
	end
end

function ENT:OnStuck()
	self.loco:Jump()
	timer.Simple(
		.3,
		function()
			if not IsValid(self) then return end
			self:StartActivity(ACT_JUMP or 30)
			self.loco:SetVelocity(self:GetForward() * 200 + Vector(0, 0, 100))
			self:EmitSound("npc/footsteps/hardboot_generic4.wav", 80, math.random(95, 110))
		end
	)
end

function ENT:OnUnStuck()
	timer.Simple(
		1,
		function()
			if not IsValid(self) then return end
			self:StartActivity(self.Panic and ACT_RUN_PANICKED or ACT_WALK)
			self:EmitSound("npc/footsteps/hardboot_generic1.wav", 80, math.random(95, 110))
		end
	)
end

if CLIENT then
	language.Add("ent_mann_mos_npc_base", "MOS NPC Base")
end