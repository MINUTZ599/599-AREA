-- 599 AREA V9 PREVIEW v42 - INSTANT START
-- Shows a HOME shell immediately, then loads V40 stable in background and swaps seamlessly.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local oldShell = pg:FindFirstChild("AREA599_V42_INSTANT")
if oldShell then oldShell:Destroy() end

local shellGui = Instance.new("ScreenGui")
shellGui.Name = "AREA599_V42_INSTANT"
shellGui.ResetOnSpawn = false
shellGui.IgnoreGuiInset = true
shellGui.DisplayOrder = 999999
shellGui.Parent = pg

local root = Instance.new("Frame")
root.Name = "Root"
root.AnchorPoint = Vector2.new(.5,.5)
root.Position = UDim2.fromScale(.5,.5)
root.Size = UDim2.fromOffset(980,620)
root.BackgroundColor3 = Color3.fromRGB(6,6,12)
root.BorderSizePixel = 0
root.Parent = shellGui
Instance.new("UICorner",root).CornerRadius = UDim.new(0,16)
local rs = Instance.new("UIStroke",root)
rs.Color = Color3.fromRGB(137,66,255)
rs.Thickness = 1.4

local scale = Instance.new("UIScale",root)
local function resize()
    local cam=workspace.CurrentCamera
    if not cam then return end
    local s=cam.ViewportSize
    scale.Scale=math.clamp(math.min((s.X-24)/980,(s.Y-24)/620),.55,1)
end
resize()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromOffset(205,620)
sidebar.BackgroundColor3 = Color3.fromRGB(8,8,16)
sidebar.BorderSizePixel = 0
sidebar.Parent = root

local logo = Instance.new("Frame")
logo.Size=UDim2.fromOffset(44,44)
logo.Position=UDim2.fromOffset(15,15)
logo.BackgroundColor3=Color3.fromRGB(45,23,83)
logo.BorderSizePixel=0
logo.Parent=sidebar
Instance.new("UICorner",logo).CornerRadius=UDim.new(0,12)
local ls=Instance.new("UIStroke",logo);ls.Color=Color3.fromRGB(175,104,255)
local dollar=Instance.new("TextLabel")
dollar.Size=UDim2.fromScale(1,1);dollar.BackgroundTransparency=1;dollar.Text="$";dollar.TextColor3=Color3.fromRGB(235,205,255);dollar.Font=Enum.Font.GothamBlack;dollar.TextSize=23;dollar.Parent=logo

local brand=Instance.new("TextLabel")
brand.Position=UDim2.fromOffset(70,13);brand.Size=UDim2.fromOffset(120,25);brand.BackgroundTransparency=1;brand.Text="599 AREA";brand.TextColor3=Color3.fromRGB(250,248,255);brand.Font=Enum.Font.GothamBold;brand.TextSize=20;brand.TextXAlignment=Enum.TextXAlignment.Left;brand.Parent=sidebar
local sub=Instance.new("TextLabel")
sub.Position=UDim2.fromOffset(70,38);sub.Size=UDim2.fromOffset(125,25);sub.BackgroundTransparency=1;sub.Text="PREMIUM SCRIPT HUB\nFOR ROBLOX";sub.TextColor3=Color3.fromRGB(183,120,255);sub.Font=Enum.Font.Gotham;sub.TextSize=8;sub.TextXAlignment=Enum.TextXAlignment.Left;sub.TextYAlignment=Enum.TextYAlignment.Top;sub.Parent=sidebar

local nav={{"HOME","Home","Dashboard"},{"MAIN","Main","General Features"},{"VISUALS","Visuals","Enhance Your Game"},{"PLAYER","Player","Player Utilities"},{"WORLD","World","World & Maps"},{"ANIME DICE","Anime Dice","Auto Collect System"},{"SETTINGS","Settings","Customize UI"},{"CREDITS","Credits","Special Thanks"}}
for i,item in ipairs(nav) do
    local b=Instance.new("Frame")
    b.Size=UDim2.fromOffset(177,46);b.Position=UDim2.fromOffset(14,78+(i-1)*51);b.BackgroundColor3=i==1 and Color3.fromRGB(54,27,96) or Color3.fromRGB(12,12,22);b.BorderSizePixel=0;b.Parent=sidebar
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local ico=Instance.new("Frame");ico.Position=UDim2.fromOffset(8,5);ico.Size=UDim2.fromOffset(34,34);ico.BackgroundColor3=i==1 and Color3.fromRGB(116,53,214) or Color3.fromRGB(25,19,42);ico.BorderSizePixel=0;ico.Parent=b;Instance.new("UICorner",ico).CornerRadius=UDim.new(0,9)
    local it=Instance.new("TextLabel");it.Size=UDim2.fromScale(1,1);it.BackgroundTransparency=1;it.Text=string.sub(item[2],1,1);it.TextColor3=Color3.fromRGB(215,170,255);it.Font=Enum.Font.GothamBold;it.TextSize=13;it.Parent=ico
    local t=Instance.new("TextLabel");t.Position=UDim2.fromOffset(50,5);t.Size=UDim2.fromOffset(118,18);t.BackgroundTransparency=1;t.Text=item[2];t.TextColor3=Color3.fromRGB(245,243,255);t.Font=Enum.Font.GothamBold;t.TextSize=10;t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=b
    local d=Instance.new("TextLabel");d.Position=UDim2.fromOffset(50,23);d.Size=UDim2.fromOffset(120,15);d.BackgroundTransparency=1;d.Text=item[3];d.TextColor3=i==1 and Color3.fromRGB(191,124,255) or Color3.fromRGB(145,139,168);d.Font=Enum.Font.Gotham;d.TextSize=7;d.TextXAlignment=Enum.TextXAlignment.Left;d.Parent=b
end

local profile=Instance.new("Frame")
profile.Size=UDim2.fromOffset(177,95);profile.Position=UDim2.new(0,14,1,-109);profile.BackgroundColor3=Color3.fromRGB(11,11,21);profile.BorderSizePixel=0;profile.Parent=sidebar;Instance.new("UICorner",profile).CornerRadius=UDim.new(0,11)
local av=Instance.new("ImageLabel");av.Size=UDim2.fromOffset(38,38);av.Position=UDim2.fromOffset(9,9);av.BackgroundColor3=Color3.fromRGB(25,20,39);av.BorderSizePixel=0;av.Parent=profile;Instance.new("UICorner",av).CornerRadius=UDim.new(1,0)
task.spawn(function() local ok,img=pcall(function() return Players:GetUserThumbnailAsync(lp.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end);if ok and av.Parent then av.Image=img end end)
local wel=Instance.new("TextLabel");wel.Position=UDim2.fromOffset(55,8);wel.Size=UDim2.fromOffset(112,42);wel.BackgroundTransparency=1;wel.Text="Welcome,\n"..lp.DisplayName.."\nPremium User";wel.TextColor3=Color3.fromRGB(235,230,255);wel.Font=Enum.Font.Gotham;wel.TextSize=8;wel.TextXAlignment=Enum.TextXAlignment.Left;wel.TextYAlignment=Enum.TextYAlignment.Top;wel.Parent=profile
local q=Instance.new("TextLabel");q.Position=UDim2.fromOffset(9,54);q.Size=UDim2.fromOffset(159,33);q.BackgroundTransparency=1;q.Text="Good Scripts Make The Game More Fun. - 599 AREA";q.TextWrapped=true;q.TextColor3=Color3.fromRGB(158,150,184);q.Font=Enum.Font.Gotham;q.TextSize=7;q.TextXAlignment=Enum.TextXAlignment.Left;q.Parent=profile

local content=Instance.new("Frame")
content.Position=UDim2.fromOffset(205,0);content.Size=UDim2.new(1,-205,1,0);content.BackgroundTransparency=1;content.Parent=root
local top=Instance.new("Frame");top.Size=UDim2.new(1,0,0,64);top.BackgroundTransparency=1;top.Parent=content
local search=Instance.new("Frame");search.Size=UDim2.fromOffset(350,36);search.Position=UDim2.fromOffset(16,14);search.BackgroundColor3=Color3.fromRGB(11,11,21);search.BorderSizePixel=0;search.Parent=top;Instance.new("UICorner",search).CornerRadius=UDim.new(0,10)
local st=Instance.new("TextLabel");st.Size=UDim2.new(1,-20,1,0);st.Position=UDim2.fromOffset(12,0);st.BackgroundTransparency=1;st.Text="Search features, scripts, or games...";st.TextColor3=Color3.fromRGB(145,139,168);st.Font=Enum.Font.Gotham;st.TextSize=9;st.TextXAlignment=Enum.TextXAlignment.Left;st.Parent=search
for i,ch in ipairs({"−","□","×"}) do local b=Instance.new("TextLabel");b.Size=UDim2.fromOffset(36,36);b.Position=UDim2.new(1,-128+(i-1)*42,0,14);b.BackgroundColor3=Color3.fromRGB(11,11,21);b.BorderSizePixel=0;b.Text=ch;b.TextColor3=Color3.fromRGB(245,243,255);b.Font=Enum.Font.GothamBold;b.TextSize=14;b.Parent=top;Instance.new("UICorner",b).CornerRadius=UDim.new(0,10) end

local area=Instance.new("Frame")
area.Position=UDim2.fromOffset(16,68);area.Size=UDim2.new(1,-32,1,-82);area.BackgroundTransparency=1;area.Parent=content
local hero=Instance.new("Frame");hero.Size=UDim2.new(1,-6,0,188);hero.BackgroundColor3=Color3.fromRGB(9,7,18);hero.BorderSizePixel=0;hero.ClipsDescendants=true;hero.Parent=area;Instance.new("UICorner",hero).CornerRadius=UDim.new(0,13);local hs=Instance.new("UIStroke",hero);hs.Color=Color3.fromRGB(145,62,255);hs.Thickness=1.4
local img=Instance.new("ImageLabel");img.Size=UDim2.fromScale(1,1);img.BackgroundTransparency=1;img.Image="rbxassetid://129070764930166";img.ScaleType=Enum.ScaleType.Crop;img.Parent=hero

local function card(x,w,title,value,col)
    local f=Instance.new("Frame");f.Position=UDim2.new(x,0,0,200);f.Size=UDim2.new(w,-7,0,78);f.BackgroundColor3=Color3.fromRGB(11,11,22);f.BorderSizePixel=0;f.Parent=area;Instance.new("UICorner",f).CornerRadius=UDim.new(0,11);local s=Instance.new("UIStroke",f);s.Color=Color3.fromRGB(87,52,132);s.Transparency=.28
    local a=Instance.new("TextLabel");a.Position=UDim2.fromOffset(13,9);a.Size=UDim2.new(1,-26,0,16);a.BackgroundTransparency=1;a.Text=title;a.TextColor3=Color3.fromRGB(151,144,174);a.Font=Enum.Font.GothamBold;a.TextSize=8;a.TextXAlignment=Enum.TextXAlignment.Left;a.Parent=f
    local v=Instance.new("TextLabel");v.Position=UDim2.fromOffset(13,28);v.Size=UDim2.new(1,-26,0,34);v.BackgroundTransparency=1;v.Text=value;v.TextColor3=col;v.Font=Enum.Font.GothamBold;v.TextSize=18;v.TextXAlignment=Enum.TextXAlignment.Left;v.Parent=f
end
card(0,.25,"599 AREA STATUS","READY",Color3.fromRGB(205,118,255))
card(.25,.25,"FPS","...",Color3.fromRGB(83,255,155))
card(.5,.25,"PING","...",Color3.fromRGB(72,207,255))
card(.75,.25,"SYSTEM","LOADING",Color3.fromRGB(255,194,93))

local left=Instance.new("Frame");left.Position=UDim2.fromOffset(0,290);left.Size=UDim2.new(.42,-5,0,200);left.BackgroundColor3=Color3.fromRGB(11,11,22);left.BorderSizePixel=0;left.Parent=area;Instance.new("UICorner",left).CornerRadius=UDim.new(0,11)
local lt=Instance.new("TextLabel");lt.Position=UDim2.fromOffset(14,10);lt.Size=UDim2.new(1,-28,0,22);lt.BackgroundTransparency=1;lt.Text="SCRIPT STATUS";lt.TextColor3=Color3.fromRGB(205,118,255);lt.Font=Enum.Font.GothamBold;lt.TextSize=12;lt.TextXAlignment=Enum.TextXAlignment.Left;lt.Parent=left
for i,v in ipairs({"NOCLIP   [N]","FLY   [F]","FREECAM   [C]","SPECTATE   [V]","CLICK TELEPORT   [T]"}) do local t=Instance.new("TextLabel");t.Position=UDim2.fromOffset(14,38+(i-1)*30);t.Size=UDim2.new(1,-28,0,22);t.BackgroundTransparency=1;t.Text=v;t.TextColor3=Color3.fromRGB(245,243,255);t.Font=Enum.Font.GothamBold;t.TextSize=9;t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=left end
local right=Instance.new("Frame");right.Position=UDim2.new(.42,7,0,290);right.Size=UDim2.new(.58,-13,0,200);right.BackgroundColor3=Color3.fromRGB(11,11,22);right.BorderSizePixel=0;right.Parent=area;Instance.new("UICorner",right).CornerRadius=UDim.new(0,11)
local rt=Instance.new("TextLabel");rt.Position=UDim2.fromOffset(14,10);rt.Size=UDim2.new(1,-28,0,22);rt.BackgroundTransparency=1;rt.Text="GAME INFORMATION";rt.TextColor3=Color3.fromRGB(205,118,255);rt.Font=Enum.Font.GothamBold;rt.TextSize=12;rt.TextXAlignment=Enum.TextXAlignment.Left;rt.Parent=right
for i,v in ipairs({"PLACE ID   "..tostring(game.PlaceId),"VERSION   V40 STABLE","PLAYERS   "..tostring(#Players:GetPlayers()),"STATUS   PREPARING FEATURES..."}) do local t=Instance.new("TextLabel");t.Position=UDim2.fromOffset(14,42+(i-1)*32);t.Size=UDim2.new(1,-28,0,24);t.BackgroundTransparency=1;t.Text=v;t.TextColor3=i==4 and Color3.fromRGB(205,118,255) or Color3.fromRGB(245,243,255);t.Font=Enum.Font.Gotham;t.TextSize=9;t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=right end

-- Build the full stable V40 in the background. Shell stays on top the whole time.
task.spawn(function()
    local ok,err=pcall(function()
        local src=game:HttpGet("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/LoaderClean_v40.lua?from=42")
        local fn,e=loadstring(src)
        if not fn then error(e) end
        fn()
    end)
    if not ok then
        warn("[599 V42] background V40 load failed: "..tostring(err))
        return
    end

    -- Wait until the final HOME dashboard is actually ready before swapping.
    local final=pg:WaitForChild("AREA599_V9_PREVIEW",15)
    if final then
        local home=final:FindFirstChild("HOME",true)
        local deadline=os.clock()+15
        while home and not home:FindFirstChild("V34_HOME") and os.clock()<deadline do task.wait() end
        task.wait()
        shellGui:Destroy()
    end
end)

print("[599 V42] instant HOME shell shown")