local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogService = game:GetService("LogService")

local clientLog = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ClientLog")

LogService.MessageOut:Connect(function(message, messageType)
	if messageType == Enum.MessageType.MessageWarning
		or messageType == Enum.MessageType.MessageError
		or messageType == Enum.MessageType.MessageInfo then
		clientLog:FireServer(message, messageType.Name)
	end
end)
