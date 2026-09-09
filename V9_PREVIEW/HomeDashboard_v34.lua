-- 599 AREA V9 PREVIEW v34 - HOME DASHBOARD ONLY
-- IMPORTANT: touches HOME page only. All approved tabs/features remain untouched.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Stats=game:GetService("Stats")
local TweenService=game:GetService("TweenService")

local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local home=gui:FindFirstChild("HOME",true)
if not home then warn("[599 V34] HOME missing") return end

-- HOME ONLY: remove old HOME placeholder.
for _,c in ipairs(home:GetChildren()) do c:Destroy() end

local PURPLE=Color3.fromRGB(145,62,255)
local PURPLE2=Color3.fromRGB(205,118,255)
local CARD=Color3.fromRGB(11,11,22)
local CARD2=Color3.fromRGB(15,14,29)
local WHITE=Color3.fromRGB(246,243,255)
local MUTED=Color3.fromRGB(151,144,174)
local GREEN=Color3.fromRGB(83,255,155)
local CYAN=Color3.fromRGB(72,207,255)
local GOLD=Color3.fromRGB(255,194,93)
local STROKE=Color3.fromRGB(87,52,132)

local function corner(o,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 10);c.Parent=o end
local function stroke(o,col,tr,th) local s=Instance.new("UIStroke");s.Color=col or STROKE;s.Transparency=tr or .28;s.Thickness=th or 1;s.Parent=o;return s end
local function txt(par,text,pos,size,fs,col,bold)
 local t=Instance.new("TextLabel");t.BackgroundTransparency=1;t.Position=pos;t.Size=size;t.Text=text;t.TextColor3=col or WHITE;t.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;t.TextSize=fs or 10;t.TextXAlignment=Enum.TextXAlignment.Left;t.TextYAlignment=Enum.TextYAlignment.Center;t.Parent=par;return t
end
local function card(par,pos,size)
 local f=Instance.new("Frame");f.Position=pos;f.Size=size;f.BackgroundColor3=CARD;f.BorderSizePixel=0;f.Parent=par;corner(f,11);stroke(f);return f
end
local function button(par,label,pos,size)
 local b=Instance.new("TextButton");b.Position=pos;b.Size=size;b.BackgroundColor3=CARD2;b.BorderSizePixel=0;b.Text=label;b.TextColor3=WHITE;b.Font=Enum.Font.GothamBold;b.TextSize=9;b.AutoButtonColor=false;b.Parent=par;corner(b,9);local s=stroke(b,Color3.fromRGB(91,57,137),.28,1)
 b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(37,20,61)}):Play();s.Color=PURPLE end)
 b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=CARD2}):Play();s.Color=Color3.fromRGB(91,57,137) end)
 return b
end

local scroll=Instance.new("ScrollingFrame")
scroll.Name="V34_HOME"
scroll.Position=UDim2.fromOffset(16,68)
scroll.Size=UDim2.new(1,-32,1,-82)
scroll.BackgroundTransparency=1
scroll.BorderSizePixel=0
scroll.ScrollBarThickness=3
scroll.ScrollBarImageColor3=PURPLE
scroll.CanvasSize=UDim2.fromOffset(0,760)
scroll.Parent=home

-- HERO. Uses the same Roblox image asset already approved in the project.
local hero=Instance.new("Frame")
hero.Size=UDim2.new(1,-6,0,188);hero.BackgroundColor3=Color3.fromRGB(9,7,18);hero.BorderSizePixel=0;hero.ClipsDescendants=true;hero.Parent=scroll;corner(hero,13);stroke(hero,PURPLE,.05,1.4)
local img=Instance.new("ImageLabel")
img.Size=UDim2.new(.64,0,1,0);img.Position=UDim2.new(.36,0,0,0);img.BackgroundTransparency=1;img.Image="rbxassetid://95794241567731";img.ScaleType=Enum.ScaleType.Crop;img.ImageTransparency=.05;img.Parent=hero
local shade=Instance.new("Frame");shade.Size=UDim2.new(.53,0,1,0);shade.BackgroundColor3=Color3.fromRGB(9,7,18);shade.BackgroundTransparency=.05;shade.BorderSizePixel=0;shade.Parent=hero
local grad=Instance.new("UIGradient");grad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.68,.05),NumberSequenceKeypoint.new(1,1)});grad.Parent=shade
local brand=txt(hero,"599\nAREA",UDim2.fromOffset(22,18),UDim2.fromOffset(170,68),28,PURPLE2,true);brand.TextYAlignment=Enum.TextYAlignment.Top
local ver=txt(hero,"V33 STABLE",UDim2.fromOffset(22,88),UDim2.fromOffset(180,24),15,PURPLE2,true)
txt(hero,"PREMIUM SCRIPT HUB FOR ROBLOX",UDim2.fromOffset(22,113),UDim2.fromOffset(230,18),8,Color3.fromRGB(221,185,255),true)
txt(hero,"GOOD SCRIPTS MAKE THE GAME MORE FUN.",UDim2.fromOffset(22,142),UDim2.fromOffset(250,18),8,WHITE,true)
txt(hero,"— 599 AREA",UDim2.fromOffset(22,159),UDim2.fromOffset(150,16),8,MUTED,false)

-- TOP LIVE CARDS
local y=200
local status=card(scroll,UDim2.fromOffset(0,y),UDim2.new(.25,-7,0,78))
txt(status,"599 AREA STATUS",UDim2.fromOffset(13,9),UDim2.new(1,-26,0,16),8,MUTED,true)
txt(status,"READY",UDim2.fromOffset(13,26),UDim2.new(1,-26,0,32),23,PURPLE2,true)
txt(status,"ALL SYSTEMS OPERATIONAL",UDim2.fromOffset(13,58),UDim2.new(1,-26,0,12),6,MUTED,false)

local fpsCard=card(scroll,UDim2.new(.25,2,0,y),UDim2.new(.25,-7,0,78))
txt(fpsCard,"FPS",UDim2.fromOffset(13,10),UDim2.new(1,-26,0,16),9,MUTED,true)
local fpsText=txt(fpsCard,"--",UDim2.fromOffset(13,30),UDim2.new(1,-26,0,32),20,GREEN,true)

local pingCard=card(scroll,UDim2.new(.5,4,0,y),UDim2.new(.25,-7,0,78))
txt(pingCard,"PING",UDim2.fromOffset(13,10),UDim2.new(1,-26,0,16),9,MUTED,true)
local pingText=txt(pingCard,"-- MS",UDim2.fromOffset(13,30),UDim2.new(1,-26,0,32),18,CYAN,true)

local timeCard=card(scroll,UDim2.new(.75,6,0,y),UDim2.new(.25,-12,0,78))
txt(timeCard,"TIME / PLAYERS",UDim2.fromOffset(13,10),UDim2.new(1,-26,0,16),9,MUTED,true)
local timeText=txt(timeCard,"--:--:--",UDim2.fromOffset(13,29),UDim2.new(1,-26,0,23),15,GOLD,true)
local playersText=txt(timeCard,"PLAYERS: "..#Players:GetPlayers(),UDim2.fromOffset(13,54),UDim2.new(1,-26,0,16),8,PURPLE2,true)

-- SCRIPT STATUS
local script=card(scroll,UDim2.fromOffset(0,290),UDim2.new(.42,-5,0,200))
txt(script,"SCRIPT STATUS",UDim2.fromOffset(14,10),UDim2.new(1,-28,0,22),12,PURPLE2,true)
local statusRows={{"NOCLIP","N"},{"FLY","F"},{"FREECAM","C"},{"SPECTATE","V"},{"CLICK TELEPORT","T"}}
for i,v in ipairs(statusRows) do
 local yy=39+(i-1)*30
 txt(script,v[1],UDim2.fromOffset(14,yy),UDim2.new(1,-105,0,22),9,WHITE,true)
 local key=txt(script,v[2],UDim2.new(1,-50,0,yy),UDim2.fromOffset(32,22),9,PURPLE2,true);key.TextXAlignment=Enum.TextXAlignment.Center;key.BackgroundTransparency=0;key.BackgroundColor3=Color3.fromRGB(28,20,47);corner(key,6)
end

-- GAME INFO
local info=card(scroll,UDim2.new(.42,7,0,290),UDim2.new(.58,-13,0,200))
txt(info,"GAME INFORMATION",UDim2.fromOffset(14,10),UDim2.new(1,-28,0,22),12,PURPLE2,true)
local gameName="ROBLOX EXPERIENCE"
pcall(function() gameName=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
local rows={{"GAME",gameName},{"PLACE ID",tostring(game.PlaceId)},{"JOB ID",game.JobId~="" and string.sub(game.JobId,1,22).."..." or "STUDIO / LOCAL"},{"PLAYERS",tostring(#Players:GetPlayers())},{"VERSION","V33 STABLE"}}
for i,r in ipairs(rows) do
 local yy=43+(i-1)*29
 txt(info,r[1],UDim2.fromOffset(14,yy),UDim2.fromOffset(88,20),8,MUTED,true)
 local val=txt(info,r[2],UDim2.fromOffset(105,yy),UDim2.new(1,-120,0,20),8,WHITE,i==5);val.TextTruncate=Enum.TextTruncate.AtEnd
end

-- QUICK ACCESS
local quick=card(scroll,UDim2.fromOffset(0,502),UDim2.new(.55,-5,0,116))
txt(quick,"QUICK ACCESS",UDim2.fromOffset(14,10),UDim2.new(1,-28,0,20),11,PURPLE2,true)
txt(quick,"Jump to your favorite section",UDim2.fromOffset(14,29),UDim2.new(1,-28,0,16),7,MUTED,false)
local destinations={{"MAIN","MAIN"},{"VISUALS","VISUALS"},{"PLAYER","PLAYER"},{"ANIME DICE","ANIME DICE"}}
for i,d in ipairs(destinations) do
 local b=button(quick,d[1],UDim2.new((i-1)/4,10+(i-1)*2,0,55),UDim2.new(.25,-14,0,45))
 b.MouseButton1Click:Connect(function()
  local target=gui:FindFirstChild(d[2],true)
  if target then
   for _,name in ipairs({"HOME","MAIN","VISUALS","PLAYER","WORLD","ANIME DICE","SETTINGS","CREDITS"}) do local p=gui:FindFirstChild(name,true);if p and p:IsA("Frame") then p.Visible=(p==target) end end
  end
 end)
end

-- KEYBINDS
local keys=card(scroll,UDim2.new(.55,7,0,502),UDim2.new(.45,-13,0,116))
txt(keys,"KEYBIND GUIDE",UDim2.fromOffset(14,10),UDim2.new(1,-28,0,20),11,PURPLE2,true)
local keyRows={{"F","Fly"},{"N","Noclip"},{"V","Spectate"},{"C","Freecam"},{"T","Click TP"}}
for i,k in ipairs(keyRows) do
 local x=(i-1)/5
 local box=Instance.new("Frame");box.Position=UDim2.new(x,8+(i-1)*2,0,48);box.Size=UDim2.new(.2,-10,0,54);box.BackgroundColor3=CARD2;box.BorderSizePixel=0;box.Parent=keys;corner(box,8)
 local kk=txt(box,k[1],UDim2.fromOffset(0,5),UDim2.new(1,0,0,22),11,PURPLE2,true);kk.TextXAlignment=Enum.TextXAlignment.Center
 local nm=txt(box,k[2],UDim2.fromOffset(0,27),UDim2.new(1,0,0,18),6,WHITE,true);nm.TextXAlignment=Enum.TextXAlignment.Center
end

-- LATEST UPDATE
local update=card(scroll,UDim2.fromOffset(0,630),UDim2.new(1,-6,0,105))
txt(update,"LATEST UPDATE  •  V33 STABLE",UDim2.fromOffset(14,10),UDim2.new(1,-28,0,20),11,PURPLE2,true)
txt(update,"Responsive Noclip [N]  •  Spectate [V]  •  Freecam [C]  •  UI overlap resolved  •  Anime Dice integrated",UDim2.fromOffset(14,37),UDim2.new(1,-28,0,20),8,WHITE,false)
txt(update,"599 AREA  •  STABLE BUILD",UDim2.fromOffset(14,67),UDim2.new(1,-28,0,18),7,MUTED,true)

-- live stats
local frames=0
local last=os.clock()
local fps=0
RunService.RenderStepped:Connect(function()
 frames+=1
 local now=os.clock()
 if now-last>=.5 then fps=math.floor(frames/(now-last)+.5);frames=0;last=now;fpsText.Text=tostring(fps) end
end)
task.spawn(function()
 while gui.Parent and home.Parent do
  local ping="--"
  pcall(function() ping=tostring(math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()+.5)) end)
  pingText.Text=ping.." MS"
  timeText.Text=os.date("%H:%M:%S")
  playersText.Text="PLAYERS: "..#Players:GetPlayers()
  task.wait(1)
 end
end)

print("[599 V34] HOME dashboard loaded - HOME ONLY")