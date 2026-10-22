local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local LogService = game:GetService("LogService")
local ScriptContext = game:GetService("ScriptContext")

local MAX_ENTRIES = 250

local logs = ServerStorage:FindFirstChild("RuntimeLogs")
if logs then
	logs:ClearAllChildren()
else
	logs = Instance.new("Folder")
	logs.Name = "RuntimeLogs"
	logs.Parent = ServerStorage
end

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local clientLog = remotes:FindFirstChild("ClientLog")
if not clientLog then
	clientLog = Instance.new("RemoteEvent")
	clientLog.Name = "ClientLog"
	clientLog.Parent = remotes
end

local sequence = 0
local clientRate = {}

local function append(level, message, source)
	sequence += 1
	local entry = Instance.new("StringValue")
	entry.Name = string.format("Entry_%06d", sequence)
	entry.Value = string.format("[%s] [%s] [%s] %s", os.date("!%Y-%m-%dT%H:%M:%SZ"), level, source, message)
	entry:SetAttribute("Level", level)
	entry:SetAttribute("Source", source)
	entry:SetAttribute("Timestamp", os.time())
	entry.Parent = logs

	local entries = logs:GetChildren()
	if #entries > MAX_ENTRIES then
		table.sort(entries, function(a, b)
			return a.Name < b.Name
		end)
		entries[1]:Destroy()
	end
end

LogService.MessageOut:Connect(function(message, messageType)
	append(messageType.Name, message, "ServerOutput")
end)

ScriptContext.Error:Connect(function(message, trace, script)
	local source = script and script:GetFullName() or "UnknownScript"
	append("ScriptError", message .. " | " .. trace, source)
end)

clientLog.OnServerEvent:Connect(function(player, message, level)
	if type(message) ~= "string" or #message > 1000 then
		return
	end

	local now = os.clock()
	local rate = clientRate[player]
	if not rate or now - rate.startedAt >= 1 then
		rate = {startedAt = now, count = 0}
		clientRate[player] = rate
	end
	if rate.count >= 20 then
		return
	end
	rate.count += 1

	append("Client_" .. tostring(level), message, player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
	clientRate[player] = nil
end)

print("Runtime log collector ready. Logs are stored in ServerStorage.RuntimeLogs")
