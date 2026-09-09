-- 599 AREA V9 PREVIEW widescreen geometry patch v19
-- Only changes overall width and Anime Dice hero/banner proportions.
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local root = gui:FindFirstChild("Root")
if not root or not root:IsA("Frame") then return end

-- Make the window wider like the visual reference, while keeping the height compact.
root.Size = UDim2.fromOffset(1120,620)

-- Keep responsive scaling correct for the wider canvas.
local scale = root:FindFirstChildOfClass("UIScale")
local function applyScale()
    if not scale then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local s = cam.ViewportSize
    scale.Scale = math.clamp(math.min((s.X-24)/1120,(s.Y-24)/620),0.50,1)
end
applyScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        task.defer(applyScale)
    end)
end

-- Widen only the Anime Dice hero image on the right side.
local banner
for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("ImageLabel") then
        local img = tostring(obj.Image)
        if img:find("95794241567731",1,true) or img:find("126519323866401",1,true) then
            if obj.AbsoluteSize.X >= 250 and obj.AbsoluteSize.Y >= 70 then
                banner = obj
                break
            end
        end
    end
end

if banner then
    banner.Size = UDim2.fromOffset(520,112)
    banner.Position = UDim2.new(1,-520,0,0)
    banner.Image = "rbxassetid://95794241567731"
    banner.ImageTransparency = 0
    banner.ImageRectOffset = Vector2.new(0,0)
    banner.ImageRectSize = Vector2.new(0,0)
    banner.ScaleType = Enum.ScaleType.Crop
end
