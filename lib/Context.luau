local RunService = game:GetService("RunService")

--[[
    Mocks the RunService:IsClient() and RunService:IsServer() Methods in 
    order to implement the RunContext internal field in Net's Configuration.
]]

local function isServer(configuration)
	if not configuration.DevMode or not configuration.RunContext then
		return RunService:IsServer()
	end

	return configuration.RunContext == "Server"
end

local function isClient(configuration)
	if not configuration.DevMode or not configuration.RunContext then
		return RunService:IsClient()
	end

	return configuration.RunContext == "Client"
end

local function isPlayer(configuration, player)
	if configuration.DevMode then
		return typeof(player) == "table" and player._type == "MockPlayer"
	else
        return typeof(player) == "Instance" and player:IsA("Player")
	end
end

local function getType(value, configuration)
	if isPlayer(configuration, value) then
		return "Instance"
	end

	return typeof(value)
end

return {
	getType = getType,

	isServer = isServer,
	isClient = isClient,

    isPlayer = isPlayer,
}
