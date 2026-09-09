-- 599 AREA V9 PREVIEW ICON PATCH v10
-- Uses the exact 8 icons supplied by the user.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local gui = pg:WaitForChild("AREA599_V9_PREVIEW", 10)
if not gui then return end

local function b64decode(data)
    local alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..alphabet..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r, f = '', (alphabet:find(x, 1, true) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0')
        end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i,i) == '1' and 2^(8-i) or 0)
        end
        return string.char(c)
    end))
end

local customAsset = getcustomasset or getsynasset
if type(writefile) ~= "function" or type(customAsset) ~= "function" then
    warn("[599 V9 ICONS] writefile/getcustomasset unsupported by executor")
    return
end

local assetsUrl = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/IconAssets_v10.lua?v=10"
local ok, src = pcall(function()
    return game:HttpGet(assetsUrl)
end)
if not ok then
    warn("[599 V9 ICONS] failed to download icon assets: " .. tostring(src))
    return
end

local fn, compileErr = loadstring(src)
if not fn then
    warn("[599 V9 ICONS] icon asset compile error: " .. tostring(compileErr))
    return
end

local assetData = fn()
if type(assetData) ~= "table" then
    warn("[599 V9 ICONS] invalid icon asset table")
    return
end

local iconKeyByTitle = {
    ["Home"] = "home",
    ["Main"] = "main",
    ["Visuals"] = "visuals",
    ["Player"] = "player",
    ["World"] = "world",
    ["Anime Dice"] = "anime_dice",
    ["Settings"] = "settings",
    ["Credits"] = "credits",
}

local loadedAssets = {}
for key, encoded in pairs(assetData) do
    local fileName = "599_v9_icon_" .. key .. ".png"
    local decoded = b64decode(encoded)
    local wrote = pcall(function()
        writefile(fileName, decoded)
    end)
    if wrote then
        local assetOk, assetId = pcall(function()
            return customAsset(fileName)
        end)
        if assetOk and assetId then
            loadedAssets[key] = assetId
        end
    end
end

for _, obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("TextButton") then
        local titleLabel
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("TextLabel") and iconKeyByTitle[child.Text] then
                titleLabel = child
                break
            end
        end

        if titleLabel then
            local key = iconKeyByTitle[titleLabel.Text]
            local assetId = loadedAssets[key]
            if assetId then
                local oldIcon
                for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("TextLabel") and child ~= titleLabel and child.Position.X.Offset <= 16 then
                        oldIcon = child
                        break
                    end
                end

                if oldIcon then
                    local icon = Instance.new("ImageLabel")
                    icon.Name = "CustomIcon"
                    icon.Position = oldIcon.Position
                    icon.Size = oldIcon.Size
                    icon.AnchorPoint = oldIcon.AnchorPoint
                    icon.BackgroundColor3 = oldIcon.BackgroundColor3
                    icon.BackgroundTransparency = oldIcon.BackgroundTransparency
                    icon.BorderSizePixel = 0
                    icon.Image = assetId
                    icon.ImageColor3 = Color3.new(1,1,1)
                    icon.ImageTransparency = 0
                    icon.ScaleType = Enum.ScaleType.Fit
                    icon.ZIndex = oldIcon.ZIndex
                    icon.Parent = obj

                    local oldCorner = oldIcon:FindFirstChildOfClass("UICorner")
                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = oldCorner and oldCorner.CornerRadius or UDim.new(0,9)
                    corner.Parent = icon

                    oldIcon.Visible = false
                end
            end
        end
    end
end

-- Keep the brand box clean; do not replace it with emoji.
for _, obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("TextLabel") and (obj.Text == "599" or obj.Text == "♛") and obj.Size.X.Offset <= 50 then
        obj.Text = "599"
        obj.TextSize = 15
        break
    end
end
