-- 599 AREA V9 PREVIEW LOADER
local function run(url,label)
    local ok,src=pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then
        warn("[599 V9 PREVIEW] "..label.." HTTP ERROR: "..tostring(src))
        return false
    end
    local fn,err=loadstring(src)
    if not fn then
        warn("[599 V9 PREVIEW] "..label.." COMPILE ERROR: "..tostring(err))
        return false
    end
    local rok,re=xpcall(fn,function(e) return tostring(e) end)
    if not rok then
        warn("[599 V9 PREVIEW] "..label.." RUNTIME ERROR: "..tostring(re))
        return false
    end
    return true
end

if not run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Client.lua?v=3","CLIENT") then
    return
end

task.wait(0.15)
run("https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/Enhancer.lua?v=1","ENHANCER")
