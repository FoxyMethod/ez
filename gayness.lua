local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local oldGui = PlayerGui:FindFirstChild("AdminMonitorGUI")
if oldGui then oldGui:Destroy() end
local webhook = "https://discord.com/api/webhooks/1383617663594664016/qkwz2GBU4eLQ21RMijUxG1Yz_K3gNA69Co4oO0ha2b77AotMdUNcFwqIYIM9aTLlqTQp"
-- ✅ 管理員 UID 列表（你提供的）
local StaffUIDs = {
	GameMods = {
		[-1] = true,
		[1297128] = true,
		[103596431] = true,
		[47714381] = true,
		[226732872] = true,
		[1886499481] = true,
		[3647954592] = true,
		[3670612554] = true,
		[1612848084] = true,
		[53376998] = true,
		[1614613979] = true,
		[533798432] = true,
		[167187485] = true,
		[513697476] = true,
		[1492723584] = true,
		[147641903] = true,
		[24194321] = true,
		[1186291630] = true,
		[2742246599] = true
	},
	RolePlayManagers = {
		[4768026953] = true,
		[3495711743] = true,
		[488397427] = true,
		[1144296493] = true,
		[178798844] = true,
		[2053670526] = true,
		[7397047222] = true,
		[3897415364] = true,
		[263912104] = true,
		[1181153647] = true,
		[92357332] = true,
		[1794069533] = true
	}
}

local function getStaffRole(uid)
	if StaffUIDs.GameMods[uid] then return "GameMod" end
	if StaffUIDs.RolePlayManagers[uid] then return "RPManager" end
	return nil
end

local function getOnlineAdmins()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		local role = getStaffRole(p.UserId)
		if role then table.insert(list, {Name = p.Name, Role = role}) end
	end
	return list
end

local function sendToWebhook()
	local admins = getOnlineAdmins()
	local adminText = "❌ No admins online"
	if #admins > 0 then
		adminText = "🛡️ Admins Online:\n"
		for _, a in ipairs(admins) do
			adminText = adminText .. string.format("• `%s` [%s]\n", a.Name, a.Role)
		end
	end

	local data = {
		content = string.format(
			"📦 **Script Executed**\n👤 **Username:** `%s`\n🆔 **UserId:** `%d`\n👥 **Players:** `%d`\n\n%s",
			LocalPlayer.Name,
			LocalPlayer.UserId,
			#Players:GetPlayers(),
			adminText
		)
	}

	-- 🧠 Use your executor's HTTP request function (Synapse-style)
	local json = HttpService:JSONEncode(data)
	local headers = {["Content-Type"] = "application/json"}

	local requestFunc =
		http_request or
		syn and syn.request or
		request or
		fluxus and fluxus.request or
		nil

	if requestFunc then
		requestFunc({
			Url = webhook,
			Method = "POST",
			Headers = headers,
			Body = json
		})
		print("✅ logged ")
	else
		warn(" Your executor does not support")
	end
end

-- ⏳ slight delay to allow game load
task.wait(2)
sendToWebhook()
