-- Mannytko 2024
local NPC = FindZBaseTable(debug.getinfo(1, 'S'))
-- Spawn with a random model from this table
-- Leave empty to use the default model for the NPC
NPC.Models = {Model("models/mos/npcs/frosty/sparbines/mos_rebelsoldier.mdl")}
NPC.StartHealth = 110 -- Max health
NPC.CanPatrol = true -- Use base patrol behaviour
NPC.m_iNumGrenades = 2
NPC.m_nKickDamage = 20
NPC.CanSecondaryAttack = true -- Can use weapon secondary attacks
NPC.HasArmor = {
	[HITGROUP_HEAD] = true,
	[HITGROUP_CHEST] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
}

---------------------------------------
NPC.BaseRangeAttack = true -- Use ZBase range attack system
NPC.RangeAttackFaceEnemy = true -- Should it face enemy while doing the range attack?
NPC.RangeAttackTurnSpeed = 8 -- Speed that it turns while trying to face the enemy when range attacking
NPC.RangeAttackDistance = {600, 1000} -- Distance that it initiates the range attack {min, max}
NPC.RangeAttackCooldown = {6, 15} -- Range attack cooldown {min, max}
NPC.RangeAttackSuppressEnemy = true -- If the enemy can't be seen, target the last seen position
NPC.RangeAttackAnimations = {"grenthrow"} -- Example: NPC.RangeAttackAnimations = {ACT_RANGE_ATTACK1}
NPC.RangeAttackAnimationSpeed = 1.4 -- Speed multiplier for the range attack animation
-- Time until the projectile code is ran
-- Set to false to disable the timer (if you want to use animation events instead for example)
NPC.RangeProjectile_Delay = .8
-- Attachment to spawn the projectile on 
-- If set to false the projectile will spawn from the NPCs center
NPC.RangeProjectile_Attachment = "anim_attachment_LH"
NPC.RangeProjectile_Offset = false -- Projectile spawn offset, example: {forward=50, up=25, right=0}
NPC.RangeProjectile_Speed = 1300 -- The speed of the projectile
NPC.RangeProjectile_Inaccuracy = 9 -- Inaccuracy, 0 = perfect, higher numbers = less accurate
---------------------------------------
NPC.BaseMeleeAttack = true
NPC.MeleeDamage_Delay = .6
NPC.MeleeAttackAnimations = {"melee_gunhit"}
NPC.MeleeWeaponAnimations = {"melee_gunhit"} -- Animations to use when attacking with a melee weapon
---------------------------------------
NPC.OnMeleeSound_Chance = 2
NPC.OnRangeSound_Chance = 4
---------------------------------------
NPC.ZBaseStartFaction = "combine"
NPC.WeaponProficiency = WEAPON_PROFICIENCY_GOOD -- WEAPON_PROFICIENCY_POOR || WEAPON_PROFICIENCY_AVERAGE || WEAPON_PROFICIENCY_GOOD
-- || WEAPON_PROFICIENCY_VERY_GOOD || WEAPON_PROFICIENCY_PERFECT
---------------------------------------
NPC.AlertSounds = "ZBaseMOSRebelSoldier.Alert" -- Sounds emitted when an enemy is seen for the first time
NPC.KilledEnemySounds = "ZBaseMOSRebelSoldier.KillEnemy" -- Sounds emitted when the NPC kills an enemy
-- Dialogue sounds
-- The NPCs will face each other as if they are talking
NPC.Dialogue_Question_Sounds = "ZBaseMOSRebelSoldier.Question" -- Dialogue questions, emitted when the NPC starts talking to another NPC
NPC.Dialogue_Answer_Sounds = "ZBaseMOSRebelSoldier.Answer" -- Dialogue answers, emitted when the NPC is spoken to
NPC.FollowPlayerSounds = "ZBaseMOSRebelSoldier.Answer" -- Sounds emitted when the NPC starts following a player
NPC.UnfollowPlayerSounds = "ZBaseMOSRebelSoldier.Answer" -- Sounds emitted when the NPC stops following a player
-- Sounds emitted when the NPC hears a potential enemy, only with this addon enabled:
-- https://steamcommunity.com/sharedfiles/filedetails/?id=3001759765
NPC.HearDangerSounds = "ZBaseMOSRebelSoldier.HearSound"
NPC.FootStepSounds = "ZBaseMOSRebelSoldier.Step" -- Footstep sound
NPC.MuteDefaultVoice = true -- Mute all default voice sounds emitted by this NPC
---------------------------------------
NPC.CanJump = true -- Can the NPC jump?
NPC.MoveSpeedMultiplier = 1
NPC.ItemDrops = {
	["ent_jack_gmod_ezifakpacket"] = {
		chance = 5,
		max = 1
	},
	["ent_jack_gmod_ezstickynade"] = {
		chance = 8,
		max = 1
	},
	["ent_mann_mos_melee_iceaxe"] = {
		chance = 15,
		max = 1
	},
	["ent_mann_mos_gun_supp18"] = {
		chance = 10,
		max = 1
	}
}

NPC.ItemDrops_TotalMax = 1
---------------------------------------
-- Health regen
NPC.HealthRegenAmount = 0
NPC.HealthCooldown = 0.2
---------------------------------------
NPC.CanOpenDoors = true -- Can open regular doors
NPC.CanOpenAutoDoors = true -- Can open auto doors
NPC.CanUse = true -- Can push buttons, pull levers, etc
NPC.m_fMaxYawSpeed = 8 -- Max turning speed
---------------------------------------
local ShouldHaveRadioSound = {
	["LostEnemySounds"] = true,
	["OnReloadSounds"] = true,
	["Dialogue_Question_Sounds"] = true,
	["Dialogue_Answer_Sounds"] = true,
	["AlertSounds"] = true,
	["KilledEnemySounds"] = true,
	["OnGrenadeSounds"] = true
}

--]]==============================================================================================]]
function NPC:CustomInitialize()
	self:SetSkin(math.random(0, 1))
end

--]]==============================================================================================]]
function NPC:CustomOnSoundEmitted(sndData, duration, sndVarName)
	if ShouldHaveRadioSound[sndVarName] then
		self:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", 75, math.random(85, 95))
		timer.Simple(
			duration,
			function()
				if not IsValid(self) then return end
				self:EmitSound("npc/metropolice/vo/off" .. math.random(1, 4) .. ".wav", 75, math.random(85, 95))
			end
		)
	end
end

--]]==============================================================================================]]
function NPC:RangeAttackProjectile()
	local projStartPos = self:Projectile_SpawnPos()
	local proj = ents.Create("ent_jack_gmod_ezstickynade")
	proj:SetPos(projStartPos)
	proj:SetAngles(self:GetAngles())
	proj:SetPhysicsAttacker(self)
	proj:SetOwner(self)
	JMod.SetEZowner(proj, self)
	proj:Spawn()
	proj:Prime()
	proj:Arm()
	local proj_phys = proj:GetPhysicsObject()
	if IsValid(proj_phys) then
		proj_phys:SetVelocity(self:RangeAttackProjectileVelocity() + Vector(0, 0, 150))
	end
end