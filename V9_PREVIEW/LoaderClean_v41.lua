-- 599 AREA V9 PREVIEW CLEAN LOADER v41
-- Current V41 stack preserved. Adds compact 430x210 live loading screen tied to real module loading.
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")

-- =========================
-- 599 AREA LIVE LOADING GUI
-- Size/position LOCKED: 430x210, centered
-- =========================
local oldLoading=pg:FindFirstChild("AREA599_LOADING")
if oldLoading then oldLoading:Destroy() end

local loadingGui=Instance.new("ScreenGui")
loadingGui.Name="AREA599_LOADING"
loadingGui.IgnoreGuiInset=true
loadingGui.ResetOnSpawn=false
loadingGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
loadingGui.DisplayOrder=999999
loadingGui.Parent=pg

local panel=Instance.new("Frame")
panel.Name="LoadingPanel"
panel.AnchorPoint=Vector2.new(0.5,0.5)
panel.Position=UDim2.fromScale(0.5,0.5)
panel.Size=UDim2.new(0,430,0,210)
panel.BackgroundColor3=Color3.fromRGB(5,5,10)
panel.BorderSizePixel=0
panel.ClipsDescendants=true
panel.Parent=loadingGui

local panelCorner=Instance.new("UICorner")
panelCorner.CornerRadius=UDim.new(0,7)
panelCorner.Parent=panel

local image=Instance.new("ImageLabel")
image.Name="BackgroundImage"
image.Size=UDim2.fromScale(1,1)
image.Position=UDim2.fromScale(0,0)
image.BackgroundTransparency=1
image.Image="rbxassetid://93304575507770"
image.ScaleType=Enum.ScaleType.Stretch
image.Parent=panel

local imageCorner=Instance.new("UICorner")
imageCorner.CornerRadius=UDim.new(0,7)
imageCorner.Parent=image

local mask=Instance.new("Frame")
mask.Name="ProgressMask"
mask.Position=UDim2.new(0,89,0,128)
mask.Size=UDim2.new(0,278,0,22)
mask.BackgroundColor3=Color3.fromRGB(7,7,14)
mask.BorderSizePixel=0
mask.Parent=panel

local progressBG=Instance.new("Frame")
progressBG.Name="ProgressBG"
progressBG.Position=UDim2.new(0,92,0,132)
progressBG.Size=UDim2.new(0,238,0,8)
progressBG.BackgroundColor3=Color3.fromRGB(15,14,30)
progressBG.BorderSizePixel=0
progressBG.ClipsDescendants=true
progressBG.Parent=panel

local progressCorner=Instance.new("UICorner")
progressCorner.CornerRadius=UDim.new(1,0)
progressCorner.Parent=progressBG

local progressStroke=Instance.new("UIStroke")
progressStroke.Color=Color3.fromRGB(75,63,145)
progressStroke.Thickness=1
progressStroke.Transparency=0.2
progressStroke.Parent=progressBG

local progress=Instance.new("Frame")
progress.Name="Progress"
progress.Size=UDim2.new(0,0,1,0)
progress.BackgroundColor3=Color3.fromRGB(185,65,255)
progress.BorderSizePixel=0
progress.Parent=progressBG

local fillCorner=Instance.new("UICorner")
fillCorner.CornerRadius=UDim.new(1,0)
fillCorner.Parent=progress

local fillGradient=Instance.new("UIGradient")
fillGradient.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(166,35,255)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(220,110,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(255,205,255))
})
fillGradient.Parent=progress

local percentage=Instance.new("TextLabel")
percentage.Name="Percentage"
percentage.Position=UDim2.new(0,337,0,125)
percentage.Size=UDim2.new(0,55,0,22)
percentage.BackgroundTransparency=1
percentage.Text="0%"
percentage.TextColor3=Color3.fromRGB(245,245,255)
percentage.TextSize=15
percentage.Font=Enum.Font.GothamBold
percentage.TextXAlignment=Enum.TextXAlignment.Left
percentage.Parent=panel

-- Smooth visual progress. Real module completion only moves this target.
local displayedProgress=0
local targetProgress=0
local progressConnection

progressConnection=RunService.RenderStepped:Connect(function(dt)
    if not loadingGui.Parent then return end
    local diff=targetProgress-displayedProgress
    if math.abs(diff)<0.01 then
        displayedProgress=targetProgress
    else
        displayedProgress=displayedProgress + diff*math.min(dt*8,1)
    end
    progress.Size=UDim2.new(displayedProgress/100,0,1,0)
    percentage.Text=tostring(math.floor(displayedProgress+0.5)).."%"
end)

local function SetProgress(value)
    targetProgress=math.clamp(value,0,100)
end

local function FinishLoading()
    SetProgress(100)

    -- Let the smooth bar visibly reach 100% before revealing HOME.
    while displayedProgress<99.85 do
        RunService.RenderStepped:Wait()
    end
    displayedProgress=100
    progress.Size=UDim2.new(1,0,1,0)
    percentage.Text="100%"

    local mainGui=pg:FindFirstChild("AREA599_V9_PREVIEW")
    local mainRoot=mainGui and mainGui:FindFirstChild("Root",true)
    if mainRoot and mainRoot.Parent then
        mainRoot.Visible=true
    end

    if progressConnection then
        progressConnection:Disconnect()
        progressConnection=nil
    end

    TweenService:Create(image,TweenInfo.new(0.3),{ImageTransparency=1}):Play()
    TweenService:Create(panel,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()

    for _,object in ipairs(panel:GetDescendants()) do
        if object:IsA("TextLabel") then
            TweenService:Create(object,TweenInfo.new(0.3),{TextTransparency=1}):Play()
        elseif object:IsA("Frame") then
            TweenService:Create(object,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        elseif object:IsA("UIStroke") then
            TweenService:Create(object,TweenInfo.new(0.3),{Transparency=1}):Play()
        end
    end

    task.delay(0.32,function()
        if loadingGui and loadingGui.Parent then
            loadingGui:Destroy()
        end
    end)
end

SetProgress(3)
task.wait()

for _,name in ipairs({"AREA599_V9_PREVIEW","AREA599_V9_DIAGNOSTIC","AREA599_V25_VISUAL_OVERLAY"}) do
    local old=pg:FindFirstChild(name)
    if old then old:Destroy() end
end

SetProgress(5)
task.wait(.05)

local function run(url,progressValue)
    local src=game:HttpGet(url)
    local fn,err=loadstring(src)
    if not fn then error(err) end
    local result=fn()
    if progressValue then SetProgress(progressValue) end
    return result
end

-- Build BASE with HOME as the true initial page.
do
    local url="https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Client_v7.lua?clean=41a-global1"
    local src=game:HttpGet(url)
    local patched,count=src:gsub('selectPage%(%"ANIME DICE%"%)','selectPage("HOME")',1)
    if count~=1 then error("[599 V41] startup HOME patch failed") end
    local fn,err=loadstring(patched)
    if not fn then error(err) end
    fn()
end
SetProgress(12)

-- Hide only the main panel while the remaining approved patches are assembled.
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
local root=gui and gui:FindFirstChild("Root",true)
if root then root.Visible=false end

-- V41 approved stack, unchanged. Progress targets update only after each real module finishes.
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/IconPatch_v9.lua?clean=41b-global1",16)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeIconFix_v12.lua?clean=41c-global1",20)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/BannerRoblox_v14.lua?clean=41d-global1",24)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Logo599Dollar_v22.lua?clean=41e-global1",28)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/MinimizeDock_v23.lua?clean=41f-global1",32)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/MainPatch_v24.lua?clean=41g-global1",38)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/VisualsTab_v25.lua?clean=41h-global1",44)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/PlayerTab_v26.lua?clean=41i-global1",50)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/PlayerTrackerBridge_v26.lua?clean=41j-global1",55)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/WorldTab_v27.lua?clean=41k-global1",61)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/AnimeDicePatch_v28.lua?clean=41l-delayfix1-global1",67)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/SettingsTab_v29.lua?clean=41m-global1",72)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/FreecamMain_v30.lua?clean=41n-camerafix1-global1",78)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/PageOverlapFix_v31.lua?clean=41o-global1",83)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/NoclipSpectateResponsive_v33.lua?clean=41p-global1",88)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeDashboard_v34.lua?clean=41q-global1",92)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeBannerRoblox_v36.lua?clean=41r-global1",95)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeBannerFull_v37.lua?clean=41s-global1",97)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeBannerFill_v38.lua?clean=41t-global1",99)

FinishLoading()

print("[599 V41] startup ready - smooth loading reached 100% then HOME revealed")