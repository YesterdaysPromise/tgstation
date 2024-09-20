/**
 * # Techweb Node
 *
 * A datum representing a researchable node in the techweb.
 *
 * Techweb nodes are GLOBAL, there should only be one instance of them in the game. Persistant
 * changes should never be made to them in-game. USE SSRESEARCH PROCS TO OBTAIN REFERENCES.
 * DO NOT REFERENCE OUTSIDE OF SSRESEARCH OR YOU WILL FUCK UP GC.
 */
/datum/techweb_node
	/// Internal ID of the node
	var/id
	/// The name of the node as it is shown on UIs
	var/display_name = "Errored Node"
	/// A description of the node to show on UIs
	var/description = "Why are you seeing this?"
	/// Whether it starts off hidden
	var/hidden = FALSE
	/// If the tech can be randomly generated by BEPIS tech as a reward. Meant to be fully given in tech disks, not researched
	var/experimental = FALSE
	/// Whether it's available without any research
	var/starting_node = FALSE
	var/list/prereq_ids = list()
	var/list/design_ids = list()
	/// CALCULATED FROM OTHER NODE'S PREREQUISITIES. Associated list id = TRUE
	var/list/unlock_ids = list()
	/// List of items you need to deconstruct to unlock this node.
	var/list/required_items_to_unlock = list()
	/// Boosting this will autounlock this node
	var/autounlock_by_boost = TRUE
	/// The points cost to research the node, type = amount
	var/list/research_costs = list()
	/// The category of the node
	var/category = "Misc"
	/// The list of experiments required to research the node
	var/list/required_experiments = list()
	/// If completed, these experiments give a specific point amount discount to the node.area
	var/list/discount_experiments = list()
	/// When this node is completed, allows these experiments to be performed.
	var/list/experiments_to_unlock = list()
	/// Whether or not this node should show on the wiki
	var/show_on_wiki = TRUE
	/// Hidden Mech nodes unlocked when mech fabricator emaged.
	var/illegal_mech_node = FALSE
	/**
	 * If set, the researched node will be announced on these channels by an announcement system
	 * with 'announce_research_node' set to TRUE when researched by the station.
	 * Not every node has to be announced if you want, some are best kept a little "subtler", like Illegal Weapons.
	 */
	var/list/announce_channels

/datum/techweb_node/error_node
	id = "ERROR"
	display_name = "ERROR"
	description = "This usually means something in the database has corrupted. If it doesn't go away automatically, inform Central Command for their techs to fix it ASAP(tm)"
	show_on_wiki = FALSE

/datum/techweb_node/proc/Initialize()
	//Make lists associative for lookup
	for(var/id in prereq_ids)
		prereq_ids[id] = TRUE
	for(var/id in design_ids)
		design_ids[id] = TRUE
	for(var/id in unlock_ids)
		unlock_ids[id] = TRUE

/datum/techweb_node/Destroy()
	SSresearch.techweb_nodes -= id
	return ..()

/datum/techweb_node/proc/on_design_deletion(datum/design/D)
	prune_design_id(D.id)

/datum/techweb_node/proc/on_node_deletion(datum/techweb_node/TN)
	prune_node_id(TN.id)

/datum/techweb_node/proc/prune_design_id(design_id)
	design_ids -= design_id

/datum/techweb_node/proc/prune_node_id(node_id)
	prereq_ids -= node_id
	unlock_ids -= node_id

/datum/techweb_node/proc/get_price(datum/techweb/host)
	if(!host)
		return research_costs

	var/list/actual_costs = research_costs.Copy()

	for(var/cost_type in actual_costs)
		for(var/experiment_type in discount_experiments)
			if(host.completed_experiments[experiment_type]) //do we have this discount_experiment unlocked?
				actual_costs[cost_type] -= discount_experiments[experiment_type]

	if(host.boosted_nodes[id]) // Boosts should be subservient to experiments. Discount from boosts are capped when costs fall below 250.
		var/list/boostlist = host.boosted_nodes[id]
		for(var/booster in boostlist)
			if(actual_costs[booster])
				actual_costs[booster] = max(actual_costs[booster] - boostlist[booster], 0)

	return actual_costs

/datum/techweb_node/proc/is_free(datum/techweb/host)
	var/list/costs = get_price(host)
	var/total_points = 0

	for(var/point_type in costs)
		total_points += costs[point_type]

	if(total_points == 0)
		return TRUE
	return FALSE

/datum/techweb_node/proc/price_display(datum/techweb/TN)
	return techweb_point_display_generic(get_price(TN))

///Proc called when the Station (Science techweb specific) researches a node.
/datum/techweb_node/proc/on_station_research(atom/research_source)
	SHOULD_CALL_PARENT(TRUE)
	var/channels_to_use = announce_channels
	if(istype(research_source, /obj/machinery/computer/rdconsole))
		var/obj/machinery/computer/rdconsole/console = research_source
		var/obj/item/circuitboard/computer/rdconsole/board = console.circuit
		if(board.silence_announcements)
			return
		if(board.obj_flags & EMAGGED)
			channels_to_use = list(RADIO_CHANNEL_COMMON)
	if(!length(channels_to_use) || starting_node)
		return
	var/obj/machinery/announcement_system/system
	var/list/available_machines = list()
	for(var/obj/machinery/announcement_system/announce as anything in GLOB.announcement_systems)
		if(announce.announce_research_node)
			available_machines += announce
			break
	if(!length(available_machines))
		return
	system = pick(available_machines)
	system.announce(AUTO_ANNOUNCE_NODE, display_name, channels = channels_to_use)
