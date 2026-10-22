local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local combatRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CombatRequest")
local combatResult = ReplicatedStorage.Remotes:WaitForChild("CombatResult")
local selectHero = ReplicatedStorage.Remotes:WaitForChild("SelectHero")

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		combatRequest:FireServer("BasicAttack")
	elseif input.KeyCode == Enum.KeyCode.Q then
		combatRequest:FireServer("BlockStart")
	elseif input.KeyCode == Enum.KeyCode.E then
		combatRequest:FireServer("Skill1")
	elseif input.KeyCode == Enum.KeyCode.R then
		combatRequest:FireServer("Skill2")
	elseif input.KeyCode == Enum.KeyCode.One then
		selectHero:FireServer("Knight")
	elseif input.KeyCode == Enum.KeyCode.Two then
		selectHero:FireServer("Mage")
	elseif input.KeyCode == Enum.KeyCode.Three then
		selectHero:FireServer("Rogue")
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Q then
		combatRequest:FireServer("BlockEnd")
	end
end)

combatResult.OnClientEvent:Connect(function(effectName)
	-- Placeholder for animation and VFX playback.
	-- Server results are received here so visuals can be added without trusting the client.
	if effectName == "BasicAttack" or effectName == "Charge" then
		return
	end
end)

print("Hero controls: 1 Knight | 2 Mage | 3 Rogue | Left Click attack | Q block | E/R skills")
