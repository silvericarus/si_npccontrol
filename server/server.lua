local objectsSpawned = false

RegisterCommand("startEnvironmentEvent", function(source, args)
    if objectsSpawned then
        print("Environment event already started.")
        return
    end

    if not Config.EnvironmentEventEnabled then
        print("Environment event is disabled in the configuration.")
        return
    end

    local eventName = args[1] or "default_event"
    local eventConfig = Config.EnvironmentEvents[eventName]
    if not eventConfig then
        print("Invalid event name: " .. eventName)
        return
    end

    if not objectsSpawned then
        -- Spawn objects for the event
        objectsSpawned = true
        print("Environment event started: " .. eventName)
        TriggerClientEvent("client:startEnviromentEvent", -1, eventConfig.objects)
    end
end, false)