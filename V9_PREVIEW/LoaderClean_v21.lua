-- 599 AREA V9 PREVIEW CLEAN LOADER v21
-- Fresh filename to bypass executor/raw cache from v19/v20.
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- Hard clean previous preview instances first.
for _,name in ipairs({"AREA599_V9_PREVIEW","AREA599_V9_DIAGNOSTIC"}) do
    local old = pg:FindFirstChild(name)
    if old then old:Destroy() end
end

task.wait(0.1)

local function run(url)
    local src = game:HttpGet(url)
    local fn,err = loadstring(src)
    if not fn then error(err) end
    return fn()
end

-- Base UI only: no widescreen patch.
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Client_v7.lua?clean=21a")
task.wait(0.12)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/IconPatch_v9.lua?clean=21b")
task.wait(0.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeIconFix_v12.lua?clean=21c")
task.wait(0.08)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/BannerRoblox_v14.lua?clean=21d")
