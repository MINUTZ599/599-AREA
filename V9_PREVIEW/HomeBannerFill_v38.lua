-- 599 AREA V9 PREVIEW v38 - HOME BANNER FILL FIX ONLY
-- ONLY changes HOME hero image scaling/position. No other tab/feature touched.
local Players=game:GetService("Players")
local pg=Players.LocalPlayer:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local home=gui:FindFirstChild("HOME",true)
if not home then return end
local scroll=home:FindFirstChild("V34_HOME")
if not scroll then return end

local hero=nil
for _,c in ipairs(scroll:GetChildren()) do
    if c:IsA("Frame") and c.AbsoluteSize.Y >= 170 then
        hero=c
        break
    end
end
if not hero then return end

local image=nil
for _,c in ipairs(hero:GetChildren()) do
    if c:IsA("ImageLabel") then image=c break end
end
if not image then return end

image.AnchorPoint=Vector2.new(0.5,0.5)
image.Position=UDim2.fromScale(0.5,0.5)
image.Size=UDim2.fromScale(1,1)
image.Image="rbxassetid://129070764930166"
image.ImageTransparency=0
image.BackgroundTransparency=1
image.ScaleType=Enum.ScaleType.Crop
image.ImageRectOffset=Vector2.zero
image.ImageRectSize=Vector2.zero
image.ZIndex=1
hero.ClipsDescendants=true

print("[599 V38] HOME banner now fills hero border")