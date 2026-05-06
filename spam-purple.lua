local player = game.Players.LocalPlayer

function spamPurple()
    local char = player.Character
    local tool = player.Backpack:FindFirstChild("AmethystPeriastron")
    task.wait(0.8)
	if tool then
		tool.Parent = char
        local remote = tool:WaitForChild('Remote')
        tool.Equipped:Connect(function()
            remote:FireServer(Enum.KeyCode.Q)    
        end)
	end
    task.wait(1.5)
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end

spamPurple()

player.CharacterAdded:Connect(function(char)
	spamPurple()
end)
