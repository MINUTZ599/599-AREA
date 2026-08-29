 = Enum.TextYAlignment.Center
	t.TextWrapped = false
	t.Parent = parent
	return t
end

local function panel(parent, size, pos, z)
	local f = Instance.new("Frame")
	f.Size = size
	f.Position = pos
	f.BackgroundColor3 = C.PANEL
	f.BackgroundTransparency = 0.08
	f.BorderSizePixel = 0
	f.ZIndex = z or 6
	f.Parent = parent
	round(f,10)
	outline(f,C.STROKE,0.35,1)
	return f
end

local notifBusy = false
local function notify(msg)
	if not notificationsEnabled then return end
	if notifBusy then
		local oldNotif = gui:FindFirstChild("_599Notif")
		if oldNotif then oldNotif:Destroy() end
	end
	notifBusy = true

	local n = Instance.new("Frame")
	n.Name = "_599Notif"
	n.Size = UDim2.fromOffset(300,48)
	n.Position = UDim2.new(1,20,1,-64)
	n.BackgroundColor3 = C.PANEL3
	n.BorderSizePixel = 0
	n.ZIndex = 100
	n.Parent = gui
	round(n,10)
	outline(n,C.ORANGE,0.15,1)

	local nt = text(n,msg,UDim2.new(1,-24,1,0),UDim2.fromOffset(12,0),12,C.WHITE,true)
	nt.ZIndex = 101

	TweenService:Create(n,TweenInfo.new(0.22),{Position=UDim2.new(1,-316,1,-64)}):Play()
	task.delay(1.7,function()
		if not n.Parent then return end
		TweenService:Create(n,TweenInfo.new(0.22),{Position=UDim2.new(1,20,1,-64)}):Play()
		task.wait(0.25)
		if n then n:Destroy() end
		notifBusy = false
	end)
end

--========================================================
-- HEADER
--========================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,150)
header.BackgroundTransparency = 1
header.ZIndex = 4
header.Parent = main

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.fromOffset(74,74)
avatar.Position = UDim2.fromOffset(18,18)
avatar.BackgroundColor3 = C.PANEL2
avatar.BorderSizePixel = 0
avatar.ZIndex = 7
avatar.Parent = header
round(avatar,37)
outline(avatar,C.ORANGE,0,2)

task.spawn(function()
	local ok,img = pcall(function()
		return Players:GetUserThumbnailAsync(lp.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
	end)
	if ok then avatar.Image = img end
end)

local brand = text(header,"",UDim2.fromOffset(310,40),UDim2.fromOffset(108,18),30,C.WHITE,true)
brand.RichText = true
brand.Font = Enum.Font.GothamBlack
brand.TextStrokeColor3 = Color3.new(0,0,0)
brand.TextStrokeTransparency = 0.35
brand.Text = '<font color="#F5F5F7">599 </font><font color="#FF6A00">AREA</font>'

local brandAccent = Instance.new("Frame")
brandAccent.Size = UDim2.fromOffset(118,3)
brandAccent.Position = UDim2.fromOffset(108,57)
brandAccent.BackgroundColor3 = C.ORANGE
brandAccent.BorderSizePixel = 0
brandAccent.ZIndex = 7
brandAccent.Parent = header
local bag = Instance.new("UIGradient")
bag.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.ORANGE),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(70,20,0)),
})
bag.Parent = brandAccent

text(header,"@"..lp.Name,UDim2.fromOffset(270,22),UDim2.fromOffset(108,62),12,C.MUTED,false)

local premium = Instance.new("TextLabel")
premium.Size = UDim2.fromOffset(145,25)
premium.Position = UDim2.fromOffset(108,84)
premium.BackgroundColor3 = Color3.fromRGB(39,21,7)
premium.Text = "★ 599 AREA V8.4 • PREMIUM"
premium.TextColor3 = C.ORANGE2
premium.Font = Enum.Font.GothamBold
premium.TextSize = 10
premium.ZIndex = 7
premium.Parent = header
round(premium,6)
outline(premium,C.ORANGE,0.25,1)

-- Stylized center logo: layered shadow + glow + gradients
local logoShadow599 = text(header,"599",UDim2.fromOffset(280,66),UDim2.new(0.5,-138,0,1),62,Color3.fromRGB(18,5,0),true)
logoShadow599.Font = Enum.Font.Arcade
logoShadow599.TextXAlignment = Enum.TextXAlignment.Center
logoShadow599.TextStrokeColor3 = Color3.new(0,0,0)
logoShadow599.TextStrokeTransparency = 0
logoShadow599.Rotation = -4

local logo599 = text(header,"599",UDim2.fromOffset(280,66),UDim2.new(0.5,-142,0,-3),62,C.ORANGE,true)
logo599.Font = Enum.Font.Arcade
logo599.TextXAlignment = Enum.TextXAlignment.Center
logo599.TextYAlignment = Enum.TextYAlignment.Center
logo599.TextStrokeColor3 = Color3.fromRGB(75,18,0)
logo599.TextStrokeTransparency = 0
logo599.Rotation = -4
local lg599Gradient = Instance.new("UIGradient")
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
accentLine.Backgr