-- 599 AREA V8.5 - INTEGRATED WORLD SKYBOX MANAGER
-- Local visual feature; attaches directly to the existing WORLD page.
local Players=game:GetService("Players")
local Lighting=game:GetService("Lighting")
local lp=Players.LocalPlayer
local pg=lp:WaitForChild("PlayerGui")
local base=pg:WaitForChild("AREA599_V8",10)
if not base then warn("[599 V8.5 Skybox] AREA599_V8 not found") return end
local world=base:FindFirstChild("WORLD",true)
if not world then warn("[599 V8.5 Skybox] WORLD page not found") return end
if world:FindFirstChild("V85_SKYBOX_MANAGER") then world.V85_SKYBOX_MANAGER:Destroy() end

local PRESETS={
 {Name="599 AREA",Id="126519323866401"},
 {Name="599 AREA 2",Id="86301017321800"},
 {Name="SKY 1",Id="130316008595492"},
 {Name="SKY 2",Id="125716730217872"},
 {Name="SKY 3",Id="86111082891584"},
}
local original={}
for _,v in ipairs(Lighting:GetChildren()) do if v:IsA("Sky") then original[#original+1]=v:Clone() end end
local function clearSky() for _,v in ipairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end end
local function applySky(id,name)
 clearSky();local a="rbxassetid://"..tostring(id);local s=Instance.new("Sky");s.Name="599_AREA_SKY_"..tostring(name or id)
 s.SkyboxBk=a;s.SkyboxDn=a;s.SkyboxFt=a;s.SkyboxLf=a;s.SkyboxRt=a;s.SkyboxUp=a;s.Parent=Lighting
end
local function resetSky() clearSky();for _,v in ipairs(original) do v:Clone().Parent=Lighting end end

local C_BG=Color3.fromRGB(17,17,21);local C_CARD=Color3.fromRGB(22,22,27);local C_ORANGE=Color3.fromRGB(255,119,0);local C_WHITE=Color3.fromRGB(245,245,248);local C_MUTED=Color3.fromRGB(160,160,170)
local box=Instance.new("Frame");box.Name="V85_SKYBOX_MANAGER";box.Size=UDim2.fromOffset(945,300);box.Position=UDim2.fromOffset(0,218);box.BackgroundColor3=C_BG;box.BorderSizePixel=0;box.Parent=world
local bc=Instance.new("UICorner",box);bc.CornerRadius=UDim.new(0,8);local bs=Instance.new("UIStroke",box);bs.Color=Color3.fromRGB(55,55,65);bs.Transparency=.25
local title=Instance.new("TextLabel");title.BackgroundTransparency=1;title.Position=UDim2.fromOffset(14,10);title.Size=UDim2.new(1,-28,0,26);title.Font=Enum.Font.GothamBold;title.Text="SKYBOX MANAGER";title.TextColor3=C_ORANGE;title.TextSize=15;title.TextXAlignment=Enum.TextXAlignment.Left;title.Parent=box
local status=Instance.new("TextLabel");status.BackgroundTransparency=1;status.Position=UDim2.fromOffset(14,35);status.Size=UDim2.new(1,-28,0,18);status.Font=Enum.Font.Gotham;status.Text="ACTIVE: ORIGINAL SKY";status.TextColor3=C_MUTED;status.TextSize=10;status.TextXAlignment=Enum.TextXAlignment.Left;status.Parent=box
local list=Instance.new("ScrollingFrame");list.Position=UDim2.fromOffset(14,62);list.Size=UDim2.new(1,-28,0,170);list.BackgroundTransparency=1;list.BorderSizePixel=0;list.ScrollBarThickness=3;list.ScrollBarImageColor3=C_ORANGE;list.AutomaticCanvasSize=Enum.AutomaticSize.Y;list.CanvasSize=UDim2.new();list.Parent=box
local layout=Instance.new("UIListLayout",list);layout.Padding=UDim.new(0,7);layout.SortOrder=Enum.SortOrder.LayoutOrder
local function presetCard(p,i)
 local card=Instance.new("Frame");card.Size=UDim2.new(1,-6,0,48);card.BackgroundColor3=C_CARD;card.BorderSizePixel=0;card.LayoutOrder=i;card.Parent=list;local cc=Instance.new("UICorner",card);cc.CornerRadius=UDim.new(0,7);local cs=Instance.new("UIStroke",card);cs.Color=Color3.fromRGB(73,52,38);cs.Transparency=.25
 local n=Instance.new("TextLabel");n.BackgroundTransparency=1;n.Position=UDim2.fromOffset(12,5);n.Size=UDim2.new(1,-130,0,20);n.Font=Enum.Font.GothamSemibold;n.Text=p.Name;n.TextColor3=C_WHITE;n.TextSize=11;n.TextXAlignment=Enum.TextXAlignment.Left;n.Parent=card
 local id=Instance.new("TextLabel");id.BackgroundTransparency=1;id.Position=UDim2.fromOffset(12,24);id.Size=UDim2.new(1,-130,0,16);id.Font=Enum.Font.Gotham;id.Text="ID: "..p.Id;id.TextColor3=C_MUTED;id.TextSize=9;id.TextXAlignment=Enum.TextXAlignment.Left;id.Parent=card
 local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(92,32);b.Position=UDim2.new(1,-104,.5,-16);b.BackgroundColor3=Color3.fromRGB(43,28,18);b.Text="APPLY";b.TextColor3=C_ORANGE;b.TextSize=11;b.Font=Enum.Font.GothamBold;b.AutoButtonColor=false;b.Parent=card;local c=Instance.new("UICorner",b);c.CornerRadius=UDim.new(0,7);local s=Instance.new("UIStroke",b);s.Color=C_ORANGE;s.Transparency=.2
 b.MouseButton1Click:Connect(function() applySky(p.Id,p.Name);status.Text="ACTIVE: "..p.Name.."  •  "..p.Id end)
end
for i,p in ipairs(PRESETS) do presetCard(p,i) end
local reset=Instance.new("TextButton");reset.Size=UDim2.new(1,-28,0,42);reset.Position=UDim2.new(0,14,1,-54);reset.BackgroundColor3=Color3.fromRGB(24,24,29);reset.Text="RESET TO ORIGINAL SKY";reset.TextColor3=C_WHITE;reset.TextSize=11;reset.Font=Enum.Font.GothamBold;reset.Parent=box;local rc=Instance.new("UICorner",reset);rc.CornerRadius=UDim.new(0,8);local rs=Instance.new("UIStroke",reset);rs.Color=Color3.fromRGB(83,60,43)
reset.MouseButton1Click:Connect(function() resetSky();status.Text="ACTIVE: ORIGINAL SKY" end)
