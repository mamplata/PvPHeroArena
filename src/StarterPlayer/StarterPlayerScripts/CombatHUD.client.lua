local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local combatResult = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CombatResult")
local matchUpdate = ReplicatedStorage.Remotes:WaitForChild("MatchUpdate")

local oldGui = playerGui:FindFirstChild("CombatHUD")
if oldGui then
	oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "CombatHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "StatusPanel"
panel.AnchorPoint = Vector2.new(0, 1)
panel.Position = UDim2.new(0, 20, 1, -20)
panel.Size = UDim2.fromOffset(280, 92)
panel.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
panel.BackgroundTransparency = 0.12
panel.BorderSizePixel = 0
panel.Parent = gui

local matchStatus = Instance.new("TextLabel")
matchStatus.AnchorPoint = Vector2.new(0.5, 0)
matchStatus.Position = UDim2.new(0.5, 0, 0, 24)
matchStatus.Size = UDim2.fromOffset(460, 32)
matchStatus.BackgroundTransparency = 1
matchStatus.Text = "WAITING FOR 2 PLAYERS"
matchStatus.TextColor3 = Color3.fromRGB(255, 220, 120)
matchStatus.Font = Enum.Font.GothamBold
matchStatus.TextSize = 20
matchStatus.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 24)
title.Position = UDim2.fromOffset(10, 7)
title.BackgroundTransparency = 1
title.Text = "KNIGHT"
title.TextColor3 = Color3.fromRGB(150, 205, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local healthBackground = Instance.new("Frame")
healthBackground.Size = UDim2.new(1, -20, 0, 18)
healthBackground.Position = UDim2.fromOffset(10, 35)
healthBackground.BackgroundColor3 = Color3.fromRGB(55, 25, 35)
healthBackground.BorderSizePixel = 0
healthBackground.Parent = panel

local healthFill = Instance.new("Frame")
healthFill.Size = UDim2.fromScale(1, 1)
healthFill.BackgroundColor3 = Color3.fromRGB(70, 215, 120)
healthFill.BorderSizePixel = 0
healthFill.Parent = healthBackground

local healthText = Instance.new("TextLabel")
healthText.Size = UDim2.fromScale(1, 1)
healthText.BackgroundTransparency = 1
healthText.TextColor3 = Color3.new(1, 1, 1)
healthText.Font = Enum.Font.GothamBold
healthText.TextSize = 12
healthText.Parent = healthBackground

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 24)
status.Position = UDim2.fromOffset(10, 60)
status.BackgroundTransparency = 1
status.Text = "1/2/3 Select Hero   |   LMB Attack   |   E/R Skills"
status.TextColor3 = Color3.fromRGB(210, 215, 225)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

local function updateHeroLabel()
	local hero = player:GetAttribute("SelectedHero") or "Knight"
	title.Text = string.upper(hero)
	if hero == "Knight" then
		status.Text = "LMB Attack   |   Q Block   |   E Charge"
	elseif hero == "Mage" then
		status.Text = "LMB Attack   |   E Fireball   |   R Teleport"
	else
		status.Text = "LMB Attack   |   E Dash   |   R Smoke Veil"
	end
end

player:GetAttributeChangedSignal("SelectedHero"):Connect(updateHeroLabel)
updateHeroLabel()

local function updateHealth()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	local ratio = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
	healthFill.Size = UDim2.fromScale(ratio, 1)
	healthText.Text = string.format("%d / %d", math.ceil(humanoid.Health), humanoid.MaxHealth)
	end

local function watchCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.HealthChanged:Connect(updateHealth)
	updateHealth()
end

player.CharacterAdded:Connect(watchCharacter)
if player.Character then
	watchCharacter(player.Character)
end

combatResult.OnClientEvent:Connect(function(effectName, value)
	if effectName == "BlockStart" and value == player then
		status.Text = "SHIELD BLOCKING"
		status.TextColor3 = Color3.fromRGB(120, 205, 255)
	elseif effectName == "BlockEnd" and value == player then
		updateHeroLabel()
		status.TextColor3 = Color3.fromRGB(210, 215, 225)
	elseif effectName == "BasicAttackHit" then
		status.Text = "HIT CONFIRMED"
		task.delay(0.35, function()
			if status.Text == "HIT CONFIRMED" then
			updateHeroLabel()
			end
		end)
	end
end)

matchUpdate.OnClientEvent:Connect(function(text, round, winsA, winsB)
	if round > 0 then
		matchStatus.Text = string.format("%s  |  ROUND %d  |  %d - %d", text, round, winsA, winsB)
	else
		matchStatus.Text = string.format("%s  |  %d - %d", text, winsA, winsB)
	end

	if text == "FIGHT" then
		matchStatus.TextColor3 = Color3.fromRGB(120, 255, 160)
	else
		matchStatus.TextColor3 = Color3.fromRGB(255, 220, 120)
	end
end)

RunService.RenderStepped:Connect(updateHealth)
