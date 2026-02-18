local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.fromOffset(40, 40)
btn.Parent = gui
btn.Position = UDim2.fromScale(0.86, 0.6)
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.Text = "😈"
btn.TextSize = 14

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = btn

local flag = 0

btn.MouseButton1Click:Connect(function()
    flag = 1
    local char = player.Character
    local tool = player.Backpack:FindFirstChild("IvoryPeriastron")

    if tool and flag then
        local weaponAlreadyEquipped
        local weaponsList = {"SteampunkGlove", "Taser", "ChartreusePeriastron", "FallPeriastron", "LinkedSword", "8BitSword", "PotOfGoldSword", "FuseBomb", "NeonSpaceGun", "RedHyperLaser", "LaserFingerPointers", "Acceleration Coil", "AmethystPeriastron", "AzurePeriastron", "ChristmasTreeSword", "CrimsonPeriastron", "FestivePeriastron", "FireSword", "GrimgoldPeriastron", "IvoryPeriastron", "RainbowPeriastron", "RocketBoots", "WaterSword"}
        local carpetsList = {"GoldenCarpet", "RainbowMagicCarpet"}

        for _, obj in ipairs(char:GetChildren()) do
            for _, e in ipairs(weaponsList) do
                if obj.Name == e then
                    weaponAlreadyEquipped = obj.Name
                    local w = char:FindFirstChild(weaponAlreadyEquipped)
                    w.Parent = player.Backpack
                end
            end
            for _, e in ipairs(carpetsList) do
                if obj.Name == e then
                    weaponAlreadyEquipped = obj.Name
                end
            end
        end

        tool.Parent = char
        local remote = tool:WaitForChild('Remote')
        
            remote:FireServer(Enum.KeyCode.E)    
        
        local remote = tool:WaitForChild('Remote')
        
            remote:FireServer(Enum.KeyCode.E)    
        

        tool.Parent = player.Backpack
        if weaponAlreadyEquipped and weaponAlreadyEquipped ~= 'RainbowMagicCarpet' and weaponAlreadyEquipped ~= 'GoldenCarpet' then
            local weapon = player.Backpack:FindFirstChild(weaponAlreadyEquipped)
            if weapon then
                weapon.Parent = char
            end
        end
    end
    flag = 0
end)