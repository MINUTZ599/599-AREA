-- 599 AREA V9 PREVIEW CLEAN LOADER v25
-- V24 preserved. ONLY adds migrated VISUALS tab features.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
for _,name in ipairs({"AREA599_V9_PREVIEW","AREA599_V9_DIAGNOSTIC","AREA599_V25_VISUAL_OVERLAY"}) do
    local old=pg:FindFirstChild(name)
    if old then old:Destroy() end
end
task.wait(.1)
local function run(url)
    local src=game:HttpGet(url)
    local fn,err=loadstring(src)
    if not fn then error(err) end
    return fn()
end
-- Stable V24 base, unchanged.
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Client_v7.lua?clean=25a")
task.wait(.12)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/IconPatch_v9.lua?clean=25b")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeIconFix_v12.lua?clean=25c")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/BannerRoblox_v14.lua?clean=25d")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Logo599Dollar_v22.lua?clean=25e")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/MinimizeDock_v23.lua?clean=25f")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/MainPatch_v24.lua?clean=25g")
task.wait(.08)
-- ONLY new change in v25: VISUALS tab migration.
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/VisualsTab_v25.lua?clean=25h")
