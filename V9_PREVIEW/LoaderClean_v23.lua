-- 599 AREA V9 PREVIEW CLEAN LOADER v23
-- V22 base preserved. ONLY adds Mini Control Dock minimize UI.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
for _,name in ipairs({"AREA599_V9_PREVIEW","AREA599_V9_DIAGNOSTIC"}) do
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
-- Approved V22 base, unchanged.
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Client_v7.lua?clean=23a")
task.wait(.12)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/IconPatch_v9.lua?clean=23b")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeIconFix_v12.lua?clean=23c")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/BannerRoblox_v14.lua?clean=23d")
task.wait(.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Logo599Dollar_v22.lua?clean=23e")
task.wait(.08)
-- ONLY new change: Mini Control Dock minimize style.
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/MinimizeDock_v23.lua?clean=23f")
