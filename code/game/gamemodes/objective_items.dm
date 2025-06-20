GLOBAL_DATUM_INIT(steal_item_handler, /datum/objective_item_handler, new())

/proc/add_item_to_steal(source, type)
	GLOB.steal_item_handler.objectives_by_path[type] += source
	return type

/// Holds references to information about all of the items you might need to steal for objectives
/datum/objective_item_handler
	var/list/list/objectives_by_path
	var/generated_items = FALSE

/datum/objective_item_handler/New()
	. = ..()
	objectives_by_path = list()
	for(var/datum/objective_item/item as anything in subtypesof(/datum/objective_item))
		objectives_by_path[initial(item.targetitem)] = list()
	RegisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE, PROC_REF(save_items))
	RegisterSignal(SSdcs, COMSIG_GLOB_NEW_ITEM, PROC_REF(new_item_created))

/datum/objective_item_handler/proc/new_item_created(datum/source, obj/item/item)
	SIGNAL_HANDLER
	if(HAS_TRAIT(item, TRAIT_ITEM_OBJECTIVE_BLOCKED))
		return
	if(!generated_items)
		item.add_stealing_item_objective()
		return
	var/typepath = item.add_stealing_item_objective()
	if(typepath != null)
		register_item(item, typepath)

/// Registers all items that are potentially stealable and removes ones that aren't.
/// We still need to do things this way because on mapload, items may not be on the station until everything has finished loading.
/datum/objective_item_handler/proc/save_items()
	SIGNAL_HANDLER
	for(var/obj/item/typepath as anything in objectives_by_path)
		var/list/obj_by_path_cache = objectives_by_path[typepath].Copy()
		for(var/obj/item/object as anything in obj_by_path_cache)
			register_item(object, typepath)
	generated_items = TRUE

/datum/objective_item_handler/proc/register_item(atom/object, typepath)
	var/turf/place = get_turf(object)
	if(!place || !is_station_level(place.z))
		objectives_by_path[typepath] -= object
		return
	RegisterSignal(object, COMSIG_QDELETING, PROC_REF(remove_item))

/datum/objective_item_handler/proc/remove_item(atom/source)
	SIGNAL_HANDLER
	for(var/typepath in objectives_by_path)
		objectives_by_path[typepath] -= source

//Contains the target item datums for Steal objectives.
/datum/objective_item
	/// How the item is described in the objective
	var/name = "a silly bike horn! Honk!"
	/// Typepath of item
	var/targetitem = /obj/item/bikehorn
	/// Valid containers that the target item can be in.
	var/list/valid_containers = list()
	/// Who CARES if this item goes missing (no stealing unguarded items), often similar but not identical to the next list
	var/list/item_owner = list()
	/// Jobs which cannot generate this objective (no stealing your own stuff)
	var/list/excludefromjob = list()
	/// List of additional items which also count, for things like blueprints
	var/list/altitems = list()
	/// Items to provide to people in order to allow them to acquire the target
	var/list/special_equipment = list()
	/// Defines in which contexts the item can be given as an objective
	var/objective_type = OBJECTIVE_ITEM_TYPE_NORMAL
	/// Whether this item exists on the station map at the start of a round.
	var/exists_on_map = FALSE
	/**
	 * How hard it is to steal this item given normal circumstances, ranked on a scale of 1 to 5.
	 *
	 * 1 - Probably found in a public area
	 * 2 - Likely on someone's person, or in a less-than-public but otherwise unguarded area
	 * 3 - Usually on someone's person, or in a locked locker or otherwise secure area
	 * 4 - Always on someone's person, or in a secure area
	 * 5 - You know it when you see it. Things like the Nuke Disc which have a pointer to it at all times.
	 *
	 * Also accepts 0 as "extremely easy to steal" and >5 as "almost impossible to steal"
	 */
	var/difficulty = 0
	/// A hint explaining how one may find the target item.
	var/steal_hint = "The clown might have one."

	///If the item takes special steps to destroy for an objective (e.g. blackbox)
	var/destruction_method = null

/// For objectives with special checks (does that intellicard have an ai in it? etcetc)
/datum/objective_item/proc/check_special_completion(obj/item/thing)
	return TRUE

/// Takes a list of minds and returns true if this is a valid objective to give to a team of these minds
/datum/objective_item/proc/valid_objective_for(list/potential_thieves, require_owner = FALSE)
	if(!target_exists() || (require_owner && !owner_exists()))
		return FALSE
	for (var/datum/mind/possible_thief as anything in potential_thieves)
		var/datum/job/role = possible_thief.assigned_role
		if(role.title in excludefromjob)
			return FALSE
	return TRUE

/// Returns true if the target item exists
/datum/objective_item/proc/target_exists()
	return (exists_on_map) ? length(GLOB.steal_item_handler.objectives_by_path[targetitem]) : TRUE

/// Returns true if one of the item's owners exists somewhere
/datum/objective_item/proc/owner_exists()
	if (!length(item_owner))
		return TRUE
	for (var/mob/living/player as anything in GLOB.player_list)
		if ((player.mind?.assigned_role.title in item_owner) && player.stat != DEAD && !is_centcom_level(player.z))
			return TRUE
	return FALSE

/datum/objective_item/steal/New()
	. = ..()
	if(target_exists())
		GLOB.possible_items += src
	else
		qdel(src)

/datum/objective_item/steal/Destroy()
	GLOB.possible_items -= src
	return ..()

// Low risk steal objectives
/datum/objective_item/steal/traitor
	objective_type = OBJECTIVE_ITEM_TYPE_TRAITOR

// Unique-ish low risk objectives
/datum/objective_item/steal/traitor/bartender_shotgun
	name = "the bartender's shotgun"
	targetitem = /obj/item/gun/ballistic/shotgun/doublebarrel
	excludefromjob = list(JOB_BARTENDER)
	item_owner = list(JOB_BARTENDER)
	exists_on_map = TRUE
	difficulty = 2
	steal_hint = "A double-barrel shotgun usually found on the bartender's person, or if none are around, in the bar's backroom."

/obj/item/gun/ballistic/shotgun/doublebarrel/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/gun/ballistic/shotgun/doublebarrel)

/datum/objective_item/steal/traitor/fireaxe
	name = "a fire axe"
	targetitem = /obj/item/fireaxe
	excludefromjob = list(
		JOB_ATMOSPHERIC_TECHNICIAN,
		JOB_SITE_DIRECTOR,
		JOB_SITE_MANAGER,
		JOB_SCIENTIFIC_DIRECTOR,
		JOB_ENGINEERING_DIRECTOR,
		JOB_MEDICAL_DIRECTOR,
		JOB_LOGISTICS_OFFICER,
		JOB_ETHICS_LIAISON,
		JOB_TRIBUNAL_OFFICER,
		JOB_TASK_FORCE_OVERWATCH,
		JOB_SECURITY_CAPTAIN,
		JOB_STATION_ENGINEER,
	)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "Only two of these exist on the station - one in the bridge, and one in atmospherics. \
		You can use a multitool to hack open the case, or break it open the hard way."

/obj/item/fireaxe/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/fireaxe)

/datum/objective_item/steal/traitor/big_crowbar
	name = "a mech removal tool"
	targetitem = /obj/item/crowbar/mechremoval
	excludefromjob = list(
		JOB_SCIENTIFIC_DIRECTOR,
		JOB_SCIENTIST,
		JOB_ROBOTICIST,
	)
	item_owner = list(JOB_ROBOTICIST)
	exists_on_map = TRUE
	difficulty = 2
	steal_hint = "A specialized tool found in the roboticist's lab. You can use a multitool to hack open the case, or break it open the hard way."

/obj/item/crowbar/mechremoval/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/crowbar/mechremoval)

/datum/objective_item/steal/traitor/nullrod
	name = "the chaplain's null rod"
	targetitem = /obj/item/nullrod
	excludefromjob = list(JOB_CHAPLAIN)
	item_owner = list(JOB_CHAPLAIN)
	exists_on_map = TRUE
	difficulty = 2
	steal_hint = "A holy artifact usually found on the chaplain's person, or if none are around, in the chapel's relic closet. \
		If there is a chaplain aboard, it is likely be to be transformed into some holy weapon - some of which are... difficult to remove from their person."

/obj/item/nullrod/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/nullrod)

/datum/objective_item/steal/traitor/clown_shoes
	name = "the clown's shoes"
	targetitem = /obj/item/clothing/shoes/clown_shoes
	excludefromjob = list(JOB_CLOWN, JOB_CARGO_TECHNICIAN, JOB_LOGISTICS_OFFICER)
	item_owner = list(JOB_CLOWN)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "The clown's huge, bright shoes. They should always be on the clown's feet."

/obj/item/clothing/shoes/clown_shoes/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/clothing/shoes/clown_shoes)

/datum/objective_item/steal/traitor/mime_mask
	name = "the mime's mask"
	targetitem = /obj/item/clothing/mask/gas/mime
	excludefromjob = list(JOB_MIME, JOB_CARGO_TECHNICIAN, JOB_LOGISTICS_OFFICER)
	item_owner = list(JOB_MIME)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "The mime's mask. It should always be on the mime's face."

/obj/item/clothing/mask/gas/mime/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/clothing/mask/gas/mime)

/datum/objective_item/steal/traitor/chef_moustache
	name = "a fancy fake moustache"
	targetitem = /obj/item/clothing/mask/fakemoustache/italian
	excludefromjob = list(JOB_COOK, JOB_SITE_MANAGER, JOB_CARGO_TECHNICIAN, JOB_LOGISTICS_OFFICER)
	item_owner = list(JOB_COOK)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "The chef's fake Italian moustache, either found on their face or in the garbage, depending on who's on duty."

/obj/item/clothing/mask/fakemoustache/italian/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/clothing/mask/fakemoustache/italian)

/datum/objective_item/steal/traitor/det_revolver
	name = "detective's revolver"
	targetitem = /obj/item/gun/ballistic/revolver/c38/detective
	excludefromjob = list(JOB_SECURITY_INVESTIGATOR)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "A .38 special revolver found in the Detective's holder. \
		Usually found on the Detective's person, or if none are around, in the detective's locker, in their office."

/obj/item/gun/ballistic/revolver/c38/detective/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/gun/ballistic/revolver/c38/detective)

/datum/objective_item/steal/traitor/lawyers_badge
	name = "the tribunal officer's badge"
	targetitem = /obj/item/clothing/accessory/lawyers_badge
	excludefromjob = list(JOB_TRIBUNAL_OFFICER)
	item_owner = list(JOB_TRIBUNAL_OFFICER)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "The internal tribunal officer's badge. Usually pinned to their chest, but a spare can be obtained from their clothes vendor."

/obj/item/clothing/accessory/lawyers_badge/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/clothing/accessory/lawyers_badge)

/datum/objective_item/steal/traitor/chief_engineer_belt
	name = "the engineering director's belt"
	targetitem = /obj/item/storage/belt/utility/chief
	excludefromjob = list(JOB_ENGINEERING_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 2
	steal_hint = "The engineering director's toolbelt, strapped to their waist at all times."

/obj/item/storage/belt/utility/chief/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/storage/belt/utility/chief)

/datum/objective_item/steal/traitor/telebaton
	name = "a telescopic baton"
	targetitem = /obj/item/melee/baton/telescopic
	excludefromjob = list(
		JOB_SITE_DIRECTOR,
		JOB_SITE_MANAGER,
		JOB_SCIENTIFIC_DIRECTOR,
		JOB_ENGINEERING_DIRECTOR,
		JOB_MEDICAL_DIRECTOR,
		JOB_LOGISTICS_OFFICER,
		JOB_ETHICS_LIAISON,
		JOB_TRIBUNAL_OFFICER,
		JOB_TASK_FORCE_OVERWATCH,
		JOB_SECURITY_CAPTAIN,
	)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "A self-defense weapon standard-issue for all heads of staff, and security personnel. Rarely found off of their person."

/datum/objective_item/steal/traitor/telebaton/check_special_completion(obj/item/thing)
	return thing.type == /obj/item/melee/baton/telescopic

/obj/item/melee/baton/telescopic/add_stealing_item_objective()
	if(type == /obj/item/melee/baton/telescopic)
		return add_item_to_steal(src, /obj/item/melee/baton/telescopic)

/datum/objective_item/steal/traitor/cargo_budget
	name = "logistics' departmental budget"
	targetitem = /obj/item/card/id/departmental_budget/car
	excludefromjob = list(JOB_LOGISTICS_OFFICER, JOB_CARGO_TECHNICIAN)
	item_owner = list(JOB_LOGISTICS_OFFICER)
	exists_on_map = TRUE
	difficulty = 2
	steal_hint = "A card that grants access to Logistics funds. \
		Normally found in the locker of the Logistics Officer, but a particularly keen one may have it on their person or in their wallet."

/obj/item/card/id/departmental_budget/car/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/card/id/departmental_budget/car)

/datum/objective_item/steal/traitor/captain_spare
	name = "the captain's spare ID"
	targetitem = /obj/item/card/id/advanced/gold/captains_spare
	excludefromjob = list(
		JOB_SCIENTIFIC_DIRECTOR,
		JOB_SITE_DIRECTOR,
		JOB_SECURITY_CAPTAIN,
		JOB_SITE_MANAGER,
		JOB_ENGINEERING_DIRECTOR,
		JOB_MEDICAL_DIRECTOR,
		JOB_LOGISTICS_OFFICER,
	)
	exists_on_map = TRUE
	difficulty = 4
	steal_hint = "The spare ID of the High Lord himself. \
		If there's no official Captain around, you may find it pinned to the chest of the Acting Captain - one of the Heads of Staff. \
		Otherwise, you'll have to bust open the golden safe on the bridge with acid or explosives to get to it."

/obj/item/card/id/advanced/gold/captains_spare/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/card/id/advanced/gold/captains_spare)

// High risk steal objectives

// Will always generate even with no Captain due to its security and temptation to use it
/datum/objective_item/steal/hostaser
	name = "the security captain's advanced taser"
	targetitem = /obj/item/gun/energy/e_gun/advtaser
	excludefromjob = list(JOB_SECURITY_CAPTAIN)
	item_owner = list(JOB_SECURITY_CAPTAIN)
	exists_on_map = TRUE
	difficulty = 4
	steal_hint = "The Security Captain's personal advanced taser with two modes. \
		Always found on their person, if they are alive, but may otherwise be found in their locker."

/obj/item/gun/energy/e_gun/advtaser/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/gun/energy/e_gun/advtaser)

/datum/objective_item/steal/handtele
	name = "a hand teleporter"
	targetitem = /obj/item/hand_tele
	excludefromjob = list(JOB_SITE_DIRECTOR, JOB_SCIENTIFIC_DIRECTOR, JOB_SITE_MANAGER)
	item_owner = list(JOB_SITE_DIRECTOR, JOB_SCIENTIFIC_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "Only two of these devices exist on the station, with one sitting in the Teleporter Room \
		for emergencies, and the other in the Site Director's Office for personal use."

/obj/item/hand_tele/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/hand_tele)

/datum/objective_item/steal/magboots
	name = "the engineering director's advanced magnetic boots"
	targetitem = /obj/item/clothing/shoes/magboots/advance
	excludefromjob = list(JOB_ENGINEERING_DIRECTOR)
	item_owner = list(JOB_ENGINEERING_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "A pair of magnetic boots found in the Engineering Director's Suit Storage Unit. \
		May also be found on their person, concealed beneath their MODsuit."

/obj/item/clothing/shoes/magboots/advance/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/clothing/shoes/magboots/advance)

/datum/objective_item/steal/capmedal
	name = "the medal of captaincy"
	targetitem = /obj/item/clothing/accessory/medal/gold/captain
	excludefromjob = list(JOB_SITE_DIRECTOR)
	item_owner = list(JOB_SITE_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "A gold medal found in the medal box in the Site Director's Quarters. \
		The Site Director usually also has one pinned to their jumpsuit."

/obj/item/clothing/accessory/medal/gold/captain/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/clothing/accessory/medal/gold/captain)

/datum/objective_item/steal/hypo
	name = "the hypospray"
	targetitem = /obj/item/reagent_containers/hypospray/cmo
	excludefromjob = list(JOB_MEDICAL_DIRECTOR)
	item_owner = list(JOB_MEDICAL_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "The Medical Director's personal medical injector. \
		Usually found amongst their medical supplies on their person, in their belt, or otherwise in their locker."

/obj/item/reagent_containers/hypospray/cmo/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/reagent_containers/hypospray/cmo)

/datum/objective_item/steal/nukedisc
	name = "the warhead authentication card"
	targetitem = /obj/item/disk/nuclear
	excludefromjob = list(JOB_SITE_DIRECTOR)
	difficulty = 5
	steal_hint = "THAT card - you know the one. Carried by the Site Director at all times (hopefully). \
		Difficult to miss, but if you can't find it, the Security Captain and Site Director both have devices to track its precise location."

/obj/item/disk/nuclear/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/disk/nuclear)

/datum/objective_item/steal/nukedisc/check_special_completion(obj/item/disk/nuclear/N)
	return !N.fake

/datum/objective_item/steal/reactive
	name = "the reactive teleport armor"
	targetitem = /obj/item/clothing/suit/armor/reactive/teleport
	excludefromjob = list(JOB_SCIENTIFIC_DIRECTOR)
	item_owner = list(JOB_SCIENTIFIC_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "A special suit of armor found in the possession of the Scientific Director. \
		You may otherwise find it in their locker."

/obj/item/clothing/suit/armor/reactive/teleport/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/clothing/suit/armor/reactive/teleport)

/datum/objective_item/steal/documents
	name = "any set of secret documents of any organization"
	valid_containers = list(/obj/item/folder)
	targetitem = /obj/item/documents
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "A set of papers belonging to a megaconglomerate. \
		SCP Foundation documents can easily be found in the station's vault. \
		For other corporations, you may find them in strange and distant places. \
		A photocopy may also suffice."

/obj/item/documents/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/documents) //Any set of secret documents. Doesn't have to be NT's

/datum/objective_item/steal/nuke_core
	name = "the heavily radioactive plutonium core from the onboard warhead"
	valid_containers = list(/obj/item/nuke_core_container)
	targetitem = /obj/item/nuke_core
	exists_on_map = TRUE
	difficulty = 4
	steal_hint = "The core of the station's warhead device, found in the Warhead Silo."

/obj/item/nuke_core/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/nuke_core)

/datum/objective_item/steal/nuke_core/New()
	special_equipment += /obj/item/storage/box/syndie_kit/nuke
	..()

/datum/objective_item/steal/hdd_extraction
	name = "the source code for Project Goon from the master R&D server mainframe"
	targetitem = /obj/item/computer_disk/hdd_theft
	excludefromjob = list(JOB_SCIENTIFIC_DIRECTOR, JOB_SCIENTIST, JOB_ROBOTICIST)
	item_owner = list(JOB_SCIENTIFIC_DIRECTOR, JOB_SCIENTIST)
	exists_on_map = TRUE
	difficulty = 4
	steal_hint = "The hard drive of the master research server, found in R&D's server room."

/obj/item/computer_disk/hdd_theft/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/computer_disk/hdd_theft)

/datum/objective_item/steal/hdd_extraction/New()
	special_equipment += /obj/item/paper/guides/antag/hdd_extraction
	return ..()


/datum/objective_item/steal/supermatter
	name = "a sliver of a supermatter crystal"
	targetitem = /obj/item/nuke_core/supermatter_sliver
	valid_containers = list(/obj/item/nuke_core_container/supermatter)
	difficulty = 5
	steal_hint = "A small shard of the station's supermatter crystal engine."

/datum/objective_item/steal/supermatter/New()
	special_equipment += /obj/item/storage/box/syndie_kit/supermatter
	..()

/datum/objective_item/steal/supermatter/target_exists()
	return GLOB.main_supermatter_engine != null

// Doesn't need item_owner = (JOB_AI) because this handily functions as a murder objective if there isn't one
/datum/objective_item/steal/functionalai
	name = "a functional AI"
	targetitem = /obj/item/aicard
	difficulty = 5
	steal_hint = "An intellicard (or MODsuit) containing an active, functional AI."

/datum/objective_item/steal/functionalai/New()
	. = ..()
	altitems += typesof(/obj/item/mod/control) // only here so we can account for AIs tucked away in a MODsuit.

/datum/objective_item/steal/functionalai/check_special_completion(obj/item/potential_storage)
	var/mob/living/silicon/ai/being

	if(istype(potential_storage, /obj/item/aicard))
		var/obj/item/aicard/card = potential_storage
		being = card.AI // why is this one capitalized and the other one not? i wish i knew.
	else if(istype(potential_storage, /obj/item/mod/control))
		var/obj/item/mod/control/suit = potential_storage
		if(isAI(suit.ai_assistant))
			being = suit.ai_assistant
	else
		stack_trace("check_special_completion() called on [src] with [potential_storage] ([potential_storage.type])! That's not supposed to happen!")
		return FALSE

	if(isAI(being) && being.stat != DEAD)
		return TRUE

	return FALSE

/datum/objective_item/steal/blueprints
	name = "the facility blueprints"
	targetitem = /obj/item/blueprints
	excludefromjob = list(JOB_ENGINEERING_DIRECTOR)
	item_owner = list(JOB_ENGINEERING_DIRECTOR)
	altitems = list(/obj/item/photo)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "The blueprints of the facility, found in the Engineering Director's locker, or on their person. A picture may suffice."

/obj/item/blueprints/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/blueprints)

/datum/objective_item/steal/blueprints/check_special_completion(obj/item/I)
	if(istype(I, /obj/item/blueprints))
		return TRUE
	if(istype(I, /obj/item/photo))
		var/obj/item/photo/P = I
		if(P.picture.has_blueprints) //if the blueprints are in frame
			return TRUE
	return FALSE

/datum/objective_item/steal/blackbox
	name = "the Blackbox"
	targetitem = /obj/item/blackbox
	excludefromjob = list(JOB_ENGINEERING_DIRECTOR, JOB_STATION_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN)
	exists_on_map = TRUE
	difficulty = 4
	steal_hint = "The station's data Blackbox, found solely within the Communications Tower basement."
	destruction_method = "Too strong to be destroyed via normal means - needs to be dusted via the supermatter, or burnt in the chapel's crematorium."

/obj/item/blackbox/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/blackbox)


// A number of special early-game steal objectives intended to be used with the steal-and-destroy objective.
// They're basically items of utility or emotional value that may be found on many players or lying around the station.
/datum/objective_item/steal/traitor/insuls
	name = "some insulated gloves"
	targetitem = /obj/item/clothing/gloves/color/yellow
	excludefromjob = list(JOB_CARGO_TECHNICIAN, JOB_LOGISTICS_OFFICER, JOB_ATMOSPHERIC_TECHNICIAN, JOB_STATION_ENGINEER, JOB_ENGINEERING_DIRECTOR)
	item_owner = list(JOB_STATION_ENGINEER, JOB_ENGINEERING_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "A basic pair of insulated gloves, usually worn by the lowly Office Workers, Engineers, or Logistics Technicians."

/obj/item/clothing/gloves/color/yellow/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/clothing/gloves/color/yellow)

/datum/objective_item/steal/traitor/moth_plush
	name = "a cute moth plush toy"
	targetitem = /obj/item/toy/plush/moth
	excludefromjob = list(JOB_PSYCHOLOGIST, JOB_SENIOR_DOCTOR, JOB_CHEMIST, JOB_MEDICAL_DOCTOR, JOB_MEDICAL_DIRECTOR, JOB_CORONER)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "A moth plush toy. The Psychologist has one to help console patients."

/obj/item/toy/plush/moth/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/toy/plush/moth)

/datum/objective_item/steal/traitor/lizard_plush
	name = "a cute lizard plush toy"
	targetitem = /obj/item/toy/plush/lizard_plushie
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "A lizard plush toy. Often found hidden in maintenance."

/obj/item/toy/plush/lizard_plushie/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/toy/plush/lizard_plushie)

/datum/objective_item/steal/traitor/denied_stamp
	name = "logistics' denied stamp"
	targetitem = /obj/item/stamp/denied
	excludefromjob = list(JOB_CARGO_TECHNICIAN, JOB_LOGISTICS_OFFICER)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "Logistics often has multiple of these red stamps lying around to process paperwork."

/obj/item/stamp/denied/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/stamp/denied)

/datum/objective_item/steal/traitor/granted_stamp
	name = "logistics' granted stamp"
	targetitem = /obj/item/stamp/granted
	excludefromjob = list(JOB_CARGO_TECHNICIAN, JOB_LOGISTICS_OFFICER)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "Logistics often has multiple of these green stamps lying around to process paperwork."

/obj/item/stamp/granted/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/stamp/granted)

/datum/objective_item/steal/traitor/space_law
	name = "a book on space law"
	targetitem = /obj/item/book/manual/wiki/security_space_law
	excludefromjob = list(JOB_SECURITY_GUARD, JOB_SECURITY_CAPTAIN, JOB_TRIBUNAL_OFFICER, JOB_SECURITY_INVESTIGATOR)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "Sometimes found in the possession of members of Security and the Internal Tribunal Officer. \
		The courtroom and the library are also good places to look."

/obj/item/book/manual/wiki/security_space_law/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/book/manual/wiki/security_space_law)

/datum/objective_item/steal/traitor/rpd
	name = "a rapid pipe dispenser"
	targetitem = /obj/item/pipe_dispenser
	excludefromjob = list(
		JOB_ATMOSPHERIC_TECHNICIAN,
		JOB_STATION_ENGINEER,
		JOB_ENGINEERING_DIRECTOR,
		JOB_SCIENTIST,
		JOB_SCIENTIFIC_DIRECTOR,
		JOB_ROBOTICIST,
	)
	item_owner = list(JOB_ENGINEERING_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "A tool often used by Engineers, Life Support Technicians, and Ordnance Researchers."

/obj/item/pipe_dispenser/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/pipe_dispenser)

/datum/objective_item/steal/traitor/donut_box
	name = "a box of prized donuts"
	targetitem = /obj/item/storage/fancy/donut_box
	excludefromjob = list(
		JOB_SITE_DIRECTOR,
		JOB_ENGINEERING_DIRECTOR,
		JOB_SITE_MANAGER,
		JOB_SECURITY_CAPTAIN,
		JOB_LOGISTICS_OFFICER,
		JOB_MEDICAL_DIRECTOR,
		JOB_SCIENTIFIC_DIRECTOR,
		JOB_SECURITY_LIEUTENANT,
		JOB_SECURITY_MEDIC,
		JOB_SECURITY_SERGEANT,
		JOB_SECURITY_GUARD,
		JOB_TRIBUNAL_OFFICER,
		JOB_SECURITY_INVESTIGATOR,
	)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "Everyone has a box of donuts - you may most commonly find them in Administrative, within Security, or in any department's break room."

/obj/item/storage/fancy/donut_box/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/storage/fancy/donut_box)

/datum/objective_item/steal/spy
	objective_type = OBJECTIVE_ITEM_TYPE_SPY

/datum/objective_item/steal/spy/taser
	name = "a taser"
	targetitem = /obj/item/gun/energy/taser
	excludefromjob = list(
		JOB_SITE_DIRECTOR,
		JOB_SECURITY_INVESTIGATOR,
		JOB_SITE_MANAGER,
		JOB_SECURITY_CAPTAIN,
		JOB_SECURITY_LIEUTENANT,
		JOB_SECURITY_MEDIC,
		JOB_SECURITY_SERGEANT,
		JOB_SECURITY_GUARD,
	)
	difficulty = 2
	steal_hint = "A hand-held taser, often found in the possession of Security Department officers."

/datum/objective_item/steal/spy/p90
	name = "an P90"
	targetitem = /obj/item/gun/ballistic/automatic/p90
	excludefromjob = list(
		JOB_SITE_DIRECTOR,
		JOB_ENGINEERING_DIRECTOR,
		JOB_MEDICAL_DIRECTOR,
		JOB_SECURITY_INVESTIGATOR,
		JOB_SITE_MANAGER,
		JOB_SECURITY_CAPTAIN,
		JOB_LOGISTICS_OFFICER,
		JOB_SCIENTIFIC_DIRECTOR,
		JOB_SECURITY_LIEUTENANT,
		JOB_SECURITY_MEDIC,
		JOB_SECURITY_SERGEANT,
		JOB_SECURITY_GUARD,
	)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "A automatic SMG, found in the station's Armory, as well as in the hands of most security personnel."

/datum/objective_item/steal/spy/p90/check_special_completion(obj/item/thing)
	return thing.type == /obj/item/gun/ballistic/automatic/p90

/obj/item/gun/ballistic/automatic/p90/add_stealing_item_objective()
	if(type == /obj/item/gun/ballistic/automatic/p90)
		return add_item_to_steal(src, /obj/item/gun/ballistic/automatic/p90)

/datum/objective_item/steal/spy/glock
	name = "a glock"
	targetitem = /obj/item/gun/ballistic/automatic/pistol/glock
	excludefromjob = list(
		JOB_SITE_DIRECTOR,
		JOB_ENGINEERING_DIRECTOR,
		JOB_MEDICAL_DIRECTOR,
		JOB_SECURITY_INVESTIGATOR,
		JOB_SITE_MANAGER,
		JOB_SECURITY_CAPTAIN,
		JOB_LOGISTICS_OFFICER,
		JOB_SCIENTIFIC_DIRECTOR,
		JOB_SECURITY_LIEUTENANT,
		JOB_SECURITY_MEDIC,
		JOB_SECURITY_SERGEANT,
		JOB_SECURITY_GUARD,
	)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "A trusty 12 bullet pistol, found in the station's Armory, as well as in the hands of most security personnel."

/datum/objective_item/steal/spy/glock/check_special_completion(obj/item/thing)
	return thing.type == /obj/item/gun/ballistic/automatic/pistol/glock

/obj/item/gun/ballistic/automatic/pistol/glock/add_stealing_item_objective()
	if(type == /obj/item/gun/ballistic/automatic/pistol/glock)
		return add_item_to_steal(src, /obj/item/gun/ballistic/automatic/pistol/glock)

/datum/objective_item/steal/spy/shotgun
	name = "a mossberg shotgun"
	targetitem = /obj/item/gun/ballistic/shotgun/mossberg_590
	excludefromjob = list(
		JOB_SECURITY_INVESTIGATOR,
		JOB_SITE_MANAGER,
		JOB_SECURITY_CAPTAIN,
		JOB_SECURITY_LIEUTENANT,
		JOB_SECURITY_MEDIC,
		JOB_SECURITY_SERGEANT,
		JOB_SECURITY_GUARD,
	)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "A shotgun found in the station's Armory for riot suppression. Doesn't miss."

/obj/item/gun/ballistic/shotgun/mossberg_590/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/gun/ballistic/shotgun/mossberg_590)

/datum/objective_item/steal/spy/stamp
	name = "a department director's stamp"
	targetitem = /obj/item/stamp/head
	excludefromjob = list(
		JOB_SITE_DIRECTOR,
		JOB_ENGINEERING_DIRECTOR,
		JOB_MEDICAL_DIRECTOR,
		JOB_SITE_MANAGER,
		JOB_SECURITY_CAPTAIN,
		JOB_LOGISTICS_OFFICER,
		JOB_SCIENTIFIC_DIRECTOR,
	)
	exists_on_map = TRUE
	difficulty = 1
	steal_hint = "A stamp owned by a department director, from their offices."

/obj/item/stamp/head/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/stamp/head)

/datum/objective_item/steal/spy/sunglasses
	name = "some sunglasses"
	targetitem = /obj/item/clothing/glasses/sunglasses
	excludefromjob = list(
		JOB_SITE_DIRECTOR,
		JOB_ENGINEERING_DIRECTOR,
		JOB_MEDICAL_DIRECTOR,
		JOB_SITE_MANAGER,
		JOB_SECURITY_CAPTAIN,
		JOB_TRIBUNAL_OFFICER,
		JOB_LOGISTICS_OFFICER,
		JOB_SCIENTIFIC_DIRECTOR,
		JOB_SECURITY_LIEUTENANT,
		JOB_SECURITY_MEDIC,
		JOB_SECURITY_SERGEANT,
		JOB_SECURITY_GUARD,
	)
	difficulty = 1
	steal_hint = "A pair of sunglasses. Administrative personnel often have a few pairs, as do some department directors. \
		You can also obtain a pair from dissassembling hudglasses."

/datum/objective_item/steal/spy/ce_modsuit
	name = "the engineering director's advanced MOD control unit"
	targetitem = /obj/item/mod/control/pre_equipped/advanced
	excludefromjob = list(JOB_ENGINEERING_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 2
	steal_hint = "An advanced version of the standard Engineering MODsuit commonly worn by the Engineering Director."

/obj/item/mod/control/pre_equipped/advanced/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/mod/control/pre_equipped/advanced)

/datum/objective_item/steal/spy/rd_modsuit
	name = "the scientific director's research MOD control unit"
	targetitem = /obj/item/mod/control/pre_equipped/research
	excludefromjob = list(JOB_SCIENTIFIC_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 2
	steal_hint = "A bulky MODsuit commonly worn by the Scientific Director to protect themselves from the hazards of their work."

/obj/item/mod/control/pre_equipped/research/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/mod/control/pre_equipped/research)

/datum/objective_item/steal/spy/captain_sabre_sheathe
	name = "the captain's sabre sheathe"
	targetitem = /obj/item/storage/belt/sabre
	excludefromjob = list(JOB_SITE_DIRECTOR)
	exists_on_map = TRUE
	difficulty = 3
	steal_hint = "The sheathe for the captain's sabre, found in their closet or strapped to their waist at all times."

/obj/item/storage/belt/sabre/add_stealing_item_objective()
	return add_item_to_steal(src, /obj/item/storage/belt/sabre)
