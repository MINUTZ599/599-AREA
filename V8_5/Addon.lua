-- 599 AREA V8.5 TRACKER ADDON - standalone chunk
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local base=pg:WaitForChild("AREA599_V8",10)
if not base then warn("[599 V8.5] base GUI missing") return end
local mouse=lp:GetMouse()
local clickTP=false
local waypoints={}
local esp={box=false,name=false,health=false,skeleton=false}
local selected=nil
local ORANGE=Color3.fromRGB(255,92,0)
local WHITE=Color3.fromRGB(245,245,247)
local MUTED=Color3.fromRGB(155,155,168)
local PANEL=Color3.fromRGB(16,16,20)
local GREEN=Color3.fromRGB(48,185,87)

local function corner(o,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=o end
local function label(par,s,pos,sz,col,bold)
 local x=Instance.new("TextLabel");x.BackgroundTransparency=1;x.Text=s;x.Position=pos;x.Size=sz;x.TextColor3=col or WHITE;x.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;x.TextSize=11;x.TextXAlignment=Enum.TextXAlignment.Left;x.Parent=par;return x
end
local function button(par,s,pos,sz)
 local b=Instance.new("TextButton");b.Text=s;b.Position=pos;b.Size=sz;b.BackgroundColor3=PANEL;b.TextColor3=ORANGE;b.Font=Enum.Font.GothamBold;b.TextSize=10;b.AutoButtonColor=false;b.Parent=par;corner(b,8);local st=Instance.new("UIStroke");st.Color=ORANGE;st.Transparency=.35;st.Parent=b;return b
end
local function toggle(par,s,pos)
 local b=button(par,s.."  [OFF]",pos,UDim2.fromOffset(440,48));return b
end
local function notify(s)
 pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="599 AREA V8.5",Text=s,Duration=2}) end)
end

-- Find original content frame via named PLAYER page.
local playerPage=base:FindFirstChild("PLAYER",true)
if not playerPage then warn("[599 V8.5] PLAYER page missing") return end
local content=playerPage.Parent
local main=content.Parent
local sidebar=nil
for _,d in ipairs(main:GetChildren()) do
 if d:IsA("Frame") and d~=content then
  local n=0;for _,c in ipairs(d:GetChildren()) do if c:IsA("TextButton") then n+=1 end end
  if n>=7 then sidebar=d break end
 end
end
if not sidebar then warn("[599 V8.5] sidebar missing") return end

local tab=button(sidebar,"◎   TRACKER+",UDim2.fromOffset(9,449),UDim2.new(1,-18,0,48));tab.TextColor3=MUTED;tab.TextXAlignment=Enum.TextXAlignment.Left
local pad=Instance.new("UIPadding");pad.PaddingLeft=UDim.new(0,14);pad.Parent=tab
local page=Instance.new("Frame");page.Name="TRACKER+";page.Size=UDim2.fromScale(1,1);page.BackgroundTransparency=1;page.Visible=false;page.Parent=content
label(page,"◎  TRACKER+",UDim2.fromOffset(4,0),UDim2.new(1,0,0,30),ORANGE,true).TextSize=18
local function showPage()
 for _,p in ipairs(content:GetChildren()) do if p:IsA("Frame") then p.Visible=(p==page) end end
 page.Visible=true
end
tab.MouseButton1Click:Connect(showPage)

local tpToggle=toggle(page,"CLICK TELEPORT [ T ]",UDim2.fromOffset(0,42))
local function setTP(v) clickTP=v;tpToggle.Text="CLICK TELEPORT [ T ]  ["..(v and "ON" or "OFF").."]";notify("Click Teleport "..(v and "ON" or "OFF")) end
tpToggle.MouseButton1Click:Connect(function() setTP(not clickTP) end)
UIS.InputBegan:Connect(function(i,g)
 if UIS:GetFocusedTextBox() then return end
 if i.KeyCode==Enum.KeyCode.T then setTP(not clickTP);return end
 if not g and clickTP and i.UserInputType==Enum.UserInputType.MouseButton1 and mouse.Target then
  local ch=lp.Character;local r=ch and ch:FindFirstChild("HumanoidRootPart");if r then r.CFrame=CFrame.new(mouse.Hit.Position+Vector3.new(0,3,0)) end
 end
end)

local trackBox=Instance.new("Frame");trackBox.Position=UDim2.fromOffset(0,104);trackBox.Size=UDim2.fromOffset(455,130);trackBox.BackgroundColor3=PANEL;trackBox.Parent=page;corner(trackBox,8)
label(trackBox,"🎯  PLAYER TRACKER+",UDim2.fromOffset(14,10),UDim2.new(1,-28,0,24),ORANGE,true)
local trackText=label(trackBox,"TARGET: select a player in PLAYER tab",UDim2.fromOffset(14,42),UDim2.new(1,-28,0,76),WHITE,false);trackText.TextWrapped=true;trackText.TextYAlignment=Enum.TextYAlignment.Top

local wpBox=Instance.new("Frame");wpBox.Position=UDim2.fromOffset(0,248);wpBox.Size=UDim2.fromOffset(455,294);wpBox.BackgroundColor3=PANEL;wpBox.Parent=page;corner(wpBox,8)
label(wpBox,"📍  WAYPOINT MANAGER",UDim2.fromOffset(14,10),UDim2.new(1,-28,0,24),ORANGE,true)
for i=1,5 do
 local y=42+(i-1)*46;local t=label(wpBox,"WP "..i.."  EMPTY",UDim2.fromOffset(14,y),UDim2.fromOffset(145,34),MUTED,true)
 local s=button(wpBox,"SAVE",UDim2.fromOffset(175,y),UDim2.fromOffset(120,34));local q=button(wpBox,"TP",UDim2.fromOffset(307,y),UDim2.fromOffset(120,34))
 s.MouseButton1Click:Connect(function() local r=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart");if r then waypoints[i]=r.CFrame;t.Text="WP "..i.."  SAVED";t.TextColor3=WHITE;notify("Waypoint "..i.." saved") end end)
 q.MouseButton1Click:Connect(function() local r=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart");if r and waypoints[i] then r.CFrame=waypoints[i]+Vector3.new(0,3,0);notify("Waypoint "..i) else notify("Waypoint empty") end end)
end

local keys={{"BOX ESP","box"},{"NAME + DISTANCE","name"},{"HEALTH BAR","health"},{"SKELETON ESP","skeleton"}}
for i,v in ipairs(keys) do
 local b=toggle(page,v[1],UDim2.fromOffset(490,42+(i-1)*62));b.MouseButton1Click:Connect(function() esp[v[2]]=not esp[v[2]];b.Text=v[1].."  ["..(esp[v[2]] and "ON" or "OFF").."]" end)
end

local overlay=Instance.new("ScreenGui");overlay.Name="AREA599_V85_ESP";overlay.ResetOnSpawn=false;overlay.IgnoreGuiInset=true;overlay.DisplayOrder=9998;overlay.Parent=pg
local visuals={}
local function getV(p)
 if visuals[p] then return visuals[p] end
 local box=Instance.new("Frame");box.BackgroundTransparency=1;box.Visible=false;box.Parent=overlay;local st=Instance.new("UIStroke");st.Color=ORANGE;st.Thickness=1.5;st.Parent=box
 local nm=label(overlay,"",UDim2.new(),UDim2.fromOffset(220,20),WHITE,true);nm.TextXAlignment=Enum.TextXAlignment.Center;nm.Visible=false
 local hp=Instance.new("Frame");hp.BackgroundColor3=GREEN;hp.BorderSizePixel=0;hp.Visible=false;hp.Parent=overlay
 visuals[p]={box=box,nm=nm,hp=hp};return visuals[p]
end
local function hide(v) v.box.Visible=false;v.nm.Visible=false;v.hp.Visible=false end
RS.RenderStepped:Connect(function()
 local myr=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
 for _,p in ipairs(Players:GetPlayers()) do
  if p~=lp then
   local v=getV(p);local ch=p.Character;local r=ch and ch:FindFirstChild("HumanoidRootPart");local h=ch and ch:FindFirstChildOfClass("Humanoid")
   if r and h then
    local pt,on=workspace.CurrentCamera:WorldToViewportPoint(r.Position)
    if on then
     local dist=myr and (r.Position-myr.Position).Magnitude or 0;local scale=math.clamp(2200/math.max(pt.Z,1),28,180);local w=scale*.55;local hh=scale
     v.box.Position=UDim2.fromOffset(pt.X-w/2,pt.Y-hh/2);v.box.Size=UDim2.fromOffset(w,hh);v.box.Visible=esp.box
     v.nm.Position=UDim2.fromOffset(pt.X-110,pt.Y-hh/2-22);v.nm.Text=p.DisplayName.."  ["..math.floor(dist).."m]";v.nm.Visible=esp.name
     local ratio=math.clamp(h.Health/math.max(h.MaxHealth,1),0,1);v.hp.Position=UDim2.fromOffset(pt.X-w/2-7,pt.Y-hh/2+hh*(1-ratio));v.hp.Size=UDim2.fromOffset(3,hh*ratio);v.hp.Visible=esp.health
    else hide(v) end
   else hide(v) end
  end
 end
 -- tracker follows currently spectated/nearest selected-ish target; prefer camera subject owner
 local subj=workspace.CurrentCamera.CameraSubject;selected=nil
 for _,p in ipairs(Players:GetPlayers()) do if p~=lp and p.Character and subj and subj:IsDescendantOf(p.Character) then selected=p break end end
 if selected and selected.Character then local r=selected.Character:FindFirstChild("HumanoidRootPart");local h=selected.Character:FindFirstChildOfClass("Humanoid");if r and h then local d=myr and (r.Position-myr.Position).Magnitude or 0;trackText.Text=string.format("TARGET: %s  @%s\nHP: %d/%d   DIST: %d studs\nPOS: %d, %d, %d",selected.DisplayName,selected.Name,h.Health,h.MaxHealth,d,r.Position.X,r.Position.Y,r.Position.Z) end end
end)
Players.PlayerRemoving:Connect(function(p) local v=visuals[p];if v then v.box:Destroy();v.nm:Destroy();v.hp:Destroy();visuals[p]=nil end end)
notify("V8.5 Tracker Edition loaded")