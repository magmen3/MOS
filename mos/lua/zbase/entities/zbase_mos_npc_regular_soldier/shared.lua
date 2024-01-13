-- Mannytko 2024
local NPC = FindZBaseTable(debug.getinfo(1, 'S'))
-- The NPC class
-- Can be any existing NPC in the game
-- If you want to make a human that can use weapons, you should probably use "npc_combine_s" or "npc_citizen" for example
-- Use "npc_zbase_snpc" if you want to create a brand new SNPC
NPC.Class = "npc_combine_s"
NPC.Name = "M.A.N.N. Regular Soldier" -- Name of your NPC
NPC.Category = "M.A.N.N. Offense Solutions - NPCs" -- Category in the ZBase tab
NPC.Weapons = {"wep_mann_mos_gun_ar55"} -- Example: {"weapon_rpg", "weapon_crowbar", "weapon_crossbow"}
NPC.Inherit = "npc_zbase" -- Inherit features from any existing zbase npc
local eyevector = Vector(0, 1, -6)
local eyecolor = Color(0, 165, 255)
-- format: multiline
ZBaseAddGlowingEye(
	"MOS_RegularSoldierEyeLight",
	"models/mos/npcs/frosty/sparbines/mos_regularsoldier.mdl",
	false,
	"b_helmet",
	eyevector,
	8,
	eyecolor
)

--]]==============================================================================================]]
-- Nasral
local function MOSCreateSoldierSounds(name, tbl)
	sound.Add(
		{
			name = name,
			channel = CHAN_VOICE,
			volume = .5,
			level = 90,
			pitch = {105, 110},
			sound = tbl
		}
	)
end

--]]==============================================================================================]]
-- format: multiline
sound.Add(
	{
		name = "ZBaseMOSSoldier.Step",
		channel = CHAN_AUTO,
		volume = .7,
		level = 80,
		pitch = {
			90,
			110
		},
		sound = {
			"player/footsteps/metal1.wav",
			"player/footsteps/metal2.wav",
			"player/footsteps/metal3.wav",
			"player/footsteps/metal4.wav"
		}
	}
)

--]]==============================================================================================]]
-- format: multiline
MOSCreateSoldierSounds(
	"ZBaseMOSSoldier.Question",
	{
		"npc/metropolice/vo/dispupdatingapb.wav",
		"npc/metropolice/vo/pickingupnoncorplexindy.wav",
		"npc/metropolice/vo/ten97suspectisgoa.wav",
		"npc/metropolice/vo/stillgetting647e.wav",
		"npc/metropolice/vo/404zone.wav",
		"npc/metropolice/vo/standardloyaltycheck.wav",
		"npc/metropolice/vo/anyonepickup647e.wav",
		"npc/metropolice/vo/blockisholdingcohesive.wav",
		"npc/metropolice/vo/checkformiscount.wav",
		"npc/metropolice/vo/catchthatbliponstabilization.wav",
		"npc/metropolice/vo/clearandcode100.wav",
		"npc/metropolice/vo/clearno647no10-107.wav",
		"npc/metropolice/vo/classifyasdbthisblockready.wav",
		"npc/metropolice/vo/control100percent.wav",
		"npc/metropolice/vo/cprequestsallunitsreportin.wav",
		"npc/metropolice/vo/dispreportssuspectincursion.wav",
		"npc/metropolice/vo/wegotadbherecancel10-102.wav",
		"npc/metropolice/vo/localcptreportstatus.wav",
		"npc/metropolice/vo/novisualonupi.wav",
		"npc/metropolice/vo/loyaltycheckfailure.wav",
	}
)

--]]==============================================================================================]]
-- format: multiline
MOSCreateSoldierSounds(
	"ZBaseMOSSoldier.Answer",
	{
		"npc/metropolice/vo/rodgerthat.wav"
	}
)

--]]==============================================================================================]]
-- format: multiline
sound.Add(
	{
		name = "ZBaseMOSSoldier.Die",
		channel = CHAN_AUTO,
		volume = .7,
		level = 80,
		pitch = {
			90,
			95
		},
		sound = {
			"mann/flatshoot/death.wav"
		}
	}
)

--]]==============================================================================================]]
-- format: multiline
MOSCreateSoldierSounds(
	"ZBaseMOSSoldier.Alert",
	{
		"npc/metropolice/vo/allunitscloseonsuspect.wav",
		"npc/metropolice/vo/allunitsmovein.wav",
		"npc/metropolice/vo/contactwith243suspect.wav",
		"npc/metropolice/vo/criminaltrespass63.wav",
		"npc/metropolice/vo/get11-44inboundcleaningup.wav",
		"npc/metropolice/vo/unlawfulentry603.wav",
		"npc/metropolice/vo/malcompliant10107my1020.wav",
		"npc/metropolice/vo/level3civilprivacyviolator.wav",
		"npc/metropolice/vo/ivegot408hereatlocation.wav",
		"npc/metropolice/vo/ihave10-30my10-20responding.wav",
		"npc/metropolice/vo/readytoprosecute.wav",
		"npc/metropolice/vo/priority2anticitizenhere.wav",
		"npc/metropolice/vo/gota10-107sendairwatch.wav",
	}
)

--]]==============================================================================================]]
-- format: multiline
MOSCreateSoldierSounds(
	"ZBaseMOSSoldier.KillEnemy",
	{
		"npc/metropolice/vo/chuckle.wav",
		"npc/metropolice/vo/suspectisbleeding.wav",
		"npc/metropolice/vo/sentencedelivered.wav",
	}
)

--]]==============================================================================================]]
-- format: multiline
MOSCreateSoldierSounds(
	"ZBaseMOSSoldier.HearSound",
	{
		"npc/metropolice/vo/requestsecondaryviscerator.wav",
		"npc/metropolice/vo/goingtotakealook.wav",
		"npc/metropolice/vo/movetoarrestpositions.wav",
		"npc/metropolice/vo/investigating10-103.wav",
		"npc/metropolice/vo/readytoamputate.wav",
		"npc/metropolice/vo/readytojudge.wav",
		"npc/metropolice/vo/preparingtojudge10-107.wav",
		"npc/metropolice/vo/prepareforjudgement.wav",
		"npc/metropolice/vo/possible10-103alerttagunits.wav",
		"npc/metropolice/vo/possible404here.wav",
		"npc/metropolice/vo/possiblelevel3civilprivacyviolator.wav",
		"npc/metropolice/vo/possible647erequestairwatch.wav",
		"npc/metropolice/vo/positiontocontain.wav",
	}
)