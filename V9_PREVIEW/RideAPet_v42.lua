--============================================================
-- 599 AREA - RIDE A PET STANDALONE TEST BUILD
-- Auto Pickup V4 Baseplate Continuous + Egg ESP V5.4 FINAL
--
-- IMPORTANT:
-- 599 AREA MAIN HUB IS NOT MODIFIED BY THIS FILE.
-- Auto Pickup logic is kept from the working final file.
-- ESP V5.4 settings/logic are kept from the locked final file.
--============================================================

warn("[599 TEST] Loading Ride a Pet standalone test...")

--========================================================

-- RIDE A PET - AUTO PICKUP V4 WALKBACK

--

-- ✓ Real Rarity Filter

-- ✓ TP ke selected egg

-- ✓ Auto Pickup

-- ✓ Setelah pickup: WALK kembali ke base

-- ✗ Tidak TP instan kembali ke base

--========================================================

local Players = game:GetService("Players")

local RS = game:GetService("ReplicatedStorage")

local WS = game:GetService("Workspace")

local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

local RenderedEggs = WS:WaitForChild("RenderedEggs")

local Plots = WS:WaitForChild("Plots")

--========================================================

-- LOAD EGG DATA

--========================================================

local EggModule = RS

    :WaitForChild("GameData")

    :WaitForChild("Eggs")

local ok, EggData = pcall(require, EggModule)

if not ok or typeof(EggData) ~= "table" then

    warn("[V4 WALKBACK] Failed loading GameData.Eggs")

    return

end

print("[V4 WALKBACK] EggData loaded")

--========================================================

-- SETTINGS

--========================================================

local AUTO = false

local BUSY = false

local WALKING_HOME = false

-- Return-cycle state (must be initialized before any += operation)
local RETURN_CYCLE_ID = 0
local RETURN_COMPLETE = false

-- Baseplate finish trigger state
local ACTIVE_RETURN_POSITION = nil
local ACTIVE_RETURN_INDEX = nil
local BASEPLATE_STOP_BUSY = false

local EGG_OFFSET = Vector3.new(0, 3, 0)

local PICKUP_TIMEOUT = 2

local NEXT_DELAY = 0.20

local FAIL_DELAY = 0.50

local WALK_TIMEOUT = 45


local RETURN_POSITIONS = {
    Vector3.new(180.138336, 40854.324219, -3287.538574), -- #1
    Vector3.new(-3400.578369, 40264.253906, -1272.210938), -- #2
    Vector3.new(3269.072510, 40417.558594, 4224.917969), -- #3
}

--========================================================

-- CHARACTER

--========================================================

local function getCharacter()

    local character =

        LP.Character or LP.CharacterAdded:Wait()

    local root =

        character:WaitForChild("HumanoidRootPart")

    local humanoid =

        character:FindFirstChildOfClass("Humanoid")

    if not humanoid then

        humanoid =

            character:WaitForChild("Humanoid")

    end

    return character, root, humanoid

end

--========================================================

-- BUILD RARITY LIST

--========================================================

local raritySet = {}

for _, data in pairs(EggData) do

    if typeof(data) == "table"

        and typeof(data.Rarity) == "string"

    then

        raritySet[data.Rarity] = true

    end

end

local Rarities = {}

for rarity in pairs(raritySet) do

    table.insert(Rarities, rarity)

end

table.sort(Rarities)

local EnabledRarities = {}

for _, rarity in ipairs(Rarities) do

    EnabledRarities[rarity] = false

end

print("")

print("========== RARITIES ==========")

for _, rarity in ipairs(Rarities) do

    print(rarity)

end

print("==============================")

--========================================================

-- GET RARITY

--========================================================

local function getRarity(egg)

    local data = EggData[egg.Name]

    if typeof(data) ~= "table" then

        return nil

    end

    return data.Rarity

end

--========================================================

-- FIND OWN BASE

--========================================================

local function getMyBase()

    for _, plot in ipairs(Plots:GetChildren()) do

        local owner =

            plot:GetAttribute("NestsOwnerLoaded")

        if owner == LP.UserId then

            local baseplate =

                plot:FindFirstChild("Baseplate")

            if baseplate

                and baseplate:IsA("BasePart")

            then

                return baseplate

            end

        end

    end

    return nil

end

--========================================================

-- WALK BACK TO BASE

--========================================================

local function getNearestReturnPosition(currentPosition)
    local nearestPosition = nil
    local nearestIndex = nil
    local nearestDistance = math.huge

    for index, position in ipairs(RETURN_POSITIONS) do
        local distance = (currentPosition - position).Magnitude

        if distance < nearestDistance then
            nearestDistance = distance
            nearestPosition = position
            nearestIndex = index
        end
    end

    return nearestPosition, nearestIndex, nearestDistance
end

local function stopCharacter(root, humanoid)
    if not root or not root.Parent or not humanoid or not humanoid.Parent then
        return
    end

    humanoid:MoveTo(root.Position)
    humanoid:Move(Vector3.zero, false)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

--========================================================
-- BASEPLATE FINISH TRIGGER
--========================================================

local CACHED_MY_BASEPLATE = nil

local function findBaseplate()
    if CACHED_MY_BASEPLATE and CACHED_MY_BASEPLATE.Parent then
        return CACHED_MY_BASEPLATE
    end

    -- ONLY the local player's own Baseplate can finish the return.
    CACHED_MY_BASEPLATE = getMyBase()
    return CACHED_MY_BASEPLATE
end

local function rootInsideBaseplateXZ(root, baseplate)
    local localPos =
        baseplate.CFrame:PointToObjectSpace(root.Position)

    local half = baseplate.Size / 2

    -- Small margin makes edge detection safer.
    local margin = 6

    return math.abs(localPos.X) <= half.X + margin
        and math.abs(localPos.Z) <= half.Z + margin
end

local function forceStopOnBaseplate()
    if BASEPLATE_STOP_BUSY then
        return
    end

    BASEPLATE_STOP_BUSY = true

    local _, root, humanoid = getCharacter()
    local finishedIndex = ACTIVE_RETURN_INDEX

    -- Invalidate every active/stale return loop first.
    -- Finish this return only; AUTO intentionally stays ON.
    RETURN_COMPLETE = true
    RETURN_CYCLE_ID += 1
    WALKING_HOME = false

    ACTIVE_RETURN_POSITION = nil
    ACTIVE_RETURN_INDEX = nil

    -- Kill any old MoveTo/momentum for multiple frames.
    for _ = 1, 20 do
        if root.Parent and humanoid.Parent then
            stopCharacter(root, humanoid)
        end
        RunService.Heartbeat:Wait()
    end

    if autoButton then
        autoButton.Text = "AUTO PICKUP : ON"
    end

    if status then
        status.Text = "✓ Baseplate reached / AUTO waiting next egg"
    end

    print("")
    print("==============================")
    print("[RETURN] BASEPLATE TRIGGERED")
    print("[RETURN] RETURN #" .. tostring(finishedIndex))
    print("[RETURN] AUTO PICKUP STAYS ON")
    print("[RETURN] CHARACTER STOPPED / WAITING NEXT EGG")
    print("==============================")

    BASEPLATE_STOP_BUSY = false
end

-- Independent watcher: Baseplate itself is the finish zone.
RunService.Heartbeat:Connect(function()
    if not WALKING_HOME
        or RETURN_COMPLETE
        or BASEPLATE_STOP_BUSY
    then
        return
    end

    local character = LP.Character
    local root =
        character
        and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local baseplate = findBaseplate()
    if not baseplate then
        return
    end

    if rootInsideBaseplateXZ(root, baseplate) then
        task.spawn(forceStopOnBaseplate)
    end
end)

local function walkToBase()
    if WALKING_HOME then
        return false
    end

    WALKING_HOME = true
    RETURN_COMPLETE = false

    RETURN_CYCLE_ID += 1
    local myCycle = RETURN_CYCLE_ID

    local _, root, humanoid = getCharacter()

    local destination, destinationIndex, initialDistance =
        getNearestReturnPosition(root.Position)

    if not destination then
        warn("[RETURN] No return positions")
        WALKING_HOME = false
        ACTIVE_RETURN_POSITION = nil
        ACTIVE_RETURN_INDEX = nil
        return false
    end

    ACTIVE_RETURN_POSITION = destination
    ACTIVE_RETURN_INDEX = destinationIndex

    print("")
    print("==============================")
    print("[RETURN] New cycle #" .. tostring(myCycle))
    print("[RETURN] Nearest position #" .. tostring(destinationIndex))
    print("[DESTINATION]", destination)
    print(
        "[DISTANCE]",
        math.floor(initialDistance * 10) / 10,
        "studs"
    )
    print("==============================")

    local started = os.clock()
    local lastMove = 0

    while os.clock() - started < WALK_TIMEOUT do
        -- The cycle is no longer current: never issue movement again.
        if myCycle ~= RETURN_CYCLE_ID then
            stopCharacter(root, humanoid)
            return RETURN_COMPLETE
        end

        if RETURN_COMPLETE then
            stopCharacter(root, humanoid)
            return true
        end

        if not AUTO then
            stopCharacter(root, humanoid)
            WALKING_HOME = false
            return false
        end

        if not root.Parent or humanoid.Health <= 0 then
            WALKING_HOME = false
            return false
        end

                if os.clock() - lastMove >= 0.75 then
            -- Re-check cycle immediately before MoveTo.
            if myCycle ~= RETURN_CYCLE_ID or RETURN_COMPLETE then
                stopCharacter(root, humanoid)
                return RETURN_COMPLETE
            end

            humanoid:MoveTo(destination)
            lastMove = os.clock()
        end

        task.wait(0.05)
    end

    -- Timeout invalidates this cycle too.
    if myCycle == RETURN_CYCLE_ID then
        RETURN_CYCLE_ID += 1
    end

    stopCharacter(root, humanoid)
    WALKING_HOME = false
    warn("[RETURN] Walk timeout")
    return false
end

--========================================================

-- GET EGG POSITION

--========================================================

local function getEggPosition(egg, prompt)

    if prompt.Parent

        and prompt.Parent:IsA("BasePart")

    then

        return prompt.Parent.Position

    end

    if egg:IsA("Model") then

        return egg:GetPivot().Position

    end

    local part =

        egg:FindFirstChildWhichIsA(

            "BasePart",

            true

        )

    return part and part.Position

end

--========================================================

-- GET SELECTED TARGETS

--========================================================

local function getTargets()

    local targets = {}

    for _, egg in ipairs(

        RenderedEggs:GetChildren()

    ) do

        if egg:IsA("Model") then

            local rarity =

                getRarity(egg)

            if rarity

                and EnabledRarities[rarity]

            then

                local prompt =

                    egg:FindFirstChild(

                        "Pickup",

                        true

                    )

                if prompt

                    and prompt:IsA("ProximityPrompt")

                    and prompt.Enabled

                then

                    local position =

                        getEggPosition(

                            egg,

                            prompt

                        )

                    if position then

                        table.insert(

                            targets,

                            {

                                Egg = egg,

                                Prompt = prompt,

                                Position = position,

                                Rarity = rarity

                            }

                        )

                    end

                end

            end

        end

    end

    return targets

end

--========================================================

-- PICKUP

-- V4 MECHANISM

--========================================================

local function pickupEgg(target)

    -- New egg = new return cycle; no manual OFF/ON required.
    RETURN_COMPLETE = false
    ACTIVE_RETURN_POSITION = nil
    ACTIVE_RETURN_INDEX = nil


    if not AUTO then

        return false

    end

    if not target.Egg.Parent then

        return false

    end

    if not target.Prompt.Parent then

        return false

    end

    local _, root =

        getCharacter()

    print("")

    print("====================================")

    print("[TARGET]", target.Egg.Name)

    print("[RARITY]", target.Rarity)

    --====================================================

    -- V4: TELEPORT TO EGG

    --====================================================

    root.CFrame =

        CFrame.new(

            target.Position + EGG_OFFSET

        )

    task.wait(0.15)

    if not AUTO then

        return false

    end

    if not target.Prompt.Parent then

        return false

    end

    --====================================================

    -- PICKUP

    --====================================================

    if not fireproximityprompt then

        warn(

            "[PICKUP] fireproximityprompt unavailable"

        )

        AUTO = false

        return false

    end

    print("[ACTION] Trigger Pickup")

    fireproximityprompt(

        target.Prompt

    )

    --====================================================

    -- WAIT FOR SUCCESS

    --====================================================

    local started = os.clock()

    while

        AUTO

        and os.clock() - started

            < PICKUP_TIMEOUT

    do

        if not target.Egg.Parent then

            print(

                "[SUCCESS]",

                target.Egg.Name,

                "(" .. target.Rarity .. ")"

            )

            --============================================

            -- NEW:

            -- WALK HOME INSTEAD OF TELEPORTING HOME

            --============================================

            task.wait(0.10)

            local arrived =

                walkToBase()

            if arrived then

                print(

                    "[READY]",

                    "At saved position"

                )

            end

            return true

        end

        task.wait(0.05)

    end

    warn(

        "[FAILED]",

        target.Egg.Name

    )

    return false

end

--========================================================

-- REMOVE OLD GUI

--========================================================

local GUI_NAME =

    "RideAPet_V4_WalkBack"

local old =

    LP.PlayerGui:FindFirstChild(

        GUI_NAME

    )

if old then

    old:Destroy()

end

--========================================================

-- GUI

--========================================================

local gui =

    Instance.new("ScreenGui")

gui.Name = GUI_NAME

gui.ResetOnSpawn = false

gui.Parent = LP.PlayerGui

-- Unified GUI owns the visible controls
gui.Enabled = false

local frame =

    Instance.new("Frame")

frame.Size =

    UDim2.fromOffset(

        330,

        450

    )

frame.Position =

    UDim2.new(

        0.5,

        -165,

        0.5,

        -225

    )

frame.BackgroundColor3 =

    Color3.fromRGB(

        18,

        18,

        23

    )

frame.Active = true

frame.Draggable = true

frame.Parent = gui

--========================================================

-- TITLE

--========================================================

local title =

    Instance.new("TextLabel")

title.Size =

    UDim2.new(

        1,

        0,

        0,

        40

    )

title.BackgroundTransparency = 1

title.Text =

    "RIDE A PET - V4 BASEPLATE ONLY CONTINUOUS"

title.TextColor3 =

    Color3.new(1,1,1)

title.TextSize = 16

title.Parent = frame

--========================================================

-- STATUS

--========================================================

local status =

    Instance.new("TextLabel")

status.Position =

    UDim2.fromOffset(

        10,

        40

    )

status.Size =

    UDim2.new(

        1,

        -20,

        0,

        50

    )

status.BackgroundTransparency = 1

status.Text =

    "Select rarity then enable Auto Pickup"

status.TextWrapped = true

status.TextColor3 =

    Color3.fromRGB(

        210,

        210,

        210

    )

status.Parent = frame

--========================================================

-- AUTO BUTTON

--========================================================

local autoButton =

    Instance.new("TextButton")

autoButton.Position =

    UDim2.fromOffset(

        20,

        95

    )

autoButton.Size =

    UDim2.fromOffset(

        290,

        42

    )

autoButton.Text =

    "AUTO PICKUP : OFF"

autoButton.Parent = frame
autoButton.MouseButton1Click:Connect(

    function()

        AUTO = not AUTO

        if AUTO then
            -- Fresh user-requested pickup cycle.
            RETURN_COMPLETE = false
            ACTIVE_RETURN_POSITION = nil
            ACTIVE_RETURN_INDEX = nil
            RETURN_CYCLE_ID += 1

            autoButton.Text =

                "AUTO PICKUP : ON"

            status.Text =

                "Scanning selected rarities..."

        else

            autoButton.Text =

                "AUTO PICKUP : OFF"

            status.Text =

                "Stopped"

            -- Manual OFF cancels any active return.
            RETURN_COMPLETE = true
            RETURN_CYCLE_ID += 1
            WALKING_HOME = false
            ACTIVE_RETURN_POSITION = nil
            ACTIVE_RETURN_INDEX = nil

            local _, root, humanoid = getCharacter()
            stopCharacter(root, humanoid)

        end

    end

)

--========================================================

-- WALK HOME TEST BUTTON

--========================================================

local homeButton =

    Instance.new("TextButton")

homeButton.Position =

    UDim2.fromOffset(

        20,

        145

    )

homeButton.Size =

    UDim2.fromOffset(

        290,

        35

    )

homeButton.Text =

    "WALK TO NEAREST POSITION"

homeButton.Parent = frame

homeButton.MouseButton1Click:Connect(

    function()

        if WALKING_HOME then

            return

        end

        task.spawn(function()

            -- Manual test starts one clean return cycle.
            AUTO = true
            RETURN_COMPLETE = false

            status.Text =
                "Walking to nearest position..."

            local success =
                walkToBase()

            if success then

                status.Text =

                    "✓ Arrived at nearest position"

            else

                status.Text =

                    "✗ Could not reach base"

            end

        end)

    end

)

--========================================================

-- RARITY LIST

--========================================================

local scroll =

    Instance.new("ScrollingFrame")

scroll.Position =

    UDim2.fromOffset(

        20,

        195

    )

scroll.Size =

    UDim2.fromOffset(

        290,

        230

    )

scroll.BackgroundTransparency = 0.5

scroll.ScrollBarThickness = 5

scroll.AutomaticCanvasSize =

    Enum.AutomaticSize.Y

scroll.CanvasSize =

    UDim2.new()

scroll.Parent = frame

local layout =

    Instance.new("UIListLayout")

layout.Padding =

    UDim.new(

        0,

        5

    )

layout.Parent = scroll

--========================================================

-- RARITY CHECKBOXES

--========================================================

for _, rarity in ipairs(Rarities) do

    local button =

        Instance.new("TextButton")

    button.Size =

        UDim2.new(

            1,

            -8,

            0,

            34

        )

    button.Text =

        "[ ] " .. rarity

    button.Parent = scroll

    button.MouseButton1Click:Connect(

        function()

            EnabledRarities[rarity] =

                not EnabledRarities[rarity]

            if EnabledRarities[rarity] then

                button.Text =

                    "[✓] " .. rarity

            else

                button.Text =

                    "[ ] " .. rarity

            end

        end

    )

end

--========================================================

-- MAIN LOOP

--========================================================

task.spawn(function()

    while task.wait(0.1) do

        if AUTO

            and not BUSY

            and not WALKING_HOME

        then

            BUSY = true

            local targets =

                getTargets()

            status.Text =

                "Matching eggs: "

                .. tostring(#targets)

            if #targets > 0 then

                local _, root =

                    getCharacter()

                -- Nearest selected egg first.

                table.sort(

                    targets,

                    function(a, b)

                        local da =

                            (

                                a.Position

                                - root.Position

                            ).Magnitude

                        local db =

                            (

                                b.Position

                                - root.Position

                            ).Magnitude

                        return da < db

                    end

                )

                local target =

                    targets[1]

                status.Text =

                    "Picking "

                    .. target.Egg.Name

                    .. " | "

                    .. target.Rarity

                local worked =

                    pickupEgg(target)

                if worked then

                    status.Text =

                        "✓ Pickup complete / returned"

                    task.wait(

                        NEXT_DELAY

                    )

                else

                    status.Text =

                        "✗ Failed: "

                        .. target.Egg.Name

                    task.wait(

                        FAIL_DELAY

                    )

                end

            else

                status.Text =

                    "No matching eggs"

                task.wait(0.4)

            end

            BUSY = false

        end

    end

end)

print("")

print("========================================")

print(" RIDE A PET V4 BASEPLATE ONLY CONTINUOUS LOADED")

print("========================================")

print("✓ Real rarity filter")

print("✓ V4 TP-to-egg")

print("✓ V4 pickup")

print("✓ WALK to nearest of 3 return positions")

print("✗ No instant TP back to base")

print("✓ 599 AREA untouched")

print("========================================")

--============================================================

--============================================================
-- 599 AREA - RIDE A PET / V4 REFERENCE GUI
-- GUI rebuilt to closely match the approved mockup.
-- Auto Pickup + ESP behavior below remains the existing working logic.
--============================================================
local oldUnified = LP.PlayerGui:FindFirstChild("599_RIDE_A_PET_UNIFIED_TEST")
if oldUnified then oldUnified:Destroy() end

local UnifiedGui=Instance.new("ScreenGui")
UnifiedGui.Name="599_RIDE_A_PET_UNIFIED_TEST"
UnifiedGui.ResetOnSpawn=false
UnifiedGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
UnifiedGui.Parent=LP.PlayerGui

local Main=Instance.new("Frame")
Main.Size=UDim2.fromOffset(610,470)
Main.Position=UDim2.new(.5,-305,.5,-235)
Main.BackgroundColor3=Color3.fromRGB(8,8,15)
Main.BackgroundTransparency=.04
Main.BorderSizePixel=0
Main.Parent=UnifiedGui
local mc=Instance.new("UICorner"); mc.CornerRadius=UDim.new(0,18); mc.Parent=Main
local ms=Instance.new("UIStroke"); ms.Color=Color3.fromRGB(174,55,255); ms.Thickness=1.6; ms.Transparency=.05; ms.Parent=Main

local Header=Instance.new("Frame")
Header.Size=UDim2.new(1,0,0,72)
Header.BackgroundColor3=Color3.fromRGB(12,11,22)
Header.BackgroundTransparency=.05
Header.BorderSizePixel=0
Header.Parent=Main
local hc=Instance.new("UICorner"); hc.CornerRadius=UDim.new(0,18); hc.Parent=Header

local Logo=Instance.new("ImageLabel")
Logo.BackgroundTransparency=1; Logo.Position=UDim2.fromOffset(20,12); Logo.Size=UDim2.fromOffset(45,45)
Logo.Image="rbxassetid://126889401822389"
Logo.ScaleType=Enum.ScaleType.Fit
Logo.Parent=Header

local Title=Instance.new("TextLabel")
Title.BackgroundTransparency=1; Title.Position=UDim2.fromOffset(75,12); Title.Size=UDim2.fromOffset(390,25)
Title.Font=Enum.Font.GothamBold; Title.Text="599 AREA — RIDE A PET"; Title.TextSize=18
Title.TextColor3=Color3.fromRGB(247,246,252); Title.TextXAlignment=Enum.TextXAlignment.Left; Title.Parent=Header

local Sub=Instance.new("TextLabel")
Sub.BackgroundTransparency=1; Sub.Position=UDim2.fromOffset(75,38); Sub.Size=UDim2.fromOffset(300,18)
Sub.Font=Enum.Font.Gotham; Sub.Text="V4  |  Standalone Build"; Sub.TextSize=11
Sub.TextColor3=Color3.fromRGB(161,132,188); Sub.TextXAlignment=Enum.TextXAlignment.Left; Sub.Parent=Header

local Min=Instance.new("TextButton")
Min.Position=UDim2.new(1,-82,0,17); Min.Size=UDim2.fromOffset(28,28)
Min.BackgroundTransparency=1; Min.Text="—"; Min.Font=Enum.Font.GothamBold; Min.TextSize=18
Min.TextColor3=Color3.fromRGB(194,121,255); Min.Parent=Header

local Close=Instance.new("TextButton")
Close.Position=UDim2.new(1,-45,0,17); Close.Size=UDim2.fromOffset(28,28)
Close.BackgroundTransparency=1; Close.Text="×"; Close.Font=Enum.Font.GothamBold; Close.TextSize=25
Close.TextColor3=Color3.fromRGB(194,121,255); Close.Parent=Header
Close.MouseButton1Click:Connect(function() UnifiedGui.Enabled=false end)

local body=Instance.new("Frame")
body.Position=UDim2.fromOffset(12,80); body.Size=UDim2.new(1,-24,1,-92)
body.BackgroundTransparency=1; body.Parent=Main

local Side=Instance.new("Frame")
Side.Size=UDim2.fromOffset(145,366); Side.BackgroundColor3=Color3.fromRGB(11,11,20)
Side.BackgroundTransparency=.08; Side.BorderSizePixel=0; Side.Parent=body
local sc=Instance.new("UICorner"); sc.CornerRadius=UDim.new(0,15); sc.Parent=Side
local ss=Instance.new("UIStroke"); ss.Color=Color3.fromRGB(74,43,104); ss.Transparency=.45; ss.Parent=Side

local Content=Instance.new("Frame")
Content.Position=UDim2.fromOffset(157,0); Content.Size=UDim2.new(1,-157,1,0)
Content.BackgroundColor3=Color3.fromRGB(10,10,18); Content.BackgroundTransparency=.04
Content.BorderSizePixel=0; Content.Parent=body
local cc=Instance.new("UICorner"); cc.CornerRadius=UDim.new(0,15); cc.Parent=Content
local cs=Instance.new("UIStroke"); cs.Color=Color3.fromRGB(74,43,104); cs.Transparency=.45; cs.Parent=Content

local function navButton(y,icon,text,imageId)
    local b=Instance.new("TextButton")
    b.Position=UDim2.fromOffset(8,y); b.Size=UDim2.new(1,-16,0,50)
    b.BackgroundColor3=Color3.fromRGB(16,15,27); b.BorderSizePixel=0
    b.Text=""; b.Parent=Side
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,11); c.Parent=b

    if imageId then
        local img=Instance.new("ImageLabel")
        img.Position=UDim2.fromOffset(14,11); img.Size=UDim2.fromOffset(28,28)
        img.BackgroundTransparency=1
        img.Image="rbxassetid://"..tostring(imageId)
        img.ScaleType=Enum.ScaleType.Fit
        img.Parent=b
    else
        local fallback=Instance.new("TextLabel")
        fallback.Position=UDim2.fromOffset(14,0); fallback.Size=UDim2.fromOffset(28,50)
        fallback.BackgroundTransparency=1; fallback.Text=icon
        fallback.Font=Enum.Font.GothamBold; fallback.TextSize=20
        fallback.TextColor3=Color3.fromRGB(194,121,255); fallback.Parent=b
    end

    local txt=Instance.new("TextLabel")
    txt.Position=UDim2.fromOffset(53,0); txt.Size=UDim2.new(1,-60,1,0)
    txt.BackgroundTransparency=1; txt.Text=text
    txt.Font=Enum.Font.GothamSemibold; txt.TextSize=13
    txt.TextColor3=Color3.fromRGB(236,232,245)
    txt.TextXAlignment=Enum.TextXAlignment.Left; txt.Parent=b

    return b
end

-- Requested custom icons only; navigation/feature logic is unchanged.
local MainNav=navButton(12,"","Main",104857036411942)
local EspNav=navButton(70,"","Egg ESP",122991701514648)
local SettingsNav=navButton(128,"⚙","Settings")
SettingsNav.AutoButtonColor=false

local Motto=Instance.new("TextLabel")
Motto.Position=UDim2.fromOffset(16,278); Motto.Size=UDim2.new(1,-32,0,70)
Motto.BackgroundTransparency=1; Motto.Font=Enum.Font.GothamBold
Motto.Text="PLAY\nSMART\nHATCH\nFASTER"; Motto.TextSize=11
Motto.TextColor3=Color3.fromRGB(152,128,177); Motto.TextXAlignment=Enum.TextXAlignment.Left
Motto.TextYAlignment=Enum.TextYAlignment.Top; Motto.Parent=Side

local MainPage=Instance.new("Frame")
MainPage.Size=UDim2.fromScale(1,1); MainPage.BackgroundTransparency=1; MainPage.Parent=Content
local EspPage=Instance.new("Frame")
EspPage.Size=UDim2.fromScale(1,1); EspPage.BackgroundTransparency=1; EspPage.Visible=false; EspPage.Parent=Content

local function heading(parent,text)
    local l=Instance.new("TextLabel")
    l.Position=UDim2.fromOffset(18,14); l.Size=UDim2.new(1,-36,0,25)
    l.BackgroundTransparency=1; l.Font=Enum.Font.GothamBold; l.Text=text; l.TextSize=15
    l.TextColor3=Color3.fromRGB(190,57,255); l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=parent
end

local function toggleRow(parent,y,text)
    local row=Instance.new("Frame")
    row.Position=UDim2.fromOffset(16,y); row.Size=UDim2.new(1,-32,0,50)
    row.BackgroundColor3=Color3.fromRGB(19,19,30); row.BorderSizePixel=0; row.Parent=parent
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,10); c.Parent=row
    local l=Instance.new("TextLabel")
    l.Position=UDim2.fromOffset(14,0); l.Size=UDim2.new(1,-100,1,0); l.BackgroundTransparency=1
    l.Font=Enum.Font.Gotham; l.Text=text; l.TextSize=13; l.TextColor3=Color3.fromRGB(242,240,247)
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=row
    local b=Instance.new("TextButton")
    b.Position=UDim2.new(1,-76,.5,-14); b.Size=UDim2.fromOffset(62,28)
    b.BackgroundColor3=Color3.fromRGB(48,46,59); b.BorderSizePixel=0; b.Text="OFF"
    b.Font=Enum.Font.GothamBold; b.TextSize=10; b.TextColor3=Color3.new(1,1,1); b.Parent=row
    local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(1,0); bc.Parent=b
    return b
end

local function filterTitle(parent,text,y)
    local l=Instance.new("TextLabel")
    l.Position=UDim2.fromOffset(18,y); l.Size=UDim2.new(1,-36,0,22)
    l.BackgroundTransparency=1; l.Font=Enum.Font.GothamBold; l.Text=text; l.TextSize=12
    l.TextColor3=Color3.fromRGB(190,57,255); l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=parent
end

-- Exact checkbox-style rarity selector requested by user.
local function checkboxGrid(parent,y,stateTable,onChanged)
    local box=Instance.new("Frame")
    box.Position=UDim2.fromOffset(16,y); box.Size=UDim2.new(1,-32,0,218)
    box.BackgroundColor3=Color3.fromRGB(17,17,27); box.BorderSizePixel=0; box.Parent=parent
    local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(0,10); bc.Parent=box

    local leftX,rightX=14,205
    local rowY=12
    for i,rarity in ipairs(Rarities) do
        local col=((i-1)%2)
        local row=math.floor((i-1)/2)
        local x=col==0 and leftX or rightX
        local yPos=rowY+row*30

        local hit=Instance.new("TextButton")
        hit.Position=UDim2.fromOffset(x,yPos); hit.Size=UDim2.fromOffset(170,24)
        hit.BackgroundTransparency=1; hit.Text=""; hit.Parent=box

        local square=Instance.new("Frame")
        square.Position=UDim2.fromOffset(0,3); square.Size=UDim2.fromOffset(16,16)
        square.BackgroundColor3=Color3.fromRGB(31,28,42); square.BorderSizePixel=0; square.Parent=hit
        local sqc=Instance.new("UICorner"); sqc.CornerRadius=UDim.new(0,3); sqc.Parent=square
        local stroke=Instance.new("UIStroke"); stroke.Color=Color3.fromRGB(171,45,255); stroke.Thickness=1.5; stroke.Parent=square

        local check=Instance.new("TextLabel")
        check.Size=UDim2.fromScale(1,1); check.BackgroundTransparency=1; check.Font=Enum.Font.GothamBold
        check.Text="✓"; check.TextSize=13; check.TextColor3=Color3.new(1,1,1); check.Parent=square

        local name=Instance.new("TextLabel")
        name.Position=UDim2.fromOffset(24,0); name.Size=UDim2.fromOffset(142,22)
        name.BackgroundTransparency=1; name.Font=Enum.Font.Gotham; name.Text=rarity; name.TextSize=11
        name.TextColor3=Color3.fromRGB(235,232,240); name.TextXAlignment=Enum.TextXAlignment.Left; name.Parent=hit

        local function refresh()
            local on=stateTable[rarity]==true
            check.Visible=on
            square.BackgroundColor3=on and Color3.fromRGB(170,35,255) or Color3.fromRGB(31,28,42)
            stroke.Color=on and Color3.fromRGB(218,91,255) or Color3.fromRGB(112,77,140)
        end
        refresh()

        hit.MouseButton1Click:Connect(function()
            stateTable[rarity]=not stateTable[rarity]
            refresh()
            if onChanged then onChanged(rarity) end
        end)
    end
end

heading(MainPage,"AUTO PICKUP")
local AutoToggle=toggleRow(MainPage,48,"Automatic Egg Pickup")
filterTitle(MainPage,"RARITY FILTER (AUTO PICKUP)",112)
checkboxGrid(MainPage,140,EnabledRarities)

heading(EspPage,"EGG ESP V5.4")
local EspToggle=toggleRow(EspPage,48,"World Egg ESP")
filterTitle(EspPage,"RARITY FILTER (EGG ESP)",112)
local EspEnabledRarities={}

local UnifiedHiddenPointers=Instance.new("Folder")
UnifiedHiddenPointers.Name="599_ESP_HIDDEN_POINTERS"
UnifiedHiddenPointers.Parent=RS

checkboxGrid(EspPage,140,EspEnabledRarities,function()
    local espState=getgenv()._599_WORLD_ESP_V54
    local espOnNow=getgenv()._599_UNIFIED_ESP_ENABLED==true
    if espState and espState.Tracked then
        for _,data in pairs(espState.Tracked) do
            local showNow=espOnNow and (EspEnabledRarities[data.Rarity]==true)
            if data.Billboard then data.Billboard.Enabled=showNow end
            if data.Pointer then
                data.Pointer.Transparency=0.05
                data.Pointer.Parent=showNow and WS or UnifiedHiddenPointers
            end
        end
    end
end)

local Status=Instance.new("TextLabel")
Status.Position=UDim2.new(0,16,1,-30); Status.Size=UDim2.new(1,-32,0,20)
Status.BackgroundTransparency=1; Status.Font=Enum.Font.Gotham; Status.Text="STATUS: READY"; Status.TextSize=9
Status.TextColor3=Color3.fromRGB(137,126,151); Status.TextXAlignment=Enum.TextXAlignment.Left; Status.Parent=Content

local function selectPage(page)
    local main=page=="MAIN"
    MainPage.Visible=main; EspPage.Visible=not main
    MainNav.BackgroundColor3=main and Color3.fromRGB(92,27,151) or Color3.fromRGB(16,15,27)
    EspNav.BackgroundColor3=not main and Color3.fromRGB(92,27,151) or Color3.fromRGB(16,15,27)
end
MainNav.MouseButton1Click:Connect(function() selectPage("MAIN") end)
EspNav.MouseButton1Click:Connect(function() selectPage("ESP") end)
SettingsNav.MouseButton1Click:Connect(function() Status.Text="SETTINGS: COMING SOON" end)
selectPage("MAIN")

local dragging,dragStart,startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=i.Position; startPos=Main.Position
    end
end)
Header.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
game:GetService("UserInputService").InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-dragStart
        Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)

local minimized=false
Min.MouseButton1Click:Connect(function()
    minimized=not minimized
    body.Visible=not minimized

    -- ICON ONLY minimize style.
    -- Uses the same custom 599 AREA header icon requested by the user.
    if minimized then
        Main.Size=UDim2.fromOffset(72,72)
        Header.Size=UDim2.fromOffset(72,72)

        Logo.Position=UDim2.fromOffset(13,13)
        Logo.Size=UDim2.fromOffset(46,46)

        Title.Visible=false
        Sub.Visible=false
        Min.Visible=false
        Close.Visible=false
    else
        Main.Size=UDim2.fromOffset(610,470)
        Header.Size=UDim2.new(1,0,0,72)

        Logo.Position=UDim2.fromOffset(20,12)
        Logo.Size=UDim2.fromOffset(45,45)

        Title.Visible=true
        Sub.Visible=true
        Min.Visible=true
        Close.Visible=true
    end
end)

-- When minimized, clicking the icon restores the full GUI.
Logo.InputBegan:Connect(function(input)
    if minimized and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then
        minimized=false
        body.Visible=true
        Main.Size=UDim2.fromOffset(610,470)
        Header.Size=UDim2.new(1,0,0,72)

        Logo.Position=UDim2.fromOffset(20,12)
        Logo.Size=UDim2.fromOffset(45,45)

        Title.Visible=true
        Sub.Visible=true
        Min.Visible=true
        Close.Visible=true
    end
end)

AutoToggle.MouseButton1Click:Connect(function()
    AUTO=not AUTO
    AutoToggle.Text=AUTO and "ON" or "OFF"
    AutoToggle.BackgroundColor3=AUTO and Color3.fromRGB(159,37,238) or Color3.fromRGB(48,46,59)
    Status.Text=AUTO and "STATUS: AUTO PICKUP ON" or "STATUS: AUTO PICKUP OFF"
    if AUTO then
        RETURN_COMPLETE=false; ACTIVE_RETURN_POSITION=nil; ACTIVE_RETURN_INDEX=nil; RETURN_CYCLE_ID+=1
    else
        RETURN_COMPLETE=true; RETURN_CYCLE_ID+=1; WALKING_HOME=false
        ACTIVE_RETURN_POSITION=nil; ACTIVE_RETURN_INDEX=nil
        local _,root,humanoid=getCharacter(); stopCharacter(root,humanoid)
    end
end)

getgenv()._599_UNIFIED_ESP_ENABLED=false
EspToggle.MouseButton1Click:Connect(function()
    getgenv()._599_UNIFIED_ESP_ENABLED=not getgenv()._599_UNIFIED_ESP_ENABLED
    local on=getgenv()._599_UNIFIED_ESP_ENABLED
    EspToggle.Text=on and "ON" or "OFF"
    EspToggle.BackgroundColor3=on and Color3.fromRGB(159,37,238) or Color3.fromRGB(48,46,59)
    Status.Text=on and "STATUS: EGG ESP ON" or "STATUS: EGG ESP OFF"

    local espState=getgenv()._599_WORLD_ESP_V54
    if espState and espState.Tracked then
        for _,data in pairs(espState.Tracked) do
            local showThisEsp=on and (EspEnabledRarities[data.Rarity]==true)
            if data.Billboard then data.Billboard.Enabled=showThisEsp end
            if data.Pointer then
                data.Pointer.Transparency=0.05
                data.Pointer.Parent=showThisEsp and WS or UnifiedHiddenPointers
            end
        end
    end
end)

--============================================================
-- 599 TEST: EGG ESP V5.4 FINAL STARTS BELOW
--============================================================

--============================================================

-- 599 AREA - WORLD EGG ESP V5.4

-- BLACKHOLE RAINBOW EDITION

--

-- ✓ Workspace.RenderedEggs ONLY

-- ✓ Base egg ignored

-- ✓ Name + STUDS only

-- ✓ Normal eggs = rarity color

-- ✓ BLACKHOLE EGG = animated rainbow

-- ✓ Rainbow board + text + line

-- ✓ Adjustable board height

-- ✓ Adjustable line thickness

-- ✓ Fixed text size

-- ✓ Live distance

-- ✓ Auto add/remove

-- ✓ Anti duplicate

--============================================================

local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Workspace = game:GetService("Workspace")

local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

local ENV = getgenv and getgenv() or _G

--============================================================

-- CLEANUP OLD VERSIONS

--============================================================

local OLD_STATES = {

    "_599_WORLD_ESP_V3",

    "_599_WORLD_ESP_V4",

    "_599_WORLD_ESP_V5",

    "_599_WORLD_ESP_V52",

    "_599_WORLD_ESP_V53",

    "_599_WORLD_ESP_V54"

}

for _, stateName in ipairs(OLD_STATES) do

    local old = ENV[stateName]

    if old then

        if old.Connections then

            for _, con in ipairs(old.Connections) do

                pcall(function()

                    con:Disconnect()

                end)

            end

        end

        if old.Billboards then

            for _, gui in pairs(old.Billboards) do

                pcall(function()

                    gui:Destroy()

                end)

            end

        end

        if old.Pointers then

            for _, pointer in pairs(old.Pointers) do

                pcall(function()

                    pointer:Destroy()

                end)

            end

        end

        if old.Beams then

            for _, pointer in pairs(old.Beams) do

                pcall(function()

                    pointer:Destroy()

                end)

            end

        end

        ENV[stateName] = nil

    end

end

--============================================================

-- CLEAN LEFTOVER OBJECTS

--============================================================

for _, obj in ipairs(Workspace:GetDescendants()) do

    if obj:IsA("BillboardGui") then

        if string.find(

            obj.Name,

            "599_WORLD_EGG_ESP",

            1,

            true

        )

        or obj.Name == "599_EGG_ESP"

        then

            pcall(function()

                obj:Destroy()

            end)

        end

    elseif obj:IsA("BasePart")

        and obj.Name == "599_WORLD_EGG_POINTER"

    then

        pcall(function()

            obj:Destroy()

        end)

    end

end

--============================================================

-- STATE

--============================================================

local STATE = {

    Connections = {},

    Billboards = {},

    Pointers = {},

    Tracked = {}

}

ENV._599_WORLD_ESP_V54 = STATE

--============================================================

-- SETTINGS

--============================================================

local ESP_ENABLED = true

local MAX_DISTANCE = 100000

--============================================================

-- BOARD SIZE

--============================================================

local BOARD_WIDTH = 140

local BOARD_HEIGHT = 46

--============================================================

-- 🔥 KETINGGIAN BOARD

--

-- 35 = tinggi

-- 45 = lebih tinggi

-- 50 = sangat tinggi

--============================================================
local BOARD_HEIGHT_STUDS = 130

--============================================================

-- 🔥 KETEBALAN LINE

--

-- 0.22 = tipis

-- 0.45 = tebal

-- 0.70 = sangat tebal

-- 1.00 = ekstrem

--============================================================

local LINE_THICKNESS = 0.87

local LINE_TRANSPARENCY = 0.05

--============================================================

-- TEXT

--============================================================

local NAME_TEXT_SIZE = 13

local DISTANCE_TEXT_SIZE = 11

--============================================================

-- 🌈 BLACKHOLE RAINBOW SPEED

--

-- 0.08 = pelan

-- 0.12 = normal

-- 0.20 = cepat

--============================================================

local BLACKHOLE_RAINBOW_SPEED = 0.12

--============================================================

-- OPTIONAL FILTER

--

-- kosong = semua

--============================================================

local ENABLED_RARITIES = {

    -- Ethereal = true,

}

local ENABLED_EGGS = {

    -- ["Blackhole Egg"] = true,

}

--============================================================

-- NORMAL RARITY COLORS

--============================================================

local RARITY_COLORS = {

    Common =

        Color3.fromRGB(

            235,

            235,

            235

        ),

    Uncommon =

        Color3.fromRGB(

            70,

            255,

            120

        ),

    Rare =

        Color3.fromRGB(

            55,

            170,

            255

        ),

    Epic =

        Color3.fromRGB(

            190,

            65,

            255

        ),

    Legendary =

        Color3.fromRGB(

            255,

            180,

            25

        ),

    Mythic =

        Color3.fromRGB(

            255,

            45,

            145

        ),

    Ethereal =

        Color3.fromRGB(

            30,

            240,

            255

        ),

    Divine =

        Color3.fromRGB(

            255,

            80,

            35

        )

}

local DEFAULT_COLOR =

    Color3.fromRGB(

        220,

        220,

        220

    )

--============================================================

-- BLACKHOLE RAINBOW

--============================================================

local function isBlackholeEgg(name)

    return string.lower(

        tostring(name)

    ) == "blackhole egg"

end

local function getRainbowColor()

    local hue =

        (

            time()

            * BLACKHOLE_RAINBOW_SPEED

        ) % 1

    return Color3.fromHSV(

        hue,

        1,

        1

    )

end

--============================================================

-- LOAD EGG DATABASE

--============================================================

local EggData = {}

local ok, result = pcall(function()

    return require(

        ReplicatedStorage

            :WaitForChild("GameData")

            :WaitForChild("Eggs")

    )

end)

if ok and type(result) == "table" then

    EggData = result

    print(

        "[599 ESP V5.4] Egg database loaded"

    )

else

    warn(

        "[599 ESP V5.4] Egg database FAILED"

    )

end

--============================================================

-- HELPERS

--============================================================

local function addConnection(con)

    table.insert(

        STATE.Connections,

        con

    )

    return con

end

local function tableEmpty(tbl)

    return next(tbl) == nil

end

local function getRoot()

    local character =

        LP.Character

    if not character then

        return nil

    end

    return character:FindFirstChild(

        "HumanoidRootPart"

    )

end

--============================================================

-- RARITY

--============================================================

local function getRarity(eggName)

    local config =

        EggData[eggName]

    if type(config) ~= "table" then

        return "Unknown"

    end

    return tostring(

        config.Rarity

        or config.rarity

        or "Unknown"

    )

end

local function getRarityColor(rarity)

    return

        RARITY_COLORS[rarity]

        or DEFAULT_COLOR

end

--============================================================

-- FILTER

--============================================================

local function allowedEgg(

    eggName,

    rarity

)

    if not ESP_ENABLED then

        return false

    end

    if not tableEmpty(ENABLED_EGGS)

        and not ENABLED_EGGS[eggName]

    then

        return false

    end

    if not tableEmpty(ENABLED_RARITIES)

        and not ENABLED_RARITIES[rarity]

    then

        return false

    end

    return true

end

--============================================================

-- GET DISPLAY PART

--============================================================

local function getDisplayPart(egg)

    if not egg then

        return nil

    end

    local handle =

        egg:FindFirstChild(

            "Handle",

            true

        )

    if handle

        and handle:IsA("BasePart")

    then

        return handle

    end

    local eggBase =

        egg:FindFirstChild(

            "EggBase",

            true

        )

    if eggBase

        and eggBase:IsA("BasePart")

    then

        return eggBase

    end

    if egg:IsA("Model")

        and egg.PrimaryPart

    then

        return egg.PrimaryPart

    end

    return egg:FindFirstChildWhichIsA(

        "BasePart",

        true

    )

end

--============================================================

-- REMOVE ESP

--============================================================

local function removeESP(egg)

    local data =

        STATE.Tracked[egg]

    if not data then

        return

    end

    if data.Billboard then

        pcall(function()

            data.Billboard:Destroy()

        end)

    end

    if data.Pointer then

        pcall(function()

            data.Pointer:Destroy()

        end)

    end

    STATE.Billboards[egg] = nil

    STATE.Pointers[egg] = nil

    STATE.Tracked[egg] = nil

end

--============================================================

-- CREATE ESP

--============================================================

local function createESP(egg)

    if not egg

        or not egg.Parent

    then

        return

    end

    local rendered =

        Workspace:FindFirstChild(

            "RenderedEggs"

        )

    --========================================================

    -- WORLD EGG ONLY

    --========================================================

    if not rendered

        or egg.Parent ~= rendered

    then

        return

    end

    --========================================================

    -- ANTI DOUBLE

    --========================================================

    if STATE.Tracked[egg] then

        return

    end

    local eggName =

        egg.Name

    --========================================================

    -- VALID DATABASE EGG ONLY

    --========================================================

    if type(EggData[eggName])

        ~= "table"

    then

        return

    end

    local rarity =

        getRarity(

            eggName

        )

    if not allowedEgg(

        eggName,

        rarity

    ) then

        return

    end

    local rarityColor =

        getRarityColor(

            rarity

        )

    --========================================================

    -- FIND PART

    --========================================================

    local part =

        getDisplayPart(

            egg

        )

    if not part then

        task.wait(0.15)

        if not egg.Parent then

            return

        end

        part =

            getDisplayPart(

                egg

            )

    end

    if not part then

        return

    end

    --========================================================

    -- CLEAN OLD BOARD

    --========================================================

    for _, child in ipairs(

        part:GetChildren()

    ) do

        if child:IsA("BillboardGui")

            and (

                string.find(

                    child.Name,

                    "599_WORLD_EGG_ESP",

                    1,

                    true

                )

                or child.Name ==

                    "599_EGG_ESP"

            )

        then

            pcall(function()

                child:Destroy()

            end)

        end

    end

    --========================================================

    -- INITIAL COLOR

    --========================================================

    local initialColor =

        rarityColor

    if isBlackholeEgg(

        eggName

    ) then

        initialColor =

            getRainbowColor()

    end

    --========================================================

    -- VERTICAL NEON POINTER

    --========================================================

    local pointer =

        Instance.new("Part")

    pointer.Name =

        "599_WORLD_EGG_POINTER"

    pointer.Size =

        Vector3.new(

            LINE_THICKNESS,

            BOARD_HEIGHT_STUDS,

            LINE_THICKNESS

        )

    pointer.Anchored =

        true

    pointer.CanCollide =

        false

    pointer.CanTouch =

        false

    pointer.CanQuery =

        false

    pointer.CastShadow =

        false

    pointer.Material =

        Enum.Material.Neon

    pointer.Color =

        initialColor

    pointer.Transparency =

        LINE_TRANSPARENCY

    pointer.CFrame =

        CFrame.new(

            part.Position

            + Vector3.new(

                0,

                BOARD_HEIGHT_STUDS / 2,

                0

            )

        )

    pointer.Parent =

        Workspace

    --========================================================

    -- BILLBOARD

    --========================================================

    local billboard =

        Instance.new("BillboardGui")

    billboard.Name =

        "599_WORLD_EGG_ESP_V54"

    billboard.Adornee =

        part

    billboard.Parent =

        part

    billboard.Size =

        UDim2.fromOffset(

            BOARD_WIDTH,

            BOARD_HEIGHT

        )

    billboard.StudsOffset =

        Vector3.new(

            0,

            BOARD_HEIGHT_STUDS,

            0

        )

    billboard.AlwaysOnTop =

        true

    billboard.LightInfluence =

        0

    billboard.MaxDistance =

        MAX_DISTANCE

    billboard.Enabled =

        getgenv()._599_UNIFIED_ESP_ENABLED == true

    --========================================================

    -- GLOW

    --========================================================

    local glow =

        Instance.new("Frame")

    glow.Name =

        "Glow"

    glow.Parent =

        billboard

    glow.AnchorPoint =

        Vector2.new(

            0.5,

            0.5

        )

    glow.Position =

        UDim2.fromScale(

            0.5,

            0.5

        )

    glow.Size =

        UDim2.new(

            1,

            6,

            1,

            6

        )

    glow.BackgroundColor3 =

        initialColor

    glow.BackgroundTransparency =

        0.72

    glow.BorderSizePixel =

        0

    local glowCorner =

        Instance.new("UICorner")

    glowCorner.CornerRadius =

        UDim.new(

            0,

            10

        )

    glowCorner.Parent =

        glow

    --========================================================

    -- MAIN BOARD

    --========================================================

    local board =

        Instance.new("Frame")

    board.Name =

        "Board"

    board.Parent =

        billboard

    board.Size =

        UDim2.fromScale(

            1,

            1

        )

    board.BackgroundColor3 =

        Color3.fromRGB(

            12,

            14,

            18

        )

    board.BackgroundTransparency =

        0.12

    board.BorderSizePixel =

        0
    board.ZIndex =

        2

    local boardCorner =

        Instance.new("UICorner")

    boardCorner.CornerRadius =

        UDim.new(

            0,

            8

        )

    boardCorner.Parent =

        board

    --========================================================

    -- BORDER

    --========================================================

    local border =

        Instance.new("UIStroke")

    border.Name =

        "RarityBorder"

    border.Parent =

        board

    border.Color =

        initialColor

    border.Thickness =

        1.6

    border.Transparency =

        0.05

    border.ApplyStrokeMode =

        Enum.ApplyStrokeMode.Border

    --========================================================

    -- DARK BOARD GRADIENT

    --========================================================

    local gradient =

        Instance.new("UIGradient")

    gradient.Parent =

        board

    gradient.Color =

        ColorSequence.new({

            ColorSequenceKeypoint.new(

                0,

                Color3.fromRGB(

                    28,

                    30,

                    38

                )

            ),

            ColorSequenceKeypoint.new(

                0.55,

                Color3.fromRGB(

                    12,

                    14,

                    18

                )

            ),

            ColorSequenceKeypoint.new(

                1,

                Color3.fromRGB(

                    22,

                    24,

                    30

                )

            )

        })

    --========================================================

    -- LEFT ACCENT

    --========================================================

    local accent =

        Instance.new("Frame")

    accent.Name =

        "Accent"

    accent.Parent =

        board

    accent.Size =

        UDim2.new(

            0,

            4,

            1,

            -12

        )

    accent.Position =

        UDim2.new(

            0,

            5,

            0,

            6

        )

    accent.BackgroundColor3 =

        initialColor

    accent.BorderSizePixel =

        0

    accent.ZIndex =

        4

    local accentCorner =

        Instance.new("UICorner")

    accentCorner.CornerRadius =

        UDim.new(

            1,

            0

        )

    accentCorner.Parent =

        accent

    --========================================================

    -- EGG NAME

    --========================================================

    local nameLabel =

        Instance.new("TextLabel")

    nameLabel.Name =

        "EggName"

    nameLabel.Parent =

        board

    nameLabel.BackgroundTransparency =

        1

    nameLabel.Position =

        UDim2.new(

            0,

            13,

            0,

            4

        )

    nameLabel.Size =

        UDim2.new(

            1,

            -19,

            0,

            20

        )

    nameLabel.Font =

        Enum.Font.GothamBold

    nameLabel.TextScaled =

        false

    nameLabel.TextSize =

        NAME_TEXT_SIZE

    nameLabel.TextWrapped =

        false

    nameLabel.Text =

        string.upper(

            eggName

        )

    nameLabel.TextColor3 =

        initialColor

    nameLabel.TextStrokeColor3 =

        Color3.fromRGB(

            0,

            0,

            0

        )

    nameLabel.TextStrokeTransparency =

        0.25

    nameLabel.TextXAlignment =

        Enum.TextXAlignment.Center

    nameLabel.TextYAlignment =

        Enum.TextYAlignment.Center

    nameLabel.ZIndex =

        5

    --========================================================

    -- DISTANCE

    --========================================================

    local distanceLabel =

        Instance.new("TextLabel")

    distanceLabel.Name =

        "Distance"

    distanceLabel.Parent =

        board

    distanceLabel.BackgroundTransparency =

        1

    distanceLabel.Position =

        UDim2.new(

            0,

            13,

            0,

            23

        )

    distanceLabel.Size =

        UDim2.new(

            1,

            -19,

            0,

            16

        )

    distanceLabel.Font =

        Enum.Font.GothamSemibold

    distanceLabel.TextScaled =

        false

    distanceLabel.TextSize =

        DISTANCE_TEXT_SIZE

    distanceLabel.TextWrapped =

        false

    distanceLabel.Text =

        "... STUDS"

    distanceLabel.TextColor3 =

        initialColor

    distanceLabel.TextStrokeColor3 =

        Color3.fromRGB(

            0,

            0,

            0

        )

    distanceLabel.TextStrokeTransparency =

        0.35

    distanceLabel.TextXAlignment =

        Enum.TextXAlignment.Center

    distanceLabel.TextYAlignment =

        Enum.TextYAlignment.Center

    distanceLabel.ZIndex =

        5

    --========================================================

    -- CONNECTOR

    --========================================================

    local connector =

        Instance.new("Frame")

    connector.Name =

        "Connector"

    connector.Parent =

        board

    connector.AnchorPoint =

        Vector2.new(

            0.5,

            0

        )

    connector.Position =

        UDim2.new(

            0.5,

            0,

            1,

            -1

        )

    connector.Size =

        UDim2.fromOffset(

            6,

            6

        )

    connector.BackgroundColor3 =

        initialColor

    connector.BorderSizePixel =

        0

    connector.ZIndex =

        6

    local connectorCorner =

        Instance.new("UICorner")

    connectorCorner.CornerRadius =

        UDim.new(

            1,

            0

        )

    connectorCorner.Parent =

        connector

    --========================================================

    -- SAVE

    --========================================================

    STATE.Tracked[egg] = {

        Egg =

            egg,

        Part =

            part,

        Pointer =

            pointer,

        Billboard =

            billboard,

        Board =

            board,

        Glow =

            glow,

        Border =

            border,

        Accent =

            accent,

        Connector =

            connector,

        NameLabel =

            nameLabel,

        DistanceLabel =

            distanceLabel,

        Name =

            eggName,

        Rarity =

            rarity,

        Color =

            rarityColor,

        IsBlackhole =

            isBlackholeEgg(

                eggName

            )

    }

    STATE.Billboards[egg] =

        billboard

    STATE.Pointers[egg] =

        pointer

    --========================================================
    -- UNIFIED GUI: APPLY CURRENT ESP FILTER TO NEW/RESET EGG
    --========================================================
    -- Egg resets create a fresh ESP object. Apply the CURRENT
    -- checkbox state immediately so old/unselected rarities
    -- cannot reappear during a respawn/reset.
    do
        local espOnNow = getgenv()._599_UNIFIED_ESP_ENABLED == true
        local raritySelectedNow = EspEnabledRarities[rarity] == true
        local showNow = espOnNow and raritySelectedNow

        billboard.Enabled = showNow
        pointer.Transparency = LINE_TRANSPARENCY
        pointer.Parent = showNow and Workspace or UnifiedHiddenPointers
    end

    print(

        "[599 ESP V5.4] ADDED:",

        eggName,

        "|",

        rarity,

        isBlackholeEgg(eggName)

            and "| RAINBOW"

            or ""

    )

end

--============================================================

-- RENDERED EGGS WATCHER

--============================================================

local CURRENT_RENDERED =

    nil

local RENDERED_CONNECTIONS =

    {}

local function clearRenderedConnections()

    for _, con in ipairs(

        RENDERED_CONNECTIONS

    ) do

        pcall(function()

            con:Disconnect()

        end)

    end

    table.clear(

        RENDERED_CONNECTIONS

    )

end

local function hookRenderedEggs(

    rendered

)

    if not rendered then

        return

    end

    if CURRENT_RENDERED ==

        rendered

    then

        return

    end

    clearRenderedConnections()

    CURRENT_RENDERED =

        rendered

    warn(

        "[599 ESP V5.4] WATCHING:",

        rendered:GetFullName()

    )

    --========================================================

    -- EXISTING EGGS

    --========================================================

    for _, egg in ipairs(

        rendered:GetChildren()

    ) do

        task.spawn(function()

            task.wait(

                0.15

            )

            if egg.Parent ==

                rendered

            then

                createESP(

                    egg

                )

            end

        end)

    end

    --========================================================

    -- NEW EGGS

    --========================================================

    local added =

        rendered.ChildAdded:

        Connect(function(egg)

            task.delay(

                0.20,

                function()

                    if egg.Parent ==

                        rendered

                    then

                        createESP(

                            egg

                        )

                    end

                end

            )

        end)

    table.insert(

        RENDERED_CONNECTIONS,

        added

    )

    addConnection(

        added

    )

    --========================================================

    -- REMOVED EGGS

    --========================================================

    local removed =

        rendered.ChildRemoved:

        Connect(function(egg)

            removeESP(

                egg

            )

        end)

    table.insert(

        RENDERED_CONNECTIONS,

        removed

    )

    addConnection(

        removed

    )

end

--============================================================

-- INITIAL RENDERED EGGS

--============================================================

local rendered =

    Workspace:FindFirstChild(

        "RenderedEggs"

    )

if rendered then

    hookRenderedEggs(

        rendered

    )

end

--============================================================

-- RENDERED EGGS CREATED LATER

--============================================================

addConnection(

    Workspace.ChildAdded:

    Connect(function(child)

        if child.Name ==

            "RenderedEggs"

        then

            task.wait(

                0.1

            )

            hookRenderedEggs(

                child

            )

        end

    end)

)

--============================================================

-- LIVE UPDATE

--============================================================

local elapsed =

    0

addConnection(

    RunService.Heartbeat:

    Connect(function(dt)

        elapsed += dt

        --====================================================

        -- Update 20x/sec

        --

        -- Dibuat lebih cepat dari V5.3 supaya rainbow halus.

        --====================================================

        if elapsed < 0.05 then

            return

        end

        elapsed =

            0

        local root =

            getRoot()

        local removeQueue =

            {}

        -- Satu rainbow color untuk frame ini

        local rainbowColor =

            getRainbowColor()

        for egg, data in pairs(

            STATE.Tracked

        ) do

            if not egg

                or not egg.Parent

                or not data.Part

                or not data.Part.Parent

                or not data.Pointer

                or not data.Pointer.Parent

                or not data.Billboard

                or not data.Billboard.Parent

            then

                table.insert(

                    removeQueue,

                    egg

                )

            else

                local eggPosition =

                    data.Part.Position

                local unifiedEspOn = getgenv()._599_UNIFIED_ESP_ENABLED == true
                local raritySelected = EspEnabledRarities[data.Rarity] == true
                local showThisEsp = unifiedEspOn and raritySelected

                data.Billboard.Enabled = showThisEsp

                -- Keep the already-working V5.4 line exactly as before.
                data.Pointer.Transparency = LINE_TRANSPARENCY
                data.Pointer.Parent = showThisEsp and Workspace or UnifiedHiddenPointers

                --================================================

                -- LINE POSITION

                --================================================

                data.Pointer.Size =

                    Vector3.new(

                        LINE_THICKNESS,

                        BOARD_HEIGHT_STUDS,

                        LINE_THICKNESS

                    )

                data.Pointer.CFrame =

                    CFrame.new(

                        eggPosition

                        + Vector3.new(

                            0,

                            BOARD_HEIGHT_STUDS / 2,

                            0
                        )

                    )

                --================================================

                -- DISTANCE

                --================================================

                local distance =

                    0

                if root then

                    distance =

                        math.floor(

                            (

                                root.Position

                                - eggPosition

                            ).Magnitude

                        )

                end

                data.DistanceLabel.Text =

                    tostring(

                        distance

                    )

                    .. " STUDS"

                --================================================

                -- COLOR

                --

                -- Blackhole = RAINBOW

                -- Egg lain = rarity normal

                --================================================

                local currentColor

                if data.IsBlackhole then

                    currentColor =

                        rainbowColor

                else

                    currentColor =

                        data.Color

                end

                --================================================

                -- APPLY COLOR

                --================================================

                data.Pointer.Color =

                    currentColor

                data.NameLabel.TextColor3 =

                    currentColor

                data.DistanceLabel.TextColor3 =

                    currentColor

                data.Border.Color =

                    currentColor

                data.Accent.BackgroundColor3 =

                    currentColor

                data.Connector.BackgroundColor3 =

                    currentColor

                data.Glow.BackgroundColor3 =

                    currentColor

            end

        end

        --====================================================

        -- REMOVE DEAD EGGS

        --====================================================

        for _, egg in ipairs(

            removeQueue

        ) do

            removeESP(

                egg

            )

        end

    end)

)

--============================================================

-- ANTI DUPLICATE SAFETY

--============================================================

task.spawn(function()

    while ENV._599_WORLD_ESP_V54 ==

        STATE

    do

        task.wait(

            3

        )

        for egg, data in pairs(

            STATE.Tracked

        ) do

            if data.Part

                and data.Part.Parent

            then

                for _, child in ipairs(

                    data.Part:GetChildren()

                ) do

                    if child:IsA(

                        "BillboardGui"

                    )

                        and (

                            string.find(

                                child.Name,

                                "599_WORLD_EGG_ESP",

                                1,

                                true

                            )

                            or child.Name ==

                                "599_EGG_ESP"

                        )

                        and child ~=

                            data.Billboard

                    then

                        pcall(function()

                            child:Destroy()

                        end)

                    end

                end

            end

        end

    end

end)

--============================================================

-- READY

--============================================================

warn("")

warn("================================================")

warn("599 WORLD EGG ESP V5.4")

warn("BLACKHOLE RAINBOW EDITION")

warn("================================================")

warn("✓ Workspace.RenderedEggs ONLY")

warn("✓ Normal eggs = rarity color")

warn("✓ BLACKHOLE EGG = animated rainbow")

warn("✓ Rainbow name")

warn("✓ Rainbow STUDS")

warn("✓ Rainbow border")

warn("✓ Rainbow accent")

warn("✓ Rainbow glow")

warn("✓ Rainbow vertical line")

warn("✓ Board height adjustable")

warn("✓ Line thickness adjustable")

warn("✓ Live distance")

warn("✓ Auto add/remove")

warn("✓ Anti duplicate")

warn("================================================")

warn("[599 TEST] Ride a Pet standalone systems loaded.")
warn("[599 TEST] 599 AREA main hub remains untouched.")