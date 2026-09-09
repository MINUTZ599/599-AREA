-- 599 AREA V9 PREVIEW - VISUAL ENHANCER
-- Additive UI polish only. Does not touch V8.5 stable.

local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local shell=gui:FindFirstChild("Shell")
if not shell then return end

local PURPLE=Color3.fromRGB(145,72,255)
local PURPLE2=Color3.fromRGB(194,132,255)
local DEEP=Color3.fromRGB(11,8,21)
local WHITE=Color3.fromRGB(248,246,255)

local function corner(o,r)
 local c=o:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
 c.CornerRadius=UDim.new(0,r or 12);c.Parent=o;return c
end
local function stroke(o,col,tr,th,name)
 local s=o:FindFirstChild(name or "V9EnhanceStroke")
 if not s then s=Instance.new("UIStroke");s.Name=name or "V9EnhanceStroke";s.Parent=o end
 s.Color=col or PURPLE;s.Transparency=tr or .5;s.Thickness=th or 1;return s
end
local function tween(o,t,props)
 TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),props):Play()
end

-- outer neon depth
local outer=Instance.new("Frame")
outer.Name="V9OuterGlow"
outer.AnchorPoint=Vector2.new(.5,.5)
outer.Position=UDim2.fromScale(.5,.5)
outer.Size=UDim2.new(1,18,1,18)
outer.BackgroundTransparency=1
outer.ZIndex=-5
outer.Parent=shell
corner(outer,24)
stroke(outer,PURPLE,.55,3,"GlowA")
local outer2=outer:Clone();outer2.Name="V9OuterGlow2";outer2.Size=UDim2.new(1,32,1,32);outer2.Parent=shell
local s2=outer2:FindFirstChild("GlowA");if s2 then s2.Transparency=.82;s2.Thickness=5 end

-- subtle top accent line
local topLine=Instance.new("Frame")
topLine.Name="V9TopAccent"
topLine.Size=UDim2.new(1,-28,0,2)
topLine.Position=UDim2.fromOffset(14,8)
topLine.BackgroundColor3=PURPLE
topLine.BorderSizePixel=0
topLine.ZIndex=50
topLine.Parent=shell
corner(topLine,2)
local gl=Instance.new("UIGradient")
gl.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(55,24,102)),ColorSequenceKeypoint.new(.5,PURPLE2),ColorSequenceKeypoint.new(1,Color3.fromRGB(55,24,102))})
gl.Parent=topLine

-- animated ambient glows
for i=1,3 do
 local g=Instance.new("Frame")
 g.Name="V9AmbientGlow"..i
 g.Size=UDim2.fromOffset(260+i*70,260+i*70)
 g.Position=UDim2.fromOffset(430+i*130,-170+i*70)
 g.BackgroundColor3=i==2 and Color3.fromRGB(88,42,200) or PURPLE
 g.BackgroundTransparency=.955
 g.BorderSizePixel=0
 g.ZIndex=-2
 g.Parent=shell
 corner(g,400)
 task.spawn(function()
  local dir=1
  while g.Parent do
   tween(g,2.6,{BackgroundTransparency=dir==1 and .925 or .965})
   dir=-dir
   task.wait(2.65)
  end
 end)
end

-- hover polish for all buttons
for _,d in ipairs(gui:GetDescendants()) do
 if d:IsA("TextButton") then
  d.AutoButtonColor=false
  local baseSize=d.Size
  local baseColor=d.BackgroundColor3
  d.MouseEnter:Connect(function()
   tween(d,.12,{BackgroundColor3=baseColor:Lerp(PURPLE,.16)})
  end)
  d.MouseLeave:Connect(function()
   tween(d,.15,{BackgroundColor3=baseColor})
  end)
  d.MouseButton1Down:Connect(function()
   tween(d,.07,{Size=UDim2.new(baseSize.X.Scale,baseSize.X.Offset-4,baseSize.Y.Scale,baseSize.Y.Offset-2)})
  end)
  d.MouseButton1Up:Connect(function()
   tween(d,.1,{Size=baseSize})
  end)
 end
end

-- find Anime Dice page and polish its cards
local anime=shell:FindFirstChild("ANIME DICE",true)
if anime then
 for _,d in ipairs(anime:GetDescendants()) do
  if d:IsA("Frame") then
   if d.AbsoluteSize.X>240 and d.AbsoluteSize.Y>70 then
    stroke(d,Color3.fromRGB(102,63,168),.48,1,"AnimeGlassStroke")
   end
  elseif d:IsA("TextLabel") and d.Text:find("ANIME") then
   d.TextStrokeColor3=Color3.fromRGB(47,20,92)
   d.TextStrokeTransparency=.45
  end
 end

 -- decorative badge row near hero if room allows
 local hero=nil
 for _,d in ipairs(anime:GetChildren()) do
  if d:IsA("Frame") and d.AbsoluteSize.Y>=130 and d.AbsoluteSize.Y<=180 then hero=d break end
 end
 if hero then
  local tags={"⚡ FAST","◇ CLEAN","◈ STABLE","▥ EFFICIENT"}
  for i,txt in ipairs(tags) do
   local b=Instance.new("TextLabel")
   b.Size=UDim2.fromOffset(84,24)
   b.Position=UDim2.fromOffset(122+(i-1)*92,102)
   b.BackgroundColor3=Color3.fromRGB(20,15,36)
   b.BackgroundTransparency=.08
   b.Text=txt
   b.TextColor3=i==1 and WHITE or PURPLE2
   b.Font=Enum.Font.GothamBold
   b.TextSize=8
   b.ZIndex=40
   b.Parent=hero
   corner(b,12)
   stroke(b,PURPLE,.55,1,"TagStroke")
  end
 end
end

-- profile/status accent
for _,d in ipairs(gui:GetDescendants()) do
 if d:IsA("TextLabel") and (d.Text=="Premium User" or d.Text:find("V9 PREVIEW")) then
  d.TextColor3=PURPLE2
 end
end

-- tiny moving sheen over large purple action buttons
for _,d in ipairs(gui:GetDescendants()) do
 if d:IsA("TextButton") and d.AbsoluteSize.X>220 and d.AbsoluteSize.Y>38 then
  local sheen=Instance.new("Frame")
  sheen.Name="V9Sheen"
  sheen.Size=UDim2.fromOffset(70,d.AbsoluteSize.Y+8)
  sheen.Position=UDim2.new(0,-90,0,-4)
  sheen.BackgroundColor3=Color3.new(1,1,1)
  sheen.BackgroundTransparency=.88
  sheen.BorderSizePixel=0
  sheen.Rotation=12
  sheen.ZIndex=d.ZIndex+1
  sheen.Parent=d
  corner(sheen,20)
  task.spawn(function()
   while sheen.Parent do
    sheen.Position=UDim2.new(0,-90,0,-4)
    tween(sheen,1.4,{Position=UDim2.new(1,20,0,-4)})
    task.wait(4.2)
   end
  end)
 end
end

-- smooth shell entrance
local oldPos=shell.Position
shell.Position=UDim2.new(oldPos.X.Scale,oldPos.X.Offset,oldPos.Y.Scale,oldPos.Y.Offset+18)
shell.BackgroundTransparency=.08
tween(shell,.32,{Position=oldPos,BackgroundTransparency=0})

-- pulse active neon strokes softly
RunService.RenderStepped:Connect(function()
 local x=(math.sin(os.clock()*2.2)+1)/2
 for _,d in ipairs(gui:GetDescendants()) do
  if d:IsA("UIStroke") and (d.Name=="ActiveStroke" or d.Name=="TagStroke") then
   d.Transparency=.18+.22*x
  end
 end
end)
