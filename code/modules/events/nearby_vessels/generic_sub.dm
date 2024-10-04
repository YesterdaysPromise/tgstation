/datum/round_event_control/autodestruct
	name = "Autodesruction"
	typepath = /datum/round_event/meteor_wave
	weight = 0
	min_players = 10
	max_occurrences = 0
	category = EVENT_CATEGORY_SPACE
	description = "A space vessel orbitting the station spontaniously blows up! Doesn't work if there is no vessel, though, obviously."
	map_flags = EVENT_SPACE_ONLY

/datum/round_event_control/debris_wave
	name = "debris Wave"
	typepath = /datum/round_event/meteor_wave
	weight = 8
	min_players = 15
	max_occurrences = 0
	earliest_start = 5 MINUTES
	category = EVENT_CATEGORY_SPACE
	description = "Items and scrap-metoers fly towards the station. Happens whenever a nearby vessel blows up, or is blown up. Might also happen on debris field."
	map_flags = EVENT_SPACE_ONLY

///Most of this is shamelessy stolen from meteor wave, since its similiar in principle and premise. I will clobber you if you object.
/datum/round_event/debris_wave
	start_when = 6
	end_when = 66
	announce_when = 1
	var/list/debris_type
	var/debris_name = "generic"
	///overall 'cost' of the items we throw at the station.
	var/item_bank = 10
	/// cost deducted on the throw.
	var/item_spendings = 1
	/// the item we are throwing.
	var/obj/item
	var/selected_item
	///
	var/turf/item_spawn
	var/turf/item_target
	///
	var/datum/debris/debris_list


/datum/round_event/debris_wave/New()
	..()
	if(!debris_type)
		determine_wave_type()

/datum/round_event/debris_wave/proc/determine_wave_type()
	if(!debris_name)
		debris_name = pick_weight(list(
			"generic" = 50,
			"techy" = 40,
			"nanotrasen" = 10))
	switch(debris_name)
		if("nanotrasen")
			debris_type = GLOB.meteors_debris_nt
			if(STATION_TIME_PASSED() > 25 MINUTES)
				if(prob(60))
					debris_type += GLOB.meteors_debris_generic
				else
					debris_type += GLOB.meteors_debris_nt
		if("clown")
			debris_type = GLOB.meteors_debris_clown
			if(STATION_TIME_PASSED() > 25 MINUTES)
				if(prob(60))
					debris_type += GLOB.meteors_debris_generic
				else
					debris_type += GLOB.meteors_debris_nt
		if("syndicate")
			debris_type = GLOB.meteors_debris_syndicate
			if(STATION_TIME_PASSED() > 25 MINUTES)
				if(prob(60))
					debris_type += GLOB.meteors_debris_syndicate
				else
					debris_type += GLOB.meteors_debris_generic

		else
			debris_type = GLOB.meteors_debris_generic
			if(STATION_TIME_PASSED() > 25 MINUTES)
				debris_type += GLOB.meteors_debris_generic
	if(debris_name == "techy")
		item_bank += 5
	if(STATION_TIME_PASSED() > 10 MINUTES)
		item_bank += 5
	if(STATION_TIME_PASSED() > 30 MINUTES)
		item_bank += 5

	item_bank += rand(5, 10)

/datum/round_event/debris_wave/tick()
	if(ISMULTIPLE(activeFor, 3))
		spawn_meteors(1, debris_type) //meteor list types defined in gamemode/meteor/meteors.dm

		///Throws items at the station
		if(item_bank > 1)
			item_spendings = rand(0, item_bank/2)
		else
			item_spendings = 1


		while(item_spendings > 0)

			item_spawn = get_edge_target_turf()
			item_target = get_random_station_turf()

			switch(debris_name)
				if("nanotrasen")
					if(prob(0.1) || item_spendings > 4)
						item = new /obj/item/banner (item_spawn)
						item_spendings -= 5
					else if(prob(25) || item_spendings > 2)
						selected_item = pick(debris_list.rare)
						item =  new selected_item (item_spawn)
						item_spendings -= 3
					else if(prob(50) || item_spendings > 1)
						selected_item = pick(debris_list.uncommon)
						item =  new selected_item (item_spawn)
						item_spendings -= 2
					else
						selected_item = pick(debris_list.common)
						item = new selected_item (item_spawn)
						item_spendings -= 1

			item.throw_at(item_target, 3, 3, spin = FALSE)

/datum/debris
	var/common
	var/uncommon
	var/rare

/datum/round_event_control/debris_wave/generic
	name = "Generic debris Wave"
	typepath = /datum/round_event/debris_wave/generic

/datum/round_event/debris_wave/generic
	debris_name = "generic"
	debris_list = /datum/debris/generic

/datum/debris/generic
	common = list(/obj/item/stack/sheet/iron/fifty = 1,
		/obj/effect/mob_spawn/corpse/human/assistant = 1,
		/obj/item/storage/toolbox/emergency = 1,
		/obj/structure/closet = 2,
		/obj/structure/closet/crate = 2,
		/obj/item/tank/internals/emergency_oxygen = 3,
		/obj/item/stack/sheet/mineral/plasma/five = 3,
		/obj/item/stack/sheet/iron/twenty = 3,
		/obj/item/paper_bin = 4,
	)
	uncommon = list(/obj/item/card/id/advanced/technician_id = 1,
		/obj/item/assembly/flash = 1,
		/obj/item/stack/rods/fifty = 1,
		/obj/item/stack/sheet/mineral/plasma/thirty = 2,
		/obj/item/stack/sheet/plasteel/twenty = 2,
		/obj/item/stack/rods/twentyfive = 3,
	)
	rare = list(/obj/item/tank/jetpack/carbondioxide = 0.1,
		/obj/item/gun/energy/e_gun/mini = 0.9,
		/obj/item/stack/tile/carpet/executive/thirty = 2,
		/obj/item/relic = 2,
	)

/datum/round_event_control/debris_wave/techy
	name = "Techy debris Wave"
	typepath = /datum/round_event/debris_wave/techy

/datum/round_event/debris_wave/techy
	debris_name = "techy"
	debris_list = /datum/debris/techy

/datum/debris/techy
	common = list(/obj/item/stack/sheet/iron/fifty = 1,
		/obj/effect/mob_spawn/corpse/human/assistant = 1,
		/obj/item/storage/toolbox/emergency = 1,
		/obj/structure/closet = 2,
		/obj/structure/closet/crate = 2,
		/obj/item/tank/internals/emergency_oxygen = 3,
		/obj/item/stack/sheet/mineral/plasma/five = 3,
		/obj/item/stack/sheet/iron/twenty = 3,
		/obj/item/paper_bin = 4,
	)
	uncommon = list(/obj/item/card/id/advanced/technician_id = 1,
		/obj/item/assembly/flash = 1,
		/obj/item/stack/rods/fifty = 1,
		/obj/item/stack/sheet/mineral/plasma/thirty = 2,
		/obj/item/stack/sheet/plasteel/twenty = 2,
		/obj/item/stack/rods/twentyfive = 3,
	)
	rare = list(/obj/item/tank/jetpack/carbondioxide = 0.1,
		/obj/item/gun/energy/e_gun/mini = 0.9,
		/obj/item/stack/tile/carpet/executive/thirty = 2,
		/obj/item/relic = 2,
	)

/datum/round_event_control/debris_wave/nanotrasen
	name = "Nanotrasen debris Wave"
	typepath = /datum/round_event/debris_wave/nanotrasen

/datum/round_event/debris_wave/nanotrasen
	debris_name = "nanotrasen"
	debris_list = /datum/debris/nanotrasen

/datum/debris/nanotrasen
	common = list(/obj/item/stack/sheet/iron/fifty = 1,
		/obj/effect/mob_spawn/corpse/human/assistant = 1,
		/obj/item/storage/toolbox/emergency = 1,
		/obj/structure/closet = 2,
		/obj/structure/closet/crate = 2,
		/obj/item/tank/internals/emergency_oxygen = 3,
		/obj/item/stack/sheet/mineral/plasma/five = 3,
		/obj/item/stack/sheet/iron/twenty = 3,
		/obj/item/paper_bin = 4,
	)
	uncommon = list(/obj/item/card/id/advanced/technician_id = 1,
		/obj/item/assembly/flash = 1,
		/obj/item/stack/rods/fifty = 1,
		/obj/item/stack/sheet/mineral/plasma/thirty = 2,
		/obj/item/stack/sheet/plasteel/twenty = 2,
		/obj/item/stack/rods/twentyfive = 3,
	)
	rare = list(/obj/item/tank/jetpack/carbondioxide = 0.1,
		/obj/item/gun/energy/e_gun/mini = 0.9,
		/obj/item/stack/tile/carpet/executive/thirty = 2,
		/obj/item/relic = 2,
	)

/datum/round_event_control/debris_wave/clown
	name = "Clown debris Wave"
	weight = 6
	typepath = /datum/round_event/meteor_wave

/datum/round_event/debris_wave/clown
	debris_name = "clown"
	debris_list = /datum/debris/clown

/datum/debris/clown
	common = list(/obj/item/stack/sheet/iron/fifty = 1,
		/obj/effect/mob_spawn/corpse/human/assistant = 1,
		/obj/item/storage/toolbox/emergency = 1,
		/obj/structure/closet = 2,
		/obj/structure/closet/crate = 2,
		/obj/item/tank/internals/emergency_oxygen = 3,
		/obj/item/stack/sheet/mineral/plasma/five = 3,
		/obj/item/stack/sheet/iron/twenty = 3,
		/obj/item/paper_bin = 4,
	)
	uncommon = list(/obj/item/card/id/advanced/technician_id = 1,
		/obj/item/assembly/flash = 1,
		/obj/item/stack/rods/fifty = 1,
		/obj/item/stack/sheet/mineral/plasma/thirty = 2,
		/obj/item/stack/sheet/plasteel/twenty = 2,
		/obj/item/stack/rods/twentyfive = 3,
	)
	rare = list(/obj/item/tank/jetpack/carbondioxide = 0.1,
		/obj/item/gun/energy/e_gun/mini = 0.9,
		/obj/item/stack/tile/carpet/executive/thirty = 2,
		/obj/item/relic = 2,
	)

/datum/round_event_control/debris_wave/syndicate
	name = "Syndicate debris Wave"
	weight = 4
	typepath = /datum/round_event/debris_wave/syndicate

/datum/round_event/debris_wave/syndicate
	debris_name = "syndicate"
	debris_list = /datum/debris/syndicate

/datum/debris/syndicate
	common = list(/obj/item/stack/sheet/iron/fifty = 1,
		/obj/effect/mob_spawn/corpse/human/assistant = 1,
		/obj/item/storage/toolbox/emergency = 1,
		/obj/structure/closet = 2,
		/obj/structure/closet/crate = 2,
		/obj/item/tank/internals/emergency_oxygen = 3,
		/obj/item/stack/sheet/mineral/plasma/five = 3,
		/obj/item/stack/sheet/iron/twenty = 3,
		/obj/item/paper_bin = 4,
	)
	uncommon = list(/obj/item/card/id/advanced/technician_id = 1,
		/obj/item/assembly/flash = 1,
		/obj/item/stack/rods/fifty = 1,
		/obj/item/stack/sheet/mineral/plasma/thirty = 2,
		/obj/item/stack/sheet/plasteel/twenty = 2,
		/obj/item/stack/rods/twentyfive = 3,
	)
	rare = list(/obj/item/tank/jetpack/carbondioxide = 0.1,
		/obj/item/gun/energy/e_gun/mini = 0.9,
		/obj/item/stack/tile/carpet/executive/thirty = 2,
		/obj/item/relic = 2,
	)

/datum/round_event_control/debris_wave/magicky
	name = "Magicky debris Wave"
	weight = 2
	typepath = /datum/round_event/debris_wave/magicky

/datum/round_event/debris_wave/magicky
	debris_list = /datum/debris/magicky

/datum/debris/magicky
	common = list(/obj/item/stack/sheet/iron/fifty = 1,
		/obj/effect/mob_spawn/corpse/human/assistant = 1,
		/obj/item/storage/toolbox/emergency = 1,
		/obj/structure/closet = 2,
		/obj/structure/closet/crate = 2,
		/obj/item/tank/internals/emergency_oxygen = 3,
		/obj/item/stack/sheet/mineral/plasma/five = 3,
		/obj/item/stack/sheet/iron/twenty = 3,
		/obj/item/paper_bin = 4,
	)
	uncommon = list(/obj/item/card/id/advanced/technician_id = 1,
		/obj/item/assembly/flash = 1,
		/obj/item/stack/rods/fifty = 1,
		/obj/item/stack/sheet/mineral/plasma/thirty = 2,
		/obj/item/stack/sheet/plasteel/twenty = 2,
		/obj/item/stack/rods/twentyfive = 3,
	)
	rare = list(/obj/item/tank/jetpack/carbondioxide = 0.1,
		/obj/item/gun/energy/e_gun/mini = 0.9,
		/obj/item/stack/tile/carpet/executive/thirty = 2,
		/obj/item/relic = 2,
	)

/datum/round_event_control/debris_wave/enigmatic
	name = "Enignatic debris Wave"
	weight = 2
	typepath = /datum/round_event/debris_wave/enigmatic

/datum/round_event/debris_wave/enigmatic
	debris_list = /datum/debris/enigmatic

/datum/debris/enigmatic
	common = list(/obj/item/stack/sheet/iron/fifty = 1,
		/obj/effect/mob_spawn/corpse/human/assistant = 1,
		/obj/item/storage/toolbox/emergency = 1,
		/obj/structure/closet = 2,
		/obj/structure/closet/crate = 2,
		/obj/item/tank/internals/emergency_oxygen = 3,
		/obj/item/stack/sheet/mineral/plasma/five = 3,
		/obj/item/stack/sheet/iron/twenty = 3,
		/obj/item/paper_bin = 4,
	)
	uncommon = list(/obj/item/card/id/advanced/technician_id = 1,
		/obj/item/assembly/flash = 1,
		/obj/item/stack/rods/fifty = 1,
		/obj/item/stack/sheet/mineral/plasma/thirty = 2,
		/obj/item/stack/sheet/plasteel/twenty = 2,
		/obj/item/stack/rods/twentyfive = 3,
	)
	rare = list(/obj/item/tank/jetpack/carbondioxide = 0.1,
		/obj/item/gun/energy/e_gun/mini = 0.9,
		/obj/item/stack/tile/carpet/executive/thirty = 2,
		/obj/item/relic = 2,
	)

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

/// How is it going?
/datum/round_event_control/dialogue/howitgoing
	typepath = /datum/round_event/dialogue/howitgoing

/datum/round_event/dialogue/howitgoing
	var/datum/comm_message/dialogue
	var/malice = 25
/datum/round_event/dialogue/howitgoing/announce(fake)
	priority_announce("Incoming subspace communication. Secure channel opened at all communication consoles.", "Incoming Message", SSstation.announcer.get_rand_report_sound())

/datum/round_event/dialogue/howitgoing/start()
	dialogue = new("How is it going?", "Hey ugh, how are you doing there? Bit boring work day here, so looking for something interesting to talk with the crew about.", list("It's rather hectic.","Rather boring shift here.", "I don't think I can disclouse that."))
	dialogue.answer_callback = CALLBACK(src, PROC_REF(start_answered))
	GLOB.communications_controller.send_message(dialogue, unique = TRUE)

/datum/round_event/dialogue/howitgoing/proc/start_answered()
	switch(dialogue.answered)
		if(1)
			interest()
		if(2)
			if(prob(60))
				dead_end(1)
			else
				gift(1)
		if(3)
			if(prob(50))
				dead_end(2)
			else
				oh_please()

/datum/round_event/dialogue/howitgoing/proc/interest()
	dialogue = new("Really? Damn. Don't envy you on that. Mind sharing your camera feed key so we here can see what's going on in there? Surely would keep up my crew's spirit, if at your expense.", list("Sure, just don't share it.","That'd be a breach of safety."))
	dialogue.answer_callback = CALLBACK(src, PROC_REF(interest_answered))
	GLOB.communications_controller.send_message(dialogue, unique = TRUE)

/datum/round_event/dialogue/howitgoing/proc/interest_answered()
	switch(dialogue.answered)
		if(1)
			if(prob(malice))
				if(prob(malice))
					nt_intervention()
			else
				if(prob(10))
					dead_end(4)

				if(SSdynamic.threat_level < rand(20, 30))
					dissapointment()

				if(prob(SSdynamic.threat_level))
					gift(3)
				else
					gift(2)
		if(2)
			if(prob(10 + malice))
				suspicious_question()
			else
				dead_end(3)

/datum/round_event/dialogue/howitgoing/proc/oh_please()
	dialogue = new("Oh please, most captains sneakily do things more out-of-protocol than that. It's just for innocent entertainment's sake. What harm could it do?", list("Fine, we have issues.","It's just a boring shift anyway.", "You sound awfully fishy."))
	dialogue.answer_callback = CALLBACK(src, PROC_REF(please_answered))
	GLOB.communications_controller.send_message(dialogue, unique = TRUE)
	malice += 15

/datum/round_event/dialogue/howitgoing/proc/please_answered()
	switch(dialogue.answered)
		if(1)
			interest()
		if(2)
			if(prob(60))
				dead_end(1)
			else
				gift(1)
		if(3)
			if(prob(10 + malice))
				suspicious_question()
			else
				dead_end(3)

/datum/round_event/dialogue/howitgoing/proc/suspicious_question()
	dialogue = new("Oh no, no. Just wish to play some videos from your camera-feed for my bored crewmates. Just give me the access and I won't bother you again.", list("No.","Alright, fine."))
	dialogue.answer_callback = CALLBACK(src, PROC_REF(suspicious_answer))
	GLOB.communications_controller.send_message(dialogue, unique = TRUE)

/datum/round_event/dialogue/howitgoing/proc/suspicious_answer()
	switch(dialogue.answered)
		if(2)
			malice+=10
			if(prob(malice))
				addtimer(CALLBACK(src, PROC_REF(nt_intervention), rand(5, 20) MINUTES))

/datum/round_event/dialogue/howitgoing/proc/dissapointment()
	dialogue = new("This... Seems rather boring to me. Are you even more boring normally, or what? Put it on my telescreens and my crew claims they'd prefer static...", list("Sorry, I guess.","Better than nothing, no?"))
	dialogue.answer_callback = CALLBACK(src, PROC_REF(dissapointment_answer))
	GLOB.communications_controller.send_message(dialogue, unique = TRUE)
	malice += 10

/datum/round_event/dialogue/howitgoing/proc/dissapointment_answer()
	switch(dialogue.answered)
		if(1)
			if(prob(50))
				malice -= 5
			if(prob(malice))
				addtimer(CALLBACK(src, PROC_REF(nt_intervention), rand(5, 20) MINUTES))
		if(2)
			if(prob(20))
				malice -= 20
			if(prob(malice))
				addtimer(CALLBACK(src, PROC_REF(nt_intervention), rand(5, 20) MINUTES))

/datum/round_event/dialogue/howitgoing/proc/dead_end(variant)
	switch(variant)
		if(1)
			GLOB.communications_controller.send_message("Fair enough. Can't do much with that information though...", unique = TRUE)
		if(2)
			GLOB.communications_controller.send_message("Oh well, damn. Guess not only a boring day, but also an unlucky one. Hope you have a good one, though as you say, can't know.", unique = TRUE)
		if(3)
			GLOB.communications_controller.send_message("Eegh. Fair enough. Have a good rest of your shift, I suppose.", unique = TRUE)
		if(4)
			GLOB.communications_controller.send_message("Damn it, somethings interfering with the feed transfer. Unlucky I guess... Well, can't do much with this static, will have to figure something else to entertain the crew. Still, thanks.", unique = TRUE)

/datum/round_event/dialogue/howitgoing/proc/gift(variant)
	var/datum/bank_account/cargo_bank = SSeconomy.get_dep_account(ACCOUNT_CAR)
	switch(variant)
		if(1)
			GLOB.communications_controller.send_message("Tedious and boring all-round, huh? At least know we are comrades in that. Ugh, here, sending a bunch 'o toys for your crews perusal. Maybe you'll menage to squeeze out some entertainment out of them, haven't landed well with us.", unique = TRUE)
			send_supply_pod_to_area(/obj/structure/closet/crate/robust/toys, /area/station/command/bridge, pod_type = /obj/structure/closet/supplypod)
			return
		if(2)
			GLOB.communications_controller.send_message("Quite the chaos there! My crew is watching it like a good mix of sitcom and action movie. Have some money for the trouble.", unique = TRUE)
			cargo_bank.adjust_money(2000)
		if(3)
			GLOB.communications_controller.send_message("You got all that going on and still menage to send a message, huh? Quite admirable. Here, have the payment for the entertainment... and to repair the damages..", unique = TRUE)
			cargo_bank.adjust_money(5000)
	if(prob(malice))
		addtimer(CALLBACK(src, PROC_REF(nt_intervention), rand(5, 20) MINUTES))

/datum/round_event/dialogue/howitgoing/proc/nt_intervention()
	var/datum/bank_account/cargo_bank = SSeconomy.get_dep_account(ACCOUNT_CAR)
	priority_announce("The camera footage of the station got leaked, causing a massive security hazard. Though our cybersecurity team acted quickly mitaging major breaches, the source of the breach was traced to your comms console. You will be fined heavily for this.")
	cargo_bank.adjust_money(-8000)
	SSdynamic.threat_level += 10
