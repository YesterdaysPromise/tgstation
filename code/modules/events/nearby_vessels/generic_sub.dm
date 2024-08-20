/datum/round_event_control/nearby_vessel/autodestruct
	name = "Debree Wave"
	typepath = /datum/round_event/meteor_wave
	weight = 4
	min_players = 15
	max_occurrences = 0
	category = EVENT_CATEGORY_SPACE
	description = "A space vessel orbitting the station spontaniously blows up! Doesn't work if there is no vessel, though, obviously."
	map_flags = EVENT_SPACE_ONLY





/datum/round_event_control/nearby_vessel/debree_wave
	name = "Debree Wave"
	typepath = /datum/round_event/meteor_wave
	weight = 4
	min_players = 15
	max_occurrences = 0
	category = EVENT_CATEGORY_SPACE
	description = "Items and scrap-metoers fly towards the station. Happens whenever a nearby vessel blows up, or is blown up. Might also happen on debris field."
	map_flags = EVENT_SPACE_ONLY
