--========================================================
-- 599 AREA - WALK KNOCKBACK SERVER
-- Script -> ServerScriptService
-- For your own Roblox experience / Studio testing.
--========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local REMOTE_NAME = "599KnockbackRequest"

-- Server-side limits. Client values are NEVER trusted directly.
local MAX_RADIUS = 18
local MAX_POWER = 120
local MIN_RADIUS = 4
local MIN_POWER = 35

local UP_FORCE = 28
local REQUEST_COOLDOWN = 0.18

local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = REMOTE_NAME
	remote.Parent = ReplicatedStorage
end

local lastRequest = {}

local function getRootAndHumanoid(plr)
	local char = plr.Character
	if not char then return nil,nil end

	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")

	if not hum or not root or hum.Health <= 0 then
		return nil,nil
	end

	return root,hum
end

remote.OnServerEvent:Connect(function(plr,requestedRadius,requestedPower)
	local now = os.clock()

	if lastRequest[plr] and now - lastRequest[plr] < REQUEST_COOLDOWN then
		return
	end
	lastRequest[plr] = now

	local sourceRoot = getRootAndHumanoid(plr)
	if not sourceRoot then return end

	local radius = math.clamp(tonumber(requestedRadius) or 10,MIN_RADIUS,MAX_RADIUS)
	local power = math.clamp(tonumber(requestedPower) or 85,MIN_POWER,MAX_POWER)

	for _,target in ipairs(Players:GetPlayers()) do
		if target ~= plr then
			local targetRoot,targetHum = getRootAndHumanoid(target)

			if targetRoot and targetHum then
				local delta = targetRoot.Position - sourceRoot.Position
				local distance = delta.Magnitude

				if distance > 0.05 and distance <= radius then
					-- No physical player-to-player collision is required.
					-- The server directly applies velocity to the target assembly.
					local direction = delta.Unit
					local horizontal = direction * power
					local launch = Vector3.new(horizontal.X,UP_FORCE,horizontal.Z)

					-- Set network ownership temporarily to server for a more
					-- consistent server-authoritative impulse.
					pcall(function()
						targetRoot:SetNetworkOwner(nil)
					end)

					targetRoot.AssemblyLinearVelocity =
						targetRoot.AssemblyLinearVelocity + launch

					task.delay(0.25,function()
						if targetRoot and targetRoot.Parent then
							pcall(function()
								targetRoot:SetNetworkOwnershipAuto()
							end)
						end
					end)
				end
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	lastRequest[plr] = nil
end)

print("599 AREA Walk Knockback Server loaded")
