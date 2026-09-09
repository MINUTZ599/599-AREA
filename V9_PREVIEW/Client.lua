-- 599 AREA V9 PREVIEW - NEON ANIME DASHBOARD
-- UI preview only. V8.5 stable remains untouched.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local old = pg:FindFirstChild("AREA599_V9_PREVIEW")
if old then old:Destroy() end

local C = {
    BG = Color3.fromRGB(5,5,10),
    SURFACE = Color3.fromRGB(9,9,17),
    SURFACE2 = Color3.fromRGB(13,13,24),
    SURFACE3 = Color3.fromRGB(19,17,34),
    PURPLE = Color3.fromRGB(139,70,255),
    PURPLE2 = Color3.fromRGB(188,124,255),
    PURPLE3 = Color3.fromRGB(77,38,145),
    WHITE = Color3.fromRGB(246,244,255),
    MUTED = Color3.fromRGB(158,151,185),
    MUTED2 = Color3.fromRGB(103,97,128),
    GREEN = Color3.fromRGB(64,226,156),
    RED = Color3.fromRGB(255,92,117),
    CYAN = Color3.fromRGB(89,220,255),
}

local function corner(o,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r or 12)
    c.Parent = o
    return c
end

local function stroke(o,col,tr,th)
    local s = Instance.new("UIStroke")
    s.Color = col or C.PURPLE
    s.Transparency = tr == nil and .6 or tr
    s.Thickness = th or 1
    s.Parent = o
    return s
end

local function label(par,txt,pos,size,fs,col,bold,align)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = txt
    t.Position = pos
    t.Size = size
    t.TextColor3 = col or C.WHITE
    t.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextSize = fs or 12
    t.TextXAlignment = align or Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.Parent = par
    return t
end

local function gradient(o,a,b,rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(a,b)
    g.Rotation = rot or 0
    g.Parent = o
    return g
end

local function card(par,pos,size)
    local f = Instance.new("Frame")
    f.Position = pos
    f.Size = size
    f.BackgroundColor3 = C.SURFACE2
    f.BackgroundTransparency = .04
    f.BorderSizePixel = 0
    f.Parent = par
    corner(f,14)
    stroke(f,Color3.fromRGB(88,58,139),.55,1)
    return f
end

local gui = Instance.new("ScreenGui")
gui.Name = "AREA599_V9_PREVIEW"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = pg

local shell = Instance.new("Frame")
shell.Name = "Shell"
shell.AnchorPoint = Vector2.new(.5,.5)
shell.Position = UDim2.fromScale(.5,.5)
shell.Size = UDim2.fromOffset(1250,760)
shell.BackgroundColor3 = C.BG
shell.BorderSizePixel = 0
shell.ClipsDescendants = true
shell.Parent = gui
corner(shell,20)
stroke(shell,C.PURPLE,.08,1.6)

local scale = Instance.new("UIScale")
scale.Parent = shell
local function rescale()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local s = cam.ViewportSize
    scale.Scale = math.clamp(math.min((s.X-24)/1250,(s.Y-24)/760),.5,1)
end
rescale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)

local glow1 = Instance.new("Frame")
glow1.Size = UDim2.fromOffset(520,520)
glow1.Position = UDim2.fromOffset(760,-250)
glow1.BackgroundColor3 = C.PURPLE
glow1.BackgroundTransparency = .93
glow1.BorderSizePixel = 0
glow1.Parent = shell
corner(glow1,260)

local glow2 = glow1:Clone()
glow2.Size = UDim2.fromOffset(420,420)
glow2.Position = UDim2.fromOffset(-170,500)
glow2.BackgroundColor3 = Color3.fromRGB(77,41,176)
glow2.Parent = shell

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromOffset(245,760)
sidebar.BackgroundColor3 = Color3.fromRGB(7,7,13)
sidebar.BackgroundTransparency = .01
sidebar.BorderSizePixel = 0
sidebar.Parent = shell

local sideLine = Instance.new("Frame")
sideLine.Size = UDim2.new(0,1,1,0)
sideLine.Position = UDim2.new(1,-1,0,0)
sideLine.BackgroundColor3 = Color3.fromRGB(50,34,79)
sideLine.BackgroundTransparency = .25
sideLine.BorderSizePixel = 0
sideLine.Parent = sidebar

local brandIcon = Instance.new("TextLabel")
brandIcon.Size = UDim2.fromOffset(46,46)
brandIcon.Position = UDim2.fromOffset(20,22)
brandIcon.BackgroundColor3 = Color3.fromRGB(32,19,60)
brandIcon.Text = "♛"
brandIcon.TextColor3 = C.PURPLE2
brandIcon.TextSize = 25
brandIcon.Font = Enum.Font.GothamBold
brandIcon.Parent = sidebar
corner(brandIcon,13)
stroke(brandIcon,C.PURPLE,.15,1)

label(sidebar,"599 AREA",UDim2.fromOffset(78,20),UDim2.fromOffset(145,27),24,C.WHITE,true)
label(sidebar,"PREMIUM SCRIPT HUB",UDim2.fromOffset(78,49),UDim2.fromOffset(150,16),9,C.PURPLE2,true)
label(sidebar,"FOR ROBLOX",UDim2.fromOffset(78,64),UDim2.fromOffset(110,15),9,C.MUTED,true)

local tabs, pages = {}, {}
local tabData = {
    {"HOME","⌂","Dashboard"},
    {"MAIN","✦","General Features"},
    {"VISUALS","◉","Enhance Your Game"},
    {"PLAYER","♟","Player Utilities"},
    {"WORLD","◈","World & Maps"},
    {"ANIME DICE","◆","Auto Collect System"},
    {"SETTINGS","⚙","Customize UI"},
    {"CREDITS","ⓘ","Special Thanks"},
}

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(245,0)
content.Size = UDim2.new(1,-245,1,0)
content.BackgroundTransparency = 1
content.Parent = shell

for i,item in ipairs(tabData) do
    local name,ic,sub = item[1],item[2],item[3]
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(207,58)
    b.Position = UDim2.fromOffset(19,105+(i-1)*65)
    b.BackgroundColor3 = Color3.fromRGB(10,10,19)
    b.BackgroundTransparency = .04
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.Parent = sidebar
    corner(b,12)

    local ico = label(b,ic,UDim2.fromOffset(12,9),UDim2.fromOffset(40,40),19,C.PURPLE2,true,Enum.TextXAlignment.Center)
    local ttl = label(b,name,UDim2.fromOffset(58,8),UDim2.fromOffset(135,20),12,C.WHITE,true)
    local st = label(b,sub,UDim2.fromOffset(58,29),UDim2.fromOffset(138,18),9,C.MUTED,false)
    tabs[name] = {button=b, icon=ico, title=ttl, sub=st}

    local p = Instance.new("Frame")
    p.Name = name
    p.Size = UDim2.fromScale(1,1)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = content
    pages[name] = p
end

local profile = Instance.new("Frame")
profile.Size = UDim2.fromOffset(207,116)
profile.Position = UDim2.new(0,19,1,-134)
profile.BackgroundColor3 = C.SURFACE
profile.BackgroundTransparency = .02
profile.Parent = sidebar
corner(profile,14)
stroke(profile,C.PURPLE,.68,1)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.fromOffset(48,48)
avatar.Position = UDim2.fromOffset(13,14)
avatar.BackgroundColor3 = C.SURFACE3
avatar.BorderSizePixel = 0
avatar.Parent = profile
corner(avatar,24)
stroke(avatar,C.PURPLE,.2,1)

task.spawn(function()
    local ok,img = pcall(function()
        return Players:GetUserThumbnailAsync(lp.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
    end)
    if ok then avatar.Image = img end
end)

label(profile,"Welcome,",UDim2.fromOffset(71,12),UDim2.fromOffset(118,16),9,C.MUTED,false)
label(profile,lp.DisplayName,UDim2.fromOffset(71,31),UDim2.fromOffset(123,20),12,C.WHITE,true)
label(profile,"Premium User",UDim2.fromOffset(71,52),UDim2.fromOffset(120,16),9,C.PURPLE2,true)
label(profile,'“Good Scripts\nMake The Game More Fun.”',UDim2.fromOffset(13,72),UDim2.fromOffset(178,31),9,C.MUTED,false)

local function selectTab(name)
    for n,p in pairs(pages) do p.Visible = (n==name) end
    for n,t in pairs(tabs) do
        local active = n==name
        if active then
            t.button.BackgroundColor3 = Color3.fromRGB(40,22,72)
            t.button.BackgroundTransparency = 0
            t.title.TextColor3 = C.WHITE
            t.sub.TextColor3 = C.PURPLE2
            t.icon.TextColor3 = C.WHITE
            if not t.button:FindFirstChild("ActiveStroke") then
                local s = stroke(t.button,C.PURPLE,.05,1.2)
                s.Name = "ActiveStroke"
            end
        else
            t.button.BackgroundColor3 = Color3.fromRGB(10,10,19)
            t.button.BackgroundTransparency = .04
            t.title.TextColor3 = C.WHITE
            t.sub.TextColor3 = C.MUTED
            t.icon.TextColor3 = C.PURPLE2
            local s=t.button:FindFirstChild("ActiveStroke")
            if s then s:Destroy() end
        end
    end
end

for name,t in pairs(tabs) do
    t.button.MouseButton1Click:Connect(function() selectTab(name) end)
end

local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,82)
top.BackgroundTransparency = 1
top.Active = true
top.Parent = content

local search = Instance.new("TextBox")
search.Size = UDim2.fromOffset(420,44)
search.Position = UDim2.fromOffset(24,19)
search.BackgroundColor3 = C.SURFACE
search.BackgroundTransparency = .05
search.Text = ""
search.PlaceholderText = "⌕   Search features, scripts, or games..."
search.PlaceholderColor3 = C.MUTED
search.TextColor3 = C.WHITE
search.Font = Enum.Font.Gotham
search.TextSize = 11
search.ClearTextOnFocus = false
search.Parent = top
corner(search,12)
stroke(search,Color3.fromRGB(71,49,105),.45,1)

local clockBox = card(top,UDim2.new(1,-312,0,18),UDim2.fromOffset(135,46))
local clockText = label(clockBox,"--:--:--",UDim2.fromOffset(12,4),UDim2.new(1,-24,0,19),12,C.WHITE,true)
label(clockBox,"V9 PREVIEW",UDim2.fromOffset(12,23),UDim2.new(1,-24,0,16),8,C.MUTED,false)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.fromOffset(46,46)
minBtn.Position = UDim2.new(1,-158,0,18)
minBtn.BackgroundColor3 = C.SURFACE
minBtn.Text = "—"
minBtn.TextColor3 = C.WHITE
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.AutoButtonColor = false
minBtn.Parent = top
corner(minBtn,12)
stroke(minBtn,Color3.fromRGB(71,49,105),.45,1)

local maxBtn = minBtn:Clone()
maxBtn.Position = UDim2.new(1,-104,0,18)
maxBtn.Text = "□"
maxBtn.Parent = top

local closeBtn = minBtn:Clone()
closeBtn.Position = UDim2.new(1,-50,0,18)
closeBtn.Text = "×"
closeBtn.TextSize = 22
closeBtn.Parent = top

local ad = pages["ANIME DICE"]

local hero = card(ad,UDim2.fromOffset(24,92),UDim2.new(1,-48,0,150))
hero.BackgroundColor3 = Color3.fromRGB(10,8,18)
hero.ClipsDescendants = true

local heroGlow = Instance.new("Frame")
heroGlow.Size = UDim2.fromOffset(410,240)
heroGlow.Position = UDim2.new(1,-390,0,-55)
heroGlow.BackgroundColor3 = C.PURPLE
heroGlow.BackgroundTransparency = .86
heroGlow.BorderSizePixel = 0
heroGlow.Parent = hero
corner(heroGlow,160)

local heroImage = Instance.new("ImageLabel")
heroImage.Size = UDim2.fromOffset(485,150)
heroImage.Position = UDim2.new(1,-485,0,0)
heroImage.BackgroundTransparency = 1
heroImage.Image = "rbxassetid://126519323866401"
heroImage.ImageTransparency = .23
heroImage.ScaleType = Enum.ScaleType.Crop
heroImage.Parent = hero

local heroShade = Instance.new("Frame")
heroShade.Size = UDim2.fromScale(1,1)
heroShade.BackgroundColor3 = Color3.fromRGB(7,5,12)
heroShade.BackgroundTransparency = .34
heroShade.BorderSizePixel = 0
heroShade.Parent = hero
local hg = Instance.new("UIGradient")
hg.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,0),
    NumberSequenceKeypoint.new(.48,.15),
    NumberSequenceKeypoint.new(1,.76),
})
hg.Parent = heroShade

local diceIcon = Instance.new("TextLabel")
diceIcon.Size = UDim2.fromOffset(72,72)
diceIcon.Position = UDim2.fromOffset(28,28)
diceIcon.BackgroundColor3 = Color3.fromRGB(38,22,70)
diceIcon.Text = "◆"
diceIcon.TextColor3 = C.PURPLE2
diceIcon.TextSize = 31
diceIcon.Font = Enum.Font.GothamBold
diceIcon.Parent = hero
corner(diceIcon,18)
stroke(diceIcon,C.PURPLE,.1,1.2)

local animeTitle = label(hero,"ANIME DICE",UDim2.fromOffset(122,21),UDim2.fromOffset(400,36),28,C.WHITE,true)
animeTitle.RichText = true
animeTitle.Text = 'ANIME <font color="#A86BFF">DICE</font>'
label(hero,"Auto Collect Your Income Effortlessly.",UDim2.fromOffset(122,57),UDim2.fromOffset(430,22),13,C.PURPLE2,false)

local badgeTexts = {"⚡ Fast","◆ Clean","◉ Stable","▥ Efficient"}
for i,txt in ipairs(badgeTexts) do
    local b = Instance.new("TextLabel")
    b.Size = UDim2.fromOffset(82,26)
    b.Position = UDim2.fromOffset(122+(i-1)*90,92)
    b.BackgroundColor3 = Color3.fromRGB(19,15,31)
    b.Text = txt
    b.TextColor3 = C.WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.Parent = hero
    corner(b,13)
    stroke(b,Color3.fromRGB(91,60,133),.55,1)
end

label(hero,'“Let the dice roll,\nwhile you collect.”',UDim2.new(1,-212,0,42),UDim2.fromOffset(190,42),11,C.WHITE,false,Enum.TextXAlignment.Right)
label(hero,"- 599 AREA",UDim2.new(1,-212,0,87),UDim2.fromOffset(190,18),9,C.MUTED,false,Enum.TextXAlignment.Right)

local left = card(ad,UDim2.fromOffset(24,258),UDim2.fromOffset(500,390))
local right = card(ad,UDim2.fromOffset(540,258),UDim2.new(1,-564,0,390))

local leftIcon = label(left,"▦",UDim2.fromOffset(20,17),UDim2.fromOffset(42,42),20,C.PURPLE2,true,Enum.TextXAlignment.Center)
leftIcon.BackgroundTransparency = 0
leftIcon.BackgroundColor3 = Color3.fromRGB(34,22,60)
corner(leftIcon,10)
stroke(leftIcon,C.PURPLE,.25,1)
label(left,"SELECT PLOT",UDim2.fromOffset(76,15),UDim2.fromOffset(210,24),14,C.WHITE,true)
label(left,"Choose which plots to collect from.",UDim2.fromOffset(76,40),UDim2.fromOffset(260,18),10,C.MUTED,false)

local countBadge = Instance.new("TextLabel")
countBadge.Size = UDim2.fromOffset(118,34)
countBadge.Position = UDim2.new(1,-138,0,14)
countBadge.BackgroundColor3 = Color3.fromRGB(21,16,36)
countBadge.Text = "0 / 16 Selected"
countBadge.TextColor3 = C.PURPLE2
countBadge.Font = Enum.Font.GothamBold
countBadge.TextSize = 10
countBadge.Parent = left
corner(countBadge,10)
stroke(countBadge,C.PURPLE,.55,1)

local selected = {}
local plotButtons = {}
local function updateCount()
    local n=0
    for i=1,16 do if selected[i] then n+=1 end end
    countBadge.Text = string.format("%d / 16 Selected",n)
end
local function setPlot(i,on)
    selected[i]=on
    local b=plotButtons[i]
    b.BackgroundColor3 = on and Color3.fromRGB(116,49,244) or Color3.fromRGB(16,16,28)
    b.TextColor3 = on and C.WHITE or Color3.fromRGB(226,223,240)
    if on then
        if not b:FindFirstChild("SelGlow") then local s=stroke(b,C.PURPLE2,.1,1);s.Name="SelGlow" end
    else
        local s=b:FindFirstChild("SelGlow");if s then s:Destroy() end
    end
    updateCount()
end

for i=1,16 do
    local col=(i-1)%4
    local row=math.floor((i-1)/4)
    local b=Instance.new("TextButton")
    b.Size=UDim2.fromOffset(101,46)
    b.Position=UDim2.fromOffset(20+col*116,77+row*58)
    b.BackgroundColor3=Color3.fromRGB(16,16,28)
    b.Text=tostring(i)
    b.TextColor3=Color3.fromRGB(226,223,240)
    b.Font=Enum.Font.GothamBold
    b.TextSize=13
    b.AutoButtonColor=false
    b.Parent=left
    corner(b,10)
    stroke(b,Color3.fromRGB(67,52,91),.66,1)
    plotButtons[i]=b
    selected[i]=false
    b.MouseButton1Click:Connect(function() setPlot(i,not selected[i]) end)
end

local selectAll = Instance.new("TextButton")
selectAll.Size=UDim2.fromOffset(218,52)
selectAll.Position=UDim2.fromOffset(20,318)
selectAll.BackgroundColor3=C.PURPLE
selectAll.Text="▦   Select All"
selectAll.TextColor3=C.WHITE
selectAll.Font=Enum.Font.GothamBold
selectAll.TextSize=12
selectAll.AutoButtonColor=false
selectAll.Parent=left
corner(selectAll,11)
gradient(selectAll,Color3.fromRGB(129,57,255),Color3.fromRGB(104,41,224),0)
stroke(selectAll,C.PURPLE2,.1,1)

local clear = Instance.new("TextButton")
clear.Size=UDim2.fromOffset(218,52)
clear.Position=UDim2.fromOffset(252,318)
clear.BackgroundColor3=Color3.fromRGB(17,17,29)
clear.Text="⌫   Clear"
clear.TextColor3=C.WHITE
clear.Font=Enum.Font.GothamBold
clear.TextSize=12
clear.AutoButtonColor=false
clear.Parent=left
corner(clear,11)
stroke(clear,Color3.fromRGB(74,56,102),.5,1)

selectAll.MouseButton1Click:Connect(function() for i=1,16 do setPlot(i,true) end end)
clear.MouseButton1Click:Connect(function() for i=1,16 do setPlot(i,false) end end)

local rIcon = label(right,"◷",UDim2.fromOffset(20,17),UDim2.fromOffset(42,42),21,C.PURPLE2,true,Enum.TextXAlignment.Center)
rIcon.BackgroundTransparency=0
rIcon.BackgroundColor3=Color3.fromRGB(34,22,60)
corner(rIcon,10)
stroke(rIcon,C.PURPLE,.25,1)
label(right,"COLLECT SETTINGS",UDim2.fromOffset(76,15),UDim2.fromOffset(250,24),14,C.WHITE,true)
label(right,"Set the delay between each collection.",UDim2.fromOffset(76,40),UDim2.fromOffset(270,18),10,C.MUTED,false)

local rangeBadge=Instance.new("TextLabel")
rangeBadge.Size=UDim2.fromOffset(92,34)
rangeBadge.Position=UDim2.new(1,-112,0,14)
rangeBadge.BackgroundColor3=Color3.fromRGB(28,18,50)
rangeBadge.Text="0.5s - 30s"
rangeBadge.TextColor3=C.PURPLE2
rangeBadge.Font=Enum.Font.GothamBold
rangeBadge.TextSize=10
rangeBadge.Parent=right
corner(rangeBadge,10)
stroke(rangeBadge,C.PURPLE,.45,1)

local delay=0.5
local delayText=label(right,"0.5s",UDim2.fromOffset(0,77),UDim2.new(1,0,0,45),28,C.WHITE,true,Enum.TextXAlignment.Center)
local bar=Instance.new("Frame")
bar.Size=UDim2.new(1,-54,0,10)
bar.Position=UDim2.fromOffset(27,136)
bar.BackgroundColor3=Color3.fromRGB(48,44,68)
bar.BorderSizePixel=0
bar.Active=true
bar.Parent=right
corner(bar,5)
local fill=Instance.new("Frame")
fill.Size=UDim2.new(0,0,1,0)
fill.BackgroundColor3=C.PURPLE
fill.BorderSizePixel=0
fill.Parent=bar
corner(fill,5)
gradient(fill,Color3.fromRGB(192,107,255),Color3.fromRGB(126,55,255),0)
local knob=Instance.new("TextButton")
knob.Size=UDim2.fromOffset(22,22)
knob.AnchorPoint=Vector2.new(.5,.5)
knob.Position=UDim2.new(0,0,.5,0)
knob.BackgroundColor3=Color3.fromRGB(210,164,255)
knob.Text=""
knob.AutoButtonColor=false
knob.Parent=bar
corner(knob,11)
stroke(knob,Color3.fromRGB(255,255,255),.2,1)
label(right,"0.5s",UDim2.fromOffset(27,150),UDim2.fromOffset(50,18),9,C.PURPLE2,false)
label(right,"30s",UDim2.new(1,-77,0,150),UDim2.fromOffset(50,18),9,C.PURPLE2,false,Enum.TextXAlignment.Right)

local sliderDrag=false
local function sliderAt(x)
    local w=bar.AbsoluteSize.X
    if w<=0 then return end
    local pct=math.clamp((x-bar.AbsolutePosition.X)/w,0,1)
    delay=math.floor((0.5+29.5*pct)*10+0.5)/10
    fill.Size=UDim2.new(pct,0,1,0)
    knob.Position=UDim2.new(pct,0,.5,0)
    delayText.Text=string.format("%.1fs",delay)
end
bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliderDrag=true;sliderAt(i.Position.X) end end)
knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliderDrag=true;sliderAt(i.Position.X) end end)

local status=card(right,UDim2.fromOffset(18,184),UDim2.new(1,-36,0,84))
local statusIcon=label(status,"○",UDim2.fromOffset(16,17),UDim2.fromOffset(42,42),26,C.CYAN,true,Enum.TextXAlignment.Center)
statusIcon.BackgroundTransparency=0
statusIcon.BackgroundColor3=Color3.fromRGB(12,28,43)
corner(statusIcon,10)
stroke(statusIcon,C.CYAN,.2,1)
label(status,"STATUS",UDim2.fromOffset(72,16),UDim2.fromOffset(120,20),12,C.WHITE,true)
local statusSub=label(status,"Ready to start collecting...",UDim2.fromOffset(72,38),UDim2.fromOffset(210,18),9,C.MUTED,false)
local statusBadge=Instance.new("TextLabel")
statusBadge.Size=UDim2.fromOffset(108,36)
statusBadge.Position=UDim2.new(1,-124,.5,-18)
statusBadge.BackgroundColor3=Color3.fromRGB(55,20,31)
statusBadge.Text="■  Stopped"
statusBadge.TextColor3=C.RED
statusBadge.Font=Enum.Font.GothamBold
statusBadge.TextSize=10
statusBadge.Parent=status
corner(statusBadge,10)
stroke(statusBadge,C.RED,.55,1)

local startBtn=Instance.new("TextButton")
startBtn.Size=UDim2.new(1,-36,0,72)
startBtn.Position=UDim2.fromOffset(18,286)
startBtn.BackgroundColor3=C.PURPLE
startBtn.Text="▶   START AUTO COLLECT\n      Collect from selected plots automatically"
startBtn.TextColor3=C.WHITE
startBtn.Font=Enum.Font.GothamBold
startBtn.TextSize=13
startBtn.TextWrapped=true
startBtn.AutoButtonColor=false
startBtn.Parent=right
corner(startBtn,12)
gradient(startBtn,Color3.fromRGB(183,104,255),Color3.fromRGB(117,43,235),0)
stroke(startBtn,C.PURPLE2,.06,1.2)

local running=false
startBtn.MouseButton1Click:Connect(function()
    running=not running
    if running then
        statusBadge.Text="●  Running"
        statusBadge.TextColor3=C.GREEN
        statusBadge.BackgroundColor3=Color3.fromRGB(14,48,34)
        statusSub.Text="Preview mode running at "..string.format("%.1fs",delay).." delay"
        startBtn.Text="■   STOP AUTO COLLECT\n      Preview mode only"
    else
        statusBadge.Text="■  Stopped"
        statusBadge.TextColor3=C.RED
        statusBadge.BackgroundColor3=Color3.fromRGB(55,20,31)
        statusSub.Text="Ready to start collecting..."
        startBtn.Text="▶   START AUTO COLLECT\n      Collect from selected plots automatically"
    end
end)

local info=card(ad,UDim2.fromOffset(24,662),UDim2.new(1,-48,0,76))
local infoIcon=label(info,"ⓘ",UDim2.fromOffset(18,15),UDim2.fromOffset(42,42),18,C.PURPLE2,true,Enum.TextXAlignment.Center)
infoIcon.BackgroundTransparency=0
infoIcon.BackgroundColor3=Color3.fromRGB(25,19,45)
corner(infoIcon,10)
label(info,"INFORMATION",UDim2.fromOffset(76,14),UDim2.fromOffset(170,20),11,C.WHITE,true)
label(info,"Select the plots you want, set the delay, then start auto collect. This V9 build is still UI preview only.",UDim2.fromOffset(76,36),UDim2.new(1,-270,0,18),9,C.MUTED,false)
label(info,"SIMPLE   MODERN   CLEAN   BEAUTIFUL",UDim2.new(1,-312,0,19),UDim2.fromOffset(280,18),9,C.MUTED,true,Enum.TextXAlignment.Right)
label(info,"- 599 AREA",UDim2.new(1,-312,0,38),UDim2.fromOffset(280,18),8,C.MUTED2,false,Enum.TextXAlignment.Right)

local function pageHeader(p,ic,title,sub)
    local h=card(p,UDim2.fromOffset(24,92),UDim2.new(1,-48,0,120))
    local box=label(h,ic,UDim2.fromOffset(22,24),UDim2.fromOffset(56,56),24,C.PURPLE2,true,Enum.TextXAlignment.Center)
    box.BackgroundTransparency=0;box.BackgroundColor3=Color3.fromRGB(31,20,57);corner(box,14);stroke(box,C.PURPLE,.3,1)
    label(h,title,UDim2.fromOffset(96,23),UDim2.fromOffset(400,28),22,C.WHITE,true)
    label(h,sub,UDim2.fromOffset(96,55),UDim2.fromOffset(620,20),10,C.MUTED,false)
end
for _,d in ipairs({
    {"HOME","⌂","HOME","Welcome to the next visual direction for 599 AREA."},
    {"MAIN","✦","MAIN","General features will be migrated here after the UI is approved."},
    {"VISUALS","◉","VISUALS","A cleaner home for ESP, tracker and visual utilities."},
    {"PLAYER","♟","PLAYER","Player tools and targeting controls will live here."},
    {"WORLD","◈","WORLD","World, skybox and environment tools will live here."},
    {"SETTINGS","⚙","SETTINGS","Theme, transparency, sounds and interface behavior."},
    {"CREDITS","ⓘ","CREDITS","599 AREA • V9 PREVIEW • BY MINUTZ"},
}) do pageHeader(pages[d[1]],d[2],d[3],d[4]) end

RunService.RenderStepped:Connect(function()
    clockText.Text = os.date("%H:%M:%S")
end)

local dragging=false
local dragInput
local dragStart
local startPos
local dragTween

top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        if input.Position.X > search.AbsolutePosition.X and input.Position.X < search.AbsolutePosition.X+search.AbsoluteSize.X then return end
        dragging=true
        dragStart=input.Position
        startPos=shell.Position
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end)
top.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)

UIS.InputChanged:Connect(function(input)
    if sliderDrag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then sliderAt(input.Position.X) end
    if dragging and input==dragInput then
        local d=input.Position-dragStart
        local target=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        if dragTween then dragTween:Cancel() end
        dragTween=TweenService:Create(shell,TweenInfo.new(.07,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=target})
        dragTween:Play()
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliderDrag=false end
end)

local minimized=false
local fullSize=shell.Size
local function setMinimized(on)
    minimized=on
    if on then
        content.Visible=false
        sidebar.Visible=false
        TweenService:Create(shell,TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(245,70)}):Play()
        minBtn.Text="+"
    else
        local tw=TweenService:Create(shell,TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=fullSize})
        tw:Play();tw.Completed:Once(function() if not minimized then sidebar.Visible=true;content.Visible=true end end)
        minBtn.Text="—"
    end
end
minBtn.MouseButton1Click:Connect(function() setMinimized(not minimized) end)
maxBtn.MouseButton1Click:Connect(function() setMinimized(false) end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

selectTab("ANIME DICE")
