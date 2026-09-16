-- 599 AREA V42
-- Final Game Hub release loader.
-- V41 remains untouched for rollback.

local BASE = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/"

local function run(path)
    local src = game:HttpGet(BASE .. path .. "?v=20260916_1622")
    local fn, err = loadstring(src)
    if not fn then
        error("[599 AREA V42] "..path.." compile error: "..tostring(err))
    end
    return fn()
end

-- Existing stable 599 AREA stack.
run("LoaderClean_v41.lua")

-- Final Game Hub integration.
task.wait()
run("GameHub_v42.lua")
