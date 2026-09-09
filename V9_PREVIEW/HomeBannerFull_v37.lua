-- 599 AREA V9 PREVIEW v37 - HOME HERO FULL PHOTO ONLY
-- ONLY changes HOME hero composition. No other tab/feature touched.
local Players=game:GetService("Players")
local pg=Players.LocalPlayer:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local home=gui:FindFirstChild("HOME",true)
if not home then return end
local scroll=home:FindFirstChild("V34_HOME")
if not scroll then return end

-- Hero is the first large frame created by HomeDashboard_v34.
local hero=nil
for _,c in ipairs(scroll:GetChildren()) do
    if c:IsA("Frame") and c.AbsoluteSize.Y >= 170 then
        hero=c
        break
    end
end
if not hero then return end

-- Remove only HOME hero overlays/text/shading, preserving corner/stroke.
for _,c in ipairs(hero:GetChildren()) do
    if c:IsA("TextLabel") or c:IsA("TextButton") then
        c:Destroy()
    elseif c:IsA("Frame") then
        c:Destroy()
    end
end

-- Find existing hero image and make it fill the entire hero.
local image=nil
for _,c in ipairs(hero:GetChildren()) do
    if c:IsA("ImageLabel") then image=c break end
end
if not image then
    image=Instance.new("ImageLabel")
    image.BackgroundTransparency=1
    image.Parent=hero
end
image.Position=UDim2.fromScale(0,0)
image.Size=UDim2.fromScale(1,1)
image.Image="rbxassetid://129070764930166"
image.ImageTransparency=0
image.ScaleType=Enum.ScaleType.Fit
image.ImageRectOffset=Vector2.zero
image.ImageRectSize=Vector2.zero
image.ZIndex=1

-- Keep rounded clipping and purple outline already belonging to hero.
hero.ClipsDescendants=true
print("[599 V37] HOME hero = full clean banner")