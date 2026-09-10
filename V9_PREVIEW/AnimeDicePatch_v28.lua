-- 599 AREA V9 PREVIEW v28 - ANIME DICE FUNCTION MIGRATION
-- Preserves the approved Anime Dice layout/banner. Only wires real functionality.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local gui=pg:WaitForChild("AREA599_V9_PREVIEW",10)
if not gui then return end
local page=gui:FindFirstChild("ANIME DICE",true)
if not page then warn("[599 V28] ANIME DICE page missing") return end

local PURPLE=Color3.fromRGB(135,60,255)
local OFF=Color3.fromRGB(18,18,31)
local GREEN=Color3.fromRGB(81,230,145)
local RED=Color3.fromRGB(240,82,98)
local selected={}
for i=1,16 do selected[i]=false end

local function findButton(text)
    for _,d in ipairs(page:GetDescendants()) do
        if d:IsA("TextButton") and string.upper(d.Text or "")==string.upper(text) then return d end
    end
end

local plotButtons={}
for _,d in ipairs(page:GetDescendants()) do
    if d:IsA("TextButton") then
        local n=tonumber(d.Text)
        if n and n>=1 and n<=16 then plotButtons[n]=d end
    end
end

local function renderPlot(i)
    local b=plotButtons[i]
    if not b then return end
    b.BackgroundColor3=selected[i] and PURPLE or OFF
end

for i,b in pairs(plotButtons) do
    b.MouseButton1Click:Connect(function()
        selected[i]=not selected[i]
        renderPlot(i)
    end)
end

local allBtn=findButton("SELECT ALL")
local clearBtn=findButton("CLEAR")
if allBtn then allBtn.MouseButton1Click:Connect(function() for i=1,16 do selected[i]=true;renderPlot(i) end end) end
if clearBtn then clearBtn.MouseButton1Click:Connect(function() for i=1,16 do selected[i]=false;renderPlot(i) end end) end

-- FIX: bind to the actual numeric delay label (0.5s) and its slider bar.
local delayValue=.5
local delayLabel=nil
local sliderBar=nil
for _,d in ipairs(page:GetDescendants()) do
    if d:IsA("TextLabel") and string.match(d.Text or "","^%d+%.?%d*s$") then
        delayLabel=d
        break
    end
end
if delayLabel and delayLabel.Parent then
    local parent=delayLabel.Parent
    for _,d in ipairs(parent:GetChildren()) do
        if d:IsA("Frame") and d.AbsoluteSize.X>150 and d.AbsoluteSize.Y<=16 then
            sliderBar=d
            break
        end
    end
end
local dragging=false
local function setDelayFromX(x)
    if not sliderBar or sliderBar.AbsoluteSize.X<=0 then return end
    local p=math.clamp((x-sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X,0,1)
    delayValue=math.floor((.5+(30-.5)*p)*10+.5)/10
    if delayLabel then delayLabel.Text=string.format("%.1fs",delayValue) end
    local fill=sliderBar:FindFirstChildWhichIsA("Frame")
    if fill then fill.Size=UDim2.new(p,0,1,0) end
end
if sliderBar then
    sliderBar.Active=true
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true;setDelayFromX(input.Position.X) end
    end)
end
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then setDelayFromX(input.Position.X) end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)

local function getRemote()
    local n=ReplicatedStorage:FindFirstChild("Network")
    local ps=n and n:FindFirstChild("PlotService")
    local re=ps and ps:FindFirstChild("RE")
    local r=re and re:FindFirstChild("CollectBalance")
    return r and r:IsA("RemoteEvent") and r or nil
end

local startBtn=findButton("START AUTO COLLECT") or findButton("STOP AUTO COLLECT")
local statusLabel=nil
for _,d in ipairs(page:GetDescendants()) do
    if d:IsA("TextLabel") and ((d.Text or "")=="STOPPED" or (d.Text or "")=="RUNNING") then statusLabel=d end
end
local running=false
local function renderRunning()
    if startBtn then
        startBtn.Text=running and "STOP AUTO COLLECT" or "START AUTO COLLECT"
        startBtn.BackgroundColor3=running and Color3.fromRGB(74,24,38) or PURPLE
    end
    if statusLabel then statusLabel.Text=running and "RUNNING" or "STOPPED";statusLabel.TextColor3=running and GREEN or RED end
end
if startBtn then
    startBtn.MouseButton1Click:Connect(function()
        if not running then
            if not getRemote() then warn("[599 V28] PlotService.RE.CollectBalance not found") return end
            local any=false for i=1,16 do if selected[i] then any=true break end end
            if not any then warn("[599 V28] Select at least one plot") return end
        end
        running=not running
        renderRunning()
    end)
end

task.spawn(function()
    while page.Parent do
        if running then
            local remote=getRemote()
            if not remote then running=false;renderRunning() else
                for i=1,16 do
                    if running and selected[i] then pcall(function() remote:FireServer(i) end);task.wait(.03) end
                end
            end
        end
        task.wait(delayValue)
    end
end)
