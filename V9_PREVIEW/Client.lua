-- 599 AREA V9 PREVIEW - COMPACT REFERENCE BUILD
-- UI preview only. V8.5 stable remains untouched.

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local old=pg:FindFirstChild("AREA599_V9_PREVIEW") if old then old:Destroy() end

local C={BG=Color3.fromRGB(5,5,11),SIDE=Color3.fromRGB(7,7,15),CARD=Color3.fromRGB(10,10,20),CARD2=Color3.fromRGB(15,13,28),PURPLE=Color3.fromRGB(138,63,255),PURPLE2=Color3.fromRGB(191,124,255),WHITE=Color3.fromRGB(248,246,255),MUTED=Color3.fromRGB(154,148,181),GREEN=Color3.fromRGB(61,224,151),RED=Color3.fromRGB(255,90,118),CYAN=Color3.fromRGB(76,215,255)}
local function corner(o,r)local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 12);c.Parent=o;return c end
local function stroke(o,col,tr,th)local s=Instance.new("UIStroke");s.Color=col or C.PURPLE;s.Transparency=tr==nil and .5 or tr;s.Thickness=th or 1;s.Parent=o;return s end
local function text(p,t,pos,size,fs,col,bold,align)local x=Instance.new("TextLabel");x.BackgroundTransparency=1;x.Text=t;x.Position=pos;x.Size=size;x.TextColor3=col or C.WHITE;x.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;x.TextSize=fs or 11;x.TextXAlignment=align or Enum.TextXAlignment.Left;x.TextYAlignment=Enum.TextYAlignment.Center;x.Parent=p;return x end
local function card(p,pos,size)local f=Instance.new("Frame");f.Position=pos;f.Size=size;f.BackgroundColor3=C.CARD;f.BackgroundTransparency=.02;f.BorderSizePixel=0;f.Parent=p;corner(f,13);stroke(f,Color3.fromRGB(73,48,108),.45,1);return f end
local function grad(o,a,b,rot)local g=Instance.new("UIGradient");g.Color=ColorSequence.new(a,b);g.Rotation=rot or 0;g.Parent=o;return g end

local gui=Instance.new("ScreenGui");gui.Name="AREA599_V9_PREVIEW";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;gui.Parent=pg
local shell=Instance.new("Frame");shell.Name="Shell";shell.AnchorPoint=Vector2.new(.5,.5);shell.Position=UDim2.fromScale(.5,.5);shell.Size=UDim2.fromOffset(1080,680);shell.BackgroundColor3=C.BG;shell.BorderSizePixel=0;shell.ClipsDescendants=true;shell.Parent=gui;corner(shell,18);stroke(shell,C.PURPLE,.08,1.5)
local sc=Instance.new("UIScale");sc.Parent=shell
local function rescale()local cam=workspace.CurrentCamera if not cam then return end local s=cam.ViewportSize sc.Scale=math.clamp(math.min((s.X-28)/1080,(s.Y-28)/680),.55,1) end
rescale();workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)

for _,d in ipairs({{760,-170,390},{-130,510,300}}) do local g=Instance.new("Frame");g.Size=UDim2.fromOffset(d[3],d[3]);g.Position=UDim2.fromOffset(d[1],d[2]);g.BackgroundColor3=C.PURPLE;g.BackgroundTransparency=.94;g.BorderSizePixel=0;g.Parent=shell;corner(g,d[3]/2) end

-- SIDEBAR
local side=Instance.new("Frame");side.Size=UDim2.fromOffset(215,680);side.BackgroundColor3=C.SIDE;side.BorderSizePixel=0;side.Parent=shell
local sep=Instance.new("Frame");sep.Size=UDim2.new(0,1,1,0);sep.Position=UDim2.new(1,-1,0,0);sep.BackgroundColor3=Color3.fromRGB(55,35,87);sep.BackgroundTransparency=.2;sep.BorderSizePixel=0;sep.Parent=side

local crown=Instance.new("TextLabel");crown.Size=UDim2.fromOffset(48,48);crown.Position=UDim2.fromOffset(16,15);crown.BackgroundColor3=Color3.fromRGB(35,20,66);crown.Text="♛";crown.TextColor3=C.WHITE;crown.TextSize=29;crown.Font=Enum.Font.GothamBold;crown.Parent=side;corner(crown,13);stroke(crown,C.PURPLE,.05,1.2)
local cg=grad(crown,Color3.fromRGB(255,255,255),C.PURPLE2,90)
text(side,"599 AREA",UDim2.fromOffset(76,14),UDim2.fromOffset(125,25),22,C.WHITE,true)
text(side,"PREMIUM SCRIPT HUB",UDim2.fromOffset(76,40),UDim2.fromOffset(128,14),8,C.PURPLE2,true)
text(side,"FOR ROBLOX",UDim2.fromOffset(76,54),UDim2.fromOffset(100,13),8,C.MUTED,true)

local content=Instance.new("Frame");content.Position=UDim2.fromOffset(215,0);content.Size=UDim2.new(1,-215,1,0);content.BackgroundTransparency=1;content.Parent=shell
local pages,tabs={},{}
local nav={{"HOME","⌂","Dashboard"},{"MAIN","↗","General Features"},{"VISUALS","◉","Enhance Your Game"},{"PLAYER","♟","Player Utilities"},{"WORLD","◈","World & Maps"},{"ANIME DICE","◆","Auto Collect System"},{"SETTINGS","⚙","Customize UI"},{"CREDITS","✚","Special Thanks"}}
for i,v in ipairs(nav) do
 local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(187,50);b.Position=UDim2.fromOffset(14,82+(i-1)*55);b.BackgroundColor3=Color3.fromRGB(10,10,20);b.Text="";b.AutoButtonColor=false;b.BorderSizePixel=0;b.Parent=side;corner(b,11)
 local ico=text(b,v[2],UDim2.fromOffset(10,5),UDim2.fromOffset(38,38),18,C.PURPLE2,true,Enum.TextXAlignment.Center)
 local ttl=text(b,v[1],UDim2.fromOffset(52,6),UDim2.fromOffset(125,19),11,C.WHITE,true)
 local sub=text(b,v[3],UDim2.fromOffset(52,25),UDim2.fromOffset(130,16),8,C.MUTED,false)
 tabs[v[1]]={b=b,ico=ico,ttl=ttl,sub=sub}
 local p=Instance.new("Frame");p.Name=v[1];p.Size=UDim2.fromScale(1,1);p.BackgroundTransparency=1;p.Visible=false;p.Parent=content;pages[v[1]]=p
end

local profile=card(side,UDim2.new(0,14,1,-126),UDim2.fromOffset(187,112))
local av=Instance.new("ImageLabel");av.Size=UDim2.fromOffset(44,44);av.Position=UDim2.fromOffset(10,10);av.BackgroundColor3=C.CARD2;av.BorderSizePixel=0;av.Parent=profile;corner(av,22);stroke(av,C.PURPLE,.1,1)
task.spawn(function()local ok,img=pcall(function()return Players:GetUserThumbnailAsync(lp.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)end)if ok then av.Image=img end end)
text(profile,"Welcome,",UDim2.fromOffset(62,8),UDim2.fromOffset(110,14),8,C.MUTED,false)
text(profile,lp.DisplayName,UDim2.fromOffset(62,23),UDim2.fromOffset(115,18),10,C.WHITE,true)
text(profile,"Premium User",UDim2.fromOffset(62,42),UDim2.fromOffset(115,14),8,C.PURPLE2,true)
text(profile,'“Good Scripts\nMake The Game More Fun.”\n- 599 AREA',UDim2.fromOffset(10,61),UDim2.fromOffset(166,43),8,C.MUTED,false).TextYAlignment=Enum.TextYAlignment.Top

local function selectTab(name)
 for n,p in pairs(pages)do p.Visible=(n==name)end
 for n,t in pairs(tabs)do local a=n==name
  TweenService:Create(t.b,TweenInfo.new(.15),{BackgroundColor3=a and Color3.fromRGB(55,26,98) or Color3.fromRGB(10,10,20)}):Play()
  t.sub.TextColor3=a and C.PURPLE2 or C.MUTED;t.ico.TextColor3=a and C.WHITE or C.PURPLE2
  local s=t.b:FindFirstChild("Active") if a and not s then s=stroke(t.b,C.PURPLE,.02,1.4);s.Name="Active" elseif not a and s then s:Destroy() end
 end
end
for n,t in pairs(tabs)do t.b.MouseButton1Click:Connect(function()selectTab(n)end)end

-- TOP BAR
local top=Instance.new("Frame");top.Size=UDim2.new(1,0,0,72);top.BackgroundTransparency=1;top.Active=true;top.Parent=content
local search=Instance.new("TextBox");search.Size=UDim2.fromOffset(405,40);search.Position=UDim2.fromOffset(18,16);search.BackgroundColor3=C.CARD;search.Text="";search.PlaceholderText="⌕   Search features, scripts, or games...";search.PlaceholderColor3=C.MUTED;search.TextColor3=C.WHITE;search.Font=Enum.Font.Gotham;search.TextSize=10;search.ClearTextOnFocus=false;search.Parent=top;corner(search,10);stroke(search,Color3.fromRGB(75,49,111),.45,1)
local clock=card(top,UDim2.new(1,-278,0,16),UDim2.fromOffset(120,40));local clockText=text(clock,"--:--:--",UDim2.fromOffset(10,2),UDim2.new(1,-20,0,18),10,C.WHITE,true);text(clock,"V9 PREVIEW",UDim2.fromOffset(10,20),UDim2.new(1,-20,0,14),7,C.MUTED,false)
local function wb(x,tt)local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(40,40);b.Position=UDim2.new(1,x,0,16);b.BackgroundColor3=C.CARD;b.Text=tt;b.TextColor3=C.WHITE;b.Font=Enum.Font.GothamBold;b.TextSize=17;b.AutoButtonColor=false;b.Parent=top;corner(b,10);stroke(b,Color3.fromRGB(75,49,111),.45,1);return b end
local minBtn=wb(-146,"—");local maxBtn=wb(-100,"□");local closeBtn=wb(-54,"×")

-- ANIME DICE
local ad=pages["ANIME DICE"]
local hero=card(ad,UDim2.fromOffset(18,76),UDim2.new(1,-36,0,132));hero.BackgroundColor3=Color3.fromRGB(9,7,17);hero.ClipsDescendants=true
local hi=Instance.new("ImageLabel");hi.Size=UDim2.fromOffset(410,132);hi.Position=UDim2.new(1,-410,0,0);hi.BackgroundTransparency=1;hi.Image="rbxassetid://126519323866401";hi.ImageTransparency=.18;hi.ScaleType=Enum.ScaleType.Crop;hi.Parent=hero
local shade=Instance.new("Frame");shade.Size=UDim2.fromScale(1,1);shade.BackgroundColor3=Color3.fromRGB(7,5,13);shade.BackgroundTransparency=.28;shade.BorderSizePixel=0;shade.Parent=hero
local shg=Instance.new("UIGradient");shg.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.45,.08),NumberSequenceKeypoint.new(1,.78)});shg.Parent=shade
local dice=Instance.new("TextLabel");dice.Size=UDim2.fromOffset(62,62);dice.Position=UDim2.fromOffset(18,23);dice.BackgroundColor3=Color3.fromRGB(40,21,75);dice.Text="◆";dice.TextColor3=C.WHITE;dice.TextSize=27;dice.Font=Enum.Font.GothamBold;dice.Parent=hero;corner(dice,15);stroke(dice,C.PURPLE,.03,1.2);grad(dice,Color3.fromRGB(255,255,255),C.PURPLE2,90)
local title=text(hero,"ANIME DICE",UDim2.fromOffset(96,20),UDim2.fromOffset(310,30),24,C.WHITE,true);title.RichText=true;title.Text='ANIME <font color="#B778FF">DICE</font>'
text(hero,"Auto Collect Your Income Effortlessly.",UDim2.fromOffset(96,49),UDim2.fromOffset(330,20),11,C.PURPLE2,false)
for i,v in ipairs({"⚡ Fast","◆ Clean","◉ Stable","▥ Efficient"})do local b=Instance.new("TextLabel");b.Size=UDim2.fromOffset(76,24);b.Position=UDim2.fromOffset(96+(i-1)*82,78);b.BackgroundColor3=Color3.fromRGB(18,14,31);b.Text=v;b.TextColor3=C.WHITE;b.Font=Enum.Font.GothamSemibold;b.TextSize=8;b.Parent=hero;corner(b,12);stroke(b,Color3.fromRGB(82,53,121),.45,1)end
text(hero,'“Let the dice roll,\nwhile you collect.”\n- 599 AREA',UDim2.new(1,-195,0,24),UDim2.fromOffset(170,74),9,C.WHITE,false,Enum.TextXAlignment.Right).TextYAlignment=Enum.TextYAlignment.Top

local left=card(ad,UDim2.fromOffset(18,222),UDim2.fromOffset(425,365))
local right=card(ad,UDim2.fromOffset(457,222),UDim2.new(1,-475,0,365))
local li=Instance.new("TextLabel");li.Size=UDim2.fromOffset(40,40);li.Position=UDim2.fromOffset(14,14);li.BackgroundColor3=Color3.fromRGB(38,21,69);li.Text="▦";li.TextColor3=C.PURPLE2;li.TextSize=18;li.Font=Enum.Font.GothamBold;li.Parent=left;corner(li,10);stroke(li,C.PURPLE,.1,1)
text(left,"SELECT PLOT",UDim2.fromOffset(66,13),UDim2.fromOffset(190,20),13,C.WHITE,true)
text(left,"Choose which plots to collect from.",UDim2.fromOffset(66,34),UDim2.fromOffset(220,16),8,C.MUTED,false)
local badge=Instance.new("TextLabel");badge.Size=UDim2.fromOffset(94,28);badge.Position=UDim2.new(1,-108,0,15);badge.BackgroundColor3=Color3.fromRGB(18,14,31);badge.Text="0 / 16 Selected";badge.TextColor3=C.PURPLE2;badge.Font=Enum.Font.GothamBold;badge.TextSize=8;badge.Parent=left;corner(badge,9);stroke(badge,Color3.fromRGB(80,50,120),.35,1)
local selected,btns={},{}
local function count()local n=0 for i=1,16 do if selected[i]then n+=1 end end badge.Text=n.." / 16 Selected" end
for i=1,16 do local col=(i-1)%4;local row=math.floor((i-1)/4);local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(88,42);b.Position=UDim2.fromOffset(17+col*99,68+row*50);b.BackgroundColor3=Color3.fromRGB(18,18,31);b.Text=tostring(i);b.TextColor3=C.WHITE;b.Font=Enum.Font.GothamBold;b.TextSize=11;b.AutoButtonColor=false;b.Parent=left;corner(b,9);stroke(b,Color3.fromRGB(59,48,82),.45,1);btns[i]=b;b.MouseButton1Click:Connect(function()selected[i]=not selected[i];TweenService:Create(b,TweenInfo.new(.13),{BackgroundColor3=selected[i] and C.PURPLE or Color3.fromRGB(18,18,31)}):Play();count()end)end
local all=Instance.new("TextButton");all.Size=UDim2.fromOffset(186,44);all.Position=UDim2.fromOffset(17,278);all.BackgroundColor3=C.PURPLE;all.Text="▦   Select All";all.TextColor3=C.WHITE;all.Font=Enum.Font.GothamBold;all.TextSize=10;all.AutoButtonColor=false;all.Parent=left;corner(all,10);stroke(all,C.PURPLE2,.05,1);grad(all,Color3.fromRGB(177,103,255),Color3.fromRGB(105,42,255),0)
local clear=all:Clone();clear.Position=UDim2.fromOffset(217,278);clear.BackgroundColor3=Color3.fromRGB(18,18,31);clear.Text="♜   Clear";clear.Parent=left;local g=clear:FindFirstChildOfClass("UIGradient")if g then g:Destroy()end
all.MouseButton1Click:Connect(function()for i=1,16 do selected[i]=true;btns[i].BackgroundColor3=C.PURPLE end;count()end)
clear.MouseButton1Click:Connect(function()for i=1,16 do selected[i]=false;btns[i].BackgroundColor3=Color3.fromRGB(18,18,31)end;count()end)

local settings=card(right,UDim2.fromOffset(0,0),UDim2.new(1,0,0,178))
local ri=Instance.new("TextLabel");ri.Size=UDim2.fromOffset(40,40);ri.Position=UDim2.fromOffset(14,14);ri.BackgroundColor3=Color3.fromRGB(38,21,69);ri.Text="◷";ri.TextColor3=C.PURPLE2;ri.TextSize=18;ri.Font=Enum.Font.GothamBold;ri.Parent=settings;corner(ri,10);stroke(ri,C.PURPLE,.1,1)
text(settings,"COLLECT SETTINGS",UDim2.fromOffset(66,13),UDim2.fromOffset(220,20),13,C.WHITE,true)
text(settings,"Set the delay between each collect.",UDim2.fromOffset(66,34),UDim2.fromOffset(250,16),8,C.MUTED,false)
local range=Instance.new("TextLabel");range.Size=UDim2.fromOffset(82,28);range.Position=UDim2.new(1,-96,0,15);range.BackgroundColor3=Color3.fromRGB(26,16,47);range.Text="0.5s - 30s";range.TextColor3=C.PURPLE2;range.Font=Enum.Font.GothamBold;range.TextSize=8;range.Parent=settings;corner(range,9)
local delayText=text(settings,"2.5s",UDim2.fromOffset(0,74),UDim2.new(1,0,0,34),23,C.WHITE,true,Enum.TextXAlignment.Center)
local bar=Instance.new("Frame");bar.Size=UDim2.new(1,-34,0,8);bar.Position=UDim2.fromOffset(17,124);bar.BackgroundColor3=Color3.fromRGB(46,42,66);bar.BorderSizePixel=0;bar.Active=true;bar.Parent=settings;corner(bar,4)
local fill=Instance.new("Frame");fill.Size=UDim2.new(.068,0,1,0);fill.BackgroundColor3=C.PURPLE;fill.BorderSizePixel=0;fill.Parent=bar;corner(fill,4);grad(fill,Color3.fromRGB(196,119,255),Color3.fromRGB(104,42,255),0)
local knob=Instance.new("Frame");knob.Size=UDim2.fromOffset(18,18);knob.AnchorPoint=Vector2.new(.5,.5);knob.Position=UDim2.new(.068,0,.5,0);knob.BackgroundColor3=C.WHITE;knob.BorderSizePixel=0;knob.Parent=bar;corner(knob,9);stroke(knob,C.PURPLE2,0,2)
text(settings,"0.5s",UDim2.fromOffset(17,136),UDim2.fromOffset(50,14),8,C.MUTED,false);text(settings,"30s",UDim2.new(1,-51,0,136),UDim2.fromOffset(34,14),8,C.MUTED,false,Enum.TextXAlignment.Right)
local dragging=false
local function setDelay(x)local w=bar.AbsoluteSize.X if w<=0 then return end local pct=math.clamp((x-bar.AbsolutePosition.X)/w,0,1);local v=.5+29.5*pct;v=math.floor(v*10+.5)/10;fill.Size=UDim2.new(pct,0,1,0);knob.Position=UDim2.new(pct,0,.5,0);delayText.Text=string.format("%.1fs",v)end
bar.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;setDelay(i.Position.X)end end)
UIS.InputChanged:Connect(function(i)if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then setDelay(i.Position.X)end end)
UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)

local status=card(right,UDim2.fromOffset(0,192),UDim2.new(1,0,0,173))
local si=Instance.new("TextLabel");si.Size=UDim2.fromOffset(40,40);si.Position=UDim2.fromOffset(14,14);si.BackgroundColor3=Color3.fromRGB(12,35,50);si.Text="◯";si.TextColor3=C.CYAN;si.TextSize=23;si.Font=Enum.Font.GothamBold;si.Parent=status;corner(si,10);stroke(si,C.CYAN,.4,1)
text(status,"STATUS",UDim2.fromOffset(66,14),UDim2.fromOffset(100,18),12,C.WHITE,true);text(status,"Ready to start collecting...",UDim2.fromOffset(66,34),UDim2.fromOffset(220,16),8,C.MUTED,false)
local st=Instance.new("TextLabel");st.Size=UDim2.fromOffset(92,34);st.Position=UDim2.new(1,-106,0,17);st.BackgroundColor3=Color3.fromRGB(54,15,28);st.Text="■  Stopped";st.TextColor3=C.RED;st.Font=Enum.Font.GothamBold;st.TextSize=9;st.Parent=status;corner(st,10);stroke(st,C.RED,.5,1)
local start=Instance.new("TextButton");start.Size=UDim2.new(1,-28,0,62);start.Position=UDim2.fromOffset(14,92);start.BackgroundColor3=C.PURPLE;start.Text="▶   START AUTO COLLECT";start.TextColor3=C.WHITE;start.Font=Enum.Font.GothamBold;start.TextSize=14;start.AutoButtonColor=false;start.Parent=status;corner(start,11);stroke(start,C.PURPLE2,.02,1.2);grad(start,Color3.fromRGB(188,111,255),Color3.fromRGB(108,43,255),0)
local running=false;start.MouseButton1Click:Connect(function()running=not running;st.Text=running and "●  Running" or "■  Stopped";st.TextColor3=running and C.GREEN or C.RED;st.BackgroundColor3=running and Color3.fromRGB(14,49,34) or Color3.fromRGB(54,15,28);start.Text=running and "■   STOP AUTO COLLECT" or "▶   START AUTO COLLECT" end)

local info=card(ad,UDim2.fromOffset(18,600),UDim2.new(1,-36,0,62));local ii=Instance.new("TextLabel");ii.Size=UDim2.fromOffset(36,36);ii.Position=UDim2.fromOffset(13,13);ii.BackgroundColor3=Color3.fromRGB(30,24,52);ii.Text="ⓘ";ii.TextColor3=C.PURPLE2;ii.TextSize=16;ii.Font=Enum.Font.GothamBold;ii.Parent=info;corner(ii,9);text(info,"INFORMATION",UDim2.fromOffset(60,8),UDim2.fromOffset(140,18),10,C.WHITE,true);text(info,"Select plots, set the delay, then start auto collect.",UDim2.fromOffset(60,28),UDim2.fromOffset(390,18),8,C.MUTED,false);text(info,"SIMPLE   MODERN   CLEAN   BEAUTIFUL",UDim2.new(1,-285,0,16),UDim2.fromOffset(260,20),8,C.PURPLE2,true,Enum.TextXAlignment.Right)

-- simple placeholders for other tabs
for _,name in ipairs({"HOME","MAIN","VISUALS","PLAYER","WORLD","SETTINGS","CREDITS"})do local p=pages[name];local h=card(p,UDim2.fromOffset(18,92),UDim2.new(1,-36,0,150));text(h,name,UDim2.fromOffset(24,26),UDim2.new(1,-48,0,34),24,C.WHITE,true);text(h,"599 AREA V9 compact preview",UDim2.fromOffset(24,65),UDim2.new(1,-48,0,20),10,C.MUTED,false)end

-- smooth drag
local drag=false;local ds;local sp;local dragInput;local dragTween
local function upd(i)local d=i.Position-ds;local target=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y);if dragTween then dragTween:Cancel()end;dragTween=TweenService:Create(shell,TweenInfo.new(.07,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=target});dragTween:Play()end
top.InputBegan:Connect(function(i)if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) and not UIS:GetFocusedTextBox() then drag=true;ds=i.Position;sp=shell.Position;i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then drag=false end end)end end)
top.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end end)
UIS.InputChanged:Connect(function(i)if drag and i==dragInput then upd(i)end end)
local minimized=false;local full=UDim2.fromOffset(1080,680);local mini=UDim2.fromOffset(1080,72)
minBtn.MouseButton1Click:Connect(function()minimized=not minimized;minBtn.Text=minimized and "+" or "—";TweenService:Create(shell,TweenInfo.new(.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=minimized and mini or full}):Play()end)
maxBtn.MouseButton1Click:Connect(function()shell.Position=UDim2.fromScale(.5,.5)end)
closeBtn.MouseButton1Click:Connect(function()gui:Destroy()end)
RunService.RenderStepped:Connect(function()clockText.Text=os.date("%H:%M:%S")end)
selectTab("ANIME DICE")
