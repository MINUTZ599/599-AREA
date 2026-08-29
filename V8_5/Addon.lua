-- 599 AREA V8.5 - VISUALS INTEGRATED ADDON
-- Click TP + Player Tracker + Box/Skeleton/Health/Name ESP inside the original VISUALS page.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local StarterGui=game:GetService("StarterGui")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local base=pg:WaitForChild("AREA599_V8",10)
if not base then warn("[599 V8.5] base GUI missing") return end
local visualPage=base:FindFirstChild("VISUALS",true)
local playerPage=base:FindFirstChild("PLAYER",true)
if not visualPage or not playerPage then warn("[599 V8.5] VISUALS/PLAYER page missing") return end

local mouse=lp:GetMouse()
local ORANGE=Color3.fromRGB(255,92,0)
local ORANGE2=Color3.fromRGB(255,145,35)
local WHITE=Color3.fromRGB(245,245,247)
local MUTED=Color3.fromRGB(155,155,168)
local PANEL=Color3.fromRGB(16,16,20)
local GREEN=Color3.fromRGB(48,185,87)
local STROKE=Color3.fromRGB(111,51,15)
local state={clicktp=false,tracker=false,box=false,skeleton=false,health=false,name=false}

local function corner(o,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=o end
local function outline(o,col,tr,th) local s=Instance.new("UIStroke");s.Color=col or STROKE;s.Transparency=tr==nil and .45 or tr;s.Thickness=th or 1;s.Parent=o;return s end
local function label(par,s,pos,sz,col,bold,fs)
 local x=Instance.new("TextLabel");x.BackgroundTransparency=1;x.Text=s;x.Position=pos;x.Size=sz;x.TextColor3=col or WHITE;x.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;x.TextSize=fs or 11;x.TextXAlignment=Enum.TextXAlignment.Left;x.TextYAlignment=Enum.TextYAlignment.Center;x.Parent=par;return x
end
local function notify(s) pcall(function() StarterGui:SetCore("SendNotification",{Title="599 AREA V8.5",Text=s,Duration=2}) end) end
local function card(par,title,desc,pos)
 local f=Instance.new("Frame");f.Size=UDim2.fromOffset(455,64);f.Position=pos;f.BackgroundColor3=PANEL;f.BackgroundTransparency=.04;f.BorderSizePixel=0;f.Parent=par;corner(f,8);outline(f,STROKE,.42,1)
 label(f,title,UDim2.fromOffset(15,8),UDim2.new(1,-105,0,23),WHITE,true,12)
 label(f,desc,UDim2.fromOffset(15,34),UDim2.new(1,-110,0,18),MUTED,false,10)
 local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(62,30);b.Position=UDim2.new(1,-76,.5,-15);b.BackgroundColor3=Color3.fromRGB(42,42,49);b.Text="OFF";b.TextColor3=WHITE;b.Font=Enum.Font.GothamBold;b.TextSize=10;b.AutoButtonColor=false;b.Parent=f;corner(b,15)
 return b
end
local function setToggle(b,on) b.Text=on and "ON" or "OFF";b.BackgroundColor3=on and GREEN or Color3.fromRGB(42,42,49) end

-- Reuse the original VISUAL ENGINE panel as the lower-right status panel.
local infoPanel,infoText=nil,nil
for _,d in ipairs(visualPage:GetDescendants()) do
 if d:IsA("TextLabel") and d.Text=="VISUAL ENGINE" then infoPanel=d.Parent break end
end
if infoPanel and infoPanel:IsA("Frame") then
 infoPanel.Position=UDim2.fromOffset(490,346)
 infoPanel.Size=UDim2.fromOffset(455,196)
 for _,d in ipairs(infoPanel:GetChildren()) do if d:IsA("TextLabel") and d.Text~="VISUAL ENGINE" then infoText=d end end
 if infoText then infoText.Position=UDim2.fromOffset(14,46);infoText.Size=UDim2.new(1,-28,1,-54);infoText.Text="V8.5 VISUAL SUITE\n\nClick TP, Player Tracker and ESP+ are integrated directly into VISUALS." end
end

-- Left column continues under the four original VISUALS cards.
local clickBtn=card(visualPage,"CLICK TELEPORT [ T ]","Click a world point to teleport locally",UDim2.fromOffset(0,346))
local trackerBtn=card(visualPage,"PLAYER TRACKER","Track the player selected in PLAYER tab",UDim2.fromOffset(0,422))

-- Right column is dedicated to ESP+.
local boxBtn=card(visualPage,"BOX ESP","Draw a 2D box around visible players",UDim2.fromOffset(490,42))
local skeletonBtn=card(visualPage,"SKELETON ESP","Draw local body-bone lines",UDim2.fromOffset(490,118))
local healthBtn=card(visualPage,"HEALTH BAR","Show player health beside the box",UDim2.fromOffset(490,194))
local nameBtn=card(visualPage,"NAME + DISTANCE","Show display name and distance",UDim2.fromOffset(490,270))

local function bind(btn,key,title)
 btn.MouseButton1Click:Connect(function() state[key]=not state[key];setToggle(btn,state[key]);notify(title.." "..(state[key] and "ON" or "OFF")) end)
end
bind(clickBtn,"clicktp","Click Teleport")
bind(trackerBtn,"tracker","Player Tracker")
bind(boxBtn,"box","Box ESP")
bind(skeletonBtn,"skeleton","Skeleton ESP")
bind(healthBtn,"health","Health Bar")
bind(nameBtn,"name","Name + Distance")

UIS.InputBegan:Connect(function(input,gpe)
 if UIS:GetFocusedTextBox() then return end
 if input.KeyCode==Enum.KeyCode.T then state.clicktp=not state.clicktp;setToggle(clickBtn,state.clicktp);notify("Click Teleport "..(state.clicktp and "ON" or "OFF"));return end
 if not gpe and state.clicktp and input.UserInputType==Enum.UserInputType.MouseButton1 and mouse.Target then
  local ch=lp.Character;local root=ch and ch:FindFirstChild("HumanoidRootPart");local hum=ch and ch:FindFirstChildOfClass("Humanoid")
  if root and hum and hum.Health>0 then local _,yaw,_=root.CFrame:ToOrientation();root.CFrame=CFrame.new(mouse.Hit.Position+Vector3.new(0,3,0))*CFrame.Angles(0,yaw,0) end
 end
end)

local function selectedPlayerFromUI()
 for _,d in ipairs(playerPage:GetDescendants()) do
  if d:IsA("TextLabel") then
   local name=(d.Text or ""):match("@([%w_]+)%s+•%s+UserId")
   if name then local p=Players:FindFirstChild(name);if p and p~=lp then return p end end
  end
 end
 return nil
end

local old=pg:FindFirstChild("AREA599_V85_ESP");if old then old:Destroy() end
local overlay=Instance.new("ScreenGui");overlay.Name="AREA599_V85_ESP";overlay.ResetOnSpawn=false;overlay.IgnoreGuiInset=true;overlay.DisplayOrder=9998;overlay.Parent=pg
local skeletonPairs={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
local visuals={}
local function newLine() local f=Instance.new("Frame");f.AnchorPoint=Vector2.new(.5,.5);f.BackgroundColor3=ORANGE2;f.BorderSizePixel=0;f.Visible=false;f.ZIndex=42;f.Parent=overlay;return f end
local function getV(p)
 if visuals[p] then return visuals[p] end
 local box=Instance.new("Frame");box.BackgroundTransparency=1;box.BorderSizePixel=0;box.Visible=false;box.ZIndex=35;box.Parent=overlay;local st=outline(box,ORANGE,0,1.5)
 local nm=label(overlay,"",UDim2.new(),UDim2.fromOffset(240,20),WHITE,true,12);nm.TextXAlignment=Enum.TextXAlignment.Center;nm.Visible=false;nm.ZIndex=43
 local hpBack=Instance.new("Frame");hpBack.BackgroundColor3=Color3.fromRGB(30,30,34);hpBack.BorderSizePixel=0;hpBack.Visible=false;hpBack.ZIndex=36;hpBack.Parent=overlay
 local hp=Instance.new("Frame");hp.AnchorPoint=Vector2.new(0,1);hp.Position=UDim2.fromScale(0,1);hp.Size=UDim2.fromScale(1,1);hp.BackgroundColor3=GREEN;hp.BorderSizePixel=0;hp.ZIndex=37;hp.Parent=hpBack
 local lines={};for i=1,#skeletonPairs do lines[i]=newLine() end
 visuals[p]={box=box,stroke=st,nm=nm,hpBack=hpBack,hp=hp,lines=lines};return visuals[p]
end
local function hide(v) v.box.Visible=false;v.nm.Visible=false;v.hpBack.Visible=false;for _,l in ipairs(v.lines) do l.Visible=false end end
local function drawLine(f,a,b)
 local dx,dy=b.X-a.X,b.Y-a.Y;local len=math.sqrt(dx*dx+dy*dy);if len<1 then f.Visible=false return end
 f.Size=UDim2.fromOffset(len,2);f.Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2);f.Rotation=math.deg(math.atan2(dy,dx));f.Visible=true
end

RS.RenderStepped:Connect(function()
 local cam=workspace.CurrentCamera;if not cam then return end
 local myr=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
 local selected=selectedPlayerFromUI()
 for _,p in ipairs(Players:GetPlayers()) do
  if p~=lp then
   local v=getV(p);local ch=p.Character;local r=ch and ch:FindFirstChild("HumanoidRootPart");local h=ch and ch:FindFirstChildOfClass("Humanoid")
   if not r or not h or h.Health<=0 then hide(v) continue end
   local pt,on=cam:WorldToViewportPoint(r.Position);if not on or pt.Z<=0 then hide(v) continue end
   local dist=myr and (r.Position-myr.Position).Magnitude or 0;local scale=math.clamp(2200/math.max(pt.Z,1),28,180);local w=scale*.55;local hh=scale
   local tracked=state.tracker and selected==p
   v.box.Position=UDim2.fromOffset(pt.X-w/2,pt.Y-hh/2);v.box.Size=UDim2.fromOffset(w,hh);v.box.Visible=state.box or tracked;v.stroke.Color=tracked and ORANGE2 or ORANGE;v.stroke.Thickness=tracked and 2.5 or 1.5
   v.nm.Position=UDim2.fromOffset(pt.X-120,pt.Y-hh/2-22);v.nm.Text=(tracked and "🎯 " or "")..p.DisplayName.."  ["..math.floor(dist).."m]";v.nm.Visible=state.name or tracked;v.nm.TextColor3=tracked and ORANGE2 or WHITE
   local ratio=math.clamp(h.Health/math.max(h.MaxHealth,1),0,1);v.hpBack.Position=UDim2.fromOffset(pt.X-w/2-8,pt.Y-hh/2);v.hpBack.Size=UDim2.fromOffset(4,hh);v.hp.Size=UDim2.new(1,0,ratio,0);v.hpBack.Visible=state.health or tracked
   for idx,pair in ipairs(skeletonPairs) do
    local a=ch:FindFirstChild(pair[1]);local b=ch:FindFirstChild(pair[2]);local line=v.lines[idx]
    if state.skeleton and a and b and a:IsA("BasePart") and b:IsA("BasePart") then
     local pa,oa=cam:WorldToViewportPoint(a.Position);local pb,ob=cam:WorldToViewportPoint(b.Position)
     if oa and ob and pa.Z>0 and pb.Z>0 then drawLine(line,Vector2.new(pa.X,pa.Y),Vector2.new(pb.X,pb.Y)) else line.Visible=false end
    else line.Visible=false end
   end
  end
 end
 if infoText then
  if state.tracker then
   if selected and selected.Character then
    local r=selected.Character:FindFirstChild("HumanoidRootPart");local h=selected.Character:FindFirstChildOfClass("Humanoid")
    if r and h then local d=myr and (r.Position-myr.Position).Magnitude or 0;infoText.Text=string.format("TRACKING: %s  @%s\nHP: %d / %d   DIST: %d studs\nPOS: %d, %d, %d",selected.DisplayName,selected.Name,math.floor(h.Health),math.floor(h.MaxHealth),math.floor(d),math.floor(r.Position.X),math.floor(r.Position.Y),math.floor(r.Position.Z)) else infoText.Text="PLAYER TRACKER ON\nTarget character unavailable." end
   else infoText.Text="PLAYER TRACKER ON\nSelect a player first from the PLAYER tab." end
  else infoText.Text="V8.5 VISUAL SUITE\n\nClick TP, Player Tracker and ESP+ are integrated directly into VISUALS." end
 end
end)

Players.PlayerRemoving:Connect(function(p)
 local v=visuals[p];if not v then return end
 pcall(function() v.box:Destroy() end);pcall(function() v.nm:Destroy() end);pcall(function() v.hpBack:Destroy() end);for _,l in ipairs(v.lines) do pcall(function() l:Destroy() end) end;visuals[p]=nil
end)

notify("V8.5 Visuals Integrated loaded")