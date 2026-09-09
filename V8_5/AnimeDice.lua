-- 599 AREA V8.5 - ANIME DICE TAB
-- Integrated 16-plot auto collect with 0.5s-30s delay control.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local base = pg:WaitForChild("AREA599_V8", 10)
if not base then warn("[599 Anime Dice] base GUI missing") return end

local visualPage = base:FindFirstChild("VISUALS", true)
if not visualPage or not visualPage.Parent then
    warn("[599 Anime Dice] content container missing")
    return
end

local content = visualPage.Parent
local sidebar
for _, d in ipairs(base:GetDescendants()) do
    if d:IsA("TextButton") and string.find(d.Text or "", "SETTINGS", 1, true) then
        sidebar = d.Parent
        break
    end
end
if not sidebar then warn("[599 Anime Dice] sidebar missing") return end

local ORANGE = Color3.fromRGB(255,92,0)
local ORANGE2 = Color3.fromRGB(255,145,35)
local WHITE = Color3.fromRGB(245,245,247)
local MUTED = Color3.fromRGB(155,155,168)
local PANEL = Color3.fromRGB(16,16,20)
local PANEL3 = Color3.fromRGB(22,22,27)
local GREEN = Color3.fromRGB(48,185,87)
local RED = Color3.fromRGB(235,55,65)
local STROKE = Color3.fromRGB(111,51,15)

local function corner(o,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 8)
    c.Parent=o
    return c
end

local function outline(o,col,tr,th)
    local s=Instance.new("UIStroke")
    s.Color=col or STROKE
    s.Transparency=tr==nil and .45 or tr
    s.Thickness=th or 1
    s.Parent=o
    return s
end

local function label(par,txt,pos,sz,col,bold,fs)
    local x=Instance.new("TextLabel")
    x.BackgroundTransparency=1
    x.Text=txt
    x.Position=pos
    x.Size=sz
    x.TextColor3=col or WHITE
    x.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    x.TextSize=fs or 11
    x.TextXAlignment=Enum.TextXAlignment.Left
    x.TextYAlignment=Enum.TextYAlignment.Center
    x.Parent=par
    return x
end

local function panel(par,size,pos)
    local f=Instance.new("Frame")
    f.Size=size
    f.Position=pos
    f.BackgroundColor3=PANEL
    f.BackgroundTransparency=.04
    f.BorderSizePixel=0
    f.ZIndex=6
    f.Parent=par
    corner(f,10)
    outline(f,STROKE,.35,1)
    return f
end

local function notify(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification",{Title="599 AREA • ANIME DICE",Text=msg,Duration=2})
    end)
end

-- Remove an older injected Anime Dice page/tab if this module is rerun.
local oldPage = content:FindFirstChild("ANIME DICE")
if oldPage then oldPage:Destroy() end
local oldTab = sidebar:FindFirstChild("AnimeDiceTab")
if oldTab then oldTab:Destroy() end

-- New sidebar tab (9th slot; base sidebar has room for it).
local tab = Instance.new("TextButton")
tab.Name = "AnimeDiceTab"
tab.Size = UDim2.new(1,-18,0,48)
tab.Position = UDim2.fromOffset(9,449)
tab.BackgroundColor3 = PANEL
tab.Text = "🎲   ANIME DICE"
tab.TextColor3 = MUTED
tab.Font = Enum.Font.GothamSemibold
tab.TextSize = 12
tab.TextXAlignment = Enum.TextXAlignment.Left
tab.AutoButtonColor = false
tab.ZIndex = 7
tab.Parent = sidebar
corner(tab,8)
local tabPad=Instance.new("UIPadding")
tabPad.PaddingLeft=UDim.new(0,14)
tabPad.Parent=tab

-- New page.
local page = Instance.new("Frame")
page.Name = "ANIME DICE"
page.Size = UDim2.fromScale(1,1)
page.BackgroundTransparency = 1
page.Visible = false
page.ZIndex = 5
page.Parent = content

local title = label(page,"🎲  ANIME DICE",UDim2.fromOffset(4,0),UDim2.new(1,0,0,30),ORANGE,true,18)
title.ZIndex=7
label(page,"AUTO COLLECT • 16 PLOTS",UDim2.fromOffset(4,28),UDim2.fromOffset(320,20),MUTED,false,10).ZIndex=7

local left = panel(page,UDim2.fromOffset(600,490),UDim2.fromOffset(0,58))
local right = panel(page,UDim2.fromOffset(340,490),UDim2.fromOffset(620,58))

label(left,"PLOT SELECTOR",UDim2.fromOffset(18,12),UDim2.fromOffset(250,24),WHITE,true,13).ZIndex=7
label(left,"Pilih plot yang ingin di-collect otomatis.",UDim2.fromOffset(18,36),UDim2.fromOffset(400,20),MUTED,false,10).ZIndex=7

local selected = {}
local plotButtons = {}
for i=1,16 do selected[i]=false end

local function setPlotVisual(i)
    local b=plotButtons[i]
    if not b then return end
    if selected[i] then
        b.BackgroundColor3=Color3.fromRGB(63,28,8)
        b.TextColor3=ORANGE2
        local st=b:FindFirstChild("SelectedStroke")
        if not st then
            st=Instance.new("UIStroke")
            st.Name="SelectedStroke"
            st.Color=ORANGE
            st.Transparency=.15
            st.Thickness=1
            st.Parent=b
        end
        b.Text="✓  PLOT "..i
    else
        b.BackgroundColor3=PANEL3
        b.TextColor3=WHITE
        local st=b:FindFirstChild("SelectedStroke")
        if st then st:Destroy() end
        b.Text="PLOT "..i
    end
end

for i=1,16 do
    local row=math.floor((i-1)/4)
    local col=(i-1)%4
    local b=Instance.new("TextButton")
    b.Size=UDim2.fromOffset(130,58)
    b.Position=UDim2.fromOffset(18 + col*142,72 + row*70)
    b.BackgroundColor3=PANEL3
    b.BorderSizePixel=0
    b.Text="PLOT "..i
    b.TextColor3=WHITE
    b.Font=Enum.Font.GothamBold
    b.TextSize=11
    b.AutoButtonColor=false
    b.ZIndex=7
    b.Parent=left
    corner(b,8)
    outline(b,STROKE,.48,1)
    plotButtons[i]=b
    b.MouseButton1Click:Connect(function()
        selected[i]=not selected[i]
        setPlotVisual(i)
    end)
end

local selectAll=Instance.new("TextButton")
selectAll.Size=UDim2.fromOffset(270,46)
selectAll.Position=UDim2.fromOffset(18,365)
selectAll.BackgroundColor3=Color3.fromRGB(63,28,8)
selectAll.BorderSizePixel=0
selectAll.Text="SELECT ALL"
selectAll.TextColor3=ORANGE2
selectAll.Font=Enum.Font.GothamBold
selectAll.TextSize=11
selectAll.AutoButtonColor=false
selectAll.ZIndex=7
selectAll.Parent=left
corner(selectAll,8)
outline(selectAll,ORANGE,.25,1)

local clearAll=selectAll:Clone()
clearAll.Position=UDim2.fromOffset(312,365)
clearAll.BackgroundColor3=PANEL3
clearAll.Text="CLEAR"
clearAll.TextColor3=WHITE
clearAll.Parent=left

selectAll.MouseButton1Click:Connect(function()
    for i=1,16 do selected[i]=true;setPlotVisual(i) end
end)
clearAll.MouseButton1Click:Connect(function()
    for i=1,16 do selected[i]=false;setPlotVisual(i) end
end)

local selectedCount=label(left,"0 / 16 PLOTS SELECTED",UDim2.fromOffset(18,430),UDim2.fromOffset(564,26),MUTED,true,10)
selectedCount.TextXAlignment=Enum.TextXAlignment.Center
selectedCount.ZIndex=7
local function refreshCount()
    local n=0
    for i=1,16 do if selected[i] then n=n+1 end end
    selectedCount.Text=n.." / 16 PLOTS SELECTED"
end
for i=1,16 do
    plotButtons[i].MouseButton1Click:Connect(refreshCount)
end
selectAll.MouseButton1Click:Connect(refreshCount)
clearAll.MouseButton1Click:Connect(refreshCount)

label(right,"AUTO COLLECT",UDim2.fromOffset(18,12),UDim2.fromOffset(250,24),WHITE,true,13).ZIndex=7
label(right,"Atur jeda collect dari 0.5 sampai 30 detik.",UDim2.fromOffset(18,36),UDim2.fromOffset(300,20),MUTED,false,10).ZIndex=7

local delay=0.5
local MIN_DELAY=0.5
local MAX_DELAY=30
local delayText=label(right,"COLLECT DELAY   0.5s",UDim2.fromOffset(18,82),UDim2.fromOffset(304,24),WHITE,true,11)
delayText.ZIndex=7

local bar=Instance.new("Frame")
bar.Size=UDim2.fromOffset(304,10)
bar.Position=UDim2.fromOffset(18,122)
bar.BackgroundColor3=Color3.fromRGB(47,47,55)
bar.BorderSizePixel=0
bar.Active=true
bar.ZIndex=7
bar.Parent=right
corner(bar,5)

local fill=Instance.new("Frame")
fill.Size=UDim2.new(0,0,1,0)
fill.BackgroundColor3=ORANGE
fill.BorderSizePixel=0
fill.ZIndex=8
fill.Parent=bar
corner(fill,5)

local knob=Instance.new("TextButton")
knob.Size=UDim2.fromOffset(20,20)
knob.AnchorPoint=Vector2.new(.5,.5)
knob.Position=UDim2.new(0,0,.5,0)
knob.BackgroundColor3=ORANGE2
knob.BorderSizePixel=0
knob.Text=""
knob.AutoButtonColor=false
knob.ZIndex=9
knob.Parent=bar
corner(knob,10)

local minT=label(right,"0.5s",UDim2.fromOffset(18,138),UDim2.fromOffset(70,18),MUTED,false,9)
minT.ZIndex=7
local maxT=label(right,"30s",UDim2.fromOffset(252,138),UDim2.fromOffset(70,18),MUTED,false,9)
maxT.TextXAlignment=Enum.TextXAlignment.Right
maxT.ZIndex=7

local sliderDragging=false
local function setSlider(x)
    local w=bar.AbsoluteSize.X
    if w<=0 then return end
    local pct=math.clamp((x-bar.AbsolutePosition.X)/w,0,1)
    delay=MIN_DELAY+(MAX_DELAY-MIN_DELAY)*pct
    delay=math.floor(delay*10+.5)/10
    fill.Size=UDim2.new(pct,0,1,0)
    knob.Position=UDim2.new(pct,0,.5,0)
    delayText.Text=string.format("COLLECT DELAY   %.1fs",delay)
end
bar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        sliderDragging=true
        setSlider(input.Position.X)
    end
end)
knob.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        sliderDragging=true
        setSlider(input.Position.X)
    end
end)
UIS.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        setSlider(input.Position.X)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        sliderDragging=false
    end
end)

local statusBox=panel(right,UDim2.fromOffset(304,90),UDim2.fromOffset(18,185))
local statusTitle=label(statusBox,"STATUS",UDim2.fromOffset(14,10),UDim2.fromOffset(100,20),MUTED,true,9)
statusTitle.ZIndex=7
local statusText=label(statusBox,"STOPPED",UDim2.fromOffset(14,34),UDim2.fromOffset(276,32),RED,true,18)
statusText.ZIndex=7

local running=false
local toggle=Instance.new("TextButton")
toggle.Size=UDim2.fromOffset(304,52)
toggle.Position=UDim2.fromOffset(18,295)
toggle.BackgroundColor3=Color3.fromRGB(63,28,8)
toggle.BorderSizePixel=0
toggle.Text="START AUTO COLLECT"
toggle.TextColor3=ORANGE2
toggle.Font=Enum.Font.GothamBold
toggle.TextSize=12
toggle.AutoButtonColor=false
toggle.ZIndex=7
toggle.Parent=right
corner(toggle,9)
outline(toggle,ORANGE,.2,1)

local info=label(right,"Remote: waiting for Anime Dice...",UDim2.fromOffset(18,365),UDim2.fromOffset(304,54),MUTED,false,10)
info.TextWrapped=true
info.TextYAlignment=Enum.TextYAlignment.Top
info.ZIndex=7

local function getRemote()
    local network=ReplicatedStorage:FindFirstChild("Network")
    local plotService=network and network:FindFirstChild("PlotService")
    local re=plotService and plotService:FindFirstChild("RE")
    local remote=re and re:FindFirstChild("CollectBalance")
    if remote and remote:IsA("RemoteEvent") then return remote end
    return nil
end

local remote=getRemote()
if remote then
    info.Text="Remote: PlotService.RE.CollectBalance ✓\nReady untuk Anime Dice."
    info.TextColor3=GREEN
else
    info.Text="Remote Anime Dice belum ditemukan.\nBuka game yang sesuai lalu tekan START."
end

local function updateRunVisual()
    if running then
        statusText.Text="RUNNING"
        statusText.TextColor3=GREEN
        toggle.Text="STOP AUTO COLLECT"
        toggle.BackgroundColor3=Color3.fromRGB(65,18,22)
        toggle.TextColor3=Color3.fromRGB(255,110,120)
    else
        statusText.Text="STOPPED"
        statusText.TextColor3=RED
        toggle.Text="START AUTO COLLECT"
        toggle.BackgroundColor3=Color3.fromRGB(63,28,8)
        toggle.TextColor3=ORANGE2
    end
end

toggle.MouseButton1Click:Connect(function()
    if not running then
        remote=getRemote()
        if not remote then
            notify("CollectBalance remote tidak ditemukan")
            return
        end
        local any=false
        for i=1,16 do if selected[i] then any=true break end end
        if not any then
            notify("Pilih minimal 1 plot dulu")
            return
        end
    end
    running=not running
    updateRunVisual()
    notify("Auto Collect "..(running and "ON" or "OFF"))
end)

-- Keep one lightweight loop; changing the slider takes effect on the next cycle.
task.spawn(function()
    while page.Parent do
        if running then
            remote=getRemote()
            if not remote then
                running=false
                updateRunVisual()
                info.Text="Remote CollectBalance hilang / tidak tersedia."
                info.TextColor3=RED
            else
                for i=1,16 do
                    if selected[i] and running then
                        pcall(function() remote:FireServer(i) end)
                        task.wait(.03)
                    end
                end
            end
        end
        task.wait(delay)
    end
end)

-- Integrate navigation with the original V8 tabs.
local function resetAnimeTabStyle()
    tab.BackgroundColor3=PANEL
    tab.TextColor3=MUTED
    local s=tab:FindFirstChild("AnimeActiveStroke")
    if s then s:Destroy() end
end

for _, d in ipairs(sidebar:GetChildren()) do
    if d:IsA("TextButton") and d~=tab then
        d.MouseButton1Click:Connect(function()
            page.Visible=false
            resetAnimeTabStyle()
        end)
    end
end

tab.MouseButton1Click:Connect(function()
    for _, p in ipairs(content:GetChildren()) do
        if p:IsA("Frame") then p.Visible=(p==page) end
    end
    for _, b in ipairs(sidebar:GetChildren()) do
        if b:IsA("TextButton") then
            b.BackgroundColor3=PANEL
            b.TextColor3=MUTED
            if b~=tab then
                local st=b:FindFirstChildOfClass("UIStroke")
                if st then st:Destroy() end
            end
        end
    end
    tab.BackgroundColor3=Color3.fromRGB(63,28,8)
    tab.TextColor3=ORANGE
    local st=tab:FindFirstChild("AnimeActiveStroke")
    if not st then
        st=Instance.new("UIStroke")
        st.Name="AnimeActiveStroke"
        st.Color=ORANGE
        st.Transparency=.2
        st.Thickness=1
        st.Parent=tab
    end
end)

notify("Anime Dice tab loaded")