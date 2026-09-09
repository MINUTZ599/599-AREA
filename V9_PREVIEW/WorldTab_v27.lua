-- 599 AREA V9 PREVIEW v27 - WORLD TAB MIGRATION
-- Only populates WORLD. V26 base/features remain untouched.
local Players=game:GetService("Players")
local Lighting=game:GetService("Lighting")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")

local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local page=gui:FindFirstChild("WORLD",true)
if not page then warn("[599 V27] WORLD page missing") return end

local old=page:FindFirstChild("V27_WORLD")
if old then old:Destroy() end

local holder=Instance.new("Frame")
holder.Name="V27_WORLD"
holder.Size=UDim2.new(1,0,1,0)
holder.BackgroundTransparency=1
holder.Parent=page

local PURPLE=Color3.fromRGB(138,61,255)
local PURPLE2=Color3.fromRGB(191,100,255)
local CARD=Color3.fromRGB(14,14,27)
local CARD2=Color3.fromRGB(18,16,32)
local WHITE=Color3.fromRGB(245,243,255)
local MUTED=Color3.fromRGB(150,144,172)
local STROKE=Color3.fromRGB(73,54,112)

local title=Instance.new("TextLabel")
title.Position=UDim2.fromOffset(20,76)
title.Size=UDim2.new(1,-40,0,28)
title.BackgroundTransparency=1
title.Text="WORLD"
title.TextColor3=WHITE
title.Font=Enum.Font.GothamBold
title.TextSize=22
title.TextXAlignment=Enum.TextXAlignment.Left
title.Parent=holder

local sub=Instance.new("TextLabel")
sub.Position=UDim2.fromOffset(20,103)
sub.Size=UDim2.new(1,-40,0,18)
sub.BackgroundTransparency=1
sub.Text="World controls + Skybox Manager migrated from 599 AREA V8.5"
sub.TextColor3=PURPLE2
sub.Font=Enum.Font.Gotham
sub.TextSize=10
sub.TextXAlignment=Enum.TextXAlignment.Left
sub.Parent=holder

local scroll=Instance.new("ScrollingFrame")
scroll.Name="WorldScroll"
scroll.Position=UDim2.fromOffset(20,132)
scroll.Size=UDim2.new(1,-40,1,-150)
scroll.BackgroundTransparency=1
scroll.BorderSizePixel=0
scroll.ScrollBarThickness=3
scroll.ScrollBarImageColor3=PURPLE2
scroll.CanvasSize=UDim2.fromOffset(0,590)
scroll.Parent=holder

local function corner(o,r)
 local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 10);c.Parent=o
end
local function stroke(o,col,tr,th)
 local s=Instance.new("UIStroke");s.Color=col or STROKE;s.Transparency=tr or .2;s.Thickness=th or 1;s.Parent=o;return s
end
local function label(par,txt,pos,size,fs,col,bold)
 local t=Instance.new("TextLabel");t.BackgroundTransparency=1;t.Position=pos;t.Size=size;t.Text=txt;t.TextColor3=col or WHITE;t.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;t.TextSize=fs or 11;t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=par;return t
end
local function button(par,txt,pos,size)
 local b=Instance.new("TextButton");b.Position=pos;b.Size=size;b.BackgroundColor3=Color3.fromRGB(34,20,60);b.Text=txt;b.TextColor3=WHITE;b.Font=Enum.Font.GothamBold;b.TextSize=11;b.AutoButtonColor=false;b.Parent=par;corner(b,9);stroke(b,PURPLE2,.12,1.3)
 b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(54,26,94)}):Play() end)
 b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(34,20,60)}):Play() end)
 return b
end

-- WORLD CONTROLS
local controls=Instance.new("Frame")
controls.Size=UDim2.new(1,-6,0,150)
controls.BackgroundColor3=CARD
controls.BorderSizePixel=0
controls.Parent=scroll
corner(controls,12);stroke(controls)
label(controls,"WORLD CONTROLS",UDim2.fromOffset(15,10),UDim2.new(1,-30,0,22),13,PURPLE2,true)
label(controls,"Local gravity",UDim2.fromOffset(15,42),UDim2.fromOffset(130,18),10,MUTED,false)
local gravValue=label(controls,tostring(math.floor(workspace.Gravity)),UDim2.new(1,-95,0,39),UDim2.fromOffset(75,22),11,WHITE,true)
gravValue.TextXAlignment=Enum.TextXAlignment.Right

local bar=Instance.new("Frame")
bar.Position=UDim2.fromOffset(15,69)
bar.Size=UDim2.new(1,-30,0,8)
bar.BackgroundColor3=Color3.fromRGB(48,45,64)
bar.BorderSizePixel=0
bar.Parent=controls
corner(bar,4)
local fill=Instance.new("Frame")
fill.Size=UDim2.new(math.clamp(workspace.Gravity/500,0,1),0,1,0)
fill.BackgroundColor3=PURPLE2
fill.BorderSizePixel=0
fill.Parent=bar
corner(fill,4)
local dragging=false
local function setGravity(x)
 local w=bar.AbsoluteSize.X;if w<=0 then return end
 local pct=math.clamp((x-bar.AbsolutePosition.X)/w,0,1)
 local v=math.floor(500*pct+.5)
 fill.Size=UDim2.new(pct,0,1,0);gravValue.Text=tostring(v);workspace.Gravity=v
end
bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;setGravity(i.Position.X) end end)
UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then setGravity(i.Position.X) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)

local day=button(controls,"☀  SET DAY",UDim2.fromOffset(15,94),UDim2.new(.5,-23,0,42))
local night=button(controls,"☾  SET NIGHT",UDim2.new(.5,8,0,94),UDim2.new(.5,-23,0,42))
day.MouseButton1Click:Connect(function() Lighting.ClockTime=14 end)
night.MouseButton1Click:Connect(function() Lighting.ClockTime=0 end)

-- SKYBOX MANAGER
local skybox=Instance.new("Frame")
skybox.Position=UDim2.fromOffset(0,164)
skybox.Size=UDim2.new(1,-6,0,410)
skybox.BackgroundColor3=CARD
skybox.BorderSizePixel=0
skybox.Parent=scroll
corner(skybox,12);stroke(skybox)
label(skybox,"SKYBOX MANAGER",UDim2.fromOffset(15,10),UDim2.new(1,-30,0,22),13,PURPLE2,true)
local status=label(skybox,"ACTIVE: ORIGINAL SKY",UDim2.fromOffset(15,34),UDim2.new(1,-30,0,18),9,MUTED,false)

local original={}
for _,v in ipairs(Lighting:GetChildren()) do if v:IsA("Sky") then original[#original+1]=v:Clone() end end
local function clearSky() for _,v in ipairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end end
local function applySky(id,name)
 clearSky();local a="rbxassetid://"..id;local s=Instance.new("Sky");s.Name="599_AREA_SKY_"..name
 s.SkyboxBk=a;s.SkyboxDn=a;s.SkyboxFt=a;s.SkyboxLf=a;s.SkyboxRt=a;s.SkyboxUp=a;s.Parent=Lighting
 status.Text="ACTIVE: "..name.."  •  "..id
end
local function resetSky()
 clearSky();for _,v in ipairs(original) do v:Clone().Parent=Lighting end;status.Text="ACTIVE: ORIGINAL SKY"
end

local presets={
 {Name="599 AREA",Id="126519323866401"},
 {Name="599 AREA 2",Id="86301017321800"},
 {Name="SKY 1",Id="130316008595492"},
 {Name="SKY 2",Id="125716730217872"},
 {Name="SKY 3",Id="86111082891584"},
}

for i,p in ipairs(presets) do
 local y=62+(i-1)*55
 local c=Instance.new("Frame");c.Position=UDim2.fromOffset(15,y);c.Size=UDim2.new(1,-30,0,48);c.BackgroundColor3=CARD2;c.BorderSizePixel=0;c.Parent=skybox;corner(c,9);stroke(c,Color3.fromRGB(61,48,89),.28,1)
 label(c,p.Name,UDim2.fromOffset(12,4),UDim2.new(1,-130,0,19),11,WHITE,true)
 label(c,"ID: "..p.Id,UDim2.fromOffset(12,24),UDim2.new(1,-130,0,15),9,MUTED,false)
 local b=button(c,"APPLY",UDim2.new(1,-105,.5,-16),UDim2.fromOffset(92,32))
 b.MouseButton1Click:Connect(function() applySky(p.Id,p.Name) end)
end

local reset=button(skybox,"RESET TO ORIGINAL SKY",UDim2.fromOffset(15,347),UDim2.new(1,-30,0,44))
reset.MouseButton1Click:Connect(resetSky)
