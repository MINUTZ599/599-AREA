-- 599 AREA V8.5 - AIR WALK ADDON
-- Adds Air Walk to the existing MOVEMENT page without changing the base layout.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local base = pg:WaitForChild("AREA599_V8", 10)
if not base then
    warn("[599 V8.5] base GUI missing for Air Walk")
    return
end

local movementPage = base:FindFirstChild("MOVEMENT", true)
if not movementPage then
    warn("[599 V8.5] MOVEMENT page missing")
    return
end

local oldCard = movementPage:FindFirstChild("V85_AIRWALK_CARD")
if oldCard then oldCard:Destroy() end

local oldPlatform = workspace:FindFirstChild("AREA599_AIRWALK_" .. lp.UserId)
if oldPlatform then oldPlatform:Destroy() end

local PANEL = Color3.fromRGB(16,16,20)
local WHITE = Color3.fromRGB(245,245,247)
local MUTED = Color3.fromRGB(155,155,168)
local GREEN = Color3.fromRGB(48,185,87)
local STROKE = Color3.fromRGB(111,51,15)

local enabled = false
local platform = nil
local holdY = nil

local function corner(o,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r or 8)
    c.Parent = o
end

local function outline(o)
    local s = Instance.new("UIStroke")
    s.Color = STROKE
    s.Transparency = .42
    s.Thickness = 1
    s.Parent = o
end

local function label(par,txt,pos,sz,col,bold,size)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Text = txt
    x.Position = pos
    x.Size = sz
    x.TextColor3 = col or WHITE
    x.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    x.TextSize = size or 11
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.TextYAlignment = Enum.TextYAlignment.Center
    x.Parent = par
    return x
end

local function notify(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification",{
            Title = "599 AREA V8.5",
            Text = msg,
            Duration = 2
        })
    end)
end

local card = Instance.new("Frame")
card.Name = "V85_AIRWALK_CARD"
card.Size = UDim2.fromOffset(455,64)
card.Position = UDim2.fromOffset(490,400)
card.BackgroundColor3 = PANEL
card.BackgroundTransparency = .04
card.BorderSizePixel = 0
card.Parent = movementPage
corner(card,8)
outline(card)

label(card,"AIR WALK [ H ]",UDim2.fromOffset(15,8),UDim2.new(1,-105,0,23),WHITE,true,12)
label(card,"Walk in mid-air without falling",UDim2.fromOffset(15,34),UDim2.new(1,-110,0,18),MUTED,false,10)

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(62,30)
toggle.Position = UDim2.new(1,-76,.5,-15)
toggle.BackgroundColor3 = Color3.fromRGB(42,42,49)
toggle.Text = "OFF"
toggle.TextColor3 = WHITE
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 10
toggle.AutoButtonColor = false
toggle.Parent = card
corner(toggle,15)

local function setVisual(on)
    toggle.Text = on and "ON" or "OFF"
    toggle.BackgroundColor3 = on and GREEN or Color3.fromRGB(42,42,49)
end

local function destroyPlatform()
    if platform then
        platform:Destroy()
        platform = nil
    end
end

local function createPlatform()
    destroyPlatform()
    platform = Instance.new("Part")
    platform.Name = "AREA599_AIRWALK_" .. lp.UserId
    platform.Anchored = true
    platform.CanCollide = true
    platform.CanTouch = false
    platform.CanQuery = false
    platform.Transparency = 1
    platform.Size = Vector3.new(8,0.6,8)
    platform.CastShadow = false
    platform.Parent = workspace
end

local function setAirWalk(on)
    enabled = on
    setVisual(on)

    if on then
        local ch = lp.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then
            enabled = false
            setVisual(false)
            notify("Air Walk: character unavailable")
            return
        end

        holdY = root.Position.Y - 3.15
        createPlatform()
        notify("Air Walk ON")
    else
        holdY = nil
        destroyPlatform()
        notify("Air Walk OFF")
    end
end

toggle.MouseButton1Click:Connect(function()
    setAirWalk(not enabled)
end)

UIS.InputBegan:Connect(function(input,gpe)
    if gpe or UIS:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.H then
        setAirWalk(not enabled)
    end
end)

RunService.Heartbeat:Connect(function()
    if not enabled then return end

    local ch = lp.Character
    local root = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")

    if not root or not hum or hum.Health <= 0 then
        destroyPlatform()
        return
    end

    if not platform or not platform.Parent then
        holdY = root.Position.Y - 3.15
        createPlatform()
    end

    platform.CFrame = CFrame.new(root.Position.X, holdY, root.Position.Z)
end)

lp.CharacterAdded:Connect(function(char)
    destroyPlatform()
    if not enabled then return end

    local root = char:WaitForChild("HumanoidRootPart",10)
    local hum = char:WaitForChild("Humanoid",10)
    if root and hum then
        holdY = root.Position.Y - 3.15
        createPlatform()
    end
end)

notify("Air Walk added to MOVEMENT")
