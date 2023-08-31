local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Net = require(Packages.Net)

local MockRemoteEvent = require(script.mockRemoteEvent)

return function()
	beforeAll(function(context)
		local mockRemote = MockRemoteEvent.new()

		-- Create a new Net Server/Client
		context.server = Net.new({
			Channel = "ReliableUnordered",
			Event = "default",

			DevMode = true,
			MockRemoteEvent = mockRemote,
			RunContext = "Server",
		})

		context.client = Net.new({
			Channel = "ReliableUnordered",
			Event = "default",

			DevMode = true,
			MockRemoteEvent = mockRemote,
			RunContext = "Client",
		})

		context.IDENTIFIERS = {
			["ExampleOne"] = Net.identifier("ExampleOne"),
			["ExampleTwo"] = Net.identifier("ExampleTwo"),
		}

		RunService.Heartbeat:Connect(function()
			-- The Bridge:step() method processes the incoming and outgoing queues
			context.server._bridge:step()
			context.client._bridge:step()
		end)
	end)
end
