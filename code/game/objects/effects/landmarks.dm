/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = 1
	simulated = 0
	invisibility = 100
	var/delete_me = 0

/obj/effect/landmark/Initialize()
	. = ..()
	tag = text("landmark*[]", name)
	invisibility = 101
	switch(name)			//some of these are probably obsolete
		if("monkey")
			monkeystart += loc
			delete_me = 1
		if("start")
			newplayer_start += loc
			delete_me = 1
		if("JoinLate") // Bit difference, since we need the spawn point to move.
			latejoin += src
			simulated = 1
		if("JoinLateGateway")
			latejoin_gateway += loc
			delete_me = 1
		if("JoinLateElevator")
			latejoin_elevator += loc
			delete_me = 1
		if("JoinLateCheckpoint")
			latejoin_checkpoint += loc
			delete_me = 1
		if("JoinLateWilderness")
			latejoin_wilderness += loc
			delete_me = 1
		if("JoinLateCryo")
			latejoin_cryo += loc
			delete_me = 1
		if("JoinLateCyborg")
			latejoin_cyborg += loc
			delete_me = 1
		if("prisonwarp")
			prisonwarp += loc
			delete_me = 1
		if("Holding Facility")
			holdingfacility += loc
		if("tdome1")
			tdome1 += loc
		if("tdome2")
			tdome2 += loc
		if("tdomeadmin")
			tdomeadmin += loc
		if("tdomeobserve")
			tdomeobserve += loc
		if("prisonsecuritywarp")
			prisonsecuritywarp += loc
			delete_me = 1
		if("blobstart")
			blobstart += loc
			delete_me = 1
		if("xeno_spawn")
			xeno_spawn += loc
			delete_me = 1
		if("endgame_exit")
			endgame_safespawns += loc
			delete_me = 1
		if("bluespacerift")
			endgame_exits += loc
			delete_me = 1

	if(delete_me)
		return INITIALIZE_HINT_QDEL

	landmarks_list += src

/obj/effect/landmark/proc/delete()
	delete_me = 1

/obj/effect/landmark/Destroy(var/force = FALSE)
	if(delete_me || force)
		landmarks_list -= src
		return ..()
	return QDEL_HINT_LETMELIVE

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/effect/landmark/start/Initialize()
	. = ..()
	tag = "start*[name]"
	invisibility = 101

	return 1

/obj/effect/landmark/forbidden_level
	delete_me = 1
/obj/effect/landmark/forbidden_level/Initialize()
	. = ..()
	if(using_map)
		using_map.secret_levels |= z
	else
		log_error("[type] mapped in but no using_map")


/obj/effect/landmark/virtual_reality
	name = "virtual_reality"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/effect/landmark/virtual_reality/Initialize()
	. = ..()
	tag = "virtual_reality*[name]"
	invisibility = 101

//Costume spawner landmarks
/obj/effect/landmark/costume/Initialize() //costume spawner, selects a random subclass and disappears
	..()
	if(type == /obj/effect/landmark/costume)
		var/list/options = subtypesof(/obj/effect/landmark/costume)
		var/PICK = options[rand(1,options.len)]
		new PICK(src.loc)
	return INITIALIZE_HINT_QDEL

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/Initialize()
	..()
	new /obj/item/clothing/suit/costume/chickensuit(src.loc)
	new /obj/item/clothing/head/collectable/chicken(src.loc)
	new /obj/item/reagent_containers/food/snacks/egg(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/gladiator/Initialize()
	..()
	new /obj/item/clothing/under/costume/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/collectable/gladiator(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/madscientist/Initialize()
	..()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/toggle/labcoat/mad(src.loc)
	new /obj/item/clothing/glasses/gglasses(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/elpresidente/Initialize()
	..()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/smokable/cigarette/cigar/havana(src.loc)
	new /obj/item/clothing/shoes/boots/jackboots(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/nyangirl/Initialize()
	..()
	new /obj/item/clothing/under/costume/schoolgirl(src.loc)
	new /obj/item/clothing/head/kitty(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/maid/Initialize()
	..()
	new /obj/item/clothing/under/skirt(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/butler/Initialize()
	..()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/highlander/Initialize()
	..()
	new /obj/item/clothing/under/costume/kilt(src.loc)
	new /obj/item/clothing/head/beret(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/prig/Initialize()
	..()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(src.loc)
	new /obj/item/clothing/shoes/black(src.loc)
	new /obj/item/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/plaguedoctor/Initialize()
	..()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	new /obj/item/clothing/head/collectable/plaguedoctorhat(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/nightowl/Initialize()
	..()
	new /obj/item/clothing/under/costume/owl(src.loc)
	new /obj/item/clothing/mask/gas/costume/owl_mask(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/waiter/Initialize()
	..()
	new /obj/item/clothing/under/waiter(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new CHOICE(src.loc)
	new /obj/item/clothing/suit/storage/apron(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/pirate/Initialize()
	..()
	new /obj/item/clothing/under/costume/pirate(src.loc)
	new /obj/item/clothing/suit/costume(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/collectable/pirate , /obj/item/clothing/head/bandana )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/commie/Initialize()
	..()
	new /obj/item/clothing/under/costume/soviet(src.loc)
	new /obj/item/clothing/head/ushanka(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/holiday_priest/Initialize()
	..()
	new /obj/item/clothing/suit/costume/holidaypriest(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/marisawizard/fake/Initialize()
	..()
	new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/cutewitch/Initialize()
	..()
	new /obj/item/clothing/under/sundress(src.loc)
	new /obj/item/clothing/head/collectable/witchwig(src.loc)
	new /obj/item/staff/broom(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/fakewizard/Initialize()
	..()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/staff/(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/sexyclown/Initialize()
	..()
	new /obj/item/clothing/mask/gas/costume/sexyclown(src.loc)
	new /obj/item/clothing/under/costume/sexyclown(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/sexymime/Initialize()
	..()
	new /obj/item/clothing/mask/gas/costume/sexymime(src.loc)
	new /obj/item/clothing/under/costume/sexymime(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/crashed_pod
	name = "Crash Survivor Spawn"
	delete_me = FALSE

/obj/effect/landmark/snowy_turf
	name = "snowy turf"
	desc = "This landmark will cause the turf it's on to become covered in snow during Initialize()."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "snow"
	alpha = 25
	/// When initializing, this landmark will set the `snow_layers` of its parent turf to this value.
	var/snow_density = SNOW_HEAVY

/obj/effect/landmark/snowy_turf/Initialize()
	..()
	if (istype(loc, /turf/simulated/floor))
		var/turf/simulated/floor/F = loc
		F.set_snow(snow_density)
	return INITIALIZE_HINT_QDEL
