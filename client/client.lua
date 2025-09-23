local noNPCZones = {}

local function AddNoNPCZone(zoneCoords, zoneRadius)
	local minX = zoneCoords.x - zoneRadius
	local minY = zoneCoords.y - zoneRadius
	local minZ = zoneCoords.z - zoneRadius
	local maxX = zoneCoords.x + zoneRadius
	local maxY = zoneCoords.y + zoneRadius
	local maxZ = zoneCoords.z + zoneRadius

	local blockingArea = AddScenarioBlockingArea(minX, minY, minZ, maxX, maxY, maxZ, false, true, true, true)

	local centerX = (minX + maxX) / 2.0
	local centerY = (minY + maxY) / 2.0
	local centerZ = (minZ + maxZ) / 2.0

	ClearAreaOfPeds(centerX, centerY, centerZ, zoneRadius, true)
	ClearAreaOfVehicles(centerX, centerY, centerZ, zoneRadius, false, false, false, false, false)
	RemoveVehiclesFromGeneratorsInArea(minX, minY, minZ, maxX, maxY, maxZ)

	table.insert(noNPCZones, {
		coords = zoneCoords,
		radius = zoneRadius,
		min = { x = minX, y = minY, z = minZ },
		max = { x = maxX, y = maxY, z = maxZ },
		blockingArea = blockingArea
	})
end

local function AddNPCMeetingZone(zoneCoords, zoneRadius, npcAmount, npcGroup)
	for i = 1, npcAmount do
		local npcModel = npcGroup.peds[math.random(1, #npcGroup.peds)] -- Randomly select a NPC model from the group
		RequestModel(npcModel)
		while not HasModelLoaded(npcModel) do
			Citizen.Wait(100)
		end
		local npcPed = CreatePed(4, npcModel, zoneCoords.x + math.random(-zoneRadius, zoneRadius),
			zoneCoords.y + math.random(-zoneRadius, zoneRadius), zoneCoords.z, 0.0, true, false)
		SetEntityAsMissionEntity(npcPed, true, true)
		SetBlockingOfNonTemporaryEvents(npcPed, false)
		SetPedFleeAttributes(npcPed, 0, true)
		SetPedCombatAttributes(npcPed, 17, npcGroup.pacific) -- Prevent NPCs from engaging in combat
		TaskWanderStandard(npcPed, 10.0, 10)
		SetModelAsNoLongerNeeded(npcModel)             -- Release the model
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
			Citizen.CreateThread(function()
				while true do
					for _, zone in ipairs(noNPCZones) do
						local minBounds = zone.min
						local maxBounds = zone.max
						local centerX = (minBounds.x + maxBounds.x) / 2.0
						local centerY = (minBounds.y + maxBounds.y) / 2.0
						local centerZ = (minBounds.z + maxBounds.z) / 2.0

						ClearAreaOfPeds(centerX, centerY, centerZ, zone.radius, true)
						ClearAreaOfVehicles(centerX, centerY, centerZ, zone.radius, false, false, false, false, false)
						RemoveVehiclesFromGeneratorsInArea(minBounds.x, minBounds.y, minBounds.z, maxBounds.x,
							maxBounds.y, maxBounds.z)
					end

					Citizen.Wait(5000)
				end
			end)
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

AddEventHandler('onResourceStop', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		for index = #noNPCZones, 1, -1 do
			local zone = noNPCZones[index]
			if zone.blockingArea then
				RemoveScenarioBlockingArea(zone.blockingArea, false)
			end
			noNPCZones[index] = nil
		end
	end
end)
