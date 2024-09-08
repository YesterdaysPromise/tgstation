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
			intrest()
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

/datum/round_event/dialogue/howitgoing/proc/intrest()
	dialogue = new("Really? Damn. Don't envy you on that. Mind sharing your camera feed key so we here can see what's going on in there? Surely would keep up my crew's spirit, if at your expense.", list("Sure, just don't share it.","That'd be a breach of safety."))
	dialogue.answer_callback = CALLBACK(src, PROC_REF(intrest_answered))
	GLOB.communications_controller.send_message(dialogue, unique = TRUE)

/datum/round_event/dialogue/howitgoing/proc/intrest_answered()
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
			intrest()
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
				nt_intervention()

/datum/round_event/dialogue/howitgoing/proc/dissapointment()
	dialogue = new("This... Seems rather boring to me. Are you even more boring normally, or what? Put it on my telescreens and my crew claims they’d prefer static...", list("Sorry, I guess.","Better than nothing, no?"))
	dialogue.answer_callback = CALLBACK(src, PROC_REF(dissapointment_answer))
	GLOB.communications_controller.send_message(dialogue, unique = TRUE)
	malice += 10

/datum/round_event/dialogue/howitgoing/proc/dissapointment_answer()
	switch(dialogue.answered)
		if(1)
			if(prob(50))
				malice -= 5
			if(prob(malice))
				nt_intervention()
		if(2)
			if(prob(20))
				malice -= 20
			if(prob(malice))
				nt_intervention()

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
	switch(variant)
		if(1)
			GLOB.communications_controller.send_message("Tedious and boring all-round, huh? At least know we are comrades in that. Ugh, here, sending a bunch 'o toys for your crews perusal. Maybe you'll menage to squeeze out some entertainment out of them, haven’t landed well with us.", unique = TRUE)

			return
		if(2)
			GLOB.communications_controller.send_message("Quite the chaos there! My crew is watching it like a good mix of sitcom and action movie. Have some money for the trouble.", unique = TRUE)
			cargo_bank.adjust_money(2000)
		if(3)
			GLOB.communications_controller.send_message("You got all that going on and still menage to send a message, huh? Quite admirable. Here, have the payment for the entertainment... and to repair the damages..", unique = TRUE)
			cargo_bank.adjust_money(5000)
	if(prob(malice))
		nt_intervention()

/datum/round_event/dialogue/howitgoing/proc/nt_intervention()
