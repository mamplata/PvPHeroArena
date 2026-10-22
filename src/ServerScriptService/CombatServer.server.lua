local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local config = require(ReplicatedStorage.Shared.CombatConfig)
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local combatRequest = remotes:WaitForChild("CombatRequest")
local combatResult = remotes:WaitForChild("CombatResult")
local selectHero = remotes:WaitForChild("SelectHero")
local matchState = ReplicatedStorage:WaitForChild("MatchState")
local state = {}

local function getHero(player)
	local heroName = player:GetAttribute("SelectedHero") or "Knight"
	return heroName, config[heroName] or config.Knight
end

local function getCharacterData(player)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 then return nil end
	return character, root, humanoid
end

local function getState(player)
	if not state[player] then
		state[player] = {blocking = false, cooldowns = {}}
	end
	return state[player]
end

local function ready(player, name, cooldown)
	local playerState = getState(player)
	local now = os.clock()
	if now < (playerState.cooldowns[name] or 0) then return false end
	playerState.cooldowns[name] = now + cooldown
	return true
end

local function addWeldedPart(parent, hand, name, size, color, offset, material)
	local object = Instance.new("Part")
	object.Name = name
	object.Size = size
	object.Color = color
	object.Material = material or Enum.Material.Metal
	object.CanCollide = false
	object.CanTouch = false
	object.Massless = true
	object.CFrame = hand.CFrame * offset
	object.Parent = parent
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = hand
	weld.Part1 = object
	weld.Parent = object
	return object
end

local function equipHero(character)
	local player = Players:GetPlayerFromCharacter(character)
	local heroName, hero = getHero(player)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.MaxHealth = hero.MaxHealth
	humanoid.Health = hero.MaxHealth
	humanoid.WalkSpeed = hero.WalkSpeed
	character:SetAttribute("HeroId", heroName)

	local oldWeapons = character:FindFirstChild("HeroWeapons")
	if oldWeapons then oldWeapons:Destroy() end
	local rightHand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
	local leftHand = character:FindFirstChild("LeftHand") or character:FindFirstChild("Left Arm")
	if not rightHand or not leftHand then return end

	local weapons = Instance.new("Folder")
	weapons.Name = "HeroWeapons"
	weapons.Parent = character

	if heroName == "Knight" then
		addWeldedPart(weapons, rightHand, "Sword", Vector3.new(0.35, 0.35, 4), Color3.fromRGB(205, 215, 230), CFrame.new(0, -1.4, -1.2) * CFrame.Angles(math.rad(90), 0, 0))
		local shield = addWeldedPart(weapons, leftHand, "Shield", Vector3.new(0.6, 3.5, 3.5), Color3.fromRGB(45, 90, 160), CFrame.new(0, 0, -0.7) * CFrame.Angles(0, math.rad(90), 0))
		shield.Shape = Enum.PartType.Cylinder
	elseif heroName == "Mage" then
		local staff = addWeldedPart(weapons, rightHand, "Staff", Vector3.new(0.3, 0.3, 5), Color3.fromRGB(115, 65, 40), CFrame.new(0, -1.6, -1) * CFrame.Angles(math.rad(90), 0, 0))
		local crystal = Instance.new("Part")
		crystal.Name = "StaffCrystal"
		crystal.Shape = Enum.PartType.Ball
		crystal.Size = Vector3.new(0.8, 0.8, 0.8)
		crystal.Color = Color3.fromRGB(255, 120, 40)
		crystal.Material = Enum.Material.Neon
		crystal.CanCollide = false
		crystal.CanTouch = false
		crystal.Massless = true
		crystal.CFrame = staff.CFrame * CFrame.new(0, -2.3, 0)
		crystal.Parent = weapons
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = staff
		weld.Part1 = crystal
		weld.Parent = crystal
	else
		addWeldedPart(weapons, rightHand, "RightDagger", Vector3.new(0.25, 0.25, 2.3), Color3.fromRGB(220, 225, 235), CFrame.new(0, -0.7, -0.8) * CFrame.Angles(math.rad(90), 0, 0))
		addWeldedPart(weapons, leftHand, "LeftDagger", Vector3.new(0.25, 0.25, 2.3), Color3.fromRGB(220, 225, 235), CFrame.new(0, -0.7, -0.8) * CFrame.Angles(math.rad(90), 0, 0))
	end
end

local function isBlocked(targetPlayer, attackerRoot, targetRoot)
	local targetState = targetPlayer and state[targetPlayer]
	if not targetState or not targetState.blocking then return false end
	local directionToAttacker = (attackerRoot.Position - targetRoot.Position).Unit
	return targetRoot.CFrame.LookVector:Dot(directionToAttacker) >= config.Knight.Block.FrontAngle
end

local function findHumanoids(parts, attackerCharacter)
	local targets, seen = {}, {}
	for _, part in ipairs(parts) do
		local character = part:FindFirstAncestorOfClass("Model")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if character and character ~= attackerCharacter and humanoid and humanoid.Health > 0 and not seen[humanoid] then
			seen[humanoid] = true
			table.insert(targets, {character = character, humanoid = humanoid})
		end
	end
	return targets
end

local function damageTarget(attackerRoot, target, damage)
	local targetPlayer = Players:GetPlayerFromCharacter(target.character)
	local targetRoot = target.character:FindFirstChild("HumanoidRootPart")
	if targetRoot and not isBlocked(targetPlayer, attackerRoot, targetRoot) then
		target.humanoid:TakeDamage(damage)
		combatResult:FireAllClients("BasicAttackHit", targetRoot.Position)
	end
end

local function useBasicAttack(player, character, root, hero)
	if not ready(player, "BasicAttack", hero.BasicAttack.Cooldown) then return end
	local overlap = OverlapParams.new()
	overlap.FilterType = Enum.RaycastFilterType.Exclude
	overlap.FilterDescendantsInstances = {character}
	local parts = workspace:GetPartBoundsInBox(root.CFrame * hero.BasicAttack.BoxOffset, hero.BasicAttack.BoxSize, overlap)
	for _, target in ipairs(findHumanoids(parts, character)) do
		damageTarget(root, target, hero.BasicAttack.Damage)
	end
	combatResult:FireAllClients("BasicAttack", player)
end

local function useKnightCharge(player, root, hero)
	if not ready(player, "Charge", hero.Charge.Cooldown) or getState(player).blocking then return end
	root:ApplyImpulse(root.CFrame.LookVector * root.AssemblyMass * hero.Charge.Speed)
	combatResult:FireAllClients("Charge", player)
end

local function useFireball(player, character, root, hero)
	if not ready(player, "Fireball", hero.Fireball.Cooldown) then return end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {character}
	local result = workspace:Raycast(root.Position + Vector3.new(0, 1, 0), root.CFrame.LookVector * hero.Fireball.Range, params)
	if result then
		local targetCharacter = result.Instance:FindFirstAncestorOfClass("Model")
		local humanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			damageTarget(root, {character = targetCharacter, humanoid = humanoid}, hero.Fireball.Damage)
		end
	end
	combatResult:FireAllClients("Fireball", result and result.Position or root.Position + root.CFrame.LookVector * hero.Fireball.Range)
end

local function useTeleport(player, root, hero)
	if not ready(player, "Teleport", hero.Teleport.Cooldown) then return end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {player.Character}
	local direction = root.CFrame.LookVector
	local result = workspace:Raycast(root.Position, direction * hero.Teleport.Distance, params)
	local destination = result and result.Position - direction * 3 or root.Position + direction * hero.Teleport.Distance
	root.CFrame = CFrame.lookAt(destination, destination + direction)
	combatResult:FireAllClients("Teleport", destination)
end

local function useDash(player, root, hero)
	if not ready(player, "Dash", hero.Dash.Cooldown) then return end
	root:ApplyImpulse(root.CFrame.LookVector * root.AssemblyMass * hero.Dash.Speed)
	combatResult:FireAllClients("Dash", player)
end

local function useSmokeVeil(player, character, hero)
	if not ready(player, "SmokeVeil", hero.SmokeVeil.Cooldown) then return end
	local original = {}
	for _, object in ipairs(character:GetDescendants()) do
		if object:IsA("BasePart") and object.Name ~= "HumanoidRootPart" then
			original[object] = object.Transparency
			object.Transparency = 0.75
		end
	end
	combatResult:FireAllClients("SmokeVeil", character)
	task.delay(hero.SmokeVeil.Duration, function()
		for object, transparency in pairs(original) do
			if object.Parent then object.Transparency = transparency end
		end
	end)
end

selectHero.OnServerEvent:Connect(function(player, heroName)
	if player:GetAttribute("InMatch") or type(heroName) ~= "string" or not config[heroName] then return end
	player:SetAttribute("SelectedHero", heroName)
	player:LoadCharacter()
	combatResult:FireClient(player, "HeroSelected", heroName)
end)

combatRequest.OnServerEvent:Connect(function(player, action)
	if type(action) ~= "string" or not player:GetAttribute("InMatch") or matchState:GetAttribute("Status") ~= "FIGHT" then return end
	local character, root = getCharacterData(player)
	if not character then return end
	local heroName, hero = getHero(player)
	local playerState = getState(player)

	if action == "BlockStart" and heroName == "Knight" then
		playerState.blocking = true
		combatResult:FireAllClients("BlockStart", player)
	elseif action == "BlockEnd" then
		playerState.blocking = false
		combatResult:FireAllClients("BlockEnd", player)
	elseif action == "BasicAttack" then
		useBasicAttack(player, character, root, hero)
	elseif action == "Skill1" then
		if heroName == "Knight" then useKnightCharge(player, root, hero)
		elseif heroName == "Mage" then useFireball(player, character, root, hero)
		elseif heroName == "Rogue" then useDash(player, root, hero) end
	elseif action == "Skill2" then
		if heroName == "Mage" then useTeleport(player, root, hero)
		elseif heroName == "Rogue" then useSmokeVeil(player, character, hero) end
	end
end)

local function setupPlayer(player)
	player:SetAttribute("SelectedHero", player:GetAttribute("SelectedHero") or "Knight")
	player:SetAttribute("InMatch", false)
	player.CharacterAdded:Connect(function(character)
		state[player] = {blocking = false, cooldowns = {}}
		equipHero(character)
	end)
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(function(player) state[player] = nil end)

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
	if player.Character then equipHero(player.Character) end
end

print("Hero combat server ready")
