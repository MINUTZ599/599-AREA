-- 599 AREA V9 PREVIEW - REFERENCE MATCH REBUILD
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
    BG=Color3.fromRGB(5,5,10), SURFACE=Color3.fromRGB(8,8,16), CARD=Color3.fromRGB(11,11,21),
    CARD2=Color3.fromRGB(15,14,28), PURPLE=Color3.fromRGB(136,64,255), PURPLE2=Color3.fromRGB(190,122,255),
    PURPLE3=Color3.fromRGB(73,32,142), WHITE=Color3.fromRGB(248,246,255), MUTED=Color3.fromRGB(157,151,182),
    GREEN=Color3.fromRGB(58,225,152), RED=Color3.fromRGB(255,91,118), CYAN=Color3.fromRGB(80,210,255)
}

local function corner(o,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 12); c.Parent=o; return c end
local function stroke(o,col,tr,th) local s=Instance.new("UIStroke"); s.Color=col or C.PURPLE; s.Transparency=tr or .55; s.Thickness=th or 1; s.Parent=o; return s end
local function txt(p,t,pos,size,fs,col,bold,align)
    local x=Instance.new("TextLabel"); x.BackgroundTransparency=1; x.Text=t; x.Position=pos; x.Size=size; x.TextColor3=col or C.WHITE
    x.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham; x.TextSize=fs or 12; x.TextXAlignment=align or Enum.TextXAlignment.Left
    x.TextYAlignment=Enum.TextYAlignment.Center; x.Parent=p; return x
end
local function card(p,pos,size)
    local f=Instance.new("Frame"); f.Position=pos; f.Size=size; f.BackgroundColor3=C.CARD; f.BackgroundTransparency=.02; f.BorderSizePixel=0; f.Parent=p
    corner(f,14); stroke(f,Color3.fromRGB(78,52,116),.45,1); return f
end
local function hover(b,normal,over)
    b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.14),{BackgroundColor3=over}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.14),{BackgroundColor3=normal}):Play() end)
end

local gui=Instance.new("ScreenGui")
gui.Name="AREA599_V9_PREVIEW"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.Parent=pg

local shell=Instance.new("Frame")
shell.AnchorPoint=Vector2.new(.5,.5); shell.Position=UDim2.fromScale(.5,.5); shell.Size=UDim2.fromOffset(1450,900)
shell.BackgroundColor3=C.BG; shell.BorderSizePixel=0; shell.ClipsDescendants=true; shell.Parent=gui; corner(shell,20); stroke(shell,C.PURPLE,.08,1.5)

local sc=Instance.new("UIScale"); sc.Parent=shell
local function rescale() local cam=workspace.CurrentCamera if not cam then return end local s=cam.ViewportSize sc.Scale=math.clamp(math.min((s.X-22)/1450,(s.Y-22)/900),.45,1) end
rescale(); workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)

-- ambient purple glow
for _,d in ipairs({{1050,-220,520},{-180,650,420},{700,760,360}}) do
    local g=Instance.new("Frame"); g.Size=UDim2.fromOffset(d[3],d[3]); g.Position=UDim2.fromOffset(d[1],d[2]); g.BackgroundColor3=C.PURPLE; g.BackgroundTransparency=.94; g.BorderSizePixel=0; g.Parent=shell; corner(g,d[3]/2)
end

-- SIDEBAR
local side=Instance.new("Frame")
side.Size=UDim2.fromOffset(285,900); side.BackgroundColor3=Color3.fromRGB(7,7,13); side.BorderSizePixel=0; side.Parent=shell
local sep=Instance.new("Frame"); sep.Size=UDim2.new(0,1,1,0); sep.Position=UDim2.new(1,-1,0,0); sep.BackgroundColor3=Color3.fromRGB(54,34,84); sep.BackgroundTransparency=.25; sep.BorderSizePixel=0; sep.Parent=side

local crown=Instance.new("TextLabel"); crown.Size=UDim2.fromOffset(54,54); crown.Position=UDim2.fromOffset(24,24); crown.BackgroundColor3=Color3.fromRGB(34,19,65); crown.Text="♛"; crown.TextColor3=C.PURPLE2; crown.TextSize=30; crown.Font=Enum.Font.GothamBold; crown.Parent=side; corner(crown,15); stroke(crown,C.PURPLE,.12,1)
txt(side,"599 AREA",UDim2.fromOffset(94,23),UDim2.fromOffset(165,31),28,C.WHITE,true)
txt(side,"PREMIUM SCRIPT HUB",UDim2.fromOffset(94,56),UDim2.fromOffset(160,18),10,C.PURPLE2,true)
txt(side,"FOR ROBLOX",UDim2.fromOffset(94,74),UDim2.fromOffset(110,16),9,C.MUTED,true)

local content=Instance.new("Frame"); content.Position=UDim2.fromOffset(285,0); content.Size=UDim2.new(1,-285,1,0); content.BackgroundTransparency=1; content.Parent=shell
local pages,tabs={},{}
local nav={{"HOME","⌂","Dashboard"},{"MAIN","✦","General Features"},{"VISUALS","◉","Enhance Your Game"},{"PLAYER","♟","Player Utilities"},{"WORLD","◈","World & Maps"},{"ANIME DICE","◆","Auto Collect System"},{"SETTINGS","⚙","Customize UI"},{"CREDITS","ⓘ","Special Thanks"}}

for i,v in ipairs(nav) do
    local b=Instance.new("TextButton"); b.Size=UDim2.fromOffset(239,62); b.Position=UDim2.fromOffset(23,120+(i-1)*68); b.BackgroundColor3=Color3.fromRGB(10,10,19); b.Text=""; b.AutoButtonColor=false; b.BorderSizePixel=0; b.Parent=side; corner(b,12)
    local ico=txt(b,v[2],UDim2.fromOffset(13,11),UDim2.fromOffset(42,40),20,C.PURPLE2,true,Enum.TextXAlignment.Center)
    local title=txt(b,v[1],UDim2.fromOffset(62,8),UDim2.fromOffset(160,22),12,C.WHITE,true)
    local sub=txt(b,v[3],UDim2.fromOffset(62,31),UDim2.fromOffset(160,18),9,C.MUTED,false)
    tabs[v[1]]={b=b,ico=ico,title=title,sub=sub}
    local p=Instance.new("Frame"); p.Name=v[1]; p.Size=UDim2.fromScale(1,1); p.BackgroundTransparency=1; p.Visible=false; p.Parent=content; pages[v[1]]=p
end

local profile=card(side,UDim2.new(0,23,1,-154),UDim2.fromOffset(239,128))
local avatar=Instance.new("ImageLabel"); avatar.Size=UDim2.fromOffset(52,52); avatar.Position=UDim2.fromOffset(14,14); avatar.BackgroundColor3=C.CARD2; avatar.BorderSizePixel=0; avatar.Parent=profile; corner(avatar,26); stroke(avatar,C.PURPLE,.1,1)
task.spawn(function() local ok,img=pcall(function() return Players:GetUserThumbnailAsync(lp.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end) if ok then avatar.Image=img end end)
txt(profile,"Welcome,",UDim2.fromOffset(80,13),UDim2.fromOffset(130,16),9,C.MUTED,false)
txt(profile,lp.DisplayName,UDim2.fromOffset(80,33),UDim2.fromOffset(140,22),12,C.WHITE,true)
txt(profile,"Premium User",UDim2.fromOffset(80,55),UDim2.fromOffset(140,18),9,C.PURPLE2,true)
txt(profile,'“Good Scripts\nMake The Game More Fun.”',UDim2.fromOffset(14,80),UDim2.fromOffset(210,38),9,C.MUTED,false)

local function selectTab(name)
    for n,p in pairs(pages) do p.Visible=(n==name) end
    for n,t in pairs(tabs) do
        local a=n==name
        TweenService:Create(t.b,TweenInfo.new(.16),{BackgroundColor3=a and Color3.fromRGB(49,24,88) or Color3.fromRGB(10,10,19)}):Play()
        t.ico.TextColor3=a and C.WHITE or C.PURPLE2; t.sub.TextColor3=a and C.PURPLE2 or C.MUTED
        local s=t.b:FindFirstChild("Active")
        if a and not s then s=stroke(t.b,C.PURPLE,.02,1.2); s.Name="Active" elseif not a and s then s:Destroy() end
    end
end
for n,t in pairs(tabs) do t.b.MouseButton1Click:Connect(function() selectTab(n) end) end

-- TOP BAR
local top=Instance.new("Frame"); top.Size=UDim2.new(1,0,0,94); top.BackgroundTransparency=1; top.Active=true; top.Parent=content
local search=Instance.new("TextBox"); search.Size=UDim2.fromOffset(480,48); search.Position=UDim2.fromOffset(28,22); search.BackgroundColor3=C.SURFACE; search.BackgroundTransparency=.02; search.Text=""; search.PlaceholderText="⌕   Search features, scripts, or games..."; search.PlaceholderColor3=C.MUTED; search.TextColor3=C.WHITE; search.Font=Enum.Font.Gotham; search.TextSize=12; search.ClearTextOnFocus=false; search.Parent=top; corner(search,12); stroke(search,Color3.fromRGB(74,48,108),.4,1)
local clock=card(top,UDim2.new(1,-355,0,22),UDim2.fromOffset(155,48)); local clockText=txt(clock,"--:--:--",UDim2.fromOffset(14,3),UDim2.new(1,-28,0,20),12,C.WHITE,true); txt(clock,"V9 PREVIEW",UDim2.fromOffset(14,24),UDim2.new(1,-28,0,16),8,C.MUTED,false)
local function winBtn(x,textv)
    local b=Instance.new("TextButton"); b.Size=UDim2.fromOffset(48,48); b.Position=UDim2.new(1,x,0,22); b.BackgroundColor3=C.SURFACE; b.Text=textv; b.TextColor3=C.WHITE; b.Font=Enum.Font.GothamBold; b.TextSize=20; b.AutoButtonColor=false; b.Parent=top; corner(b,12); stroke(b,Color3.fromRGB(74,48,108),.4,1); hover(b,C.SURFACE,Color3.fromRGB(28,20,48)); return b
end
local minBtn=winBtn(-184,"—"); local maxBtn=winBtn(-128,"□"); local closeBtn=winBtn(-72,"×")

-- ANIME DICE PAGE
local ad=pages["ANIME DICE"]
local hero=card(ad,UDim2.fromOffset(28,104),UDim2.new(1,-56,0,172)); hero.BackgroundColor3=Color3.fromRGB(9,7,17); hero.ClipsDescendants=true
local heroImage=Instance.new("ImageLabel"); heroImage.Size=UDim2.fromOffset(600,172); heroImage.Position=UDim2.new(1,-600,0,0); heroImage.BackgroundTransparency=1; heroImage.Image="rbxassetid://126519323866401"; heroImage.ImageTransparency=.20; heroImage.ScaleType=Enum.ScaleType.Crop; heroImage.Parent=hero
local shade=Instance.new("Frame"); shade.Size=UDim2.fromScale(1,1); shade.BackgroundColor3=Color3.fromRGB(6,5,12); shade.BackgroundTransparency=.28; shade.BorderSizePixel=0; shade.Parent=hero
local sg=Instance.new("UIGradient"); sg.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.45,.1),NumberSequenceKeypoint.new(1,.78)}); sg.Parent=shade
local di=Instance.new("TextLabel"); di.Size=UDim2.fromOffset(78,78); di.Position=UDim2.fromOffset(30,33); di.BackgroundColor3=Color3.fromRGB(39,21,73); di.Text="◆"; di.TextColor3=C.PURPLE2; di.TextSize=34; di.Font=Enum.Font.GothamBold; di.Parent=hero; corner(di,18); stroke(di,C.PURPLE,.05,1.2)
local at=txt(hero,"ANIME DICE",UDim2.fromOffset(130,24),UDim2.fromOffset(440,42),31,C.WHITE,true); at.RichText=true; at.Text='ANIME <font color="#B66EFF">DICE</font>'
txt(hero,"Auto Collect Your Income Effortlessly.",UDim2.fromOffset(130,64),UDim2.fromOffset(450,24),14,C.PURPLE2,false)
for i,badge in ipairs({"⚡ Fast","◆ Clean","◉ Stable","▥ Efficient"}) do
    local bb=Instance.new("TextLabel"); bb.Size=UDim2.fromOffset(92,28); bb.Position=UDim2.fromOffset(130+(i-1)*99,100); bb.BackgroundColor3=Color3.fromRGB(18,14,31); bb.Text=badge; bb.TextColor3=C.WHITE; bb.Font=Enum.Font.GothamSemibold; bb.TextSize=9; bb.Parent=hero; corner(bb,14); stroke(bb,Color3.fromRGB(83,53,123),.45,1)
end
local quote=txt(hero,'“Let the dice roll,\nwhile you collect.”\n\n- 599 AREA',UDim2.new(1,-260,0,30),UDim2.fromOffset(230,104),11,C.WHITE,false,Enum.TextXAlignment.Right); quote.TextYAlignment=Enum.TextYAlignment.Top

local left=card(ad,UDim2.fromOffset(28,296),UDim2.fromOffset(595,430))
local right=card(ad,UDim2.fromOffset(642,296),UDim2.new(1,-670,0,430))
local ic=Instance.new("TextLabel"); ic.Size=UDim2.fromOffset(48,48); ic.Position=UDim2.fromOffset(20,18); ic.BackgroundColor3=Color3.fromRGB(38,21,69); ic.Text="▦"; ic.TextColor3=C.PURPLE2; ic.TextSize=20; ic.Font=Enum.Font.GothamBold; ic.Parent=left; corner(ic,12); stroke(ic,C.PURPLE,.1,1)
txt(left,"SELECT PLOT",UDim2.fromOffset(82,17),UDim2.fromOffset(250,24),16,C.WHITE,true)
txt(left,"Choose which plots to collect from.",UDim2.fromOffset(82,43),UDim2.fromOffset(300,18),10,C.MUTED,false)
local selBadge=Instance.new("TextLabel"); selBadge.Size=UDim2.fromOffset(118,34); selBadge.Position=UDim2.new(1,-138,0,20); selBadge.BackgroundColor3=Color3.fromRGB(18,14,32); selBadge.Text="0 / 16 Selected"; selBadge.TextColor3=C.PURPLE2; selBadge.Font=Enum.Font.GothamBold; selBadge.TextSize=9; selBadge.Parent=left; corner(selBadge,10); stroke(selBadge,Color3.fromRGB(79,48,120),.35,1)
local selected={}; local plotBtns={}
local function refreshCount() local n=0 for i=1,16 do if selected[i] then n+=1 end end selBadge.Text=n.." / 16 Selected" end
for i=1,16 do
    local col=(i-1)%4; local row=math.floor((i-1)/4)
    local b=Instance.new("TextButton"); b.Size=UDim2.fromOffset(118,52); b.Position=UDim2.fromOffset(22+col*139,84+row*62); b.BackgroundColor3=Color3.fromRGB(16,16,29); b.Text=tostring(i); b.TextColor3=C.WHITE; b.Font=Enum.Font.GothamBold; b.TextSize=13; b.AutoButtonColor=false; b.Parent=left; corner(b,10); stroke(b,Color3.fromRGB(62,45,91),.55,1)
    plotBtns[i]=b; b.MouseButton1Click:Connect(function() selected[i]=not selected[i]; TweenService:Create(b,TweenInfo.new(.14),{BackgroundColor3=selected[i] and C.PURPLE or Color3.fromRGB(16,16,29)}):Play(); refreshCount() end)
end
local all=Instance.new("TextButton"); all.Size=UDim2.fromOffset(255,54); all.Position=UDim2.fromOffset(22,340); all.BackgroundColor3=C.PURPLE; all.Text="▦  Select All"; all.TextColor3=C.WHITE; all.Font=Enum.Font.GothamBold; all.TextSize=12; all.AutoButtonColor=false; all.Parent=left; corner(all,11)
local ag=Instance.new("UIGradient"); ag.Color=ColorSequence.new(Color3.fromRGB(113,48,255),Color3.fromRGB(170,74,255)); ag.Parent=all
local clear=all:Clone(); clear.Position=UDim2.fromOffset(296,340); clear.BackgroundColor3=Color3.fromRGB(18,18,31); clear.Text="⌫  Clear"; clear.Parent=left; clear:FindFirstChildOfClass("UIGradient"):Destroy(); stroke(clear,Color3.fromRGB(65,48,91),.4,1)
all.MouseButton1Click:Connect(function() for i=1,16 do selected[i]=true; plotBtns[i].BackgroundColor3=C.PURPLE end refreshCount() end)
clear.MouseButton1Click:Connect(function() for i=1,16 do selected[i]=false; plotBtns[i].BackgroundColor3=Color3.fromRGB(16,16,29) end refreshCount() end)

local ri=Instance.new("TextLabel"); ri.Size=UDim2.fromOffset(48,48); ri.Position=UDim2.fromOffset(20,18); ri.BackgroundColor3=Color3.fromRGB(38,21,69); ri.Text="◷"; ri.TextColor3=C.PURPLE2; ri.TextSize=20; ri.Font=Enum.Font.GothamBold; ri.Parent=right; corner(ri,12); stroke(ri,C.PURPLE,.1,1)
txt(right,"COLLECT SETTINGS",UDim2.fromOffset(82,17),UDim2.fromOffset(270,24),16,C.WHITE,true)
txt(right,"Set the delay between each collection.",UDim2.fromOffset(82,43),UDim2.fromOffset(330,18),10,C.MUTED,false)
local range=Instance.new("TextLabel"); range.Size=UDim2.fromOffset(100,34); range.Position=UDim2.new(1,-120,0,20); range.BackgroundColor3=Color3.fromRGB(27,16,49); range.Text="0.5s - 30s"; range.TextColor3=C.PURPLE2; range.Font=Enum.Font.GothamBold; range.TextSize=9; range.Parent=right; corner(range,10); stroke(range,C.PURPLE,.35,1)
local val=txt(right,"0.5s",UDim2.fromOffset(20,84),UDim2.new(1,-40,0,50),30,C.WHITE,true,Enum.TextXAlignment.Center)
local bar=Instance.new("Frame"); bar.Size=UDim2.new(1,-56,0,12); bar.Position=UDim2.fromOffset(28,150); bar.BackgroundColor3=Color3.fromRGB(53,47,73); bar.BorderSizePixel=0; bar.Parent=right; corner(bar,6)
local fill=Instance.new("Frame"); fill.Size=UDim2.new(0,0,1,0); fill.BackgroundColor3=C.PURPLE; fill.BorderSizePixel=0; fill.Parent=bar; corner(fill,6)
local knob=Instance.new("Frame"); knob.Size=UDim2.fromOffset(22,22); knob.AnchorPoint=Vector2.new(.5,.5); knob.Position=UDim2.new(0,0,.5,0); knob.BackgroundColor3=C.PURPLE2; knob.BorderSizePixel=0; knob.Parent=bar; corner(knob,11); stroke(knob,C.WHITE,.2,1)
txt(right,"0.5s",UDim2.fromOffset(28,166),UDim2.fromOffset(50,18),9,C.PURPLE2,false)
txt(right,"30s",UDim2.new(1,-78,0,166),UDim2.fromOffset(50,18),9,C.PURPLE2,false,Enum.TextXAlignment.Right)
local drag=false
local function setDelay(x) local w=bar.AbsoluteSize.X if w<=0 then return end local pct=math.clamp((x-bar.AbsolutePosition.X)/w,0,1); local v=.5+(29.5*pct); v=math.floor(v*10+.5)/10; fill.Size=UDim2.new(pct,0,1,0); knob.Position=UDim2.new(pct,0,.5,0); val.Text=string.format("%.1fs",v) end
bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; setDelay(i.Position.X) end end)
UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then setDelay(i.Position.X) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
local status=card(right,UDim2.fromOffset(20,214),UDim2.new(1,-40,0,72)); local dot=Instance.new("Frame"); dot.Size=UDim2.fromOffset(20,20); dot.Position=UDim2.fromOffset(18,25); dot.BackgroundColor3=C.CYAN; dot.Parent=status; corner(dot,10); stroke(dot,C.CYAN,.1,1)
txt(status,"STATUS",UDim2.fromOffset(52,11),UDim2.fromOffset(120,20),11,C.WHITE,true); txt(status,"Ready to start collecting...",UDim2.fromOffset(52,33),UDim2.fromOffset(250,18),9,C.MUTED,false)
local pill=Instance.new("TextLabel"); pill.Size=UDim2.fromOffset(110,34); pill.Position=UDim2.new(1,-126,.5,-17); pill.BackgroundColor3=Color3.fromRGB(47,16,29); pill.Text="■  Stopped"; pill.TextColor3=C.RED; pill.Font=Enum.Font.GothamBold; pill.TextSize=10; pill.Parent=status; corner(pill,11); stroke(pill,C.RED,.45,1)
local start=Instance.new("TextButton"); start.Size=UDim2.new(1,-40,0,74); start.Position=UDim2.fromOffset(20,310); start.BackgroundColor3=C.PURPLE; start.Text="▶   START AUTO COLLECT\n     Collect from selected plots automatically"; start.TextColor3=C.WHITE; start.Font=Enum.Font.GothamBold; start.TextSize=13; start.TextWrapped=true; start.AutoButtonColor=false; start.Parent=right; corner(start,12); local stg=Instance.new("UIGradient"); stg.Color=ColorSequence.new(Color3.fromRGB(116,45,255),Color3.fromRGB(176,73,255)); stg.Parent=start
local running=false; start.MouseButton1Click:Connect(function() running=not running; pill.Text=running and "●  Running" or "■  Stopped"; pill.TextColor3=running and C.GREEN or C.RED; pill.BackgroundColor3=running and Color3.fromRGB(15,51,38) or Color3.fromRGB(47,16,29); start.Text=running and "■   STOP AUTO COLLECT\n     Click to stop collecting" or "▶   START AUTO COLLECT\n     Collect from selected plots automatically" end)

local info=card(ad,UDim2.fromOffset(28,744),UDim2.new(1,-56,0,116)); local ii=Instance.new("TextLabel"); ii.Size=UDim2.fromOffset(46,46); ii.Position=UDim2.fromOffset(18,20); ii.BackgroundColor3=Color3.fromRGB(31,21,55); ii.Text="ⓘ"; ii.TextColor3=C.PURPLE2; ii.TextSize=18; ii.Font=Enum.Font.GothamBold; ii.Parent=info; corner(ii,12)
txt(info,"INFORMATION",UDim2.fromOffset(82,15),UDim2.fromOffset(230,20),11,C.WHITE,true); txt(info,"Select the plots you want to collect from, set the delay, and start the auto collect.\nMake sure you are in the correct area (Anime Dice).",UDim2.fromOffset(82,39),UDim2.fromOffset(620,42),9,C.MUTED,false)
txt(info,"SIMPLE   MODERN   CLEAN   BEAUTIFUL",UDim2.new(1,-370,0,18),UDim2.fromOffset(330,22),10,C.MUTED,true,Enum.TextXAlignment.Right)
txt(info,"- 599 AREA",UDim2.new(1,-370,0,47),UDim2.fromOffset(330,18),9,C.PURPLE2,false,Enum.TextXAlignment.Right)

-- placeholders for other pages
for name,p in pairs(pages) do if name~="ANIME DICE" then txt(p,name,UDim2.fromOffset(38,130),UDim2.fromOffset(500,40),28,C.WHITE,true); txt(p,"V9 preview page — layout ready for future migration.",UDim2.fromOffset(38,174),UDim2.fromOffset(600,24),11,C.MUTED,false) end end

-- smooth drag
local dragging=false; local dragStart; local startPos; local dragInput
local function dragUpdate(i) local d=i.Position-dragStart; local target=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y); TweenService:Create(shell,TweenInfo.new(.06,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=target}):Play() end
top.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; dragStart=i.Position; startPos=shell.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end) end end)
top.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end end)
UIS.InputChanged:Connect(function(i) if dragging and i==dragInput then dragUpdate(i) end end)

local minimized=false; local fullSize=shell.Size
minBtn.MouseButton1Click:Connect(function() minimized=not minimized; if minimized then for _,o in ipairs(shell:GetChildren()) do if o~=side and o~=sc and o:IsA("GuiObject") then o.Visible=false end end; TweenService:Create(shell,TweenInfo.new(.2),{Size=UDim2.fromOffset(285,96)}):Play() else TweenService:Create(shell,TweenInfo.new(.2),{Size=fullSize}):Play(); task.delay(.2,function() for _,o in ipairs(shell:GetChildren()) do if o:IsA("GuiObject") then o.Visible=true end end end) end end)
maxBtn.MouseButton1Click:Connect(function() shell.Position=UDim2.fromScale(.5,.5) end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
RunService.RenderStepped:Connect(function() if clockText.Parent then clockText.Text=os.date("%H:%M:%S") end end)
selectTab("ANIME DICE")
