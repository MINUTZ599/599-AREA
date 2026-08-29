-- 599 AREA V8.5 - AIR WALK ADDON
-- Air Walk + adjustable height slider in MOVEMENT.

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local StarterGui=game:GetService("StarterGui")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local base=pg:WaitForChild("AREA599_V8",10)
if not base then return end
local movementPage=base:FindFirstChild("MOVEMENT",true)
if not movementPage then return end

for _,n in ipairs({"V85_AIRWALK_CARD","V85_AIRWALK_HEIGHT"}) do local x=movementPage:FindFirstChild(n);if x then x:Destroy() end end
local oldPlatform=workspace:FindFirstChild("AREA599_AIRWALK_"..lp.UserId);if oldPlatform then oldPlatform:Destroy() end

local PANEL=Color3.fromRGB(16,16,20);local WHITE=Color3.fromRGB(245,245,247);local MUTED=Color3.fromRGB(155,155,168);local GREEN=Color3.fromRGB(48,185,87);local ORANGE=Color3.fromRGB(255,92,0);local STROKE=Color3.fromRGB(111,51,15)
local enabled=false;local platform=nil;local baseY=nil;local heightOffset=0
local function corner(o,r)local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=o end
local function outline(o)local s=Instance.new("UIStroke");s.Color=STROKE;s.Transparency=.42;s.Thickness=1;s.Parent=o end
local function label(p,t,pos,sz,col,bold,size)local x=Instance.new("TextLabel");x.BackgroundTransparency=1;x.Text=t;x.Position=pos;x.Size=sz;x.TextColor3=col or WHITE;x.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;x.TextSize=size or 11;x.TextXAlignment=Enum.TextXAlignment.Left;x.Parent=p;return x end
local function notify(m)pcall(function()StarterGui:SetCore("SendNotification",{Title="599 AREA V8.5",Text=m,Duration=2})end)end

local card=Instance.new("Frame");card.Name="V85_AIRWALK_CARD";card.Size=UDim2.fromOffset(455,64);card.Position=UDim2.fromOffset(490,400);card.BackgroundColor3=PANEL;card.BackgroundTransparency=.04;card.BorderSizePixel=0;card.Parent=movementPage;corner(card);outline(card)
label(card,"AIR WALK [ H ]",UDim2.fromOffset(15,8),UDim2.new(1,-105,0,23),WHITE,true,12)
label(card,"Walk in mid-air without falling",UDim2.fromOffset(15,34),UDim2.new(1,-110,0,18),MUTED,false,10)
local toggle=Instance.new("TextButton");toggle.Size=UDim2.fromOffset(62,30);toggle.Position=UDim2.new(1,-76,.5,-15);toggle.BackgroundColor3=Color3.fromRGB(42,42,49);toggle.Text="OFF";toggle.TextColor3=WHITE;toggle.Font=Enum.Font.GothamBold;toggle.TextSize=10;toggle.AutoButtonColor=false;toggle.Parent=card;corner(toggle,15)

local slider=Instance.new("Frame");slider.Name="V85_AIRWALK_HEIGHT";slider.Size=UDim2.fromOffset(455,76);slider.Position=UDim2.fromOffset(490,476);slider.BackgroundColor3=PANEL;slider.BackgroundTransparency=.04;slider.BorderSizePixel=0;slider.Parent=movementPage;corner(slider);outline(slider)
label(slider,"AIR WALK HEIGHT",UDim2.fromOffset(15,7),UDim2.fromOffset(250,20),WHITE,true,11)
local valueLabel=label(slider,"0",UDim2.new(1,-65,0,7),UDim2.fromOffset(50,20),ORANGE,true,11);valueLabel.TextXAlignment=Enum.TextXAlignment.Right
local bar=Instance.new("Frame");bar.Position=UDim2.fromOffset(15,43);bar.Size=UDim2.new(1,-30,0,5);bar.BackgroundColor3=Color3.fromRGB(48,48,55);bar.BorderSizePixel=0;bar.Parent=slider;corner(bar,3)
local fill=Instance.new("Frame");fill.Size=UDim2.fromScale(.5,1);fill.BackgroundColor3=ORANGE;fill.BorderSizePixel=0;fill.Parent=bar;corner(fill,3)
local knob=Instance.new("TextButton");knob.AnchorPoint=Vector2.new(.5,.5);knob.Position=UDim2.fromScale(.5,.5);knob.Size=UDim2.fromOffset(16,16);knob.BackgroundColor3=ORANGE;knob.Text="";knob.AutoButtonColor=false;knob.Parent=bar;corner(knob,8)
local dragging=false
local function updateSlider(x)
 local a=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1);local v=math.floor((-20+a*60)+.5);heightOffset=v;local norm=(v+20)/60;fill.Size=UDim2.fromScale(norm,1);knob.Position=UDim2.fromScale(norm,.5);valueLabel.Text=(v>0 and "+" or "")..v.." studs"
end
knob.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true end end)
bar.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;updateSlider(i.Position.X) end end)
UIS.InputChanged:Connect(function(i)if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then updateSlider(i.Position.X) end end)
UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)

local function destroyPlatform()if platform then platform:Destroy();platform=nil end end
local function createPlatform()destroyPlatform();platform=Instance.new("Part");platform.Name="AREA599_AIRWALK_"..lp.UserId;platform.Anchored=true;platform.CanCollide=true;platform.CanTouch=false;platform.CanQuery=false;platform.Transparency=1;platform.Size=Vector3.new(8,.6,8);platform.CastShadow=false;platform.Parent=workspace end
local function setAirWalk(on)
 enabled=on;toggle.Text=on and "ON" or "OFF";toggle.BackgroundColor3=on and GREEN or Color3.fromRGB(42,42,49)
 if on then local ch=lp.Character;local r=ch and ch:FindFirstChild("HumanoidRootPart");local h=ch and ch:FindFirstChildOfClass("Humanoid");if not r or not h or h.Health<=0 then enabled=false;toggle.Text="OFF";return end;baseY=r.Position.Y-3.15;createPlatform();notify("Air Walk ON") else baseY=nil;destroyPlatform();notify("Air Walk OFF") end
end
toggle.MouseButton1Click:Connect(function()setAirWalk(not enabled)end)
UIS.InputBegan:Connect(function(i,g)if not g and not UIS:GetFocusedTextBox() and i.KeyCode==Enum.KeyCode.H then setAirWalk(not enabled)end end)
RunService.Heartbeat:Connect(function()
 if not enabled then return end;local ch=lp.Character;local r=ch and ch:FindFirstChild("HumanoidRootPart");local h=ch and ch:FindFirstChildOfClass("Humanoid");if not r or not h or h.Health<=0 then destroyPlatform();return end
 if not platform or not platform.Parent then baseY=r.Position.Y-3.15-heightOffset;createPlatform() end
 platform.CFrame=CFrame.new(r.Position.X,baseY+heightOffset,r.Position.Z)
end)
lp.CharacterAdded:Connect(function(ch)destroyPlatform();if not enabled then return end;local r=ch:WaitForChild("HumanoidRootPart",10);if r then baseY=r.Position.Y-3.15-heightOffset;createPlatform()end end)
notify("Air Walk + Height Control loaded")
