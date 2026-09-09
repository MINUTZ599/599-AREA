-- 599 AREA V9 PREVIEW v39 - STARTUP HOME ONLY
-- ONLY changes the initially visible tab after execute.
local Players=game:GetService("Players")
local pg=Players.LocalPlayer:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local names={"HOME","MAIN","VISUALS","PLAYER","WORLD","ANIME DICE","SETTINGS","CREDITS"}
local home=gui:FindFirstChild("HOME",true)
if not home then return end

for _,name in ipairs(names) do
    local page=gui:FindFirstChild(name,true)
    if page and page:IsA("Frame") then
        page.Visible=(page==home)
    end
end

-- Match sidebar active highlight to HOME without rebuilding any navigation.
local root=gui:FindFirstChild("Root",true)
if root then
    local sidebar=root:FindFirstChildWhichIsA("Frame")
    if sidebar then
        for _,b in ipairs(sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                local title=nil
                for _,d in ipairs(b:GetChildren()) do
                    if d:IsA("TextLabel") and string.lower(d.Text)=="home" then title=d break end
                end
                if title then
                    b.BackgroundColor3=Color3.fromRGB(54,27,96)
                    for _,d in ipairs(b:GetChildren()) do
                        if d:IsA("TextLabel") then
                            if d.Text=="Home" then
                                -- title preserved
                            elseif d.Text=="Dashboard" then
                                d.TextColor3=Color3.fromRGB(191,124,255)
                            end
                        end
                    end
                end
            end
        end
    end
end

print("[599 V39] startup page set to HOME")