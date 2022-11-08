/datum/equipment_preset/goon
	name = "WY Goons"
	faction = FACTION_WY
	rank = FACTION_WY
	idtype = /obj/item/card/id/silver/cl
	faction = FACTION_WY
	faction_group = FACTION_LIST_WY
	languages = list(LANGUAGE_ENGLISH)

/datum/equipment_preset/goon/New()
	. = ..()
	access = get_all_accesses() + get_all_centcom_access()

/datum/equipment_preset/goon/load_name(mob/living/carbon/human/H, var/randomise)
	H.gender = pick(60;MALE,40;FEMALE)
	var/datum/preferences/A = new()
	A.randomize_appearance(H)
	var/random_name
	if(H.gender == MALE)
		random_name = "[pick(first_names_male_colonist)] [pick(last_names_colonist)]"
		H.f_style = "5 O'clock Shadow"
	else
		random_name = "[pick(first_names_female_colonist)] [pick(last_names_colonist)]"
	H.change_real_name(H, random_name)
	H.age = rand(20,45)
	H.r_hair = 25
	H.g_hair = 25
	H.b_hair = 35

/datum/equipment_preset/goon/load_id(mob/living/carbon/human/H, client/mob_client)
	var/obj/item/clothing/under/uniform = H.w_uniform
	if(istype(uniform))
		uniform.has_sensor = UNIFORM_HAS_SENSORS
		uniform.sensor_faction = FACTION_WY
	return ..()


/datum/equipment_preset/goon/standard
	name = "Weyland-Yutani Corporate Security (Goon)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_WY_GOON
	rank = JOB_WY_GOON
	paygrade = "WEY-GOON"
	skills = /datum/skills/MP

/datum/equipment_preset/goon/standard/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/corporate, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/light/corporate, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/corporate, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/ap, WEAR_IN_BACK)


/datum/equipment_preset/goon/lead
	name = "Weyland-Yutani Corporate Security Lead (Goon Lead)"
	flags = EQUIPMENT_PRESET_EXTRA

	assignment = JOB_WY_GOON_LEAD
	rank = JOB_WY_GOON_LEAD
	paygrade = "WEY-GOON-L"
	skills = /datum/skills/MP

/datum/equipment_preset/goon/lead/load_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/PMC/corporate/lead, WEAR_BODY)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/veteran/PMC/light/corporate/lead, WEAR_JACKET)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/veteran, WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/veteran/PMC/corporate/lead, WEAR_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/corporate, WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/storage/backpack/lightpack, WEAR_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/tool/crowbar, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/mod88, WEAR_WAIST)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full, WEAR_R_STORE)

	H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/nsg23, WEAR_J_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/nsg_ap, WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23/ap, WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/nsg23/ap, WEAR_IN_BACK)