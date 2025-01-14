/datum/xeno_ai_movement/linger
	var/turf/travelling_turf

	var/linger_range = 5
	var/linger_deviation = 1

/datum/xeno_ai_movement/linger/ai_move_target(delta_time, game_evaluation)
	var/mob/living/carbon/Xenomorph/X = parent
	if(X.throwing)
		return

	if(!(X.current_target in GLOB.all_multi_vehicles) && !(X.current_target in GLOB.all_defenses))
		if(X.current_target.can_ai_target())
			return ..()

	if(!(X in view(world.view, X.current_target)))
		travelling_turf = X.current_target.get_ai_attack_turf(X)
	else if(!travelling_turf || get_dist(travelling_turf, X) <= 0)
		travelling_turf = get_random_turf_in_range_unblocked(X.current_target, linger_range+linger_deviation, linger_range-linger_deviation)
		if(!travelling_turf)
			travelling_turf = X.current_target.get_ai_attack_turf(X)

	if(!X.move_to_next_turf(travelling_turf))
		travelling_turf = X.current_target.get_ai_attack_turf(X)
		return TRUE
