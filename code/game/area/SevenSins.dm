/area/sevensins
	icon = 'icons/turf/area_almayer.dmi'
	//ambience = list('sound/ambience/shipambience.ogg')
	icon_state = "almayer"
	ceiling = CEILING_METAL
	powernet_name = "sevensins"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	soundscape_interval = 30
//	requires_power = 0
	//soundscape_playlist = list('sound/effects/xylophone1.ogg', 'sound/effects/xylophone2.ogg', 'sound/effects/xylophone3.ogg')
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE

/area/sevensins/cryo
	name = "\improper 'Seven Sins' Cryo Chamber"
	icon_state = "cryo"
	fake_zlevel = 2 // lowerdeck

/area/sevensins/cryo/restroom
	name = "\improper 'Seven Sins' Laundry"
	icon_state = "laundry"

/area/sevensins/medbay
	name = "\improper 'Seven Sins' Hospital"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck

/area/sevensins/medbay/chemistry
	name = "\improper 'Seven Sins' Chemical lab"
	icon_state = "chemistry"

/area/sevensins/medbay/triage
	name = "\improper 'Seven Sins' Triage"

/area/sevensins/medbay/storage
	name = "\improper 'Seven Sins' Medical Storage"

/area/sevensins/medbay/cryo
	name = "\improper 'Seven Sins' Medical Cryo Chamber"

/area/sevensins/medbay/cmo
	name = "\improper 'Seven Sins' CMO office"

/area/sevensins/medbay/breakroom
	name = "\improper 'Seven Sins' Hospital breakroom"

/area/sevensins/medbay/operation
	name = "\improper 'Seven Sins' Operation Waiting room"

/area/sevensins/medbay/operation/first
	name = "\improper 'Seven Sins' Medical Operation room 1"

/area/sevensins/medbay/operation/second
	name = "\improper 'Seven Sins' Medical Operation room 2"

/area/sevensins/medbay/morgue
	name = "\improper 'Seven Sins' Hospital Morgue"

/area/sevensins/corridor_east
	name = "\improper 'Seven Sins' East Corridor"
	icon_state = "uppermonitoring"
	fake_zlevel = 2 // lowerdeck

/area/sevensins/corridor_east/pods

/area/sevensins/corridor_west
	name = "\improper 'Seven Sins' East Corridor"
	icon_state = "lowerengineering"
	fake_zlevel = 2 // lowerdeck

/area/sevensins/corridor_west/pods

/area/sevensins/hangar
	name = "\improper 'Seven Sins' Hangar"
	icon_state = "hangar"
	fake_zlevel = 2 // lowerdeck

/area/sevensins/hangar/vehicle
	name = "\improper 'Seven Sins' Vehicle Hangar"

/area/sevensins/hangar/cargo
	name = "\improper 'Seven Sins' Cargo Storage"

/area/sevensins/hangar/dropship
	name = "\improper 'Seven Sins' Deployment Workshop"

/area/sevensins/hangar/arms
	name = "\improper 'Seven Sins' Armory"

/area/sevensins/boxing
	name = "\improper 'Seven Sins' Gym"
	icon_state = "ab_shared"
	fake_zlevel = 2 // lowerdeck

/area/sevensins/basketball
	name = "\improper 'Seven Sins' Basketball Chamber"
	icon_state = "basketball"
	fake_zlevel = 2 // lowerdeck

/area/sevensins/engineering/engine_core
	name = "\improper 'Seven Sins' Core Room"
	icon_state = "coreroom"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ENG
	soundscape_interval = 15

/area/sevensins/engineering/starboard_atmos
	name = "\improper 'Seven Sins' Atmospherics Starboard"
	icon_state = "starboardatmos"
	fake_zlevel = 2

/area/sevensins/engineering/port_atmos
	name = "\improper 'Seven Sins' Atmospherics Port"
	icon_state = "portatmos"
	fake_zlevel = 2

/area/sevensins/engineering/telecomms
	name = "\improper 'Seven Sins' Telecommunications"
	icon_state = "tcomms"
	fake_zlevel = 2
	flags_area = AREA_NOTUNNEL

/area/sevensins/firing_range
	name = "\improper 'Seven Sins' Firing Range"
	icon_state = "brig"
	fake_zlevel = 2