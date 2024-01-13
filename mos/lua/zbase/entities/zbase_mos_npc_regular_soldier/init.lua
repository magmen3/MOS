-- Mannytko 2024
local NPC = FindZBaseTable(debug.getinfo(1, 'S'))
-- Spawn with a random model from this table
-- Leave empty to use the default model for the NPC
NPC.Models = {Model("models/mos/npcs/frosty/sparbines/mos_regularsoldier.mdl")}
NPC.StartHealth = 120 -- Max health
NPC.CanPatrol = true -- Use base patrol behaviour
NPC.m_iNumGrenades = 2
NPC.m_nKickDamage = 25
NPC.m_iTacticalVariant = 1
NPC.CanSecondaryAttack = true -- Can use weapon secondary attacks
NPC.HasArmor = {
	[HITGROUP_HEAD] = true,
	[HITGROUP_CHEST] = true
}

NPC.BaseRangeAttack = true -- Use ZBase range attack system
NPC.RangeAttackFaceEnemy = false -- Should it face enemy while doing the range attack?
NPC.RangeAttackTurnSpeed = 15 -- Speed that it turns while trying to face the enemy when range attacking
NPC.RangeAttackDistance = {650, 1200} -- Distance that it initiates the range attack {min, max}
NPC.RangeAttackCooldown = {6, 14} -- Range attack cooldown {min, max}
NPC.RangeAttackSuppressEnemy = true -- If the enemy can't be seen, target the last seen position
NPC.RangeAttackAnimations = {"grenthrow"} -- Example: NPC.RangeAttackAnimations = {ACT_RANGE_ATTACK1}
NPC.RangeAttackAnimationSpeed = 1.5 -- Speed multiplier for the range attack animation
-- Time until the projectile code is ran
-- Set to false to disable the timer (if you want to use animation events instead for example)
NPC.RangeProjectile_Delay = .75
-- Attachment to spawn the projectile on 
-- If set to false the projectile will spawn from the NPCs center
NPC.RangeProjectile_Attachment = "anim_attachment_LH"
NPC.RangeProjectile_Offset = false -- Projectile spawn offset, example: {forward=50, up=25, right=0}
NPC.RangeProjectile_Speed = 1100 -- The speed of the projectile
NPC.RangeProjectile_Inaccuracy = 10 -- Inaccuracy, 0 = perfect, higher numbers = less accurate
NPC.BaseMeleeAttack = true
NPC.MeleeDamage_Delay = .5
NPC.MeleeAttackAnimations = {"melee_gunhit"}
NPC.MeleeWeaponAnimations = {"melee_gunhit"} -- Animations to use when attacking with a melee weapon
NPC.OnMeleeSound_Chance = 2
NPC.OnRangeSound_Chance = 3
-- ZBase faction
-- Can be any string, all ZBase NPCs with the same faction will be allied
-- Default factions:
-- "combine" || "ally" || "zombie" || "antlion" || "none" || "neutral"
-- "none" = not allied with anybody
-- "neutral" = allied with everybody
NPC.ZBaseStartFaction = "ally"
-- Weapon Proficiency
NPC.WeaponProficiency = WEAPON_PROFICIENCY_PERFECT -- WEAPON_PROFICIENCY_POOR || WEAPON_PROFICIENCY_AVERAGE || WEAPON_PROFICIENCY_GOOD
-- || WEAPON_PROFICIENCY_VERY_GOOD || WEAPON_PROFICIENCY_PERFECT
NPC.AlertSounds = "ZBaseMOSSoldier.Alert" -- Sounds emitted when an enemy is seen for the first time
NPC.KilledEnemySounds = "ZBaseMOSSoldier.KillEnemy" -- Sounds emitted when the NPC kills an enemy
-- Dialogue sounds
-- The NPCs will face each other as if they are talking
NPC.Dialogue_Question_Sounds = "ZBaseMOSSoldier.Question" -- Dialogue questions, emitted when the NPC starts talking to another NPC
NPC.Dialogue_Answer_Sounds = "ZBaseMOSSoldier.Answer" -- Dialogue answers, emitted when the NPC is spoken to
NPC.FollowPlayerSounds = "ZBaseMOSSoldier.Answer" -- Sounds emitted when the NPC starts following a player
NPC.UnfollowPlayerSounds = "ZBaseMOSSoldier.Answer" -- Sounds emitted when the NPC stops following a player
-- Sounds emitted when the NPC hears a potential enemy, only with this addon enabled:
-- https://steamcommunity.com/sharedfiles/filedetails/?id=3001759765
NPC.HearDangerSounds = "ZBaseMOSSoldier.HearSound"
NPC.FootStepSounds = "ZBaseMOSSoldier.Step" -- Footstep sound
NPC.DeathSounds = "ZBaseMOSSoldier.Die" -- Death sound
NPC.MuteDefaultVoice = true -- Mute all default voice sounds emitted by this NPC
NPC.ItemDrops = {
	["ent_jack_gmod_ezifakpacket"] = {
		chance = 5,
		max = 1
	},
	["ent_mann_gmod_ezplasmanade"] = {
		chance = 8,
		max = 1
	},
	["ent_mann_mos_gun_smg25"] = {
		chance = 15,
		max = 1
	},
	["ent_mann_mos_gun_hg22"] = {
		chance = 10,
		max = 1
	}
}

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
function NPC:CustomOnSoundEmitted(sndData, duration, sndVarName)
	if ShouldHaveRadioSound[sndVarName] then
		self:EmitSound("npc/metropolice/vo/on" .. math.random(1, 2) .. ".wav", 75, math.random(95, 105))
		timer.Simple(
			duration,
			function()
				if not IsValid(self) then return end
				self:EmitSound("npc/metropolice/vo/off" .. math.random(1, 4) .. ".wav", 75, math.random(95, 105))
			end
		)
	end
end

--]]==============================================================================================]]
function NPC:RangeAttackProjectile()
	local projStartPos = self:Projectile_SpawnPos()
	local proj = ents.Create("ent_mann_gmod_ezplasmanade")
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
		proj_phys:SetVelocity(self:RangeAttackProjectileVelocity() + Vector(0, 0, 200))
	end
end