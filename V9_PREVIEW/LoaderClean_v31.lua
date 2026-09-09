-- 599 AREA V9 PREVIEW CLEAN LOADER v31
-- V30 preserved. ONLY removes leftover base placeholders causing title overlap.
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
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Client_v7.lua?clean=31a")
task.wait(.12)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/IconPatch_v9.lua?clean=31b")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeIconFix_v12.lua?clean=31c")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/BannerRoblox_v14.lua?clean=31d")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Logo599Dollar_v22.lua?clean=31e")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/MinimizeDock_v23.lua?clean=31f")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/MainPatch_v24.lua?clean=31g")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/VisualsTab_v25.lua?clean=31h")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/PlayerTab_v26.lua?clean=31i")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/PlayerTrackerBridge_v26.lua?clean=31j")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/WorldTab_v27.lua?clean=31k")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/AnimeDicePatch_v28.lua?clean=31l")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/SettingsTab_v29.lua?clean=31m")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/FreecamMain_v30.lua?clean=31n")
task.wait(.08)
-- ONLY new change in v31: remove old placeholder UI underneath migrated pages.
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/PageOverlapFix_v31.lua?clean=31o")