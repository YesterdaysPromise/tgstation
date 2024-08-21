
///BSA unlocked by head ID swipes
GLOBAL_VAR_INIT(bsa_unlock, FALSE)

// Crew has to build a bluespace cannon
// Cargo orders part for high price
// Requires high amount of power
// Requires high level stock parts
/datum/station_goal/bluespace_cannon
	name = "Bluespace Artillery"

/datum/station_goal/bluespace_cannon/get_report()
	return list(
		"<blockquote>Our military presence is inadequate in your sector.",
		"We need you to construct BSA-[rand(1,99)] Artillery position aboard your station.",
		"",
		"Base parts are available for shipping via cargo.",
		"-Nanotrasen Naval Command</blockquote>",
	).Join("\n")

/datum/station_goal/bluespace_cannon/on_report()
	//Unlock BSA parts
	var/datum/supply_pack/engineering/bsa/P = SSshuttle.supply_packs[/datum/supply_pack/engineering/bsa]
	P.special_enabled = TRUE

/datum/station_goal/bluespace_cannon/check_completion()
	if(..())
		return TRUE
	var/obj/machinery/bsa/full/B = locate()
	if(B && !B.machine_stat)
		return TRUE
	return FALSE

/obj/machinery/bsa
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	density = TRUE
	anchored = TRUE

/obj/machinery/bsa/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool, time = 1 SECONDS)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/bsa/back
	name = "Bluespace Artillery Generator"
	desc = "Generates cannon pulse. Needs to be linked with a fusor."
	icon_state = "power_box"

/obj/machinery/bsa/back/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/bsa/back/multitool_act(mob/living/user, obj/item/multitool/M)
	M.set_buffer(src)
	balloon_alert(user, "saved to multitool buffer")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/bsa/front
	name = "Bluespace Artillery Bore"
	desc = "Do not stand in front of cannon during operation. Needs to be linked with a fusor."
	icon_state = "emitter_center"

/obj/machinery/bsa/front/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/bsa/front/multitool_act(mob/living/user, obj/item/multitool/M)
	M.set_buffer(src)
	balloon_alert(user, "saved to multitool buffer")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/bsa/middle
	name = "Bluespace Artillery Fusor"
	desc = "Contents classified by Nanotrasen Naval Command. Needs to be linked with the other BSA parts using a multitool."
	icon_state = "fuel_chamber"
	var/datum/weakref/back_ref
	var/datum/weakref/front_ref

/obj/machinery/bsa/middle/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/machinery/bsa/middle/multitool_act(mob/living/user, obj/item/multitool/tool)
	. = NONE

	if(istype(tool.buffer, /obj/machinery/bsa/back))
		back_ref = WEAKREF(tool.buffer)
		to_chat(user, span_notice("You link [src] with [tool.buffer]."))
		tool.set_buffer(null)
		return ITEM_INTERACT_SUCCESS
	else if(istype(tool.buffer, /obj/machinery/bsa/front))
		front_ref = WEAKREF(tool.buffer)
		to_chat(user, span_notice("You link [src] with [tool.buffer]."))
		tool.set_buffer(null)
		return ITEM_INTERACT_SUCCESS

/obj/machinery/bsa/middle/proc/check_completion()
	var/obj/machinery/bsa/front/front = front_ref?.resolve()
	var/obj/machinery/bsa/back/back = back_ref?.resolve()
	if(!front || !back)
		return "No linked parts detected!"
	if(!front.anchored || !back.anchored || !anchored)
		return "Linked parts unwrenched!"
	if(front.y != y || back.y != y || !(front.x > x && back.x < x || front.x < x && back.x > x) || front.z != z || back.z != z)
		return "Parts misaligned!"
	if(!has_space())
		return "Not enough free space!"

/obj/machinery/bsa/middle/proc/has_space()
	var/cannon_dir = get_cannon_direction()
	var/width = 10
	var/offset
	switch(cannon_dir)
		if(EAST)
			offset = -4
		if(WEST)
			offset = -6
		else
			return FALSE

	var/turf/base = get_turf(src)
	for(var/turf/T as anything in CORNER_BLOCK_OFFSET(base, width, 3, offset, -1))
		if(T.density || isspaceturf(T))
			return FALSE
	return TRUE

/obj/machinery/bsa/middle/proc/get_cannon_direction()
	var/obj/machinery/bsa/front/front = front_ref?.resolve()
	var/obj/machinery/bsa/back/back = back_ref?.resolve()
	if(!front || !back)
		return
	if(front.x > x && back.x < x)
		return EAST
	else if(front.x < x && back.x > x)
		return WEST


/obj/machinery/bsa/full
	name = "Bluespace Artillery"
	desc = "Long range bluespace artillery."
	icon = 'icons/obj/machines/cannon.dmi'
	icon_state = "cannon_west"
	var/static/mutable_appearance/top_layer
	var/ex_power = 3
	var/power_used_per_shot = 2000000 //enough to kil standard apc - todo : make this use wires instead and scale explosion power with it
	var/ready
	pixel_y = -32
	pixel_x = -192
	bound_width = 352
	bound_x = -192
	appearance_flags = LONG_GLIDE //Removes default TILE_BOUND

/obj/machinery/bsa/full/wrench_act(mob/living/user, obj/item/I)
	return FALSE

/obj/machinery/bsa/full/proc/get_front_turf()
	switch(dir)
		if(WEST)
			return locate(x - 7,y,z)
		if(EAST)
			return locate(x + 7,y,z)
	return get_turf(src)

/obj/machinery/bsa/full/proc/get_back_turf()
	switch(dir)
		if(WEST)
			return locate(x + 5,y,z)
		if(EAST)
			return locate(x - 5,y,z)
	return get_turf(src)

/obj/machinery/bsa/full/proc/get_target_turf()
	switch(dir)
		if(WEST)
			return locate(1,y,z)
		if(EAST)
			return locate(world.maxx,y,z)
	return get_turf(src)

/obj/machinery/bsa/full/Initialize(mapload, cannon_direction = WEST)
	. = ..()
	switch(cannon_direction)
		if(WEST)
			setDir(WEST)
			icon_state = "cannon_west"
		if(EAST)
			setDir(EAST)
			pixel_x = -128
			bound_x = -128
			icon_state = "cannon_east"
	get_layer()
	reload()

/obj/machinery/bsa/full/proc/get_layer()
	top_layer = mutable_appearance(icon, layer = ABOVE_MOB_LAYER)
	switch(dir)
		if(WEST)
			top_layer.icon_state = "top_west"
		if(EAST)
			top_layer.icon_state = "top_east"
	add_overlay(top_layer)

/obj/machinery/bsa/full/proc/fire(mob/user, turf/bullseye)
	reload()

	var/turf/point = get_front_turf()
	var/turf/target = get_target_turf()
	var/atom/movable/blocker
	for(var/T in get_line(get_step(point, dir), target))
		var/turf/tile = T
		if(SEND_SIGNAL(tile, COMSIG_ATOM_BSA_BEAM) & COMSIG_ATOM_BLOCKS_BSA_BEAM)
			blocker = tile
		else
			for(var/AM in tile)
				var/atom/movable/stuff = AM
				if(SEND_SIGNAL(stuff, COMSIG_ATOM_BSA_BEAM) & COMSIG_ATOM_BLOCKS_BSA_BEAM)
					blocker = stuff
					break
		if(blocker)
			target = tile
			break
		else
			SSexplosions.highturf += tile //also fucks everything else on the turf
	point.Beam(target, icon_state = "bsa_beam", time = 5 SECONDS, maxdistance = world.maxx) //ZZZAP
	new /obj/effect/temp_visual/bsa_splash(point, dir)

	notify_ghosts(
		"The Bluespace Artillery has been fired!",
		source = bullseye,
		header = "KABOOM!",
	)

	if(!blocker)
		message_admins("[ADMIN_LOOKUPFLW(user)] has launched a bluespace artillery strike targeting [ADMIN_VERBOSEJMP(bullseye)].")
		user.log_message("has launched a bluespace artillery strike targeting [AREACOORD(bullseye)].", LOG_GAME)
		explosion(bullseye, devastation_range = ex_power, heavy_impact_range = ex_power*2, light_impact_range = ex_power*4, explosion_cause = src)
	else
		message_admins("[ADMIN_LOOKUPFLW(user)] has launched a bluespace artillery strike targeting [ADMIN_VERBOSEJMP(bullseye)] but it was blocked by [blocker] at [ADMIN_VERBOSEJMP(target)].")
		user.log_message("has launched a bluespace artillery strike targeting [AREACOORD(bullseye)] but it was blocked by [blocker] at [AREACOORD(target)].", LOG_GAME)


/obj/machinery/bsa/full/proc/reload()
	ready = FALSE
	use_energy(power_used_per_shot)
	addtimer(CALLBACK(src,"ready_cannon"), 1 MINUTES)

/obj/machinery/bsa/full/proc/ready_cannon()
	ready = TRUE

/obj/structure/filler
	name = "big machinery part"
	density = TRUE
	anchored = TRUE
	invisibility = INVISIBILITY_ABSTRACT
	var/obj/machinery/parent

/obj/structure/filler/ex_act()
	return FALSE

/obj/machinery/computer/bsa_control
	name = "bluespace artillery control"
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/computer/bsa_control
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "control_boxp"
	icon_keyboard = null
	icon_screen = null

	var/datum/weakref/cannon_ref
	var/notice
	var/target
	var/area_aim = FALSE //should also show areas for targeting

/obj/machinery/computer/bsa_control/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/computer/bsa_control/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BluespaceArtillery", name)
		ui.open()

/obj/machinery/computer/bsa_control/ui_data()
	var/obj/machinery/bsa/full/cannon = cannon_ref?.resolve()
	var/list/data = list()
	data["ready"] = cannon ? cannon.ready : FALSE
	data["connected"] = cannon
	data["notice"] = notice
	data["unlocked"] = GLOB.bsa_unlock
	if(target)
		data["target"] = get_target_name()
	return data

/obj/machinery/computer/bsa_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("build")
			cannon_ref = WEAKREF(deploy())
			. = TRUE
		if("fire")
			if(istype(target, /area) || istype(target, /datum/component/gps))
				fire(usr)
			else
				vessel_fire(usr)
			. = TRUE
		if("recalibrate")
			calibrate(usr)
			. = TRUE
	update_appearance()

/obj/machinery/computer/bsa_control/proc/calibrate(mob/user)
	if(!GLOB.bsa_unlock)
		return
	var/list/gps_locators = list()
	for(var/datum/component/gps/G in GLOB.GPS_list) //nulls on the list somehow
		if(G.tracking)
			gps_locators[G.gpstag] = G

	var/list/options = gps_locators
	if(area_aim)
		options += GLOB.teleportlocs

	var/genericship_target = locate(/datum/round_event/nearby_vessel/neutral/generic) in SSevents.running
	if(genericship_target)
		options += genericship_target.BSA_target_name

	var/victim = tgui_input_list(user, "Select target", "Artillery Targeting", options)
	if(isnull(victim))
		return
	if(isnull(options[victim]))
		return
	target = options[victim]
	log_game("[key_name(user)] has aimed the bluespace artillery strike at [target].")


/obj/machinery/computer/bsa_control/proc/get_target_name()
	if(istype(target, /area))
		return get_area_name(target, TRUE)
	else if(istype(target, /datum/component/gps))
		var/datum/component/gps/G = target
		return G.gpstag
	else
		return target

/obj/machinery/computer/bsa_control/proc/get_impact_turf()
	if(obj_flags & EMAGGED)
		return get_turf(src)
	else if(istype(target, /area))
		return pick(get_area_turfs(target))
	else if(istype(target, /datum/component/gps))
		var/datum/component/gps/G = target
		return get_turf(G.parent)

/obj/machinery/computer/bsa_control/proc/fire(mob/user)
	var/obj/machinery/bsa/full/cannon = cannon_ref?.resolve()
	if(!cannon)
		notice = "No Cannon Exists!"
		return
	if(cannon.machine_stat)
		notice = "Cannon unpowered!"
		return
	notice = null
	var/turf/target_turf = get_impact_turf()
	cannon.fire(user, target_turf)

/obj/machinery/computer/bsa_control/proc/vessel_fire(mob/user)
	var/obj/machinery/bsa/full/cannon = cannon_ref?.resolve()
	if(!cannon)
		notice = "No Cannon Exists!"
		return
	if(cannon.machine_stat)
		notice = "Cannon unpowered!"
		return
	notice = null
	var/datum/bank_account/cargo_bank = SSeconomy.get_dep_account(ACCOUNT_CAR)

	var/datum/vessel_theme/vessel_target = locate(/datum/round_event/nearby_vessel/neutral/generic) in SSevents.running
	if(vessel_target)
		/datum/round_event/nearby_vessel/neutral/generic.kill()

	switch(target)
		if("Nanotrasen Vessel")
			priority_announce(pick("If we are reading it right, some kind of horrible missfire just happend or you let some idiot fiddle with one of the best station-mounted weapons avaible to us... Guess who will pay for damages?",\
			"Really, guys, you can't handle a hyperadvanced bluespace artillery cannon properly?! It's not rocket science! Well, it kinda is, but... egh. Off goes your money.",\
			"Do you have any idea how much paperwork will this little accident cost us? How about we show you by subtracting it straight from you? Someone will have to really answer for this..."), "Nanotrasen Naval Command")
			cargo_bank.adjust_money(rand(-100000, -50000))
			return
		if ("Foreign Corporate Entity's Vessel")
			priority_announce(pick("Your level of idiocy will cost you highly. Do you have any idea how hard it is to sweep 'accidents' like this under the rug?!", \
			"With a little bit of luck, they will not miss that ship much. With lack therof... You will all be in debt for couple of years to come."), "Nanotrasen Naval Command")
			cargo_bank.adjust_money(rand(-100000, -25000))
			return
		if ("Spinward Sector's Vessel")
			priority_announce(pick("Only thing saving your sorry assess is that civillains shouldn't really be here in the first place. The clean-up fee is still on you, though.", \
			"We'll have to hire Interdyne Corpse Retrival agents for this mess, and they cost us an arm and a leg... Especially if we want those civillains to not remember your little missconduit."), "Nanotrasen Naval Command")
			cargo_bank.adjust_money(rand(-50000, -10000))
			return
		if ("Syndicate Vessel")
			priority_announce(pick("A good shot! Don't expect any fanfare though, for all intents and purposes we are 'neutral' with syndicate parties. If anyone asks, this was just an accident.", \
			"Syndicate Vessel down. For the sake of 'neutrality' and plausible deniability we can't pay you for it... But feel free to 'clear up' any of their scrap coming your way."), "Nanotrasen Naval Command")
			return
		if ("Clown Vessel")
			if(user.job == JOB_MIME)
				user.client.give_award(/datum/award/achievement/misc/unspeakable_crimes, user)
			priority_announce(pick("That will require a lot of PR work with the Clown Planet, and it won't be easy... We'll have you pay up for it.", \
			"Yes, clown vessels often use white and red plating in circular pattern, buy it's because that's what circusses used to look like, not to form a bullseye! It's basics of BSA usage manual!"), "Nanotrasen Naval Command")
			cargo_bank.adjust_money(rand(-75000, -25000))
			return
		if ("Pirate Vessel")
			priority_announce(pick("You really didn't have to shoot *someone* with that BSA to test it, you know? But serves those pirates about right. We'll check if there was some bounty on them and transfer you a cut. 15% should suffice?", \
			"Well-shot. We'll transfer your cut of the bounty for those pirates now."), "Nanotrasen Naval Command")
			cargo_bank.adjust_money(rand(2500, 7500))
			return
		if ("Golem Vessel")
			priority_announce(pick("You really didn't have to shoot *someone* with that BSA to test it, you know? But serves those pirates about right. We'll check if there was some bounty on them and transfer you a cut. 15% should suffice?", \
			"Well-shot. We'll transfer your cut of the bounty for those pirates now."), "Nanotrasen Naval Command")
			cargo_bank.adjust_money(rand(2500, 7500))
			return
		if ("Uknown Vessel")
			if(prob(60))
				priority_announce(pick("You really didn't have to shoot *someone* with that BSA to test it, you know? But serves those pirates about right. We'll check if there was some bounty on them and transfer you a cut. 15% should suffice?", \
			"Well-shot. We'll transfer your cut of the bounty for those pirates now."), "Nanotrasen Naval Command")
			else
				if(prob(50))
					priority_announce(pick("You just shot a *very* expensive prototype cloaking ship we've been developing for the last 30 years... We are smart enough to have a backup or two, and the fact you we are able to shoot it all will provide research data, but... It will cost you."), "Nanotrasen Naval Command")
					cargo_bank.adjust_money(rand(-100000, -50000))
				else
					priority_announce(pick("It seems that ship was syndicate-aligned intelligence gatherer. Due to the strengths of its encryption we can only assume it comes from entity known as MI13. More-over... it seems like its destruction initiated a Ion Purge, brace for impact. Here's to cover for it."), "Nanotrasen Naval Command")
					cargo_bank.adjust_money(rand(2500, 5000))
			return

/obj/machinery/computer/bsa_control/proc/deploy(force=FALSE)
	var/obj/machinery/bsa/full/prebuilt = locate() in range(7) //In case of adminspawn
	if(prebuilt)
		return prebuilt

	var/obj/machinery/bsa/middle/centerpiece = locate() in range(7)
	if(!centerpiece)
		notice = "No BSA parts detected nearby."
		return null
	notice = centerpiece.check_completion()
	if(notice)
		return null
	//Totally nanite construction system not an immersion breaking spawning
	var/datum/effect_system/fluid_spread/smoke/fourth_wall_guard = new
	fourth_wall_guard.set_up(4, holder = src, location = get_turf(centerpiece))
	fourth_wall_guard.start()
	var/obj/machinery/bsa/full/cannon = new(get_turf(centerpiece),centerpiece.get_cannon_direction())
	QDEL_NULL(centerpiece.front_ref)
	QDEL_NULL(centerpiece.back_ref)
	qdel(centerpiece)
	return cannon
/obj/machinery/computer/bsa_control/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	balloon_alert(user, "rigged to explode")
	to_chat(user, span_warning("You emag [src] and hear the focusing crystal short out. You get the feeling it wouldn't be wise to stand near [src] when the BSA fires..."))
	return TRUE
