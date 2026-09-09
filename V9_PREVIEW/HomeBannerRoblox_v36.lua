-- 599 AREA V9 PREVIEW v36 - HOME BANNER ONLY
-- Changes ONLY the HOME hero image. No other page/feature is touched.
local Players=game:GetService("Players")
local pg=Players.LocalPlayer:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local home=gui:FindFirstChild("HOME",true)
if not home then return end
local scroll=home:FindFirstChild("V34_HOME")
if not scroll then return end

local target=nil
for _,d in ipairs(scroll:GetDescendants()) do
    if d:IsA("ImageLabel") then
        if not target or (d.AbsoluteSize.X*d.AbsoluteSize.Y) > (target.AbsoluteSize.X*target.AbsoluteSize.Y) then
            target=d
        end
    end
end

if target then
    target.Image="rbxassetid://129070764930166"
    target.ImageTransparency=0
    target.ScaleType=Enum.ScaleType.Crop
    target.ImageRectOffset=Vector2.zero
    target.ImageRectSize=Vector2.zero
end

print("[599 V36] HOME banner set to Roblox asset 129070764930166")