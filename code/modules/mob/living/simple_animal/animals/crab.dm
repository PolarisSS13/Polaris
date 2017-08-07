//Look Sir, free crabs!
/mob/living/simple_animal/crab
	name = "crab"
	desc = "A hard-shelled crustacean. Seems quite content to lounge around all the time."
	icon_state = "crab"
	icon_living = "crab"
	icon_dead = "crab_dead"

	wander = 0
	stop_automated_movement = 1
	turns_per_move = 5
	mob_size = MOB_SMALL

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"
	friendly = "pinches"

	speak_chance = 1
	speak_emote = list("clicks")
	emote_hear = list("clicks")
	emote_see = list("clacks")

	autopsy_tool = /obj/item/weapon/surgical/circular_saw

	var/obj/item/inventory_head
	var/obj/item/inventory_mask

/mob/living/simple_animal/crab/Life()
	..()
	//CRAB movement, I'm not porting this up to SA because... "sideways-only movement" var nothanks
	if(!ckey && !stat)
		if(isturf(src.loc) && !resting && !buckled)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			lifes_since_move++
			if(lifes_since_move >= turns_per_move)
				Move(get_step(src,pick(4,8)))
				lifes_since_move = 0
	regenerate_icons()

/mob/living/simple_animal/fish/spawn_organ()
	var/list/heart = list(/obj/item/organ/internal/heart, "[name]'s heart", "It's \the [name]'s heart. It pumps blood throughout \the [name]'s body.")
	organs += heart
	var/list/gills = list(/obj/item/organ/internal/kidneys, "[name]'s gills", "It's \the [name]'s gills. It provides oxygen to \the [name]'s body.")
	organs += gills
	var/list/liver = list(/obj/item/organ/internal/liver, "[name]'s liver", "It's \the [name]'s liver. It helps filter out toxins from \the [name]'s body.")
	organs += liver
	var/list/swim_bladder = list(/obj/item/organ/internal/liver, "[name]'s swim bladder", "It's \the [name]'s swim bladder. It allows \the [name] to change its buoyancy.")
	organs += swim_bladder
	var/list/kidneys = list(/obj/item/organ/internal/kidneys, "[name]'s kidneys", "It's \the [name]'s kidneys. It removes toxins from \the [name]'s body.")
	organs += kidneys
	var/list/brain = list(/obj/item/organ/internal/brain, "[name]'s brain", "It's \the [name]'s brain. It controls \the [name]'s body.")
	organs += brain
	var/list/appendix = list(/obj/item/organ/internal/appendix, "[name]'s appendix", "It's \the [name]'s appendix. It doesn't seem to do anything useful.")
	organs += appendix
	var/list/eyes = list(/obj/item/organ/internal/eyes, "[name]'s eyes", "It's \the [name]'s eyes. They allow \the [name] to see.")
	organs += eyes

//COFFEE! SQUEEEEEEEEE!
/mob/living/simple_animal/crab/Coffee
	name = "Coffee"
	real_name = "Coffee"
	desc = "It's Coffee, the other pet!"
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"
