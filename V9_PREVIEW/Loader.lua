-- 599 AREA V9 PREVIEW DIAGNOSTIC LOADER v8
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
box.Text = "599 V9 DIAGNOSTIC | LOADER OK - downloading Client_v7..."
box.Parent = diag
Instance.new("UICorner",box).CornerRadius = UDim.new(0,12)
local st = Instance.new("UIStroke",box)
st.Color = Color3.fromRGB(140,70,255)
st.Thickness = 1.3

local url = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Client_v7.lua?v=8"
local ok, src = pcall(function()
    return game:HttpGet(url)
end)

if not ok then
    box.TextColor3 = Color3.fromRGB(255,100,120)
    box.Text = "599 V9 DIAGNOSTIC | HTTP ERROR: " .. tostring(src)
    return
end

box.Text = "599 V9 DIAGNOSTIC | DOWNLOAD OK (" .. tostring(#src) .. " bytes) - compiling..."

local fn, err = loadstring(src)
if not fn then
    box.TextColor3 = Color3.fromRGB(255,100,120)
    box.Text = "599 V9 DIAGNOSTIC | COMPILE ERROR: " .. tostring(err)
    return
end

box.Text = "599 V9 DIAGNOSTIC | COMPILE OK - running client..."

local rok, runtimeErr = xpcall(fn, function(e)
    return tostring(e)
end)

if not rok then
    box.TextColor3 = Color3.fromRGB(255,100,120)
    box.Text = "599 V9 DIAGNOSTIC | RUNTIME ERROR: " .. tostring(runtimeErr)
    return
end

box.TextColor3 = Color3.fromRGB(100,255,170)
box.Text = "599 V9 DIAGNOSTIC | SUCCESS - GUI loaded"
task.delay(3,function()
    if diag and diag.Parent then diag:Destroy() end
end)
