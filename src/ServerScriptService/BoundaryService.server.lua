local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local arena = workspace:WaitForChild("ActiveArena")
local spawnA = arena:WaitForChild("SpawnA")
local spawnB = arena:WaitForChild("SpawnB")

local MIN_X = -36
local MAX_X = 36
local MIN_Z = -36
local MAX_Z = 36
local MIN_Y = -4

local function recover(player, root)
	local spawnPoint = player:GetAttribute("ArenaSpawn") == "B" and spawnB or spawnA
	root.CFrame = spawnPoint.CFrame + Vector3.new(0, 3, 0)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
end

RunService.Heartbeat:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		if player:GetAttribute("InMatch") then
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if root and humanoid and humanoid.Health > 0 then
				local position = root.Position
				if position.X < MIN_X or position.X > MAX_X
					or position.Z < MIN_Z or position.Z > MAX_Z
					or position.Y < MIN_Y then
					recover(player, root)
				end
			end
		end
	end
end)

print("Arena boundary service ready")
