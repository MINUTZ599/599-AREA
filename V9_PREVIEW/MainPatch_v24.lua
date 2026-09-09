-- 599 AREA V9 PREVIEW - MAIN TAB MIGRATION v24
-- Migrates local Movement + Utility features into the new MAIN tab only.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local gui = pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local mainPage
for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("Frame") and obj.Name == "MAIN" then
        mainPage = obj
        break
    end
end
if not mainPage then return end

for _,c in ipairs(mainPage:GetChildren()) do
    c:Destroy()
end

local state = {
    speed=false,
    infinite=false,
    fly=false,
    highjump=false,
    noclip=false,
    god=false,
}

local speedValue = 75
local flySpeed = 100
local jumpValue = 120
local DEFAULT_SPEED = 16
local DEFAULT_JUMP = 50
local savedPosition = nil
local slots = {}
local flyConn, noclipConn, godConn
local bv, bg
local noclipOriginal = {}

local function getChar()
    local ch = lp.Character
    if not ch then return nil,nil,nil end
    return ch, ch:FindFirstChildOfClass("Humanoid"), ch:FindFirstChild("HumanoidRootPart")
end

local function round(obj,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 10)
    c.Parent=obj
end

local function stroke(obj,color,thickness,transparency)
    local s=Instance.new("UIStroke")
    s.Color=color or Color3.fromRGB(125,70,190)
    s.Thickness=thickness or 1
    s.Transparency=transparency or 0.4
    s.Parent=obj
    return s
end

local title=Instance.new("TextLabel")
title.BackgroundTransparency=1
title.Position=UDim2.fromOffset(18,74)
title.Size=UDim2.new(1,-36,0,32)
title.Text="MAIN"
title.TextColor3=Color3.fromRGB(246,243,255)
title.Font=Enum.Font.GothamBold
title.TextSize=24
title.TextXAlignment=Enum.TextXAlignment.Left
title.Parent=mainPage

local sub=Instance.new("TextLabel")
sub.BackgroundTransparency=1
sub.Position=UDim2.fromOffset(18,106)
sub.Size=UDim2.new(1,-36,0,20)
sub.Text="Movement & Utility • migrated from V8.5"
sub.TextColor3=Color3.fromRGB(180,120,255)
sub.Font=Enum.Font.Gotham
sub.TextSize=10
sub.TextXAlignment=Enum.TextXAlignment.Left
sub.Parent=mainPage

local scroll=Instance.new("ScrollingFrame")
scroll.Position=UDim2.fromOffset(18,138)
scroll.Size=UDim2.new(1,-36,1,-156)
scroll.BackgroundTransparency=1
scroll.BorderSizePixel=0
scroll.ScrollBarThickness=4
scroll.ScrollBarImageColor3=Color3.fromRGB(140,70,255)
scroll.CanvasSize=UDim2.fromOffset(0,1160)
scroll.Parent=mainPage

local function card(y,h)
    local f=Instance.new("Frame")
    f.Size=UDim2.new(1,-10,0,h)
    f.Position=UDim2.fromOffset(0,y)
    f.BackgroundColor3=Color3.fromRGB(10,10,20)
    f.BorderSizePixel=0
    f.Parent=scroll
    round(f,12)
    stroke(f,Color3.fromRGB(93,55,140),1,0.42)
    return f
end

local function addText(parent,textValue,pos,size,fontSize,bold,color)
    local t=Instance.new("TextLabel")
    t.BackgroundTransparency=1
    t.Position=pos
    t.Size=size
    t.Text=textValue
    t.TextColor3=color or Color3.fromRGB(240,237,255)
    t.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    t.TextSize=fontSize or 11
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.Parent=parent
    return t
end

local function neonToggle(parent,y,label,desc,initial,callback)
    local row=Instance.new("Frame")
    row.Size=UDim2.new(1,-24,0,58)
    row.Position=UDim2.fromOffset(12,y)
    row.BackgroundColor3=Color3.fromRGB(14,14,26)
    row.BorderSizePixel=0
    row.Parent=parent
    round(row,10)

    addText(row,label,UDim2.fromOffset(14,8),UDim2.new(1,-110,0,20),11,true)
    addText(row,desc,UDim2.fromOffset(14,29),UDim2.new(1,-110,0,18),8,false,Color3.fromRGB(145,139,168))

    local shell=Instance.new("TextButton")
    shell.Size=UDim2.fromOffset(64,30)
    shell.Position=UDim2.new(1,-78,0.5,-15)
    shell.Text=""
    shell.AutoButtonColor=false
    shell.BackgroundColor3=Color3.fromRGB(18,18,31)
    shell.BorderSizePixel=0
    shell.Parent=row
    round(shell,15)
    local shStroke=stroke(shell,Color3.fromRGB(100,88,140),2,0.18)

    local knob=Instance.new("Frame")
    knob.Size=UDim2.fromOffset(22,22)
    knob.Position=UDim2.fromOffset(4,4)
    knob.BackgroundColor3=Color3.fromRGB(170,168,200)
    knob.BorderSizePixel=0
    knob.Parent=shell
    round(knob,11)

    local on=initial and true or false
    local function render(anim)
        local shellColor = on and Color3.fromRGB(88,28,170) or Color3.fromRGB(18,18,31)
        local strokeColor = on and Color3.fromRGB(190,90,255) or Color3.fromRGB(100,88,140)
        local knobColor = on and Color3.fromRGB(246,232,255) or Color3.fromRGB(170,168,200)
        local knobPos = on and UDim2.fromOffset(38,4) or UDim2.fromOffset(4,4)
        if anim then
            TweenService:Create(shell,TweenInfo.new(.16),{BackgroundColor3=shellColor}):Play()
            TweenService:Create(knob,TweenInfo.new(.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=knobPos,BackgroundColor3=knobColor}):Play()
            TweenService:Create(shStroke,TweenInfo.new(.16),{Color=strokeColor,Transparency=on and 0 or .18}):Play()
        else
            shell.BackgroundColor3=shellColor
            knob.Position=knobPos
            knob.BackgroundColor3=knobColor
            shStroke.Color=strokeColor
            shStroke.Transparency=on and 0 or .18
        end
    end
    render(false)

    shell.MouseButton1Click:Connect(function()
        on=not on
        render(true)
        callback(on)
    end)
    return function(v)
        on=v and true or false
        render(true)
    end
end

local function slider(parent,y,label,minv,maxv,startv,callback)
    addText(parent,label,UDim2.fromOffset(14,y),UDim2.fromOffset(180,18),9,true)
    local value=addText(parent,tostring(startv),UDim2.new(1,-80,0,y),UDim2.fromOffset(62,18),9,true,Color3.fromRGB(198,124,255))
    value.TextXAlignment=Enum.TextXAlignment.Right

    local bar=Instance.new("Frame")
    bar.Size=UDim2.new(1,-28,0,7)
    bar.Position=UDim2.fromOffset(14,y+25)
    bar.BackgroundColor3=Color3.fromRGB(46,42,65)
    bar.BorderSizePixel=0
    bar.Parent=parent
    round(bar,4)

    local fill=Instance.new("Frame")
    fill.Size=UDim2.new((startv-minv)/(maxv-minv),0,1,0)
    fill.BackgroundColor3=Color3.fromRGB(140,60,255)
    fill.BorderSizePixel=0
    fill.Parent=bar
    round(fill,4)

    local knob=Instance.new("Frame")
    knob.AnchorPoint=Vector2.new(.5,.5)
    knob.Size=UDim2.fromOffset(15,15)
    knob.Position=UDim2.new((startv-minv)/(maxv-minv),0,.5,0)
    knob.BackgroundColor3=Color3.fromRGB(226,190,255)
    knob.BorderSizePixel=0
    knob.Parent=bar
    round(knob,8)

    local dragging=false
    local function setX(x)
        local w=bar.AbsoluteSize.X
        if w<=0 then return end
        local p=math.clamp((x-bar.AbsolutePosition.X)/w,0,1)
        local v=math.floor(minv+(maxv-minv)*p+.5)
        fill.Size=UDim2.new(p,0,1,0)
        knob.Position=UDim2.new(p,0,.5,0)
        value.Text=tostring(v)
        callback(v)
    end
    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; setX(i.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            setX(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
end

local function action(parent,x,y,w,label,callback)
    local b=Instance.new("TextButton")
    b.Size=UDim2.fromOffset(w,38)
    b.Position=UDim2.fromOffset(x,y)
    b.BackgroundColor3=Color3.fromRGB(20,18,34)
    b.Text=label
    b.TextColor3=Color3.fromRGB(240,237,255)
    b.Font=Enum.Font.GothamBold
    b.TextSize=9
    b.AutoButtonColor=false
    b.BorderSizePixel=0
    b.Parent=parent
    round(b,9)
    stroke(b,Color3.fromRGB(115,62,180),1,0.35)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- Movement
local movement=card(0,390)
addText(movement,"MOVEMENT",UDim2.fromOffset(14,12),UDim2.fromOffset(180,24),14,true,Color3.fromRGB(205,160,255))

neonToggle(movement,44,"SPEED","Increase walk speed",false,function(on)
    state.speed=on
    local _,hum=getChar()
    if hum then hum.WalkSpeed=on and speedValue or DEFAULT_SPEED end
end)
slider(movement,112,"SPEED VALUE",16,150,speedValue,function(v)
    speedValue=v
    local _,hum=getChar()
    if state.speed and hum then hum.WalkSpeed=v end
end)

neonToggle(movement,166,"INFINITE JUMP","Jump without limits",false,function(on)
    state.infinite=on
end)

neonToggle(movement,228,"FLY [ F ]","Fly in camera direction",false,function(on)
    state.fly=on
    local ch,hum,root=getChar()
    if not root then state.fly=false return end
    if not on then
        if flyConn then flyConn:Disconnect(); flyConn=nil end
        if bv then bv:Destroy(); bv=nil end
        if bg then bg:Destroy(); bg=nil end
        if hum then hum.PlatformStand=false end
        return
    end
    bv=Instance.new("BodyVelocity")
    bv.MaxForce=Vector3.new(1e9,1e9,1e9)
    bv.Velocity=Vector3.zero
    bv.Parent=root
    bg=Instance.new("BodyGyro")
    bg.MaxTorque=Vector3.new(1e9,1e9,1e9)
    bg.P=8e4
    bg.CFrame=root.CFrame
    bg.Parent=root
    if hum then hum.PlatformStand=true end
    flyConn=RunService.RenderStepped:Connect(function()
        local _,h,r=getChar()
        local cam=workspace.CurrentCamera
        if not state.fly or not r or not cam then return end
        local move=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then move+=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move-=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move-=cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move+=cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move+=Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move-=Vector3.yAxis end
        if move.Magnitude>0 then move=move.Unit*flySpeed end
        if bv then bv.Velocity=move end
        if bg then bg.CFrame=CFrame.lookAt(r.Position,r.Position+cam.CFrame.LookVector) end
        if h then h.PlatformStand=true end
    end)
end)
slider(movement,296,"FLY SPEED",10,200,flySpeed,function(v) flySpeed=v end)

-- High jump card
local jumpCard=card(402,180)
addText(jumpCard,"JUMP",UDim2.fromOffset(14,12),UDim2.fromOffset(180,24),14,true,Color3.fromRGB(205,160,255))
neonToggle(jumpCard,44,"HIGH JUMP","Increase jump power",false,function(on)
    state.highjump=on
    local _,hum=getChar()
    if hum then
        hum.UseJumpPower=true
        hum.JumpPower=on and jumpValue or DEFAULT_JUMP
    end
end)
slider(jumpCard,112,"JUMP POWER",50,200,jumpValue,function(v)
    jumpValue=v
    local _,hum=getChar()
    if state.highjump and hum then hum.JumpPower=v end
end)

-- Utility
local utility=card(594,388)
addText(utility,"UTILITY",UDim2.fromOffset(14,12),UDim2.fromOffset(180,24),14,true,Color3.fromRGB(205,160,255))

neonToggle(utility,44,"NOCLIP [ N ]","Walk through local collision",false,function(on)
    state.noclip=on
    if not on then
        if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
        for part,canCollide in pairs(noclipOriginal) do
            if part and part.Parent then part.CanCollide=canCollide end
        end
        table.clear(noclipOriginal)
        return
    end
    noclipConn=RunService.Stepped:Connect(function()
        local ch=getChar()
        if not state.noclip or not ch then return end
        for _,d in ipairs(ch:GetDescendants()) do
            if d:IsA("BasePart") then
                if noclipOriginal[d]==nil then noclipOriginal[d]=d.CanCollide end
                d.CanCollide=false
            end
        end
    end)
end)

neonToggle(utility,106,"GODMODE [ G ]","Local character health protection",false,function(on)
    state.god=on
    if godConn then godConn:Disconnect(); godConn=nil end
    local _,hum=getChar()
    if not hum then return end
    if on then
        hum.MaxHealth=1e9
        hum.Health=hum.MaxHealth
        godConn=RunService.Heartbeat:Connect(function()
            local _,h=getChar()
            if state.god and h then
                if h.MaxHealth<1e9 then h.MaxHealth=1e9 end
                if h.Health<h.MaxHealth then h.Health=h.MaxHealth end
            end
        end)
    else
        hum.MaxHealth=100
        if hum.Health>100 then hum.Health=100 end
    end
end)

action(utility,14,178,160,"SAVE POSITION",function()
    local _,_,root=getChar(); if root then savedPosition=root.CFrame end
end)
action(utility,186,178,170,"TELEPORT SAVED",function()
    local _,_,root=getChar(); if root and savedPosition then root.CFrame=savedPosition+Vector3.new(0,3,0) end
end)
action(utility,14,226,160,"SIT / UNSIT",function()
    local _,hum=getChar(); if hum then hum.Sit=not hum.Sit end
end)
action(utility,186,226,170,"RESET CHARACTER",function()
    local ch=lp.Character; if ch then ch:BreakJoints() end
end)

addText(utility,"POSITION SLOTS",UDim2.fromOffset(14,280),UDim2.fromOffset(180,20),10,true,Color3.fromRGB(180,120,255))
for i=1,5 do
    local y=310+((i-1)%3)*0
    local x=14+(i-1)*68
    action(utility,x,308,58,"S"..i,function()
        local _,_,root=getChar(); if root then slots[i]=root.CFrame end
    end)
end
for i=1,5 do
    local x=14+(i-1)*68
    action(utility,x,350,58,"TP"..i,function()
        local _,_,root=getChar(); if root and slots[i] then root.CFrame=slots[i]+Vector3.new(0,3,0) end
    end)
end

-- Infinite jump
UIS.JumpRequest:Connect(function()
    if not state.infinite then return end
    local _,hum=getChar()
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- Keybinds preserved from V8.5
UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode==Enum.KeyCode.F then
        state.fly=not state.fly
        -- trigger by finding the FLY toggle shell and clicking is unreliable; reproduce directly
        local ch,hum,root=getChar()
        if state.fly and root then
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            bv=Instance.new("BodyVelocity"); bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.Parent=root
            bg=Instance.new("BodyGyro"); bg.MaxTorque=Vector3.new(1e9,1e9,1e9); bg.P=8e4; bg.CFrame=root.CFrame; bg.Parent=root
            if hum then hum.PlatformStand=true end
            if flyConn then flyConn:Disconnect() end
            flyConn=RunService.RenderStepped:Connect(function()
                local _,h,r=getChar(); local cam=workspace.CurrentCamera
                if not state.fly or not r or not cam then return end
                local move=Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then move+=cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then move-=cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then move-=cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then move+=cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then move+=Vector3.yAxis end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move-=Vector3.yAxis end
                if move.Magnitude>0 then move=move.Unit*flySpeed end
                if bv then bv.Velocity=move end
                if bg then bg.CFrame=CFrame.lookAt(r.Position,r.Position+cam.CFrame.LookVector) end
                if h then h.PlatformStand=true end
            end)
        else
            state.fly=false
            if flyConn then flyConn:Disconnect(); flyConn=nil end
            if bv then bv:Destroy(); bv=nil end
            if bg then bg:Destroy(); bg=nil end
            local _,h=getChar(); if h then h.PlatformStand=false end
        end
    elseif input.KeyCode==Enum.KeyCode.N then
        state.noclip=not state.noclip
        if state.noclip then
            if noclipConn then noclipConn:Disconnect() end
            noclipConn=RunService.Stepped:Connect(function()
                local ch=getChar(); if not state.noclip or not ch then return end
                for _,d in ipairs(ch:GetDescendants()) do if d:IsA("BasePart") then d.CanCollide=false end end
            end)
        else
            if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
        end
    elseif input.KeyCode==Enum.KeyCode.G then
        state.god=not state.god
        local _,h=getChar()
        if h then
            if state.god then h.MaxHealth=1e9; h.Health=h.MaxHealth else h.MaxHealth=100; h.Health=math.min(h.Health,100) end
        end
    end
end)

lp.CharacterAdded:Connect(function()
    task.wait(.35)
    local _,hum=getChar()
    if hum then
        hum.UseJumpPower=true
        hum.WalkSpeed=state.speed and speedValue or DEFAULT_SPEED
        hum.JumpPower=state.highjump and jumpValue or DEFAULT_JUMP
    end
    state.fly=false
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    if bv then bv:Destroy(); bv=nil end
    if bg then bg:Destroy(); bg=nil end
end)
