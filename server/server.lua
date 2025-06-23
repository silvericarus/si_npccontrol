local objectsSpawned = false

RegisterCommand("startenviroevent", function(source, args)
	if not Config.environmentEventsActive then
		print("Environment event is disabled in the configuration.")
		return
	end

	local eventName = args[1] or ""
	if not eventName or eventName == "" then
		print("Please specify a valid environment event name.")
		return
	end
	local eventConfig = EnvironmentEvents.events[eventName]
	if not eventConfig then
		print("Invalid event name: " .. eventName)
		return
	end

	if not objectsSpawned then
		objectsSpawned = true
		TriggerClientEvent("client:startenviroevent", source, eventName, eventConfig["description"], eventConfig.peds,
		eventConfig.vehicles)
	end
end, false)
