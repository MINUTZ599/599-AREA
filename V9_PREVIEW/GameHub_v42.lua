-- 599 AREA V42 Game Hub
-- Bootstrap the final tested Game Hub build.
-- Ride A Pet engine is kept in its own module.

local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local lp=Players.LocalPlayer
local gui=lp.PlayerGui:WaitForChild("AREA599_V9_PREVIEW",15)
if not gui then error("[599 GAME HUB V42] main GUI missing") end

local animePage=gui:FindFirstChild("ANIME DICE",true)
if not animePage then error("[599 GAME HUB V42] Anime Dice page missing") end

-- Remove old visible Anime Dice label; internal page/key stays untouched.
for _,d in ipairs(gui:GetDescendants()) do
    if d:IsA("TextLabel") and d.Text=="Anime Dice" then
        d.Text=""
        d.Visible=false
    end
end

-- Locate Anime Dice navigation button and present it as Game.
for _,b in ipairs(gui:GetDescendants()) do
    if b:IsA("TextButton") then
        local match=false
        for _,c in ipairs(b:GetChildren()) do
            if c:IsA("TextLabel") and c.Text=="Auto Collect System" then
                match=true
                c.Text="Game Hub"
            end
        end
        if match then
            local label=Instance.new("TextLabel")
            label.Name="599_GAME_LABEL";label.Position=UDim2.fromOffset(50,5)
            label.Size=UDim2.fromOffset(118,18);label.BackgroundTransparency=1
            label.Text="Game";label.TextColor3=Color3.fromRGB(245,243,255)
            label.Font=Enum.Font.GothamBold;label.TextSize=10
            label.TextXAlignment=Enum.TextXAlignment.Left;label.Parent=b
            break
        end
    end
end

local oldHolder=Instance.new("Frame")
oldHolder.Name="599_ORIGINAL_ANIME_DICE";oldHolder.Size=UDim2.fromScale(1,1)
oldHolder.BackgroundTransparency=1;oldHolder.Visible=false;oldHolder.Parent=animePage
for _,c in ipairs(animePage:GetChildren()) do if c~=oldHolder then c.Parent=oldHolder end end

local hub=Instance.new("Frame")
hub.Name="599_GAME_HUB";hub.Size=UDim2.fromScale(1,1);hub.BackgroundTransparency=1;hub.Parent=animePage

local head=Instance.new("TextLabel")
head.Position=UDim2.fromOffset(24,76);head.Size=UDim2.fromOffset(420,32);head.BackgroundTransparency=1
head.Text="🎮  Game";head.Font=Enum.Font.GothamBold;head.TextSize=25
head.TextColor3=Color3.fromRGB(247,245,255);head.TextXAlignment=Enum.TextXAlignment.Left;head.Parent=hub
local sub=Instance.new("TextLabel")
sub.Position=UDim2.fromOffset(24,108);sub.Size=UDim2.fromOffset(500,20);sub.BackgroundTransparency=1
sub.Text="Select game to load specific features.";sub.Font=Enum.Font.Gotham;sub.TextSize=11
sub.TextColor3=Color3.fromRGB(165,157,187);sub.TextXAlignment=Enum.TextXAlignment.Left;sub.Parent=hub

local function card(x,title,tagline,accent,imageId)
    local f=Instance.new("Frame");f.Position=UDim2.fromOffset(x,145);f.Size=UDim2.fromOffset(350,190)
    f.BackgroundColor3=Color3.fromRGB(10,10,20);f.BorderSizePixel=0;f.ClipsDescendants=true;f.Parent=hub
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,14)
    local st=Instance.new("UIStroke",f);st.Color=accent;st.Transparency=.15;st.Thickness=1.3
    local bg=Instance.new("ImageLabel");bg.Size=UDim2.fromScale(1,1);bg.BackgroundTransparency=1
    bg.Image="rbxassetid://"..tostring(imageId);bg.ScaleType=Enum.ScaleType.Crop;bg.ImageTransparency=.08;bg.ZIndex=1;bg.Parent=f
    local shade=Instance.new("Frame");shade.Size=UDim2.fromScale(1,1);shade.BackgroundColor3=Color3.fromRGB(4,3,10)
    shade.BackgroundTransparency=.38;shade.BorderSizePixel=0;shade.ZIndex=2;shade.Parent=f
    local glow=Instance.new("Frame");glow.Size=UDim2.new(1,0,0,5);glow.BackgroundColor3=accent;glow.BorderSizePixel=0;glow.ZIndex=4;glow.Parent=f
    Instance.new("UICorner",glow).CornerRadius=UDim.new(0,14)
    local t=Instance.new("TextLabel");t.Position=UDim2.fromOffset(20,28);t.Size=UDim2.new(1,-40,0,32);t.BackgroundTransparency=1
    t.Text=title;t.Font=Enum.Font.GothamBold;t.TextSize=22;t.TextColor3=Color3.fromRGB(247,245,255);t.TextXAlignment=Enum.TextXAlignment.Left;t.ZIndex=3;t.Parent=f
    local s=Instance.new("TextLabel");s.Position=UDim2.fromOffset(20,62);s.Size=UDim2.new(1,-40,0,22);s.BackgroundTransparency=1
    s.Text=tagline;s.Font=Enum.Font.Gotham;s.TextSize=10;s.TextColor3=Color3.fromRGB(166,157,188);s.TextXAlignment=Enum.TextXAlignment.Left;s.ZIndex=3;s.Parent=f
    local b=Instance.new("TextButton");b.Position=UDim2.fromOffset(20,126);b.Size=UDim2.new(1,-40,0,44)
    b.BackgroundColor3=Color3.fromRGB(116,43,225);b.BorderSizePixel=0;b.Text="LOAD "..string.upper(title).."   ›"
    b.Font=Enum.Font.GothamBold;b.TextSize=12;b.TextColor3=Color3.new(1,1,1);b.ZIndex=3;b.Parent=f
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    return f,b
end

local _,animeBtn=card(24,"Anime Dice","Roll. Fight. Become Stronger.",Color3.fromRGB(111,57,219),90889252469875)
local _,rideBtn=card(390,"Ride A Pet","Hatch. Collect. Ride Together.",Color3.fromRGB(201,57,255),115727608036551)

local function preview(x,title,lines)
    local f=Instance.new("Frame");f.Position=UDim2.fromOffset(x,350);f.Size=UDim2.fromOffset(350,180)
    f.BackgroundColor3=Color3.fromRGB(10,10,19);f.BorderSizePixel=0;f.Parent=hub
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
    local st=Instance.new("UIStroke",f);st.Color=Color3.fromRGB(66,50,93);st.Transparency=.35
    local t=Instance.new("TextLabel");t.Position=UDim2.fromOffset(16,12);t.Size=UDim2.new(1,-32,0,24)
    t.BackgroundTransparency=1;t.Text=title.." - Features Preview";t.Font=Enum.Font.GothamBold;t.TextSize=12
    t.TextColor3=Color3.fromRGB(242,239,251);t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=f
    for i,v in ipairs(lines) do
        local l=Instance.new("TextLabel");l.Position=UDim2.fromOffset(18,39+(i-1)*22);l.Size=UDim2.new(1,-36,0,20)
        l.BackgroundTransparency=1;l.Text="✓   "..v;l.Font=Enum.Font.Gotham;l.TextSize=10
        l.TextColor3=Color3.fromRGB(211,204,225);l.TextXAlignment=Enum.TextXAlignment.Left;l.Parent=f
    end
end
preview(24,"Anime Dice",{"Auto Collect","Plot Selection","Collect Delay","Existing Anime Dice System","And More..."})
preview(390,"Ride A Pet",{"Auto Pickup Egg","World Egg ESP","Rarity Filter","ESP Board & Line","Live Filter System"})

local function hasDesc(root,name)
    for _,o in ipairs(root:GetDescendants()) do if o.Name==name then return true end end
    return false
end
local signals=0
for _,n in ipairs({"PlotService","RollService","DiceShop","CollectBalance","RollDice","SetAutoRoll"}) do
    if hasDesc(RS,n) then signals+=1 end
end
local animeAllowed=signals>=2

-- Ride A Pet detection: use the same objects as the tested RideAPet_v42 build.
-- Do not depend on Packages/Datas/Assets, because those are not the live paths
-- used by the working Ride A Pet script.
local gameData=RS:FindFirstChild("GameData")
local eggData=gameData and gameData:FindFirstChild("Eggs")
local renderedEggs=workspace:FindFirstChild("RenderedEggs")
local plots=workspace:FindFirstChild("Plots")
local rideDetected=(eggData ~= nil) and (renderedEggs ~= nil) and (plots ~= nil)
local detected=rideDetected and "Ride A Pet" or (animeAllowed and "Anime Dice" or "Unknown")

local detect=Instance.new("TextLabel");detect.Position=UDim2.new(1,-230,0,77);detect.Size=UDim2.fromOffset(200,45)
detect.BackgroundColor3=Color3.fromRGB(13,13,24);detect.Text="Game Detected\n"..detected;detect.Font=Enum.Font.GothamBold
detect.TextSize=10;detect.TextColor3=Color3.fromRGB(193,91,255);detect.Parent=hub
Instance.new("UICorner",detect).CornerRadius=UDim.new(0,10)

if not animeAllowed then
    animeBtn.Text="NOT AVAILABLE IN THIS GAME";animeBtn.BackgroundColor3=Color3.fromRGB(43,40,52)
    animeBtn.TextColor3=Color3.fromRGB(132,126,145);animeBtn.AutoButtonColor=false
    animeBtn.Active=false;animeBtn.Interactable=false
    local lock=Instance.new("TextButton");lock.Name="ANIME_DICE_GAME_LOCK";lock.Position=animeBtn.Position;lock.Size=animeBtn.Size
    lock.AnchorPoint=animeBtn.AnchorPoint;lock.BackgroundTransparency=1;lock.Text="";lock.AutoButtonColor=false
    lock.Active=true;lock.Interactable=true;lock.ZIndex=animeBtn.ZIndex+20;lock.Parent=animeBtn.Parent
end

animeBtn.MouseButton1Click:Connect(function()
    if not animeAllowed then return end
    hub.Visible=false
    oldHolder.Visible=true
end)

local rideLoaded=false
rideBtn.MouseButton1Click:Connect(function()
    if not rideDetected then return end
    if rideLoaded then
        local g=lp.PlayerGui:FindFirstChild("599_RIDE_A_PET_UNIFIED_TEST")
        if g then g.Enabled=true end
        return
    end
    rideLoaded=true
    local ok,err=pcall(function()
        local src=game:HttpGet("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/RideAPet_v42.lua?v=20260922_higlight_layout_v3")
        local fn,e=loadstring(src);if not fn then error(e) end;fn()
    end)
    if not ok then rideLoaded=false;warn("[599 RIDE A PET V42] "..tostring(err)) end
end)

print("[599 GAME HUB V42] ready")
