//Slowing spit
/datum/action/xeno_action/activable/slowing_spit
	name = "Slowing Spit"
	action_icon_state = "xeno_spit"
	ability_name = "slowing spit"
	macro_path = /datum/action/xeno_action/verb/verb_slowing_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 1.5 SECONDS
	plasma_cost = 20

// Scatterspit
/datum/action/xeno_action/activable/scattered_spit
	name = "Scattered Spit"
	action_icon_state = "acid_shotgun"
	ability_name = "scattered spit"
	macro_path = /datum/action/xeno_action/verb/verb_scattered_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 8 SECONDS
	plasma_cost = 30

	var/scattered_spit_chance_per_second = 80
	default_ai_action = TRUE

/datum/action/xeno_action/activable/scattered_spit/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(DT_PROB(scattered_spit_chance_per_second, delta_time) && get_dist(X, X.current_target) <= 4)
		use_ability_async(X.current_target)

// Paralyzing slash
/datum/action/xeno_action/onclick/paralyzing_slash
	name = "Paralyzing Slash"
	action_icon_state = "lurker_inject_neuro"
	ability_name = "paralyzing slash"
	macro_path = /datum/action/xeno_action/verb/verb_paralyzing_slash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 12 SECONDS
	plasma_cost = 50

	var/buff_duration = 50
	var/paralyzing_slash_prob_chance = 100
	default_ai_action = TRUE

/datum/action/xeno_action/onclick/paralyzing_slash/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(DT_PROB(paralyzing_slash_prob_chance, delta_time))
		use_ability_async()