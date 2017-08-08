/obj/machinery/atmospherics/trinary/mixer
	icon = 'icons/atmos/mixer.dmi'
	icon_state = "map"
	density = 0
	level = 1

	name = "Gas mixer"

	use_power = 1
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	active_power_usage = 3700	//This also doubles as a measure of how powerful the mixer is, in Watts. 3700 W ~ 5 HP

	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_MIXER
	var/list/mixing_inputs

	//for mapping
	var/node1_concentration = 0.5
	var/node2_concentration = 0.5

	//node 3 is the outlet, nodes 1 & 2 are intakes

/obj/machinery/atmospherics/trinary/mixer/update_icon(var/safety = 0)
	if(istype(src, /obj/machinery/atmospherics/trinary/mixer/m_mixer))
		icon_state = "m"
	else if(istype(src, /obj/machinery/atmospherics/trinary/mixer/t_mixer))
		icon_state = "t"
	else
		icon_state = ""

	if(!powered())
		icon_state += "off"
	else if(node2 && node3 && node1)
		icon_state += on ? "on" : "off"
	else
		icon_state += "off"
		on = 0

/obj/machinery/atmospherics/trinary/mixer/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return

		if(istype(src, /obj/machinery/atmospherics/trinary/mixer/t_mixer))
			add_underlay(T, node1, turn(dir, -90))
		else
			add_underlay(T, node1, turn(dir, -180))

		if(istype(src, /obj/machinery/atmospherics/trinary/mixer/m_mixer) || istype(src, /obj/machinery/atmospherics/trinary/mixer/t_mixer))
			add_underlay(T, node2, turn(dir, 90))
		else
			add_underlay(T, node2, turn(dir, -90))

		add_underlay(T, node3, dir)

/obj/machinery/atmospherics/trinary/mixer/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/trinary/mixer/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/trinary/mixer/New()
	..()
	air1.volume = ATMOS_DEFAULT_VOLUME_MIXER
	air2.volume = ATMOS_DEFAULT_VOLUME_MIXER
	air3.volume = ATMOS_DEFAULT_VOLUME_MIXER * 1.5

/obj/machinery/atmospherics/trinary/mixer/process()
	..()

	//For some reason this doesn't work even in initialize(), so it goes here.
	if (!mixing_inputs)
		mixing_inputs = list(src.air1 = node1_concentration, src.air2 = node2_concentration)

	if((stat & (NOPOWER|BROKEN)) || !on)
		update_use_power(0)	//usually we get here because a player turned a pump off - definitely want to update.
		last_flow_rate = 0
		return

	//Figure out the amount of moles to transfer
	var/transfer_moles = (set_flow_rate*mixing_inputs[air1]/air1.volume)*air1.total_moles + (set_flow_rate*mixing_inputs[air1]/air2.volume)*air2.total_moles

	var/power_draw = -1
	if (transfer_moles > MINUMUM_MOLES_TO_FILTER)
		power_draw = mix_gas(src, mixing_inputs, air3, transfer_moles, active_power_usage)

		if(network1 && mixing_inputs[air1])
			network1.update = 1

		if(network2 && mixing_inputs[air2])
			network2.update = 1

		if(network3)
			network3.update = 1

	if (power_draw < 0)
		//update_use_power(0)
		use_power = 0	//don't force update - easier on CPU
		last_flow_rate = 0
	else
		handle_power_draw(power_draw)

	return 1

/obj/machinery/atmospherics/trinary/mixer/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (!istype(W, /obj/item/weapon/wrench))
		return ..()
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		user << "\red You cannot unwrench this [src], it too exerted due to internal pressure."
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
	user << "\blue You begin to unfasten \the [src]..."
	if (do_after(user, 40, TRUE, 5, BUSY_ICON_CLOCK))
		user.visible_message( \
			"[user] unfastens \the [src].", \
			"\blue You have unfastened \the [src].", \
			"You hear ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		cdel(src)

/obj/machinery/atmospherics/trinary/mixer/attack_hand(user as mob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		user << "\red Access denied."
		return
	usr.set_interaction(src)
	var/dat = {"<b>Power: </b><a href='?src=\ref[src];power=1'>[on?"On":"Off"]</a><br>
				<b>Set Flow Rate Limit: </b>
				[set_flow_rate]L/s|<a href='?src=\ref[src];set_press=1'>Change</a>
				<br>
				<b>Flow Rate: </b>[round(last_flow_rate, 0.1)]L/s
				<br><hr>
				<b>Node 1 Concentration:</b>
				<a href='?src=\ref[src];node1_c=-0.1'><b>-</b></a>
				<a href='?src=\ref[src];node1_c=-0.01'>-</a>
				[mixing_inputs[air1]]([mixing_inputs[air1]*100]%)
				<a href='?src=\ref[src];node1_c=0.01'><b>+</b></a>
				<a href='?src=\ref[src];node1_c=0.1'>+</a>
				<br>
				<b>Node 2 Concentration:</b>
				<a href='?src=\ref[src];node2_c=-0.1'><b>-</b></a>
				<a href='?src=\ref[src];node2_c=-0.01'>-</a>
				[mixing_inputs[air2]]([mixing_inputs[air2]*100]%)
				<a href='?src=\ref[src];node2_c=0.01'><b>+</b></a>
				<a href='?src=\ref[src];node2_c=0.1'>+</a>
				"}

	user << browse("<HEAD><TITLE>[src.name] control</TITLE></HEAD><TT>[dat]</TT>", "window=atmo_mixer")
	onclose(user, "atmo_mixer")
	return

/obj/machinery/atmospherics/trinary/mixer/Topic(href,href_list)
	if(..()) return
	if(href_list["power"])
		on = !on
	if(href_list["set_press"])
		var/max_flow_rate = min(air1.volume, air2.volume)
		var/new_flow_rate = input(usr,"Enter new flow rate limit (0-[max_flow_rate]L/s)","Flow Rate Control",src.set_flow_rate) as num
		src.set_flow_rate = max(0, min(max_flow_rate, new_flow_rate))
	if(href_list["node1_c"])
		var/value = text2num(href_list["node1_c"])
		src.mixing_inputs[air1] = max(0, min(1, src.mixing_inputs[air1] + value))
		src.mixing_inputs[air2] = 1.0 - mixing_inputs[air1]
	if(href_list["node2_c"])
		var/value = text2num(href_list["node2_c"])
		src.mixing_inputs[air2] = max(0, min(1, src.mixing_inputs[air2] + value))
		src.mixing_inputs[air1] = 1.0 - mixing_inputs[air2]
	src.update_icon()
	src.updateUsrDialog()
	return

obj/machinery/atmospherics/trinary/mixer/t_mixer
	icon_state = "tmap"

	dir = SOUTH
	initialize_directions = SOUTH|EAST|WEST

	//node 3 is the outlet, nodes 1 & 2 are intakes

obj/machinery/atmospherics/trinary/mixer/t_mixer/New()
	..()
	switch(dir)
		if(NORTH)
			initialize_directions = EAST|NORTH|WEST
		if(SOUTH)
			initialize_directions = SOUTH|WEST|EAST
		if(EAST)
			initialize_directions = EAST|NORTH|SOUTH
		if(WEST)
			initialize_directions = WEST|NORTH|SOUTH

obj/machinery/atmospherics/trinary/mixer/t_mixer/initialize()
	..()
	if(node1 && node2 && node3) return

	var/node1_connect = turn(dir, -90)
	var/node2_connect = turn(dir, 90)
	var/node3_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_connect))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,node2_connect))
		if(target.initialize_directions & get_dir(target,src))
			node2 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,node3_connect))
		if(target.initialize_directions & get_dir(target,src))
			node3 = target
			break

	update_icon()
	update_underlays()

obj/machinery/atmospherics/trinary/mixer/m_mixer
	icon_state = "mmap"

	dir = SOUTH
	initialize_directions = SOUTH|NORTH|EAST

	//node 3 is the outlet, nodes 1 & 2 are intakes

obj/machinery/atmospherics/trinary/mixer/m_mixer/New()
	..()
	switch(dir)
		if(NORTH)
			initialize_directions = WEST|NORTH|SOUTH
		if(SOUTH)
			initialize_directions = SOUTH|EAST|NORTH
		if(EAST)
			initialize_directions = EAST|WEST|NORTH
		if(WEST)
			initialize_directions = WEST|SOUTH|EAST

obj/machinery/atmospherics/trinary/mixer/m_mixer/initialize()
	..()
	if(node1 && node2 && node3) return

	var/node1_connect = turn(dir, -180)
	var/node2_connect = turn(dir, 90)
	var/node3_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_connect))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,node2_connect))
		if(target.initialize_directions & get_dir(target,src))
			node2 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,node3_connect))
		if(target.initialize_directions & get_dir(target,src))
			node3 = target
			break

	update_icon()
	update_underlays()
