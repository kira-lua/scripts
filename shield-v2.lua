local player = game.Players.LocalPlayer

function shield(char)
    local tool = player.Backpack:FindFirstChild('ChartreusePeriastron')
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
    tool.Equipped:Connect(function()
        remote:FireServer(Enum.KeyCode.Q)    
    end)
    tool.Parent = player.Backpack
    if weaponAlreadyEquipped and weaponAlreadyEquipped ~= 'RainbowMagicCarpet' and weaponAlreadyEquipped ~= 'GoldenCarpet' then
        local weapon = player.Backpack:FindFirstChild(weaponAlreadyEquipped)
        if weapon then
            weapon.Parent = char
        end
    end
end

Workspace.ChildAdded:Connect(function(obj)
    if obj.Name == 'SONARPeri' then
        shield(player.Character)
    end
end)

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild('Humanoid')
    local lastHealth = hum.Health
    hum.HealthChanged:Connect(function(newHealth)
        if newHealth < lastHealth then
            shield(char)
        end
        lastHealth = newHealth
    end)
end)