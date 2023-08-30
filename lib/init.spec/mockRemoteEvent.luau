local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DevPackages = ReplicatedStorage.DevPackages
local Signal = require(DevPackages.Signal)

local MockPlayer = {
    _type = "MockPlayer",

    Name = "MockPlayer",
    UserId = 123456789
}

local RemoteEvent = {}
RemoteEvent.__index = RemoteEvent

function RemoteEvent:FireAllClients(...: any)
    local players = Players:GetPlayers()
    if #players == 0 then
        table.insert(players, MockPlayer)
    end

    for _, player in Players:GetPlayers() do
        self:FireClient(player, ...)
    end
end

function RemoteEvent:FireClient(_player: any, ...: any)
    self.OnClientEvent:Fire(...)
end

function RemoteEvent:FireServer(...: any)
    self.OnServerEvent:Fire(MockPlayer, ...)
end

function RemoteEvent.new()
    local self = {}
    setmetatable(self, RemoteEvent)

    self.OnClientEvent = Signal.new()
    self.OnServerEvent = Signal.new()

    return self
end

return RemoteEvent