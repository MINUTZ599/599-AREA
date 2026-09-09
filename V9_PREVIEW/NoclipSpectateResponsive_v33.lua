-- 599 AREA V9 PREVIEW v33
-- FIX ONLY: responsive Noclip [N] + Spectate [V].
-- Uses high-priority ContextActionService so keybinds react immediately.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local CAS=game:GetService("ContextActionService")
local UIS=game:GetService("UserInputService")

local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

local NOCLIP_ACTION="AREA599_V33_NOCLIP"
local SPECTATE_ACTION="AREA599_V33_SPECTATE"
local noclip=false
local spectating=false
local original={}
local noclipConn=nil

local function char()
    return lp.Character
end

local function snapshot()
    table.clear(original)
    local ch=char()
    if not ch then return end
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("BasePart") then
            original[d]=d.CanCollide
        end
    end
end

local function restore()
    if noclipConn then noclipConn:Disconnect();noclipConn=nil end
    for part,value in pairs(original) do
        if part and part.Parent then
            part.CanCollide=value
        end
    end
    table.clear(original)
end

local function startNoclip()
    restore()
    snapshot()
    noclip=true
    noclipConn=RunService.Stepped:Connect(function()
        if not noclip then return end
        local ch=char()
        if not ch then return end
        for _,d in ipairs(ch:GetDescendants()) do
            if d:IsA("BasePart") then
                if original[d]==nil then original[d]=d.CanCollide end
                d.CanCollide=false
            end
        end
    end)
end

local function stopNoclip()
    noclip=false
    restore()
    -- one extra restore on next physics step in case the older handler ran too
    task.defer(function()
        RunService.Stepped:Wait()
        for part,value in pairs(original) do
            if part and part.Parent then part.CanCollide=value end
        end
    end)
end

local function localHumanoid()
    local ch=char()
    return ch and ch:FindFirstChildOfClass("Humanoid")
end

local function stopSpectate()
    spectating=false
    local cam=workspace.CurrentCamera
    local hum=localHumanoid()
    if cam and hum then
        cam.CameraType=Enum.CameraType.Custom
        cam.CameraSubject=hum
    end
end

local function startSpectate()
    local target=_G.AREA599_SELECTED_PLAYER
    local ch=target and target.Character
    local hum=ch and ch:FindFirstChildOfClass("Humanoid")
    local cam=workspace.CurrentCamera
    if not cam or not hum then return end
    cam.CameraType=Enum.CameraType.Custom
    cam.CameraSubject=hum
    spectating=true
end

local function noclipAction(_,inputState)
    if inputState~=Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end
    if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
    if noclip then stopNoclip() else startNoclip() end
    return Enum.ContextActionResult.Sink
end

local function spectateAction(_,inputState)
    if inputState~=Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end
    if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
    if spectating then stopSpectate() else startSpectate() end
    return Enum.ContextActionResult.Sink
end

CAS:UnbindAction(NOCLIP_ACTION)
CAS:UnbindAction(SPECTATE_ACTION)
CAS:BindActionAtPriority(NOCLIP_ACTION,noclipAction,false,Enum.ContextActionPriority.High.Value+1000,Enum.KeyCode.N)
CAS:BindActionAtPriority(SPECTATE_ACTION,spectateAction,false,Enum.ContextActionPriority.High.Value+1000,Enum.KeyCode.V)

lp.CharacterAdded:Connect(function()
    noclip=false
    spectating=false
    if noclipConn then noclipConn:Disconnect();noclipConn=nil end
    table.clear(original)
end)

Players.PlayerRemoving:Connect(function(p)
    if spectating and p==_G.AREA599_SELECTED_PLAYER then stopSpectate() end
end)

print("[599 V33] responsive Noclip [N] + Spectate [V] loaded")