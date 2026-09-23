-- 599 AREA V42
-- Final Game Hub release loader.
-- V41 remains untouched for rollback.
-- Key gate added before the existing stable stack.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- SUPABASE KEY VALIDATION
--========================================================

local SUPABASE_URL =
    "https://rlllfrnhrojtgpoosyba.supabase.co"

local SUPABASE_KEY =
    "sb_publishable_SkakYlrR-HmpSjKNXuw2Yw_ZehH38-1"

local RPC_URL =
    SUPABASE_URL ..
    "/rest/v1/rpc/validate_599_key"

local httpRequest =
    request
    or http_request
    or (syn and syn.request)
    or (http and http.request)

--========================================================
-- EXISTING V42 PAYLOAD
-- Kept identical: V41 + GameHub V42
--========================================================

local BASE = "https://raw.githubusercontent.com/MINUTZ599/599-AREA/main/V9_PREVIEW/"

local function run(path)
    local src = game:HttpGet(BASE .. path .. "?v=20260923_1302_visual_module")
    local fn, err = loadstring(src)
    if not fn then
        error("[599 AREA V42] "..path.." compile error: "..tostring(err))
    end
    return fn()
end

local payloadStarted = false

local function RunExistingV42()
    if payloadStarted then
        return
    end
    payloadStarted = true

    -- Existing stable 599 AREA stack.
    run("LoaderClean_v41.lua")

    -- Final Game Hub integration.
    task.wait()
    run("GameHub_v42.lua")
end

--========================================================
-- REMOVE OLD KEY GUI
--========================================================

local Old = PlayerGui:FindFirstChild("AREA599_KEY_LOGIN")
if Old then
    Old:Destroy()
end

--========================================================
-- KEY LOGIN CONFIG
--========================================================

local IMAGE = "rbxassetid://120425062633143"

local PURPLE = Color3.fromRGB(195,35,255)
local LIGHT_PURPLE = Color3.fromRGB(235,155,255)
local WHITE = Color3.fromRGB(255,255,255)
local DARK = Color3.fromRGB(12,7,20)
local NORMAL_STROKE = Color3.fromRGB(230,120,255)
local HOVER_STROKE = Color3.fromRGB(245,175,255)
local SUCCESS = Color3.fromRGB(135,255,185)
local ERROR = Color3.fromRGB(255,90,150)
local WARNING = Color3.fromRGB(255,195,90)

--========================================================
-- SCREEN GUI
--========================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "AREA599_KEY_LOGIN"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.fromScale(0.5,0.5)
Main.Size = UDim2.fromOffset(650,390)
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = GUI

local Art = Instance.new("ImageLabel")
Art.Name = "Artwork"
Art.Size = UDim2.fromScale(1,1)
Art.Position = UDim2.fromScale(0,0)
Art.BackgroundTransparency = 1
Art.BorderSizePixel = 0
Art.Image = IMAGE
Art.ScaleType = Enum.ScaleType.Fit
Art.ZIndex = 1
Art.Parent = Main

--========================================================
-- INPUT
--========================================================

local Input = Instance.new("Frame")
Input.Name = "Input"
Input.AnchorPoint = Vector2.new(0.5,0.5)
Input.Position = UDim2.fromScale(0.675,0.625)
Input.Size = UDim2.fromScale(0.37,0.105)
Input.BackgroundColor3 = DARK
Input.BackgroundTransparency = 0.12
Input.BorderSizePixel = 0
Input.ZIndex = 5
Input.Parent = Main

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0,8)
InputCorner.Parent = Input

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = PURPLE
InputStroke.Thickness = 1.3
InputStroke.Transparency = 0.05
InputStroke.Parent = Input

local Icon = Instance.new("TextLabel")
Icon.Name = "Icon"
Icon.Position = UDim2.fromScale(0.035,0)
Icon.Size = UDim2.fromScale(0.13,1)
Icon.BackgroundTransparency = 1
Icon.Text = "◆"
Icon.TextColor3 = LIGHT_PURPLE
Icon.Font = Enum.Font.GothamBold
Icon.TextSize = 14
Icon.ZIndex = 7
Icon.Parent = Input

local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Position = UDim2.fromScale(0.16,0)
KeyBox.Size = UDim2.fromScale(0.80,1)
KeyBox.BackgroundTransparency = 1
KeyBox.BorderSizePixel = 0
KeyBox.Text = ""
KeyBox.PlaceholderText = "Enter your key..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(185,155,200)
KeyBox.TextColor3 = WHITE
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.GothamMedium
KeyBox.TextXAlignment = Enum.TextXAlignment.Left
KeyBox.ClearTextOnFocus = false
KeyBox.ZIndex = 7
KeyBox.Parent = Input

--========================================================
-- LOGIN BUTTON
--========================================================

local Login = Instance.new("TextButton")
Login.Name = "Login"
Login.AnchorPoint = Vector2.new(0.5,0.5)
Login.Position = UDim2.fromScale(0.675,0.755)
Login.Size = UDim2.fromScale(0.37,0.105)
Login.BackgroundColor3 = Color3.fromRGB(150,25,210)
Login.BorderSizePixel = 0
Login.Text = ""
Login.AutoButtonColor = false
Login.ZIndex = 5
Login.Parent = Main

local LoginCorner = Instance.new("UICorner")
LoginCorner.CornerRadius = UDim.new(0,8)
LoginCorner.Parent = Login

local Gradient = Instance.new("UIGradient")
Gradient.Rotation = 0
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(105,18,155)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(155,25,215)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(205,35,255)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(175,25,230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120,18,170))
})
Gradient.Parent = Login

local LoginStroke = Instance.new("UIStroke")
LoginStroke.Color = NORMAL_STROKE
LoginStroke.Thickness = 1.5
LoginStroke.Transparency = 0
LoginStroke.Parent = Login

local LoginText = Instance.new("TextLabel")
LoginText.Name = "LoginText"
LoginText.Size = UDim2.fromScale(1,1)
LoginText.Position = UDim2.fromScale(0,0)
LoginText.BackgroundTransparency = 1
LoginText.Text = "LOGIN   →"
LoginText.TextColor3 = WHITE
LoginText.TextTransparency = 0
LoginText.TextSize = 16
LoginText.Font = Enum.Font.GothamBold
LoginText.TextStrokeColor3 = Color3.fromRGB(80,10,100)
LoginText.TextStrokeTransparency = 0.6
LoginText.ZIndex = 10
LoginText.Active = false
LoginText.Parent = Login

local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.AnchorPoint = Vector2.new(0.5,0.5)
Status.Position = UDim2.fromScale(0.675,0.835)
Status.Size = UDim2.fromScale(0.37,0.035)
Status.BackgroundTransparency = 1
Status.Text = ""
Status.TextColor3 = LIGHT_PURPLE
Status.TextSize = 9
Status.Font = Enum.Font.GothamMedium
Status.ZIndex = 7
Status.Parent = Main

--========================================================
-- STATE / VISUAL
--========================================================

local Busy = false
local HoveringLogin = false
local StatusGeneration = 0

KeyBox.Focused:Connect(function()
    TweenService:Create(
        InputStroke,
        TweenInfo.new(0.15),
        {Thickness = 2, Transparency = 0}
    ):Play()
end)

local NORMAL_SIZE = UDim2.fromScale(0.37,0.105)
local HOVER_SIZE = UDim2.fromScale(0.378,0.11)
local CLICK_SIZE = UDim2.fromScale(0.36,0.098)

Login.MouseEnter:Connect(function()
    HoveringLogin = true
    TweenService:Create(
        Login,
        TweenInfo.new(0.15,Enum.EasingStyle.Quad),
        {Size = HOVER_SIZE}
    ):Play()

    if not Busy then
        TweenService:Create(
            LoginStroke,
            TweenInfo.new(0.15),
            {Color = HOVER_STROKE, Thickness = 1.9}
        ):Play()
    end
end)

Login.MouseLeave:Connect(function()
    HoveringLogin = false
    TweenService:Create(
        Login,
        TweenInfo.new(0.15,Enum.EasingStyle.Quad),
        {Size = NORMAL_SIZE}
    ):Play()

    if not Busy then
        TweenService:Create(
            LoginStroke,
            TweenInfo.new(0.15),
            {Color = NORMAL_STROKE, Thickness = 1.5}
        ):Play()
    end
end)

Login.MouseButton1Down:Connect(function()
    TweenService:Create(
        Login,
        TweenInfo.new(0.07),
        {Size = CLICK_SIZE}
    ):Play()
end)

Login.MouseButton1Up:Connect(function()
    local TargetSize = HoveringLogin and HOVER_SIZE or NORMAL_SIZE
    TweenService:Create(
        Login,
        TweenInfo.new(0.09),
        {Size = TargetSize}
    ):Play()
end)

local function RestoreLogin()
    if not GUI.Parent then
        return
    end

    LoginText.Text = "LOGIN   →"
    LoginStroke.Color = HoveringLogin and HOVER_STROKE or NORMAL_STROKE
    LoginStroke.Thickness = HoveringLogin and 1.9 or 1.5
end

local function ShowError(buttonText,statusText,color)
    StatusGeneration += 1
    local Generation = StatusGeneration

    LoginText.Text = buttonText
    LoginStroke.Color = color
    Status.Text = statusText
    Status.TextColor3 = color

    task.delay(1.8,function()
        if not GUI.Parent then
            return
        end

        if Generation ~= StatusGeneration then
            return
        end

        RestoreLogin()
        Status.Text = ""
    end)
end

--========================================================
-- SUPABASE REQUEST
--========================================================

local function ValidateKey(key)
    if not httpRequest then
        return false,{
            status = "REQUEST_UNAVAILABLE",
            message = "HTTP REQUEST UNAVAILABLE"
        }
    end

    local Body = HttpService:JSONEncode({
        p_key_code = key,
        p_roblox_user_id = Player.UserId
    })

    local Success,Response = pcall(function()
        return httpRequest({
            Url = RPC_URL,
            Method = "POST",
            Headers = {
                ["apikey"] = SUPABASE_KEY,
                ["Authorization"] = "Bearer "..SUPABASE_KEY,
                ["Content-Type"] = "application/json",
                ["Accept"] = "application/json"
            },
            Body = Body
        })
    end)

    if not Success then
        return false,{
            status = "NETWORK_ERROR",
            message = "CONNECTION ERROR"
        }
    end

    if not Response then
        return false,{
            status = "NO_RESPONSE",
            message = "NO SERVER RESPONSE"
        }
    end

    local StatusCode = Response.StatusCode or Response.Status or 0
    local ResponseBody = Response.Body or Response.body or ""

    if StatusCode < 200 or StatusCode >= 300 then
        return false,{
            status = "HTTP_ERROR",
            message = "SERVER ERROR",
            http_status = StatusCode
        }
    end

    local DecodeSuccess,Data = pcall(
        HttpService.JSONDecode,
        HttpService,
        ResponseBody
    )

    if not DecodeSuccess or type(Data) ~= "table" then
        return false,{
            status = "INVALID_RESPONSE",
            message = "INVALID SERVER RESPONSE"
        }
    end

    return true,Data
end

--========================================================
-- VERIFY
--========================================================

local function Verify()
    if Busy then
        return
    end

    StatusGeneration += 1

    local key =
        KeyBox.Text
        :gsub("^%s+","")
        :gsub("%s+$","")

    if key == "" then
        InputStroke.Color = ERROR

        ShowError(
            "ENTER KEY FIRST",
            "KEY REQUIRED",
            ERROR
        )

        task.delay(1.8,function()
            if GUI.Parent and not Busy then
                InputStroke.Color = PURPLE
            end
        end)

        return
    end

    Busy = true
    LoginText.Text = "CHECKING..."
    Status.Text = "VERIFYING ACCESS"
    Status.TextColor3 = LIGHT_PURPLE
    InputStroke.Color = PURPLE

    local RequestWorked,Result = ValidateKey(key)

    if not GUI.Parent then
        return
    end

    if not RequestWorked then
        Busy = false

        local ErrorStatus =
            Result and Result.status or "ERROR"

        if ErrorStatus == "REQUEST_UNAVAILABLE" then
            ShowError(
                "REQUEST ERROR",
                "EXECUTOR HTTP REQUEST UNAVAILABLE",
                ERROR
            )
        elseif ErrorStatus == "HTTP_ERROR" then
            ShowError(
                "SERVER ERROR",
                "SUPABASE REQUEST FAILED",
                ERROR
            )
        else
            ShowError(
                "CONNECTION ERROR",
                "CHECK INTERNET CONNECTION",
                ERROR
            )
        end

        return
    end

    local IsValid = Result.ok == true
    local KeyStatus =
        tostring(Result.status or ""):upper()

    if IsValid and KeyStatus == "ACTIVE" then
        LoginText.Text = "ACCESS GRANTED  ✓"
        LoginStroke.Color = SUCCESS
        LoginStroke.Thickness = 1.8
        Status.Text = "WELCOME TO 599 AREA"
        Status.TextColor3 = SUCCESS

        print("")
        print("==============================")
        print("599 AREA KEY SYSTEM")
        print("USER ID:",Player.UserId)
        print("STATUS: ACCESS GRANTED")
        print("==============================")
        print("")

        task.wait(1)

        if not GUI.Parent then
            return
        end

        -- IMPORTANT:
        -- Do NOT call LoaderClean_v42.lua here.
        -- This file IS LoaderClean_v42.lua.
        -- Continue directly into the exact existing V42 payload.
        GUI:Destroy()
        RunExistingV42()
        return
    end

    Busy = false

    if KeyStatus == "INVALID" then
        ShowError("INVALID KEY","KEY NOT FOUND",ERROR)

    elseif KeyStatus == "EXPIRED" then
        ShowError("KEY EXPIRED","ACCESS EXPIRED",WARNING)

    elseif KeyStatus == "REVOKED" then
        ShowError("KEY REVOKED","ACCESS REVOKED",ERROR)

    elseif KeyStatus == "BOUND_TO_OTHER_USER" then
        ShowError(
            "ACCESS DENIED",
            "KEY BOUND TO ANOTHER USER",
            ERROR
        )

    elseif KeyStatus == "INVALID_USER" then
        ShowError(
            "USER ERROR",
            "INVALID ROBLOX USER",
            ERROR
        )

    else
        ShowError(
            "ACCESS DENIED",
            tostring(Result.message or "VALIDATION FAILED"),
            ERROR
        )
    end
end

Login.MouseButton1Click:Connect(Verify)

KeyBox.FocusLost:Connect(function(enterPressed)
    TweenService:Create(
        InputStroke,
        TweenInfo.new(0.15),
        {Thickness = 1.3, Transparency = 0.05}
    ):Play()

    if enterPressed then
        task.defer(Verify)
    end
end)

--========================================================
-- CLOSE / MINIMIZE
--========================================================

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.AnchorPoint = Vector2.new(0.5,0.5)
Close.Position = UDim2.fromScale(0.949,0.115)
Close.Size = UDim2.fromOffset(28,28)
Close.BackgroundTransparency = 1
Close.Text = ""
Close.ZIndex = 20
Close.Parent = Main

Close.MouseButton1Click:Connect(function()
    StatusGeneration += 1
    GUI:Destroy()
end)

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.AnchorPoint = Vector2.new(0.5,0.5)
Minimize.Position = UDim2.fromScale(0.905,0.115)
Minimize.Size = UDim2.fromOffset(30,25)
Minimize.BackgroundTransparency = 1
Minimize.Text = ""
Minimize.ZIndex = 20
Minimize.Parent = Main

local Mini = Instance.new("TextButton")
Mini.Name = "Mini599"
Mini.AnchorPoint = Vector2.new(0.5,0.5)
Mini.Position = UDim2.fromScale(0.5,0.5)
Mini.Size = UDim2.fromOffset(68,34)
Mini.BackgroundColor3 = Color3.fromRGB(80,15,115)
Mini.BackgroundTransparency = 0.05
Mini.BorderSizePixel = 0
Mini.Text = "599"
Mini.TextColor3 = LIGHT_PURPLE
Mini.TextSize = 14
Mini.Font = Enum.Font.GothamBold
Mini.Visible = false
Mini.ZIndex = 50
Mini.Parent = GUI

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0,7)
MiniCorner.Parent = Mini

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = PURPLE
MiniStroke.Thickness = 1.3
MiniStroke.Parent = Mini

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

Mini.MouseButton1Click:Connect(function()
    Mini.Visible = false
    Main.Visible = true
end)

--========================================================
-- SAFE DRAG
--========================================================

local Dragging = false
local DragStart = nil
local StartPosition = nil

local function MouseInside(guiObject)
    local MousePosition = UIS:GetMouseLocation()
    local Position = guiObject.AbsolutePosition
    local Size = guiObject.AbsoluteSize

    return
        MousePosition.X >= Position.X
        and MousePosition.X <= Position.X + Size.X
        and MousePosition.Y >= Position.Y
        and MousePosition.Y <= Position.Y + Size.Y
end

local function IsInteractiveArea()
    if MouseInside(Input) then
        return true
    end

    if MouseInside(Login) then
        return true
    end

    if MouseInside(Close) then
        return true
    end

    if MouseInside(Minimize) then
        return true
    end

    return false
end

Main.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end

    if IsInteractiveArea() then
        return
    end

    Dragging = true
    DragStart = input.Position
    StartPosition = Main.Position
end)

UIS.InputChanged:Connect(function(input)
    if not Dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    if not DragStart or not StartPosition then
        return
    end

    local Delta = input.Position - DragStart

    Main.Position =
        UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
        DragStart = nil
        StartPosition = nil
    end
end)

print("")
print("================================")
print("599 AREA KEY LOGIN")
print("NEON PURPLE V4")
print("SUPABASE RPC CONNECTED")
print("ROBLOX USER ID:",Player.UserId)
print("================================")
print("")
