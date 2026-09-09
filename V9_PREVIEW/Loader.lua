-- 599 AREA V9 PREVIEW LOADER v14
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local old = pg:FindFirstChild("AREA599_V9_DIAGNOSTIC")
if old then old:Destroy() end

local diag = Instance.new("ScreenGui")
diag.Name = "AREA599_V9_DIAGNOSTIC"
diag.ResetOnSpawn = false
diag.IgnoreGuiInset = true
diag.DisplayOrder = 999999
diag.Parent = pg

local box = Instance.new("TextLabel")
box.AnchorPoint = Vector2.new(0.5,0)
box.Position = UDim2.new(0.5,0,0,20)
box.Size = UDim2.fromOffset(560,64)
box.BackgroundColor3 = Color3.fromRGB(10,8,18)
box.BackgroundTransparency = 0.05
box.BorderSizePixel = 0
box.TextColor3 = Color3.fromRGB(210,170,255)
box.Font = Enum.Font.GothamBold
box.TextSize = 14
box.TextWrapped = true
box.Text = "599 V9 | loading preview..."
box.Parent = diag
Instance.new("UICorner",box).CornerRadius = UDim.new(0,12)
local st = Instance.new("UIStroke",box)
st.Color = Color3.fromRGB(140,70,255)
st.Thickness = 1.3

local function run(url,label)
    local ok,src = pcall(function() return game:HttpGet(url) end)
    if not ok then
        box.TextColor3 = Color3.fromRGB(255,100,120)
        box.Text = "599 V9 | "..label.." HTTP ERROR: "..tostring(src)
        return false
    end
    local fn,err = loadstring(src)
    if not fn then
        box.TextColor3 = Color3.fromRGB(255,100,120)
        box.Text = "599 V9 | "..label.." COMPILE ERROR: "..tostring(err)
        return false
    end
    local rok,rerr = xpcall(fn,function(e) return tostring(e) end)
    if not rok then
        box.TextColor3 = Color3.fromRGB(255,100,120)
        box.Text = "599 V9 | "..label.." RUNTIME ERROR: "..tostring(rerr)
        return false
    end
    return true
end

if not run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Client_v7.lua?v=14","CLIENT") then return end
task.wait(0.12)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/IconPatch_v9.lua?v=14","ICONS")
task.wait(0.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeIconFix_v12.lua?v=14","HOME ICON")
task.wait(0.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/BannerRoblox_v14.lua?v=14","BANNER")

box.TextColor3 = Color3.fromRGB(100,255,170)
box.Text = "599 V9 | SUCCESS"
task.delay(2,function()
    if diag and diag.Parent then diag:Destroy() end
end)
