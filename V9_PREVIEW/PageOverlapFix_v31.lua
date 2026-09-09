-- 599 AREA V9 PREVIEW v31 - migrated page overlap fix
-- Removes ONLY leftover placeholder children from the original base pages.
-- Keeps the migrated holders and all feature logic untouched.
local Players=game:GetService("Players")
local pg=Players.LocalPlayer:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local keep={
    VISUALS="V25_VISUALS",
    PLAYER="V26_PLAYER",
    WORLD="V27_WORLD",
    SETTINGS="V29_SETTINGS",
}

for pageName,holderName in pairs(keep) do
    local page=gui:FindFirstChild(pageName,true)
    if page then
        local holder=page:FindFirstChild(holderName)
        if holder then
            for _,child in ipairs(page:GetChildren()) do
                if child~=holder then
                    child:Destroy()
                end
            end
        end
    end
end

print("[599 V31] VISUALS / PLAYER / WORLD / SETTINGS overlap fixed")