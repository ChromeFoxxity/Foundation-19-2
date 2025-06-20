/area/station/site75 // Base area, Do Not Use
	name = "Station Areas"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "station"

/area/station/site75/commons
	name = "Commons"
	icon_state = "commons"
	sound_environment = SOUND_AREA_STANDARD_STATION
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/area/station/site75/commons/hub
	name = "\improper Entrance Zone Central Hub"
	icon_state = "commons"

/area/station/site75/commons/medsci
	name = "\improper Med-Sci Hallway"
	icon_state = "commons"

/area/station/site75/commons/restroom
	name = "\improper Entrance Zone Restrooms"
	icon_state = "toilet"

/area/station/site75/commons/shower
	name = "\improper Entrance Zone Showers"
	icon_state = "shower"

/area/station/site75/commons/office
	name = "\improper Office"
	icon_state = "vacant_office"

/area/station/site75/commons/entrance
	name = "\improper Entrance Hallway"
	icon_state = "commons"

/area/station/site75/commons/tram
	name = "\improper Entrance Zone Tram Station"
	icon_state = "commons"

/area/station/site75/maintenance // Base area, Do Not Use
	name = "Generic Maintenance"
	ambience_index = AMBIENCE_MAINT
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED | PERSISTENT_ENGRAVINGS
	airlock_wires = /datum/wires/airlock/maint
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	forced_ambience = TRUE
	ambient_buzz = 'sound/ambience/maintenance/source_corridor2.ogg'
	ambient_buzz_vol = 20

/area/station/site75/maintenance/central_hub_upper
	name = "Upper Central Hub Maintenance"

/area/station/site75/maintenance/medsci
	name = "Med-Sci Hall Maintenance"

/area/station/site75/maintenance/abandoned_observation
	name = "Abandoned Observation Lounge"

/area/station/site75/maintenance/abandoned_reactor
	name = "Abandoned Reactor Room"

/area/station/site75/maintenance/abandoned_library
	name = "Abandoned Library"

/area/station/site75/maintenance/abandoned_arcade
	name = "Abandoned Arcade"

/area/station/site75/maintenance/engineering
	name = "Engineering Maintenance"

/area/station/site75/maintenance/service
	name = "Service Plaza Maintenance"

/area/station/site75/maintenance/service/upper
	name = "Upper Service Plaza Maintenance"

/area/station/site75/maintenance/logistics
	name = "Logistics Maintenance"

/area/station/site75/maintenance/admin
	name = "Administrative Maintenance"

/area/station/site75/maintenance/abandoned_kitchen
	name = "Abandoned Kitchen"

/area/station/site75/security // Base area, Do Not Use
	name = "Security"
	icon_state = "security"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/security
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/site75/security/lobby
	name = "\improper Security Center Lobby"
	icon_state = "security"

/area/station/site75/security/office
	name = "\improper Security Center Conference Room"
	icon_state = "security"

/area/station/site75/security/hallway
	name = "\improper Security Center Hallway"
	icon_state = "security"

/area/station/site75/security/sergeant1
	name = "\improper Security Sergeant's Office #1"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/site75/security/sergeant2
	name = "\improper Security Sergeant's Office #2"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/site75/security/lieutenant1
	name = "\improper Security Lieutenant's Office #1"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/site75/security/lieutenant2
	name = "\improper Security Lieutenant's Office #2"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/site75/security/lockers
	name = "\improper Security Center Locker Room"
	icon_state = "securitylockerroom"

/area/station/site75/security/infirmary
	name = "\improper Security Center Infirmary"
	icon_state = "security_medical"

/area/station/site75/security/termination
	name = "\improper Security Center Termination Room"
	icon_state = "holding_cell"

/area/station/site75/security/amnestic
	name = "\improper Security Center Amnestic Room"
	icon_state = "holding_cell"

/area/station/site75/security/cells
	name = "\improper Security Center Containment Cells"
	icon_state = "holding_cell"

/area/station/site75/security/captain
	name = "\improper Security Captain's Office"
	icon_state = "hos_office"
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/site75/security/investigations
	name = "\improper Security Center Investigations Division"
	icon_state = "detective"

/area/station/site75/security/processing
	name = "\improper Security Center Processing"
	icon_state = "security"

/area/station/site75/security/processing_office
	name = "\improper Security Center Processing Officer"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/site75/security/firing_range
	name = "\improper Security Center Firing Range"
	icon_state = "firingrange"

/area/station/site75/security/interrogation
	name = "\improper Security Center Interrogation"
	icon_state = "interrogation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/site75/security/morgue
	name = "\improper Security Center Morgue"
	icon_state = "security"
	ambience_index = AMBIENCE_SPOOKY
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/site75/security/itdo
	name = "\improper Internal Tribunal Officer's Office"
	icon_state = "warden"
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/site75/service // Base area, Do Not Use
	name = "Service"
	icon_state = "commons"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/site75/service/plaza
	name = "\improper Service Plaza"
	icon_state = "commons"

/area/station/site75/service/plaza/upper
	name = "\improper Upper Service Plaza"
	icon_state = "commons"

/area/station/site75/service/coffee
	name = "\improper Coffee Shop"
	icon_state = "commons"

/area/station/site75/service/office
	name = "\improper Service Office"
	icon_state = "hall_service"

/area/station/site75/service/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/station/site75/service/kitchen/freezer
	name = "\improper Kitchen Freezer"
	icon_state = "kitchen_cold"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/site75/service/bar
	name = "\improper Bar"
	icon_state = "bar"
	mood_bonus = 5
	mood_message = "I love being in the bar!"
	mood_trait = TRAIT_EXTROVERT
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/site75/service/bar/backroom
	name = "\improper Bar Backroom"
	icon_state = "bar_backroom"

/area/station/site75/service/library
	name = "\improper Library"
	icon_state = "library"
	mood_bonus = 5
	mood_message = "I love being in the library!"
	mood_trait = TRAIT_INTROVERT
	area_flags = CULT_PERMITTED | BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/station/site75/service/library/private
	name = "\improper Library Private Study"
	icon_state = "library_gallery_private"

/area/station/site75/service/chapel
	name = "\improper Chapel"
	icon_state = "chapel"
	mood_bonus = 5
	mood_message = "Being in the chapel brings me peace."
	mood_trait = TRAIT_SPIRITUAL
	ambience_index = AMBIENCE_HOLY
	flags_1 = NONE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/site75/service/chapel/office
	name = "\improper Chapel Office"
	icon_state = "chapeloffice"

/area/station/site75/service/greenhouse
	name = "Greenhouse"
	icon_state = "hydro"

/area/station/site75/service/greenhouse/backroom
	name = "Greenhouse Backroom"
	icon_state = "hydro"

/area/station/site75/service/theater
	name = "\improper Theater"
	icon_state = "theatre"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/site75/medical // Base area, Do Not Use
	name = "Medical"
	icon_state = "medbay"
	ambience_index = AMBIENCE_MEDICAL
	airlock_wires = /datum/wires/airlock/medbay
	sound_environment = SOUND_AREA_STANDARD_STATION
	min_ambience_cooldown = 90 SECONDS
	max_ambience_cooldown = 180 SECONDS

/area/station/site75/medical/lobby
	name = "\improper Medical Lobby"
	icon_state = "med_lobby"

/area/station/site75/medical/central
	name = "Medical Central Hallway"
	icon_state = "med_central"

/area/station/site75/medical/staff
	name = "Medical Staff Hallway"
	icon_state = "med_aft"

/area/station/site75/medical/pharmacy
	name = "\improper Medical Pharmacy"
	icon_state = "pharmacy"

/area/station/site75/medical/office
	name = "\improper Medical Office"
	icon_state = "med_office"

/area/station/site75/medical/morgue
	name = "\improper Medical Morgue"
	icon_state = "morgue"
	ambience_index = AMBIENCE_SPOOKY
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/site75/medical/storage
	name = "Medical Primary Storage"
	icon_state = "med_storage"

/area/station/site75/medical/locker
	name = "Medical Locker Room"
	icon_state = "med_storage"

/area/station/site75/medical/break_room
	name = "\improper Medical Break Room"
	icon_state = "med_break"

/area/station/site75/medical/virology
	name = "Medical Virology Lab"
	icon_state = "virology"
	ambience_index = AMBIENCE_VIROLOGY

/area/station/site75/medical/treatment_center
	name = "\improper Medical Treatment Center"
	icon_state = "exam_room"

/area/station/site75/medical/surgery
	name = "\improper Medical Operating Room #1"
	icon_state = "surgery"

/area/station/site75/medical/surgery2
	name = "\improper Medical Operating Room #2"
	icon_state = "surgery"

/area/station/site75/medical/surgical
	name = "\improper Medical Surgical Hallway"
	icon_state = "surgerytheatre"

/area/station/site75/medical/psychology
	name = "\improper Medical Psychology Office"
	icon_state = "psychology"
	mood_bonus = 3
	mood_message = "I feel at ease here."
	ambientsounds = list(
		'sound/ambience/aurora_caelus/aurora_caelus_short.ogg',
		)

/area/station/site75/medical/cmo
	name = "\improper Medical Director's Office"
	icon_state = "cmo_office"
	sound_environment = SOUND_AREA_WOODFLOOR
	airlock_wires = /datum/wires/airlock/command

/area/station/site75/medical/genetics
	name = "\improper Decommissioned Medical Genetics Lab"
	icon_state = "geneticssci"

/area/station/site75/lcz // Base area, Do Not Use
	name = "\improper Light Containment Zone"
	icon_state = "primaryhall"
	airlock_wires = /datum/wires/airlock/lcz
	sound_environment = SOUND_AREA_STANDARD_STATION

/datum/wires/airlock/lcz
	dictionary_key = /datum/wires/airlock/lcz
	proper_name = "LCZ Airlock"

/area/station/site75/lcz/hallway
	name = "LCZ Corridors"
	icon_state = "primaryhall"

/area/station/site75/lcz/hallway/entrance
	name = "LCZ Entrance Hall"
	icon_state = "primaryhall"

/area/station/site75/lcz/security // Base area, Do Not Use
	name = "LCZ Security"
	icon_state = "security"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/security
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/site75/lcz/security/center
	name = "LCZ Security Center"
	icon_state = "brig"

/area/station/site75/lcz/security/check
	name = "LCZ Security Checkpoint"
	icon_state = "security"

/area/station/site75/lcz/security/check
	name = "LCZ Security Checkpoint"
	icon_state = "security"

/area/station/site75/lcz/security/office
	name = "LCZ Security Office"
	icon_state = "securitylockerroom"

/area/station/site75/hcz
	name = "\improper Heavy Containment Zone"
	icon_state = "primaryhall"
	airlock_wires = /datum/wires/airlock/hcz
	sound_environment = SOUND_AREA_STANDARD_STATION

/datum/wires/airlock/hcz
	dictionary_key = /datum/wires/airlock/hcz
	proper_name = "HCZ Airlock"

/area/station/site75/logistics // Base area, Do Not Use
	name = "Logistics"
	icon_state = "cargo_bay"
	airlock_wires = /datum/wires/airlock/cargo
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/site75/logistics/office
	name = "\improper Logistics office"
	icon_state = "cargo_office"

/area/station/site75/logistics/storage
	name = "\improper Logistics Storage Bay"
	icon_state = "cargo_bay"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/site75/logistics/storage/upper
	name = "\improper Upper Logistics"

/area/station/site75/logistics/disposal
	name = "\improper Logistics Disposal Center"
	icon_state = "cargo_delivery"

/area/station/site75/logistics/refinery
	name = "\improper Logistics Refinery"
	icon_state = "cargo_delivery"

/area/station/site75/logistics/warehouse
	name = "\improper Logistics Warehouse"
	icon_state = "cargo_warehouse"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/site75/logistics/lo
	name = "\improper Logistics Officer's Office"
	icon_state = "qm_office"
	sound_environment = SOUND_AREA_WOODFLOOR
	airlock_wires = /datum/wires/airlock/command

/area/station/site75/logistics/vault
	name = "\improper Secure Vault"
	icon_state = "cargo_bay"
	airlock_wires = /datum/wires/airlock/command

/area/station/site75/engineering // Base area, Do Not Use
	name = "Engineering"
	icon_state = "engie"
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/site75/engineering/office
	name = "\improper Engineering Office"
	icon_state = "engine"

/area/station/site75/engineering/hub
	name = "\improper Engineering Hub"
	icon_state = "engine_hallway"

/area/station/site75/engineering/engine_smes
	name = "\improper Engineering Power Storage"
	icon_state = "engine_smes"

/area/station/site75/engineering/supermatter
	name = "\improper Supermatter Engine"
	icon_state = "engine_sm"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/site75/engineering/supermatter/room
	name = "\improper Supermatter Engine Room"
	icon_state = "engine_sm_room"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/site75/engineering/break_room
	name = "\improper Engineering Foyer"
	icon_state = "engine_break"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/site75/engineering/storage
	name = "\improper Engineering Storage"
	icon_state = "engine_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/site75/engineering/atmos
	name = "\improper Facility Atmospherics"
	icon_state = "atmos"

/area/station/site75/engineering/atmos/office
	name = "\improper Facility Atmospherics Monitoring"
	icon_state = "atmos_office"

/area/station/site75/engineering/atmos/storage
	name = "\improper Facility Atmospherics Storage"
	icon_state = "atmos_storage"

/area/station/site75/engineering/ed
	name = "\improper Engineering Director's Office"
	icon_state = "ce_office"
	sound_environment = SOUND_AREA_WOODFLOOR
	airlock_wires = /datum/wires/airlock/command

/area/station/site75/administrative // Base area, Do Not Use
	name = "Administrative"
	icon_state = "command"
	ambientsounds = list(
		'sound/ambience/misc/signal.ogg',
		)
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/site75/administrative/public_hall
	name = "\improper Administrative Zone Public Hall"
	icon_state = "command"

/area/station/site75/administrative/lounge
	name = "\improper Administrative Lounge"
	icon_state = "command"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/site75/administrative/high_hall
	name = "\improper Administrative Zone Higher Echelon Hall"
	icon_state = "command"

/area/station/site75/administrative/conference
	name = "\improper Administrative Conference Room"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/site75/administrative/security
	name = "\improper Administrative Security Checkpoint"
	icon_state = "security"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/security

/area/station/site75/administrative/security_office
	name = "\improper Administrative Security Office"
	icon_state = "security"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/security

/area/station/site75/administrative/teleporter
	name = "\improper Administrative Experimental Teleporter Room"
	icon_state = "teleporter"
	ambience_index = AMBIENCE_ENGI

/area/station/site75/administrative/gateway
	name = "\improper Administrative Gateway Room"
	icon_state = "gateway"
	ambience_index = AMBIENCE_ENGI

/area/station/site75/administrative/goc_rep
	name = "\improper Global Occult Coalition Representative's Office"
	icon_state = "command"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/site75/administrative/uiu_rep
	name = "\improper Unusual Incidents Unit Representative's Office"
	icon_state = "command"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/site75/administrative/ecl
	name = "\improper Ethics Committee Liaison's Office"
	icon_state = "command"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/site75/administrative/site_manager
	name = "\improper Site Manager's Office"
	icon_state = "hop_office"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/site75/administrative/site_director
	name = "\improper Site Director's Office"
	icon_state = "captain"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/site75/administrative/command_center
	name = "\improper Administrative Command Center"
	icon_state = "bridge"

/area/station/site75/ai_monitored
	icon_state = "ai"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/site75/ai_monitored/turret_protected
	ambientsounds = list('sound/ambience/engineering/ambitech.ogg', 'sound/ambience/engineering/ambitech2.ogg', 'sound/ambience/engineering/ambiatmos.ogg', 'sound/ambience/engineering/ambiatmos2.ogg')
	///Some sounds (like the space jam) are terrible when on loop. We use this variable to add it to other AI areas, but override it to keep it from the AI's core.
	var/ai_will_not_hear_this = list('sound/ambience/misc/ambimalf.ogg')
	airlock_wires = /datum/wires/airlock/ai

/area/station/site75/ai_monitored/turret_protected/ai_upload
	name = "\improper Facility Artificial Intelligence Upload Office"
	icon_state = "ai_upload"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/site75/ai_monitored/turret_protected/ai
	name = "\improper Facility Artificial Intelligence Core Chamber"
	icon_state = "ai_chamber"
	ai_will_not_hear_this = null

/area/station/site75/ai_monitored/turret_protected/ai_control
	name = "\improper Facility Artificial Intelligence Control Room"
	icon_state = "ai"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/station/site75/ai_monitored/turret_protected/administrative/nuke_silo
	name = "\improper Administrative Warhead Silo"
	icon_state = "nuke_storage"
	airlock_wires = /datum/wires/airlock/command

/area/station/site75/ai_monitored/security/armory
	name = "\improper Security Center Armory"
	icon_state = "armory"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/security

/area/station/site75/ai_monitored/security/armory/secure
	name = "Security Center Secure Armory"

/area/station/site75/administrative/is
	name = "\improper Intake Officer's Office"
	icon_state = "command"
	sound_environment = SOUND_AREA_WOODFLOOR
