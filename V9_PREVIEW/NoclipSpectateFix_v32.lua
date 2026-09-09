-- 599 AREA V9 PREVIEW v32
-- FIX ONLY: Noclip N restore + Spectate V keybind.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")

local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end

--========================================================
-- NOCLIP [N] RESTORE FIX
-- MainPatch_v24 turns CanCollide off on N but did not restore it on second N.
-- We keep a shadow snapshot and restore it when N toggles OFF.
--========================================================
local noclipActive=false
local collisionSnapshot={}

local function snapshotCharacter()
    table.clear(collisionSnapshot)
    local ch=lp.Character
    if not ch then return end
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("BasePart") then
            collisionSnapshot[d]=d.CanCollide
        end
    end
end

local function restoreCharacterCollision()
    for part,canCollide in pairs(collisionSnapshot) do
        if part and part.Parent then
            part.CanCollide=canCollide
        end
    end
end

snapshotCharacter()
lp.CharacterAdded:Connect(function()
    noclipActive=false
    task.wait(.35)
    snapshotCharacter()
end)

--========================================================
-- SPECTATE [V]
-- V toggles spectate for the target selected in PLAYER.
--========================================================
local spectating=false

local function localHumanoid()
    local ch=lp.Character
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
    if not hum or not cam then return false end
    cam.CameraType=Enum.CameraType.Custom
    cam.CameraSubject=hum
    spectating=true
    return true
end

UIS.InputBegan:Connect(function(input,gp)
    if gp or UIS:GetFocusedTextBox() then return end

    if input.KeyCode==Enum.KeyCode.N then
        -- Original MainPatch handler also receives N.
        -- Defer our restore so it runs after the old handler has switched state OFF.
        noclipActive=not noclipActive
        if noclipActive then
            snapshotCharacter()
        else
            task.defer(restoreCharacterCollision)
        end

    elseif input.KeyCode==Enum.KeyCode.V then
        if spectating then
            stopSpectate()
        else
            startSpectate()
        end
    end
end)

-- If target disappears while our V-spectate is active, safely return camera.
Players.PlayerRemoving:Connect(function(p)
    if spectating and p==_G.AREA599_SELECTED_PLAYER then
        stopSpectate()
    end
end)

print("[599 V32] Noclip restore + Spectate [V] fixed")