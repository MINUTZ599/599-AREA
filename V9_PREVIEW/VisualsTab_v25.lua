-- 599 AREA V9 PREVIEW v25 - VISUALS TAB MIGRATION
-- Only populates VISUALS. V24 base remains untouched.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local TweenService=game:GetService("TweenService")

local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local page=gui:FindFirstChild("VISUALS",true)
if not page then warn("[599 V25] VISUALS page missing") return end

for _,c in ipairs(page:GetChildren()) do
    if c.Name=="V25_VISUALS" then c:Destroy() end
end

local holder=Instance.new("Frame")
holder.Name="V25_VISUALS"
holder.Size=UDim2.new(1,0,1,0)
holder.BackgroundTransparency=1
holder.Parent=page

local PURPLE=Color3.fromRGB(138,61,255)
local PURPLE2=Color3.fromRGB(191,100,255)
local BG=Color3.fromRGB(10,10,20)
local CARD=Color3.fromRGB(14,14,27)
local OFF=Color3.fromRGB(43,43,61)
local WHITE=Color3.fromRGB(245,243,255)
local MUTED=Color3.fromRGB(146,140,170)
local GREEN=Color3.fromRGB(91,255,160)

local state={nameesp=false,tracer=false,highlight=false,fullbright=false,clicktp=false,box=false,skeleton=false,health=false,namedist=false}
local mouse=lp:GetMouse()

local title=Instance.new("TextLabel")
title.Position=UDim2.fromOffset(20,76)
title.Size=UDim2.new(1,-40,0,28)
title.BackgroundTransparency=1
title.Text="VISUALS"
title.TextColor3=WHITE
title.Font=Enum.Font.GothamBold
title.TextSize=22
title.TextXAlignment=Enum.TextXAlignment.Left
title.Parent=holder

local sub=Instance.new("TextLabel")
sub.Position=UDim2.fromOffset(20,103)
sub.Size=UDim2.new(1,-40,0,18)
sub.BackgroundTransparency=1
sub.Text="Local visual tools migrated from 599 AREA V8.5"
sub.TextColor3=PURPLE2
sub.Font=Enum.Font.Gotham
sub.TextSize=10
sub.TextXAlignment=Enum.TextXAlignment.Left
sub.Parent=holder

local function neonCard(text,desc,x,y,callback)
    local f=Instance.new("Frame")
    f.Size=UDim2.new(.5,-26,0,70)
    f.Position=UDim2.new(x, x==0 and 20 or 6, 0, y)
    f.BackgroundColor3=CARD
    f.BorderSizePixel=0
    f.Parent=holder
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,11)
    local fs=Instance.new("UIStroke",f);fs.Color=Color3.fromRGB(68,48,102);fs.Transparency=.35

    local t=Instance.new("TextLabel")
    t.Position=UDim2.fromOffset(14,10);t.Size=UDim2.new(1,-110,0,20);t.BackgroundTransparency=1
    t.Text=text;t.TextColor3=WHITE;t.Font=Enum.Font.GothamBold;t.TextSize=11;t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=f
    local d=Instance.new("TextLabel")
    d.Position=UDim2.fromOffset(14,34);d.Size=UDim2.new(1,-110,0,18);d.BackgroundTransparency=1
    d.Text=desc;d.TextColor3=MUTED;d.Font=Enum.Font.Gotham;d.TextSize=8;d.TextXAlignment=Enum.TextXAlignment.Left;d.Parent=f

    local sw=Instance.new("TextButton")
    sw.Size=UDim2.fromOffset(72,32);sw.Position=UDim2.new(1,-88,.5,-16);sw.BackgroundColor3=Color3.fromRGB(15,15,29)
    sw.Text="";sw.AutoButtonColor=false;sw.Parent=f;Instance.new("UICorner",sw).CornerRadius=UDim.new(1,0)
    local stroke=Instance.new("UIStroke",sw);stroke.Color=Color3.fromRGB(80,75,110);stroke.Thickness=1.3
    local knob=Instance.new("Frame");knob.Size=UDim2.fromOffset(24,24);knob.Position=UDim2.fromOffset(4,4);knob.BackgroundColor3=Color3.fromRGB(150,150,178);knob.BorderSizePixel=0;knob.Parent=sw;Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local on=false
    local function render(v)
        on=v
        TweenService:Create(knob,TweenInfo.new(.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=v and UDim2.fromOffset(44,4) or UDim2.fromOffset(4,4),BackgroundColor3=v and Color3.fromRGB(250,240,255) or Color3.fromRGB(150,150,178)}):Play()
        TweenService:Create(sw,TweenInfo.new(.16),{BackgroundColor3=v and Color3.fromRGB(89,26,173) or Color3.fromRGB(15,15,29)}):Play()
        stroke.Color=v and PURPLE2 or Color3.fromRGB(80,75,110)
        stroke.Thickness=v and 2 or 1.3
    end
    sw.MouseButton1Click:Connect(function() render(not on);callback(on,render) end)
    return render
end

-- Overlay for ESP+
local old=pg:FindFirstChild("AREA599_V25_VISUAL_OVERLAY") if old then old:Destroy() end
local overlay=Instance.new("ScreenGui");overlay.Name="AREA599_V25_VISUAL_OVERLAY";overlay.ResetOnSpawn=false;overlay.IgnoreGuiInset=true;overlay.DisplayOrder=9998;overlay.Parent=pg
local skeletonPairs={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
local visuals={}
local highlights={}
local billboards={}
local function newLine()
    local f=Instance.new("Frame");f.AnchorPoint=Vector2.new(.5,.5);f.BackgroundColor3=PURPLE2;f.BorderSizePixel=0;f.Visible=false;f.ZIndex=42;f.Parent=overlay;return f
end
local function newVisual(p)
    if visuals[p] then return visuals[p] end
    local box=Instance.new("Frame");box.BackgroundTransparency=1;box.BorderSizePixel=0;box.Visible=false;box.ZIndex=35;box.Parent=overlay
    local st=Instance.new("UIStroke",box);st.Color=PURPLE2;st.Thickness=1.5
    local nm=Instance.new("TextLabel");nm.BackgroundTransparency=1;nm.Size=UDim2.fromOffset(240,20);nm.TextColor3=WHITE;nm.Font=Enum.Font.GothamBold;nm.TextSize=11;nm.TextXAlignment=Enum.TextXAlignment.Center;nm.Visible=false;nm.ZIndex=43;nm.Parent=overlay
    local hpBack=Instance.new("Frame");hpBack.BackgroundColor3=Color3.fromRGB(28,28,36);hpBack.BorderSizePixel=0;hpBack.Visible=false;hpBack.ZIndex=36;hpBack.Parent=overlay
    local hp=Instance.new("Frame");hp.AnchorPoint=Vector2.new(0,1);hp.Position=UDim2.fromScale(0,1);hp.Size=UDim2.fromScale(1,1);hp.BackgroundColor3=GREEN;hp.BorderSizePixel=0;hp.ZIndex=37;hp.Parent=hpBack
    local lines={} for i=1,#skeletonPairs do lines[i]=newLine() end
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

local tracerLines={}
local function tracerFor(p)
    if tracerLines[p] then return tracerLines[p] end
    local l=newLine();tracerLines[p]=l;return l
end

local oldLighting={Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,FogEnd=Lighting.FogEnd,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient}
local function setFullbright(on)
    state.fullbright=on
    if on then Lighting.Brightness=3;Lighting.ClockTime=14;Lighting.FogEnd=100000;Lighting.Ambient=Color3.fromRGB(178,178,178);Lighting.OutdoorAmbient=Color3.fromRGB(178,178,178)
    else for k,v in pairs(oldLighting) do Lighting[k]=v end end
end
local function refreshHighlights()
    for p,h in pairs(highlights) do if h then h.Enabled=state.highlight end end
    if state.highlight then
        for _,p in ipairs(Players:GetPlayers()) do if p~=lp and p.Character then
            local h=highlights[p]
            if not h or not h.Parent then h=Instance.new("Highlight");h.Name="_599V25Highlight";h.FillColor=PURPLE;h.FillTransparency=.55;h.OutlineColor=PURPLE2;h.OutlineTransparency=0;h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;h.Parent=p.Character;highlights[p]=h end
            h.Enabled=true
        end end
    end
end
local function refreshBillboards()
    for p,b in pairs(billboards) do if b then b.Enabled=state.nameesp end end
    if state.nameesp then
        for _,p in ipairs(Players:GetPlayers()) do if p~=lp and p.Character then
            local head=p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
            if head then
                local b=billboards[p]
                if not b or not b.Parent then
                    b=Instance.new("BillboardGui");b.Name="_599V25NameESP";b.Size=UDim2.fromOffset(180,34);b.StudsOffset=Vector3.new(0,2.7,0);b.AlwaysOnTop=true;b.Parent=head
                    local tx=Instance.new("TextLabel");tx.Size=UDim2.fromScale(1,1);tx.BackgroundTransparency=1;tx.Text=p.DisplayName;tx.TextColor3=WHITE;tx.TextStrokeTransparency=.35;tx.Font=Enum.Font.GothamBold;tx.TextSize=13;tx.Parent=b
                    billboards[p]=b
                end
                b.Enabled=true
            end
        end end
    end
end

neonCard("PLAYER NAME ESP","Names above players",0,138,function(on) state.nameesp=on;refreshBillboards() end)
neonCard("PLAYER TRACER","Line to each visible player",.5,138,function(on) state.tracer=on end)
neonCard("PLAYER HIGHLIGHT","Highlight players locally",0,216,function(on) state.highlight=on;refreshHighlights() end)
neonCard("FULLBRIGHT","Improve local visibility",.5,216,function(on) setFullbright(on) end)
neonCard("CLICK TELEPORT [ T ]","Click world point to teleport",0,294,function(on) state.clicktp=on end)
neonCard("BOX ESP","2D box around players",.5,294,function(on) state.box=on end)
neonCard("SKELETON ESP","Local body-bone lines",0,372,function(on) state.skeleton=on end)
neonCard("HEALTH BAR","Health beside ESP box",.5,372,function(on) state.health=on end)
neonCard("NAME + DISTANCE","Overlay name and distance",0,450,function(on) state.namedist=on end)

local dep=Instance.new("Frame");dep.Size=UDim2.new(.5,-26,0,70);dep.Position=UDim2.new(.5,6,0,450);dep.BackgroundColor3=BG;dep.BorderSizePixel=0;dep.Parent=holder;Instance.new("UICorner",dep).CornerRadius=UDim.new(0,11)
local ds=Instance.new("UIStroke",dep);ds.Color=Color3.fromRGB(72,48,105);ds.Transparency=.25
local dt=Instance.new("TextLabel");dt.Position=UDim2.fromOffset(14,9);dt.Size=UDim2.new(1,-28,0,20);dt.BackgroundTransparency=1;dt.Text="PLAYER TRACKER";dt.TextColor3=WHITE;dt.Font=Enum.Font.GothamBold;dt.TextSize=11;dt.TextXAlignment=Enum.TextXAlignment.Left;dt.Parent=dep
local dd=Instance.new("TextLabel");dd.Position=UDim2.fromOffset(14,31);dd.Size=UDim2.new(1,-28,0,28);dd.BackgroundTransparency=1;dd.Text="Ready after PLAYER tab migration";dd.TextColor3=PURPLE2;dd.Font=Enum.Font.Gotham;dd.TextSize=9;dd.TextXAlignment=Enum.TextXAlignment.Left;dd.Parent=dep

UIS.InputBegan:Connect(function(input,gpe)
    if UIS:GetFocusedTextBox() then return end
    if input.KeyCode==Enum.KeyCode.T then state.clicktp=not state.clicktp return end
    if not gpe and state.clicktp and input.UserInputType==Enum.UserInputType.MouseButton1 and mouse.Target then
        local ch=lp.Character;local root=ch and ch:FindFirstChild("HumanoidRootPart");local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.Health>0 then local _,yaw,_=root.CFrame:ToOrientation();root.CFrame=CFrame.new(mouse.Hit.Position+Vector3.new(0,3,0))*CFrame.Angles(0,yaw,0) end
    end
end)

RS.RenderStepped:Connect(function()
    local cam=workspace.CurrentCamera;if not cam then return end
    local myr=lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local bottom=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y-18)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=lp then
            local ch=p.Character;local r=ch and ch:FindFirstChild("HumanoidRootPart");local h=ch and ch:FindFirstChildOfClass("Humanoid")
            local v=newVisual(p);local tl=tracerFor(p)
            if not r or not h or h.Health<=0 then hide(v);tl.Visible=false continue end
            local pt,on=cam:WorldToViewportPoint(r.Position)
            if not on or pt.Z<=0 then hide(v);tl.Visible=false continue end
            local dist=myr and (r.Position-myr.Position).Magnitude or 0
            local scale=math.clamp(2200/math.max(pt.Z,1),28,180);local w=scale*.55;local hh=scale
            v.box.Position=UDim2.fromOffset(pt.X-w/2,pt.Y-hh/2);v.box.Size=UDim2.fromOffset(w,hh);v.box.Visible=state.box
            v.nm.Position=UDim2.fromOffset(pt.X-120,pt.Y-hh/2-22);v.nm.Text=p.DisplayName.."  ["..math.floor(dist).."m]";v.nm.Visible=state.namedist
            local ratio=math.clamp(h.Health/math.max(h.MaxHealth,1),0,1);v.hpBack.Position=UDim2.fromOffset(pt.X-w/2-8,pt.Y-hh/2);v.hpBack.Size=UDim2.fromOffset(4,hh);v.hp.Size=UDim2.new(1,0,ratio,0);v.hpBack.Visible=state.health
            if state.tracer then drawLine(tl,bottom,Vector2.new(pt.X,pt.Y)) else tl.Visible=false end
            for idx,pair in ipairs(skeletonPairs) do
                local a=ch:FindFirstChild(pair[1]);local b=ch:FindFirstChild(pair[2]);local line=v.lines[idx]
                if state.skeleton and a and b and a:IsA("BasePart") and b:IsA("BasePart") then
                    local pa,oa=cam:WorldToViewportPoint(a.Position);local pb,ob=cam:WorldToViewportPoint(b.Position)
                    if oa and ob and pa.Z>0 and pb.Z>0 then drawLine(line,Vector2.new(pa.X,pa.Y),Vector2.new(pb.X,pb.Y)) else line.Visible=false end
                else line.Visible=false end
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(.5);refreshHighlights();refreshBillboards() end) end)
Players.PlayerRemoving:Connect(function(p)
    visuals[p]=nil;tracerLines[p]=nil;highlights[p]=nil;billboards[p]=nil
end)
