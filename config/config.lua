Config = {}

Config.notificationSystem = "qb" -- Options: "qb", "ox", "esx", "custom"

Config.enviromentEventsActive = true

Config.NoNPCZones = {
	["weazel_offices"] = {
		coords = vector3(333.45, 63.51, 20.35),
		radius = 100.0,
	},
}

Config.NPCMeetingZones = {
	["meeting_zone_1"] = {
		coords = vector3(338.77, 62.3, 26.04),
		radius = 20.0,
		amount = 5,
        npcGroup = "civilians", 
	},
	["meeting_zone_2"] = {
		coords = vector3(333.31, 63.08, 26.04),
		radius = 20.0,
		amount = 10,
        npcGroup = "police",
	},
}
