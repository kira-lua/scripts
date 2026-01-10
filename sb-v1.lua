local function fly()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    local velocityHandlerName = "FlyVelocity"
    local gyroHandlerName = "FlyGyro"
    local iyflyspeed = 1

    local function getRoot(character)
        return character:FindFirstChild("HumanoidRootPart")
    end

    local function unmobilefly(speaker)
        local root = getRoot(speaker.Character)
        if root then
            local bv = root:FindFirstChild(velocityHandlerName)
            if bv then bv:Destroy() end
            local bg = root:FindFirstChild(gyroHandlerName)
            if bg then bg:Destroy() end
        end
        if speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") then
            speaker.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
        end
    end

    local function mobilefly(speaker, vfly)
        unmobilefly(speaker)
        local root = getRoot(speaker.Character)
        local camera = workspace.CurrentCamera
        local v3none = Vector3.new()
        local v3zero = Vector3.new(0,0,0)
        local v3inf = Vector3.new(9e9, 9e9, 9e9)

        local controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

        local bv = Instance.new("BodyVelocity")
        bv.Name = velocityHandlerName
        bv.Parent = root
        bv.MaxForce = v3zero
        bv.Velocity = v3zero

        local bg = Instance.new("BodyGyro")
        bg.Name = gyroHandlerName
        bg.Parent = root
        bg.MaxTorque = v3inf
        bg.P = 1000
        bg.D = 50

        RunService.RenderStepped:Connect(function()
            root = getRoot(speaker.Character)
            camera = workspace.CurrentCamera
            if speaker.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
                local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
                local VelocityHandler = root:FindFirstChild(velocityHandlerName)
                local GyroHandler = root:FindFirstChild(gyroHandlerName)

                VelocityHandler.MaxForce = v3inf
                GyroHandler.MaxTorque = v3inf
                if not vfly then humanoid.PlatformStand = true end
                GyroHandler.CFrame = camera.CFrame
                VelocityHandler.Velocity = v3none

                local direction = controlModule:GetMoveVector()
                if direction.X ~= 0 then
                    VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * iyflyspeed * 50)
                end
                if direction.Z ~= 0 then
                    VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * iyflyspeed * 50)
                end
            end
        end)
    end
    mobilefly(player, false)
end

local function unfly()
    local player = game.Players.LocalPlayer
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if root then
        local bv = root:FindFirstChild("FlyVelocity")
        if bv then bv:Destroy() end
        local bg = root:FindFirstChild("FlyGyro")
        if bg then bg:Destroy() end
    end

    if humanoid then
        humanoid.PlatformStand = false
    end
end
local targetGlobal

local headSitConnection

local standActive = false
local viewActive = false

local function Stand(target)
    standActive = true
    fly()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    local function getRoot(character)
        return character:FindFirstChild("HumanoidRootPart")
    end

    local targetPlr = Players:FindFirstChild(target)

    if targetPlr and targetPlr.Character and getRoot(targetPlr.Character) and getRoot(player.Character) then
        if headSitConnection then headSitConnection:Disconnect() end

        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end

        local sitDied = humanoid.Died:Connect(function()
            if headSitConnection then
                headSitConnection:Disconnect()
            end
        end)

        headSitConnection = RunService.Heartbeat:Connect(function()
            local root = getRoot(player.Character)
            local targetRoot = getRoot(targetPlr.Character)
            if root and targetRoot then
                root.CFrame = targetRoot.CFrame * CFrame.new(-2.5, 1, 1)
            else
                headSitConnection:Disconnect()
            end
        end)
    else
        warn("Le joueur cible n'existe pas ou n'a pas de personnage valide.")
    end
end

local function StopStand()
    standActive = false
    unfly()
    if headSitConnection then
        headSitConnection:Disconnect()
        headSitConnection = nil
    end
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local viewDied
local viewChanged
local viewing

local function View(targetName)
    viewActive = true
    if StopFreecam then
        StopFreecam()
    end

    local targetPlr = Players:FindFirstChild(targetName)
    if not targetPlr or not targetPlr.Character then
        warn("Le joueur cible n'existe pas ou n'a pas de personnage valide.")
        return
    end

    if viewDied then viewDied:Disconnect() end
    if viewChanged then viewChanged:Disconnect() end

    viewing = targetPlr
    workspace.CurrentCamera.CameraSubject = viewing.Character

    if notify then
        notify('Spectate', 'Viewing ' .. viewing.Name)
    end

    viewDied = viewing.CharacterAdded:Connect(function()
        repeat wait() until viewing.Character and viewing.Character:FindFirstChild("HumanoidRootPart")
        workspace.CurrentCamera.CameraSubject = viewing.Character
    end)

    viewChanged = workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
        workspace.CurrentCamera.CameraSubject = viewing.Character
    end)
end

local function Unview()
    viewActive = false
    if viewDied then viewDied:Disconnect() end
    if viewChanged then viewChanged:Disconnect() end
    viewing = nil
    workspace.CurrentCamera.CameraSubject = Players.LocalPlayer.Character
end

local function r15(player)
    return player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.RigType == Enum.HumanoidRigType.R15
end

local function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
end

local function getTorso(character)
    return character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("HumanoidRootPart")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local bangTrack
local bangAnim
local bangDied
local bangLoop

local function unbang(speaker)
	if bangLoop then bangLoop:Disconnect() bangLoop = nil end
	if bangDied then bangDied:Disconnect() bangDied = nil end
	if bangTrack then bangTrack:Stop() bangTrack = nil end
	if bangAnim then bangAnim:Destroy() bangAnim = nil end
end

local function bang(target, speed, speaker)
	unbang(speaker)
	task.wait()

	local char = speaker.Character
	if not char then return end

	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if not hum then return end

	bangAnim = Instance.new("Animation")
	bangAnim.AnimationId = r15(speaker)
		and "rbxassetid://5918726674"
		or  "rbxassetid://148840371"

	bangTrack = hum:LoadAnimation(bangAnim)
	bangTrack:Play(0.1, 1, speed or 3)

	bangDied = hum.Died:Connect(function()
		unbang(speaker)
	end)

	if not target then return end

	local targetPlr = Players:FindFirstChild(target)
	if not targetPlr then return end

	local offset = CFrame.new(0, 0, 1.1)

	bangLoop = RunService.Stepped:Connect(function()
		pcall(function()
			local myRoot = getRoot(speaker.Character)
			local tRoot = getTorso(targetPlr.Character)
			if myRoot and tRoot then
				myRoot.CFrame = tRoot.CFrame * offset
			end
		end)
	end)
end

local function SetTarget(newTarget)
    if targetGlobal == newTarget then return end

    targetGlobal = newTarget

    if standActive == true then
        StopStand()

        if targetGlobal then
            Stand(targetGlobal)
        end
    end
    
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.DisplayOrder = 999999
gui.Parent = player:WaitForChild("PlayerGui")

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.fromOffset(30, 30)
openBtn.Position = UDim2.fromScale(0.02, 0.9)
openBtn.Text = "K"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 22
openBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.Rotation = -90
openBtn.ZIndex = 99999999
openBtn.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 4)
corner.Parent = openBtn

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(150,150,150)
stroke.Thickness = 1
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = openBtn

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(400, 240)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Visible = false
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0,10)
frameCorner.Parent = frame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0,20)
uiPadding.PaddingLeft = UDim.new(0,20)
uiPadding.PaddingRight = UDim.new(0,20)
uiPadding.Parent = frame

local avatar = Instance.new("ImageLabel")
avatar.Position = UDim2.fromScale(0,0)
avatar.BackgroundColor3 = Color3.fromRGB(0,0,0)
avatar.Parent = frame

local function updateAvatarSize()
    local size = frame.AbsoluteSize.Y * 0.3
    avatar.Size = UDim2.new(0, size, 0, size)
end
updateAvatarSize()
frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateAvatarSize)

local search = Instance.new("TextBox")
search.Size = UDim2.new(0, frame.AbsoluteSize.X - avatar.Size.X.Offset - 55, 0, 30)
search.Position = UDim2.new(0, avatar.Size.X.Offset + 15, 0, 0)
search.PlaceholderText = "target"
search.BackgroundColor3 = Color3.fromRGB(0,0,0)
search.TextColor3 = Color3.fromRGB(255,255,255)
search.PlaceholderColor3 = Color3.fromRGB(180,180,180)
search.TextSize = 18
search.Parent = frame

local username = Instance.new("TextLabel")
username.Size = UDim2.new(0, search.Size.X.Offset, 0, 25)
username.Position = UDim2.new(0, avatar.Size.X.Offset + 15, 0, 35)
username.Text = "username :"
username.BackgroundTransparency = 1
username.TextColor3 = Color3.fromRGB(255,255,255)
username.TextXAlignment = Enum.TextXAlignment.Left
username.Parent = frame

local display = Instance.new("TextLabel")
display.Size = UDim2.new(0, search.Size.X.Offset, 0, 25)
display.Position = UDim2.new(0, avatar.Size.X.Offset + 15, 0, 60)
display.Text = "display :"
display.BackgroundTransparency = 1
display.TextColor3 = Color3.fromRGB(255,255,255)
display.TextXAlignment = Enum.TextXAlignment.Left
display.Parent = frame

local function updateButtons()
    local padding = 20
    local spacing = 10
    local btnWidth = (frame.AbsoluteSize.X - 2*padding - spacing) / 2
    local btnHeight = 40

    for i = 1, 4 do
        local btn = frame:FindFirstChild("ActionButton"..i)
		
        if not btn then
            btn = Instance.new("TextButton")
            btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 16

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 5)
            corner.Parent = btn

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(150,150,150)
            stroke.Thickness = 1
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = btn

			btn.Font = Enum.Font.Gotham
			btn.TextSize = 16
            if i == 3 then
                btn.Name = "ActionButton3"
                btn.Text = "Stand"
                btn.MouseButton1Click:Connect(function()
					if targetGlobal == nil then
						return
					end
                    if standActive == false then
                        Stand(targetGlobal)
                        btn.TextColor3 = Color3.fromRGB(0,255,0)
                    else
                        StopStand()
                        btn.TextColor3 = Color3.fromRGB(255,255,255)
                    end
                end)
            end
            if i == 4 then
                btn.Name = "ActionButton4"
                btn.Text = "View"
                btn.MouseButton1Click:Connect(function()
					if targetGlobal == nil then
						return
					end
                    if viewActive == false then
                        View(targetGlobal)
                        btn.TextColor3 = Color3.fromRGB(0,255,0)
                    else
                        Unview()
                        btn.TextColor3 = Color3.fromRGB(255,255,255)
                    end
                end)
            end
			if i == 1 then
                btn.Name = "ActionButton1"
                btn.Text = "Bang"
                btn.MouseButton1Click:Connect(function()
					if targetGlobal == nil then
						return
					end
					bang(targetGlobal, 2, game.Players.LocalPlayer)
                end)
            end
			if i == 2 then
                btn.Name = "ActionButton2"
                btn.Text = "Unbang"
                btn.MouseButton1Click:Connect(function()
					if targetGlobal == nil then
						return
					end
					unbang(game.Players.LocalPlayer)
                end)
            end
            btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Parent = frame
        end

        btn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
        local row = math.floor((i-1)/2)
        local col = (i-1)%2
        btn.Position = UDim2.new(0, padding - 20 + col*(btnWidth + spacing), 1, -padding - (row+1)*(btnHeight + spacing) + spacing)
    end
end

updateButtons()
frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateButtons)

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local TweenService = game:GetService("TweenService")

Players.PlayerRemoving:Connect(function(plr)
    if targetGlobal == plr.Name then
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 200, 0, 40)
        notif.Position = UDim2.new(1, 10, 1, -60)
        notif.AnchorPoint = Vector2.new(0,0)
        notif.BackgroundColor3 = Color3.fromRGB(0,0,0)
        notif.BackgroundTransparency = 0.3
        notif.Parent = gui

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1,0,1,0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "Target left"
        textLabel.TextColor3 = Color3.fromRGB(255,255,255)
        textLabel.TextSize = 18
        textLabel.Font = Enum.Font.Gotham
        textLabel.Parent = notif

        local tweenIn = TweenService:Create(
            notif,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(1, -210, 1, -60)}
        )
        tweenIn:Play()

        task.spawn(function()
            task.wait(3)
            local tweenOut = TweenService:Create(
                notif,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Position = UDim2.new(1, 10, 1, -60)}
            )
            tweenOut:Play()
            tweenOut.Completed:Wait()
            notif:Destroy()
        end)

        unbang(Players.LocalPlayer)
        StopStand()
        Unview()
        targetGlobal = nil

        username.Text = "Username :"
        display.Text = "Display :"
        avatar.Image = ""
        search.Text = ""

        local bangBtn = frame:FindFirstChild("ActionButton1")
        local unbangBtn = frame:FindFirstChild("ActionButton2")
        local standBtn = frame:FindFirstChild("ActionButton3")
        local viewBtn = frame:FindFirstChild("ActionButton4")

        if bangBtn then bangBtn.TextColor3 = Color3.fromRGB(255,255,255) end
        if unbangBtn then unbangBtn.TextColor3 = Color3.fromRGB(255,255,255) end
        if standBtn then standBtn.TextColor3 = Color3.fromRGB(255,255,255) end
        if viewBtn then viewBtn.TextColor3 = Color3.fromRGB(255,255,255) end
    end
end)


local function DetectLocalDeath(char)
	if standActive and targetGlobal then
		StopStand()
		task.wait(0.1)
		Stand(targetGlobal)
	end
end

Players.LocalPlayer.CharacterAdded:Connect(function(char)
    DetectLocalDeath(char)
end)

local function DetectTargetDeath(targetName)
    local target = Players:FindFirstChild(targetName)
    if not target then return end

    target.CharacterAdded:Connect(function()
        task.wait(0.2)
        if standActive and targetGlobal == targetName then
            Stand(targetName)
        end
    end)

    if target.Character then
        local hum = target.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.Died:Connect(function()
                print("target died")
            end)
        end
    end
end

search.FocusLost:Connect(function()
    local text = search.Text:lower()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():sub(1,#text) == text
        or plr.DisplayName:lower():sub(1,#text) == text then

			if plr == Players.LocalPlayer then
                print("Impossible de te target toi-même")
                return
            end

            username.Text = "username : @" .. plr.Name
            display.Text = "display : " .. plr.DisplayName
            SetTarget(plr.Name)
			DetectTargetDeath(plr.Name)

            local img = Players:GetUserThumbnailAsync(
                plr.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size420x420
            )
            avatar.Image = img
            break
        end
    end
end)

username.Font = Enum.Font.Gotham
display.Font = Enum.Font.Gotham
search.Font = Enum.Font.Gotham

username.TextSize = 14
display.TextSize = 14
search.TextSize = 14
openBtn.TextSize = 14

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = Color3.fromRGB(120,120,120)
avatarStroke.Thickness = 0.5
avatarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
avatarStroke.Parent = avatar

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = Color3.fromRGB(120,120,120)
searchStroke.Thickness = 0.5
searchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
searchStroke.Parent = search
