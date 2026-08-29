-- 599 AREA V8.5 - VISUALS INTEGRATION ADDON
-- Click TP + Player Tracker + ESP+ live inside the original VISUALS page.
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
local clickTP=false
local esp={box=false,name=false,health=false,skeleton=false}
local ORANGE=Color3.fromRGB(255,92,0)
local ORANGE2=Color3.fromRGB(255,145,35)
local WHITE=Color3.fromRGB(245,245,247)
local MUTED=Color3.fromRGB(155,155,168)
local PANEL=Color3.fromRGB(16,16,20)
local GREEN=Color3.fromRGB(48,185,87)
local STROKE=Color3.fromRGB(111,51,15)

local function corner(o,r)
 local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=o
end
local function outline(o,col,tr,th)
 local s=Instance.new("UIStroke");s.Color=col or STROKE;s.Transparency=tr==nil and .45 or tr;s.Thickness=th or 1;s.Parent=o;return s
end
local function label(par,s,pos,sz,col,bold,fs)
 local x=Instance.new("TextLabel");x.BackgroundTransparency=1;x.Text=s;x.Position=pos;x.Size=sz;x.TextColor3=col or WHITE;x.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;x.TextSize=fs or 11;x.TextXAlignment=Enum.TextXAlignment.Left;x.Parent=par;return x
end
local function notify(s)
 pcall(function() StarterGui:SetCore("SendNotification",{Title="599 AREA V8.5",Text=s,Duration=2}) end)
end
local function card(par,title,desc,pos)
 local f=Instance.new("Frame");f.Size=UDim2.fromOffset(455,64);f.Position=pos;f.BackgroundColor3=PANEL;f.BackgroundTransparency=.04;f.BorderSizePixel=0;f.Parent=par;corner(f,8);outline(f,STROKE,.42,1)
 label(f,title,UDim2.fromOffset(15,8),UDim2.new(1,-105,0,23),WHITE,true,12)
 label(f,desc,UDim2.fromOffset(15,34),UDim2.new(1,-110,0,18),MUTED,false,10)
 local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(62,30);b.Position=UDim2.new(1,-76,.5,-15);b.BackgroundColor3=Color3.fromRGB(42,42,49);b.Text="OFF";b.TextColor3=WHITE;b.Font=Enum.Font.GothamBold;b.TextSize=10;b.AutoButtonColor=false;b.Parent=f;corner(b,15)
 return b
end
local function setToggle(b,on)
 b.Text=on and "ON" or "OFF";b.BackgroundColor3=on and GREEN or Color3.fromRGB(42,42,49)
end

-- Remove the old right-side VISUAL ENGINE info panel to make room for V8.5 controls.
for _,d in ipairs(visualPage:GetDescendants()) do
 if d:IsA("TextLabel") and d.Text=="VISUAL ENGINE" then
  local p=d.Parent
  if p and p~=visualPage then p:Destroy() end
  break
 end
end

-- New V8.5 controls, styled like the original VISUALS cards.
local clickBtn=card(visualPage,"CLICK TELEPORT [ T ]","Click a world point to teleport locally",UDim2.fromOffset(490,42))
local boxBtn=card(visualPage,"BOX ESP","Draw a 2D box around visible players",UDim2.fromOffset(490,118))
local skeletonBtn=card(visualPage,"SKELETON ESP","Draw a local skeleton over player rigs",UDim2.fromOffset(490,194))
local healthBtn=card(visualPage,"HEALTH BAR","Show a health bar beside each ESP box",UDim2.fromOffset(490,270))
local nameBtn=card(visualPage,"NAME + DISTANCE","Show display name and distance above players",UDim2.fromOffset(490,346))

local tracker=Instance.new("Frame");tracker.Size=UDim2.fromOffset(455,120);tracker.Position=UDim2.fromOffset(490,422);tracker.BackgroundColor3=PANEL;tracker.BackgroundTransparency=.04;tracker.BorderSizePixel=0;tracker.Parent=visualPage;corner(tracker,8);outline(tracker,STROKE,.42,1)
label(tracker,"🎯  PLAYER TRACKER",UDim2.fromOffset(14,10),UDim2.new(1,-28,0,24),ORANGE,true,12)
local trackerText=label(tracker,"TARGET: select a player in PLAYER tab",UDim2.fromOffset(14,40),UDim2.new(1,-28,0,68),WHITE,false,10);trackerText.TextWrapped=true;trackerText.TextYAlignment=Enum.TextYAlignment.Top

local function setClick(v)
 clickTP=v;setToggle(clickBtn,v);notify("Click Teleport "..(v and "ON" or "OFF"))
end
clickBtn.MouseButton1Click:Connect(function() setClick(not clickTP) end)

local function bindEsp(btn,key,name)
 btn.MouseButton1Click:Connect(function()
  esp[key]=not esp[key];setToggle(btn,esp[key]);notify(name.." "..(esp[key] and "ON" or "OFF"))
 end)
end
bindEsp(boxBtn,"box","Box ESP")
bindEsp(skeletonBtn,"skeleton","Skeleton ESP")
bindEsp(healthBtn,"health","Health Bar")
bindEsp(nameBtn,"name","Name + Distance")

UIS.InputBegan:Connect(function(i,g)
 if UIS:GetFocusedTextBox() then return end
 if i.KeyCode==Enum.KeyCode.T then setClick(not clickTP);return end
 if not g and clickTP and i.UserInputType==Enum.UserInputType.MouseButton1 and mouse.Target then
  local ch=lp.Character;local r=ch and ch:FindFirstChild("HumanoidRootPart")
  if r then
   local _,y,_=r.CFrame:ToOrientation();r.CFrame=CFrame.new(mouse.Hit.Position+Vector3.new(0,3,0))*CFrame.Angles(0,y,0)
  end
 end
end)

local old=pg:FindFirstChild("AREA599_V85_ESP")
if old then old:Destroy() end
local overlay=Instance.new("ScreenGui");overlay.Name="AREA599_V85_ESP";overlay.ResetOnSpawn=false;overlay.IgnoreGuiInset=true;overlay.DisplayOrder=9998;overlay.Parent=pg
local visuals={}
local skeletonPairs={
 {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
 {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
 {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
 {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
 {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
 {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}
}
local function newLine()
 local f=Instance.new("Frame");f.AnchorPoint=Vector2.new(.5,.5);f.BackgroundColor3=ORANGE2;f.BorderSizePixel=0;f.Visible=false;f.ZIndex=42;f.Parent=overlay;return f
end
local function getV(p)
 if visuals[p] then return visuals[p] end
 local box=Instance.new("Frame");box.BackgroundTransparency=1;box.BorderSizePixel=0;box.Visible=false;box.ZIndex=35;box.Parent=overlay;local st=Instance.new("UIStroke");st.Color=ORANGE;st.Thickness=1.5;st.Parent=box
 local nm=label(overlay,"",UDim2.new(),UDim2.fromOffset(240,20),WHITE,true,12);nm.TextXAlignment=Enum.TextXAlignment.Center;nm.Visible=false;nm.ZIndex=43
 local hpBack=Instance.new("Frame");hpBack.BackgroundColor3=Color3.fromRGB(30,30,34);hpBack.BorderSizePixel=0;hpBack.Visible=false;hpBack.ZIndex=36;hpBack.Parent=overlay
 local hp=Instance.new("Frame");hp.AnchorPoint=Vector2.new(0,1);hp.Position=UDim2.fromScale(0,1);hp.Size=UDim2.fromScale(1,1);hp.BackgroundColor3=GREEN;hp.BorderSizePixel=0;hp.ZIndex=37;hp.Parent=hpBack
 local lines={};for i=1,#skeletonPairs do lines[i]=newLine() end
 visuals[p]={box=box,nm=nm,hpBack=hpBack,hp=hp,lines=lines};return visuals[p]
end
local function hide(v)
 v.box.Visible=false;v.nm.Visible=false;v.hpBack.Visible=false;for _,l in ipairs(v.lines) do l.Visible=false end
end
local function drawLine(f,a,b)
 local dx,dy=b.X-a.X,b.Y-a.Y;local len=math.sqrt(dx*dx+dy*dy)
 if len<1 then f.Visible=false return end
 f.Size=UDim2.fromOffset(len,2);f.Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2);f.Rotation=math.deg(math.atan2(dy,dx));f.Visible=true
end
local function selectedPlayerFromUI()
 for _,d in ipairs(playerPage:GetDescendants()) do
  if d:IsA("TextLabel") and type(d.Text)=="string" then
   local name=d.Text:match("@([%w_]+)%s+•%s+UserId")
   if name then return Players:FindFirstChild(name) end
  end
 end
 return nil
end

RS.RenderStepped:Connect(function()
 local cam=workspace.CurrentCamera
 local myr=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
 for _,p in ipairs(Players:GetPlayers()) do
  if p~=lp then
   local v=getV(p);local ch=p.Character;local r=ch and ch:FindFirstChild("HumanoidRootPart");local h=ch and ch:FindFirstChildOfClass("Humanoid")
   if r and h and h.Health>0 then
    local pt,on=cam:WorldToViewportPoint(r.Position)
    if on and pt.Z>0 then
     local dist=myr and (r.Position-myr.Position).Magnitude or 0
     local scale=math.clamp(2200/math.max(pt.Z,1),28,180);local w=scale*.55;local hh=scale
     v.box.Position=UDim2.fromOffset(pt.X-w/2,pt.Y-hh/2);v.box.Size=UDim2.fromOffset(w,hh);v.box.Visible=esp.box
     v.nm.Position=UDim2.fromOffset(pt.X-120,pt.Y-hh/2-22);v.nm.Text=p.DisplayName.."  ["..math.floor(dist).."m]";v.nm.Visible=esp.name
     local ratio=math.clamp(h.Health/math.max(h.MaxHealth,1),0,1);v.hpBack.Position=UDim2.fromOffset(pt.X-w/2-7,pt.Y-hh/2);v.hpBack.Size=UDim2.fromOffset(3,hh);v.hp.Size=UDim2.new(1,0,ratio,0);v.hpBack.Visible=esp.health
     for idx,pair in ipairs(skeletonPairs) do
      local a=ch:FindFirstChild(pair[1]);local b=ch:FindFirstChild(pair[2]);local line=v.lines[idx]
      if esp.skeleton and a and b and a:IsA("BasePart") and b:IsA("BasePart") then
       local pa,oa=cam:WorldToViewportPoint(a.Position);local pb,ob=cam:WorldToViewportPoint(b.Position)
       if oa and ob and pa.Z>0 and pb.Z>0 then drawLine(line,Vector2.new(pa.X,pa.Y),Vector2.new(pb.X,pb.Y)) else line.Visible=false end
      else line.Visible=false end
     end
    else hide(v) end
   else hide(v) end
  end
 end
 local s=selectedPlayerFromUI()
 if s and s.Character then
  local r=s.Character:FindFirstChild("HumanoidRootPart");local h=s.Character:FindFirstChildOfClass("Humanoid")
  if r and h then
   local d=myr and (r.Position-myr.Position).Magnitude or 0
   trackerText.Text=string.format("TARGET: %s  @%s\nHP: %d/%d   DIST: %d studs\nPOS: %d, %d, %d",s.DisplayName,s.Name,math.floor(h.Health),math.floor(h.MaxHealth),math.floor(d),math.floor(r.Position.X),math.floor(r.Position.Y),math.floor(r.Position.Z))
  end
 else trackerText.Text="TARGET: select a player in PLAYER tab" end
end)

Players.PlayerRemoving:Connect(function(p)
 local v=visuals[p];if not v then return end
 pcall(function() v.box:Destroy();v.nm:Destroy();v.hpBack:Destroy() end);for _,l in ipairs(v.lines) do pcall(function() l:Destroy() end) end;visuals[p]=nil
end)

notify("V8.5 Visuals integration loaded")