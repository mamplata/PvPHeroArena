local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not remotes then
	remotes = Instance.new("Folder")
	remotes.Name = "Remotes"
	remotes.Parent = ReplicatedStorage
end

local combatRequest = remotes:FindFirstChild("CombatRequest")
if not combatRequest then
	combatRequest = Instance.new("RemoteEvent")
	combatRequest.Name = "CombatRequest"
	combatRequest.Parent = remotes
end

local combatResult = remotes:FindFirstChild("CombatResult")
if not combatResult then
	combatResult = Instance.new("RemoteEvent")
	combatResult.Name = "CombatResult"
	combatResult.Parent = remotes
end

local selectHero = remotes:FindFirstChild("SelectHero")
if not selectHero then
	selectHero = Instance.new("RemoteEvent")
	selectHero.Name = "SelectHero"
	selectHero.Parent = remotes
end

local matchState = ReplicatedStorage:FindFirstChild("MatchState")
if not matchState then
	matchState = Instance.new("Folder")
	matchState.Name = "MatchState"
	matchState.Parent = ReplicatedStorage
end

matchState:SetAttribute("Status", "WAITING")
matchState:SetAttribute("Round", 0)
matchState:SetAttribute("WinsA", 0)
matchState:SetAttribute("WinsB", 0)

local oldArena = workspace:FindFirstChild("ActiveArena")
if oldArena then
	oldArena:Destroy()
end

local arena = Instance.new("Folder")
arena.Name = "ActiveArena"
arena:SetAttribute("ArenaId", "CitadelCourtyard")
arena.Parent = workspace

local function part(name, size, position, color, material)
	local object = Instance.new("Part")
	object.Name = name
	object.Anchored = true
	object.Size = size
	object.Position = position
	object.Color = color
	object.Material = material or Enum.Material.SmoothPlastic
	object.Parent = arena
	return object
end

local floorColor = Color3.fromRGB(82, 86, 96)
local wallColor = Color3.fromRGB(46, 49, 58)
local coverColor = Color3.fromRGB(104, 108, 119)

part("Floor", Vector3.new(80, 1, 80), Vector3.new(0, -0.5, 0), floorColor, Enum.Material.Slate)
part("NorthWall", Vector3.new(80, 10, 1), Vector3.new(0, 5, -40), wallColor, Enum.Material.Brick)
part("SouthWall", Vector3.new(80, 10, 1), Vector3.new(0, 5, 40), wallColor, Enum.Material.Brick)
part("WestWall", Vector3.new(1, 10, 80), Vector3.new(-40, 5, 0), wallColor, Enum.Material.Brick)
part("EastWall", Vector3.new(1, 10, 80), Vector3.new(40, 5, 0), wallColor, Enum.Material.Brick)

for index, position in ipairs({
	Vector3.new(-13, 2, -10),
	Vector3.new(13, 2, -10),
	Vector3.new(-13, 2, 10),
	Vector3.new(13, 2, 10),
}) do
	local cover = part("Cover" .. index, Vector3.new(6, 4, 3), position, coverColor, Enum.Material.Slate)
	cover:SetAttribute("CombatCover", true)
end

local center = part("CenterPlatform", Vector3.new(10, 1, 10), Vector3.new(0, 0.5, 0), coverColor, Enum.Material.Slate)
center:SetAttribute("CombatCover", true)

part("LobbyFloor", Vector3.new(36, 1, 20), Vector3.new(0, -0.5, 55), Color3.fromRGB(58, 72, 86), Enum.Material.Slate)

local bounds = part("ArenaBounds", Vector3.new(74, 20, 74), Vector3.new(0, 10, 0), Color3.new(1, 1, 1), Enum.Material.ForceField)
bounds.Transparency = 1
bounds.CanCollide = false
bounds.CanTouch = false
bounds.CanQuery = false

local function spawn(name, position, direction)
	local point = Instance.new("SpawnLocation")
	point.Name = name
	point.Anchored = true
	point.Neutral = true
	point.AllowTeamChangeOnTouch = false
	point.Size = Vector3.new(6, 1, 6)
	point.Enabled = false
	point.Position = position
	point.CFrame = CFrame.lookAt(position, position + direction)
	point.Color = Color3.fromRGB(55, 145, 220)
	point.Material = Enum.Material.Neon
	point.Parent = arena
	return point
end

spawn("SpawnA", Vector3.new(-27, 0.5, 0), Vector3.new(1, 0, 0))
spawn("SpawnB", Vector3.new(27, 0.5, 0), Vector3.new(-1, 0, 0))

local lobbySpawn = Instance.new("SpawnLocation")
lobbySpawn.Name = "LobbySpawn"
lobbySpawn.Anchored = true
lobbySpawn.Neutral = true
lobbySpawn.AllowTeamChangeOnTouch = false
lobbySpawn.Size = Vector3.new(6, 1, 6)
lobbySpawn.Position = Vector3.new(0, 0.5, 55)
lobbySpawn.Color = Color3.fromRGB(110, 110, 120)
lobbySpawn.Material = Enum.Material.Slate
lobbySpawn.Parent = arena

local lighting = game:GetService("Lighting")
lighting.ClockTime = 18
lighting.Brightness = 2
lighting.Ambient = Color3.fromRGB(75, 80, 105)
lighting.OutdoorAmbient = Color3.fromRGB(45, 50, 75)

local atmosphere = lighting:FindFirstChild("ArenaAtmosphere") or Instance.new("Atmosphere")
atmosphere.Name = "ArenaAtmosphere"
atmosphere.Density = 0.22
atmosphere.Color = Color3.fromRGB(145, 155, 210)
atmosphere.Decay = Color3.fromRGB(35, 40, 75)
atmosphere.Parent = lighting

local ambience = Instance.new("Sound")
ambience.Name = "ArenaAmbience"
ambience.SoundId = ""
ambience.Looped = true
ambience.Volume = 0.2
ambience.Parent = workspace

print("Citadel Courtyard loaded: Knight combat prototype ready")
