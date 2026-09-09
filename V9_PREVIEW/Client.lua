-- 599 AREA V9 PREVIEW UI ONLY
-- Separate from V8.5 stable. No gameplay features are executed here.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local old = pg:FindFirstChild("AREA599_V9_PREVIEW")
if old then old:Destroy() end

local C = {
    BG = Color3.fromRGB(8,8,14),
    PANEL = Color3.fromRGB(13,13,22),
    PANEL2 = Color3.fromRGB(20,20,32),
    PANEL3 = Color3.fromRGB(29,27,46),
    PURPLE = Color3.fromRGB(126,63,255),
    PURPLE2 = Color3.fromRGB(170,112,255),
    PURPLE3 = Color3.fromRGB(76,39,143),
    WHITE = Color3.fromRGB(246,243,255),
    MUTED = Color3.fromRGB(157,151,177),
    GREEN = Color3.fromRGB(71,215,144),
    RED = Color3.fromRGB(235,87,112),
}

local function corner(o,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 10)
    c.Parent=o
    return c
end

local function stroke(o,col,tr,th)
    local s=Instance.new("UIStroke")
    s.Color=col or C.PURPLE
    s.Transparency=tr==nil and .55 or tr
    s.Thickness=th or 1
    s.Parent=o
    return s
end

local function label(par,txt,pos,size,fs,col,bold)
    local t=Instance.new("TextLabel")
    t.BackgroundTransparency=1
    t.Text=txt
    t.Position=pos
    t.Size=size
    t.TextColor3=col or C.WHITE
    t.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextSize=fs or 12
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.TextYAlignment=Enum.TextYAlignment.Center
    t.Parent=par
    return t
end

local gui=Instance.new("ScreenGui")
gui.Name="AREA599_V9_PREVIEW"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=pg

local root=Instance.new("Frame")
root.Name="Root"
root.AnchorPoint=Vector2.new(.5,.5)
root.Position=UDim2.fromScale(.5,.5)
root.Size=UDim2.fromOffset(1040,650)
root.BackgroundColor3=C.BG
root.BorderSizePixel=0
root.ClipsDescendants=true
root.Parent=gui
corner(root,18)
stroke(root,C.PURPLE,.2,1.4)

local scale=Instance.new("UIScale")
scale.Parent=root
local function rescale()
    local cam=workspace.CurrentCamera
    if not cam then return end
    local s=cam.ViewportSize
    scale.Scale=math.clamp(math.min((s.X-30)/1040,(s.Y-30)/650),.55,1)
end
rescale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)

local glow=Instance.new("Frame")
glow.Size=UDim2.new(1,220,1,220)
glow.Position=UDim2.fromOffset(-110,-110)
glow.BackgroundColor3=C.PURPLE
nglow=glow
nglow.BackgroundTransparency=.92
nglow.BorderSizePixel=0
nglow.Parent=root
corner(nglow,300)

local top=Instance.new("Frame")
top.Name="TopBar"
top.Size=UDim2.new(1,0,0,82)
top.BackgroundColor3=Color3.fromRGB(10,10,18)
top.BackgroundTransparency=.08
top.BorderSizePixel=0
top.Active=true
top.Parent=root

local brandIcon=Instance.new("TextLabel")
brandIcon.Size=UDim2.fromOffset(44,44)
brandIcon.Position=UDim2.fromOffset(20,19)
brandIcon.BackgroundColor3=Color3.fromRGB(35,23,64)
brandIcon.Text="♛"
brandIcon.TextColor3=C.PURPLE2
brandIcon.TextSize=24
brandIcon.Font=Enum.Font.GothamBold
brandIcon.Parent=top
corner(brandIcon,12)
stroke(brandIcon,C.PURPLE,.2,1)

label(top,"599 AREA",UDim2.fromOffset(78,14),UDim2.fromOffset(240,30),24,C.WHITE,true)
label(top,"PREMIUM SCRIPT HUB • V9 PREVIEW",UDim2.fromOffset(80,43),UDim2.fromOffset(310,18),9,C.MUTED,true)

local minBtn=Instance.new("TextButton")
minBtn.Size=UDim2.fromOffset(34,34)
minBtn.Position=UDim2.new(1,-82,0,24)
minBtn.BackgroundColor3=C.PANEL2
minBtn.Text="—"
minBtn.TextColor3=C.WHITE
minBtn.Font=Enum.Font.GothamBold
minBtn.TextSize=17
minBtn.AutoButtonColor=false
minBtn.Parent=top
corner(minBtn,9)
stroke(minBtn,C.PURPLE,.55,1)

local closeBtn=minBtn:Clone()
closeBtn.Position=UDim2.new(1,-42,0,24)
closeBtn.Text="×"
closeBtn.Parent=top

local body=Instance.new("Frame")
body.Position=UDim2.fromOffset(0,82)
body.Size=UDim2.new(1,0,1,-82)
body.BackgroundTransparency=1
body.Parent=root

local sidebar=Instance.new("Frame")
sidebar.Size=UDim2.fromOffset(190,568)
sidebar.BackgroundColor3=Color3.fromRGB(10,10,18)
sidebar.BackgroundTransparency=.08
sidebar.BorderSizePixel=0
sidebar.Parent=body

local content=Instance.new("Frame")
content.Position=UDim2.fromOffset(190,0)
content.Size=UDim2.new(1,-190,1,0)
content.BackgroundTransparency=1
content.Parent=body

local tabs={}
local pages={}
local order={
    {"HOME","⌂"},{"MAIN","✦"},{"VISUALS","◉"},{"PLAYER","♙"},{"WORLD","◎"},{"ANIME DICE","🎲"},{"SETTINGS","⚙"},{"CREDITS","ⓘ"}
}

local function makePage(name)
    local p=Instance.new("Frame")
    p.Name=name
    p.Size=UDim2.fromScale(1,1)
    p.BackgroundTransparency=1
    p.Visible=false
    p.Parent=content
    pages[name]=p
    return p
end

for i,item in ipairs(order) do
    local name,ic=item[1],item[2]
    local b=Instance.new("TextButton")
    b.Size=UDim2.fromOffset(166,43)
    b.Position=UDim2.fromOffset(12,15+(i-1)*50)
    b.BackgroundColor3=Color3.fromRGB(14,14,24)
    b.BackgroundTransparency=.1
    b.BorderSizePixel=0
    b.Text=ic.."   "..name
    b.TextColor3=C.MUTED
    b.Font=Enum.Font.GothamSemibold
    b.TextSize=11
    b.TextXAlignment=Enum.TextXAlignment.Left
    b.AutoButtonColor=false
    b.Parent=sidebar
    corner(b,10)
    local pad=Instance.new("UIPadding")
    pad.PaddingLeft=UDim.new(0,14)
    pad.Parent=b
    tabs[name]=b
    makePage(name)
end

local profile=Instance.new("Frame")
profile.Size=UDim2.fromOffset(166,88)
profile.Position=UDim2.new(0,12,1,-100)
profile.BackgroundColor3=C.PANEL
profile.BackgroundTransparency=.05
profile.Parent=sidebar
corner(profile,12)
stroke(profile,C.PURPLE,.7,1)

local avatar=Instance.new("ImageLabel")
avatar.Size=UDim2.fromOffset(44,44)
avatar.Position=UDim2.fromOffset(10,12)
avatar.BackgroundColor3=C.PANEL3
avatar.BorderSizePixel=0
avatar.Parent=profile
corner(avatar,22)

task.spawn(function()
    local ok,img=pcall(function()
        return Players:GetUserThumbnailAsync(lp.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
    end)
    if ok then avatar.Image=img end
end)

label(profile,"Welcome,",UDim2.fromOffset(62,9),UDim2.fromOffset(90,16),9,C.MUTED,false)
label(profile,lp.DisplayName,UDim2.fromOffset(62,27),UDim2.fromOffset(96,18),11,C.WHITE,true)
label(profile,"Premium User",UDim2.fromOffset(62,48),UDim2.fromOffset(96,16),9,C.PURPLE2,true)

local function selectTab(name)
    for n,p in pairs(pages) do p.Visible=(n==name) end
    for n,b in pairs(tabs) do
        if n==name then
            b.BackgroundColor3=Color3.fromRGB(45,26,80)
            b.TextColor3=C.WHITE
            local s=b:FindFirstChildOfClass("UIStroke")
            if not s then s=stroke(b,C.PURPLE,.15,1) end
        else
            b.BackgroundColor3=Color3.fromRGB(14,14,24)
            b.TextColor3=C.MUTED
            local s=b:FindFirstChildOfClass("UIStroke")
            if s then s:Destroy() end
        end
    end
end

for name,b in pairs(tabs) do b.MouseButton1Click:Connect(function() selectTab(name) end) end

local function titleBlock(p,icon,title,desc)
    local ic=Instance.new("TextLabel")
    ic.Size=UDim2.fromOffset(48,48)
    ic.Position=UDim2.fromOffset(28,25)
    ic.BackgroundColor3=Color3.fromRGB(43,27,75)
    ic.Text=icon
    ic.TextColor3=C.PURPLE2
    ic.TextSize=21
    ic.Font=Enum.Font.GothamBold
    ic.Parent=p
    corner(ic,12)
    stroke(ic,C.PURPLE,.35,1)
    label(p,title,UDim2.fromOffset(88,24),UDim2.fromOffset(470,28),20,C.WHITE,true)
    label(p,desc,UDim2.fromOffset(88,50),UDim2.fromOffset(520,18),10,C.MUTED,false)
end

local function card(par,pos,size)
    local f=Instance.new("Frame")
    f.Position=pos
    f.Size=size
    f.BackgroundColor3=C.PANEL
    f.BackgroundTransparency=.03
    f.BorderSizePixel=0
    f.Parent=par
    corner(f,13)
    stroke(f,Color3.fromRGB(72,55,102),.55,1)
    return f
end

local function fauxToggle(par,text1,text2,y,on)
    local f=card(par,UDim2.fromOffset(22,y),UDim2.new(1,-44,0,58))
    label(f,text1,UDim2.fromOffset(14,7),UDim2.new(1,-110,0,20),11,C.WHITE,true)
    label(f,text2,UDim2.fromOffset(14,29),UDim2.new(1,-110,0,16),9,C.MUTED,false)
    local b=Instance.new("TextButton")
    b.Size=UDim2.fromOffset(48,24)
    b.Position=UDim2.new(1,-62,.5,-12)
    b.BackgroundColor3=on and C.PURPLE or Color3.fromRGB(45,43,58)
    b.Text=on and "ON" or "OFF"
    b.TextColor3=C.WHITE
    b.Font=Enum.Font.GothamBold
    b.TextSize=9
    b.AutoButtonColor=false
    b.Parent=f
    corner(b,12)
    b.MouseButton1Click:Connect(function()
        on=not on
        b.Text=on and "ON" or "OFF"
        TweenService:Create(b,TweenInfo.new(.15),{BackgroundColor3=on and C.PURPLE or Color3.fromRGB(45,43,58)}):Play()
    end)
end

-- HOME
local home=pages.HOME
titleBlock(home,"✦","599 AREA V9","A cleaner, smoother interface concept for the next generation.")
local hero=card(home,UDim2.fromOffset(28,105),UDim2.new(1,-56,0,205))
label(hero,"WELCOME BACK, "..string.upper(lp.DisplayName),UDim2.fromOffset(24,24),UDim2.new(1,-48,0,34),24,C.WHITE,true)
label(hero,"This preview is UI-only. Your current V8.5 stable build remains untouched.",UDim2.fromOffset(24,62),UDim2.new(1,-48,0,24),11,C.MUTED,false)
local badge=Instance.new("TextLabel")
badge.Size=UDim2.fromOffset(148,32)
badge.Position=UDim2.fromOffset(24,108)
badge.BackgroundColor3=Color3.fromRGB(46,27,78)
badge.Text="V9 • DESIGN PREVIEW"
badge.TextColor3=C.PURPLE2
badge.Font=Enum.Font.GothamBold
badge.TextSize=10
badge.Parent=hero
corner(badge,9)
stroke(badge,C.PURPLE,.45,1)
label(hero,"Smooth tabs  •  Compact cards  •  Purple neon  •  Cleaner spacing",UDim2.fromOffset(24,155),UDim2.new(1,-48,0,22),10,C.MUTED,false)

-- MAIN
local mainp=pages.MAIN
titleBlock(mainp,"✦","MAIN","Preview of the primary controls layout.")
fauxToggle(mainp,"Speed Boost","Adjust movement speed using a compact control.",104,true)
fauxToggle(mainp,"No Collision","Pass through local collision objects.",174,false)
fauxToggle(mainp,"Air Walk","Preview placement for aerial movement tools.",244,true)
fauxToggle(mainp,"Fly","Preview placement for flight controls.",314,false)

-- VISUALS
local vis=pages.VISUALS
titleBlock(vis,"◉","VISUALS","A cleaner stack for ESP and visual utilities.")
fauxToggle(vis,"ESP Players","Show player locations.",104,false)
fauxToggle(vis,"Box ESP","Draw boxes around players.",174,true)
fauxToggle(vis,"Skeleton ESP","Display body bone lines.",244,true)
fauxToggle(vis,"Name + Distance","Display player name and distance.",314,false)
fauxToggle(vis,"Full Bright","Brighten the local world.",384,true)

-- PLAYER
local player=pages.PLAYER
titleBlock(player,"♙","PLAYER","Search, inspect and manage player-focused tools.")
local pc=card(player,UDim2.fromOffset(28,110),UDim2.new(1,-56,0,140))
label(pc,"PLAYER SELECTOR",UDim2.fromOffset(18,14),UDim2.new(1,-36,0,22),11,C.PURPLE2,true)
label(pc,"This is a visual placeholder for the future player search list.",UDim2.fromOffset(18,42),UDim2.new(1,-36,0,22),10,C.MUTED,false)
local search=Instance.new("TextBox")
search.Size=UDim2.new(1,-36,0,42)
search.Position=UDim2.fromOffset(18,80)
search.BackgroundColor3=C.PANEL2
search.PlaceholderText="Search player..."
search.Text=""
search.TextColor3=C.WHITE
search.PlaceholderColor3=C.MUTED
search.Font=Enum.Font.Gotham
search.TextSize=11
search.ClearTextOnFocus=false
search.Parent=pc
corner(search,10)
stroke(search,C.PURPLE,.68,1)

-- WORLD
local world=pages.WORLD
titleBlock(world,"◎","WORLD","A dedicated clean area for world and skybox controls.")
fauxToggle(world,"Skybox Manager","Preview slot for saved skybox presets.",104,true)
fauxToggle(world,"Remove Fog","Preview local fog control.",174,false)
fauxToggle(world,"Time Override","Preview local time controls.",244,false)

-- ANIME DICE
local ad=pages["ANIME DICE"]
titleBlock(ad,"🎲","ANIME DICE","Auto Collect your income with a cleaner dedicated layout.")
local selectCard=card(ad,UDim2.fromOffset(28,108),UDim2.fromOffset(420,398))
label(selectCard,"SELECT PLOT",UDim2.fromOffset(18,14),UDim2.new(1,-36,0,24),12,C.WHITE,true)
label(selectCard,"Choose which plots to collect from.",UDim2.fromOffset(18,36),UDim2.new(1,-36,0,18),9,C.MUTED,false)
local chosen={}
for i=1,16 do
    chosen[i]=false
    local col=(i-1)%4
    local row=math.floor((i-1)/4)
    local b=Instance.new("TextButton")
    b.Size=UDim2.fromOffset(84,42)
    b.Position=UDim2.fromOffset(18+col*96,72+row*54)
    b.BackgroundColor3=C.PANEL2
    b.Text=tostring(i)
    b.TextColor3=C.WHITE
    b.Font=Enum.Font.GothamBold
    b.TextSize=12
    b.AutoButtonColor=false
    b.Parent=selectCard
    corner(b,9)
    stroke(b,Color3.fromRGB(68,58,88),.6,1)
    b.MouseButton1Click:Connect(function()
        chosen[i]=not chosen[i]
        TweenService:Create(b,TweenInfo.new(.16),{BackgroundColor3=chosen[i] and C.PURPLE or C.PANEL2}):Play()
    end)
end
local selAll=Instance.new("TextButton")
selAll.Size=UDim2.fromOffset(180,44)
selAll.Position=UDim2.fromOffset(18,302)
selAll.BackgroundColor3=C.PURPLE
selAll.Text="SELECT ALL"
selAll.TextColor3=C.WHITE
selAll.Font=Enum.Font.GothamBold
selAll.TextSize=10
selAll.Parent=selectCard
corner(selAll,10)
local clear=selAll:Clone()
clear.Position=UDim2.fromOffset(214,302)
clear.BackgroundColor3=C.PANEL2
clear.Text="CLEAR"
clear.Parent=selectCard

local settingsCard=card(ad,UDim2.fromOffset(466,108),UDim2.fromOffset(356,398))
label(settingsCard,"COLLECT SETTINGS",UDim2.fromOffset(18,14),UDim2.new(1,-36,0,24),12,C.WHITE,true)
label(settingsCard,"Set the delay between each collect cycle.",UDim2.fromOffset(18,36),UDim2.new(1,-36,0,18),9,C.MUTED,false)
local delay=label(settingsCard,"0.5",UDim2.fromOffset(18,76),UDim2.new(1,-36,0,38),28,C.WHITE,true)
delay.TextXAlignment=Enum.TextXAlignment.Center
local unit=label(settingsCard,"seconds",UDim2.fromOffset(18,109),UDim2.new(1,-36,0,16),9,C.MUTED,false)
unit.TextXAlignment=Enum.TextXAlignment.Center
local bar=Instance.new("Frame")
bar.Size=UDim2.new(1,-36,0,10)
bar.Position=UDim2.fromOffset(18,145)
bar.BackgroundColor3=Color3.fromRGB(45,43,62)
bar.BorderSizePixel=0
bar.Active=true
bar.Parent=settingsCard
corner(bar,5)
local fill=Instance.new("Frame")
fill.Size=UDim2.new(0,0,1,0)
fill.BackgroundColor3=C.PURPLE
fill.BorderSizePixel=0
fill.Parent=bar
corner(fill,5)
local knob=Instance.new("Frame")
knob.AnchorPoint=Vector2.new(.5,.5)
knob.Size=UDim2.fromOffset(20,20)
knob.Position=UDim2.new(0,0,.5,0)
knob.BackgroundColor3=C.PURPLE2
knob.BorderSizePixel=0
knob.Parent=bar
corner(knob,10)
label(settingsCard,"0.5s",UDim2.fromOffset(18,160),UDim2.fromOffset(70,16),9,C.MUTED,false)
local mx=label(settingsCard,"30s",UDim2.new(1,-88,0,160),UDim2.fromOffset(70,16),9,C.MUTED,false);mx.TextXAlignment=Enum.TextXAlignment.Right
local status=card(settingsCard,UDim2.fromOffset(18,202),UDim2.new(1,-36,0,62))
label(status,"STATUS",UDim2.fromOffset(14,8),UDim2.fromOffset(100,18),10,C.WHITE,true)
label(status,"Ready to start collecting...",UDim2.fromOffset(14,28),UDim2.new(1,-120,0,18),9,C.MUTED,false)
local stat=Instance.new("TextLabel")
stat.Size=UDim2.fromOffset(86,28)
stat.Position=UDim2.new(1,-100,.5,-14)
stat.BackgroundColor3=Color3.fromRGB(17,63,47)
stat.Text="STOPPED"
stat.TextColor3=C.GREEN
stat.Font=Enum.Font.GothamBold
stat.TextSize=9
stat.Parent=status
corner(stat,9)
local start=Instance.new("TextButton")
start.Size=UDim2.new(1,-36,0,52)
start.Position=UDim2.fromOffset(18,286)
start.BackgroundColor3=C.PURPLE
start.Text="▶   START AUTO COLLECT"
start.TextColor3=C.WHITE
start.Font=Enum.Font.GothamBold
start.TextSize=11
start.AutoButtonColor=false
start.Parent=settingsCard
corner(start,11)
stroke(start,C.PURPLE2,.15,1)

selAll.MouseButton1Click:Connect(function()
    for _,b in ipairs(selectCard:GetChildren()) do
        if b:IsA("TextButton") and tonumber(b.Text) then
            chosen[tonumber(b.Text)]=true
            TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=C.PURPLE}):Play()
        end
    end
end)
clear.MouseButton1Click:Connect(function()
    for _,b in ipairs(selectCard:GetChildren()) do
        if b:IsA("TextButton") and tonumber(b.Text) then
            chosen[tonumber(b.Text)]=false
            TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=C.PANEL2}):Play()
        end
    end
end)

local sliderDragging=false
local function sliderX(x)
    local w=bar.AbsoluteSize.X
    if w<=0 then return end
    local pct=math.clamp((x-bar.AbsolutePosition.X)/w,0,1)
    fill.Size=UDim2.new(pct,0,1,0)
    knob.Position=UDim2.new(pct,0,.5,0)
    local v=math.floor((.5+(29.5*pct))*10+.5)/10
    delay.Text=string.format("%.1f",v)
end
bar.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliderDragging=true sliderX(i.Position.X) end
end)

local running=false
start.MouseButton1Click:Connect(function()
    running=not running
    start.Text=running and "■   STOP AUTO COLLECT" or "▶   START AUTO COLLECT"
    stat.Text=running and "RUNNING" or "STOPPED"
    stat.TextColor3=running and C.WHITE or C.GREEN
    TweenService:Create(stat,TweenInfo.new(.16),{BackgroundColor3=running and C.PURPLE3 or Color3.fromRGB(17,63,47)}):Play()
end)

-- SETTINGS
local sett=pages.SETTINGS
titleBlock(sett,"⚙","SETTINGS","Customize how the V9 interface feels.")
fauxToggle(sett,"Smooth Animations","Enable subtle tab and button motion.",104,true)
fauxToggle(sett,"Compact Mode","Reduce vertical spacing for smaller screens.",174,false)
fauxToggle(sett,"UI Sounds","Preview setting for future interface sounds.",244,false)
fauxToggle(sett,"Remember Last Tab","Preview persistent UI preference.",314,true)

-- CREDITS
local cr=pages.CREDITS
titleBlock(cr,"ⓘ","CREDITS","599 AREA • UI concept preview")
local cc=card(cr,UDim2.fromOffset(28,110),UDim2.new(1,-56,0,190))
label(cc,"599 AREA",UDim2.fromOffset(24,20),UDim2.new(1,-48,0,34),24,C.WHITE,true)
label(cc,"Designed as a separate V9 preview so the stable V8.5 build stays untouched.",UDim2.fromOffset(24,62),UDim2.new(1,-48,0,24),10,C.MUTED,false)
label(cc,"BY MINUTZ",UDim2.fromOffset(24,120),UDim2.new(1,-48,0,24),12,C.PURPLE2,true)

selectTab("ANIME DICE")

-- Smooth drag from top bar
local dragging=false
local dragStart
local startPos
local currentTween

top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPos=root.Position
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then sliderX(input.Position.X) end
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local d=input.Position-dragStart
        local target=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        if currentTween then currentTween:Cancel() end
        currentTween=TweenService:Create(root,TweenInfo.new(.06,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=target})
        currentTween:Play()
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliderDragging=false end
end)

-- Minimize into compact bar
local minimized=false
local normalSize=root.Size
minBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    if minimized then
        body.Visible=false
        minBtn.Text="+"
        TweenService:Create(root,TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(1040,82)}):Play()
    else
        minBtn.Text="—"
        local tw=TweenService:Create(root,TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=normalSize})
        tw:Play()
        tw.Completed:Once(function() if not minimized then body.Visible=true end end)
    end
end)

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
