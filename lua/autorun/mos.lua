-- Mannytko 2024
--------------------------------
-- M.A.N.N. Offense Solutions --
--------------------------------
hook.Add("InitPostEntity", "MOS_InitPostEntity_SPWarning", function()
	if game.SinglePlayer() then
		if CLIENT then
			Derma_Query("You are running singleplayer server.", "It is recommended to play in multiplayer so some functions works better", "I understood", function() RunConsoleCommand("disconnect") end)
		else
			print("[MOS] Error! Running on singleplayer.")
			PrintMessage(HUD_PRINTTALK, "[MOS] Error! Running on singleplayer.")
		end
	end
end)

MOS = MOS or {}
function MOS.Print(output, color)
	if not (output or color) then return end
	local defcolor = Color(0, 200, 0)
	MsgC(color or defcolor, "[MOS] " .. output .. "\n")
end

local SwayMode = CreateConVar("MOS_SwayMode", 1, FCVAR_ARCHIVE, "MOS Weapons sway mode (0 = disable, 1 = only MOS weapons, 2 = enable sway for all weapons)", 0, 2)
CreateConVar("MOS_DamageMul", 1, FCVAR_ARCHIVE, "MOS Weapons damage multiplier", .01, 1000)
if SERVER then
	MOS.Print("M.A.N.N. Offense Solutions Initialized!")
else
	system.FlashWindow()
	-- Fonts --
	local function CreateFonts()
		-- Holo Font
		surface.CreateFont("MOS-HoloFont", {
			font = "Arial",
			size = 46,
			weight = 500,
			blursize = 0,
			scanlines = 3,
			antialias = false,
			outline = true
		})

		-- Holo Font Blur
		surface.CreateFont("MOS-HoloFontBlur", {
			font = "Arial",
			size = 46,
			weight = 450,
			blursize = 6,
			antialias = false,
			scanlines = 3
		})

		-- Holo Font Small
		surface.CreateFont("MOS-HoloFontSmall", {
			font = "Arial",
			size = 24,
			weight = 500,
			blursize = 0,
			scanlines = 3,
			antialias = false,
			outline = true
		})
	end

	CreateFonts()
	-- Circle
	function Circle(x, y, radius, seg)
		local cir = {}
		table.insert(cir, {
			x = x,
			y = y,
			u = .5,
			v = .5
		})

		for i = 0, seg do
			local a = math.rad((i / seg) * -360)
			table.insert(cir, {
				x = x + math.sin(a) * radius,
				y = y + math.cos(a) * radius,
				u = math.sin(a) / 2 + .5,
				v = math.cos(a) / 2 + .5
			})
		end

		local a = math.rad(0) -- This is needed for non absolute segment counts
		table.insert(cir, {
			x = x + math.sin(a) * radius,
			y = y + math.cos(a) * radius,
			u = math.sin(a) / 2 + .5,
			v = math.cos(a) / 2 + .5
		})

		surface.DrawPoly(cir)
	end
end

-- Spawnmenu Icons
list.Set("ContentCategoryIcons", "M.A.N.N. Offense Solutions - Firearms", "mos_icon_firearms32.png")
list.Set("ContentCategoryIcons", "M.A.N.N. Offense Solutions - Weapons", "mos_icon_firearms32.png")
list.Set("ContentCategoryIcons", "M.A.N.N. Offense Solutions - NPC Weapons", "mos_icon_firearms32.png")
list.Set("ContentCategoryIcons", "M.A.N.N. Offense Solutions - Hacked Firearms", "mos_icon_firearms_hacked32.png")
list.Set("ContentCategoryIcons", "M.A.N.N. Offense Solutions - Melees", "mos_icon_melees32.png")
hook.Add("Initialize", "ZBaseMOSInit", function() if ZBaseInstalled then ZBaseSetCategoryIcon("M.A.N.N. Offense Solutions - NPCs", "mos_icon_npcs32.png") end end)
-- Playermodels
-- Easier playermodel creation
function MOS.CreatePM(name, pmodel, hmodel, manncorp)
	if not (name or pmodel or hmodel) then
		MOS.Print("Error! Calling MOS.CreatePM without one of args!")
		return
	end

	manncorp = manncorp or true
	local MOSPMName = manncorp and "M.A.N.N. " .. name or name
	player_manager.AddValidModel(MOSPMName, pmodel, hmodel)
	player_manager.AddValidHands(MOSPMName, hmodel, 0, "00000000")
	list.Set("PlayerOptionsAnimations", MOSPMName, {"idle_passive", "idle_ar2", "menu_combine"})
	if SERVER then MOS.Print("Loading playermodel: " .. MOSPMName) end
end

-- Rebel Soldier --
-- format: multiline
MOS.CreatePM(
	"Rebel Soldier", 
	"models/mos/npcs/frosty/sparbine_players/mos_rebelsoldier_pm.mdl", 
	"models/mos/npcs/frosty/sparbine_players/hands/c_arms_mos_rebelsoldier.mdl", 
	false
)

-- Regular Soldier --
-- format: multiline
MOS.CreatePM(
	"Regular Soldier", 
	"models/mos/npcs/frosty/sparbine_players/mos_regularsoldier_pm.mdl", 
	"models/mos/npcs/frosty/sparbine_players/hands/c_arms_mos_regularsoldier.mdl"
)

-- Security Officer --
-- format: multiline
MOS.CreatePM(
	"Security Officer", 
	"models/mos/npcs/frosty/sparbine_players/mos_security_pm.mdl", 
	"models/mos/npcs/frosty/sparbine_players/hands/c_arms_mos_security.mdl"
)

-- Hooks
hook.Add("PlayerDeathSound", "MOS_PlayerDeath", function(ply)
	local mdl = ply:GetModel()
	if mdl == nil then return end
	if mdl == "models/mos/npcs/frosty/sparbine_players/mos_regularsoldier_pm.mdl" or mdl == "models/mos/npcs/frosty/sparbine_players/mos_security_pm.mdl" then
		ply:EmitSound("mann/flatshoot/death.wav", 80, math.random(90, 95))
		return true
	end
	return false
end)

-- Sway
if CLIENT then
	local SwayBlacklist = {
		["weapon_physgun"] = true,
		["gmod_tool"] = true,
		["gmod_camera"] = true,
		["weapon_vj_npccontroller"] = true,
		["drgbase_possessor"] = true,
		["swep_construction_kit"] = true,
		["laserpointer"] = true,
		["remotecontroller"] = true
	}

	local WDir = VectorRand()
	hook.Add("CreateMove", "MOS_CreateMove_Sway", function(cmd)
		local Ply = LocalPlayer()
		if not Ply:Alive() or SwayMode:GetInt() == 0 then return end
		local Wep = Ply:GetActiveWeapon()
		if (SwayMode:GetInt() == 1 and IsValid(Wep) and Wep.EnableSway) or SwayMode:GetInt() == 2 then
			if Wep ~= NULL and Wep.GetState and (Wep:GetState() == ArcCW.STATE_SIGHTS) then -- ArcCW compatibility
				return
			end

			if Wep ~= NULL and SwayBlacklist[Wep:GetClass()] then return end
			if Ply:GetMoveType() == MOVETYPE_NOCLIP or Ply:GetMoveType() == MOVETYPE_OBSERVER then return end
			--------------------------------------------------
			local Amt, Sporadicness, FT = 8, 40, FrameTime()
			local IsWalking = Ply:KeyDown(IN_FORWARD + IN_BACK + IN_MOVELEFT + IN_MOVERIGHT)
			if Ply:IsSprinting() and IsWalking or not Ply:OnGround() then
				Sporadicness = Sporadicness * (Ply:OnGround() and .5 or .2)
				Amt = Amt * (Ply:OnGround() and 2.2 or 4)
			end

			Sporadicness = IsWalking and Sporadicness * .5 or Sporadicness
			Amt = IsWalking and Amt * 2 or Amt
			--------------------------------------------------
			local S, EAng = .05, cmd:GetViewAngles()
			WDir = (WDir + FT * VectorRand() * Sporadicness):GetNormalized()
			EAng.pitch = math.NormalizeAngle(EAng.pitch + WDir.z * FT * Amt * S)
			EAng.yaw = math.NormalizeAngle(EAng.yaw + WDir.x * FT * Amt * S)
			cmd:SetViewAngles(EAng)
		end
	end)
end