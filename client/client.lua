local function AddNoNPCZone(zoneCoords, zoneRadius)
    ClearAreaOfPeds(zoneCoords.x, zoneCoords.y, zoneCoords.z, zoneRadius, true)
end

local function AddNPCMeetingZone(zoneCoords, zoneRadius, npcAmount, npcGroup)
    for i = 1, npcAmount do
        local npcModel = npcGroup.peds[math.random(1, #npcGroup.peds)] -- Randomly select a NPC model from the group
        RequestModel(npcModel)
        while not HasModelLoaded(npcModel) do
            Citizen.Wait(100)
        end
        local npcPed = CreatePed(4, npcModel, zoneCoords.x + math.random(-zoneRadius, zoneRadius), zoneCoords.y + math.random(-zoneRadius, zoneRadius), zoneCoords.z, 0.0, true, false)
        SetEntityAsMissionEntity(npcPed, true, true)
        SetBlockingOfNonTemporaryEvents(npcPed, true)
        SetPedFleeAttributes(npcPed, 0, false)
        SetPedCombatAttributes(npcPed, 17, npcGroup.pacific) -- Prevent NPCs from engaging in combat
        SetPedCanRagdoll(npcPed, true) -- Prevent NPCs from ragdolling
        SetPedKeepTask(npcPed, true) -- Keep NPCs in their task
        TaskStartScenarioInPlace(npcPed, "WORLD_HUMAN_STAND_MOBILE", 0, true) -- Make NPCs stand still
        SetModelAsNoLongerNeeded(npcModel) -- Release the model
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Citizen.CreateThread(function()
            for zoneName, zoneData in pairs(Config.NoNPCZones) do
                local zoneCoords = zoneData.coords
                local zoneRadius = zoneData.radius
                -- Create a no NPC zone
                AddNoNPCZone(zoneCoords, zoneRadius)
                Citizen.Wait(0) -- Wait to avoid performance issues
            end
            for zoneName, zoneData in pairs(Config.NPCMeetingZones) do
                local zoneCoords = zoneData.coords
                local zoneRadius = zoneData.radius
                local npcAmount = zoneData.amount or 1 -- Default to 1 if not specified
                local npcGroup = zoneData.npcGroup -- Get the NPC group from the config
                local npcGroupData = NPCGroups[npcGroup] -- Get the NPC group data from the shared config
                -- Create NPCs in the meeting zone
                AddNPCMeetingZone(zoneCoords, zoneRadius, npcAmount, npcGroupData)
                Citizen.Wait(0) -- Wait to avoid performance issues
            end
        end)
    end    
end)

RegisterNetEvent('client:startEnviromentEvent', function(objects)
    print("Starting environment event with objects: " .. json.encode(objects))
end)