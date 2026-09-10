-- 599 AREA V9 PREVIEW v29 - SETTINGS TAB MIGRATION
-- Only populates SETTINGS. Earlier approved tabs remain untouched.
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local Lighting=game:GetService("Lighting")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local page=gui:FindFirstChild("SETTINGS",true)
local root=gui:FindFirstChild("Root",true)
if not page or not root then warn("[599 V29] SETTINGS/Root missing") return end

local old=page:FindFirstChild("V29_SETTINGS") if old then old:Destroy() end
local holder=Instance.new("Frame")
holder.Name="V29_SETTINGS"
holder.Size=UDim2.fromScale(1,1)
holder.BackgroundTransparency=1
holder.Parent=page

local PURPLE=Color3.fromRGB(138,61,255)
local PURPLE2=Color3.fromRGB(191,100,255)
local CARD=Color3.fromRGB(14,14,27)
local WHITE=Color3.fromRGB(245,243,255)
local MUTED=Color3.fromRGB(146,140,170)
local GREEN=Color3.fromRGB(91,255,160)

local function txt(par,text,pos,size,fs,col,bold)
 local t=Instance.new("TextLabel");t.BackgroundTransparency=1;t.Position=pos;t.Size=size;t.Text=text;t.TextColor3=col or WHITE;t.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;t.TextSize=fs or 10;t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=par;return t
end
local function card(pos,size)
 local f=Instance.new("Frame");f.Position=pos;f.Size=size;f.BackgroundColor3=CARD;f.BorderSizePixel=0;f.Parent=holder;Instance.new("UICorner",f).CornerRadius=UDim.new(0,12);local s=Instance.new("UIStroke",f);s.Color=Color3.fromRGB(72,48,105);s.Transparency=.25;return f
end
local function button(par,label,pos,size)
 local b=Instance.new("TextButton");b.Position=pos;b.Size=size;b.BackgroundColor3=Color3.fromRGB(22,18,37);b.BorderSizePixel=0;b.Text=label;b.TextColor3=WHITE;b.Font=Enum.Font.GothamBold;b.TextSize=10;b.AutoButtonColor=false;b.Parent=par;Instance.new("UICorner",b).CornerRadius=UDim.new(0,9);local s=Instance.new("UIStroke",b);s.Color=Color3.fromRGB(91,58,136);s.Transparency=.25;return b
end

local title=txt(holder,"SETTINGS",UDim2.fromOffset(20,76),UDim2.new(1,-40,0,28),22,WHITE,true)
txt(holder,"Customize 599 AREA without changing your feature layout",UDim2.fromOffset(20,104),UDim2.new(1,-40,0,18),10,PURPLE2,false)

-- GENERAL
local general=card(UDim2.fromOffset(20,138),UDim2.new(.5,-30,0,206))
txt(general,"GENERAL",UDim2.fromOffset(16,12),UDim2.new(1,-32,0,24),13,PURPLE2,true)

-- Neon Glow #2 notification toggle
local label=txt(general,"NOTIFICATIONS",UDim2.fromOffset(16,54),UDim2.new(1,-120,0,20),11,WHITE,true)
txt(general,"Allow 599 AREA popup status messages",UDim2.fromOffset(16,76),UDim2.new(1,-120,0,18),8,MUTED,false)
local sw=Instance.new("TextButton");sw.Size=UDim2.fromOffset(72,32);sw.Position=UDim2.new(1,-90,0,56);sw.BackgroundColor3=Color3.fromRGB(89,26,173);sw.Text="";sw.AutoButtonColor=false;sw.Parent=general;Instance.new("UICorner",sw).CornerRadius=UDim.new(1,0)
local sws=Instance.new("UIStroke",sw);sws.Color=PURPLE2;sws.Thickness=2
local knob=Instance.new("Frame");knob.Size=UDim2.fromOffset(24,24);knob.Position=UDim2.fromOffset(44,4);knob.BackgroundColor3=Color3.fromRGB(250,240,255);knob.BorderSizePixel=0;knob.Parent=sw;Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
getgenv().AREA599_NOTIFICATIONS=true
local notif=true
local function renderNotif(v)
 notif=v;getgenv().AREA599_NOTIFICATIONS=v
 TweenService:Create(knob,TweenInfo.new(.16),{Position=v and UDim2.fromOffset(44,4) or UDim2.fromOffset(4,4),BackgroundColor3=v and Color3.fromRGB(250,240,255) or Color3.fromRGB(150,150,178)}):Play()
 TweenService:Create(sw,TweenInfo.new(.16),{BackgroundColor3=v and Color3.fromRGB(89,26,173) or Color3.fromRGB(15,15,29)}):Play()
 sws.Color=v and PURPLE2 or Color3.fromRGB(80,75,110);sws.Thickness=v and 2 or 1.3
end
sw.MouseButton1Click:Connect(function() renderNotif(not notif) end)

local reset=button(general,"RESET ALL FEATURES",UDim2.fromOffset(16,118),UDim2.new(1,-32,0,48))
reset.TextColor3=Color3.fromRGB(255,140,165)
reset.MouseButton1Click:Connect(function()
 local ch=lp.Character;local hum=ch and ch:FindFirstChildOfClass("Humanoid");local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
 if hum then hum.WalkSpeed=16;hum.UseJumpPower=true;hum.JumpPower=50;hum.PlatformStand=false end
 if hrp then hrp.Anchored=false end
 workspace.Gravity=196.2
 for _,p in ipairs(Players:GetPlayers()) do if p.Character then for _,d in ipairs(p.Character:GetDescendants()) do if d:IsA("Highlight") and string.find(d.Name,"599",1,true) then d:Destroy() end end end end
 local ov=pg:FindFirstChild("AREA599_V25_VISUAL_OVERLAY") if ov then ov:Destroy() end
 task.defer(function()
   local src=game:HttpGet("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/LoaderClean_v41.lua?reset="..tostring(math.floor(os.clock()*1000)))
   local fn=loadstring(src);if fn then fn() end
 end)
end)

-- UI SCALE
local scaleCard=card(UDim2.new(.5,10,0,138),UDim2.new(.5,-30,0,206))
txt(scaleCard,"UI SCALE",UDim2.fromOffset(16,12),UDim2.new(1,-32,0,24),13,PURPLE2,true)
local value=txt(scaleCard,"100%",UDim2.new(1,-86,0,50),UDim2.fromOffset(70,22),12,WHITE,true);value.TextXAlignment=Enum.TextXAlignment.Right
local bar=Instance.new("Frame");bar.Position=UDim2.fromOffset(16,88);bar.Size=UDim2.new(1,-32,0,8);bar.BackgroundColor3=Color3.fromRGB(42,38,55);bar.BorderSizePixel=0;bar.Active=true;bar.Parent=scaleCard;Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
local fill=Instance.new("Frame");fill.Size=UDim2.new(2/3,0,1,0);fill.BackgroundColor3=PURPLE;fill.BorderSizePixel=0;fill.Parent=bar;Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
local UIS=game:GetService("UserInputService")
local dragging=false
local baseScale=root:FindFirstChildOfClass("UIScale")
local function setScale(x)
 local pct=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
 local v=math.floor(60+60*pct+.5)
 fill.Size=UDim2.new(pct,0,1,0);value.Text=v.."%"
 if baseScale then baseScale.Scale=v/100 end
end
bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;setScale(i.Position.X) end end)
UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then setScale(i.Position.X) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
txt(scaleCard,"60%",UDim2.fromOffset(16,104),UDim2.fromOffset(60,18),8,MUTED,false)
local mx=txt(scaleCard,"120%",UDim2.new(1,-76,0,104),UDim2.fromOffset(60,18),8,MUTED,false);mx.TextXAlignment=Enum.TextXAlignment.Right

-- APPEARANCE
local appearance=card(UDim2.fromOffset(20,360),UDim2.new(1,-40,0,160))
txt(appearance,"BACKGROUND / PANEL INTENSITY",UDim2.fromOffset(16,12),UDim2.new(1,-32,0,24),13,PURPLE2,true)
txt(appearance,"Adjust only the main panel darkness. Anime Dice banner and approved artwork stay untouched.",UDim2.fromOffset(16,38),UDim2.new(1,-32,0,20),8,MUTED,false)
local strong=button(appearance,"STRONG",UDim2.fromOffset(16,78),UDim2.new(1/3,-22,0,48))
local medium=button(appearance,"MEDIUM",UDim2.new(1/3,6,0,78),UDim2.new(1/3,-20,0,48))
local soft=button(appearance,"SOFT",UDim2.new(2/3,4,0,78),UDim2.new(1/3,-20,0,48))
strong.MouseButton1Click:Connect(function() root.BackgroundTransparency=0 end)
medium.MouseButton1Click:Connect(function() root.BackgroundTransparency=.08 end)
soft.MouseButton1Click:Connect(function() root.BackgroundTransparency=.16 end)

print("[599 V29] SETTINGS migrated")