-- 599 AREA V9 PREVIEW CLEAN LOADER v41
-- V40 preserved. ONLY fixes startup black/empty delay by assembling UI hidden, then revealing when ready.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")

for _,name in ipairs({"AREA599_V9_PREVIEW","AREA599_V9_DIAGNOSTIC","AREA599_V25_VISUAL_OVERLAY"}) do
    local old=pg:FindFirstChild(name)
    if old then old:Destroy() end
end

task.wait(.05)

local function run(url)
    local src=game:HttpGet(url)
    local fn,err=loadstring(src)
    if not fn then error(err) end
    return fn()
end

-- Build BASE with HOME as the true initial page.
do
    local url="https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Client_v7.lua?clean=41a"
    local src=game:HttpGet(url)
    local patched,count=src:gsub('selectPage%(%"ANIME DICE%"%)','selectPage("HOME")',1)
    if count~=1 then error("[599 V41] startup HOME patch failed") end
    local fn,err=loadstring(patched)
    if not fn then error(err) end
    fn()
end

-- Hide only the main panel while the remaining approved patches are assembled.
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
local root=gui and gui:FindFirstChild("Root",true)
if root then root.Visible=false end

-- V40 approved stack, unchanged.
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/IconPatch_v9.lua?clean=41b")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeIconFix_v12.lua?clean=41c")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/BannerRoblox_v14.lua?clean=41d")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Logo599Dollar_v22.lua?clean=41e")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/MinimizeDock_v23.lua?clean=41f")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/MainPatch_v24.lua?clean=41g")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/VisualsTab_v25.lua?clean=41h")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/PlayerTab_v26.lua?clean=41i")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/PlayerTrackerBridge_v26.lua?clean=41j")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/WorldTab_v27.lua?clean=41k")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/AnimeDicePatch_v28.lua?clean=41l")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/SettingsTab_v29.lua?clean=41m")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/FreecamMain_v30.lua?clean=41n")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/PageOverlapFix_v31.lua?clean=41o")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/NoclipSpectateResponsive_v33.lua?clean=41p")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeDashboard_v34.lua?clean=41q")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeBannerRoblox_v36.lua?clean=41r")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeBannerFull_v37.lua?clean=41s")
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/HomeBannerFill_v38.lua?clean=41t")

-- Reveal only after HOME and every approved feature/UI patch is ready.
if root and root.Parent then
    root.Visible=true
end

print("[599 V41] startup ready - HOME revealed fully assembled")