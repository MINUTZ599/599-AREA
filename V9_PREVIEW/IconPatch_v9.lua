-- 599 AREA V9 PREVIEW ICON PATCH
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local gui = pg:WaitForChild("AREA599_V9_PREVIEW", 10)
if not gui then return end

local iconMap = {
    ["Home"] = "🏠",
    ["Main"] = "📈",
    ["Visuals"] = "👁",
    ["Player"] = "👥",
    ["World"] = "🌐",
    ["Anime Dice"] = "🎲",
    ["Settings"] = "⚙",
    ["Credits"] = "ⓘ",
}

for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("TextButton") then
        local titleLabel = nil
        for _,child in ipairs(obj:GetChildren()) do
            if child:IsA("TextLabel") and iconMap[child.Text] then
                titleLabel = child
                break
            end
        end
        if titleLabel then
            local wantedIcon = iconMap[titleLabel.Text]
            local iconLabel = nil
            for _,child in ipairs(obj:GetChildren()) do
                if child:IsA("TextLabel") and child ~= titleLabel and child.Position.X.Offset <= 16 then
                    iconLabel = child
                    break
                end
            end
            if iconLabel then
                iconLabel.Text = wantedIcon
                iconLabel.Font = Enum.Font.GothamBold
                iconLabel.TextSize = 16
            end
        end
    end
end

-- Crown-style brand mark
for _,obj in ipairs(gui:GetDescendants()) do
    if obj:IsA("TextLabel") and obj.Text == "599" and obj.Size.X.Offset <= 50 then
        obj.Text = "♛"
        obj.TextSize = 24
        break
    end
end
