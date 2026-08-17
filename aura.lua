local P,S,C,H=game:GetService("Players"),true,game:GetService("CoreGui"),{}
if C:FindFirstChild("G")then C.G:Destroy()end
local G=Instance.new("ScreenGui",C)G.Name="G"
local F=Instance.new("Frame",G)F.Size,F.Position,F.BackgroundColor3,F.Active,F.Draggable=UDim2.new(0,140,0,75),UDim2.new(0.5,-70,0.1,0),Color3.fromRGB(35,35,35),true,true
Instance.new("UICorner",F).CornerRadius=UDim.new(0,8)
local L=Instance.new("TextLabel",F)L.Size,L.Position,L.BackgroundTransparency,L.Text,L.TextColor3,L.TextSize,L.Font=UDim2.new(1,0,0,25),UDim2.new(0,0,0,5),1,"Aura script",Color3.new(1,1,1),13,Enum.Font.SourceSansBold
local T=Instance.new("TextButton",F)T.Size,T.Position,T.BackgroundColor3,T.Text,T.TextColor3,T.TextSize,T.Font=UDim2.new(0.85,0,0,35),UDim2.new(0.075,0,0,32),Color3.fromRGB(0,170,0),"ON",Color3.new(1,1,1),14,Enum.Font.SourceSansBold
Instance.new("UICorner",T).CornerRadius=UDim.new(0,6)

local function A(v, Ch)
if not Ch then return end
if H[Ch] then 
    if typeof(H[Ch]) == "table" then
        if H[Ch][1] then H[Ch][1]:Destroy() end
        if H[Ch][2] then H[Ch][2]:Destroy() end
    else
        H[Ch]:Destroy() 
    end
    H[Ch]=nil 
end

local teamColor = (v.Team and v.Team.TeamColor and v.Team.TeamColor.Color) or Color3.new(1,1,1)

-- Remplissage rendu plus clair (mélange avec du blanc)
local fillColor = Color3.new(
    math.min(1, teamColor.R + (1 - teamColor.R) * 0.4),
    math.min(1, teamColor.G + (1 - teamColor.G) * 0.4),
    math.min(1, teamColor.B + (1 - teamColor.B) * 0.4)
)

local outCol
if teamColor.R > 0.9 and teamColor.G > 0.9 and teamColor.B > 0.9 then
outCol = Color3.new(0, 0, 0)
else
outCol = Color3.new(teamColor.R * 0.25, teamColor.G * 0.25, teamColor.B * 0.25)
end

local Hl1=Instance.new("Highlight")
Hl1.Adornee=Ch
Hl1.FillTransparency=1
Hl1.OutlineColor=outCol
Hl1.OutlineTransparency=0
Hl1.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
Hl1.Enabled=S
Hl1.Parent=Ch

local Hl2=Instance.new("Highlight")
Hl2.Adornee=Ch
Hl2.FillColor=fillColor
Hl2.FillTransparency=0.2
Hl2.OutlineColor=outCol
Hl2.OutlineTransparency=0
Hl2.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
Hl2.Enabled=S
Hl2.Parent=Ch

H[Ch]={Hl1, Hl2}
end

local function HookPlayer(v)
if v==P.LocalPlayer then return end
if v.Character then A(v, v.Character) end
v.CharacterAdded:Connect(function(Ch)
A(v, Ch)
end)
v:GetPropertyChangedSignal("Team"):Connect(function()
if v.Character then
A(v, v.Character)
end
end)
end

for _,v in ipairs(P:GetPlayers()) do
HookPlayer(v)
end

P.PlayerAdded:Connect(HookPlayer)

T.MouseButton1Click:Connect(function()
S=not S
T.Text,T.BackgroundColor3=S and"ON"or"OFF",S and Color3.fromRGB(0,170,0)or Color3.fromRGB(170,0,0)
for _,highlights in pairs(H) do
if highlights then
if typeof(highlights) == "table" then
if highlights[1] and highlights[1].Parent then highlights[1].Enabled=S end
if highlights[2] and highlights[2].Parent then highlights[2].Enabled=S end
elseif highlights and highlights.Parent then
highlights.Enabled=S
end
end
end
end)
