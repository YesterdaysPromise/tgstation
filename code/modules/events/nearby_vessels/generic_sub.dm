/datum/round_event_control/autodestruct
	name = "Autodesruction"
	typepath = /datum/round_event/meteor_wave
	weight = 4
	min_players = 15
	max_occurrences = 0
	category = EVENT_CATEGORY_SPACE
	description = "A space vessel orbitting the station spontaniously blows up! Doesn't work if there is no vessel, though, obviously."
	map_flags = EVENT_SPACE_ONLY

/datum/round_event_control/debree_wave
	name = "Debree Wave"
	typepath = /datum/round_event/meteor_wave
	weight = 4
	min_players = 15
	max_occurrences = 0
	category = EVENT_CATEGORY_SPACE
	description = "Items and scrap-metoers fly towards the station. Happens whenever a nearby vessel blows up, or is blown up. Might also happen on debris field."
	map_flags = EVENT_SPACE_ONLY

///This one should go last because its bit wordy. Dialogue, duh.

///
/datum/round_event_control/dialogue
	name = "Dialogue"
	typepath = /datum/round_event/meteor_wave
	weight = 4
	min_players = 15
	max_occurrences = 0
	category = EVENT_CATEGORY_SPACE
	description = "A series of nearby vessel sub events which send dialogues to comms console of the station. Some answers lead to rewards, some, to punishments."



/datum/round_event_control/dialogue/howitgoing
	typepath = /datum/round_event/dialogue/howitgoing


/datum/round_event/dialogue/howitgoing
	var/datum/comm_message/dialogue

/datum/round_event/dialogue/howitgoing/announce(fake)
	priority_announce("Incoming subspace communication. Secure channel opened at all communication consoles.", "Incoming Message", SSstation.announcer.get_rand_report_sound())

/datum/round_event/dialogue/howitgoing/start()
	dialogue = new("How is it going?", "Hey ugh, how are you doing there? Bit boring work day here, so looking for something interesting to talk with the crew about.", list("It's rather hectic.","Rather boring shift here.", "I don't think I can disclouse that."))
	dialogue.answer_callback = CALLBACK(src, PROC_REF(answered))
	GLOB.communications_controller.send_message(dialogue, unique = TRUE)

/datum/round_event/dialogue/howitgoing/proc/answered()
	if(insurance_message && insurance_message.answered == 1)
