-- Mannytko 2024
local NPC = FindZBaseTable(debug.getinfo(1, 'S'))
NPC.Models = {Model("models/mos/npcs/zombie/zombie_soldier.mdl")}
NPC.CanPatrol = true -- Use base patrol behaviour
NPC.StartHealth = 250 -- Max health
NPC.m_iNumGrenades = 0 -- thanks to zippy for help with grenades
NPC.ZBaseStartFaction = "zombie"
---------------------------------------
NPC.AlertSounds = "ZBaseMOSZombie.Alert" -- Sounds emitted when an enemy is seen for the first time
NPC.KilledEnemySounds = "ZBaseMOSZombie.Alert" -- Sounds emitted when the NPC kills an enemy
NPC.HearDangerSounds = "ZBaseMOSZombie.Alert"
NPC.SeeDangerSounds = "ZBaseMOSZombie.Alert" -- Sounds emitted when the NPC spots a danger, such as a flaming barrel
NPC.KilledEnemySounds = "ZBaseMOSZombie.Idle" -- Sounds emitted when the NPC kills an enemy
NPC.IdleSounds = "ZBaseMOSZombie.Idle" -- Sounds emitted while there is no enemy
NPC.Idle_HasEnemy_Sounds = "ZBaseMOSZombie.Idle" -- Sounds emitted while there is an enemy
NPC.FootStepSounds = "ZBaseMOSZombie.Step" -- Footstep sound
NPC.DeathSounds = "ZBaseMOSZombie.Die" -- Death sound
NPC.PainSounds = "ZBaseMOSZombie.Pain" -- Sounds emitted on hurt
NPC.OnMeleeSounds = "ZBaseMOSZombie.Attack" -- Sounds emitted when the NPC does its melee attack
NPC.MuteDefaultVoice = true -- Mute all default voice sounds emitted by this NPC
---------------------------------------
NPC.MoveSpeedMultiplier = 2.3
NPC.CanPatrol = true -- Use base patrol behaviour
NPC.CanJump = true -- Can the NPC jump?
---------------------------------------
NPC.DamageScaling = {
	[DMG_BLAST] = 2,
	[DMG_BULLET] = .8
}

NPC.PhysDamageScale = 1.5 -- Damage scale from props
---------------------------------------
NPC.MeleeDamage = {15, 25}
NPC.MeleeWeaponAnimations = {
	"fastattack" -- Animations to use when attacking with a melee weapon
}

NPC.MeleeAttackAnimations = {"fastattack"}
---------------------------------------
-- Health regen
NPC.HealthRegenAmount = 5
NPC.HealthCooldown = 3
---------------------------------------
NPC.CanOpenDoors = true -- Can open regular doors
NPC.CanOpenAutoDoors = true -- Can open auto doors
NPC.CanUse = true -- Can push buttons, pull levers, etc
NPC.CantReachEnemyBehaviour = ZBASE_CANTREACHENEMY_HIDE -- How should it behave when it cannot reach the enemy while chasing
---------------------------------------
NPC.BloodColor = BLOOD_COLOR_ZOMBIE -- DONT_BLEED || BLOOD_COLOR_RED || BLOOD_COLOR_YELLOW || BLOOD_COLOR_GREEN
---------------------------------------
NPC.m_fMaxYawSpeed = 6 -- Max turning speed
NPC.FootStepSoundDelay_Walk = 0.4 -- Step cooldown when walking
NPC.FootStepSoundDelay_Run = 0.3 -- Step cooldown when running
--]]==============================================================================================]]
function NPC:DoMoveSpeed()
	local TimeLastMovement = self:GetInternalVariable("m_flTimeLastMovement")
	self:SetPlaybackRate(1.5)
	self:SetSaveValue("m_flTimeLastMovement", TimeLastMovement * self.MoveSpeedMultiplier)
end