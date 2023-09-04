local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Net = require(Packages.Net)

local MockRemoteEvent = require(script.mockRemoteEvent)

return function()
	beforeEach(function(context)
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

		local hooks = {}
		hooks.queue = {}

		function hooks:add(callback: (any) -> never)
			table.insert(self.queue, callback)
		end

		function hooks:clear()
			table.clear(self.queue)
		end

		function hooks:step()
			for _, callback in self.queue do
				callback()
			end
		end

		context.hooks = hooks

		context.runnerThread = RunService.Heartbeat:Connect(function()
			hooks:step()

			-- The Bridge:step() method processes the incoming and outgoing queues
			context.server._bridge:step()
			context.client._bridge:step()
		end)
	end)

	afterEach(function(context)
		context.hooks:clear()
		context.runnerThread:Disconnect()
	end)
end
