local player = game.Players.LocalPlayer

player.CharacterAdded:Connect(function(char)
	task.wait(0.6)

	local tool = player.Backpack:FindFirstChild("FallPeriastron")
	if tool then
		tool.Parent = char
	end
end)