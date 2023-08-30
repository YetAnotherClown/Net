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

return {
	isServer = isServer,
	isClient = isClient,
}
