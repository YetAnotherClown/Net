local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.Shared.components)

local name = RunService:IsServer() and "serverEntityId" or "clientEntityId"

local function updateModelAttribute(world)
	for id, record in world:queryChanged(components.Model) do
		if record.new then
			record.new.model:SetAttribute(name, id)
		end
	end
end

return updateModelAttribute
