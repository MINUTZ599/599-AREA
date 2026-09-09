-- 599 AREA V9 PREVIEW v26 - PLAYER TAB MIGRATION
-- Only populates PLAYER and exposes the selected target for VISUALS Player Tracker.
local Players=game:GetService("Players")
local RS=game:GetService("RunService")
local TweenService=game:GetService("TweenService")

local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local page=gui:FindFirstChild("PLAYER",true)
if not page then warn("[599 V26] PLAYER page missing") return end

for _,c in ipairs(page:GetChildren()) do
    if c.Name=="V26_PLAYER" then c:Destroy() end
end

local holder=Instance.new("Frame")
holder.Name="V26_PLAYER"
holder.Size=UDim2.fromScale(1,1)
holder.BackgroundTransparency=1
holder.Parent=page

local PURPLE=Color3.fromRGB(138,61,255)
local PURPLE2=Color3.fromRGB(191,100,255)
local CARD=Color3.fromRGB(14,14,27)
local CARD2=Color3.fromRGB(18,18,34)
local WHITE=Color3.fromRGB(245,243,255)
local MUTED=Color3.fromRGB(146,140,170)
local GREEN=Color3.fromRGB(91,255,160)
local RED=Color3.fromRGB(255,94,118)

local selected=nil
local spectating=false
_G.AREA599_SELECTED_PLAYER=nil

local function corner(o,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 10);c.Parent=o end
local function stroke(o,col,tr,th) local s=Instance.new("UIStroke");s.Color=col or PURPLE;s.Transparency=tr or .35;s.Thickness=th or 1;s.Parent=o;return s end
local function label(par,txt,pos,size,fs,col,bold)
    local t=Instance.new("TextLabel");t.BackgroundTransparency=1;t.Text=txt;t.Position=pos;t.Size=size;t.TextColor3=col or WHITE;t.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham;t.TextSize=fs or 10;t.TextXAlignment=Enum.TextXAlignment.Left;t.TextYAlignment=Enum.TextYAlignment.Center;t.Parent=par;return t
end
local function button(par,txt,pos,size,col)
    local b=Instance.new("TextButton");b.Position=pos;b.Size=size;b.BackgroundColor3=CARD2;b.BorderSizePixel=0;b.Text=txt;b.TextColor3=col or PURPLE2;b.Font=Enum.Font.GothamBold;b.TextSize=10;b.AutoButtonColor=false;b.Parent=par;corner(b,9);stroke(b,col or PURPLE,.35,1);return b
end

label(holder,"PLAYER",UDim2.fromOffset(20,76),UDim2.new(1,-40,0,28),22,WHITE,true)
label(holder,"Search, inspect, spectate, and teleport to players",UDim2.fromOffset(20,103),UDim2.new(1,-40,0,18),10,PURPLE2,false)

local left=Instance.new("Frame");left.Position=UDim2.fromOffset(20,136);left.Size=UDim2.new(.55,-26,0,384);left.BackgroundColor3=CARD;left.BorderSizePixel=0;left.Parent=holder;corner(left,12);stroke(left,Color3.fromRGB(70,48,104),.3,1)
local right=Instance.new("Frame");right.Position=UDim2.new(.55,6,0,136);right.Size=UDim2.new(.45,-26,0,384);right.BackgroundColor3=CARD;right.BorderSizePixel=0;right.Parent=holder;corner(right,12);stroke(right,Color3.fromRGB(70,48,104),.3,1)

local search=Instance.new("TextBox");search.Position=UDim2.fromOffset(12,12);search.Size=UDim2.new(1,-24,0,40);search.BackgroundColor3=CARD2;search.BorderSizePixel=0;search.PlaceholderText="Search player...";search.PlaceholderColor3=MUTED;search.Text="";search.TextColor3=WHITE;search.Font=Enum.Font.Gotham;search.TextSize=11;search.ClearTextOnFocus=false;search.Parent=left;corner(search,9);stroke(search,PURPLE,.45,1)

local list=Instance.new("ScrollingFrame");list.Position=UDim2.fromOffset(12,62);list.Size=UDim2.new(1,-24,1,-74);list.BackgroundTransparency=1;list.BorderSizePixel=0;list.ScrollBarThickness=3;list.ScrollBarImageColor3=PURPLE2;list.CanvasSize=UDim2.new();list.Parent=left
local layout=Instance.new("UIListLayout");layout.Padding=UDim.new(0,6);layout.Parent=list

label(right,"PLAYER INFO",UDim2.fromOffset(14,10),UDim2.new(1,-28,0,25),14,PURPLE2,true)
local avatar=Instance.new("ImageLabel");avatar.Position=UDim2.fromOffset(16,48);avatar.Size=UDim2.fromOffset(82,82);avatar.BackgroundColor3=CARD2;avatar.BorderSizePixel=0;avatar.Image="";avatar.Parent=right;corner(avatar,41);stroke(avatar,PURPLE,.2,1)
local display=label(right,"No player selected",UDim2.fromOffset(112,55),UDim2.new(1,-126,0,26),15,WHITE,true)
local username=label(right,"",UDim2.fromOffset(112,82),UDim2.new(1,-126,0,40),9,MUTED,false)
username.TextWrapped=true
local stats=label(right,"HEALTH: --   DIST: --",UDim2.fromOffset(16,145),UDim2.new(1,-32,0,22),10,PURPLE2,true)

local spec=button(right,"SPECTATE",UDim2.fromOffset(16,184),UDim2.new(.5,-24,0,44),PURPLE2)
local tp=button(right,"TELEPORT",UDim2.new(.5,8,0,184),UDim2.new(.5,-24,0,44),RED)
local prev=button(right,"◀  PREV",UDim2.fromOffset(16,238),UDim2.new(.5,-24,0,40),PURPLE2)
local nextb=button(right,"NEXT  ▶",UDim2.new(.5,8,0,238),UDim2.new(.5,-24,0,40),PURPLE2)
local stopSpec=button(right,"STOP SPECTATE",UDim2.fromOffset(16,290),UDim2.new(1,-32,0,40),GREEN)

local hint=label(right,"Selected target is shared with VISUALS → Player Tracker.",UDim2.fromOffset(16,338),UDim2.new(1,-32,0,32),9,MUTED,false);hint.TextWrapped=true

local function setSelected(p)
    selected=p
    _G.AREA599_SELECTED_PLAYER=p
    if not p then
        display.Text="No player selected";username.Text="";avatar.Image="";stats.Text="HEALTH: --   DIST: --";return
    end
    display.Text=p.DisplayName
    username.Text="@"..p.Name.."  •  UserId "..tostring(p.UserId)
    task.spawn(function()
        local ok,img=pcall(function() return Players:GetUserThumbnailAsync(p.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) end)
        if ok and selected==p then avatar.Image=img end
    end)
end

local function rebuild()
    for _,v in ipairs(list:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local q=string.lower(search.Text or "")
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=lp then
            local key=string.lower(p.Name.." "..p.DisplayName)
            if q=="" or string.find(key,q,1,true) then
                local row=Instance.new("TextButton");row.Size=UDim2.new(1,-4,0,46);row.BackgroundColor3=CARD2;row.BorderSizePixel=0;row.Text=p.DisplayName.."   @"..p.Name;row.TextColor3=WHITE;row.Font=Enum.Font.GothamSemibold;row.TextSize=10;row.TextXAlignment=Enum.TextXAlignment.Left;row.AutoButtonColor=false;row.Parent=list;corner(row,8)
                local pad=Instance.new("UIPadding");pad.PaddingLeft=UDim.new(0,12);pad.Parent=row
                row.MouseButton1Click:Connect(function() setSelected(p) end)
            end
        end
    end
    task.defer(function() list.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+8) end)
end

local function pool()
    local t={} for _,p in ipairs(Players:GetPlayers()) do if p~=lp then t[#t+1]=p end end return t
end
local function cycle(step)
    local t=pool();if #t==0 then setSelected(nil) return end
    local idx=0 for i,p in ipairs(t) do if p==selected then idx=i break end end
    idx=((idx-1+step)%#t)+1;setSelected(t[idx])
end

spec.MouseButton1Click:Connect(function()
    local ch=selected and selected.Character;local h=ch and ch:FindFirstChildOfClass("Humanoid")
    if h then workspace.CurrentCamera.CameraType=Enum.CameraType.Custom;workspace.CurrentCamera.CameraSubject=h;spectating=true end
end)
stopSpec.MouseButton1Click:Connect(function()
    spectating=false
    local h=lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if h then workspace.CurrentCamera.CameraType=Enum.CameraType.Custom;workspace.CurrentCamera.CameraSubject=h end
end)
tp.MouseButton1Click:Connect(function()
    local myr=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local tr=selected and selected.Character and selected.Character:FindFirstChild("HumanoidRootPart")
    if myr and tr then myr.CFrame=tr.CFrame*CFrame.new(0,0,4) end
end)
prev.MouseButton1Click:Connect(function() cycle(-1) end)
nextb.MouseButton1Click:Connect(function() cycle(1) end)
search:GetPropertyChangedSignal("Text"):Connect(rebuild)
Players.PlayerAdded:Connect(rebuild)
Players.PlayerRemoving:Connect(function(p) if selected==p then setSelected(nil) end rebuild() end)

RS.RenderStepped:Connect(function()
    local ch=selected and selected.Character
    local h=ch and ch:FindFirstChildOfClass("Humanoid")
    local tr=ch and ch:FindFirstChild("HumanoidRootPart")
    local myr=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if h and tr and myr then stats.Text=string.format("HEALTH: %d/%d   DIST: %d studs",math.floor(h.Health),math.floor(h.MaxHealth),math.floor((tr.Position-myr.Position).Magnitude)) else stats.Text="HEALTH: --   DIST: --" end
    if spectating and (not selected or not selected.Parent or not h) then
        spectating=false
        local mh=lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if mh then workspace.CurrentCamera.CameraSubject=mh end
    end
end)

rebuild()
