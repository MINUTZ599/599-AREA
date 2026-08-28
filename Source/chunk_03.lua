lg599Gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(255,210,70)),
	ColorSequenceKeypoint.new(0.42,Color3.fromRGB(255,110,0)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(175,35,0)),
})
lg599Gradient.Rotation = 90
lg599Gradient.Parent = logo599

local logoGlow = text(header,"599",UDim2.fromOffset(288,70),UDim2.new(0.5,-146,0,-5),64,C.ORANGE,true)
logoGlow.Font = Enum.Font.Arcade
logoGlow.TextXAlignment = Enum.TextXAlignment.Center
logoGlow.TextTransparency = 0.78
logoGlow.TextStrokeColor3 = C.ORANGE
logoGlow.TextStrokeTransparency = 0.72
logoGlow.Rotation = -4
logoGlow.ZIndex = 6

local logoAreaShadow = text(header,"AREA",UDim2.fromOffset(270,48),UDim2.new(0.5,-131,0,55),42,Color3.fromRGB(15,15,15),true)
logoAreaShadow.Font = Enum.Font.SciFi
logoAreaShadow.TextXAlignment = Enum.TextXAlignment.Center
logoAreaShadow.TextStrokeColor3 = Color3.new(0,0,0)
logoAreaShadow.TextStrokeTransparency = 0
logoAreaShadow.Rotation = -2

local logoArea = text(header,"AREA",UDim2.fromOffset(270,48),UDim2.new(0.5,-135,0,51),42,C.WHITE,true)
logoArea.Font = Enum.Font.SciFi
logoArea.TextXAlignment = Enum.TextXAlignment.Center
logoArea.TextYAlignment = Enum.TextYAlignment.Center
logoArea.TextStrokeColor3 = Color3.new(0,0,0)
logoArea.TextStrokeTransparency = 0
logoArea.Rotation = -2
local lgAreaGradient = Instance.new("UIGradient")
lgAreaGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(0.55,Color3.fromRGB(215,215,215)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(120,120,120)),
})
lgAreaGradient.Rotation = 90
lgAreaGradient.Parent = logoArea

local logoSub = text(header,"V8  •  PREMIUM",UDim2.fromOffset(190,22),UDim2.new(0.5,-95,0,101),14,C.ORANGE2,true)
logoSub.Font = Enum.Font.GothamBlack
logoSub.TextXAlignment = Enum.TextXAlignment.Center
logoSub.TextStrokeColor3 = Color3.new(0,0,0)
logoSub.TextStrokeTransparency = 0.15

local logoLineL = Instance.new("Frame")
logoLineL.Size = UDim2.fromOffset(55,2)
logoLineL.Position = UDim2.new(0.5,-158,0,111)
logoLineL.BackgroundColor3 = C.ORANGE
logoLineL.BorderSizePixel = 0
logoLineL.ZIndex = 7
logoLineL.Rotation = -3
logoLineL.Parent = header
local logoLineR = logoLineL:Clone()
logoLineR.Position = UDim2.new(0.5,103,0,111)
logoLineR.Rotation = 3
logoLineR.Parent = header

-- small claw/slash accents around logo
for i = 1,3 do
	local slash = Instance.new("Frame")
	slash.Size = UDim2.fromOffset(32 - i*4,2)
	slash.Position = UDim2.new(0.5,-154 + i*6,0,80 + i*5)
	slash.BackgroundColor3 = C.ORANGE
	slash.BorderSizePixel = 0
	slash.Rotation = -18
	slash.ZIndex = 7
	slash.Parent = header
end

local statBox = panel(header,UDim2.fromOffset(170,90),UDim2.new(1,-230,0,18),7)
local statusText = text(statBox,"FPS: --\nPING: --\nTIME: --",UDim2.new(1,-20,1,-16),UDim2.fromOffset(12,8),12,C.WHITE,true)
statusText.TextYAlignment = Enum.TextYAlignment.Top

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.fromOffset(42,42)
minBtn.Position = UDim2.new(1,-55,0,20)
minBtn.BackgroundColor3 = C.PANEL3
minBtn.Text = "—"
minBtn.TextColor3 = C.ORANGE
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.ZIndex = 8
minBtn.Parent = header
round(minBtn,9)
outline(minBtn,C.ORANGE,0.15,1)

local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(1,-24,0,2)
accentLine.Position = UDim2.fromOffset(12,148)
accentLine.BackgroundColor3 = C.ORANGE
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 5
accentLine.Parent = main

local accentGradient = Instance.new("UIGradient")
accentGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(70,20,0)),
	ColorSequenceKeypoint.new(0.5, C.ORANGE),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(70,20,0)),
})
accentGradient.Parent = accentLine

