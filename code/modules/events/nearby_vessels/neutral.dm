/datum/round_event_control/nearby_vessel/neutral/generic
	name = "Generic Neutral Vessel Arrival"
	typepath = /datum/round_event/nearby_vessel/neutral/generic
	max_occurrences = 2
	min_players = 5
	category = EVENT_CATEGORY_VESSEL
	description = "Ship enters the orbit. Triggers sub-events more often than other ships, but does nothing, nor has any unique of its own."

/datum/round_event/nearby_vessel/neutral/generic
	var/BSA_target_name
	var/generic_vessel_theme
	var/datum/vessel_theme/theme
	var/ship

/datum/round_event/nearby_vessel/neutral/generic/setup()
	end_when = rand(600, 1200)
	generic_vessel_theme = pick(vessel_theme)
	theme = GLOB.vessel_theme_to_datum[generic_vessel_theme]
	ship = pick(theme.genericship_types)
	BSA_target_name = (theme.BSA_target_name)

/datum/round_event/nearby_vessel/neutral/generic/announce(fake)
	var/arrived = pick(arrival_type)
	var/reason = pick(arrival_reason)
	priority_announce(pick("Due to [reason], [ship] seems to have [arrived] into [station_name()]'s system.",\
	"Attention, [ship] has been detected in [station_name()]'s proximity.",\
	"Sensors detect that [ship] has [arrived] somewhere within fire range but far outside of boarding distance of the station.",\
	"We've just recieved intel that due to [reason], your system should soon be visited by [ship]."), "Automated Arrival Announcer",)

/datum/round_event/nearby_vessel/neutral/generic/tick()
