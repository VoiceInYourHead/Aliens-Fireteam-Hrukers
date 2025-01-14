// Rav charge
/datum/action/xeno_action/activable/pounce/charge
	name = "Charge"
	action_icon_state = "charge"
	ability_name = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_charge_rav
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 14 SECONDS
	plasma_cost = 25

	// Pounce config
	distance = 5
	knockdown = FALSE				// Should we knock down the target?
	slash = FALSE					// Do we slash upon reception?
	freeze_self = FALSE				// Should we freeze ourselves after the lunge?
	should_destroy_objects = TRUE   // Only used for ravager charge

	var/shielded_prob_chance = 100
	prob_chance = 30

/datum/action/xeno_action/activable/pounce/charge/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(get_dist(X, X.current_target.get_ai_attack_turf(X)) > distance)
		return

	var/shield_total = 0
	for (var/l in X.xeno_shields)
		var/datum/xeno_shield/XS = l
		if (XS.shield_source == XENO_SHIELD_SOURCE_RAVAGER)
			shield_total += XS.amount
			break
	var/datum/behavior_delegate/ravager_base/BD = X.behavior_delegate

	var/clear = FALSE
	if (shield_total > BD.super_empower_threshold)
		clear = DT_PROB(shielded_prob_chance, delta_time)
	else
		clear = DT_PROB(prob_chance, delta_time)

	if(!clear)
		return

	var/turf/last_turf = X.loc
	X.add_temp_pass_flags(PASS_OVER_THROW_MOB)
	for(var/i in getline2(X, X.current_target, FALSE))
		var/turf/new_turf = i
		if(LinkBlocked(X, last_turf, new_turf, list(X.current_target, X)))
			clear = FALSE
			break
	X.remove_temp_pass_flags(PASS_OVER_THROW_MOB)

	if(!clear)
		return

	use_ability_async(X.current_target)

// Base ravager shield ability
/datum/action/xeno_action/onclick/empower
	name = "Empower"
	action_icon_state = "empower"
	ability_name = "empower"
	macro_path = /datum/action/xeno_action/verb/verb_empower
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 50
	xeno_cooldown = 22 SECONDS

	// Config values (mutable)
	var/empower_range = 3
	var/max_targets = 5
	var/main_empower_base_shield = 0
	var/initial_activation_shield = 75
	var/shield_per_human = 80
	var/time_until_timeout = 15 SECONDS

	// State
	var/activated_once = FALSE

	var/prob_chance = 100
	var/ai_activate_percentage_health = 0.25
	var/ai_activate_people = 3

	default_ai_action = TRUE

/datum/action/xeno_action/onclick/empower/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(!DT_PROB(prob_chance, delta_time))
		return

	var/should_apply = FALSE
	if(X.health/X.maxHealth < ai_activate_percentage_health)
		should_apply = TRUE

	var/humans_around = 0
	for(var/i in GLOB.alive_client_human_list)
		var/mob/living/carbon/human/H = i
		if(get_dist(H, src) <= empower_range)
			humans_around++

		if(humans_around >= ai_activate_people)
			should_apply = TRUE
			break

	if(should_apply)
		use_ability_async(null)

// Rav "Scissor Cut"
/datum/action/xeno_action/activable/scissor_cut
	name = "Scissor Cut"
	ability_name = "scissor cut"
	action_icon_state = "rav_scissor_cut"
	macro_path = /datum/action/xeno_action/verb/verb_scissorcut
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 10 SECONDS
	plasma_cost = 25

	// Config
	var/damage = 45

	var/superslow_duration = 3 SECONDS
	var/prob_chance = 75
	var/ai_range = 3

	default_ai_action = TRUE

/datum/action/xeno_action/activable/scissor_cut/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(DT_PROB(prob_chance, delta_time) && get_dist(X, X.current_target.get_ai_attack_turf(X)) <= ai_range)
		use_ability_async(X.current_target)


//// BERSERKER ACTIONS

/datum/action/xeno_action/activable/apprehend
	name = "Apprehend"
	action_icon_state = "rav_enrage"
	ability_name = "apprehend"
	macro_path = /datum/action/xeno_action/verb/verb_apprehend
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 0
	xeno_cooldown = 200

	// Config values
	var/max_distance = 6 // 5 tiles between
	var/windup_duration = 10
	var/apprehend_chance_per_second = 60

	default_ai_action = TRUE

/datum/action/xeno_action/activable/apprehend/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(DT_PROB(apprehend_chance_per_second, delta_time) && get_dist(X, X.current_target.get_ai_attack_turf(X)) <= 7)
		use_ability_async(X.current_target)

/datum/action/xeno_action/activable/clothesline
	name = "Clothesline"
	action_icon_state = "rav_clothesline"
	ability_name = "clothesline"
	macro_path = /datum/action/xeno_action/verb/verb_clothesline
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 0
	xeno_cooldown = 140

	// Config values
	var/heal_per_rage = 150
	var/damage = 20
	var/fling_dist_base = 4
	var/daze_amount = 2
	var/clothesline_chance_per_second = 80

	default_ai_action = TRUE

/datum/action/xeno_action/activable/clothesline/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	var/datum/behavior_delegate/ravager_berserker/BD = X.behavior_delegate
	if(DT_PROB(clothesline_chance_per_second, delta_time) && get_dist(X, X.current_target.get_ai_attack_turf(X)) <= 2 && BD.rage > 3)
		use_ability_async(X.current_target)

/datum/action/xeno_action/activable/eviscerate
	name = "Eviscerate"
	action_icon_state = "rav_eviscerate"
	ability_name = "eviscerate"
	macro_path = /datum/action/xeno_action/verb/verb_eviscerate
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 0
	xeno_cooldown = 230

	// Config values
	var/activation_delay = 20

	var/base_damage = 25
	var/damage_at_rage_levels = list(5, 10, 25, 45, 70)
	var/range_at_rage_levels = list(1, 1, 1, 2, 2)
	var/windup_reduction_at_rage_levels = list(0, 2, 4, 6, 10)
	var/eviscerate_chance_per_second = 80

	default_ai_action = TRUE

/datum/action/xeno_action/activable/eviscerate/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	var/datum/behavior_delegate/ravager_berserker/BD = X.behavior_delegate
	if(DT_PROB(eviscerate_chance_per_second, delta_time) && get_dist(X, X.current_target.get_ai_attack_turf(X)) <= 2 && BD.rage > 3)
		use_ability_async()


////// HEDGEHOG ABILITIES

/datum/action/xeno_action/onclick/spike_shield
	name = "Spike Shield (150 shards)"
	action_icon_state = "rav_shard_shield"
	ability_name = "spike shield"
	macro_path = /datum/action/xeno_action/verb/verb_spike_shield
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 0
	xeno_cooldown = 9 SECONDS + 2 SECONDS // Left operand is the actual CD, right operand is the buffer for the shield duration

	// Config values
	var/shield_duration = 20  		// Shield lasts 2 seconds by default.
	var/shield_amount = 500 		// Shield HP amount
	var/shield_shrapnel_amount = 7  // How much shrapnel each shield hit should spawn
	var/shard_cost = 150 			// Minimum spikes to use this ability
	var/shield_active = FALSE 		// Is our shield active.
	var/real_hp_per_shield_hp = 0.5	// How many real HP we get for each shield HP
	var/spike_shield_chance_per_second = 80
	var/ai_spike_shield_percentage_activate = 0.98

	default_ai_action = TRUE

/datum/action/xeno_action/onclick/spike_shield/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
	if(DT_PROB(spike_shield_chance_per_second, delta_time) && get_dist(X, X.current_target.get_ai_attack_turf(X)) <= 5 && X.health/X.maxHealth < ai_spike_shield_percentage_activate && BD.shards >= 150)
		use_ability_async()

/datum/action/xeno_action/activable/rav_spikes
	name = "Fire Spikes (75 shards)"
	action_icon_state = "rav_spike"
	ability_name = "fire spikes"
	macro_path = /datum/action/xeno_action/verb/verb_fire_spikes
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 0
	xeno_cooldown = 100

	// Config
	var/shard_cost = 75
	var/ammo_type = /datum/ammo/xeno/bone_chips
	var/rav_spikes_chance_per_second = 80

	default_ai_action = TRUE

/datum/action/xeno_action/activable/rav_spikes/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	var/datum/behavior_delegate/ravager_hedgehog/BD = X.behavior_delegate
	if(DT_PROB(rav_spikes_chance_per_second, delta_time) && get_dist(X, X.current_target.get_ai_attack_turf(X)) <= 3 && BD.shards >= 225)
		use_ability_async(X.current_target)

/datum/action/xeno_action/onclick/spike_shed
	name = "Spike Shed (50 shards)"
	action_icon_state = "rav_shard_shed"
	ability_name = "spike shed"
	macro_path = /datum/action/xeno_action/verb/verb_shed_spikes
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 0
	xeno_cooldown = 300

	// Config values
	var/shard_cost = 50
	var/ammo_type = /datum/ammo/xeno/bone_chips/spread
	var/shrapnel_amount = 40
	var/spike_shed_chance_per_second = 100
	var/ai_spike_shed_percentage_activate = 0.10

	default_ai_action = TRUE

/datum/action/xeno_action/onclick/spike_shed/process_ai(mob/living/carbon/Xenomorph/X, delta_time, game_evaluation)
	if(DT_PROB(spike_shed_chance_per_second, delta_time) && X.health/X.maxHealth < ai_spike_shed_percentage_activate)
		use_ability_async()



