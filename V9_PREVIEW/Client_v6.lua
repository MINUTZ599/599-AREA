-- 599 AREA V9 PREVIEW v6 - COMPACT REFERENCE UI
-- UI preview only. V8.5 stable remains untouched.

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local old=pg:FindFirstChild("AREA599_V9_PREVIEW") if old then old:Destroy() end

local C={
 BG=Color3.fromRGB(5,5,11), SIDE=Color3.fromRGB(7,7,15), CARD=Color3.fromRGB(10,10,20), CARD2=Color3.fromRGB(15,13,28),
 PURPLE=Color3.fromRGB(138,63,255), PURPLE2=Color3.fromRGB(191,124,255), WHITE=Color3.fromRGB(248,246,255),
 MUTED=Color3.fromRGB(154,148,181), GREEN=Color3.fromRGB(61,224,151), RED=Color3.fromRGB(255,90,118), CYAN=Color3.fromRGB(76,215,255)
}

local function corner(o,r)local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 12);c.Parent=o;return c end
local function stroke(o,col,tr,th)local s=Instance.new("UIStroke");s.Color=col or C.PURPLE;s.Transparency=tr==nil and .5 or tr;s.Thickness=th or 1;s.Parent=o;return s end
local function text(p,t,pos,size,fs,col,bold,align)
 local x=Instance.new("TextLabel");x.BackgroundTransparency=1;x.Text=t;x.Position=pos;x.Size=size;x.TextColor3=col or C.WHITE
 x.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;x.TextSize=fs or 11;x.TextXAlignment=align or Enum.TextXAlignment.Left;x.TextYAlignment=Enum.TextYAlignment.Center;x.Parent=p;return x
end
local function card(p,pos,size)local f=Instance.new("Frame");f.Position=pos;f.Size=size;f.BackgroundColor3=C.CARD;f.BackgroundTransparency=.02;f.BorderSizePixel=0;f.Parent=p;corner(f,13);stroke(f,Color3.fromRGB(73,48,108),.45,1);return f end
local function grad(o,a,b,rot)local g=Instance.new("UIGradient");g.Color=ColorSequence.new(a,b);g.Rotation=rot or 0;g.Parent=o;return g end
local function button(p,pos,size,label,bg,fs)
 local b=Instance.new("TextButton");b.Position=pos;b.Size=size;b.BackgroundColor3=bg or C.CARD2;b.BorderSizePixel=0;b.AutoButtonColor=false;b.Text=label;b.TextColor3=C.WHITE;b.Font=Enum.Font.GothamBold;b.TextSize=fs or 10;b.Parent=p;corner(b,10);return b
end

local ui={pages={},tabs={},selected={},plotBtns={}}
ui.gui=Instance.new("ScreenGui");ui.gui.Name="AREA599_V9_PREVIEW";ui.gui.ResetOnSpawn=false;ui.gui.IgnoreGuiInset=true;ui.gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;ui.gui.Parent=pg
ui.shell=Instance.new("Frame");ui.shell.Name="Shell";ui.shell.AnchorPoint=Vector2.new(.5,.5);ui.shell.Position=UDim2.fromScale(.5,.5);ui.shell.Size=UDim2.fromOffset(1080,680);ui.shell.BackgroundColor3=C.BG;ui.shell.BorderSizePixel=0;ui.shell.ClipsDescendants=true;ui.shell.Parent=ui.gui;corner(ui.shell,18);stroke(ui.shell,C.PURPLE,.08,1.5)
ui.scale=Instance.new("UIScale");ui.scale.Parent=ui.shell
local function rescale()local cam=workspace.CurrentCamera;if not cam then return end;local s=cam.ViewportSize;ui.scale.Scale=math.clamp(math.min((s.X-28)/1080,(s.Y-28)/680),.55,1)end
rescale();workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)

-- subtle ambient glow
for _,d in ipairs({{760,-170,390},{-130,510,300}})do local g=Instance.new("Frame");g.Size=UDim2.fromOffset(d[3],d[3]);g.Position=UDim2.fromOffset(d[1],d[2]);g.BackgroundColor3=C.PURPLE;g.BackgroundTransparency=.94;g.BorderSizePixel=0;g.Parent=ui.shell;corner(g,d[3]/2)end

-- SIDEBAR
ui.side=Instance.new("Frame");ui.side.Size=UDim2.fromOffset(215,680);ui.side.BackgroundColor3=C.SIDE;ui.side.BorderSizePixel=0;ui.side.Parent=ui.shell
ui.sep=Instance.new("Frame");ui.sep.Size=UDim2.new(0,1,1,0);ui.sep.Position=UDim2.new(1,-1,0,0);ui.sep.BackgroundColor3=Color3.fromRGB(55,35,87);ui.sep.BackgroundTransparency=.2;ui.sep.BorderSizePixel=0;ui.sep.Parent=ui.side
ui.crown=Instance.new("TextLabel");ui.crown.Size=UDim2.fromOffset(48,48);ui.crown.Position=UDim2.fromOffset(16,15);ui.crown.BackgroundColor3=Color3.fromRGB(35,20,66);ui.crown.Text="♛";ui.crown.TextColor3=C.WHITE;ui.crown.TextSize=29;ui.crown.Font=Enum.Font.GothamBold;ui.crown.Parent=ui.side;corner(ui.crown,13);stroke(ui.crown,C.PURPLE,.05,1.2);grad(ui.crown,Color3.fromRGB(255,255,255),C.PURPLE2,90)
text(ui.side,"599 AREA",UDim2.fromOffset(76,14),UDim2.fromOffset(125,25),22,C.WHITE,true)
text(ui.side,"PREMIUM SCRIPT HUB",UDim2.fromOffset(76,40),UDim2.fromOffset(128,14),8,C.PURPLE2,true)
text(ui.side,"FOR ROBLOX",UDim2.fromOffset(76,54),UDim2.fromOffset(100,13),8,C.MUTED,true)

ui.content=Instance.new("Frame");ui.content.Position=UDim2.fromOffset(215,0);ui.content.Size=UDim2.new(1,-215,1,0);ui.content.BackgroundTransparency=1;ui.content.Parent=ui.shell
local nav={{"HOME","⌂","Dashboard"},{"MAIN","↗","General Features"},{"VISUALS","◉","Enhance Your Game"},{"PLAYER","♟","Player Utilities"},{"WORLD","◈","World & Maps"},{"ANIME DICE","◆","Auto Collect System"},{"SETTINGS","⚙","Customize UI"},{"CREDITS","✚","Special Thanks"}}
for i,v in ipairs(nav)do
 local b=button(ui.side,UDim2.fromOffset(14,82+(i-1)*55),UDim2.fromOffset(187,50),"",Color3.fromRGB(10,10,20),10)
 local ico=text(b,v[2],UDim2.fromOffset(10,5),UDim2.fromOffset(38,38),18,C.PURPLE2,true,Enum.TextXAlignment.Center)
 local ttl=text(b,v[1],UDim2.fromOffset(52,6),UDim2.fromOffset(125,19),11,C.WHITE,true)
 local sub=text(b,v[3],UDim2.fromOffset(52,25),UDim2.fromOffset(130,16),8,C.MUTED,false)
 ui.tabs[v[1]]={b=b,ico=ico,ttl=ttl,sub=sub}
 local p=Instance.new("Frame");p.Name=v[1];p.Size=UDim2.fromScale(1,1);p.BackgroundTransparency=1;p.Visible=false;p.Parent=ui.content;ui.pages[v[1]]=p
end

ui.profile=card(ui.side,UDim2.new(0,14,1,-126),UDim2.fromOffset(187,112))
ui.avatar=Instance.new("ImageLabel");ui.avatar.Size=UDim2.fromOffset(44,44);ui.avatar.Position=UDim2.fromOffset(10,10);ui.avatar.BackgroundColor3=C.CARD2;ui.avatar.BorderSizePixel=0;ui.avatar.Parent=ui.profile;corner(ui.avatar,22);stroke(ui.avatar,C.PURPLE,.1,1)
task.spawn(function()local ok,img=pcall(function()return Players:GetUserThumbnailAsync(lp.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)end);if ok then ui.avatar.Image=img end end)
text(ui.profile,"Welcome,",UDim2.fromOffset(62,8),UDim2.fromOffset(110,14),8,C.MUTED,false)
text(ui.profile,lp.DisplayName,UDim2.fromOffset(62,23),UDim2.fromOffset(115,18),10,C.WHITE,true)
text(ui.profile,"Premium User",UDim2.fromOffset(62,42),UDim2.fromOffset(115,14),8,C.PURPLE2,true)
local q=text(ui.profile,'“Good Scripts\nMake The Game More Fun.”\n- 599 AREA',UDim2.fromOffset(10,61),UDim2.fromOffset(166,43),8,C.MUTED,false);q.TextYAlignment=Enum.TextYAlignment.Top

local function selectTab(name)
 for n,p in pairs(ui.pages)do p.Visible=(n==name)end
 for n,t in pairs(ui.tabs)do local a=n==name
  TweenService:Create(t.b,TweenInfo.new(.15),{BackgroundColor3=a and Color3.fromRGB(55,26,98) or Color3.fromRGB(10,10,20)}):Play()
  t.sub.TextColor3=a and C.PURPLE2 or C.MUTED;t.ico.TextColor3=a and C.WHITE or C.PURPLE2
  local s=t.b:FindFirstChild("Active");if a and not s then s=stroke(t.b,C.PURPLE,.02,1.4);s.Name="Active" elseif not a and s then s:Destroy()end
 end
end
for n,t in pairs(ui.tabs)do t.b.MouseButton1Click:Connect(function()selectTab(n)end)end

-- TOP BAR
ui.top=Instance.new("Frame");ui.top.Size=UDim2.new(1,0,0,72);ui.top.BackgroundTransparency=1;ui.top.Active=true;ui.top.Parent=ui.content
ui.search=Instance.new("TextBox");ui.search.Size=UDim2.fromOffset(405,40);ui.search.Position=UDim2.fromOffset(18,16);ui.search.BackgroundColor3=C.CARD;ui.search.Text="";ui.search.PlaceholderText="⌕   Search features, scripts, or games...";ui.search.PlaceholderColor3=C.MUTED;ui.search.TextColor3=C.WHITE;ui.search.Font=Enum.Font.Gotham;ui.search.TextSize=10;ui.search.ClearTextOnFocus=false;ui.search.Parent=ui.top;corner(ui.search,10);stroke(ui.search,Color3.fromRGB(75,49,111),.45,1)
ui.clock=card(ui.top,UDim2.new(1,-278,0,16),UDim2.fromOffset(120,40));ui.clockText=text(ui.clock,"--:--:--",UDim2.fromOffset(10,2),UDim2.new(1,-20,0,18),10,C.WHITE,true);text(ui.clock,"V9 PREVIEW",UDim2.fromOffset(10,20),UDim2.new(1,-20,0,14),7,C.MUTED,false)
local function wb(x,tt)local b=button(ui.top,UDim2.new(1,x,0,16),UDim2.fromOffset(40,40),tt,C.CARD,17);stroke(b,Color3.fromRGB(75,49,111),.45,1);return b end
ui.minBtn=wb(-146,"—");ui.maxBtn=wb(-100,"□");ui.closeBtn=wb(-54,"×")

-- ANIME DICE PAGE
ui.ad=ui.pages["ANIME DICE"]
ui.hero=card(ui.ad,UDim2.fromOffset(18,76),UDim2.new(1,-36,0,132));ui.hero.BackgroundColor3=Color3.fromRGB(9,7,17);ui.hero.ClipsDescendants=true
ui.heroImage=Instance.new("ImageLabel");ui.heroImage.Size=UDim2.fromOffset(410,132);ui.heroImage.Position=UDim2.new(1,-410,0,0);ui.heroImage.BackgroundTransparency=1;ui.heroImage.Image="rbxassetid://126519323866401";ui.heroImage.ImageTransparency=.18;ui.heroImage.ScaleType=Enum.ScaleType.Crop;ui.heroImage.Parent=ui.hero
ui.heroShade=Instance.new("Frame");ui.heroShade.Size=UDim2.fromScale(1,1);ui.heroShade.BackgroundColor3=Color3.fromRGB(7,5,13);ui.heroShade.BackgroundTransparency=.28;ui.heroShade.BorderSizePixel=0;ui.heroShade.Parent=ui.hero
local shg=Instance.new("UIGradient");shg.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.45,.08),NumberSequenceKeypoint.new(1,.78)});shg.Parent=ui.heroShade
ui.dice=Instance.new("TextLabel");ui.dice.Size=UDim2.fromOffset(62,62);ui.dice.Position=UDim2.fromOffset(18,23);ui.dice.BackgroundColor3=Color3.fromRGB(40,21,75);ui.dice.Text="◆";ui.dice.TextColor3=C.WHITE;ui.dice.TextSize=27;ui.dice.Font=Enum.Font.GothamBold;ui.dice.Parent=ui.hero;corner(ui.dice,15);stroke(ui.dice,C.PURPLE,.03,1.2);grad(ui.dice,Color3.fromRGB(255,255,255),C.PURPLE2,90)
ui.title=text(ui.hero,"ANIME DICE",UDim2.fromOffset(96,20),UDim2.fromOffset(310,30),24,C.WHITE,true);ui.title.RichText=true;ui.title.Text='ANIME <font color="#B778FF">DICE</font>'
text(ui.hero,"Auto Collect Your Income Effortlessly.",UDim2.fromOffset(96,49),UDim2.fromOffset(330,20),11,C.PURPLE2,false)
for i,v in ipairs({"⚡ Fast","◆ Clean","◉ Stable","▥ Efficient"})do local b=Instance.new("TextLabel");b.Size=UDim2.fromOffset(76,24);b.Position=UDim2.fromOffset(96+(i-1)*82,78);b.BackgroundColor3=Color3.fromRGB(18,14,31);b.Text=v;b.TextColor3=C.WHITE;b.Font=Enum.Font.GothamSemibold;b.TextSize=8;b.Parent=ui.hero;corner(b,12);stroke(b,Color3.fromRGB(82,53,121),.45,1)end
local quote=text(ui.hero,'“Let the dice roll,\nwhile you collect.”\n- 599 AREA',UDim2.new(1,-195,0,24),UDim2.fromOffset(170,74),9,C.WHITE,false,Enum.TextXAlignment.Right);quote.TextYAlignment=Enum.TextYAlignment.Top

ui.left=card(ui.ad,UDim2.fromOffset(18,222),UDim2.fromOffset(425,365))
ui.right=card(ui.ad,UDim2.fromOffset(457,222),UDim2.new(1,-475,0,365))
ui.leftIcon=Instance.new("TextLabel");ui.leftIcon.Size=UDim2.fromOffset(40,40);ui.leftIcon.Position=UDim2.fromOffset(14,14);ui.leftIcon.BackgroundColor3=Color3.fromRGB(38,21,69);ui.leftIcon.Text="▦";ui.leftIcon.TextColor3=C.PURPLE2;ui.leftIcon.TextSize=18;ui.leftIcon.Font=Enum.Font.GothamBold;ui.leftIcon.Parent=ui.left;corner(ui.leftIcon,10);stroke(ui.leftIcon,C.PURPLE,.1,1)
text(ui.left,"SELECT PLOT",UDim2.fromOffset(66,13),UDim2.fromOffset(190,20),13,C.WHITE,true)
text(ui.left,"Choose which plots to collect from.",UDim2.fromOffset(66,34),UDim2.fromOffset(220,16),8,C.MUTED,false)
ui.badge=Instance.new("TextLabel");ui.badge.Size=UDim2.fromOffset(94,28);ui.badge.Position=UDim2.new(1,-108,0,15);ui.badge.BackgroundColor3=Color3.fromRGB(18,14,31);ui.badge.Text="0 / 16 Selected";ui.badge.TextColor3=C.PURPLE2;ui.badge.Font=Enum.Font.GothamBold;ui.badge.TextSize=8;ui.badge.Parent=ui.left;corner(ui.badge,9);stroke(ui.badge,Color3.fromRGB(80,50,120),.35,1)
local function count()local n=0;for i=1,16 do if ui.selected[i]then n=n+1 end end;ui.badge.Text=n.." / 16 Selected" end
for i=1,16 do
 local col=(i-1)%4;local row=math.floor((i-1)/4);local b=button(ui.left,UDim2.fromOffset(17+col*99,68+row*50),UDim2.fromOffset(88,42),tostring(i),Color3.fromRGB(18,18,31),11);stroke(b,Color3.fromRGB(59,48,82),.45,1);ui.plotBtns[i]=b
 b.MouseButton1Click:Connect(function()ui.selected[i]=not ui.selected[i];TweenService:Create(b,TweenInfo.new(.13),{BackgroundColor3=ui.selected[i] and C.PURPLE or Color3.fromRGB(18,18,31)}):Play();count()end)
end
ui.all=button(ui.left,UDim2.fromOffset(17,278),UDim2.fromOffset(186,44),"▦   Select All",C.PURPLE,10);stroke(ui.all,C.PURPLE2,.05,1);grad(ui.all,Color3.fromRGB(177,103,255),Color3.fromRGB(105,42,255),0)
ui.clear=button(ui.left,UDim2.fromOffset(217,278),UDim2.fromOffset(186,44),"✕   Clear",Color3.fromRGB(18,18,31),10);stroke(ui.clear,Color3.fromRGB(59,48,82),.45,1)
ui.all.MouseButton1Click:Connect(function()for i=1,16 do ui.selected[i]=true;ui.plotBtns[i].BackgroundColor3=C.PURPLE end;count()end)
ui.clear.MouseButton1Click:Connect(function()for i=1,16 do ui.selected[i]=false;ui.plotBtns[i].BackgroundColor3=Color3.fromRGB(18,18,31)end;count()end)

-- RIGHT SETTINGS
ui.settings=card(ui.right,UDim2.fromOffset(0,0),UDim2.new(1,0,0,178))
ui.ri=Instance.new("TextLabel");ui.ri.Size=UDim2.fromOffset(40,40);ui.ri.Position=UDim2.fromOffset(14,14);ui.ri.BackgroundColor3=Color3.fromRGB(38,21,69);ui.ri.Text="◷";ui.ri.TextColor3=C.PURPLE2;ui.ri.TextSize=18;ui.ri.Font=Enum.Font.GothamBold;ui.ri.Parent=ui.settings;corner(ui.ri,10);stroke(ui.ri,C.PURPLE,.1,1)
text(ui.settings,"COLLECT SETTINGS",UDim2.fromOffset(66,13),UDim2.fromOffset(220,20),13,C.WHITE,true)
text(ui.settings,"Set the delay between each collect.",UDim2.fromOffset(66,34),UDim2.fromOffset(250,16),8,C.MUTED,false)
ui.range=Instance.new("TextLabel");ui.range.Size=UDim2.fromOffset(82,28);ui.range.Position=UDim2.new(1,-96,0,15);ui.range.BackgroundColor3=Color3.fromRGB(26,16,47);ui.range.Text="0.5s - 30s";ui.range.TextColor3=C.PURPLE2;ui.range.Font=Enum.Font.GothamBold;ui.range.TextSize=8;ui.range.Parent=ui.settings;corner(ui.range,9)
ui.delayText=text(ui.settings,"2.5s",UDim2.fromOffset(0,74),UDim2.new(1,0,0,34),23,C.WHITE,true,Enum.TextXAlignment.Center)
ui.bar=Instance.new("Frame");ui.bar.Size=UDim2.new(1,-34,0,8);ui.bar.Position=UDim2.fromOffset(17,124);ui.bar.BackgroundColor3=Color3.fromRGB(46,42,66);ui.bar.BorderSizePixel=0;ui.bar.Active=true;ui.bar.Parent=ui.settings;corner(ui.bar,4)
ui.fill=Instance.new("Frame");ui.fill.Size=UDim2.new(.068,0,1,0);ui.fill.BackgroundColor3=C.PURPLE;ui.fill.BorderSizePixel=0;ui.fill.Parent=ui.bar;corner(ui.fill,4);grad(ui.fill,Color3.fromRGB(196,119,255),Color3.fromRGB(104,42,255),0)
ui.knob=Instance.new("Frame");ui.knob.Size=UDim2.fromOffset(18,18);ui.knob.AnchorPoint=Vector2.new(.5,.5);ui.knob.Position=UDim2.new(.068,0,.5,0);ui.knob.BackgroundColor3=C.WHITE;ui.knob.BorderSizePixel=0;ui.knob.Parent=ui.bar;corner(ui.knob,9);stroke(ui.knob,C.PURPLE2,0,2)
text(ui.settings,"0.5s",UDim2.fromOffset(17,136),UDim2.fromOffset(50,14),8,C.MUTED,false);text(ui.settings,"30s",UDim2.new(1,-51,0,136),UDim2.fromOffset(34,14),8,C.MUTED,false,Enum.TextXAlignment.Right)
ui.sliderDrag=false
local function setDelay(x)local w=ui.bar.AbsoluteSize.X;if w<=0 then return end;local pct=math.clamp((x-ui.bar.AbsolutePosition.X)/w,0,1);local v=.5+29.5*pct;v=math.floor(v*10+.5)/10;ui.fill.Size=UDim2.new(pct,0,1,0);ui.knob.Position=UDim2.new(pct,0,.5,0);ui.delayText.Text=string.format("%.1fs",v)end
ui.bar.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then ui.sliderDrag=true;setDelay(i.Position.X)end end)
UIS.InputChanged:Connect(function(i)if ui.sliderDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then setDelay(i.Position.X)end end)
UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then ui.sliderDrag=false end end)

ui.status=card(ui.right,UDim2.fromOffset(0,192),UDim2.new(1,0,0,173))
ui.si=Instance.new("TextLabel");ui.si.Size=UDim2.fromOffset(40,40);ui.si.Position=UDim2.fromOffset(14,14);ui.si.BackgroundColor3=Color3.fromRGB(12,35,50);ui.si.Text="◯";ui.si.TextColor3=C.CYAN;ui.si.TextSize=23;ui.si.Font=Enum.Font.GothamBold;ui.si.Parent=ui.status;corner(ui.si,10);stroke(ui.si,C.CYAN,.4,1)
text(ui.status,"STATUS",UDim2.fromOffset(66,14),UDim2.fromOffset(100,18),12,C.WHITE,true);text(ui.status,"Ready to start collecting...",UDim2.fromOffset(66,34),UDim2.fromOffset(220,16),8,C.MUTED,false)
ui.st=Instance.new("TextLabel");ui.st.Size=UDim2.fromOffset(92,34);ui.st.Position=UDim2.new(1,-106,0,17);ui.st.BackgroundColor3=Color3.fromRGB(54,15,28);ui.st.Text="■  Stopped";ui.st.TextColor3=C.RED;ui.st.Font=Enum.Font.GothamBold;ui.st.TextSize=9;ui.st.Parent=ui.status;corner(ui.st,10);stroke(ui.st,C.RED,.5,1)
ui.start=button(ui.status,UDim2.fromOffset(14,92),UDim2.new(1,-28,0,62),"▶   START AUTO COLLECT",C.PURPLE,14);stroke(ui.start,C.PURPLE2,.02,1.2);grad(ui.start,Color3.fromRGB(188,111,255),Color3.fromRGB(108,43,255),0)
ui.running=false;ui.start.MouseButton1Click:Connect(function()ui.running=not ui.running;ui.st.Text=ui.running and "●  Running" or "■  Stopped";ui.st.TextColor3=ui.running and C.GREEN or C.RED;ui.st.BackgroundColor3=ui.running and Color3.fromRGB(14,49,34) or Color3.fromRGB(54,15,28);ui.start.Text=ui.running and "■   STOP AUTO COLLECT" or "▶   START AUTO COLLECT" end)

ui.info=card(ui.ad,UDim2.fromOffset(18,600),UDim2.new(1,-36,0,62))
ui.ii=Instance.new("TextLabel");ui.ii.Size=UDim2.fromOffset(36,36);ui.ii.Position=UDim2.fromOffset(13,13);ui.ii.BackgroundColor3=Color3.fromRGB(30,24,52);ui.ii.Text="ⓘ";ui.ii.TextColor3=C.PURPLE2;ui.ii.TextSize=16;ui.ii.Font=Enum.Font.GothamBold;ui.ii.Parent=ui.info;corner(ui.ii,9)
text(ui.info,"INFORMATION",UDim2.fromOffset(60,8),UDim2.fromOffset(140,18),10,C.WHITE,true)
text(ui.info,"Select plots, set the delay, then start auto collect.",UDim2.fromOffset(60,28),UDim2.fromOffset(390,18),8,C.MUTED,false)
text(ui.info,"SIMPLE   MODERN   CLEAN   BEAUTIFUL",UDim2.new(1,-285,0,16),UDim2.fromOffset(260,20),8,C.PURPLE2,true,Enum.TextXAlignment.Right)

for _,name in ipairs({"HOME","MAIN","VISUALS","PLAYER","WORLD","SETTINGS","CREDITS"})do local p=ui.pages[name];local h=card(p,UDim2.fromOffset(18,92),UDim2.new(1,-36,0,150));text(h,name,UDim2.fromOffset(24,26),UDim2.new(1,-48,0,34),24,C.WHITE,true);text(h,"599 AREA V9 compact preview",UDim2.fromOffset(24,65),UDim2.new(1,-48,0,20),10,C.MUTED,false)end

-- drag + window controls
ui.drag=false;ui.dragStart=nil;ui.startPos=nil;ui.dragInput=nil;ui.dragTween=nil
local function updateDrag(i)local d=i.Position-ui.dragStart;local target=UDim2.new(ui.startPos.X.Scale,ui.startPos.X.Offset+d.X,ui.startPos.Y.Scale,ui.startPos.Y.Offset+d.Y);if ui.dragTween then ui.dragTween:Cancel()end;ui.dragTween=TweenService:Create(ui.shell,TweenInfo.new(.07,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=target});ui.dragTween:Play()end
ui.top.InputBegan:Connect(function(i)if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) and not UIS:GetFocusedTextBox() then ui.drag=true;ui.dragStart=i.Position;ui.startPos=ui.shell.Position;i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then ui.drag=false end end)end end)
ui.top.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then ui.dragInput=i end end)
UIS.InputChanged:Connect(function(i)if ui.drag and i==ui.dragInput then updateDrag(i)end end)
ui.minimized=false
ui.minBtn.MouseButton1Click:Connect(function()ui.minimized=not ui.minimized;ui.minBtn.Text=ui.minimized and "+" or "—";TweenService:Create(ui.shell,TweenInfo.new(.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=ui.minimized and UDim2.fromOffset(1080,72) or UDim2.fromOffset(1080,680)}):Play()end)
ui.maxBtn.MouseButton1Click:Connect(function()ui.shell.Position=UDim2.fromScale(.5,.5)end)
ui.closeBtn.MouseButton1Click:Connect(function()ui.gui:Destroy()end)
RunService.RenderStepped:Connect(function()ui.clockText.Text=os.date("%H:%M:%S")end)
selectTab("ANIME DICE")
