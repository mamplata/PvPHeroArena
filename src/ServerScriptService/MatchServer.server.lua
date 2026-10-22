local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local matchUpdate = remotes:FindFirstChild("MatchUpdate")
if not matchUpdate then
	matchUpdate = Instance.new("RemoteEvent")
	matchUpdate.Name = "MatchUpdate"
	matchUpdate.Parent = remotes
end

local arena = workspace:WaitForChild("ActiveArena")
local spawnA = arena:WaitForChild("SpawnA")
local spawnB = arena:WaitForChild("SpawnB")
local lobbySpawn = arena:WaitForChild("LobbySpawn")
local matchState = ReplicatedStorage:WaitForChild("MatchState")

local running = false
local tryStartMatch

local function sendStatus(text, round, winsA, winsB)
	matchState:SetAttribute("Status", text == "FIGHT" and "FIGHT" or "WAITING")
	matchState:SetAttribute("Round", round)
	matchState:SetAttribute("WinsA", winsA)
	matchState:SetAttribute("WinsB", winsB)
	matchUpdate:FireAllClients(text, round, winsA, winsB)
end

local function getPlayers()
	local players = Players:GetPlayers()
	table.sort(players, function(a, b)
		return a.UserId < b.UserId
	end)
	return players[1], players[2]
end

local function resetPlayer(player, spawnPoint)
	player:LoadCharacter()

	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")

	root.CFrame = spawnPoint.CFrame + Vector3.new(0, 3, 0)
	humanoid.Health = humanoid.MaxHealth
end

local function returnToLobby(player)
	if not player.Parent then
		return
	end

	player:SetAttribute("InMatch", false)
	player:SetAttribute("ArenaSpawn", nil)
	resetPlayer(player, lobbySpawn)
end

local function waitForRoundWinner(playerA, playerB)
	local winner
	local connections = {}

	local function finish(player)
		if not winner then
			winner = player == playerA and playerB or playerA
		end
	end

	for _, player in ipairs({playerA, playerB}) do
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			table.insert(connections, humanoid.Died:Connect(function()
				finish(player)
			end))
		end
	end

	while not winner and playerA.Parent and playerB.Parent do
		task.wait(0.1)
	end

	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end

	if not playerA.Parent or not playerB.Parent then
		return nil
	end

	return winner
end

local function runMatch(playerA, playerB)
	running = true
	playerA:SetAttribute("InMatch", true)
	playerB:SetAttribute("InMatch", true)
	playerA:SetAttribute("ArenaSpawn", "A")
	playerB:SetAttribute("ArenaSpawn", "B")
	local wins = {[playerA] = 0, [playerB] = 0}
	local winner

	for round = 1, 3 do
		if not playerA.Parent or not playerB.Parent then
			break
		end

		for count = 3, 1, -1 do
			sendStatus("ROUND " .. round .. " STARTING " .. count, round, wins[playerA], wins[playerB])
			task.wait(1)
		end

		resetPlayer(playerA, spawnA)
		resetPlayer(playerB, spawnB)
		sendStatus("FIGHT", round, wins[playerA], wins[playerB])

		local roundWinner = waitForRoundWinner(playerA, playerB)
		if not roundWinner then
			break
		end

		wins[roundWinner] += 1
		sendStatus(roundWinner.DisplayName .. " WINS THE ROUND", round, wins[playerA], wins[playerB])

		if wins[roundWinner] >= 2 then
			winner = roundWinner
			break
		end

		task.wait(2)
	end

	if winner then
		sendStatus(winner.DisplayName .. " WINS THE MATCH", 0, wins[playerA], wins[playerB])
	else
		sendStatus("MATCH ENDED", 0, wins[playerA], wins[playerB])
	end

	task.wait(4)
	returnToLobby(playerA)
	returnToLobby(playerB)
	matchState:SetAttribute("Status", "WAITING")
	running = false
	tryStartMatch()
end

tryStartMatch = function()
	if running then
		return
	end

	local playerA, playerB = getPlayers()
	if playerA and playerB then
		task.spawn(runMatch, playerA, playerB)
	else
		for _, player in ipairs(Players:GetPlayers()) do
			player:SetAttribute("InMatch", false)
		end
		sendStatus("WAITING FOR 2 PLAYERS", 0, 0, 0)
	end
end

Players.PlayerAdded:Connect(function()
	task.defer(tryStartMatch)
end)

Players.PlayerRemoving:Connect(function()
	if not running then
		task.defer(tryStartMatch)
	end
end)

tryStartMatch()
print("Match server ready")
