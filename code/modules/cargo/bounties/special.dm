/datum/bounty/item/alien_organs
	name = "Alien Organs"
	description = "Nanotrasen is interested in studying Xenomorph biology. Ship a set of organs to be thoroughly compensated."
	reward = CARGO_CRATE_VALUE * 50
	required_count = 3
	wanted_types = list(
		/obj/item/organ/internal/brain/alien = TRUE,
		/obj/item/organ/internal/alien = TRUE,
		/obj/item/organ/internal/body_egg/alien_embryo = TRUE,
		/obj/item/organ/internal/liver/alien = TRUE,
		/obj/item/organ/internal/tongue/alien = TRUE,
		/obj/item/organ/internal/eyes/alien = TRUE,
	)

/datum/bounty/item/syndicate_documents
	name = "Syndicate Documents"
	description = "Intel regarding the syndicate is highly prized at CentCom. If you find syndicate documents, ship them. You could save lives."
	reward = CARGO_CRATE_VALUE * 30
	wanted_types = list(
		/obj/item/documents/syndicate = TRUE,
		/obj/item/documents/photocopy = TRUE,
	)

/datum/bounty/item/syndicate_documents/applies_to(obj/O)
	if(!..())
		return FALSE
	if(istype(O, /obj/item/documents/photocopy))
		var/obj/item/documents/photocopy/Copy = O
		return (Copy.copy_type && ispath(Copy.copy_type, /obj/item/documents/syndicate))
	return TRUE

/datum/bounty/item/adamantine
	name = "Adamantine"
	description = "Nanotrasen's anomalous materials division is in desparate need of adamantine. Send them a large shipment and we'll make it worth your while."
	reward = CARGO_CRATE_VALUE * 70
	required_count = 10
	wanted_types = list(/obj/item/stack/sheet/mineral/adamantine = TRUE)

/datum/bounty/item/trash
	name = "Trash"
	description = "Recently a group of janitors have run out of trash to clean up, and CentCom wants to fire them to cut costs. Send a shipment of trash to keep them employed, and they'll give you a small compensation."
	reward = CARGO_CRATE_VALUE * 2
	required_count = 10
	wanted_types = list(/obj/item/trash = TRUE)

///Bounties related to "nearby vessel - civilian" event

/datum/bounty/item/vessel/fuel
	name = "Engine Fuel"
	description = "Ugh, hello, hello? Quartermaster of the passing-by ship here, SS13. We are short on fuel to get on going, and would gladly appreciate some help with that. Bring in a fuel tank, would ya?"
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(/obj/structure/reagent_dispensers/fueltank = TRUE)

/datum/bounty/item/vessel/party
	name = "Party Supplies"
	description = "Oi, my Cap'n requests me to get some party supplies, yet as you might know, those don't just randomly drift in space. Fetch something party-like enough to satisfy the bugger, would ya?"
	reward = CARGO_CRATE_VALUE * 12
	wanted_types = list(
		/obj/item/food/pizza = TRUE,
		/obj/item/food/cake = TRUE,
		/obj/structure/etherealball = TRUE,
		/obj/item/instrument = TRUE,
		/obj/item/storage/box/party_poppers = TRUE,
		/obj/item/storage/box/balloons = TRUE,
		/obj/item/storage/box/tail_pin = TRUE,
	)

/datum/bounty/item/vessel/toiletbong
	name = "Toiletbong"
	description = "Our ship's clown dreamt up a truely deranged device made from a makeshift flamethrower and a bloody toilet throne. If you think you can make their dreams real, they are quite willing to pay."
	reward = CARGO_CRATE_VALUE * 15
	wanted_types = list(/obj/structure/toiletbong = TRUE)

/datum/bounty/item/vessel/funeral
	name = "Flowers"
	description = "So, a memnber of our crew just passed away, and it seems that some guy on drugs ate all our flowers because eating them 'healed' him, so that's rather awkward. Could you deliver some replacement for the funeral?"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 3
	wanted_types = list(
		/obj/item/seeds/poppy = TRUE,
		/obj/item/seeds/harebell = TRUE,
		/obj/item/food/grown/rose = TRUE,
	)

