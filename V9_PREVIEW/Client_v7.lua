-- 599 AREA V9 PREVIEW v7 - robust compact UI
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local old = guiParent:FindFirstChild("AREA599_V9_PREVIEW")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AREA599_V9_PREVIEW"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = guiParent

local root = Instance.new("Frame")
root.Name = "Root"
root.AnchorPoint = Vector2.new(0.5,0.5)
root.Position = UDim2.fromScale(0.5,0.5)
root.Size = UDim2.fromOffset(980,620)
root.BackgroundColor3 = Color3.fromRGB(6,6,12)
root.BorderSizePixel = 0
root.ClipsDescendants = true
root.Parent = gui
Instance.new("UICorner",root).CornerRadius = UDim.new(0,16)
local rootStroke = Instance.new("UIStroke",root)
rootStroke.Color = Color3.fromRGB(137,66,255)
rootStroke.Thickness = 1.4

local scale = Instance.new("UIScale",root)
local function resize()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local s = cam.ViewportSize
    scale.Scale = math.clamp(math.min((s.X-24)/980,(s.Y-24)/620),0.55,1)
end
resize()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
end

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromOffset(205,620)
sidebar.BackgroundColor3 = Color3.fromRGB(8,8,16)
sidebar.BorderSizePixel = 0
sidebar.Parent = root

local logoBox = Instance.new("Frame")
logoBox.Size = UDim2.fromOffset(44,44)
logoBox.Position = UDim2.fromOffset(15,15)
logoBox.BackgroundColor3 = Color3.fromRGB(45,23,83)
logoBox.BorderSizePixel = 0
logoBox.Parent = sidebar
Instance.new("UICorner",logoBox).CornerRadius = UDim.new(0,12)
local logoStroke = Instance.new("UIStroke",logoBox)
logoStroke.Color = Color3.fromRGB(175,104,255)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.fromScale(1,1)
logoText.BackgroundTransparency = 1
logoText.Text = "599"
logoText.TextColor3 = Color3.fromRGB(255,255,255)
logoText.Font = Enum.Font.GothamBlack
logoText.TextSize = 15
logoText.Parent = logoBox

local brand = Instance.new("TextLabel")
brand.Position = UDim2.fromOffset(70,13)
brand.Size = UDim2.fromOffset(120,25)
brand.BackgroundTransparency = 1
brand.Text = "599 AREA"
brand.TextColor3 = Color3.fromRGB(250,248,255)
brand.Font = Enum.Font.GothamBold
brand.TextSize = 20
brand.TextXAlignment = Enum.TextXAlignment.Left
brand.Parent = sidebar

local sub = Instance.new("TextLabel")
sub.Position = UDim2.fromOffset(70,38)
sub.Size = UDim2.fromOffset(125,25)
sub.BackgroundTransparency = 1
sub.Text = "PREMIUM SCRIPT HUB\nFOR ROBLOX"
sub.TextColor3 = Color3.fromRGB(183,120,255)
sub.Font = Enum.Font.Gotham
sub.TextSize = 8
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.TextYAlignment = Enum.TextYAlignment.Top
sub.Parent = sidebar

local pages = {}
local tabs = {}
local nav = {
    {"HOME","Home","Dashboard"},
    {"MAIN","Main","General Features"},
    {"VISUALS","Visuals","Enhance Your Game"},
    {"PLAYER","Player","Player Utilities"},
    {"WORLD","World","World & Maps"},
    {"ANIME DICE","Anime Dice","Auto Collect System"},
    {"SETTINGS","Settings","Customize UI"},
    {"CREDITS","Credits","Special Thanks"}
}

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(205,0)
content.Size = UDim2.new(1,-205,1,0)
content.BackgroundTransparency = 1
content.Parent = root

for i,item in ipairs(nav) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(177,46)
    b.Position = UDim2.fromOffset(14,78+(i-1)*51)
    b.BackgroundColor3 = Color3.fromRGB(12,12,22)
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.Parent = sidebar
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)

    local icon = Instance.new("TextLabel")
    icon.Position = UDim2.fromOffset(8,5)
    icon.Size = UDim2.fromOffset(34,34)
    icon.BackgroundColor3 = Color3.fromRGB(25,19,42)
    icon.Text = string.sub(item[2],1,1)
    icon.TextColor3 = Color3.fromRGB(191,124,255)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 14
    icon.Parent = b
    Instance.new("UICorner",icon).CornerRadius = UDim.new(0,9)

    local title = Instance.new("TextLabel")
    title.Position = UDim2.fromOffset(50,5)
    title.Size = UDim2.fromOffset(118,18)
    title.BackgroundTransparency = 1
    title.Text = item[2]
    title.TextColor3 = Color3.fromRGB(245,243,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 10
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = b

    local desc = Instance.new("TextLabel")
    desc.Position = UDim2.fromOffset(50,23)
    desc.Size = UDim2.fromOffset(120,15)
    desc.BackgroundTransparency = 1
    desc.Text = item[3]
    desc.TextColor3 = Color3.fromRGB(145,139,168)
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 7
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = b

    tabs[item[1]] = {button=b,icon=icon,desc=desc}

    local page = Instance.new("Frame")
    page.Name = item[1]
    page.Size = UDim2.fromScale(1,1)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content
    pages[item[1]] = page
end

local profile = Instance.new("Frame")
profile.Size = UDim2.fromOffset(177,95)
profile.Position = UDim2.new(0,14,1,-109)
profile.BackgroundColor3 = Color3.fromRGB(11,11,21)
profile.BorderSizePixel = 0
profile.Parent = sidebar
Instance.new("UICorner",profile).CornerRadius = UDim.new(0,11)
local ps = Instance.new("UIStroke",profile)
ps.Color = Color3.fromRGB(80,50,120)
ps.Transparency = 0.45

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.fromOffset(38,38)
avatar.Position = UDim2.fromOffset(9,9)
avatar.BackgroundColor3 = Color3.fromRGB(25,20,39)
avatar.BorderSizePixel = 0
avatar.Parent = profile
Instance.new("UICorner",avatar).CornerRadius = UDim.new(1,0)
task.spawn(function()
    local ok,img = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
    end)
    if ok then avatar.Image = img end
end)

local welcome = Instance.new("TextLabel")
welcome.Position = UDim2.fromOffset(55,8)
welcome.Size = UDim2.fromOffset(112,42)
welcome.BackgroundTransparency = 1
welcome.Text = "Welcome,\n"..player.DisplayName.."\nPremium User"
welcome.TextColor3 = Color3.fromRGB(235,230,255)
welcome.Font = Enum.Font.Gotham
welcome.TextSize = 8
welcome.TextXAlignment = Enum.TextXAlignment.Left
welcome.TextYAlignment = Enum.TextYAlignment.Top
welcome.Parent = profile

local quote = Instance.new("TextLabel")
quote.Position = UDim2.fromOffset(9,54)
quote.Size = UDim2.fromOffset(159,33)
quote.BackgroundTransparency = 1
quote.Text = "Good Scripts Make The Game More Fun. - 599 AREA"
quote.TextWrapped = true
quote.TextColor3 = Color3.fromRGB(158,150,184)
quote.Font = Enum.Font.Gotham
quote.TextSize = 7
quote.TextXAlignment = Enum.TextXAlignment.Left
quote.Parent = profile

local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,64)
top.BackgroundTransparency = 1
top.Active = true
top.Parent = content

local search = Instance.new("TextBox")
search.Size = UDim2.fromOffset(350,36)
search.Position = UDim2.fromOffset(16,14)
search.BackgroundColor3 = Color3.fromRGB(11,11,21)
search.BorderSizePixel = 0
search.Text = ""
search.PlaceholderText = "Search features, scripts, or games..."
search.PlaceholderColor3 = Color3.fromRGB(145,139,168)
search.TextColor3 = Color3.fromRGB(245,243,255)
search.Font = Enum.Font.Gotham
search.TextSize = 9
search.ClearTextOnFocus = false
search.Parent = top
Instance.new("UICorner",search).CornerRadius = UDim.new(0,10)

local function windowButton(offset,label)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(36,36)
    b.Position = UDim2.new(1,offset,0,14)
    b.BackgroundColor3 = Color3.fromRGB(11,11,21)
    b.BorderSizePixel = 0
    b.Text = label
    b.TextColor3 = Color3.fromRGB(245,243,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.Parent = top
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)
    return b
end

local minBtn = windowButton(-128,"-")
local resetBtn = windowButton(-86,"O")
local closeBtn = windowButton(-44,"X")

local anime = pages["ANIME DICE"]

local hero = Instance.new("Frame")
hero.Position = UDim2.fromOffset(16,68)
hero.Size = UDim2.new(1,-32,0,112)
hero.BackgroundColor3 = Color3.fromRGB(10,8,19)
hero.BorderSizePixel = 0
hero.ClipsDescendants = true
hero.Parent = anime
Instance.new("UICorner",hero).CornerRadius = UDim.new(0,13)
local hs = Instance.new("UIStroke",hero)
hs.Color = Color3.fromRGB(86,53,130)
hs.Transparency = 0.25

local heroImage = Instance.new("ImageLabel")
heroImage.Size = UDim2.fromOffset(360,112)
heroImage.Position = UDim2.new(1,-360,0,0)
heroImage.BackgroundTransparency = 1
heroImage.Image = "rbxassetid://126519323866401"
heroImage.ImageTransparency = 0.25
heroImage.ScaleType = Enum.ScaleType.Crop
heroImage.Parent = hero

local heroTitle = Instance.new("TextLabel")
heroTitle.Position = UDim2.fromOffset(22,22)
heroTitle.Size = UDim2.fromOffset(290,26)
heroTitle.BackgroundTransparency = 1
heroTitle.Text = "ANIME DICE"
heroTitle.TextColor3 = Color3.fromRGB(245,243,255)
heroTitle.Font = Enum.Font.GothamBold
heroTitle.TextSize = 22
heroTitle.TextXAlignment = Enum.TextXAlignment.Left
heroTitle.Parent = hero

local heroSub = Instance.new("TextLabel")
heroSub.Position = UDim2.fromOffset(22,50)
heroSub.Size = UDim2.fromOffset(310,18)
heroSub.BackgroundTransparency = 1
heroSub.Text = "Auto Collect Your Income Effortlessly."
heroSub.TextColor3 = Color3.fromRGB(190,124,255)
heroSub.Font = Enum.Font.Gotham
heroSub.TextSize = 10
heroSub.TextXAlignment = Enum.TextXAlignment.Left
heroSub.Parent = hero

local badgeText = Instance.new("TextLabel")
badgeText.Position = UDim2.fromOffset(22,74)
badgeText.Size = UDim2.fromOffset(320,20)
badgeText.BackgroundTransparency = 1
badgeText.Text = "FAST   CLEAN   STABLE   EFFICIENT"
badgeText.TextColor3 = Color3.fromRGB(218,190,255)
badgeText.Font = Enum.Font.GothamSemibold
badgeText.TextSize = 8
badgeText.TextXAlignment = Enum.TextXAlignment.Left
badgeText.Parent = hero

local left = Instance.new("Frame")
left.Position = UDim2.fromOffset(16,194)
left.Size = UDim2.fromOffset(365,322)
left.BackgroundColor3 = Color3.fromRGB(10,10,20)
left.BorderSizePixel = 0
left.Parent = anime
Instance.new("UICorner",left).CornerRadius = UDim.new(0,12)
local ls = Instance.new("UIStroke",left);ls.Color=Color3.fromRGB(75,48,112);ls.Transparency=.35

local right = Instance.new("Frame")
right.Position = UDim2.fromOffset(393,194)
right.Size = UDim2.new(1,-409,0,322)
right.BackgroundColor3 = Color3.fromRGB(10,10,20)
right.BorderSizePixel = 0
right.Parent = anime
Instance.new("UICorner",right).CornerRadius = UDim.new(0,12)
local rs = Instance.new("UIStroke",right);rs.Color=Color3.fromRGB(75,48,112);rs.Transparency=.35

local leftTitle = Instance.new("TextLabel")
leftTitle.Position = UDim2.fromOffset(16,12)
leftTitle.Size = UDim2.fromOffset(230,30)
leftTitle.BackgroundTransparency = 1
leftTitle.Text = "SELECT PLOT\nChoose which plots to collect from."
leftTitle.TextColor3 = Color3.fromRGB(240,237,255)
leftTitle.Font = Enum.Font.GothamBold
leftTitle.TextSize = 10
leftTitle.TextXAlignment = Enum.TextXAlignment.Left
leftTitle.TextYAlignment = Enum.TextYAlignment.Top
leftTitle.Parent = left

local selected = {}
local plotButtons = {}
for i=1,16 do
    local col = (i-1)%4
    local row = math.floor((i-1)/4)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(76,38)
    b.Position = UDim2.fromOffset(16+col*84,62+row*45)
    b.BackgroundColor3 = Color3.fromRGB(18,18,31)
    b.BorderSizePixel = 0
    b.Text = tostring(i)
    b.TextColor3 = Color3.fromRGB(245,243,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.AutoButtonColor = false
    b.Parent = left
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
    plotButtons[i] = b
    b.MouseButton1Click:Connect(function()
        selected[i] = not selected[i]
        TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=selected[i] and Color3.fromRGB(135,60,255) or Color3.fromRGB(18,18,31)}):Play()
    end)
end

local allBtn = Instance.new("TextButton")
allBtn.Size = UDim2.fromOffset(158,40)
allBtn.Position = UDim2.fromOffset(16,254)
allBtn.BackgroundColor3 = Color3.fromRGB(135,60,255)
allBtn.Text = "SELECT ALL"
allBtn.TextColor3 = Color3.fromRGB(255,255,255)
allBtn.Font = Enum.Font.GothamBold
allBtn.TextSize = 9
allBtn.Parent = left
Instance.new("UICorner",allBtn).CornerRadius = UDim.new(0,9)

local clearBtn = allBtn:Clone()
clearBtn.Position = UDim2.fromOffset(190,254)
clearBtn.BackgroundColor3 = Color3.fromRGB(18,18,31)
clearBtn.Text = "CLEAR"
clearBtn.Parent = left

allBtn.MouseButton1Click:Connect(function()
    for i=1,16 do selected[i]=true;plotButtons[i].BackgroundColor3=Color3.fromRGB(135,60,255) end
end)
clearBtn.MouseButton1Click:Connect(function()
    for i=1,16 do selected[i]=false;plotButtons[i].BackgroundColor3=Color3.fromRGB(18,18,31) end
end)

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Position = UDim2.fromOffset(16,14)
settingsTitle.Size = UDim2.new(1,-32,0,36)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "COLLECT SETTINGS\nSet the delay between each collect."
settingsTitle.TextColor3 = Color3.fromRGB(240,237,255)
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 10
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.TextYAlignment = Enum.TextYAlignment.Top
settingsTitle.Parent = right

local delayText = Instance.new("TextLabel")
delayText.Position = UDim2.fromOffset(0,62)
delayText.Size = UDim2.new(1,0,0,34)
delayText.BackgroundTransparency = 1
delayText.Text = "0.5s"
delayText.TextColor3 = Color3.fromRGB(255,255,255)
delayText.Font = Enum.Font.GothamBold
delayText.TextSize = 23
delayText.Parent = right

local bar = Instance.new("Frame")
bar.Position = UDim2.fromOffset(18,108)
bar.Size = UDim2.new(1,-36,0,8)
bar.BackgroundColor3 = Color3.fromRGB(45,41,64)
bar.BorderSizePixel = 0
bar.Active = true
bar.Parent = right
Instance.new("UICorner",bar).CornerRadius = UDim.new(1,0)

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(145,70,255)
fill.BorderSizePixel = 0
fill.Parent = bar
Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0)

local sliderDragging = false
local function setSlider(x)
    local w = bar.AbsoluteSize.X
    if w <= 0 then return end
    local pct = math.clamp((x-bar.AbsolutePosition.X)/w,0,1)
    fill.Size = UDim2.new(pct,0,1,0)
    local v = 0.5 + 29.5*pct
    delayText.Text = string.format("%.1fs",math.floor(v*10+0.5)/10)
end
bar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        sliderDragging=true
        setSlider(input.Position.X)
    end
end)
UIS.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then setSlider(input.Position.X) end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliderDragging=false end
end)

local status = Instance.new("TextLabel")
status.Position = UDim2.fromOffset(18,145)
status.Size = UDim2.new(1,-36,0,36)
status.BackgroundColor3 = Color3.fromRGB(48,15,28)
status.Text = "STATUS: STOPPED"
status.TextColor3 = Color3.fromRGB(255,100,125)
status.Font = Enum.Font.GothamBold
status.TextSize = 9
status.Parent = right
Instance.new("UICorner",status).CornerRadius = UDim.new(0,9)

local startBtn = Instance.new("TextButton")
startBtn.Position = UDim2.fromOffset(18,196)
startBtn.Size = UDim2.new(1,-36,0,76)
startBtn.BackgroundColor3 = Color3.fromRGB(130,55,255)
startBtn.Text = "START AUTO COLLECT"
startBtn.TextColor3 = Color3.fromRGB(255,255,255)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 13
startBtn.Parent = right
Instance.new("UICorner",startBtn).CornerRadius = UDim.new(0,11)

local running = false
startBtn.MouseButton1Click:Connect(function()
    running = not running
    status.Text = running and "STATUS: RUNNING" or "STATUS: STOPPED"
    status.TextColor3 = running and Color3.fromRGB(90,255,165) or Color3.fromRGB(255,100,125)
    status.BackgroundColor3 = running and Color3.fromRGB(15,48,35) or Color3.fromRGB(48,15,28)
    startBtn.Text = running and "STOP AUTO COLLECT" or "START AUTO COLLECT"
end)

for _,name in ipairs({"HOME","MAIN","VISUALS","PLAYER","WORLD","SETTINGS","CREDITS"}) do
    local p = pages[name]
    local t = Instance.new("TextLabel")
    t.Position = UDim2.fromOffset(24,90)
    t.Size = UDim2.new(1,-48,0,70)
    t.BackgroundTransparency = 1
    t.Text = name.."\n599 AREA V9 PREVIEW"
    t.TextColor3 = Color3.fromRGB(245,243,255)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 18
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Top
    t.Parent = p
end

local function selectPage(name)
    for n,p in pairs(pages) do p.Visible = (n==name) end
    for n,data in pairs(tabs) do
        local active = n==name
        data.button.BackgroundColor3 = active and Color3.fromRGB(54,27,96) or Color3.fromRGB(12,12,22)
        data.icon.BackgroundColor3 = active and Color3.fromRGB(116,53,214) or Color3.fromRGB(25,19,42)
        data.desc.TextColor3 = active and Color3.fromRGB(191,124,255) or Color3.fromRGB(145,139,168)
    end
end
for name,data in pairs(tabs) do data.button.MouseButton1Click:Connect(function() selectPage(name) end) end
selectPage("ANIME DICE")

local dragging = false
local dragStart
local startPos
local dragInput

top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPos=root.Position
    end
end)
top.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input==dragInput then
        local delta=input.Position-dragStart
        root.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)

local minimized=false
minBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    root.Size=minimized and UDim2.fromOffset(980,64) or UDim2.fromOffset(980,620)
end)
resetBtn.MouseButton1Click:Connect(function() root.Position=UDim2.fromScale(0.5,0.5) end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
