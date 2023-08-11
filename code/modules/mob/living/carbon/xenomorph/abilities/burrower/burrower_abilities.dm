// Burrower Abilities

// Burrow
/datum/action/xeno_action/activable/burrow
	name = "Burrow"
	action_icon_state = "agility_on"
	ability_name = "burrow"
	macro_path = /datum/action/xeno_action/verb/verb_burrow
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	default_ai_action = TRUE
	xeno_cooldown = 10 SECONDS

	var/burrow_prob_chance = 20

/datum/action/xeno_action/activable/burrow/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(DT_PROB(burrow_prob_chance, delta_time) && get_dist(X, X.current_target.get_ai_attack_turf(X)) > 2)
		use_ability_async(X.current_target)

/datum/action/xeno_action/activable/burrow/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!action_cooldown_check())
		return
	if(X.burrow)
		X.tunnel(get_turf(A))
		apply_cooldown()
	else
		X.burrow()

/datum/action/xeno_action/onclick/tremor
	name = "Tremor (100)"
	action_icon_state = "stomp"
	ability_name = "tremor"
	macro_path = /datum/action/xeno_action/verb/verb_tremor
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	default_ai_action = TRUE

	var/tremor_prob_chance = 80

/datum/action/xeno_action/onclick/tremor/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(DT_PROB(tremor_prob_chance, delta_time) && get_dist(X, X.current_target.get_ai_attack_turf(X)) <= 3)
		use_ability_async()

/datum/action/xeno_action/onclick/tremor/use_ability()
	var/mob/living/carbon/Xenomorph/X = owner
	X.tremor()
	..()
