/mob/living/simple_mob/animal
	mob_class = MOB_CLASS_ANIMAL
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "hits"

	organ_names = /decl/mob_organ_names/quadruped

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	internal_organs = list(\
		/obj/item/organ/internal/brain,\
		/obj/item/organ/internal/heart,\
		/obj/item/organ/internal/liver,\
		/obj/item/organ/internal/stomach,\
		/obj/item/organ/internal/intestine,\
		/obj/item/organ/internal/lungs\
		)

	butchery_loot = list(\
		/obj/item/stack/animalhide = 3\
		)

	var/forager = TRUE    // Can eat from trees and bushes.
	var/scavenger = FALSE // Can eat from corpses.
	var/burrower = FALSE  // Can dig dens.

/decl/mob_organ_names/quadruped //Most subtypes have this basic body layout.
	hit_zones = list("head", "torso", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "tail")

/mob/living/simple_mob/animal/do_interaction(var/atom/A)
	var/static/list/atom_types_with_animal_interactions = list(
		/obj/structure/animal_den,
		/obj/structure/flora,
		/turf/simulated/floor/outdoors
	)
	for(var/checktype in atom_types_with_animal_interactions)
		if(istype(A, checktype))
			attack_generic(A, 0, "investigates")
			return TRUE
	if(scavenger && isliving(A) && a_intent == I_HURT)
		var/mob/living/M = A
		if(M.stat == DEAD && length(M.internal_organs))
			to_chat(src, SPAN_NOTICE("You dig into the guts of \the [M], hunting for the sweetest meat."))
			if(do_after(src, M, 2 SECOND) && !QDELETED(M) && length(M.internal_organs))
				var/obj/item/organ = M.rip_out_internal_organ(check_zone(zone_sel.selecting), damage_descriptor = "animal teeth")
				if(organ)
					visible_message(SPAN_DANGER("\The [src] rips \the [organ] out of \the [M] and devours [organ.gender == PLURAL ? "them" : "it"]!"))
					eat_food_item(organ)
					if(!length(M.internal_organs) && M.gib_on_butchery)
						M.gib()
			return TRUE
	return ..()

/mob/living/simple_mob/animal/proc/eat_food_item(var/obj/item/snack, var/silent)
	if(istype(snack, /obj/item/organ))
		var/obj/item/organ/organ = snack
		if(organ.meat_type)
			eat_food_item(new organ.meat_type(src), silent = TRUE)
	if(!silent)
		playsound(src, 'sound/items/eatfood.ogg', rand(10,50), 1)
	if(snack.reagents?.total_volume)
		snack.reagents.trans_to_mob(src, snack.reagents.total_volume, CHEM_INGEST)
	qdel(snack)
