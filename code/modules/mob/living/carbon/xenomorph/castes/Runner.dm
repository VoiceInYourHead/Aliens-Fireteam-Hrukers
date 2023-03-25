/datum/caste_datum/runner
	caste_type = XENO_CASTE_RUNNER
	caste_desc = "A fast, four-legged terror, but weak in sustained combat."
	tier = 1
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	melee_vehicle_damage = 0
	plasma_gain = XENO_PLASMA_GAIN_TIER_1
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_1
	armor_deflection = XENO_NO_ARMOR
	max_health = XENO_HEALTH_RUNNER
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_RUNNER
	attack_delay = -4
	evolves_to = list(XENO_CASTE_LURKER)
	deevolves_to = list("Larva")

	tackle_min = 4
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 4

	heal_resting = 1.75

/mob/living/carbon/Xenomorph/Runner
	caste_type = XENO_CASTE_RUNNER
	name = XENO_CASTE_RUNNER
	desc = "A small red alien that looks like it could run fairly quickly..."
	icon_state = "Runner Walking"
	icon_size = 64
	layer = MOB_LAYER
	plasma_types = list(PLASMA_CATECHOLAMINE)
	tier = 1
	pixel_x = -16  //Needed for 2x2
	old_x = -16
	pull_speed = -0.5
	viewsize = 9

	mob_size = MOB_SIZE_XENO_SMALL

	flags_ai = XENO_AI_CHOOSE_RANDOM_STRAIN

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/xenohide,
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/activable/runner_skillshot,
		/datum/action/xeno_action/onclick/toggle_long_range/runner,
	)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
	)
	mutation_type = RUNNER_NORMAL

	icon_xeno = 'icons/mob/hostiles/runner.dmi'
	icon_xenonid = 'icons/mob/hostiles/runner.dmi'

	var/linger_range = 5
	var/linger_deviation = 0
	var/pull_direction

/mob/living/carbon/Xenomorph/Runner/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_CRAWLER

/mob/living/carbon/Xenomorph/Runner/launch_towards(datum/launch_metadata/LM)
	if(!current_target)
		return ..()

	pull_direction = turn(get_dir(src, current_target), 180)

	if(!(pull_direction in GLOB.cardinals))
		if(abs(x - current_target.x) < abs(y - current_target.y))
			pull_direction &= (NORTH|SOUTH)
		else
			pull_direction &= (EAST|WEST)
	return ..()

/mob/living/carbon/Xenomorph/Runner/init_movement_handler()
	var/datum/xeno_ai_movement/linger/L = new(src)
	L.linger_range = linger_range
	L.linger_deviation = linger_deviation
	return L

/mob/living/carbon/Xenomorph/Runner/ai_move_target(delta_time, game_evaluation)
	if(throwing)
		return

	if(pulling)
		if(can_move_and_apply_move_delay())
			Move(get_step(loc, pull_direction), pull_direction)
		current_path = null
	else
		..()

	if(get_dist(current_target, src) <= 1 && current_target.is_mob_incapacitated() && !isXeno(current_target.pulledby) && !pulling && DT_PROB(RUNNER_GRAB, delta_time))
		CallAsync(src, /mob.proc/start_pulling, list(current_target))
		swap_hand()

/mob/living/carbon/Xenomorph/Runner/process_ai(delta_time, game_evaluation)
	if(get_active_hand())
		swap_hand()
	zone_selected = pick(GLOB.ai_target_limbs)
	return ..()

/mob/living/carbon/Xenomorph/Runner/cat
	name = "Angry Cat"
	desc = "D'aaawwww"
	icon = 'icons/mob/hostiles/runner.dmi'
	icon_state = "Runner Walking"
	acid_blood_damage = 0
	mob_size = 1

	melee_damage_lower = 0
	melee_damage_upper = 0

	flags_ai = XENO_AI_NO_DESPAWN

	mutation_type = RUNNER_CAT