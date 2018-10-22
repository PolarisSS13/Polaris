
//////////////////////////////////////////////
//			Aquarium Supplies				//
//////////////////////////////////////////////

/obj/item/egg_scoop
	name = "fish egg scoop"
	desc = "A small scoop to collect fish eggs with."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "egg_scoop"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 7

/obj/item/fish_net
	name = "fish net"
	desc = "A tiny net to capture fish with. It's a death sentence!"
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "net"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 7

/obj/item/fish_net/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	user.visible_message("<span class='danger'>\The [user] places the on top of [TU.his] head, [TU.his] fingers tangled in the netting! It looks like [TU.hes] trying to commit suicide.</span>")
	return (OXYLOSS)


/obj/item/fishfood
	name = "fish food can"
	desc = "A small can of Carp's Choice brand fish flakes. The label shows a smiling Space Carp."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "fish_food"
	throwforce = 1
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 7

/obj/item/tank_brush
	name = "aquarium brush"
	desc = "A brush for cleaning the inside of aquariums. Contains a built-in odor neutralizer."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "brush"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 7
	attack_verb = list("scrubbed", "brushed", "scraped")

/obj/item/tank_brush/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	user.visible_message("<span class='danger'>[user] vigorously scrubbing [TU.him] self raw with the [name]! It looks like  [TU.is] trying to commit suicide!</span>")
	return(BRUTELOSS|FIRELOSS)


//////////////////////////////////////////////
//				Fish Items					//
//////////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/snacks/shrimp
	name = "shrimp"
	desc = "A single raw shrimp."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "shrimp_raw"
	filling_color = "#FFF2FF"

	New()
		..()
		desc = pick("Anyway, like I was sayin', shrimp is the fruit of the sea.", "You can barbecue it, boil it, broil it, bake it, saute it.")
		reagents.add_reagent("protein", 1)
		src.bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/feederfish
	name = "feeder fish"
	desc = "A tiny feeder fish. Sure doesn't look very filling..."
	icon = 'icons/obj/seafood.dmi'
	icon_state = "feederfish"
	filling_color = "#FFF2FF"

	New()
		..()
		reagents.add_reagent("protein", 1)
		src.bitesize = 1

/obj/item/fish
	name = "fish"
	desc = "A generic fish"
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "fish"
	throwforce = 1
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 7
	force = 1
	attack_verb = list("slapped", "humiliated", "hit", "rubbed")
	hitsound = 'sound/effects/snap.ogg'
	var/list/produces = null //The fish meat and tooth or stuff


/obj/item/fish/attackby(var/obj/item/O, var/mob/user as mob)
	//if(!produces.len)
		//return
	if(is_sharp(O))
		to_chat(user, "You carefully clean and gut \the [src].")
		for(var/P in produces)
			new P(src.loc)
		qdel(src)
		return
		..()

/obj/item/fish/glofish
	name = "glofish"
	desc = "A small bio-luminescent fish. Not very bright, but at least it's pretty!"
	icon_state = "glofish"

/obj/item/fish/glofish/New()
		..()
		set_light(2,1,"#99FF66")

/obj/item/fish/electric_eel
	name = "electric eel"
	desc = "An eel capable of producing a mild electric shock. Luckily it's rather weak out of water."
	icon_state = "electric_eel"

/obj/item/fish/shark
	name = "shark"
	desc = "Warning: Keep away from tornadoes."
	icon_state = "shark"
	hitsound = 'sound/weapons/bite.ogg'
	force = 3

/obj/item/fish/shark/attackby(var/obj/item/O, var/mob/user as mob)
	...()
	if(istype(O, /obj/item/weapon/tool/wirecutters))
		to_chat(user, "You rip out the teeth of \the [src.name]!")
		new /obj/item/fish/toothless_shark(get_turf(src))
		new /obj/item/shard/shark_teeth(get_turf(src))
		qdel(src)
		return


/obj/item/fish/toothless_shark
	name = "toothless shark"
	desc = "Looks like someone ripped its teeth out!"
	icon_state = "shark"
	hitsound = 'sound/effects/snap.ogg'

/obj/item/shard/shark_teeth
	name = "shark teeth"
	desc = "A number of teeth, supposedly from a shark."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "teeth"
	force = 2.0
	throwforce = 5.0

/obj/item/shard/shark_teeth/New()
	src.pixel_x = rand(-5,5)
	src.pixel_y = rand(-5,5)

/obj/item/fish/catfish
	name = "catfish"
	desc = "Apparently, catfish don't purr like you might have expected them to. Such a confusing name!"
	icon_state = "catfish"
	produces = list(/obj/item/weapon/reagent_containers/food/snacks/catfishmeat, /obj/item/weapon/reagent_containers/food/snacks/catfishmeat)

/obj/item/fish/goldfish
	name = "goldfish"
	desc = "A goldfish, just like the one you never won at the county fair."
	icon_state = "goldfish"

/obj/item/fish/salmon
	name = "salmon"
	desc = "The second-favorite food of Space Bears, right behind crew members."
	icon_state = "salmon"
	produces = list(/obj/item/weapon/reagent_containers/food/snacks/salmonmeat, /obj/item/weapon/reagent_containers/food/snacks/salmonmeat)

/obj/item/fish/babycarp
	name = "baby space carp"
	desc = "Substantially smaller than the space carp lurking outside the hull, but still unsettling."
	icon_state = "babycarp"
	hitsound = 'sound/weapons/bite.ogg'
	force = 3
	produces = list(/obj/item/weapon/reagent_containers/food/snacks/carpmeat)

/obj/item/grown/bananapeel/clownfish
	name = "clown fish"
	desc = "Those eggs look quite Funny."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "clownfish"
	throwforce = 1
	force = 1
	attack_verb = list("slapped", "humiliated", "hit", "rubbed")
