local MockPlayer = {
	_type = "MockPlayer",

	Name = "MockPlayer1",
	UserId = 123456789,
}

local MockPlayer2 = {
	_type = "MockPlayer",

	Name = "MockPlayer2",
	UserId = 123456789,
}

return function()
	describe("Send", function()
		it("should pass values to the bridge", function(context)
			context.server:send(MockPlayer, "identifier", 1, 2, 3)

			local packet = context.server._bridge._outgoingQueue[1]
			expect(packet).to.be.ok()

			for i, v in packet.data do
				expect(v).to.equal(i)
			end

			expect(packet.identifier).to.equal("identifier")
			expect(packet.recipient).to.equal(MockPlayer)
		end)

		it("should fill in NET_SERVER for the client", function(context)
			context.client._bridge._outgoingQueue = {}
			context.client:send("identifier", 1, 2, 3)

			local packet = context.client._bridge._outgoingQueue[1]
			expect(packet).to.be.ok()

			for i, v in packet.data do
				expect(v).to.equal(i)
			end

			expect(packet.identifier).to.equal("identifier")
			expect(packet.recipient).to.equal("NET_SERVER")
		end)

		it("should allow strings after identifier", function(context)
			context.client._bridge._outgoingQueue = {}
			context.client:send("identifier", "1", "2", "3")

			local packet = context.client._bridge._outgoingQueue[1]
			expect(packet).to.be.ok()

			for i, v in packet.data do
				expect(v).to.equal(`{i}`)
			end

			expect(packet.identifier).to.equal("identifier")
		end)

		it("should parse Player Instances", function(context)
			local sendParams = {
				identifier = nil,
				recipient = nil,
				data = {},
			}

			context.server._parseSendParams["Instance"](sendParams, MockPlayer, context.server._configuration)
			expect(sendParams.recipient).to.equal(MockPlayer)
		end)

		it("should parse { PlayerInstance }", function(context)
			local sendParams = {
				identifier = nil,
				recipient = nil,
				data = {},
			}

			local MockPlayers = { MockPlayer, MockPlayer2 }

			context.server._parseSendParams["table"](sendParams, MockPlayers, context.server._configuration)
			expect(sendParams.recipient).to.equal(MockPlayers)
		end)

		it("should parse NET_SERVER", function(context)
			local sendParams = {
				identifier = nil,
				recipient = nil,
				data = {},
			}

			context.server._parseSendParams["string"](sendParams, "NET_SERVER", context.server._configuration)
			expect(sendParams.recipient).to.equal("NET_SERVER")
		end)

		it("should parse Identifiers", function(context)
			local sendParams = {
				identifier = nil,
				recipient = nil,
				data = {},
			}

			context.server._parseSendParams["string"](sendParams, "identifier", context.server._configuration)
			expect(sendParams.identifier).to.equal("identifier")
		end)
	end)

	describe("Iterator", function()
		it("should return all information when unfiltered in order", function(context)
			local packets = {
				{
					identifier = "identifier",
					sender = "NET_SERVER",
					data = { 1 },
				},
				{
					identifier = "identifier2",
					sender = MockPlayer,
					data = { 2 },
				},
			}

			context.server._bridge._snapshot = packets

			for i, sender, identifier, arg1 in context.server do
				local packet = packets[i]

				expect(sender).to.equal(packet.sender)
				expect(identifier).to.equal(packet.identifier)
				expect(arg1).to.equal(packet.data[1])
			end
		end)

		it("should filter key-value pairs", function(context)
			local packets = {
				{
					identifier = "identifier",
					sender = "NET_SERVER",
					data = { 1 },
				},
				{
					identifier = "identifier2",
					sender = MockPlayer,
					data = { 2 },
				},
				{
					identifier = "identifier2",
					sender = "NET_SERVER",
					data = { 2 },
				},
			}

			context.server._bridge._snapshot = packets

			local iter = context.server:__iter(function(_, v)
				if v.sender == MockPlayer then
					return
				end

				return v
			end)

			for _, sender in iter do
				expect(sender).never.to.equal(MockPlayer)
			end
		end)

		it("should filter return results", function(context)
			local packets = {
				{
					identifier = "identifier",
					sender = "NET_SERVER",
					data = { 1 },
				},
			}

			context.server._bridge._snapshot = packets

			local iter = context.server:__iter(nil, function(_, sender, _, _)
				local package = { sender }

				return table.unpack(package)
			end)

			for sender, arg2 in iter do
				expect(sender).to.equal("NET_SERVER")
				expect(arg2).to.equal(nil)
			end
		end)
	end)

	describe("Query", function()
		it("should be able to query a single Identifier", function(context)
			-- Run this every frame prior to Bridge:step()
			context.hooks:add(function()
				local n = 0
				local returned = {}

				for i, player, arg1, arg2, arg3 in context.client:query("identifier", "identifier2") do
					n += 1

					-- i should represent the number in order of events
					expect(i).to.equal(n)

					-- player should equal the player that has sent the packet
					expect(player and player.Name and player.Name == MockPlayer.Name).to.equal(true)

					-- all sent arguments should be returned
					expect(arg1).to.equal(1)
					expect(arg2).to.equal(2)
					expect(arg3).to.equal(3)

					table.insert(returned, { arg1, arg2, arg3 })
				end

				-- The packet should be received exactly once
				expect(#returned == 1).to.equal(true)
			end)

			-- Packet to be received by the query
			context.server:send(MockPlayer, "identifier", 1, 2, 3)
		end)

		it("should be able to query multiple Identifiers", function(context)
			-- Run this every frame prior to Bridge:step()
			context.hooks:add(function()
				local n = 0
				local returned = {}

				for i, player, identifier, arg1, arg2, arg3 in context.client:query("identifier", "identifier2") do
					n += 1

					-- i should represent the number in order of events
					expect(i).to.equal(n)

					-- identifier should equal the identifier used for the packet
					expect(identifier == ("identifier" or "identifier2")).to.equal(true)

					-- player should equal the player that has sent the packet
					expect(player and player.Name and player.Name == MockPlayer.Name).to.equal(true)

					-- all sent arguments should be returned
					expect(arg1).to.equal(1)
					expect(arg2).to.equal(2)
					expect(arg3).to.equal(3)

					table.insert(returned, { arg1, arg2, arg3 })
				end

				-- The packet should be received exactly twice
				expect(#returned == 2).to.equal(true)
			end)

			-- Packets to be received by the query
			context.server:send(MockPlayer, "identifier", 1, 2, 3)
			context.server:send(MockPlayer, "identifier2", 1, 2, 3)

			-- This packet should never be received by the query
			context.server:send(MockPlayer, "identifier3", 1, 2, 3)
		end)

		it("should be able to query Players", function(context)
			-- Run this every frame prior to Bridge:step()
			context.hooks:add(function()
				local n = 0
				local returned = {}

				for i, identifier, arg1, arg2, arg3 in context.server:query(MockPlayer) do
					n += 1

					-- i should represent the number in order of events
					expect(i).to.equal(n)

					-- identifier should equal the identifier used for the packet
					expect(identifier).to.equal("identifier")

					-- all sent arguments should be returned
					expect(arg1).to.equal(1)
					expect(arg2).to.equal(2)
					expect(arg3).to.equal(3)

					table.insert(returned, { arg1, arg2, arg3 })
				end

				-- The packet should be received exactly one
				expect(#returned == 1).to.equal(true)
			end)

			-- Send out packet to the server
			context.client:send("NET_SERVER", "identifier", 1, 2, 3)
		end)

		it("should return packet information in order", function(context)
			-- Run this every frame prior to Bridge:step()
			context.hooks:add(function()
				local n = 0

				for i, player, identifier, arg1, arg2, arg3 in context.client:query("identifier", "identifier2") do
					n += 1

					-- i should represent the number in order of events
					expect(i).to.equal(n)

					-- identifier should equal the identifier used for the packet
					expect(identifier == ("identifier" or "identifier2")).to.equal(true)

					-- player should equal the player that has sent the packet
					expect(player and player.Name and player.Name == MockPlayer.Name).to.equal(true)

					-- all sent arguments should be returned
					expect(arg1).to.equal(1)
					expect(arg2).to.equal(2)
					expect(arg3).to.equal(3)
				end
			end)

			-- Packet to be received by the query
			context.server:send(MockPlayer, "identifier", 1, 2, 3)
		end)
	end)

	describe("QueryParams", function()
		it("should parse Player Instances", function(context)
			local queryParams = {
				multipleSenders = false,
				senders = {},
				identifiers = {},
			}

			context.server._parseQueryParams["Instance"](queryParams, MockPlayer, context.server._configuration)
			expect(queryParams.senders[1]).to.equal(MockPlayer)
		end)

		it("should parse { PlayerInstance }", function(context)
			local queryParams = {
				multipleSenders = false,
				senders = {},
				identifiers = {},
			}

			local MockPlayers = { MockPlayer, MockPlayer2 }

			context.server._parseQueryParams["table"](queryParams, MockPlayers, context.server._configuration)
			expect(function()
				for _, sender in queryParams.senders do
					if not table.find(MockPlayers, sender) then
						error("Player not found in senders")
					end
				end
			end).to.never.throw()
		end)

		it("should parse NET_SERVER", function(context)
			local queryParams = {
				multipleSenders = false,
				senders = {},
				identifiers = {},
			}

			context.server._parseQueryParams["string"](queryParams, "NET_SERVER", context.server._configuration)
			expect(#queryParams.senders).to.equal(0)
		end)

		it("should parse Identifiers", function(context)
			local queryParams = {
				multipleSenders = false,
				senders = {},
				identifiers = {},
			}

			context.server._parseQueryParams["string"](queryParams, "identifier", context.server._configuration)
			context.server._parseQueryParams["string"](queryParams, "identifier2", context.server._configuration)
			expect(function()
				for _, sender in queryParams.senders do
					if sender ~= ("identifier" or "identifier2") then
						error("Identifier not found in identifier")
					end
				end
			end).to.never.throw()
		end)
	end)
end
