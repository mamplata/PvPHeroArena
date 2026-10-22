-- Safe smoke-test runner. It only reads game state and prints results.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local running = false

local function check(name, condition, detail)
	if condition then
		print("[MVP PASS]", name)
		return true
	end

	warn("[MVP FAIL]", name, detail or "condition was false")
	return false
end

local function runTests()
	if running then
		return
	end
	running = true

	local passed = 0
	local failed = 0

	local function test(name, condition, detail)
		if check(name, condition, detail) then
			passed += 1
		else
			failed += 1
		end
	end

	print("========== PvP Hero Arena MVP TESTS ==========")

	local arena = workspace:FindFirstChild("ActiveArena")
	test("Active arena exists", arena ~= nil)
	if arena then
		test("Arena floor exists", arena:FindFirstChild("Floor") ~= nil)
		test("Lobby spawn exists", arena:FindFirstChild("LobbySpawn") ~= nil)
		test("Arena Spawn A exists", arena:FindFirstChild("SpawnA") ~= nil)
		test("Arena Spawn B exists", arena:FindFirstChild("SpawnB") ~= nil)
		test("Arena bounds exist", arena:FindFirstChild("ArenaBounds") ~= nil)

		local spawnA = arena:FindFirstChild("SpawnA")
		local spawnB = arena:FindFirstChild("SpawnB")
		if spawnA and spawnB then
			test("Spawns are separated", (spawnA.Position - spawnB.Position).Magnitude > 20)
			test("Spawns are symmetric", math.abs(spawnA.Position.X + spawnB.Position.X) < 0.1)
		end
	end

	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	test("Remote folder exists", remotes ~= nil)
	if remotes then
		test("CombatRequest exists", remotes:FindFirstChild("CombatRequest") ~= nil)
		test("CombatResult exists", remotes:FindFirstChild("CombatResult") ~= nil)
		test("SelectHero exists", remotes:FindFirstChild("SelectHero") ~= nil)
		test("MatchUpdate exists", remotes:FindFirstChild("MatchUpdate") ~= nil)
	end

	local matchState = ReplicatedStorage:FindFirstChild("MatchState")
	test("MatchState exists", matchState ~= nil)
	if matchState then
		test("MatchState has Status", matchState:GetAttribute("Status") ~= nil)
		test("MatchState has Round", matchState:GetAttribute("Round") ~= nil)
	end

	local shared = ReplicatedStorage:FindFirstChild("Shared")
	local configModule = shared and shared:FindFirstChild("CombatConfig")
	test("CombatConfig exists", configModule ~= nil)
	if configModule then
		local ok, config = pcall(require, configModule)
		test("CombatConfig loads", ok and type(config) == "table")
		if ok and type(config) == "table" then
			for _, heroName in ipairs({"Knight", "Mage", "Rogue"}) do
				local hero = config[heroName]
				test(heroName .. " config exists", hero ~= nil)
				if hero then
					test(heroName .. " has health", type(hero.MaxHealth) == "number" and hero.MaxHealth > 0)
					test(heroName .. " has basic attack", hero.BasicAttack ~= nil)
					test(heroName .. " has two skills", (hero.Block and hero.Charge) or (hero.Fireball and hero.Teleport) or (hero.Dash and hero.SmokeVeil))
				end
			end
		end
	end

	local players = Players:GetPlayers()
	for _, player in ipairs(players) do
		test(player.Name .. " has hero selection", player:GetAttribute("SelectedHero") ~= nil)
		test(player.Name .. " has match state", player:GetAttribute("InMatch") ~= nil)
		local character = player.Character
		if character then
			test(player.Name .. " has Humanoid", character:FindFirstChildOfClass("Humanoid") ~= nil)
			test(player.Name .. " has root", character:FindFirstChild("HumanoidRootPart") ~= nil)
		end
	end

	print(string.format("========== MVP TEST RESULT: %d passed, %d failed ==========" , passed, failed))
	if failed == 0 then
		print("[MVP RESULT] PASS - smoke checks completed")
	else
		warn("[MVP RESULT] FAIL - inspect the failed checks above")
	end

	workspace:SetAttribute("RunMVPTests", false)
	running = false
end

workspace:GetAttributeChangedSignal("RunMVPTests"):Connect(function()
	if workspace:GetAttribute("RunMVPTests") == true then
		task.spawn(runTests)
	end
end)

if workspace:GetAttribute("RunMVPTests") == true then
	task.spawn(runTests)
end

print("MVP test runner ready. Set workspace.RunMVPTests = true to run.")
