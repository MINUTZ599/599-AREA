-- 599 AREA V8.4 | DIAGNOSTIC DIRECT LOADER
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player and player:FindFirstChildOfClass("PlayerGui") or nil

local diagGui, diagLabel
local function showStatus(msg, isError)
    pcall(function()
        if not playerGui and player then playerGui = player:WaitForChild("PlayerGui", 5) end
        if not playerGui then return end
        if not diagGui then
            diagGui = Instance.new("ScreenGui")
            diagGui.Name = "AREA599_V84_DIAGNOSTIC"
            diagGui.ResetOnSpawn = false
            diagGui.IgnoreGuiInset = true
            diagGui.Parent = playerGui

            diagLabel = Instance.new("TextLabel")
            diagLabel.Name = "Status"
            diagLabel.AnchorPoint = Vector2.new(0.5,0)
            diagLabel.Position = UDim2.new(0.5,0,0,16)
            diagLabel.Size = UDim2.new(0,760,0,70)
            diagLabel.BackgroundColor3 = Color3.fromRGB(12,12,12)
            diagLabel.BackgroundTransparency = 0.08
            diagLabel.BorderSizePixel = 0
            diagLabel.Font = Enum.Font.GothamBold
            diagLabel.TextSize = 16
            diagLabel.TextWrapped = true
            diagLabel.TextColor3 = Color3.fromRGB(255,145,0)
            diagLabel.ZIndex = 999999
            diagLabel.Parent = diagGui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,10)
            corner.Parent = diagLabel
        end
        diagLabel.TextColor3 = isError and Color3.fromRGB(255,80,80) or Color3.fromRGB(255,145,0)
        diagLabel.Text = "599 AREA V8.4 | " .. tostring(msg)
    end)
end

local function fail(msg)
    showStatus(msg, true)
    warn("[599 AREA V8.4] " .. tostring(msg))
    return nil
end

showStatus("loader started...", false)

local BASE = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/417965fea92cf2b472a48edea27f19de8b0e67b2/V8_4/Client/"
local chunks = {}

for i = 0, 9 do
    local path = string.format("chunk_%02d.lua", i)
    showStatus("downloading " .. path .. "...", false)
    local ok, data = pcall(function()
        return game:HttpGet(BASE .. path)
    end)
    if not ok then return fail("HTTP ERROR " .. path .. ": " .. tostring(data)) end
    if type(data) ~= "string" or #data == 0 then return fail("EMPTY CHUNK " .. path) end

    -- Some executors/raw HTTP layers append a newline to each response.
    -- These V8.4 chunks were originally split mid-token, so remove only
    -- trailing CR/LF before joining them back together.
    if i < 9 then
        data = data:gsub("[\r\n]+$", "")
    end
    chunks[#chunks + 1] = data
end

showStatus("compiling V8.4...", false)
local source = table.concat(chunks)
local fn, compileError = loadstring(source)
if not fn then return fail("COMPILE ERROR: " .. tostring(compileError)) end

showStatus("starting V8.4 GUI...", false)
local ok, runtimeError = xpcall(fn, function(err)
    local tb = ""
    pcall(function() tb = debug.traceback() end)
    return tostring(err) .. (tb ~= "" and ("\n" .. tb) or "")
end)
if not ok then return fail("RUNTIME ERROR: " .. tostring(runtimeError)) end

showStatus("V8.4 loaded successfully", false)
task.delay(2, function()
    pcall(function() if diagGui then diagGui:Destroy() end end)
end)
