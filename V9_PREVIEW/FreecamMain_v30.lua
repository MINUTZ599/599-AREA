-- 599 AREA V9 PREVIEW v30 - FREECAM MAIN ADDON
-- Adds ONLY Freecam [C] + Freecam Speed beneath MAIN Utility.

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local ContextActionService=game:GetService("ContextActionService")

local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local main=gui:FindFirstChild("MAIN",true)
if not main then return end

local scroll
for _,d in ipairs(main:GetDescendants()) do
    if d:IsA("ScrollingFrame") then scroll=d break end
end
if not scroll then return end

local old=scroll:FindFirstChild("V30_FREECAM")
if old then old:Destroy() end

local PURPLE=Color3.fromRGB(140,60,255)
local PURPLE2=Color3.fromRGB(198,124,255)
local WHITE=Color3.fromRGB(240,237,255)
local MUTED=Color3.fromRGB(145,139,168)
local CARD=Color3.fromRGB(10,10,20)
local ROW=Color3.fromRGB(14,14,26)

local holder=Instance.new("Frame")
holder.Name="V30_FREECAM"
holder.Size=UDim2.new(1,-10,0,190)
holder.Position=UDim2.fromOffset(0,994)
holder.BackgroundColor3=CARD
holder.BorderSizePixel=0
holder.Parent=scroll
Instance.new("UICorner",holder).CornerRadius=UDim.new(0,12)
local hs=Instance.new("UIStroke",holder)
hs.Color=Color3.fromRGB(93,55,140)
hs.Transparency=.42

scroll.CanvasSize=UDim2.fromOffset(0,1196)

local function label(par,text,pos,size,fs,bold,col)
    local t=Instance.new("TextLabel")
    t.BackgroundTransparency=1
    t.Position=pos
    t.Size=size
    t.Text=text
    t.TextColor3=col or WHITE
    t.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextSize=fs or 10
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.Parent=par
    return t
end

label(holder,"UTILITY",UDim2.fromOffset(14,10),UDim2.fromOffset(180,22),14,true,Color3.fromRGB(205,160,255))

local toggleRow=Instance.new("Frame")
toggleRow.Size=UDim2.new(1,-24,0,58)
toggleRow.Position=UDim2.fromOffset(12,38)
toggleRow.BackgroundColor3=ROW
toggleRow.BorderSizePixel=0
toggleRow.Parent=holder
Instance.new("UICorner",toggleRow).CornerRadius=UDim.new(0,10)

label(toggleRow,"FREECAM [ C ]",UDim2.fromOffset(14,8),UDim2.new(1,-110,0,20),11,true)
label(toggleRow,"Cinematic free camera; character stays frozen",UDim2.fromOffset(14,29),UDim2.new(1,-110,0,18),8,false,MUTED)

local shell=Instance.new("TextButton")
shell.Size=UDim2.fromOffset(64,30)
shell.Position=UDim2.new(1,-78,.5,-15)
shell.BackgroundColor3=Color3.fromRGB(18,18,31)
shell.BorderSizePixel=0
shell.Text=""
shell.AutoButtonColor=false
shell.Parent=toggleRow
Instance.new("UICorner",shell).CornerRadius=UDim.new(0,15)
local ss=Instance.new("UIStroke",shell)
ss.Color=Color3.fromRGB(100,88,140)
ss.Thickness=2
ss.Transparency=.18
local knob=Instance.new("Frame")
knob.Size=UDim2.fromOffset(22,22)
knob.Position=UDim2.fromOffset(4,4)
knob.BackgroundColor3=Color3.fromRGB(170,168,200)
knob.BorderSizePixel=0
knob.Parent=shell
Instance.new("UICorner",knob).CornerRadius=UDim.new(0,11)

local speed=100
local enabled=false
local conn
local saved={}
local ACTION="599_V30_FREECAM_BLOCK"

local function getChar()
    local ch=lp.Character
    if not ch then return nil,nil,nil end
    return ch,ch:FindFirstChildOfClass("Humanoid"),ch:FindFirstChild("HumanoidRootPart")
end

local function sink()
    return Enum.ContextActionResult.Sink
end

local function renderToggle(anim)
    local shellColor=enabled and Color3.fromRGB(88,28,170) or Color3.fromRGB(18,18,31)
    local strokeColor=enabled and Color3.fromRGB(190,90,255) or Color3.fromRGB(100,88,140)
    local knobColor=enabled and Color3.fromRGB(246,232,255) or Color3.fromRGB(170,168,200)
    local knobPos=enabled and UDim2.fromOffset(38,4) or UDim2.fromOffset(4,4)
    if anim then
        TweenService:Create(shell,TweenInfo.new(.16),{BackgroundColor3=shellColor}):Play()
        TweenService:Create(knob,TweenInfo.new(.16),{Position=knobPos,BackgroundColor3=knobColor}):Play()
        TweenService:Create(ss,TweenInfo.new(.16),{Color=strokeColor,Transparency=enabled and 0 or .18}):Play()
    else
        shell.BackgroundColor3=shellColor
        knob.Position=knobPos
        knob.BackgroundColor3=knobColor
        ss.Color=strokeColor
        ss.Transparency=enabled and 0 or .18
    end
end

local function stopFreecam()
    if conn then conn:Disconnect();conn=nil end
    ContextActionService:UnbindAction(ACTION)
    local cam=workspace.CurrentCamera
    if cam then
        cam.CameraType=saved.CameraType or Enum.CameraType.Custom
        if saved.CameraSubject and saved.CameraSubject.Parent then cam.CameraSubject=saved.CameraSubject end
        if saved.CFrame then cam.CFrame=saved.CFrame end
        if saved.FOV then cam.FieldOfView=saved.FOV end
    end
    UIS.MouseBehavior=saved.MouseBehavior or Enum.MouseBehavior.Default
    UIS.MouseIconEnabled=saved.MouseIconEnabled~=false
    local _,hum,root=getChar()
    if hum then
        if saved.WalkSpeed then hum.WalkSpeed=saved.WalkSpeed end
        if saved.JumpPower then hum.JumpPower=saved.JumpPower end
        if saved.AutoRotate~=nil then hum.AutoRotate=saved.AutoRotate end
    end
    if root and saved.RootAnchored~=nil then root.Anchored=saved.RootAnchored end
end

local function startFreecam()
    local _,hum,root=getChar()
    local cam=workspace.CurrentCamera
    if not cam or not hum or not root then enabled=false;renderToggle(true);return end

    saved.CameraType=cam.CameraType
    saved.CameraSubject=cam.CameraSubject
    saved.CFrame=cam.CFrame
    saved.FOV=cam.FieldOfView
    saved.MouseBehavior=UIS.MouseBehavior
    saved.MouseIconEnabled=UIS.MouseIconEnabled
    saved.WalkSpeed=hum.WalkSpeed
    saved.JumpPower=hum.JumpPower
    saved.AutoRotate=hum.AutoRotate
    saved.RootAnchored=root.Anchored

    hum.WalkSpeed=0
    hum.JumpPower=0
    hum.AutoRotate=false
    root.AssemblyLinearVelocity=Vector3.zero
    root.AssemblyAngularVelocity=Vector3.zero
    root.Anchored=true

    ContextActionService:BindActionAtPriority(ACTION,sink,false,Enum.ContextActionPriority.High.Value+100,
        Enum.PlayerActions.CharacterForward,Enum.PlayerActions.CharacterBackward,
        Enum.PlayerActions.CharacterLeft,Enum.PlayerActions.CharacterRight,Enum.PlayerActions.CharacterJump)

    cam.CameraType=Enum.CameraType.Scriptable
    UIS.MouseBehavior=Enum.MouseBehavior.LockCenter
    UIS.MouseIconEnabled=false

    local cf=cam.CFrame
    local yaw,pitch=0,0
    do
        local x,y,_=cf:ToOrientation()
        pitch=x;yaw=y
    end

    conn=RunService.RenderStepped:Connect(function(dt)
        if not enabled then return end
        cam=workspace.CurrentCamera
        if not cam then return end

        local delta=UIS:GetMouseDelta()
        yaw-=delta.X*0.0025
        pitch=math.clamp(pitch-delta.Y*0.0025,-1.55,1.55)

        local rot=CFrame.fromOrientation(pitch,yaw,0)
        local dir=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir+=rot.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir-=rot.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir-=rot.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir+=rot.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.E) then dir+=Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then dir-=Vector3.new(0,1,0) end
        if dir.Magnitude>0 then dir=dir.Unit end
        local boost=UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 2.5 or 1
        cf=CFrame.new(cf.Position + dir*speed*boost*dt)*rot
        cam.CFrame=cf
    end)
end

local function setEnabled(v)
    if enabled==v then return end
    enabled=v
    if enabled then startFreecam() else stopFreecam() end
    renderToggle(true)
end

shell.MouseButton1Click:Connect(function() setEnabled(not enabled) end)

UIS.InputBegan:Connect(function(input,gpe)
    if gpe or UIS:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.C then setEnabled(not enabled) end
end)

local sliderY=109
label(holder,"FREECAM SPEED",UDim2.fromOffset(14,sliderY),UDim2.fromOffset(180,18),9,true)
local value=label(holder,tostring(speed),UDim2.new(1,-80,0,sliderY),UDim2.fromOffset(62,18),9,true,PURPLE2)
value.TextXAlignment=Enum.TextXAlignment.Right

local bar=Instance.new("Frame")
bar.Size=UDim2.new(1,-28,0,7)
bar.Position=UDim2.fromOffset(14,sliderY+25)
bar.BackgroundColor3=Color3.fromRGB(46,42,65)
bar.BorderSizePixel=0
bar.Parent=holder
Instance.new("UICorner",bar).CornerRadius=UDim.new(0,4)
local fill=Instance.new("Frame")
fill.Size=UDim2.new((speed-10)/290,0,1,0)
fill.BackgroundColor3=PURPLE
fill.BorderSizePixel=0
fill.Parent=bar
Instance.new("UICorner",fill).CornerRadius=UDim.new(0,4)
local sk=Instance.new("Frame")
sk.AnchorPoint=Vector2.new(.5,.5)
sk.Size=UDim2.fromOffset(15,15)
sk.Position=UDim2.new((speed-10)/290,0,.5,0)
sk.BackgroundColor3=Color3.fromRGB(226,190,255)
sk.BorderSizePixel=0
sk.Parent=bar
Instance.new("UICorner",sk).CornerRadius=UDim.new(0,8)
label(holder,"10",UDim2.fromOffset(14,sliderY+37),UDim2.fromOffset(40,14),7,false,MUTED)
local mx=label(holder,"300",UDim2.new(1,-54,0,sliderY+37),UDim2.fromOffset(40,14),7,false,MUTED)
mx.TextXAlignment=Enum.TextXAlignment.Right

local dragging=false
local function setX(x)
    local w=bar.AbsoluteSize.X
    if w<=0 then return end
    local p=math.clamp((x-bar.AbsolutePosition.X)/w,0,1)
    speed=math.floor(10+290*p+.5)
    fill.Size=UDim2.new(p,0,1,0)
    sk.Position=UDim2.new(p,0,.5,0)
    value.Text=tostring(speed)
end
bar.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;setX(i.Position.X) end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then setX(i.Position.X) end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)

renderToggle(false)
