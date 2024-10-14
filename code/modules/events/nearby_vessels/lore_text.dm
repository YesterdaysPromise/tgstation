GLOBAL_LIST_INIT(vessel_theme_to_datum, list(
	VESSEL_THEME_NT = /datum/vessel_theme/nanotrasen,
	VESSEL_THEME_OTHERCORP = /datum/vessel_theme/othercorp,
	VESSEL_THEME_SPINWARD = /datum/vessel_theme/spinward,
	VESSEL_THEME_SYNDICATE = /datum/vessel_theme/syndicate,
	VESSEL_THEME_CLOWN = /datum/vessel_theme/clown,
	VESSEL_THEME_PIRATE = /datum/vessel_theme/pirate,
	VESSEL_THEME_GOLEM = /datum/vessel_theme/golem,
	VESSEL_THEME_UNKNOWN = /datum/vessel_theme/unknown,
))


/datum/round_event/nearby_vessel
	///Used in randomizing announcements.
	var/list/arrival_reason = list("recieving the wrong chart course",\
		"having been tricked by a member of Wizard Federation",\
		"an unstated third party",\
		"assault executed by syndicate operatives",\
		"anomaly in their navigation system",\
		"some stupid intern's fuck-up",\
		"Jacob's fault",\
		"thirty seven space snakes",\
		"party so good it tore a rip in space-time",\
		"a broken bluespace drive",\
		"a demon summoning",\
		"ugh... em... reasons",\
		"mix-up of coordinates",\
		"hostile interfarance with ships's subsystems",
	)
	var/list/arrival_type = list("blue-spaced",\
		"somehow teleported",\
		"made a bluespace jump",\
		"casually flown",\
		"got thrown",\
		"ended up getting",\
		"entered",\
		"charted",\
		"got blasted",\
		"popped out of a wormhole",\
		"arrived",
	)
	var/list/vessel_theme = list("nanotrasen",\
		"othercorp",\
		"spinward",\
		"syndicate",\
		"clown",\
		"pirate",\
		"golem",\
		"unknown",
	)
	start_when = 1
	announce_when = 2

/datum/vessel_theme
	var/genericship_types
	var/BSA_target_name

/datum/vessel_theme/nanotrasen
	genericship_types = list("Nanotrasen's Hygiene Division vessel of little significance",\
		"a shipment of interns going towards CentCom",\
		"vessel of Nanotrasen's Intelligence Devision here to check if you have any",\
		"a messanger vessel carrying priority data for Nanostrasen's corporate executive",\
		"shipment for one of our subsidiary corps",
	)
	BSA_target_name = "Nanotrasen Vessel"

/datum/vessel_theme/othercorp
	genericship_types = list("a medicine shipment vessel from DeForest Medical Corporation",\
		"Apadyne Technologies vessel here on apparently secret mission to test their armours against local fauna",\
		"Dreamland Robotics vessel with unknown agenda",\
		"a ship from Sophronia Broadcasting venturing out, looking for some inspiration for their new show",
	)
	BSA_target_name = "Foreign Corporate Entity's Vessel"

/datum/vessel_theme/spinward
	genericship_types = list("a suspicious vessel carrying a team of miners from Spinward Sector",\
		"a ship of some drunk russian hunters who somehow got the information there were monsters here",\
		"cargo shipment headed and reserved for Novoyamoskva, capital of the Spinward Sector",\
		"Spinward Stellar Coalition tax ship",
	)
	BSA_target_name = "Spinward Sector's Vessel"

/datum/vessel_theme/syndicate
	genericship_types = list("Interdyne Pharmaceutics medicine carrying cargo vessel",\
		"a seemingly passive, semi-camouflaged vessel our intel suspects might belong to the syndicate",\
		"vessel with quite blatant Cybersun identification signatures, flooding our servers with smug emails but posing no conceivable threat",\
		"syndicate aligned transport ship of unknown contents and full alliegiance",
	)
	BSA_target_name = "Syndicate Vessel"

/datum/vessel_theme/clown
	genericship_types = list("an entire space-circus (oh god)",\
		"bananium prospector team from the Clown Planet",\
		"an evengalizing banana-shaped ship on a quest to spread the word of the Honkmother",\
		"a fresh clown shipment towards CentCom",
	)
	BSA_target_name = "Clown Vessel"

/datum/vessel_theme/pirate
	genericship_types = list("a vessel in a rush carrying no trading license and a lot of rather illegal materials",\
		"a rather odd gallery-ship with several deceased bio signatures on board and no authenticity verificators",\
		"ship with multiple crime records in its data apparently having been recently pursued",\
		"pirate ship with no apparent intrest in the station",
	)
	BSA_target_name = "Pirate Vessel"

/datum/vessel_theme/golem
	genericship_types = list("one of our lost science ships, now entirely manned by non-carbon lifeforms)",\
		"a vessel with Wizard Federation identifications run by servant golems",\
		"an asteroid with engines mounted on it, and aptly rocky crew",\
		"mining ship with no carbon lifeforms, but multiple bio signatures detected",
	)
	BSA_target_name = "Golem Vessel"

/datum/vessel_theme/unknown
	genericship_types = list("<REDACTED> vessel",\
		"a ship nature of which we can't disclouse",\
		"an unidentified vessel",\
		"unidentified spacefaring object",
	)
	BSA_target_name = "Unknown Vessel"
