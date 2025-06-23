EnvironmentEvents = {}

EnvironmentEvents.events = {
	["carcrash"] = {
		["description"] = "A car crash has occurred nearby.",
		["cooldown"] = 600, -- Cooldown in seconds
		["peds"] = {
			"s_m_m_paramedic_01",
			"s_f_y_paramedic_01",
			"s_m_y_cop_01",
			"s_f_y_cop_01",
			"g_m_m_chigoon_02",
			"a_m_m_business_01"
		},
		["vehicles"] = {
			"ambulance",
			"police",
			"futo",
			"sentinel",
		},
	},
}
