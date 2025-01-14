/datum/action/xeno_action/onclick/toggle_crest
	name = "Toggle Crest Defense"
	action_icon_state = "crest_defense"
	ability_name = "toggle crest defense"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_crest
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 1.5 SECONDS
	plasma_cost = 0
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/armor_buff = 5
	var/speed_debuff = 1

/datum/action/xeno_action/activable/headbutt
	name = "Headbutt"
	action_icon_state = "headbutt"
	ability_name = "headbutt"
	macro_path = /datum/action/xeno_action/verb/verb_headbutt
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 40
	var/prob_chance = 75
	default_ai_action = TRUE

/datum/action/xeno_action/activable/headbutt/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(DT_PROB(prob_chance, delta_time) && get_dist(X, X.current_target.get_ai_attack_turf(X)) <= 1)
		use_ability_async(X.current_target)

/datum/action/xeno_action/onclick/tail_sweep
	name = "Tail Sweep"
	action_icon_state = "tail_sweep"
	ability_name = "tail sweep"
	macro_path = /datum/action/xeno_action/verb/verb_tail_sweep
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 10
	xeno_cooldown = 110
	var/prob_chance = 40
	default_ai_action = TRUE
	var/sweep_time = 0.5 SECONDS

/datum/action/xeno_action/onclick/tail_sweep/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(DT_PROB(prob_chance, delta_time) && get_dist(X, X.current_target.get_ai_attack_turf(X)) <= 1)
		use_ability_async(X.current_target)

/datum/action/xeno_action/activable/fortify
	name = "Fortify"
	action_icon_state = "fortify"
	ability_name = "fortify"
	macro_path = /datum/action/xeno_action/verb/verb_fortify
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 100

/datum/action/xeno_action/activable/tail_stab/slam
	name = "Tail Slam"
	ability_name = "tail slam"
	blunt_stab = TRUE
