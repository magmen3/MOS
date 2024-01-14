-- Mannytko 2024
local NPC = FindZBaseTable(debug.getinfo(1, 'S'))
NPC.Class = "npc_zombine" -- "npc_zombine" idk how to disable grenades
NPC.Name = "Infected Scientist" -- Name of your NPC
NPC.Category = "M.A.N.N. Offense Solutions - NPCs" -- Category in the ZBase tab
NPC.Weapons = {} -- Example: {"weapon_rpg", "weapon_crowbar", "weapon_crossbow"}
NPC.Inherit = "npc_zbase" -- Inherit features from any existing zbase npc
NPC.m_iGrenadeCount = 0 -- thanks to zippy for help with grenades
--]]==============================================================================================]]
local function MOSCreateZombieSounds(name, tbl)
	sound.Add(
		{
			name = name,
			channel = CHAN_VOICE,
			volume = .7,
			level = 95,
			pitch = {85, 95},
			sound = tbl
		}
	)
end

--]]==============================================================================================]]
-- format: multiline
sound.Add(
	{
		name = "ZBaseMOSZombie.Step",
		channel = CHAN_AUTO,
		volume = .65,
		level = 80,
		pitch = {
			95,
			110
		},
		sound = {
			"mos/npcs/zombie/foot1.wav",
			"mos/npcs/zombie/foot2.wav",
			"mos/npcs/zombie/foot3.wav"
		}
	}
)

--]]==============================================================================================]]
-- format: multiline
MOSCreateZombieSounds(
	"ZBaseMOSZombie.Idle",
	{
		"mos/npcs/mos_zombie/zombie_voice_idle1.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle2.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle3.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle4.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle5.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle6.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle7.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle8.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle9.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle10.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle11.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle12.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle13.wav",
		"mos/npcs/mos_zombie/zombie_voice_idle14.wav",
	}
)

--]]==============================================================================================]]
-- format: multiline
MOSCreateZombieSounds(
	"ZBaseMOSZombie.Alert",
	{
		"mos/npcs/mos_zombie/zombie_alert1.wav",
		"mos/npcs/mos_zombie/zombie_alert2.wav",
		"mos/npcs/mos_zombie/zombie_alert3.wav",
	}
)

--]]==============================================================================================]]
-- format: multiline
MOSCreateZombieSounds(
	"ZBaseMOSZombie.Die",
	{
		"mos/npcs/mos_zombie/zombie_die1.wav",
		"mos/npcs/mos_zombie/zombie_die2.wav",
		"mos/npcs/mos_zombie/zombie_die3.wav",
	}
)

--]]==============================================================================================]]
-- format: multiline
MOSCreateZombieSounds(
	"ZBaseMOSZombie.Pain",
	{
		"mos/npcs/mos_zombie/zombie_pain1.wav",
		"mos/npcs/mos_zombie/zombie_pain2.wav",
		"mos/npcs/mos_zombie/zombie_pain3.wav",
	}
)

--]]==============================================================================================]]
-- format: multiline
MOSCreateZombieSounds(
	"ZBaseMOSZombie.Attack",
	{
		"mos/npcs/zombie/claw_miss1.wav",
		"mos/npcs/zombie/claw_miss2.wav",
		"mos/npcs/mos_zombie/zo_attack1.wav",
		"mos/npcs/mos_zombie/zo_attack2.wav",
	}
)