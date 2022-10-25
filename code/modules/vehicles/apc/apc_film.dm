
/obj/vehicle/multitile/apc/film
	name = "M577-FOB Armored Personnel Carrier"
	desc = "A modification of the M577 Armored Personnel Carrier designed to act as a field operation base. An armored transport with four big wheels. Has inbuilt field command station installed inside and also small triage. Entrances on the side."

	icon_state = "apc_base_fob"

	interior_map = "apc_filmlike"

	passengers_slots = 20

	entrances = list(
//		"left" = list(2, 0),
		"right" = list(-2, 0)
	)

	var/sensor_radius = 65	//65 tiles radius

	var/techpod_faction_requirement = FACTION_MARINE
	var/techpod_access_settings_override = FALSE

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
		VEHICLE_SUPPORT_GUNNER_TWO = null
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
		VEHICLE_SUPPORT_GUNNER_TWO = null
	)

/obj/vehicle/multitile/apc/film/Initialize()
	. = ..()
	GLOB.command_apc_list += src

/obj/vehicle/multitile/apc/film/Destroy()
	GLOB.command_apc_list -= src
	return ..()

/obj/vehicle/multitile/apc/film/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_CREWMAN, JOB_WO_CREWMAN, JOB_UPP_CREWMAN, JOB_PMC_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Command Staff"
	RRS.roles = JOB_COMMAND_ROLES_LIST
	RRS.total = 2
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Synthetic Unit"
	RRS.roles = list(JOB_SYNTH, JOB_WO_SYNTH)
	RRS.total = 1
	role_reserved_slots += RRS

	RRS = new
	RRS.category_name = "Medical Support"
	RRS.roles = JOB_MEDIC_ROLES_LIST + list(JOB_WO_CMO, JOB_WO_DOCTOR, JOB_WO_RESEARCHER, JOB_SYNTH, JOB_WO_SYNTH)
	RRS.total = 1
	role_reserved_slots += RRS

/obj/vehicle/multitile/apc/film/add_seated_verbs(var/mob/living/M, var/seat)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
	))
	if(seat == VEHICLE_DRIVER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
		))
	else if(seat == VEHICLE_GUNNER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_shift_click,
		))

	else if(seat == VEHICLE_SUPPORT_GUNNER_TWO)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/reload_firing_port_weapon
		))

/obj/vehicle/multitile/apc/film/remove_seated_verbs(var/mob/living/M, var/seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
	))
	if(seat == VEHICLE_DRIVER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
		))
	else if(seat == VEHICLE_GUNNER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/switch_hardpoint,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_shift_click,
		))
	else if(seat == VEHICLE_SUPPORT_GUNNER_TWO)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/reload_firing_port_weapon
		))

/obj/vehicle/multitile/apc/film/initialize_cameras(var/change_tag = FALSE)
	if(!camera)
		camera = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera.c_tag = "#[rand(1,100)] M777 \"[nickname]\" FOB APC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"
	else
		camera.c_tag = "#[rand(1,100)] M777 FOB APC"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior"

/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/apc_film
	name = "APC CMD Spawner"
	icon = 'icons/obj/vehicles/apc.dmi'
	icon_state = "apc_base_fob"
	pixel_x = -48
	pixel_y = -48

//Installation of transport APC Firing Ports Weapons
/obj/effect/vehicle_spawner/apc_film/proc/load_fpw(var/obj/vehicle/multitile/apc/film/V)
	var/obj/item/hardpoint/special/firing_port_weapon/FPW = new
	FPW.allowed_seat = VEHICLE_SUPPORT_GUNNER_TWO
	V.add_hardpoint(FPW)
	FPW.dir = turn(V.dir, -90)
	FPW.name = "Right "+ initial(FPW.name)
	FPW.origins = list(-2, 0)

/obj/effect/vehicle_spawner/apc_film/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/apc_film/spawn_vehicle()
	var/obj/vehicle/multitile/apc/film/APC = new (loc)

	load_misc(APC)
	load_fpw(APC)
	load_hardpoints(APC)
	handle_direction(APC)
	APC.update_icon()

//PRESET: only wheels installed
/obj/effect/vehicle_spawner/apc_film/plain/load_hardpoints(var/obj/vehicle/multitile/apc/film/V)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/apc_film/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/apc/film/APC = new (loc)

	load_misc(APC)
	load_fpw(APC)
	handle_direction(APC)
	load_hardpoints(APC)
	load_damage(APC)
	APC.update_icon()

/obj/effect/vehicle_spawner/apc_film/decrepit/load_hardpoints(var/obj/vehicle/multitile/apc/film/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)

//PRESET: default hardpoints
/obj/effect/vehicle_spawner/apc_film/fixed/load_hardpoints(var/obj/vehicle/multitile/apc/film/V)
	V.add_hardpoint(new /obj/item/hardpoint/primary/dualcannon)
	V.add_hardpoint(new /obj/item/hardpoint/secondary/frontalcannon)
	V.add_hardpoint(new /obj/item/hardpoint/support/flare_launcher)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/apc_wheels)
