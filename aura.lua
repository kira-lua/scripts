local P,S,C,H=game:GetService("Players"),true,game:GetService("CoreGui"),{}
if C:FindFirstChild("G")then C.G:Destroy()end
local G=Instance.new("ScreenGui",C)G.Name="G"
local F=Instance.new("Frame",G)F.Size,F.Position,F.BackgroundColor3,F.Active,F.Draggable=UDim2.new(0,140,0,75),UDim2.new(0.5,-70,0.1,0),Color3.fromRGB(35,35,35),true,true
Instance.new("UICorner",F).CornerRadius=UDim.new(0,8)
local L=Instance.new("TextLabel",F)L.Size,L.Position,L.BackgroundTransparency,L.Text,L.TextColor3,L.TextSize,L.Font=UDim2.new(1,0,0,25),UDim2.new(0,0,0,5),1,"Aura script",Color3.new(1,1,1),13,Enum.Font.SourceSansBold
local T=Instance.new("TextButton",F)T.Size,T.Position,T.BackgroundColor3,T.Text,T.TextColor3,T.TextSize,T.Font=UDim2.new(0.85,0,0,35),UDim2.new(0.075,0,0,32),Color3.fromRGB(0,170,0),"ON",Color3.new(1,1,1),14,Enum.Font.SourceSansBold
Instance.new("UICorner",T).CornerRadius=UDim.new(0,6)

local function A(Ch)
if not Ch then return end
if H[Ch] then H[Ch]:Destroy() H[Ch]=nil end
local Hl=Instance.new("Highlight")
Hl.Adornee=Ch
Hl.FillColor=Color3.new(1,1,1)
Hl.FillTransparency=0
Hl.OutlineColor=Color3.new(0,0,0)
Hl.OutlineTransparency=0
Hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
Hl.Enabled=S
Hl.Parent=Ch
H[Ch]=Hl
end

local function HookPlayer(v)
if v==P.LocalPlayer then return end
if v.Character then A(v.Character) end
v.CharacterAdded:Connect(function(Ch)
A(Ch)
end)
end

for _,v in ipairs(P:GetPlayers()) do
HookPlayer(v)
end

P.PlayerAdded:Connect(HookPlayer)

T.MouseButton1Click:Connect(function()
S=not S
T.Text,T.BackgroundColor3=S and"ON"or"OFF",S and Color3.fromRGB(0,170,0)or Color3.fromRGB(170,0,0)
for _,v in pairs(H) do
if v and v.Parent then
v.Enabled=S
end
end
end)
