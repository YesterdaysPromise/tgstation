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
	map_flags = EVENT_SPACE_ONLY



/datum/round_event_control/dialogue
	typepath = /datum/round_event/meteor_wave






/datum/round_event/dialogue
	var/ship_name = "\"In the Unlikely Event\""
	var/datum/comm_message/dialogue

/datum/round_event/dialogue/announce(fake)
	priority_announce("Incoming subspace communication. Secure channel opened at all communication consoles.", "Incoming Message", SSstation.announcer.get_rand_report_sound())

/datum/round_event/dialogue/setup()
	ship_name = pick(strings(PIRATE_NAMES_FILE, "rogue_names"))

/datum/round_event/dialogue/start()
	insurance_message = new("Shuttle Insurance", "Hey, pal, this is the [ship_name]. Can't help but notice you're rocking a wild and crazy shuttle there with NO INSURANCE! Crazy. What if something happened to it, huh?! We've done a quick evaluation on your rates in this sector and we're offering [insurance_evaluation] to cover for your shuttle in case of any disaster.", list("Purchase Insurance.","Reject Offer."))
	insurance_message.answer_callback = CALLBACK(src, PROC_REF(answered))
	GLOB.communications_controller.send_message(insurance_message, unique = TRUE)

/datum/round_event/dialogue/proc/answered()
	if(EMERGENCY_AT_LEAST_DOCKED)
		priority_announce("You are definitely too late to purchase insurance, my friends. Our agents don't work on site.",sender_override = ship_name, color_override = "red")
		return
	if(insurance_message && insurance_message.answered == 1)
		var/datum/bank_account/station_balance = SSeconomy.get_dep_account(ACCOUNT_CAR)
		if(!station_balance?.adjust_money(-insurance_evaluation))
			priority_announce("You didn't send us enough money for shuttle insurance. This, in the space layman's terms, is considered scamming. We're keeping your money, scammers!", sender_override = ship_name, color_override = "red")
			return
		priority_announce("Thank you for purchasing shuttle insurance!", sender_override = ship_name, color_override = "red")
		SSshuttle.nearby_vessel/dialogue = TRUE
