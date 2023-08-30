//Food items that are eaten normally and don't leave anything behind.
/obj/item/reagent_containers/food/snacks
	name = "snack"
	desc = "yummy"
	icon = 'icons/obj/food.dmi'
	icon_state = null
	var/bitesize = 1
	var/bitecount = 0
	var/trash = null
	var/slice_path
	var/slices_num
	var/dried_type = null
	var/dry = 0
	var/survivalfood = FALSE
	var/nutriment_amt = 0
	var/nutriment_allergens = null //Apply allergens to nutriment independent of reagents, for recipes that clear their constituent parts.
	var/list/nutriment_desc = list("food" = 1)
	var/datum/reagent/nutriment/coating/coating = null
	var/icon/flat_icon = null //Used to cache a flat icon generated from dipping in batter. This is used again to make the cooked-batter-overlay
	var/do_coating_prefix = 1 //If 0, we wont do "battered thing" or similar prefixes. Mainly for recipes that include batter but have a special name
	var/cooked_icon = null //Used for foods that are "cooked" without being made into a specific recipe or combination.
	//Generally applied during modification cooking with oven/fryer
	//Used to stop deepfried meat from looking like slightly tanned raw meat, and make it actually look cooked
	var/package = FALSE // If this has a wrapper on it. If true, it will print a message and ask you to remove it
	var/package_trash // Packaged meals drop this trash type item when opened, if set
	var/package_open_state// Packaged meals switch to this state when opened, if set
	center_of_mass = list("x"=16, "y"=16)
	w_class = ITEMSIZE_SMALL
	force = 0

/obj/item/reagent_containers/food/snacks/Initialize()
	. = ..()
	if(nutriment_desc)
		nutriment_desc = TASTE_DATA(get_cached_taste_data("nutriment", nutriment_desc))
	if(nutriment_amt)
		reagents.add_reagent("nutriment", nutriment_amt, nutriment_desc)
	if(nutriment_allergens && reagents)
		for(var/datum/reagent/r in reagents.reagent_list)
			if(r.id == "nutriment")
				r.allergen_type = nutriment_allergens
	if(. != INITIALIZE_HINT_QDEL)
		return INITIALIZE_HINT_LATELOAD

/obj/item/reagent_containers/food/snacks/LateInitialize()
	. = ..()
	nutriment_desc = null

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/reagent_containers/food/snacks/proc/On_Consume(var/mob/M)
	if(!usr)
		usr = M
	if(!reagents.total_volume)
		M.visible_message("<span class='notice'>[M] finishes eating \the [src].</span>","<span class='notice'>You finish eating \the [src].</span>")
		usr.drop_from_inventory(src)	//so icons update :[

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				usr.put_in_hands(trash)
		qdel(src)
	return

/obj/item/reagent_containers/food/snacks/attack_self(mob/user as mob)
	if(package && !user.incapacitated())
		unpackage(user)

/obj/item/reagent_containers/food/snacks/attack(mob/living/M as mob, mob/user as mob, def_zone)
	if(reagents && !reagents.total_volume)
		to_chat(user, "<span class='danger'>None of [src] left!</span>")
		user.drop_from_inventory(src)
		qdel(src)
		return 0

	if(package)
		to_chat(M, "<span class='warning'>How do you expect to eat this with the packaging still on?</span>")
		return FALSE

	if(istype(M, /mob/living/carbon))
		//TODO: replace with standard_feed_mob() call.

		var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
		if(M == user)								//If you're eating it yourself
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(!H.check_has_mouth())
					to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
					return
				var/obj/item/blocked = null
				if(survivalfood)
					blocked = H.check_mouth_coverage_survival()
				else
					blocked = H.check_mouth_coverage()
				if(blocked)
					to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
					return

			user.setClickCooldown(user.get_attack_speed(src)) //puts a limit on how fast people can eat/drink things
			if (fullness <= 50)
				to_chat(M, "<span class='danger'>You hungrily chew out a piece of [src] and gobble it!</span>")
			if (fullness > 50 && fullness <= 150)
				to_chat(M, "<span class='notice'>You hungrily begin to eat [src].</span>")
			if (fullness > 150 && fullness <= 350)
				to_chat(M, "<span class='notice'>You take a bite of [src].</span>")
			if (fullness > 350 && fullness <= 550)
				to_chat(M, "<span class='notice'>You unwillingly chew a bit of [src].</span>")

		else if(user.a_intent == I_HURT)
			return ..()

		else
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(!H.check_has_mouth())
					to_chat(user, "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!")
					return
				var/obj/item/blocked = null
				var/unconcious = FALSE
				blocked = H.check_mouth_coverage()
				if(survivalfood)
					blocked = H.check_mouth_coverage_survival()
					if(H.stat && H.check_mouth_coverage())
						unconcious = TRUE
						blocked = H.check_mouth_coverage()

				if(unconcious)
					to_chat(user, "<span class='warning'>You can't feed [H] through \the [blocked] while they are unconcious!</span>")
					return

				if(blocked)
					to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
					return

				user.visible_message("<span class='danger'>[user] attempts to feed [M] [src].</span>")

				user.setClickCooldown(user.get_attack_speed(src))
				if(!do_mob(user, M)) return

				//Do we really care about this
				add_attack_logs(user,M,"Fed with [src.name] containing [reagentlist(src)]", admin_notify = FALSE)

				user.visible_message("<span class='danger'>[user] feeds [M] [src].</span>")

			else
				to_chat(user, "This creature does not seem to have a mouth!")
				return

		if(reagents)								//Handle ingestion of the reagent.
			playsound(M,'sound/items/eatfood.ogg', rand(10,50), 1)
			if(reagents.total_volume)
				if(reagents.total_volume > bitesize)
					reagents.trans_to_mob(M, bitesize, CHEM_INGEST)
				else
					reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
				bitecount++
				On_Consume(M)
			return 1

	return 0

/obj/item/reagent_containers/food/snacks/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(coating)
			. += "<span class='notice'>It's coated in [coating.name]!</span>"
		if(bitecount==0)
			return .
		else if (bitecount==1)
			. += "<span class='notice'>It was bitten by someone!</span>"
		else if (bitecount<=3)
			. += "<span class='notice'>It was bitten [bitecount] times!</span>"
		else
			. += "<span class='notice'>It was bitten multiple times!</span>"

/obj/item/reagent_containers/food/snacks/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/storage))
		. = ..() // -> item/attackby()
		return

	// Eating with forks
	if(istype(W,/obj/item/material/kitchen/utensil))
		var/obj/item/material/kitchen/utensil/U = W
		U.load_food(user, src)
		return

	if (is_sliceable())
		//these are used to allow hiding edge items in food that is not on a table/tray
		var/can_slice_here = isturf(src.loc) && ((locate(/obj/structure/table) in src.loc) || (locate(/obj/machinery/optable) in src.loc) || (locate(/obj/item/tray) in src.loc))
		var/hide_item = !has_edge(W) || !can_slice_here

		if (hide_item)
			if (W.w_class >= src.w_class || is_robot_module(W))
				return

			to_chat(user, "<span class='warning'>You slip \the [W] inside \the [src].</span>")
			user.drop_from_inventory(W, src)
			add_fingerprint(user)
			contents += W
			return

		if (has_edge(W))
			if (!can_slice_here)
				to_chat(user, "<span class='warning'>You cannot slice \the [src] here! You need a table or at least a tray to do it.</span>")
				return

			var/slices_lost = 0
			if (W.w_class > 3)
				user.visible_message("<span class='notice'>\The [user] crudely slices \the [src] with [W]!</span>", "<span class='notice'>You crudely slice \the [src] with your [W]!</span>")
				slices_lost = rand(1,min(1,round(slices_num/2)))
			else
				user.visible_message("<span class='notice'>\The [user] slices \the [src]!</span>", "<span class='notice'>You slice \the [src]!</span>")

			var/reagents_per_slice = reagents.total_volume/slices_num
			for(var/i=1 to (slices_num-slices_lost))
				var/obj/slice = new slice_path (src.loc)
				reagents.trans_to_obj(slice, reagents_per_slice)
			qdel(src)
			return

/obj/item/reagent_containers/food/snacks/proc/is_sliceable()
	return (slices_num && slice_path && slices_num > 0)

/obj/item/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.dropInto(loc)
	. = ..()

/obj/item/reagent_containers/food/snacks/proc/unpackage(mob/user)
	package = FALSE
	to_chat(user, "<span class='notice'>You tear open the plastic on \the [src]</span>")
	playsound(user,'sound/effects/packagedfoodopen.ogg', 15, 1)
	if(package_trash)
		var/obj/item/T = new package_trash
		user.put_in_hands(T)
	if(package_open_state)
		icon_state = package_open_state

/obj/item/reagent_containers/food/snacks/is_slime_food()
	return TRUE

/obj/item/reagent_containers/food/snacks/slime_chomp(mob/living/simple_mob/slime/xenobio/slime)
	if (package)
		unpackage(slime)
	// Reagents are only for carbons (for now), so we calculate and apply nutrition manually
	var/nutrition_total = 1
	if (reagents?.total_volume)
		for (var/V in reagents.reagent_list)
			var/datum/reagent/R = V
			if (istype(R, /datum/reagent/nutriment))
				var/datum/reagent/nutriment/N = R
				nutrition_total += N.volume * round(N.nutriment_factor / (N.allergen_type & ALLERGEN_MEAT ? 15 : 30))
	slime.adjust_nutrition(nutrition_total)
	slime.visible_message(
		SPAN_NOTICE("\The [slime] [pick("absorbs", "consumes", "devours", "eats", "engulfs", "envelops", "schlorps up", "vacuums up")] \the [src]!"),
		SPAN_NOTICE("You absorb \the [src]!")
	)
	playsound(slime, 'sound/items/eatfood.ogg', rand(10, 50), TRUE)
	playsound(slime, 'sound/effects/slime_squish.ogg', 30, TRUE)
	if (trash)
		new trash (get_turf(src))
	qdel(src)

////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/snacks/attack_generic(var/mob/living/user)
	if(isanimal(user))
		var/mob/living/simple_mob/animal/critter = user
		if(!critter.has_appetite())
			to_chat(critter, SPAN_WARNING("You don't have much of an appetite at the moment."))
			return TRUE
		critter.eat_food_item(src, bitesize)
	else if(istype(user, /mob/living/carbon/diona))
		user.visible_message("<b>[user]</b> nibbles away at \the [src].","You nibble away at \the [src].")
		if(reagents)
			reagents.trans_to_mob(user, bitesize, CHEM_INGEST)
	else
		return FALSE
	bitecount++
	spawn(5)
		if(!src && !user.client)
			user.custom_emote(1,"[pick("burps", "cries for more", "burps twice", "looks at the area where the food was")]")
			qdel(src)
	if(!QDELETED(src))
		On_Consume(user)

/obj/item/reagent_containers/food/snacks/animal_consumed(var/mob/user)
	On_Consume(user)

//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/reagent_containers/food/snacks/xenoburger				//Identification path for the object.
//	name = "Xenoburger"														//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."							//Duh
//	icon_state = "xburger"													//Refers to an icon in food.dmi
//	nutriment_amt = 2														//How much nutriment to add.
//	nutriment_desc = list("heresy" = 2)										//The taste string for specifically the 'nutriment' added according to nutriment_amt. Does not override tastes of other reagents/ingredients introduced in recipes. Clear reagents in recipe datum if you want ONLY this string.
// 	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_GRAINS						//Any allergens present in the described nutriment. Useful for when a recipe has had its reagents cleared but should contain e.g. nuts, without having to add a special nut reagent which may mess with taste.
//	bitesize = 3															//This is the amount each bite consumes.
///obj/item/reagent_containers/food/snacks/xenoburger/Initialize()			//Don't mess with this. (We use Initialize now instead of New())
//	. = ..()																//Same here.
//	reagents.add_reagent("xenomicrobes", 10)								//This is what is in the food item. you may copy/paste this line of code for all the contents.
//	reagents.add_reagent("protein", 10, TASTE_DATA(list("caustic meat" = 10)))			//As above. Subtypes of nutriment may be assigned taste string overrides as so. It's recommended to add e.g. protein for meats as these nutriment subtypes often have special behaviour (e.g. unathi meat benefits), pre-built allergens etc.




/obj/item/reagent_containers/food/snacks/aesirsalad
	name = "\improper Aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468C00"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_amt = 8
	nutriment_desc = list("apples" = 3,"salad" = 5)
	nutriment_allergens = ALLERGEN_FRUIT
	bitesize = 3

/obj/item/reagent_containers/food/snacks/aesirsalad/Initialize()
	. = ..()
	reagents.add_reagent("doctorsdelight", 8)
	reagents.add_reagent("tricordrazine", 8)

/obj/item/reagent_containers/food/snacks/candy/donor
	name = "donor candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy
	nutriment_amt = 9
	nutriment_desc = list("candy" = 10)
	nutriment_allergens = ALLERGEN_SUGARS // It's literally just sugar
	bitesize = 5

/obj/item/reagent_containers/food/snacks/candy/donor/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_containers/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Cannot be stored in a detective's hat, alas."
	description_fluff = "Nobody knows why Nanotrasen keeps making these waxy pieces of sugar and bone glue, but a handful of people swear by them. Purportedly popular with Skrell children, dubiously enough."
	icon_state = "candy_corn"
	filling_color = "#FFFCB0"
	center_of_mass = list("x"=14, "y"=10)
	nutriment_amt = 4
	nutriment_desc = list("waxy sugar" = 2, "vanilla marshmallow flavouring")
	nutriment_allergens = ALLERGEN_SUGARS // It's literally just sugar and... Who knows what.
	bitesize = 2

/obj/item/reagent_containers/food/snacks/candy_corn/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_containers/food/snacks/chocolatebar //not a vending item
	name = "chocolate bar"
	desc = "Such sweet, fattening food."
	icon_state = "chocolatebar"
	filling_color = "#7D5F46"
	center_of_mass = list("x"=15, "y"=15)
	nutriment_amt = 2
	nutriment_desc = list("chocolate" = 5)
	nutriment_allergens = ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chocolatebar/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("coco", 2)

/obj/item/reagent_containers/food/snacks/chocolatepiece
	name = "chocolate piece"
	desc = "A luscious milk chocolate piece filled with gooey caramel."
	icon_state =  "chocolatepiece"
	filling_color = "#7D5F46"
	center_of_mass = list("x"=15, "y"=15)
	nutriment_amt = 1
	nutriment_desc = list("chocolate" = 3, "caramel" = 2, "lusciousness" = 1)
	nutriment_allergens = ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chocolatepiece/white
	name = "white chocolate piece"
	desc = "A creamy white chocolate piece drizzled in milk chocolate."
	icon_state = "chocolatepiece_white"
	filling_color = "#E2DAD3"
	nutriment_desc = list("white chocolate" = 3, "creaminess" = 1)

/obj/item/reagent_containers/food/snacks/chocolatepiece/truffle
	name = "chocolate truffle"
	desc = "A bite-sized milk chocolate truffle that could buy anyone's love."
	icon_state = "chocolatepiece_truffle"
	nutriment_desc = list("chocolate" = 3, "undying devotion" = 3)

/obj/item/reagent_containers/food/snacks/chocolateegg
	name = "chocolate egg"
	desc = "Predates the chocolate chicken."
	icon_state = "chocolateegg"
	filling_color = "#7D5F46"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 5)
	nutriment_allergens = ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chocolateegg/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("coco", 2)

/obj/item/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with coffee."
	description_fluff = "These donuts claim to be made fresh daily in a boutique bakery in New Reykjavik and delivered to Nanotrasen's hardworking asset protection crew. They're probably synthesized."
	icon = 'icons/obj/food_donuts.dmi'
	icon_state = "donut"
	filling_color = "#D9C386"
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweetness" = 5, "fried dough" = 5),
		SPECIES_TESHARI      = list("fried dough" = 10)
	)
	nutriment_amt = 3
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_EGGS|ALLERGEN_GRAINS
	bitesize = 4
	var/overlay_state = "donut_inbox"

/obj/item/reagent_containers/food/snacks/donut/plain
	name = "plain donut"
	icon_state = "donut"
	desc = "A plain ol' donut."

/obj/item/reagent_containers/food/snacks/donut/plain/jelly
	name = "plain jelly donut"
	icon_state = "jelly"
	desc = "At least this one has jelly!"

/obj/item/reagent_containers/food/snacks/donut/plain/jelly/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/pink
	name = "pink frosted donut"
	icon_state = "donut_pink"
	desc = "This one has pink frosting!"
	overlay_state = "donut_pink_inbox"

/obj/item/reagent_containers/food/snacks/donut/pink/jelly
	name = "pink frosted jelly donut"
	icon_state = "jelly_pink"
	desc = "This one has pink frosting and a jelly filling!"

/obj/item/reagent_containers/food/snacks/donut/pink/jelly/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/purple
	name = "purple frosted donut"
	icon_state = "donut_purple"
	desc = "This one has purple frosting!"
	overlay_state = "donut_purple_inbox"

/obj/item/reagent_containers/food/snacks/donut/purple/jelly
	name = "purple frosted jelly donut"
	icon_state = "jelly_purple"
	desc = "This one has purple frosting and a jelly filling!"

/obj/item/reagent_containers/food/snacks/donut/purple/jelly/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/green
	name = "green frosted donut"
	icon_state = "donut_green"
	desc = "This one has green frosting!"
	overlay_state = "donut_green_inbox"

/obj/item/reagent_containers/food/snacks/donut/green/jelly
	name = "green frosted jelly donut"
	icon_state = "jelly_green"
	desc = "This one has green frosting and a jelly filling!"

/obj/item/reagent_containers/food/snacks/donut/green/jelly/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/beige
	name = "beige frosted donut"
	icon_state = "donut_beige"
	desc = "This one has beige frosting!"
	overlay_state = "donut_beige_inbox"

/obj/item/reagent_containers/food/snacks/donut/beige/jelly
	name = "beige frosted jelly donut"
	icon_state = "jelly_beige"
	desc = "This one has beige frosting and a jelly filling!"

/obj/item/reagent_containers/food/snacks/donut/beige/jelly/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/choc
	name = "chocolate frosted donut"
	icon_state = "donut_choc"
	desc = "This one has chocolate frosting!"
	overlay_state = "donut_choc_inbox"

/obj/item/reagent_containers/food/snacks/donut/choc/jelly
	name = "chocolate frosted jelly donut"
	icon_state = "jelly_choc"
	desc = "This one has chocolate frosting and a jelly filling!"

/obj/item/reagent_containers/food/snacks/donut/choc/jelly/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/blue
	name = "blue frosted donut"
	icon_state = "donut_blue"
	desc = "This one has blue frosting!"
	overlay_state = "donut_blue_inbox"

/obj/item/reagent_containers/food/snacks/donut/blue/jelly
	name = "blue frosted jelly donut"
	icon_state = "jelly_blue"
	desc = "This one has blue frosting and a jelly filling!"

/obj/item/reagent_containers/food/snacks/donut/blue/jelly/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/yellow
	name = "yellow frosted donut"
	icon_state = "donut_yellow"
	desc = "This one has yellow frosting!"
	overlay_state = "donut_yellow_inbox"

/obj/item/reagent_containers/food/snacks/donut/yellow/jelly
	name = "yellow frosted jelly donut"
	icon_state = "jelly_yellow"
	desc = "This one has yellow frosting and a jelly filling!"

/obj/item/reagent_containers/food/snacks/donut/yellow/jelly/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/olive
	name = "olive frosted donut"
	icon_state = "donut_olive"
	desc = "This one has olive frosting!"
	overlay_state = "donut_olive_inbox"

/obj/item/reagent_containers/food/snacks/donut/olive/jelly
	name = "olive frosted jelly donut"
	icon_state = "jelly_olive"
	desc = "This one has olive frosting and a jelly filling!"

/obj/item/reagent_containers/food/snacks/donut/olive/jelly/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/homer
	name = "frosted donut with sprinkles"
	icon_state = "donut_homer"
	desc = "It's a d'ohnut!"
	overlay_state = "donut_homer_inbox"

/obj/item/reagent_containers/food/snacks/donut/homer/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)

/obj/item/reagent_containers/food/snacks/donut/homer/jelly
	name = "frosted jelly donut with sprinkles"
	icon_state = "jelly_homer"
	desc = "It's a d'ohnut with jelly filling!"

/obj/item/reagent_containers/food/snacks/donut/homer/jelly/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/choc_sprinkles
	name = "chocolate sprinkles donut"
	icon_state = "donut_choc_sprinkles"
	desc = "Mmm, chocolate with sprinkles... approaching maximum donut."
	overlay_state = "donut_choc_sprinkles_inbox"

/obj/item/reagent_containers/food/snacks/donut/choc_sprinkles/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)

/obj/item/reagent_containers/food/snacks/donut/choc_sprinkles/jelly
	name = "chocolate sprinkles jelly donut"
	icon_state = "jelly_choc_sprinkles"
	desc = "Pretty sure this is the most sugar you can pack into a donut."

/obj/item/reagent_containers/food/snacks/donut/choc_sprinkles/jelly/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/meat
	name = "meat donut"
	icon_state = "donut_meat"
	desc = "This donut has ... meat? Is it made of meat?!"
	overlay_state = "donut_meat_inbox"
	nutriment_allergens = ALLERGEN_MEAT

/obj/item/reagent_containers/food/snacks/donut/meat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, nutriment_desc)

/obj/item/reagent_containers/food/snacks/donut/laugh
	name = "laugh donut"
	icon_state = "donut_laugh"
	desc = "Try not to laugh."
	overlay_state = "donut_laugh_inbox"

/obj/item/reagent_containers/food/snacks/donut/laugh/jelly
	name = "laugh jelly donut"
	icon_state = "jelly_laugh"
	desc = "Try not to be jelly."

/obj/item/reagent_containers/food/snacks/donut/laugh/jelly/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/chaos
	name = "chaos donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut_chaos"
	filling_color = "#ED11E6"
	nutriment_amt = 2
	bitesize = 10
	overlay_state = "donut_chaos_inbox"

/obj/item/reagent_containers/food/snacks/donut/chaos/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 1)
	switch(rand(1,10))
		if(1)
			reagents.add_reagent("nutriment", 3, nutriment_desc)
		if(2)
			reagents.add_reagent("capsaicin", 3)
		if(3)
			reagents.add_reagent("frostoil", 3)
		if(4)
			reagents.add_reagent("sprinkles", 3)
		if(5)
			reagents.add_reagent("phoron", 3)
		if(6)
			reagents.add_reagent("coco", 3)
		if(7)
			reagents.add_reagent("slimejelly", 3)
		if(8)
			reagents.add_reagent("banana", 3)
		if(9)
			reagents.add_reagent("berryjuice", 3)
		if(10)
			reagents.add_reagent("tricordrazine", 3)
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Chaos Donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_containers/food/snacks/donut/plain/jelly/poisonberry
	filling_color = "#ED1169"

/obj/item/reagent_containers/food/snacks/donut/plain/jelly/poisonberry/Initialize()
	. = ..()
	reagents.add_reagent("poisonberryjuice", 5)

/obj/item/reagent_containers/food/snacks/donut/plain/jelly/slimejelly
	filling_color = "#ED1169"

/obj/item/reagent_containers/food/snacks/donut/plain/jelly/slimejelly/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/donut/plain/jelly/cherryjelly
	filling_color = "#ED1169"

/obj/item/reagent_containers/food/snacks/donut/plain/jelly/cherryjelly/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#FDFFD1"
	volume = 10
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/snacks/egg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 3)

/obj/item/reagent_containers/food/snacks/egg/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(istype(O,/obj/machinery/microwave))
		return . = ..()
	if(!(proximity && O.is_open_container()))
		return
	to_chat(user, "You crack \the [src] into \the [O].")
	reagents.trans_to(O, reagents.total_volume)
	user.drop_from_inventory(src)
	qdel(src)

/obj/item/reagent_containers/food/snacks/egg/throw_impact(atom/hit_atom)
	. = ..()
	new/obj/effect/decal/cleanable/egg_smudge(src.loc)
	src.reagents.splash(hit_atom, reagents.total_volume)
	src.visible_message("<font color='red'>[src.name] has been squashed.</font>","<font color='red'>You hear a smack.</font>")
	qdel(src)

/obj/item/reagent_containers/food/snacks/egg/attackby(obj/item/W as obj, mob/user as mob)
	if(istype( W, /obj/item/pen/crayon ))
		var/obj/item/pen/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, "<font color='blue'>The egg refuses to take on this color!</font>")
			return

		to_chat(usr, "<font color='blue'>You color \the [src] [clr]</font>")
		icon_state = "egg-[clr]"
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/egg/blue
	icon_state = "egg-blue"

/obj/item/reagent_containers/food/snacks/egg/green
	icon_state = "egg-green"

/obj/item/reagent_containers/food/snacks/egg/mime
	icon_state = "egg-mime"

/obj/item/reagent_containers/food/snacks/egg/orange
	icon_state = "egg-orange"

/obj/item/reagent_containers/food/snacks/egg/purple
	icon_state = "egg-purple"

/obj/item/reagent_containers/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"

/obj/item/reagent_containers/food/snacks/egg/red
	icon_state = "egg-red"

/obj/item/reagent_containers/food/snacks/egg/yellow
	icon_state = "egg-yellow"

/obj/item/reagent_containers/food/snacks/friedegg
	name = "fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#FFDF78"
	center_of_mass = list("x"=16, "y"=14)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/friedegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_containers/food/snacks/boiledegg
	name = "boiled egg"
	desc = "A hard boiled egg."
	icon_state = "egg"
	filling_color = "#FFFFFF"

/obj/item/reagent_containers/food/snacks/boiledegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 3)

/obj/item/reagent_containers/food/snacks/organ
	name = "organ"
	desc = "It's good for you."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"
	center_of_mass = list("x"=16, "y"=16)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/organ/Initialize(var/ml, var/obj/item/organ/donor)
	. = ..()
	reagents.add_reagent("protein", rand(3,5))
	reagents.add_reagent("toxin", rand(1,3))
	if(donor)
		appearance = donor
		if(donor.reagents?.total_volume)
			donor.reagents.trans_to(src, donor.reagents.total_volume)
		fingerprints =       donor.fingerprints?.Copy()
		fingerprintshidden = donor.fingerprintshidden?.Copy()
		fingerprintslast =   donor.fingerprintslast
		qdel(donor)

/obj/item/reagent_containers/food/snacks/tofu
	name = "tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=17, "y"=10)
	nutriment_amt = 3
	nutriment_desc = list("tofu" = 3, "goeyness" = 3)
	nutriment_allergens = ALLERGEN_BEANS
	bitesize = 3

/obj/item/reagent_containers/food/snacks/tofurkey
	name = "tofurkey"
	desc = "A fake turkey made from tofu."
	icon_state = "tofurkey"
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_amt = 12
	nutriment_desc = list("herbal seasoning" = 3, "tofu" = 5, "goeyness" = 4)
	nutriment_allergens = ALLERGEN_BEANS
	bitesize = 3

/obj/item/reagent_containers/food/snacks/stuffing
	name = "stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#C9AC83"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 3
	nutriment_desc = list("herbs" = 2, "bread" = 2)
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 1

/obj/item/reagent_containers/food/snacks/carpmeat
	name = "fillet"
	desc = "A fillet of carp meat"
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)
	bitesize = 6

	var/toxin_type = "carpotoxin"
	var/toxin_amount = 3

/obj/item/reagent_containers/food/snacks/carpmeat/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 3)
	if(toxin_type && toxin_amount)
		reagents.add_reagent(toxin_type, toxin_amount)

/obj/item/reagent_containers/food/snacks/carpmeat/fish
	desc = "A fillet of fish meat."
	toxin_type = null

/obj/item/reagent_containers/food/snacks/carpmeat/fish/sif
	desc = "A fillet of sivian fish meat."
	filling_color = "#2c2cff"
	color = "#2c2cff"

/obj/item/reagent_containers/food/snacks/fishfingers
	name = "fish fingers"
	desc = "You didn't think fish had those?"
	icon_state = "fishfingers"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_amt = 2
	nutriment_desc = list("fried batter" = 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fishfingers/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 4, TASTE_DATA(list("fried fish" = 4)))

/obj/item/reagent_containers/food/snacks/zestfish
	name = "zesty fish"
	desc = "Lightly seasoned fish fillets."
	icon_state = "zestfish"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/zestfish/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 4, TASTE_DATA(list("lemon-infused fish meat" = 4)))

/obj/item/reagent_containers/food/snacks/mushroomslice
	name = "mushroom slice"
	desc = "A slice of mushroom."
	icon_state = "hugemushroomslice"
	filling_color = "#E0D7C5"
	center_of_mass = list("x"=17, "y"=16)
	nutriment_amt = 3
	nutriment_desc = list("raw mushroom" = 3)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/mushroomslice/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 3)

/obj/item/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato"
	icon_state = "tomatomeat"
	filling_color = "#DB0000"
	center_of_mass = list("x"=17, "y"=16)
	nutriment_amt = 3
	nutriment_desc = list("raw tomato" = 3)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#DB0000"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/bearmeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 12, TASTE_DATA(list("gamey meat" = 12)))
	reagents.add_reagent("hyperzine", 5)

/obj/item/reagent_containers/food/snacks/xenomeat
	name = "xenomeat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/xenomeat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("faintly metallic meat" = 6)))
	reagents.add_reagent("pacid",6)

/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat // Substitute for recipes requiring xeno meat.
	name = "spider meat"
	desc = "A slab of green meat."
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat/Initialize()
	. = ..()
	reagents.add_reagent("spidertoxin",6)
	reagents.remove_reagent("pacid",6)

/obj/item/reagent_containers/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#DB0000"
	center_of_mass = list("x"=16, "y"=16)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, TASTE_DATA(list("ground meat" = 3)))

/obj/item/reagent_containers/food/snacks/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	filling_color = "#DB0000"
	center_of_mass = list("x"=16, "y"=16)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sausage/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("mildly seasoned meat" = 6)))

/obj/item/reagent_containers/food/snacks/donkpocket
	name = "\improper Donk-pocket"
	desc = "The food of choice for the seasoned slob."
	description_fluff = "Donk-pockets were originally a NanoTrasen product, an attempt to break into the food market controlled by Centauri Provisions. Somehow, Centauri wound up with the rights to the Donk brand, ending NanoTrasen's ambitions. They taste pretty okay."
	icon_state = "donkpocket"
	filling_color = "#DEDEAB"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 2
	nutriment_desc = list("grease" = 1, "undercooked dough" = 2)
	var/warm = FALSE
	var/list/heated_reagents = list("tricordrazine" = 5)

/obj/item/reagent_containers/food/snacks/donkpocket/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2, TASTE_DATA(list("salty meat mush" = 2)))

/obj/item/reagent_containers/food/snacks/donkpocket/proc/heat()
	warm = 1
	for(var/reagent in heated_reagents)
		reagents.add_reagent(reagent, heated_reagents[reagent])
	bitesize = 6
	name = "warm [name]"
	cooltime()

/obj/item/reagent_containers/food/snacks/donkpocket/proc/cooltime()
	if (src.warm)
		spawn(4200)
			src.warm = 0
			for(var/reagent in heated_reagents)
				src.reagents.del_reagent(reagent)
			src.name = initial(name)
	return

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket
	name = "\improper Sin-pocket"
	desc = "The food of choice for the veteran slob. Do <B>NOT</B> overconsume."
	filling_color = "#6D6D00"
	heated_reagents = list("doctorsdelight" = 5, "hyperzine" = 0.75, "synaptizine" = 0.25)
	var/has_been_heated = 0

/obj/item/reagent_containers/food/snacks/donkpocket/sinpocket/attack_self(mob/user)
	if(has_been_heated)
		to_chat(user, "<span class='notice'>The heating chemicals have already been spent.</span>")
		return
	has_been_heated = 1
	user.visible_message("<span class='notice'>[user] crushes \the [src] package.</span>", "You crush \the [src] package and feel a comfortable heat build up.")
	spawn(200)
		to_chat(user, "You think \the [src] is ready to eat about now.")
		heat()

/obj/item/reagent_containers/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	filling_color = "#F2B6EA"
	center_of_mass = list("x"=15, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/brainburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("buttery meat" = 6)))
	reagents.add_reagent("alkysine", 6)

/obj/item/reagent_containers/food/snacks/ghostburger
	name = "ghost burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#FFF2FF"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("bread bun" = 3, "spookiness" = 3)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/human
	var/hname = ""
	var/job = null
	filling_color = "#D63C3C"

/obj/item/reagent_containers/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/human/burger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("mild pork" = 6)))

/obj/item/reagent_containers/food/snacks/cheeseburger
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "cheeseburger"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 2
	nutriment_desc = list("cheese" = 2, "bread bun" = 1)

/obj/item/reagent_containers/food/snacks/cheeseburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, TASTE_DATA(list("grilled meat" = 3)))

/obj/item/reagent_containers/food/snacks/monkeyburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#D63C3C"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 3
	nutriment_desc = list("bread bun" = 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/monkeyburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, TASTE_DATA(list("grilled meat" = 3)))

/obj/item/reagent_containers/food/snacks/fishburger
	name = "fried fish sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 3
	nutriment_desc = list("bread bun" = 2, "fried batter" = 1)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fishburger/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 6, TASTE_DATA(list("fried fish" = 6)))

/obj/item/reagent_containers/food/snacks/tofuburger
	name = "tofu burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 6
	nutriment_desc = list("bread bun" = 2, "imitation meat" = 3)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_BEANS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 2
	nutriment_desc = list("bread bun" = 2, "metal" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"
	volume = 100
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("bread bun" = 2, "metal" = 3)
	bitesize = 0.1

/obj/item/reagent_containers/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	filling_color = "#43DE18"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 3
	nutriment_desc = list("bread bun" = 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/xenoburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8, TASTE_DATA(list("unpleasantly metallic meat" = 8)))

/obj/item/reagent_containers/food/snacks/clownburger
	name = "clown burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	filling_color = "#FF00FF"
	center_of_mass = list("x"=17, "y"=12)
	nutriment_amt = 6
	nutriment_desc = list("bread bun" = 2, "clown shoe" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/mimeburger
	name = "mime burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	filling_color = "#FFFFFF"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 12
	nutriment_desc = list("bread bun" = 2, "ennui" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/omelette
	name = "cheese omelette"
	desc = "Omelette Du Fromage... That's all you can say!"
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#FFF9A8"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/omelette/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8)

/obj/item/reagent_containers/food/snacks/muffin
	name = "muffin"
	desc = "A delicious and spongy little cake."
	icon_state = "muffin"
	filling_color = "#E0CF9B"
	center_of_mass = list("x"=17, "y"=4)
	nutriment_amt = 6
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("mild sweetness" = 3, "fluffy bread" = 3),
		SPECIES_TESHARI      = list("fluffy bread" = 3)
	)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pie
	name = "banana cream pie"
	desc = "Just like back home, on clown planet! HONK!"
	description_fluff = "One of the more esoteric terms of the Nanotrasen-Centauri Noncompetition Agreement of 2545 was a requirement that Nanotrasen stock these pies on all their stations. They're calibrated for comedic value, not taste."
	icon_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#FBFFB8"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_amt = 4
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet wholewheat crust" = 3, "whipped cream" = 2),
		SPECIES_TESHARI      = list("wholewheat crust" = 3, "whipped cream" = 2)
	)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/pie/Initialize()
	. = ..()
	reagents.add_reagent("banana",5)

/obj/item/reagent_containers/food/snacks/pie/throw_impact(atom/hit_atom)
	. = ..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message("<span class='danger'>\The [src.name] splats.</span>","<span class='danger'>You hear a splat.</span>")
	qdel(src)

/obj/item/reagent_containers/food/snacks/berryclafoutis
	name = "berry clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=16, "y"=13)
	nutriment_amt = 4
	nutriment_desc = list("egg custard" = 2, "pie crust" = 3)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_EGGS
	bitesize = 3

/obj/item/reagent_containers/food/snacks/berryclafoutis/berry/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)

/obj/item/reagent_containers/food/snacks/berryclafoutis/poison/Initialize()
	. = ..()
	reagents.add_reagent("poisonberryjuice", 5)

/obj/item/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	filling_color = "#E6DEB5"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_amt = 8
	nutriment_desc = list("toasted batter" = 8)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/eggplantparm
	name = "eggplant parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4D2F5E"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 6
	nutriment_desc = list("mozzarella cheese" = 3, "baked eggplant" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soylentgreen
	name = "soylent green"
	desc = "Not made of people. Honest." //Totally people.
	icon_state = "soylent_green"
	trash = /obj/item/trash/waffles
	filling_color = "#B8E6B5"
	center_of_mass = list("x"=15, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soylentgreen/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10, TASTE_DATA(list("stale bread paste" = 5, "unidentifiable meat" = 5)))

/obj/item/reagent_containers/food/snacks/soylenviridians
	name = "soylent virdians"
	desc = "Not made of people. Honest." //Actually honest for once.
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	filling_color = "#E6FA61"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_amt = 10
	nutriment_desc = list("wet starch" = 10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatpie
	name = "meat-pie"
	icon_state = "meatpie"
	desc = "An old barber's recipe, very delicious!"
	trash = /obj/item/trash/plate
	filling_color = "#948051"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 2
	nutriment_amt = 2
	nutriment_desc = list("savory pastry" = 2)

/obj/item/reagent_containers/food/snacks/meatpie/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8, TASTE_DATA(list("lightly seasoned mince" = 4, "meat gravy" = 4)))

/obj/item/reagent_containers/food/snacks/tofupie
	name = "tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	trash = /obj/item/trash/plate
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_amt = 10
	nutriment_desc = list("lightly seasoned tofu" = 2, "savory pastry" = 8)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_BEANS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	filling_color = "#FFCCCC"
	center_of_mass = list("x"=17, "y"=9)
	nutriment_amt = 5
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweetness" = 2, "sour fungus" = 4, "savory pastry" = 2),
		SPECIES_TESHARI      = list("subtle bitterness" = 2, "sour fungus" = 4, "savory pastry" = 2)
	)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/amanita_pie/Initialize()
	. = ..()
	reagents.add_reagent("amatoxin", 3)
	reagents.add_reagent("psilocybin", 1)

/obj/item/reagent_containers/food/snacks/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	filling_color = "#B8279B"
	center_of_mass = list("x"=17, "y"=9)
	nutriment_amt = 8
	nutriment_desc = list("umami gravy" = 2, "chewy mushroom" = 3, "savory pastry" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/plump_pie/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		reagents.add_reagent("nutriment", 8, nutriment_desc)
		reagents.add_reagent("tricordrazine", 5)

/obj/item/reagent_containers/food/snacks/xemeatpie
	name = "xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	trash = /obj/item/trash/plate
	filling_color = "#43DE18"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/xemeatpie/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10, TASTE_DATA(list("unpleasantly metallic meat" = 10)))

/obj/item/reagent_containers/food/snacks/wingfangchu
	name = "sticky alien wings"
	desc = "A savory dish of questionable alien meat shaped into easily comprehensible pieces, and slathered in a sticky soy sauce."
	icon_state = "wingfangchu"
	trash = /obj/item/trash/small_bowl
	filling_color = "#43DE18"
	center_of_mass = list("x"=17, "y"=9)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/wingfangchu/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("unpleasantly metallic meat" = 5, "hoisin sauce" = 5)))

/obj/item/reagent_containers/food/snacks/human/kabob
	name = "-kabob"
	icon_state = "kabob"
	desc = "A human meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/human/kabob/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8, TASTE_DATA(list("mild chargrilled pork" = 8)))

/obj/item/reagent_containers/food/snacks/monkeykabob
	name = "meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/monkeykabob/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8, TASTE_DATA(list("chargrilled meat" = 8)))

/obj/item/reagent_containers/food/snacks/tofukabob
	name = "tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#FFFEE0"
	bitesize = 2
	center_of_mass = list("x"=17, "y"=15)
	nutriment_amt = 8
	nutriment_desc = list("tofu" = 3, "metal" = 1)
	nutriment_allergens = ALLERGEN_BEANS

/obj/item/reagent_containers/food/snacks/cubancarp
	name = "\improper Cuban carp"
	desc = "A sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"
	center_of_mass = list("x"=12, "y"=5)
	nutriment_amt = 3
	nutriment_desc = list("toasted bread" = 3)
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cubancarp/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 3, TASTE_DATA(list("spiced fish meat" = 3)))
	reagents.add_reagent("capsaicin", 3)

/obj/item/reagent_containers/food/snacks/popcorn
	name = "popcorn"
	desc = "Now let's find some cinema."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	var/unpopped = 0
	filling_color = "#FFFAD4"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_amt = 2
	nutriment_desc = list("toasted corn" = 2, "butter" = 1)
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 0.1 //This snack is supposed to be eaten for a long time.


/obj/item/reagent_containers/food/snacks/popcorn/Initialize()
	. = ..()
	unpopped = rand(1,10)

/obj/item/reagent_containers/food/snacks/popcorn/On_Consume()
	if(prob(unpopped))	//lol ...what's the point?
		to_chat(usr, "<font color='red'>You bite down on an un-popped kernel!</font>")
		unpopped = max(0, unpopped-1)
	. = ..()

/obj/item/reagent_containers/food/snacks/loadedbakedpotato
	name = "loaded baked potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	filling_color = "#9C7A68"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 12
	nutriment_desc = list("baked potato" = 3, "cheese" = 3)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_DAIRY
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fries
	name = "skinny fries"
	desc = "AKA: French Fries, chips, etc."
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 8
	nutriment_desc = list("fresh fries" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bangersandmash
	name = "bangers and mash"
	desc = "An English treat."
	icon_state = "bangersandmash"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list("fluffy potato" = 3, "sausage" = 2)
	nutriment_allergens = ALLERGEN_MEAT
	bitesize = 4

/obj/item/reagent_containers/food/snacks/cheesymash
	name = "cheesy mashed potato"
	desc = "The only thing that could make mash better."
	icon_state = "cheesymash"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list("cheesy potato" = 4)
	nutriment_allergens = ALLERGEN_DAIRY
	bitesize = 2

/obj/item/reagent_containers/food/snacks/blackpudding
	name = "black pudding"
	desc = "This doesn't seem like a pudding at all."
	icon_state = "blackpudding"
	filling_color = "#FF0000"
	center_of_mass = list("x"=16, "y"=7)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/blackpudding/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2, TASTE_DATA(list("seasoned meat" = 2)))
	reagents.add_reagent("blood", 5)

/obj/item/reagent_containers/food/snacks/soydope
	name = "soy dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	trash = /obj/item/trash/plate
	filling_color = "#C4BF76"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 2
	nutriment_desc = list("slime" = 2, "soy" = 2)
	nutriment_allergens = ALLERGEN_BEANS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spagetti
	name = "spaghetti"
	desc = "A bundle of raw spaghetti."
	icon_state = "spagetti"
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 1
	nutriment_desc = list("pasta" = 2)
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cheesyfries
	name = "cheesy fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list("fresh fries" = 3, "cheese" = 3)
	nutriment_allergens = ALLERGEN_DAIRY
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fortunecookie
	name = "fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon_state = "fortune_cookie"
	filling_color = "#E8E79E"
	center_of_mass = list("x"=15, "y"=14)
	nutriment_amt = 3
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet cracker" = 2, "vanilla" = 1),
		SPECIES_TESHARI      = list("cracker" = 2, "vanilla" = 1)
	)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/badrecipe
	name = "burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	filling_color = "#211F02"
	center_of_mass = list("x"=16, "y"=12)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/badrecipe/Initialize()
	. = ..()
	reagents.add_reagent("toxin", 1)
	reagents.add_reagent("carbon", 3)

/obj/item/reagent_containers/food/snacks/meatsteak
	name = "meat steak"
	desc = "Firm, but with a little give. "
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/meatsteak/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("grilled meat" = 4)))
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_containers/food/snacks/spacylibertyduff
	name = "psilocybin duff"
	desc = "Powerful fungal pudding. While geared for skrell tastes, it's as if it came straight from Alfred Hubbard's cookbook."
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42B873"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_amt = 6
	nutriment_desc = list("alcohol" = 3, "fungal umami" = 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/spacylibertyduff/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 6)

/obj/item/reagent_containers/food/snacks/amanitajelly
	name = "amanita jelly"
	desc = "Looks curiously toxic."
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ED0758"
	center_of_mass = list("x"=16, "y"=5)
	nutriment_amt = 6
	nutriment_desc = list("alcohol" = 3, "fungal umami" = 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/amanitajelly/Initialize()
	. = ..()
	reagents.add_reagent("amatoxin", 6)
	reagents.add_reagent("psilocybin", 3)

/obj/item/reagent_containers/food/snacks/poppypretzel
	name = "poppy pretzel"
	desc = "It's all twisted up!"
	icon_state = "poppypretzel"
	bitesize = 2
	filling_color = "#916E36"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 5
	nutriment_desc = list("poppy seeds" = 2, "salty bread" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatballsoup
	name = "meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"
	center_of_mass = list("x"=16, "y"=8)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/meatballsoup/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8, TASTE_DATA(list("meat dumplings" = 8)))

/obj/item/reagent_containers/food/snacks/slimesoup
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	icon_state = "rorosoup" //nonexistant? - 3/1/2020 FIXED. roro's live on. - 7/14/2020 - The fuck are you smoking, roro's is stupid, name it slimesoup so it's clear wtf it is. - 05/03/23 - FIXED; it's roros.
	filling_color = "#C4DBA0"
	nutriment_amt = 6
	nutriment_desc = "chlorine"
	bitesize = 5

/obj/item/reagent_containers/food/snacks/bloodsoup
	name = "tomato soup"
	desc = "Smells like copper."
	icon_state = "tomatosoup"
	filling_color = "#FF0000"
	center_of_mass = list("x"=16, "y"=7)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/bloodsoup/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2, TASTE_DATA(list("something distinctly un-tomato-like" = 2)))
	reagents.add_reagent("blood", 10)

/obj/item/reagent_containers/food/snacks/clownstears
	name = "\improper Clown's Tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	filling_color = "#C4FBFF"
	center_of_mass = list("x"=16, "y"=7)
	nutriment_amt = 4
	nutriment_desc = list("salt" = 1, "the worst joke" = 3)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/clownstears/Initialize()
	. = ..()
	reagents.add_reagent("banana", 5)
	reagents.add_reagent("water", 10)

/obj/item/reagent_containers/food/snacks/vegetablesoup
	name = "vegetable soup"
	desc = "A hearty broth of vegetables, suitable for vegans."
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_amt = 10
	nutriment_desc = list("rich broth" = 2, "carrot" = 2, "corn" = 2, "eggplant" = 2, "potato" = 2)
	nutriment_allergens = ALLERGEN_VEGETABLE
	bitesize = 5

/obj/item/reagent_containers/food/snacks/nettlesoup
	name = "nettle soup"
	desc = "All the ting, none of the sting!"
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"
	center_of_mass = list("x"=16, "y"=7)
	nutriment_amt = 8
	nutriment_desc = list("tangy salad" = 4, "egg" = 2, "potato" = 2)
	nutriment_allergens = ALLERGEN_EGGS
	bitesize = 5

/obj/item/reagent_containers/food/snacks/nettlesoup/Initialize()
	. = ..()
	reagents.add_reagent("water", 5)
	reagents.add_reagent("tricordrazine", 5)

/obj/item/reagent_containers/food/snacks/mysterysoup
	name = "mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F082FF"
	center_of_mass = list("x"=16, "y"=6)
	nutriment_amt = 1
	nutriment_desc = list("backwash" = 1)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/mysterysoup/Initialize()
	. = ..()
	var/mysteryselect = pick(1,2,3,4,5,6,7,8,9,10)
	switch(mysteryselect)
		if(1)
			reagents.add_reagent("nutriment", 6, nutriment_desc)
			reagents.add_reagent("capsaicin", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(2)
			reagents.add_reagent("nutriment", 6, nutriment_desc)
			reagents.add_reagent("frostoil", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(3)
			reagents.add_reagent("nutriment", 5, nutriment_desc)
			reagents.add_reagent("water", 5)
			reagents.add_reagent("tricordrazine", 5)
		if(4)
			reagents.add_reagent("nutriment", 5, nutriment_desc)
			reagents.add_reagent("water", 10)
		if(5)
			reagents.add_reagent("nutriment", 2, nutriment_desc)
			reagents.add_reagent("banana", 10)
		if(6)
			reagents.add_reagent("nutriment", 6, nutriment_desc)
			reagents.add_reagent("blood", 10)
		if(7)
			reagents.add_reagent("slimejelly", 10)
			reagents.add_reagent("water", 10)
		if(8)
			reagents.add_reagent("carbon", 10)
			reagents.add_reagent("toxin", 10)
		if(9)
			reagents.add_reagent("nutriment", 5, nutriment_desc)
			reagents.add_reagent("tomatojuice", 10)
		if(10)
			reagents.add_reagent("nutriment", 6, nutriment_desc)
			reagents.add_reagent("tomatojuice", 5)
			reagents.add_reagent("imidazoline", 5)

/obj/item/reagent_containers/food/snacks/wishsoup
	name = "wish soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D1F4FF"
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/wishsoup/Initialize()
	. = ..()
	reagents.add_reagent("water", 10)
	if(prob(25))
		src.desc = "A wish come true!"
		reagents.add_reagent("nutriment", 8, TASTE_DATA(list("something good" = 8)))

/obj/item/reagent_containers/food/snacks/hotchili
	name = "hot chili"
	desc = "A five alarm Texan Chili!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FF3C00"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_amt = 3
	nutriment_desc = list("chilli peppers" = 3)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/hotchili/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, TASTE_DATA(list("stewed meat" = 3)))
	reagents.add_reagent("capsaicin", 3)
	reagents.add_reagent("tomatojuice", 2)

/obj/item/reagent_containers/food/snacks/coldchili
	name = "cold chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	filling_color = "#2B00FF"
	center_of_mass = list("x"=15, "y"=9)
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 3
	nutriment_desc = list("overwhelming menthol" = 3)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/coldchili/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, TASTE_DATA(list("chilled meat" = 3)))
	reagents.add_reagent("frostoil", 3)
	reagents.add_reagent("tomatojuice", 2)

/obj/item/reagent_containers/food/snacks/cube //Generic version
	name = "dehydrated matter cube"
	desc = "Just add water! Warning: Do not swallow!"
	icon_state = "monkeycube"
	nutriment_amt = 1
	nutriment_desc = list("sawdust" = 1)
	bitesize = 12
	filling_color = "#ADAC7F"
	center_of_mass = list("x"=16, "y"=14)
	w_class = ITEMSIZE_TINY
	atom_flags = ATOM_REAGENTS_IS_OPEN
	var/wrapped = 0
	var/contents_type = "item"
	var/monkey_type = "Monkey"
	var/item_type = /obj/item/stack/material/steel

/obj/item/reagent_containers/food/snacks/cube/Initialize()
	. = ..()

/obj/item/reagent_containers/food/snacks/cube/proc/Expand()
	src.visible_message("<span class='notice'>\The [src] expands!</span>")
	if (contents_type == "mob")
		var/mob/living/carbon/human/H = new(get_turf(src))
		H.set_species(monkey_type)
		H.real_name = H.species.get_random_name()
		H.name = H.real_name
		if(ismob(loc))
			var/mob/M = loc
			M.unEquip(src)
	else if (contents_type == "item")
		new item_type(get_turf(src))
	qdel(src)
	return 1

/obj/item/reagent_containers/food/snacks/cube/attack_self(mob/user as mob)
	if(wrapped)
		Unwrap(user)

/obj/item/reagent_containers/food/snacks/cube/proc/Unwrap(mob/user as mob)
	icon_state = "monkeycube"
	desc = "Just add water!"
	to_chat(user, "You unwrap the cube.")
	wrapped = 0
	atom_flags |= ATOM_REAGENTS_IS_OPEN
	return

/obj/item/reagent_containers/food/snacks/cube/On_Consume(var/mob/M)
	var/mob/living/carbon/human/H = M
	if(ishuman(M))
		if (contents_type == "mob")
			H.visible_message("<span class='warning'>A screeching creature bursts out of [M]'s chest!</span>")
			var/obj/item/organ/external/organ = H.get_organ(BP_TORSO)
			organ.take_damage(50, 0, 0, "Animal escaping the ribcage")
		else if (contents_type == "item")
			H.visible_message("<span class='warning'>A rapidly expanding mass bursts from [M]'s mouth!</span>")
			var/obj/item/organ/external/organ = H.get_organ(BP_HEAD)
			organ.take_damage(25, 0, 0, "Large object exiting the mouth")
	Expand()

/obj/item/reagent_containers/food/snacks/cube/on_reagent_change()
	if(reagents.has_reagent("water"))
		Expand()

//Carbon mob cubes

/obj/item/reagent_containers/food/snacks/cube/monkeycube
	name = "monkey cube"
	center_of_mass = list("x"=16, "y"=14)
	contents_type = "mob"

/obj/item/reagent_containers/food/snacks/cube/monkeycube/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)


/obj/item/reagent_containers/food/snacks/cube/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	atom_flags = EMPTY_BITFIELD
	wrapped = 1

/obj/item/reagent_containers/food/snacks/cube/monkeycube/farwacube
	name = "farwa cube"
	monkey_type = "Farwa"

/obj/item/reagent_containers/food/snacks/cube/monkeycube/wrapped/farwacube
	name = "farwa cube"
	monkey_type = "Farwa"

/obj/item/reagent_containers/food/snacks/cube/monkeycube/stokcube
	name = "stok cube"
	monkey_type = "Stok"

/obj/item/reagent_containers/food/snacks/cube/monkeycube/wrapped/stokcube
	name = "stok cube"
	monkey_type = "Stok"

/obj/item/reagent_containers/food/snacks/cube/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type = "Neaera"

/obj/item/reagent_containers/food/snacks/cube/monkeycube/wrapped/neaeracube
	name = "neaera cube"
	monkey_type = "Neaera"

//Food cubes

/obj/item/reagent_containers/food/snacks/cube/protein
	name = "protein cube"
	desc = "A colony of meat cells, just add water! Warning: Do not swallow!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "proteincube"
	item_type = /obj/item/reagent_containers/food/snacks/proteinslab

/obj/item/reagent_containers/food/snacks/cube/on_reagent_change()
	if(reagents.has_reagent("water"))
		Expand()

/obj/item/reagent_containers/food/snacks/cube/protein/Initialize()
	. = ..()
	reagents.add_reagent("meatcolony", 5)

/obj/item/reagent_containers/food/snacks/proteinslab
	name = "protein slab"
	desc = "A slab of near pure protein, extremely artificial, and thoroughly disgusting."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "proteinslab"
	bitesize = 10

/obj/item/reagent_containers/food/snacks/proteinslab/Initialize()
	. = ..()
	reagents.add_reagent("protein", 35, TASTE_DATA(list("bitter chyme" = 35)))

/obj/item/reagent_containers/food/snacks/cube/nutriment
	name = "nutriment cube"
	desc = "A colony of plant cells, Just add water! Warning: Do not swallow!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "nutrimentcube"
	item_type = /obj/item/reagent_containers/food/snacks/nutrimentslab

/obj/item/reagent_containers/food/snacks/cube/nutriment/Initialize()
	. = ..()
	reagents.add_reagent("plantcolony", 5)

/obj/item/reagent_containers/food/snacks/nutrimentslab
	name = "nutriment slab"
	desc = "A slab of near pure plant-based nutrients, extremely artificial, and thoroughly disgusting."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "nutrimentslab"
	bitesize = 10
	nutriment_amt = 20
	nutriment_desc = list("compost" = 50)
	nutriment_allergens = ALLERGEN_VEGETABLE

/obj/item/storage/box/wings/tray
	name = "ration cube tray"
	desc = "A tray of food cubes, the label warns not to consume before adding water or mixing with virusfood."
	icon_state = "tray8"
	icon_base = "tray"
	startswith = 8
	w_class = ITEMSIZE_SMALL
	max_storage_space = ITEMSIZE_COST_TINY * 8
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/cube/protein = 4,
		/obj/item/reagent_containers/food/snacks/cube/nutriment = 4
	)
	can_hold = list(/obj/item/reagent_containers/food/snacks/cube/protein,
					/obj/item/reagent_containers/food/snacks/cube/nutriment)

/obj/item/reagent_containers/food/snacks/locust
	name = "locust"
	desc = "A vibrant bug that looks like a wasp, but is in fact a locust. Crunchy."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "locust"
	nutriment_amt = 4
	nutriment_desc = list("crunchiness" = 1, "goo" = 1)

/obj/item/reagent_containers/food/snacks/locust/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/locust_cooked
	name = "fried locust"
	desc = "A fried locust, extremely crunchy."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "locust_cooked"
	bitesize = 2
	nutriment_amt = 2
	nutriment_desc = list("crunchiness" = 4)

/obj/item/reagent_containers/food/snacks/locust_cooked/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/spellburger
	name = "spell burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	filling_color = "#D505FF"
	nutriment_amt = 6
	nutriment_desc = list("magic" = 3, "bread bun" = 3)
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bigbiteburger
	name = "\improper Big Bite Burger"
	desc = "Forget the Big Mac. THIS is the future!"
	icon_state = "bigbiteburger"
	filling_color = "#E3D681"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 10
	nutriment_desc = list("bread" = 4, "egg" = 2, "grease" = 2)
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_EGGS|ALLERGEN_DAIRY
	bitesize = 3

/obj/item/reagent_containers/food/snacks/bigbiteburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)

/obj/item/reagent_containers/food/snacks/enchiladas
	name = "enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#A36A1F"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_amt = 2
	nutriment_desc = list("corn tortilla" = 2)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/enchiladas/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("spiced meats" = 6)))
	reagents.add_reagent("capsaicin", 6)

/obj/item/reagent_containers/food/snacks/monkeysdelight
	name = "monkey's delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5C3C11"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/monkeysdelight/Initialize()
	. = ..()
	reagents.add_reagent("protein", 10)
	reagents.add_reagent("banana", 5)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_containers/food/snacks/baguette
	name = "baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
	filling_color = "#E3D796"
	center_of_mass = list("x"=18, "y"=12)
	nutriment_amt = 6
	nutriment_desc = list("crusty bread" = 6)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fishandchips
	name = "fish and chips"
	desc = "I do say so myself old chap."
	icon_state = "fishandchips"
	filling_color = "#E3D796"
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 3
	nutriment_desc = list("salt" = 1, "chips" = 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fishandchips/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 3)

/obj/item/reagent_containers/food/snacks/sandwich
	name = "sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	center_of_mass = list("x"=16, "y"=4)
	nutriment_amt = 3
	nutriment_desc = list("bread" = 3, "cheese" = 3)
	nutriment_allergens = ALLERGEN_DAIRY
	bitesize = 2

/obj/item/reagent_containers/food/snacks/clubsandwich
	name = "club sandwich"
	desc = "Tastes like the good feelings when you're part of a clique."
	icon_state = "clubsandwich"
	trash = "obj/item/trash/plate"
	nutriment_amt = 10
	nutriment_desc = list("lettuce and tomato" = 5, "a galactic economy coming together in pursuit of mundane foods" = 3)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_DAIRY|ALLERGEN_EGGS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/clubsandwich/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("chicken" = 3, "bacon" = 3)))

/obj/item/reagent_containers/food/snacks/toastedsandwich
	name = "toasted sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	center_of_mass = list("x"=16, "y"=4)
	nutriment_amt = 5
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/toastedsandwich/Initialize()
	. = ..()
	reagents.add_reagent("carbon", 1)

/obj/item/reagent_containers/food/snacks/grilledcheese
	name = "grilled cheese sandwich"
	desc = "Goes great with tomato soup!"
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	nutriment_amt = 6
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)
	nutriment_allergens = ALLERGEN_DAIRY
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tomatosoup
	name = "tomato soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D92929"
	center_of_mass = list("x"=16, "y"=7)
	nutriment_amt = 3
	nutriment_desc = list("a hint of basil" = 3)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/tomatosoup/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 12)

/obj/item/reagent_containers/food/snacks/rofflewaffles
	name = "fungal waffles"
	desc = "Mushroom based waffles designed for the skrellian palette."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	filling_color = "#FF00F7"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_amt = 8
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("toasted fungal umami" = 7, "sweetness" = 1),
		SPECIES_TESHARI      = list("toasted fungal umami" = 5, "unpleasant bitterness" = 2)
	)
	nutriment_allergens = ALLERGEN_FUNGI
	bitesize = 4

/obj/item/reagent_containers/food/snacks/rofflewaffles/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 8)

/obj/item/reagent_containers/food/snacks/stew
	name = "stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	filling_color = "#9E673A"
	center_of_mass = list("x"=16, "y"=5)
	nutriment_amt = 6
	nutriment_desc = list("tomato" = 2, "potato" = 2, "carrot" = 2, "eggplant" = 2, "mushroom" = 2)
	nutriment_allergens = ALLERGEN_FUNGI|ALLERGEN_MEAT|ALLERGEN_VEGETABLE
	drop_sound = 'sound/items/drop/shovel.ogg'
	pickup_sound = 'sound/items/pickup/shovel.ogg'
	bitesize = 10

/obj/item/reagent_containers/food/snacks/stew/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("imidazoline", 5)
	reagents.add_reagent("water", 5)

/obj/item/reagent_containers/food/snacks/jelliedtoast
	name = "jellied toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "jellytoast"
	trash = /obj/item/trash/plate
	filling_color = "#B572AB"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_amt = 1
	nutriment_desc = list("toasted bread" = 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jelliedtoast/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/jelliedtoast/slime/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/jellyburger
	name = "jelly burger"
	desc = "Culinary delight..?"
	icon_state = "jellyburger"
	filling_color = "#B572AB"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 5
	nutriment_desc = list("jelly-saturated bread" = 5)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/jellyburger/slime/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/jellyburger/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/milosoup
	name = "miso soup"
	desc = "The universe's best soup! Yum!!!"
	icon_state = "milosoup"
	trash = /obj/item/trash/snack_bowl
	center_of_mass = list("x"=16, "y"=7)
	nutriment_amt = 10
	nutriment_desc = list("seaweed" = 5, "umami" = 5)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/stewedsoymeat
	name = "stewed soy meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 8
	nutriment_desc = list("soy" = 4, "tomato" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledspagetti
	name = "boiled spaghetti"
	desc = "A plain dish of noodles, this sucks."
	icon_state = "spagettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 2
	nutriment_desc = list("pasta" = 2)
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledrice
	name = "boiled rice"
	desc = "A boring dish of boring rice."
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_amt = 2
	nutriment_desc = list("rice" = 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ricepudding
	name = "rice pudding"
	desc = "Where's the jam?"
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list("creaminess" = 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/kudzudonburi
	name = "\improper Zhan-Kudzu Overtaker"
	desc = "Seasoned Kudzu and fish donburi."
	icon_state = "kudzudonburi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_amt = 18
	nutriment_desc = list("rice" = 2, "gauze" = 4, "steamed fish" = 10)
	nutriment_allergens = ALLERGEN_FISH
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pastatomato
	name = "spaghetti"
	desc = "Spaghetti and crushed tomatoes."
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 15
	nutriment_desc = list("tomato sauce" = 3, "pasta" = 3)
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_GRAINS
	bitesize = 4

/obj/item/reagent_containers/food/snacks/meatballspagetti
	name = "spaghetti & meatballs"
	desc = "Now that's a nice-y meatball!"
	icon_state = "meatballspagetti"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 4
	nutriment_desc = list("pasta" = 4)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_MEAT
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatballspagetti/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("ground meat" = 4)))

/obj/item/reagent_containers/food/snacks/spesslaw
	name = "beef stroganoff"
	desc = "It doesn't have to be beef."
	icon_state = "spesslaw"
	filling_color = "#DE4545"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 4
	nutriment_desc = list("pasta" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spesslaw/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/carrotfries
	name = "carrot fries"
	desc = "Tasty fries from fresh carrots."
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#FAA005"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 3
	nutriment_desc = list("carrot" = 3,)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/carrotfries/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 3)

/obj/item/reagent_containers/food/snacks/superbiteburger
	name = "\improper Super Bite Burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	filling_color = "#CCA26A"
	center_of_mass = list("x"=16, "y"=3)
	nutriment_amt = 25
	nutriment_desc = list("bread" = 10, "cheese" = 10, "grease" = 10, "fried egg" = 10)
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_EGGS|ALLERGEN_DAIRY
	bitesize = 10

/obj/item/reagent_containers/food/snacks/superbiteburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 25)

/obj/item/reagent_containers/food/snacks/candiedapple
	name = "candied apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple2"
	filling_color = "#F21873"
	center_of_mass = list("x"=15, "y"=13)
	nutriment_amt = 3
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("apple" = 3, "sweetness" = 2),
		SPECIES_TESHARI      = list("apple" = 3, "tacky, chewy blandness" = 1, "mild bitterness" = 1)
	)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/caramelapple
	name = "caramel apple"
	desc = "An apple coated in rich caramel."
	icon_state = "candiedapple1"
	filling_color = "#F21873"
	center_of_mass = list("x"=15, "y"=13)
	nutriment_amt = 3
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("apple" = 3, "caramel" = 3, "sweetness" = 2),
		SPECIES_TESHARI      = list("apple" = 3, "caramel" = 3, "tacky, chewy blandness" = 1, "mild bitterness" = 1)
	)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/applepie
	name = "apple pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon_state = "applepie"
	filling_color = "#E0EDC5"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_amt = 4
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweetness" = 2, "apple" = 2, "sweet pie crust" = 2),
		SPECIES_TESHARI      = list("mild bitterness" = 2, "apple" = 2, "pie crust" = 2)
	)
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_GRAINS|ALLERGEN_SUGARS
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cherrypie
	name = "cherry pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	filling_color = "#FF525A"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweetness" = 2, "cherry" = 2, "sweet pie crust" = 2),
		SPECIES_TESHARI      = list("mild bitterness" = 2, "cherry" = 2, "pie crust" = 2)
	)

	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_GRAINS|ALLERGEN_SUGARS
	bitesize = 3

/obj/item/reagent_containers/food/snacks/twobread
	name = "two bread"
	desc = "It is very bitter and whiny."
	description_fluff = "The most popular recipe from the Morpheus Cyberkinetics cookbook 'Calories for Organics'"
	icon_state = "twobread"
	filling_color = "#DBCC9A"
	center_of_mass = list("x"=15, "y"=12)
	nutriment_amt = 2
	nutriment_desc = list("sourness" = 2, "bread" = 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jellysandwich
	name = "jelly sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9E3A78"
	center_of_mass = list("x"=16, "y"=8)
	nutriment_amt = 2
	nutriment_desc = list("bread" = 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jellysandwich/slime/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/jellysandwich/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_containers/food/snacks/jellysandwich/peanutbutter
	desc = "You wish you had some peanut butter to go with this... Oh wait!"
	icon_state = "pbandj"

/obj/item/reagent_containers/food/snacks/jellysandwich/peanutbutter/Initialize()
	. = ..()
	reagents.add_reagent("peanutbutter", 5)

/obj/item/reagent_containers/food/snacks/boiledslimecore
	name = "boiled slime core"
	desc = "A boiled red thing."
	icon_state = "boiledslimecore"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/boiledslimecore/Initialize()
	. = ..()
	reagents.add_reagent("slimejelly", 5)

/obj/item/reagent_containers/food/snacks/mint
	name = "mint"
	desc = "it is only wafer thin."
	icon_state = "mint"
	filling_color = "#F2F2F2"
	center_of_mass = list("x"=16, "y"=14)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/mint/Initialize()
	. = ..()
	reagents.add_reagent("mint", 1)

/obj/item/reagent_containers/food/snacks/mint/admints
	desc = "Spearmint, peppermint's non-festive cousin."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "admint"

/obj/item/storage/box/admints
	name = "Ad-mints"
	desc = "A pack of air fresheners for your mouth."
	description_fluff = "Ad-mints earned their name, and reputation when a Major Bill's senior executive attended a meeting at a large a marketing firm and was so astounded by the quality of their complimentary mints, that he immediately bought the company - the mints company, not the ad agency - and began providing 'Ad-mints' on every MBT flight."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "admint_pack"
	item_state = "candy"
	slot_flags = SLOT_EARS
	w_class = 1
	starts_with = list(/obj/item/reagent_containers/food/snacks/mint/admints = 6)
	can_hold = list(/obj/item/reagent_containers/food/snacks/mint/admints)
	use_sound = 'sound/items/drop/paper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	max_storage_space = 6
	foldable = null
	trash = /obj/item/trash/admints

/obj/item/reagent_containers/food/snacks/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty cream and mushroom soup."
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E386BF"
	center_of_mass = list("x"=17, "y"=10)
	nutriment_amt = 8
	nutriment_desc = list("creamy mushroom" = 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced dwarven wheat flour."
	icon_state = "phelmbiscuit"
	filling_color = "#CFB4C4"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_amt = 5
	nutriment_desc = list("mushroom bread" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump helmet biscuit"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
		reagents.add_reagent("nutriment", 3, nutriment_desc)

/obj/item/reagent_containers/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F0F2E4"
	center_of_mass = list("x"=17, "y"=10)
	nutriment_amt = 5
	nutriment_desc = "umami"
	nutriment_allergens = ALLERGEN_DAIRY
	bitesize = 1

/obj/item/reagent_containers/food/snacks/beetsoup
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FAC9FF"
	center_of_mass = list("x"=15, "y"=8)
	nutriment_amt = 8
	nutriment_desc = list("sour tomato" = 4, "sour beets" = 4, "vinegar" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/beetsoup/Initialize()
	. = ..()
	name = pick(list("borsch","bortsch","borstch","borsh","borshch","borscht"))

/obj/item/reagent_containers/food/snacks/tossedsalad
	name = "garden salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_amt = 8
	nutriment_desc = list("salad" = 2, "tomato" = 2, "carrot" = 2, "apple" = 2)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"
	center_of_mass = list("x"=17, "y"=11)
	nutriment_amt = 6
	nutriment_desc = list("100% real salad" = 10)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/validsalad/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = "#FFFF00"
	center_of_mass = list("x"=16, "y"=18)
	nutriment_amt = 8
	nutriment_desc = list("apple" = 8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/appletart/Initialize()
	. = ..()
	reagents.add_reagent("gold", 5)

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/reagent_containers/food/snacks/sliceable
	w_class = ITEMSIZE_NORMAL //Whole pizzas and cakes shouldn't fit in a pocket, you can slice them if you want to do that.

/**
 *  A food item slice
 *
 *  This path contains some extra code for spawning slices pre-filled with
 *  reagents.
 */
/obj/item/reagent_containers/food/snacks/slice
	name = "slice of... something"
	var/whole_path  // path for the item from which this slice comes
	var/filled = FALSE  // should the slice spawn with any reagents

/**
 *  Spawn a new slice of food
 *
 *  If the slice's filled is TRUE, this will also fill the slice with the
 *  appropriate amount of reagents. Note that this is done by spawning a new
 *  whole item, transferring the reagents and deleting the whole item, which may
 *  have performance implications.
 */
/obj/item/reagent_containers/food/snacks/slice/Initialize()
	. = ..()
	if(filled)
		var/obj/item/reagent_containers/food/snacks/whole = new whole_path()
		if(whole && whole.slices_num)
			var/reagent_amount = whole.reagents.total_volume/whole.slices_num
			whole.reagents.trans_to_obj(src, reagent_amount)

		qdel(whole)

/obj/item/reagent_containers/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman."
	icon_state = "meatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/meatbread
	slices_num = 5
	filling_color = "#FF7575"
	center_of_mass = list("x"=19, "y"=9)
	nutriment_desc = list("meaty bread" = 10)
	nutriment_amt = 10
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/meatbread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 20)

/obj/item/reagent_containers/food/snacks/slice/meatbread
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FF7575"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/obj/item/reagent_containers/food/snacks/slice/meatbread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/xenomeatbread
	slices_num = 5
	filling_color = "#8AFF75"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("funky bread" = 10)
	nutriment_amt = 10
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 20)

/obj/item/reagent_containers/food/snacks/slice/xenomeatbread
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8AFF75"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread


/obj/item/reagent_containers/food/snacks/slice/xenomeatbread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/bananabread
	name = "banana bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/bananabread
	slices_num = 5
	filling_color = "#EDE5AD"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet bread" = 10),
		SPECIES_TESHARI      = list("fruity bread" = 10, "an unpleasant bitter aftertaste" = 1)
	)
	nutriment_amt = 10
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_GRAINS|ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/bananabread/Initialize()
	. = ..()
	reagents.add_reagent("banana", 20)

/obj/item/reagent_containers/food/snacks/slice/bananabread
	name = "banana bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=8)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/bananabread

/obj/item/reagent_containers/food/snacks/slice/bananabread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/tofubread
	name = "tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/tofubread
	slices_num = 5
	filling_color = "#F7FFE0"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("tofu" = 5, "bread" = 5)
	nutriment_amt = 10
	bitesize = 2
	nutriment_allergens = ALLERGEN_FUNGI|ALLERGEN_GRAINS|ALLERGEN_SUGARS

/obj/item/reagent_containers/food/snacks/slice/tofubread
	name = "tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#F7FFE0"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/tofubread

/obj/item/reagent_containers/food/snacks/slice/tofubread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/carrotcake
	name = "carrot cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/carrotcake
	slices_num = 5
	filling_color = "#FFD675"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 10, "sweetness" = 10, "carrot" = 15),
		SPECIES_TESHARI      = list("cake" = 10, "mild bitterness" = 5, "carrot" = 15)
	)
	nutriment_amt = 25
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_GRAINS|ALLERGEN_SUGARS|ALLERGEN_EGGS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/carrotcake/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 10)

/obj/item/reagent_containers/food/snacks/slice/carrotcake
	name = "carrot cake slice"
	desc = "Carrotty slice of carrot cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD675"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake

/obj/item/reagent_containers/food/snacks/slice/carrotcake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/braincake
	name = "brain cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/braincake
	slices_num = 5
	filling_color = "#E6AEDB"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 10, "sweetness" = 10, "slime" = 15),
		SPECIES_TESHARI      = list("cake" = 10, "mild bitterness" = 5, "slime" = 15)
	)
	nutriment_amt = 15
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_SUGARS|ALLERGEN_EGGS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/braincake/Initialize()
	. = ..()
	reagents.add_reagent("protein", 15)
	reagents.add_reagent("alkysine", 10)

/obj/item/reagent_containers/food/snacks/slice/braincake
	name = "brain cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#E6AEDB"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/braincake

/obj/item/reagent_containers/food/snacks/slice/braincake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/cheesecake
	name = "cheesecake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/cheesecake
	slices_num = 5
	filling_color = "#FAF7AF"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet wholewheat crust" = 5, "sweet cream cheese" = 20),
		SPECIES_TESHARI      = list("wholewheat crust" = 5, "cream cheese" = 20, "a mild bitter aftertaste" = 1)
	)

	nutriment_amt = 25
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_SUGARS|ALLERGEN_EGGS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/cheesecake
	name = "cheesecake slice"
	desc = "Slice of pure cheestisfaction."
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAF7AF"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake

/obj/item/reagent_containers/food/snacks/slice/cheesecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/peanutcake
	name = "peanut cake"
	desc = "DANGEROUSLY nutty. Sometimes literally."
	icon_state = "peanutcake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/peanutcake
	slices_num = 5
	filling_color = "#4F3500"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cake" = 10, "peanuts" = 15)
	nutriment_amt = 25
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_SUGARS|ALLERGEN_EGGS|ALLERGEN_SEEDS //The ultimate food??
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/peanutcake
	name = "peanut cake slice"
	desc = "Slice of nutty goodness."
	icon_state = "peanutcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#4F3500"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/peanutcake

/obj/item/reagent_containers/food/snacks/slice/peanutcake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/plaincake
	name = "spongecake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/plaincake
	slices_num = 5
	filling_color = "#F7EDD5"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 10, "sweetness" = 10, "vanilla" = 15),
		SPECIES_TESHARI      = list("cake" = 10, "mild bitterness" = 5, "vanilla" = 15)
	)
	nutriment_amt = 25
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_EGGS|ALLERGEN_DAIRY|ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/slice/plaincake
	name = "spongecake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#F7EDD5"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/plaincake

/obj/item/reagent_containers/food/snacks/slice/plaincake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/orangecake
	name = "orange cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/orangecake
	slices_num = 5
	filling_color = "#FADA8E"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 10, "sweetness" = 10, "orange marmalade" = 15),
		SPECIES_TESHARI      = list("cake" = 10, "mild bitterness" = 5, "oranges" = 15)
	)
	nutriment_amt = 25
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_EGGS|ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_FRUIT

/obj/item/reagent_containers/food/snacks/slice/orangecake
	name = "orange cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FADA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/orangecake

/obj/item/reagent_containers/food/snacks/slice/orangecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/limecake
	name = "lime cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/limecake
	slices_num = 5
	filling_color = "#CBFA8E"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 10, "sweetness" = 10, "lime marmalade" = 15),
		SPECIES_TESHARI      = list("cake" = 10, "mild bitterness" = 5, "limes" = 15)
	)
	nutriment_amt = 25
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_EGGS|ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_FRUIT

/obj/item/reagent_containers/food/snacks/slice/limecake
	name = "lime cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#CBFA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/limecake

/obj/item/reagent_containers/food/snacks/slice/limecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/lemoncake
	name = "lemon cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/lemoncake
	slices_num = 5
	filling_color = "#FAFA8E"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 10, "sweetness" = 10, "lemon curd" = 15),
		SPECIES_TESHARI      = list("cake" = 10, "mild bitterness" = 5, "lemon curd" = 15)
	)
	nutriment_amt = 25
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_EGGS|ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_FRUIT

/obj/item/reagent_containers/food/snacks/slice/lemoncake
	name = "lemon cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAFA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/lemoncake

/obj/item/reagent_containers/food/snacks/slice/lemoncake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/chocolatecake
	name = "chocolate cake"
	desc = "A cake with added chocolate."
	icon_state = "chocolatecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/chocolatecake
	slices_num = 5
	filling_color = "#805930"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 10, "sweetness" = 10, "ganache" = 10, "chocolate" = 15),
		SPECIES_TESHARI      = list("cake" = 10, "mild bitterness" = 5, "rich bitterness" = 10, "chocolate" = 15)
	)
	nutriment_amt = 20

/obj/item/reagent_containers/food/snacks/slice/chocolatecake
	name = "chocolate cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/chocolatecake

/obj/item/reagent_containers/food/snacks/slice/chocolatecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	name = "cheese wheel"
	desc = "A big wheel of delicious unbranded cheese product."
	icon_state = "cheesewheel"
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge
	slices_num = 5
	filling_color = "#FFF700"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("cheese" = 10)
	nutriment_amt = 10
	nutriment_allergens = ALLERGEN_DAIRY
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesewedge
	name = "cheese wedge"
	desc = "A wedge of delicious unbranded cheese product. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	filling_color = "#FFF700"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/snacks/sliceable/birthdaycake
	name = "birthday cake"
	desc = "Happy birthday..."
	icon_state = "birthdaycake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/birthdaycake
	slices_num = 5
	filling_color = "#FFD6D6"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 10, "sweetness" = 10, "buttercream icing" = 10),
		SPECIES_TESHARI      = list("cake" = 10, "mild bitterness" = 5, "buttercream icing" = 10)
	)

	nutriment_amt = 25
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_EGGS|ALLERGEN_DAIRY|ALLERGEN_GRAINS
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sliceable/birthdaycake/Initialize()
	. = ..()
	reagents.add_reagent("sprinkles", 10)

/obj/item/reagent_containers/food/snacks/slice/birthdaycake
	name = "birthday cake slice"
	desc = "A slice of your birthday."
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD6D6"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/birthdaycake

/obj/item/reagent_containers/food/snacks/slice/birthdaycake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/bread
	name = "bread"
	icon_state = "The foundation of human civilization."
	icon_state = "bread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/bread
	slices_num = 5
	filling_color = "#FFE396"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 6)
	nutriment_amt = 10
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/bread
	name = "bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#D27332"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=4)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/bread

/obj/item/reagent_containers/food/snacks/slice/bread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread
	name = "cream cheese bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/creamcheesebread
	slices_num = 5
	filling_color = "#FFF896"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 6, "cream cheese" = 5)
	nutriment_amt = 20
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/creamcheesebread
	name = "cream cheese Bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFF896"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread

/obj/item/reagent_containers/food/snacks/slice/creamcheesebread/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/watermelonslice
	name = "watermelon slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	filling_color = "#FF3867"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=10)
	nutriment_amt = 5
	nutriment_desc = list("watermelon" = 5)
	nutriment_allergens = ALLERGEN_FRUIT

/obj/item/reagent_containers/food/snacks/sliceable/applecake
	name = "apple cake"
	desc = "A cake centred with apples."
	icon_state = "applecake"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/applecake
	slices_num = 5
	filling_color = "#EBF5B8"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 10, "sweetness" = 10, "baked apple" = 10),
		SPECIES_TESHARI      = list("cake" = 10, "mild bitterness" = 5, "baked apple" = 10)
	)
	nutriment_amt = 25
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_EGGS|ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_FRUIT

/obj/item/reagent_containers/food/snacks/slice/applecake
	name = "apple cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#EBF5B8"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/applecake

/obj/item/reagent_containers/food/snacks/slice/applecake/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	name = "pumpkin pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pumpkinpie
	slices_num = 5
	filling_color = "#F5B951"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet pie crust" = 5, "cream" = 5, "spiced pumpkin" = 5),
		SPECIES_TESHARI      = list("pie crust" = 5, "cream" = 5, "spiced pumpkin" = 5, "mild bitterness" = 1)
	)
	nutriment_amt = 15

/obj/item/reagent_containers/food/snacks/slice/pumpkinpie
	name = "pumpkin pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie

/obj/item/reagent_containers/food/snacks/slice/pumpkinpie/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/cracker
	name = "cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	filling_color = "#F5DEB8"
	center_of_mass = list("x"=16, "y"=6)
	nutriment_desc = list("salt" = 1, "wheat cracker" = 2)
	w_class = ITEMSIZE_TINY
	nutriment_amt = 1



/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/sliceable/pizza
	slices_num = 6
	filling_color = "#BAA14C"

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "\improper Margherita pizza"
	desc = "The golden standard of pizzas."
	icon_state = "pizzamargherita"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/margherita
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "mozzarella cheese" = 15, "fresh basil" = 5)
	nutriment_amt = 40
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_FRUIT
	bitesize = 2


/obj/item/reagent_containers/food/snacks/slice/margherita
	name = "\improper Margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita

/obj/item/reagent_containers/food/snacks/slice/margherita/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple
	name = "ham & pineapple pizza"
	desc = "One of the most debated pizzas in existence."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "pineapple_pizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pineapple
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cooked ham" = 10, "baked pineapple" = 10)
	nutriment_amt = 40
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_FRUIT|ALLERGEN_VEGETABLE|ALLERGEN_MEAT
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/pineapple
	name = "ham & pineapple pizza slice"
	desc = "A slice of contraband."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "pineapple_pizza_slice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple

/obj/item/reagent_containers/food/snacks/slice/pineapple/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "meat pizza"
	desc = "A pizza with meat toppings."
	icon_state = "meatpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/meatpizza
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "mozzarella cheese" = 10, "seasoned sausage" = 15, "ground meat" = 10, "ham" = 10)
	nutriment_amt = 40
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_FRUIT|ALLERGEN_MEAT
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/meatpizza
	name = "meat pizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/obj/item/reagent_containers/food/snacks/slice/meatpizza/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	name = "mushroom pizza"
	desc = "There's so mush room for toppings!"
	icon_state = "mushroompizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/mushroompizza
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "mozzarella cheese" = 5, "baked mushroom" = 10)
	nutriment_amt = 40
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_FRUIT|ALLERGEN_FUNGI
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/mushroompizza
	name = "mushroom pizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/obj/item/reagent_containers/food/snacks/slice/mushroompizza/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "vegetable pizza"
	desc = "With this many fresh vegetables, nobody will even question the cheese!"
	icon_state = "vegetablepizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/vegetablepizza
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "mozzarella cheese" = 5, "baked eggplant" = 5, "baked carrot" = 5, "corn" = 5)
	nutriment_amt = 40
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_FRUIT|ALLERGEN_VEGETABLE
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 12)

/obj/item/reagent_containers/food/snacks/slice/vegetablepizza
	name = "Vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon_state = "vegetablepizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/obj/item/reagent_containers/food/snacks/slice/vegetablepizza/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/sliceable/pizza/oldpizza
	name = "moldy pizza"
	desc = "This pizza might actually be alive.  There's mold all over."
	icon_state = "oldpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/oldpizza
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("stale pizza crust" = 10, "moldy tomato" = 10, "moldy cheese" = 5)
	nutriment_amt = 20
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_FRUIT|ALLERGEN_FUNGI
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/oldpizza/Initialize()
	. = ..()
	reagents.add_reagent("mold", 8)

/obj/item/reagent_containers/food/snacks/slice/oldpizza
	name = "moldy pizza slice"
	desc = "This used to be pizza..."
	icon_state = "old_pizza"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/oldpizza

/obj/item/reagent_containers/food/snacks/slice/oldpizza
	filled = TRUE

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food.dmi'
	icon_state = "pizzabox1"
	center_of_mass = list("x" = 16,"y" = 6)

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/reagent_containers/food/snacks/sliceable/pizza/pizza // Content pizza
	var/list/boxes = list() // If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/update_icon()

	cut_overlays()

	// Set appropriate description
	if( open && pizza )
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if( boxes.len > 0 )
		desc = "A pile of boxes suited for pizzas. There appears to be [boxes.len + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if( boxtag != "" )
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/image/pizzaimg = image("food.dmi", icon_state = pizza.icon_state)
			pizzaimg.pixel_y = -3
			add_overlay(pizzaimg)

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( boxes.len > 0 )
			var/obj/item/pizzabox/topbox = boxes[boxes.len]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			var/image/tagimg = image("food.dmi", icon_state = "pizzabox_tag")
			tagimg.pixel_y = boxes.len * 3
			add_overlay(tagimg)

	icon_state = "pizzabox[boxes.len+1]"

/obj/item/pizzabox/attack_hand( mob/user as mob )

	if( open && pizza )
		user.put_in_hands( pizza )

		to_chat(user, "<span class='warning'>You take \the [src.pizza] out of \the [src].</span>")
		src.pizza = null
		update_icon()
		return

	if( boxes.len > 0 )
		if( user.get_inactive_hand() != src )
			..()
			return

		var/obj/item/pizzabox/box = boxes[boxes.len]
		boxes -= box

		user.put_in_hands( box )
		to_chat(user, "<span class='warning'>You remove the topmost [src] from your hand.</span>")
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self( mob/user as mob )

	if( boxes.len > 0 )
		return

	open = !open

	if( open && pizza )
		ismessy = 1

	update_icon()

/obj/item/pizzabox/attackby( obj/item/I as obj, mob/user as mob )
	if( istype(I, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = I

		if( !box.open && !src.open )
			// Make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if( (boxes.len+1) + boxestoadd.len <= 5 )
				user.drop_item()

				box.loc = src
				box.boxes = list() // Clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				to_chat(user, "<span class='warning'>You put \the [box] ontop of \the [src]!</span>")
			else
				to_chat(user, "<span class='warning'>The stack is too high!</span>")
		else
			to_chat(user, "<span class='warning'>Close \the [box] first!</span>")

		return

	if( istype(I, /obj/item/reagent_containers/food/snacks/sliceable/pizza/) ) // Long ass fucking object name

		if( src.open )
			user.drop_item()
			I.loc = src
			src.pizza = I

			update_icon()

			to_chat(user, "<span class='warning'>You put \the [I] in \the [src]!</span>")
		else
			to_chat(user, "<span class='warning'>You try to push \the [I] through the lid but it doesn't work!</span>")
		return

	if( istype(I, /obj/item/pen/) )

		if( src.open )
			return

		var/t = sanitize(input("Enter what you want to add to the tag:", "Write", null, null) as text, 30)

		var/obj/item/pizzabox/boxtotagto = src
		if( boxes.len > 0 )
			boxtotagto = boxes[boxes.len]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return
	. = ..()

/obj/item/pizzabox/margherita/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "Margherita Deluxe"
	. = ..()

/obj/item/pizzabox/vegetable/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "Gourmet Vegetable"
	. = ..()

/obj/item/pizzabox/mushroom/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "Mushroom Special"
	. = ..()

/obj/item/pizzabox/meat/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "Meatlover's Supreme"
	. = ..()

/obj/item/pizzabox/pineapple/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple(src)
	boxtag = "Hawaiian Sunrise"
	. = ..()

/obj/item/pizzabox/old/Initialize()
	pizza = new /obj/item/reagent_containers/food/snacks/sliceable/pizza/oldpizza(src)
	boxtag = "Deluxe Gourmet"
	. = ..()

/obj/item/reagent_containers/food/snacks/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon_state = "dionaroast"
	trash = /obj/item/trash/plate
	filling_color = "#75754B"
	center_of_mass = list("x"=16, "y"=7)
	nutriment_amt = 6
	nutriment_desc = list("a chorus of flavor" = 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/dionaroast/Initialize()
	. = ..()
	reagents.add_reagent("radium", 2)

/obj/item/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	nutriment_amt = 4
	nutriment_desc = list("uncooked dough" = 3)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_EGGS //We're going to call the egg a gameplay abstraction for the mostpart, but for now you JUST put an egg in here...=

// Dough + rolling pin = flat dough
/obj/item/reagent_containers/food/snacks/dough/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/kitchen/rollingpin))
		new /obj/item/reagent_containers/food/snacks/sliceable/flatdough(src)
		to_chat(user, "You flatten the dough.")
		qdel(src)

// slicable into 3xdoughslices
/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/reagent_containers/food/snacks/doughslice
	slices_num = 3
	nutriment_amt = 4
	nutriment_desc = list("raw dough" = 3)
	center_of_mass = list("x"=16, "y"=16)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_EGGS


/obj/item/reagent_containers/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "doughslice"
	slice_path = /obj/item/reagent_containers/food/snacks/spagetti
	slices_num = 1
	bitesize = 2
	center_of_mass = list("x"=17, "y"=19)
	nutriment_amt = 1
	nutriment_desc = list("uncooked dough" = 1)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_EGGS

/obj/item/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)
	nutriment_amt = 4
	nutriment_desc = list("bread bun" = 4)
	nutriment_allergens = ALLERGEN_GRAINS //Egg cooked off, alright? Bread shouldn't be deadly to skrell.

/obj/item/reagent_containers/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/reagent_containers/food/snacks/result = null
	// Bun + meatball = burger
	if(istype(W,/obj/item/reagent_containers/food/snacks/meatball))
		result = new /obj/item/reagent_containers/food/snacks/monkeyburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/cutlet))
		result = new /obj/item/reagent_containers/food/snacks/monkeyburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/reagent_containers/food/snacks/sausage))
		result = new /obj/item/reagent_containers/food/snacks/hotdog(src)
		to_chat(user, "You make a hotdog.")
		qdel(W)
		qdel(src)

	// Bun + mouse = mouseburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/variable/mob))
		var/obj/item/reagent_containers/food/snacks/variable/mob/MF = W

		switch (MF.kitchen_tag)
			if ("rodent")
				result = new /obj/item/reagent_containers/food/snacks/mouseburger(src)
				to_chat(user, "You make a mouseburger!")

	if (result)
		if (W.reagents)
			//Reagents of reuslt objects will be the sum total of both.  Except in special cases where nonfood items are used
			//Eg robot head
			result.reagents.clear_reagents()
			W.reagents.trans_to(result, W.reagents.total_volume)
			reagents.trans_to(result, reagents.total_volume)

		//If the bun was in your hands, the result will be too
		if (loc == user)
			user.drop_from_inventory(src)
			user.put_in_hands(result)

// Burger + cheese wedge = cheeseburger
/obj/item/reagent_containers/food/snacks/monkeyburger/attackby(obj/item/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))// && !istype(src,/obj/item/reagent_containers/food/snacks/cheesewedge))
		new /obj/item/reagent_containers/food/snacks/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		. = ..()

// Human Burger + cheese wedge = cheeseburger
/obj/item/reagent_containers/food/snacks/human/burger/attackby(obj/item/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))
		new /obj/item/reagent_containers/food/snacks/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/bunbun
	name = "\improper Bun Bun"
	desc = "A small bread monkey fashioned from two burger buns."
	icon_state = "bunbun"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=8)
	nutriment_amt = 8
	nutriment_desc = list("bread bun" = 6, "mischief" = 2)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_EGGS

/obj/item/reagent_containers/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	bitesize = 3
	center_of_mass = list("x"=21, "y"=12)
	nutriment_amt = 4
	nutriment_desc = list("cheese" = 2,"taco shell" = 2)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE|ALLERGEN_DAIRY|ALLERGEN_MEAT

/obj/item/reagent_containers/food/snacks/taco/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1
	center_of_mass = list("x"=17, "y"=20)

/obj/item/reagent_containers/food/snacks/rawcutlet/Initialize()
	. = ..()
	reagents.add_reagent("protein", 1)

/obj/item/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "cutlet"
	bitesize = 2
	center_of_mass = list("x"=17, "y"=20)

/obj/item/reagent_containers/food/snacks/cutlet/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawmeatball"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=15)

/obj/item/reagent_containers/food/snacks/rawmeatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	icon_state = "hotdog"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=17)

/obj/item/reagent_containers/food/snacks/hotdog/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)

/obj/item/reagent_containers/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flatbread"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 4
	nutriment_desc = list("bread" = 3)

/obj/item/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)
	nutriment_amt = 3
	nutriment_desc = list("raw potato" = 3)
	nutriment_allergens = ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/rawsunflower
	name = "sunflower seeds"
	desc = "Raw sunflower seeds, alright. They look too damaged to plant."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "sunflowerseed"
	bitesize = 1
	center_of_mass = list("x"=17, "y"=18)
	nutriment_amt = 1
	nutriment_desc = list("starch" = 3)
	nutriment_allergens = ALLERGEN_SEEDS

/obj/item/reagent_containers/food/snacks/frostbelle
	name = "frostbelle bud"
	desc = "A frostbelle flower from Sif. Its petals shimmer with an inner light."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "frostbelle"
	bitesize = 1
	nutriment_amt = 1
	nutriment_desc = list("another world" = 2)
	nutriment_allergens = ALLERGEN_VEGETABLE
	catalogue_data = list(/datum/category_item/catalogue/flora/frostbelle)
	filling_color = "#5dadcf"

/obj/item/reagent_containers/food/snacks/frostbelle/Initialize()
	. = ..()
	set_light(1, 1, "#5dadcf")

	reagents.add_reagent("oxycodone", 1)
	reagents.add_reagent("sifsap", 5)
	reagents.add_reagent("bliss", 5)

/obj/item/reagent_containers/food/snacks/bellefritter
	name = "frostbelle fritters"
	desc = "Frostbelles, prepared traditionally."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "bellefritter"
	filling_color = "#5dadcf"
	center_of_mass = list("x"=16, "y"=12)
	do_coating_prefix = 0
	nutriment_amt = 5
	nutriment_desc = list("fried batter" = 5)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bellefritter/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 5)

/obj/item/reagent_containers/food/snacks/roastedsunflower
	name = "sunflower seeds"
	desc = "Sunflower seeds!"
	icon = 'icons/obj/food.dmi'
	icon_state = "sunflowerseed"
	bitesize = 1
	center_of_mass = list("x"=15, "y"=17)
	nutriment_amt = 2
	nutriment_desc = list("salt" = 3)
	nutriment_allergens = ALLERGEN_SEEDS

/obj/item/reagent_containers/food/snacks/roastedpeanuts
	name = "peanuts"
	desc = "Stopped being the planetary airline food of Earth in 2120."
	icon = 'icons/obj/food.dmi'
	icon_state = "roastnuts"
	bitesize = 1
	center_of_mass = list("x"=15, "y"=17)
	nutriment_amt = 2
	nutriment_desc = list("salt" = 3)
	nutriment_allergens = ALLERGEN_SEEDS

/obj/item/reagent_containers/food/snacks/liquidfood
	name = "\improper LiquidFood Ration"
	desc = "A prepackaged grey slurry of all the essential nutrients for a spacefarer on the go. Should this be crunchy?"
	description_fluff = "A survival food commonly packed onto short-distance bluespace shuttles and similar vessels. Tastes like chalk, but is packed full of nutrients and will keep you alive."
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#A8A8A8"
	survivalfood = TRUE
	center_of_mass = list("x"=16, "y"=15)
	nutriment_amt = 20
	nutriment_desc = list("chalk" = 6)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/liquidfood/Initialize()
	. = ..()
	reagents.add_reagent("iron", 3)

/obj/item/reagent_containers/food/snacks/liquidprotein
	name = "\improper LiquidProtein Ration"
	desc = "A variant of the LiquidFood ration, designed for more carnivorous species. Only barely more appealing than regular liquidfood. Should this be crunchy?"
	icon_state = "liquidprotein"
	trash = /obj/item/trash/liquidprotein
	filling_color = "#A8A8A8"
	survivalfood = TRUE
	center_of_mass = list("x"=16, "y"=15)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/liquidprotein/Initialize()
	. = ..()
	reagents.add_reagent("protein", 30)
	reagents.add_reagent("iron", 3)

/obj/item/reagent_containers/food/snacks/liquidvitamin
	name = "\improper VitaPaste Ration"
	desc = "A variant of the liquidfood ration, designed for any carbon-based life. Somehow worse than regular liquidfood. Should this be crunchy?"
	icon_state = "liquidvitamin"
	trash = /obj/item/trash/liquidvitamin
	filling_color = "#A8A8A8"
	survivalfood = TRUE
	center_of_mass = list("x"=16, "y"=15)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/liquidvitamin/Initialize()
	. = ..()
	reagents.add_reagent("flour", 20)
	reagents.add_reagent("tricordrazine", 5)
	reagents.add_reagent("paracetamol", 5)
	reagents.add_reagent("enzyme", 1)
	reagents.add_reagent("iron", 3)

/obj/item/reagent_containers/food/snacks/meatcube
	name = "cubed meat"
	desc = "Fried, salted lean meat compressed into a cube. Not very appetizing."
	icon_state = "meatcube"
	filling_color = "#7a3d11"
	center_of_mass = list("x"=16, "y"=16)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/meatcube/Initialize()
	. = ..()
	reagents.add_reagent("protein", 15)

/obj/item/reagent_containers/food/snacks/tastybread
	name = "bread tube"
	desc = "Bread in a tube. Chewy... and surprisingly tasty."
	description_fluff = "This is the product that brought Centauri Provisions into the limelight. A product of the earliest extrasolar colony of Heaven, the Bread Tube, while bland, contains all the nutrients a spacer needs to get through the day and is decidedly edible when compared to some of its competitors. Due to the high-fructose corn syrup content of NanoTrasen's own-brand bread tubes, many jurisdictions classify them as a confectionary."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "tastybread"
	trash = /obj/item/trash/tastybread
	filling_color = "#A66829"
	center_of_mass = list("x"=17, "y"=16)
	nutriment_amt = 6
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("bread" = 2, "sweetness" = 3),
		SPECIES_TESHARI      = list("bread" = 3, "an unpleasant bitter aftertaste" = 1)
	)
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/skrellsnacks
	name = "\improper SkrellSnax"
	desc = "Cured fungus shipped all the way from Qerr'balak, almost like jerky! Almost."
	description_fluff = "Despite the packaging, most SkrellSnax sold in Vir are produced using locally-grown, Qerr'Balak-native Go'moa fungi in controversial Skrell-owned biodomes on the suface of Sif. SkrellSnax were originally a product of Natuna, designed to welcome Ue-Katish refugees to their colony. The brand was recreated by Centauri Provisions after Natuna and SolGov broke off diplomatic relations."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "skrellsnacks"
	trash = /obj/item/trash/skrellsnax
	filling_color = "#A66829"
	center_of_mass = list("x"=15, "y"=12)
	nutriment_amt = 10
	nutriment_desc = list("dried mushroom" = 5, "salt" = 5)
	nutriment_allergens = ALLERGEN_FUNGI
	bitesize = 3

/obj/item/reagent_containers/food/snacks/unajerky
	name = "Moghes Imported Sissalik Jerky"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "unathitinred"
	desc = "An incredibly well made jerky, shipped in all the way from Moghes."
	description_fluff = "The exact meat and spices used in the curing of Sissalik Jerky are a well-kept secret, and thought to not exist at all outside of Hegemony space. Many have tried to replicate the flavour, but none have come close, so the brand remains a highly prized import. "
	trash = /obj/item/trash/unajerky
	filling_color = "#631212"
	center_of_mass = list("x"=15, "y"=9)
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'
	bitesize = 2

/obj/item/reagent_containers/food/snacks/unajerky/Initialize()
	. =..()
	reagents.add_reagent("protein", 8)
	reagents.add_reagent("capsaicin", 2)

/obj/item/reagent_containers/food/snacks/sashimi
	name = "sashimi"
	desc = "Expertly prepared. Hopefully non-toxic."
	filling_color = "#FFDEFE"
	icon_state = "sashimi"
	nutriment_amt = 6
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sashimi/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 2)

/obj/item/reagent_containers/food/snacks/benedict
	name = "eggs benedict"
	desc = "Hey, there's only one egg in this!"
	filling_color = "#FFDF78"
	icon_state = "benedict"
	nutriment_amt = 6
	nutriment_desc = list("toasted bread" = 2, "bacon" = 2, "egg" = 2)
	bitesize = 2
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_MEAT|ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/beans
	name = "baked beans"
	desc = "Sweet, savory beans that have a slight tomato taste to them."
	filling_color = "#FC6F28"
	icon_state = "bakedbeans"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 4
	nutriment_desc = list("beans" = 4)
	nutriment_allergens = ALLERGEN_BEANS|ALLERGEN_FRUIT
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarcookie
	name = "sugar cookie"
	desc = "Just like your little sister used to make."
	filling_color = "#DBC94F"
	icon_state = "sugarcookie"
	nutriment_amt = 5
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet cookie" = 5),
		SPECIES_TESHARI      = list("crisp cookie" = 5, "subtle bitterness" = 1)
	)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_GRAINS
	bitesize = 1

/obj/item/reagent_containers/food/snacks/sugarcookie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_containers/food/snacks/berrymuffin
	name = "berry muffin"
	desc = "A delicious and spongy little cake, with berries."
	icon_state = "berrymuffin"
	filling_color = "#E0CF9B"
	center_of_mass = list("x"=17, "y"=4)
	nutriment_amt = 6
	nutriment_desc = list("fluffy cake" = 2, "berries" = 2)
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_GRAINS|ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/berrymuffin/berry/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 3)

/obj/item/reagent_containers/food/snacks/berrymuffin/poison/Initialize()
	. = ..()
	reagents.add_reagent("poisonberryjuice", 3)

/obj/item/reagent_containers/food/snacks/ghostmuffin
	name = "booberry muffin"
	desc = "My stomach is a graveyard! No living being can quench my bloodthirst!"
	icon_state = "berrymuffin"
	filling_color = "#799ACE"
	center_of_mass = list("x"=17, "y"=4)
	nutriment_amt = 6
	nutriment_desc = list("spookiness" = 4, "muffin" = 1, "berries" = 1)
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_GRAINS|ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ghostmuffin/berry/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 3)

/obj/item/reagent_containers/food/snacks/ghostmuffin/poison/Initialize()
	. = ..()
	reagents.add_reagent("poisonberryjuice", 3)

/obj/item/reagent_containers/food/snacks/eggroll
	name = "egg roll"
	desc = "Free with orders over 10 thalers."
	icon_state = "eggroll"
	filling_color = "#799ACE"
	center_of_mass = list("x"=17, "y"=4)
	nutriment_amt = 4
	nutriment_desc = list("fried batter" = 4)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_VEGETABLE
	bitesize = 2

/obj/item/reagent_containers/food/snacks/devilledegg
	name = "devilled eggs"
	desc = "Spicy homestyle favorite."
	icon_state = "devilledegg"
	filling_color = "#799ACE"
	center_of_mass = list("x"=17, "y"=16)
	nutriment_amt = 8
	nutriment_desc = list("egg" = 4, "chili peppers" = 4)
	nutriment_allergens = ALLERGEN_EGGS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/devilledegg/Initialize()
	. = ..()
	reagents.add_reagent("capsaicin", 2)

/obj/item/reagent_containers/food/snacks/fruitsalad
	name = "fruit salad"
	desc = "Your standard fruit salad."
	icon_state = "fruitsalad"
	filling_color = "#FF3867"
	nutriment_amt = 10
	nutriment_desc = list("mixed fruit" = 10)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/flowerchildsalad
	name = "flowerchild poppy salad"
	desc = "A fragrant salad."
	icon_state = "flowerchildsalad"
	filling_color = "#FF3867"
	nutriment_amt = 10
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("bittersweet" = 10),
		SPECIES_TESHARI      = list("complex floral notes" = 8, "mild bitterness" = 4)
	)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/rosesalad
	name = "flowerchild rose salad"
	desc = "A fragrant salad."
	icon_state = "rosesalad"
	filling_color = "#FF3867"
	nutriment_amt = 10
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("bittersweet" = 10, "iron" = 5),
		SPECIES_TESHARI      = list("complex floral notes" = 8, "mild bitterness" = 4, "iron" = 5)
	)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/rosesalad/Initialize()
	. = ..()
	reagents.add_reagent("stoxin", 2)

/obj/item/reagent_containers/food/snacks/eggbowl
	name = "egg bowl"
	desc = "A bowl of fried rice with egg mixed in."
	icon_state = "eggbowl"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	nutriment_amt = 6
	nutriment_desc = list("rice" = 2, "egg" = 4)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/eggbowl/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/cubannachos
	name = "\improper Cuban nachos"
	desc = "That's some dangerously spicy nachos."
	icon_state = "cubannachos"
	nutriment_amt = 6
	nutriment_desc = list("salt" = 1, "cheese" = 2, "chili peppers" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cubannachos/Initialize()
	. = ..()
	reagents.add_reagent("capsaicin", 4)

/obj/item/reagent_containers/food/snacks/curryrice
	name = "curry rice"
	desc = "That's some dangerously spicy rice."
	icon_state = "curryrice"
	nutriment_amt = 6
	nutriment_desc = list("salt" = 1, "rice" = 2, "rich spices" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/curryrice/Initialize()
	. = ..()
	reagents.add_reagent("capsaicin", 4)

/obj/item/reagent_containers/food/snacks/piginblanket
	name = "pig in a blanket"
	desc = "A sausage embedded in soft, fluffy pastry. Free this pig from its blanket prison by eating it."
	icon_state = "piginblanket"
	nutriment_amt = 6
	nutriment_desc = list("sausage" = 3, "puff pastry" = 3)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_MEAT
	bitesize = 3

/obj/item/reagent_containers/food/snacks/piginblanket/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/wormsickly
	name = "sickly worm"
	desc = "A worm, it doesn't look particularily healthy, but it will still serve as good fishing bait."
	icon_state = "worm_sickly"
	nutriment_amt = 1
	nutriment_desc = list("dry bugflesh" = 1)
	nutriment_allergens = ALLERGEN_MEAT
	w_class = ITEMSIZE_TINY
	bitesize = 5

/obj/item/reagent_containers/food/snacks/wormsickly/Initialize()
	. = ..()
	reagents.add_reagent("fishbait", 9)
	reagents.add_reagent("protein",  3, nutriment_desc)

/obj/item/reagent_containers/food/snacks/worm
	name = "strange worm"
	desc = "A peculiar worm, freshly plucked from the earth."
	icon_state = "worm"
	nutriment_amt = 1
	nutriment_desc = list("bugflesh" = 1)
	nutriment_allergens = ALLERGEN_MEAT
	w_class = ITEMSIZE_TINY
	bitesize = 5

/obj/item/reagent_containers/food/snacks/worm/Initialize()
	. = ..()
	reagents.add_reagent("fishbait", 15)
	reagents.add_reagent("protein",  5, nutriment_desc)

/obj/item/reagent_containers/food/snacks/wormdeluxe
	name = "deluxe worm"
	desc = "A fancy worm, genetically engineered to appeal to fish."
	icon_state = "worm_deluxe"
	nutriment_amt = 5
	nutriment_desc = list("juicy bugflesh" = 1)
	nutriment_allergens = ALLERGEN_MEAT
	w_class = ITEMSIZE_TINY
	bitesize = 5

/obj/item/reagent_containers/food/snacks/wormdeluxe/Initialize()
	. = ..()
	reagents.add_reagent("fishbait", 30)
	reagents.add_reagent("protein",  10, nutriment_desc)

/obj/item/reagent_containers/food/snacks/siffruit
	name = "pulsing fruit"
	desc = "A blue-ish sac encased in a tough black shell."
	icon = 'icons/obj/flora/foraging.dmi'
	icon_state = "siffruit"
	nutriment_amt = 2
	nutriment_desc = list("tartness" = 1)
	w_class = ITEMSIZE_TINY

/obj/item/reagent_containers/food/snacks/siffruit/Initialize()
	. = ..()
	reagents.add_reagent("sifsap", 2)

/obj/item/reagent_containers/food/snacks/siffruit/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(!(proximity && O.is_open_container()))
		return
	to_chat(user, "<span class='notice'>You tear \the [src]'s sac open, pouring it into \the [O].</span>")
	reagents.trans_to(O, reagents.total_volume)
	user.drop_from_inventory(src)
	qdel(src)

/obj/item/reagent_containers/food/snacks/bagelplain
	name = "plain bagel"
	desc = "This bread's got chutzpah!"
	icon_state = "bagelplain"
	nutriment_amt = 6
	nutriment_desc = list("bread" = 6)
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bagelsunflower
	name = "sunflower seed bagel"
	desc = "This bread's got chutzpah - and sunflower seeds!"
	icon_state = "bagelsunflower"
	nutriment_amt = 7
	nutriment_desc = list("bread" = 4, "sunflower seeds" = 3)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_SEEDS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bagelcheese
	name = "cheese bagel"
	desc = "This bread's got cheese n' chutzpah!"
	icon_state = "bagelcheese"
	nutriment_amt = 8
	nutriment_desc = list("bread" = 4, "cheese" = 4)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_DAIRY
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bagelraisin
	name = "cinnamon raisin bagel"
	desc = "This bread's got... Raisins!"
	icon_state = "bagelraisin"
	nutriment_amt = 8
	nutriment_desc = list("bread" = 4, "cinnamon" = 2, "dried fruit" = 2)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_FRUIT
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bagelpoppy
	name = "poppy seed bagel"
	desc = "This bread's got chutzpah, and poppy seeds!"
	icon_state = "bagelpoppy"
	nutriment_amt = 6
	nutriment_desc = list("bread" = 1, "poppy seed" = 1)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_SEEDS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bageleverything
	name = "everything bagel"
	desc = "Mmm... Immeasurably unfathomable!"
	icon_state = "bageleverything"
	nutriment_amt = 20
	nutriment_desc = list("life" = 1, "death" = 1, "entropy" = 1)
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_FISH|ALLERGEN_FRUIT|ALLERGEN_VEGETABLE|ALLERGEN_GRAINS|ALLERGEN_BEANS|ALLERGEN_SEEDS|ALLERGEN_DAIRY|ALLERGEN_FUNGI|ALLERGEN_COFFEE|ALLERGEN_SUGARS|ALLERGEN_EGGS|ALLERGEN_STIMULANT //Allergens: Yes
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bageleverything/Initialize()
	. = ..()
	reagents.add_reagent("phoron", 5)
	reagents.add_reagent("defective_nanites", 5)

/obj/item/reagent_containers/food/snacks/bageltwo
	name = "two bagels"
	desc = "Noo! ...Two bagels!"
	icon_state = "bagelplain"

/obj/item/reagent_containers/food/snacks/bageltwo/Initialize()
	..()
	spawn_bagels()
	spawn_bagels()
	return INITIALIZE_HINT_QDEL

/obj/item/reagent_containers/food/snacks/bageltwo/proc/spawn_bagels()
	var/build_path = /obj/item/reagent_containers/food/snacks/bagelplain
	var/atom/A = new build_path(get_turf(src))
	if(pixel_x || pixel_y)
		A.pixel_x = pixel_x
		A.pixel_y = pixel_y

/obj/item/reagent_containers/food/snacks/macncheese
	name = "macaroni and cheese"
	desc = "The perfect combination of noodles and dairy."
	icon = 'icons/obj/food.dmi'
	icon_state = "macncheese"
	trash = /obj/item/trash/snack_bowl
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 9
	nutriment_desc = list("cheese" = 5, "pasta" = 4, "happiness" = 1)
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS
	bitesize = 3


//Code for dipping food in batter
/obj/item/reagent_containers/food/snacks/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(O.is_open_container() && O.reagents && !(istype(O, /obj/item/reagent_containers/food)) && proximity)
		for (var/r in O.reagents.reagent_list)

			var/datum/reagent/R = r
			if (istype(R, /datum/reagent/nutriment/coating))
				if (apply_coating(R, user))
					return 1

	return . = ..()

//This proc handles drawing coatings out of a container when this food is dipped into it
/obj/item/reagent_containers/food/snacks/proc/apply_coating(var/datum/reagent/nutriment/coating/C, var/mob/user)
	if (coating)
		to_chat(user, "The [src] is already coated in [coating.name]!")
		return 0

	//Calculate the reagents of the coating needed
	var/req = 0
	for (var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if (istype(R, /datum/reagent/nutriment))
			req += R.volume * 0.2
		else
			req += R.volume * 0.1

	req += w_class*0.5

	if (!req)
		//the food has no reagents left, its probably getting deleted soon
		return 0

	if (C.volume < req)
		to_chat("<span class='warning'>There's not enough [C.name] to coat the [src]!</span>")
		return 0

	var/id = C.id

	//First make sure there's space for our batter
	if (reagents.get_free_space() < req+5)
		var/extra = req+5 - reagents.get_free_space()
		reagents.maximum_volume += extra

	//Suck the coating out of the holder
	C.holder.trans_to_holder(reagents, req)

	//We're done with C now, repurpose the var to hold a reference to our local instance of it
	C = reagents.get_reagent(id)
	if (!C)
		return

	coating = C
	//Now we have to do the witchcraft with masking images
	//var/icon/I = new /icon(icon, icon_state)

	if (!flat_icon)
		flat_icon = getFlatIcon(src)
	var/icon/I = flat_icon
	color = "#FFFFFF" //Some fruits use the color var. Reset this so it doesn't tint the batter
	I.Blend(new /icon('icons/obj/food_custom.dmi', rgb(255,255,255)),ICON_ADD)
	I.Blend(new /icon('icons/obj/food_custom.dmi', coating.icon_raw),ICON_MULTIPLY)
	var/image/J = image(I)
	J.alpha = 200
	J.blend_mode = BLEND_OVERLAY
	J.tag = "coating"
	add_overlay(J)

	if (user)
		user.visible_message(span("notice", "[user] dips \the [src] into \the [coating.name]"), span("notice", "You dip \the [src] into \the [coating.name]"))

	return 1


//Called by cooking machines. This is mainly intended to set properties on the food that differ between raw/cooked
/obj/item/reagent_containers/food/snacks/proc/cook()
	if (coating)
		var/image/coating_overlay
		for (var/image/image in overlays)
			if (image.tag == "coating")
				coating_overlay = image
				break
		if (coating_overlay)
			cut_overlay(coating_overlay)

		if (!flat_icon)
			flat_icon = getFlatIcon(src)
		var/icon/I = flat_icon
		color = "#FFFFFF" //Some fruits use the color var
		I.Blend(new /icon('icons/obj/food_custom.dmi', rgb(255,255,255)),ICON_ADD)
		I.Blend(new /icon('icons/obj/food_custom.dmi', coating.icon_cooked),ICON_MULTIPLY)
		var/image/J = image(I)
		J.alpha = 200
		J.tag = "coating"
		add_overlay(J)


		if (do_coating_prefix == 1)
			name = "[coating.coated_adj] [name]"

	for (var/r in reagents.reagent_list)
		var/datum/reagent/R = r
		if (istype(R, /datum/reagent/nutriment/coating))
			var/datum/reagent/nutriment/coating/C = R
			C.data["cooked"] = 1
			C.name = C.cooked_name

/obj/item/reagent_containers/food/snacks/proc/on_consume(var/mob/eater, var/mob/feeder = null)
	if(!reagents.total_volume)
		eater.visible_message("<span class='notice'>[eater] finishes eating \the [src].</span>","<span class='notice'>You finish eating \the [src].</span>")

		if (!feeder)
			feeder = eater

		feeder.drop_from_inventory(src)	//so icons update :[ //what the fuck is this????

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(feeder)
				feeder.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				feeder.put_in_hands(trash)
		qdel(src)
	return
////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////

/mob/living
	var/composition_reagent
	var/composition_reagent_quantity

/mob/living/simple_mob/adultslime
	composition_reagent = "slimejelly"

/mob/living/carbon/diona
	composition_reagent = "nutriment"//Dionae are plants, so eating them doesn't give animal protein

/mob/living/simple_mob/slime
	composition_reagent = "slimejelly"

/mob/living/simple_mob
	var/kitchen_tag = "animal" //Used for cooking with animals

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	slices_num = 8

/obj/item/reagent_containers/food/snacks/sausage/battered
	name = "battered sausage"
	desc = "A piece of mixed, long meat, battered and then deepfried."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "batteredsausage"
	filling_color = "#DB0000"
	center_of_mass = list("x"=16, "y"=16)
	do_coating_prefix = 0
	bitesize = 2
	nutriment_amt = 5
	nutriment_desc = list("fried batter" = 5, "fried meat" = 6)
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/sausage/battered/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, nutriment_desc)

/obj/item/reagent_containers/food/snacks/jalapeno_poppers
	name = "jalapeno popper"
	desc = "A battered, deep-fried chilli pepper."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "popper"
	filling_color = "#00AA00"
	center_of_mass = list("x"=10, "y"=6)
	do_coating_prefix = 0
	nutriment_amt = 6
	nutriment_desc = list("chilli pepper" = 2, "fried batter" = 2)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_FRUIT
	bitesize = 3


/obj/item/reagent_containers/food/snacks/mouseburger
	name = "mouse burger"
	desc = "Squeaky and a little furry."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "ratburger"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("bony meat" = 2, "fuzz" = 2)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/mouseburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, nutriment_desc)

/obj/item/reagent_containers/food/snacks/chickenkatsu
	name = "chicken katsu"
	desc = "An Earth delicacy consisting of chicken fried in a light beer batter."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "katsu"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"
	center_of_mass = list("x"=16, "y"=16)
	do_coating_prefix = 0
	bitesize = 1.5
	nutriment_amt = 3
	nutriment_desc = list("fried beer batter" = 2, "fried chicken" = 5)
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/chickenkatsu/Initialize()
		. = ..()
		reagents.add_reagent("protein", 6, nutriment_desc)

/obj/item/reagent_containers/food/snacks/microchips
	name = "micro chips"
	desc = "Soft and rubbery, should have fried them. Good for smaller crewmembers, maybe?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "microchips"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 8
	nutriment_desc = list("soggy fries" = 4)
	nutriment_allergens = ALLERGEN_VEGETABLE
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ovenchips
	name = "oven chips"
	desc = "Dark and crispy, but a bit dry."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "ovenchips"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 8
	nutriment_desc = list("crisp, dry fries" = 4)
	nutriment_allergens = ALLERGEN_VEGETABLE
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	name = "pizza crunch"
	desc = "This was once a normal pizza, but it has been coated in batter and deep-fried. Whatever toppings it once had are a mystery, but they're still under there, somewhere..."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "pizzacrunch"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/pizzacrunch
	slices_num = 6
	nutriment_amt = 30
	nutriment_desc = list("deep fried pizza" = 25)
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/slice/pizzacrunch
	name = "pizza crunch slice"
	desc = "A little piece of a heart attack. It's toppings are a mystery, hidden under batter"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "pizzacrunchslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch

/obj/item/reagent_containers/food/snacks/slice/pizzacrunch/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/funnelcake
	name = "funnel cake"
	desc = "Funnel cakes rule!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "funnelcake"
	filling_color = "#Ef1479"
	center_of_mass = list("x"=16, "y"=12)
	do_coating_prefix = 0
	bitesize = 2
	nutriment_amt = 10
	nutriment_desc = list("fried batter" = 10)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_SUGARS|ALLERGEN_EGGS

/obj/item/reagent_containers/food/snacks/funnelcake/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 5)

/obj/item/reagent_containers/food/snacks/spreads
	name = "nutri-spread"
	desc = "A stick of plant-based nutriments in a semi-solid form. I can't believe it's not margarine!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "marge"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("margarine" = 1)
	nutriment_amt = 20
	nutriment_allergens = ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/spreads/butter
	name = "butter"
	desc = "A stick of pure butterfat made from milk products."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "butter"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("butter" = 1)
	nutriment_amt = 20
	nutriment_allergens = ALLERGEN_MEAT

/obj/item/reagent_containers/food/snacks/spreads/Initialize()
	. = ..()
	reagents.add_reagent("triglyceride", 20, nutriment_desc)
	reagents.add_reagent("sodiumchloride",1)

/obj/item/reagent_containers/food/snacks/rawcutlet/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/knife))
		new /obj/item/reagent_containers/food/snacks/rawbacon(src)
		new /obj/item/reagent_containers/food/snacks/rawbacon(src)
		to_chat(user, "You slice the cutlet into thin strips of bacon.")
		qdel(src)
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/rawbacon
	name = "raw bacon"
	desc = "A very thin cut of raw meat."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "rawbacon"
	bitesize = 1
	center_of_mass = list("x"=16, "y"=16)

/obj/item/reagent_containers/food/snacks/rawbacon/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2)

/obj/item/reagent_containers/food/snacks/bacon
	name = "bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "bacon"
	bitesize = 2
	nutriment_desc = list("crispy bacon" = 2)
	nutriment_allergens = ALLERGEN_MEAT
	center_of_mass = list("x"=16, "y"=16)

/obj/item/reagent_containers/food/snacks/bacon/microwave
	name = "microwaved bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "bacon"
	bitesize = 2
	nutriment_desc = list("soggy bacon" = 2)
	center_of_mass = list("x"=16, "y"=16)

/obj/item/reagent_containers/food/snacks/bacon/oven
	name = "oven-cooked bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "bacon"
	bitesize = 2
	nutriment_desc = list("crispy bacon" = 2)
	center_of_mass = list("x"=16, "y"=16)

/obj/item/reagent_containers/food/snacks/bacon/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2, nutriment_desc)
	reagents.add_reagent("triglyceride", 1)

/obj/item/reagent_containers/food/snacks/bacon_stick
	name = "eggpop"
	desc = "A bacon wrapped boiled egg, conveniently skewered on a wooden stick."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "bacon_stick"
	nutriment_desc = list("crispy bacon" = 3)
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_EGGS

/obj/item/reagent_containers/food/snacks/bacon_stick/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, nutriment_desc)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_containers/food/snacks/chilied_eggs
	name = "\improper Redeemed eggs"
	desc = "Three deviled eggs floating in a bowl of meat chili. A popular lunchtime meal for Unathi, with mild religious undertones."
	icon_state = "chilied_eggs"
	nutriment_desc = list("heavily spiced meat" = 2)
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_EGGS
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/chilied_eggs/Initialize()
	. = ..()
	reagents.add_reagent("egg", 6)
	reagents.add_reagent("protein", 2, nutriment_desc)

/obj/item/reagent_containers/food/snacks/cheese_cracker
	name = "supreme cheese toast"
	desc = "A piece of toast lathered with butter, cheese, spices, and herbs."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "cheese_cracker"
	nutriment_desc = list("melted cheese" = 4, "toasted bread" = 2, "mild spices" = 2)
	nutriment_amt = 8
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/bacon_and_eggs
	name = "bacon and eggs"
	desc = "A piece of bacon and two fried eggs."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "bacon_and_eggs"
	nutriment_desc = list("bacon" = 4)
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/bacon_and_eggs/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, nutriment_desc)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_containers/food/snacks/sweet_and_sour
	name = "sweet and sour pork"
	desc = "A traditional ancient Sol recipe with a few liberties taken with meat selection."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "sweet_and_sour"
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet and sour sauce" = 6, "fried pork" = 3),
		SPECIES_TESHARI      = list("sour, somewhat bitter sauce" = 6, "fried pork" = 3)
	)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_GRAINS
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/sweet_and_sour/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, nutriment_desc)

/obj/item/reagent_containers/food/snacks/corn_dog
	name = "corn dog"
	desc = "A cornbread covered sausage deepfried in oil."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "corndog"
	nutriment_desc = list("fried corn batter" = 4, "fried sausage" = 3)
	nutriment_amt = 4

/obj/item/reagent_containers/food/snacks/corn_dog/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, nutriment_desc)

/obj/item/reagent_containers/food/snacks/truffle
	name = "chocolate truffle"
	desc = "Rich bite-sized chocolate."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "truffle"
	nutriment_amt = 0
	bitesize = 4

/obj/item/reagent_containers/food/snacks/truffle/Initialize()
	. = ..()
	reagents.add_reagent("coco", 6)

/obj/item/reagent_containers/food/snacks/truffle/random
	name = "mystery chocolate truffle"
	desc = "Rich bite-sized chocolate with a mystery filling!"

/obj/item/reagent_containers/food/snacks/truffle/random/Initialize()
	. = ..()
	var/reagent_string = pick(list("cream","cherryjelly","mint","frostoil","capsaicin","cream","coffee","milkshake"))
	reagents.add_reagent(reagent_string, 4)

/obj/item/reagent_containers/food/snacks/bacon_flatbread
	name = "bacon cheese flatbread"
	desc = "Not a pizza."
	icon_state = "bacon_pizza"
	icon = 'icons/obj/food_syn.dmi'
	nutriment_desc = list("flatbread" = 5, "bacon" = 5)
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_GRAINS|ALLERGEN_DAIRY

/obj/item/reagent_containers/food/snacks/bacon_flatbread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5, nutriment_desc)

/obj/item/reagent_containers/food/snacks/meat_pocket
	name = "meat pocket"
	desc = "Meat and cheese stuffed in a flatbread pocket, grilled to perfection."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "meat_pocket"
	nutriment_desc = list("flatbread" = 3, "grilled meat" = 2, "cheese" = 2)
	nutriment_amt = 3
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_GRAINS|ALLERGEN_DAIRY

/obj/item/reagent_containers/food/snacks/meat_pocket/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/fish_taco
	name = "fish taco"
	desc = "A questionably cooked fish taco decorated with herbs, spices, and special sauce."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "fish_taco"
	nutriment_desc = list("flatbread" = 3)
	nutriment_amt = 3
	nutriment_allergens = ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/fish_taco/Initialize()
	. = ..()
	reagents.add_reagent("seafood",3)

/obj/item/reagent_containers/food/snacks/nt_muffin
	name = "breakfast muffin"
	desc = "An english muffin with egg, cheese, and sausage, as sold in fast food joints galaxy-wide."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "nt_muffin"
	nutriment_desc = list("buttermilk biscuit" = 4, "grilled meat" = 4, "cheese" = 4, "egg" = 4)
	nutriment_amt = 16

/obj/item/reagent_containers/food/snacks/pineapple_ring
	name = "pineapple ring"
	desc = "So retro."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "pineapple_ring"
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweetness" = 2),
		SPECIES_TESHARI = list("mild bitterness", "caustic, fruity flavour")
	)
	nutriment_amt = 2
	nutriment_allergens = ALLERGEN_SUGARS


/obj/item/reagent_containers/food/snacks/pineapple_ring/Initialize()
	. = ..()
	reagents.add_reagent("pineapplejuice",3)


/obj/item/reagent_containers/food/snacks/baconburger
	name = "bacon burger"
	desc = "The cornerstone of every nutritious breakfast, now with bacon!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "baconburger"
	filling_color = "#D63C3C"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("bread bun" = 2, "grilled meat" = 4)
	nutriment_amt = 3
	bitesize = 2

/obj/item/reagent_containers/food/snacks/baconburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, nutriment_desc)

/obj/item/reagent_containers/food/snacks/blt
	name = "BLT"
	desc = "Bacon, lettuce, tomatoes. The perfect lunch."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "blt"
	filling_color = "#D63C3C"
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("bacon" = 4, "lettuce" = 4, "tomato" = 4)
	nutriment_amt = 12
	bitesize = 2

/obj/item/reagent_containers/food/snacks/blt/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, nutriment_desc)

/obj/item/reagent_containers/food/snacks/onionrings
	name = "onion rings"
	desc = "Like circular fries but better."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "onionrings"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = list("x"=16,"y"=11)
	nutriment_desc = list("fried onions" = 5)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_EGGS|ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soup/onion
	name = "onion soup"
	desc = "A soup with layers."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "onionsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E0C367"
	center_of_mass = list("x"=16, "y"=7)
	nutriment_amt = 5
	nutriment_desc = list("onion" = 2, "umami broth" = 2)
	nutriment_allergens = ALLERGEN_VEGETABLE
	bitesize = 3

/obj/item/reagent_containers/food/snacks/porkbowl
	name = "pork bowl"
	desc = "A bowl of fried rice with cuts of meat."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "porkbowl"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	bitesize = 2
	nutriment_desc = list("ginger and garlic" = 2, "spiced pork" = 2)

/obj/item/reagent_containers/food/snacks/porkbowl/Initialize()
	. = ..()
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("protein", 4)

/obj/item/reagent_containers/food/snacks/mashedpotato
	name = "mashed potato"
	desc = "Pillowy mounds of mashed potato."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "mashedpotato"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 6
	nutriment_desc = list("mashed potatoes" = 6)
	nutriment_allergens = ALLERGEN_VEGETABLE
	bitesize = 2

/obj/item/reagent_containers/food/snacks/croissant
	name = "croissant"
	desc = "True French cuisine; invented in Austria..."
	icon = 'icons/obj/food_syn.dmi'
	filling_color = "#E3D796"
	icon_state = "croissant"
	nutriment_amt = 4
	nutriment_desc = list("buttery pastry" = 4, "flaky bread" = 4)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/crabmeat
	name = "crab legs"
	desc = "...Coffee? Is that you?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "crabmeat"
	nutriment_desc = list("crab meat" = 2)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/crabmeat/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 2, nutriment_desc)

/obj/item/reagent_containers/food/snacks/crab_legs
	name = "steamed crab legs"
	desc = "Crab legs steamed and buttered to perfection. One day when the boss gets hungry..."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "crablegs"
	nutriment_amt = 2
	nutriment_desc = list("savory butter" = 3, "crab meat" = 5)
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_FISH
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/crab_legs/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 6, nutriment_desc)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_containers/food/snacks/pancakes
	name = "pancakes"
	desc = "Do you like them?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=15, "y"=11)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("soft, dense cake" = 6, "syrupy sweetness" = 2),
		SPECIES_TESHARI      = list("soft, dense cake" = 6, "cloying bitterness" = 2)
	)
	nutriment_amt = 8
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_GRAINS|ALLERGEN_SUGARS|ALLERGEN_DAIRY
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pancakes/berry
	name = "berry pancakes"
	desc = "These pancakes are berry nice!"
	icon_state = "pancake_berry"
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=15, "y"=11)
	nutriment_desc = list("soft, dense cake" = 6, "baked berries" = 4)
	nutriment_amt = 10
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_GRAINS|ALLERGEN_SUGARS|ALLERGEN_DAIRY|ALLERGEN_FRUIT
	bitesize = 2

/obj/item/reagent_containers/food/snacks/nugget
	name = "chicken nugget"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "nugget_lump"
	nutriment_desc = "mild battered chicken"
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_GRAINS|ALLERGEN_MEAT
	bitesize = 3

/obj/item/reagent_containers/food/snacks/nugget/Initialize()
	. = ..()
	var/shape = pick("lump", "star", "lizard", "corgi")
	desc = "A chicken nugget vaguely shaped like a [shape]."
	icon_state = "nugget_[shape]"
	reagents.add_reagent("protein", 4, nutriment_desc)

/obj/item/reagent_containers/food/snacks/icecreamsandwich
	name = "ice cream sandwich"
	desc = "Portable ice cream in its own packaging."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "icecreamsandwich"
	filling_color = "#343834"
	center_of_mass = list("x"=15, "y"=4)
	nutriment_desc = list("vanilla ice cream" = 4)
	nutriment_amt = 4
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_SUGARS

/obj/item/reagent_containers/food/snacks/honeybun
	name = "honey bun"
	desc = "A sticky pastry bun glazed with honey."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "honeybun"
	nutriment_desc = list("fried pastry" = 2, "sugar glaze" = 1)
	nutriment_amt = 3
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_SUGARS
	bitesize = 3

/obj/item/reagent_containers/food/snacks/honeybun/Initialize()
	. = ..()
	reagents.add_reagent("honey", 3)

// Chip update.
/obj/item/reagent_containers/food/snacks/tortilla
	name = "tortilla"
	desc = "A thin, flour-based tortilla that can be used in a variety of dishes, or can be served as is."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "tortilla"
	bitesize = 3
	nutriment_desc = list("tortilla" = 1)
	nutriment_allergens = ALLERGEN_GRAINS
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 6

//chips
/obj/item/reagent_containers/food/snacks/chip
	name = "chip"
	desc = "A portion sized chip good for dipping."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "chip"
	var/bitten_state = "chip_half"
	bitesize = 1
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("nacho chips" = 1)
	nutriment_amt = 2
	nutriment_allergens = ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/chip/on_consume(mob/M as mob)
	if(reagents && reagents.total_volume)
		icon_state = bitten_state
	. = ..()

/obj/item/reagent_containers/food/snacks/chip/salsa
	name = "salsa chip"
	desc = "A portion sized chip good for dipping. This one has salsa on it."
	icon_state = "chip_salsa"
	bitten_state = "chip_half"
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/chip/guac
	name = "guac chip"
	desc = "A portion sized chip good for dipping. This one has guac on it."
	icon_state = "chip_guac"
	bitten_state = "chip_half"
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/chip/cheese
	name = "cheese chip"
	desc = "A portion sized chip good for dipping. This one has cheese sauce on it."
	icon_state = "chip_cheese"
	bitten_state = "chip_half"
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_DAIRY

/obj/item/reagent_containers/food/snacks/chip/nacho
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos."
	icon_state = "chip_nacho"
	bitten_state = "chip_half"

/obj/item/reagent_containers/food/snacks/chip/nacho/salsa
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has salsa on it."
	icon_state = "chip_nacho_salsa"
	bitten_state = "chip_half"
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/chip/nacho/guac
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has guac on it."
	icon_state = "chip_nacho_guac"
	bitten_state = "chip_half"
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/chip/nacho/cheese
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos. This one has extra cheese on it."
	icon_state = "chip_nacho_cheese"
	bitten_state = "chip_half"
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_DAIRY

// chip plates
/obj/item/reagent_containers/food/snacks/chipplate
	name = "basket of chips"
	desc = "A plate of chips intended for dipping."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "chip_basket"
	trash = /obj/item/trash/chipbasket
	var/vendingobject = /obj/item/reagent_containers/food/snacks/chip
	var/unitname = "chip"
	nutriment_desc = list("tortilla chips" = 10)
	bitesize = 1
	nutriment_amt = 10

/obj/item/reagent_containers/food/snacks/chipplate/attack_hand(mob/user as mob)
	var/obj/item/reagent_containers/food/snacks/returningitem = new vendingobject(loc)
	returningitem.reagents.clear_reagents()
	reagents.trans_to_obj(returningitem, bitesize)
	returningitem.bitesize = bitesize/2
	user.put_in_hands(returningitem)
	if (reagents && reagents.total_volume)
		to_chat(user, "You take a [unitname] from the plate.")
	else
		to_chat(user, "You take the last [unitname] from the plate.")
		var/obj/waste = new trash(loc)
		if (loc == user)
			user.put_in_hands(waste)
		qdel(src)

/obj/item/reagent_containers/food/snacks/chipplate/MouseDrop(mob/user) //Dropping the chip onto the user
	if(istype(user) && user == usr)
		user.put_in_active_hand(src)
		src.pickup(user)
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/chipplate/nachos
	name = "plate of nachos"
	desc = "A very cheesy nacho plate."
	icon_state = "nachos"
	unitname = "nacho"
	trash = /obj/item/trash/plate
	vendingobject = /obj/item/reagent_containers/food/snacks/chip/nacho
	nutriment_desc = list("tortilla chips" = 10)
	bitesize = 1
	nutriment_amt = 10

//dips
/obj/item/reagent_containers/food/snacks/dip
	name = "queso dip"
	desc = "A simple, cheesy dip consisting of tomatos, cheese, and spices."
	var/nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/cheese
	var/chiptrans = /obj/item/reagent_containers/food/snacks/chip/cheese
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "dip_cheese"
	trash = /obj/item/trash/dipbowl
	bitesize = 1
	nutriment_desc = list("queso" = 20)
	center_of_mass = list("x"=16, "y"=16)
	nutriment_amt = 20
	nutriment_allergens = ALLERGEN_DAIRY

/obj/item/reagent_containers/food/snacks/dip/attackby(obj/item/reagent_containers/food/snacks/item as obj, mob/user as mob)
	. = ..()
	var/obj/item/reagent_containers/food/snacks/returningitem
	if(istype(item,/obj/item/reagent_containers/food/snacks/chip/nacho) && item.icon_state == "chip_nacho")
		returningitem = new nachotrans(src)
	else if (istype(item,/obj/item/reagent_containers/food/snacks/chip) && (item.icon_state == "chip" || item.icon_state == "chip_half"))
		returningitem = new chiptrans(src)
	if(returningitem)
		returningitem.reagents.clear_reagents() //Clear the new chip
		var/memed = 0
		item.reagents.trans_to_obj(returningitem, item.reagents.total_volume) //Old chip to new chip
		if(item.icon_state == "chip_half")
			returningitem.icon_state = "[returningitem.icon_state]_half"
			returningitem.bitesize = clamp(returningitem.reagents.total_volume,1,10)
		else if(prob(1))
			memed = 1
			to_chat(user, "You scoop up some dip with the chip, but mid-scop, the chip breaks off into the dreadful abyss of dip, never to be seen again...")
			returningitem.icon_state = "[returningitem.icon_state]_half"
			returningitem.bitesize = clamp(returningitem.reagents.total_volume,1,10)
		else
			returningitem.bitesize = clamp(returningitem.reagents.total_volume*0.5,1,10)
		qdel(item)
		reagents.trans_to_obj(returningitem, bitesize) //Dip to new chip
		user.put_in_hands(returningitem)

		if (reagents && reagents.total_volume)
			if(!memed)
				to_chat(user, "You scoop up some dip with the chip.")
		else
			if(!memed)
				to_chat(user, "You scoop up the remaining dip with the chip.")
			var/obj/waste = new trash(loc)
			if (loc == user)
				user.put_in_hands(waste)
			qdel(src)

/obj/item/reagent_containers/food/snacks/dip/salsa
	name = "salsa dip"
	desc = "Traditional Sol chunky salsa dip containing tomatos, peppers, and spices."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/salsa
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/salsa
	icon_state = "dip_salsa"
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("spicy tomato" = 20),
		SPECIES_TESHARI = list("fruity notes" = 10, "rich tomato" = 10)
	)

	nutriment_amt = 20
	nutriment_allergens = ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/dip/guac
	name = "guac dip"
	desc = "A recreation of the ancient Sol 'Guacamole' dip using tofu, limes, and spices. This recreation obviously leaves out mole meat."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/guac
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/guac
	icon_state = "dip_guac"
	nutriment_desc = list("creamy vegetables" = 20)
	nutriment_amt = 20
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_BEANS

//burritos
/obj/item/reagent_containers/food/snacks/burrito
	name = "chilli burrito"
	desc = "Minced meat wrapped in a flour tortilla. It's a burrito by definition."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "burrito"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 3, "cheese" = 3)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_MEAT|ALLERGEN_DAIRY|ALLERGEN_VEGETABLE|ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/burrito/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("spiced minced meat" = 6)))

/obj/item/reagent_containers/food/snacks/burrito_vegan
	name = "vegan burrito"
	desc = "Tofu wrapped in a flour tortilla."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "burrito_vegan"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 6)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_BEANS

/obj/item/reagent_containers/food/snacks/burrito_vegan/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 6, TASTE_DATA(list("spiced tofu" = 6)))


/obj/item/reagent_containers/food/snacks/burrito_spicy
	name = "spicy burrito"
	desc = "Spicy meat wrapped in a flour tortilla."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "burrito_spicy"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 3, "chili peppers" = 3)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_MEAT|ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/burrito_spicy/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("spiced minced meat" = 6)))

/obj/item/reagent_containers/food/snacks/burrito_cheese
	name = "carne queso burrito"
	desc = "Meat and melted cheese wrapped in a flour tortilla."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "burrito_cheese"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 3, "cheese" = 3)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_MEAT|ALLERGEN_DAIRY

/obj/item/reagent_containers/food/snacks/burrito_cheese/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("spiced minced meat" = 6)))

/obj/item/reagent_containers/food/snacks/burrito_hell
	name = "el diablo"
	desc = "Meat and an insane amount of chillis packed in a flour tortilla. The Chaplain will see you now."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "burrito_hell"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("hellfire" = 6)
	nutriment_amt = 24// 10 Chilis is a lot.
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_MEAT|ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/burrito_hell/Initialize()
	. = ..()
	reagents.add_reagent("protein", 9, TASTE_DATA(list("brimstone" = 9)))
	reagents.add_reagent("condensedcapsaicin", 10) //what could possibly go wrong

/obj/item/reagent_containers/food/snacks/meatburrito
	name = "carne asada burrito"
	desc = "Sliced meat and beans, it's another basic burrito!"
	icon_state = "carneburrito"
	nutriment_amt = 6
	nutriment_desc = list("tortilla" = 3, "spiced beans" = 3)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_MEAT|ALLERGEN_BEANS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatburrito/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("spiced meat strips" = 6)))

/obj/item/reagent_containers/food/snacks/cheeseburrito
	name = "Cheese burrito"
	desc = "It's a burrito filled with beans and cheese."
	icon_state = "cheeseburrito"
	nutriment_amt = 6
	nutriment_desc = list("tortilla" = 2, "cheese" = 2, "spiced beans" = 2)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_DAIRY|ALLERGEN_BEANS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/burrito_cheese_spicy
	name = "spicy cheese burrito"
	desc = "Melted cheese, beans and chillis wrapped in a flour tortilla."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "burrito_cheese_spicy"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("tortilla" = 2, "cheese" = 2, "spicy beans" = 2, "chili peppers" = 2),
		SPECIES_TESHARI = list("tortilla" = 2, "cheese" = 2, "beans" = 2, "fruity peppers" = 2)
	)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_MEAT|ALLERGEN_DAIRY|ALLERGEN_BEANS

/obj/item/reagent_containers/food/snacks/burrito_cheese_spicy/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("spiced meat strips" = 6)))

/obj/item/reagent_containers/food/snacks/fuegoburrito
	name = "fuego phoron burrito"
	desc = "A super spicy vegetarian burrito."
	icon_state = "fuegoburrito"
	nutriment_amt = 6
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("chili peppers" = 2, "spicy beans" = 2, "tortilla" = 2),
		SPECIES_TESHARI = list("fruity peppers" = 2, "beans" = 2, "tortilla" = 2)
	)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_BEANS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fuegoburrito/Initialize()
	. = ..()
	reagents.add_reagent("capsaicin", 4)

/obj/item/reagent_containers/food/snacks/breakfast_wrap
	name = "breakfast burrito"
	desc = "Bacon, eggs, cheese, and tortilla grilled to perfection."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "breakfast_wrap"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("tortilla" = 2, "cheese" = 2)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_DAIRY

/obj/item/reagent_containers/food/snacks/breakfast_wrap/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("bacon" = 4)))
	reagents.add_reagent("egg", 3, TASTE_DATA(list("scrambled egg" = 3)))

/obj/item/reagent_containers/food/snacks/burrito_mystery
	name = "burrito misterioso"
	desc = "The mystery is, why aren't you BSAing it?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "burrito_mystery"
	bitesize = 5
	center_of_mass = list("x"=16, "y"=16)
	nutriment_desc = list("regret" = 6)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/hatchling_suprise
	name = "hatchling suprise"
	desc = "A poached egg on top of three slices of bacon. A typical breakfast for hungry unathi children."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "hatchling_suprise"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/hatchling_suprise/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)
	reagents.add_reagent("protein", 4, TASTE_DATA(list("bacon" = 4)))

/obj/item/reagent_containers/food/snacks/red_sun_special
	name = "red sun special"
	desc = "One lousy piece of sausage sitting on melted cheese curds. A popular utilitarian meal for the unathi of Moghes."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "red_sun_special"
	nutriment_amt = 3
	nutriment_desc = list("cheese curds" = 3)
	nutriment_allergens = ALLERGEN_DAIRY
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/red_sun_special/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2, TASTE_DATA(list("smoked sausage" = 2)))

/obj/item/reagent_containers/food/snacks/riztizkzi_sea
	name = "moghesian sea delight"
	desc = "Three raw eggs floating in a sea of blood. An authentic replication of an ancient Unathi delicacy."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "riztizkzi_sea"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/riztizkzi_sea/Initialize()
	. = ..()
	reagents.add_reagent("blood", 10, TASTE_DATA(list("congealed blood" = 10)))
	reagents.add_reagent("egg", 6, TASTE_DATA(list("raw egg" = 6)))

/obj/item/reagent_containers/food/snacks/father_breakfast
	name = "breakfast of champions"
	desc = "A sausage and an omelette on top of a grilled steak."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "father_breakfast"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/father_breakfast/Initialize()
	. = ..()
	reagents.add_reagent("egg", 6)
	reagents.add_reagent("protein", 10, TASTE_DATA(list("grilled steak" = 5, "grilled sausage" = 5)))

/obj/item/reagent_containers/food/snacks/stuffed_meatball
	name = "stuffed meatball"
	desc = "A meatball loaded with cheese."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "stuffed_meatball"

/obj/item/reagent_containers/food/snacks/stuffed_meatball/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, TASTE_DATA(list("seasoned meat" = 3)))

/obj/item/reagent_containers/food/snacks/egg_pancake
	name = "meat pancake"
	desc = "An omelette baked on top of a giant meat patty. This monstrousity is typically shared between four people during a dinnertime meal."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "egg_pancake"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/egg_pancake/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("meat patty" = 6)))
	reagents.add_reagent("egg", 2)

/obj/item/reagent_containers/food/snacks/sliceable/grilled_carp
	name = "\improper Njarir Merana Grill"
	desc = "A well-dressed fish, seared to perfection and adorned with herbs and spices in a traditional Nerahni Tajaran style. Can be sliced into proper serving sizes."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "grilled_carp"
	slice_path = /obj/item/reagent_containers/food/snacks/grilled_carp_slice
	slices_num = 6
	nutriment_amt = 6
	nutriment_desc = list("citrus spices" = 6)
	nutriment_allergens = ALLERGEN_FRUIT
	trash = /obj/item/trash/snacktray

/obj/item/reagent_containers/food/snacks/sliceable/grilled_carp/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 12, TASTE_DATA(list("grilled fish" = 12)))

/obj/item/reagent_containers/food/snacks/grilled_carp_slice
	name = "\improper Njarir Merana Grill slice"
	desc = "A well-dressed fillet of carp, seared to perfection and adorned with herbs and spices."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "grilled_carp_slice"
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/redcurry
	name = "red curry"
	gender = PLURAL
	desc = "A bowl of creamy red curry with meat and rice. This one looks savory."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "redcurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f73333"
	nutriment_amt = 8
	nutriment_desc = list("rice" = 4, "bold spices" = 4)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_DAIRY
	center_of_mass = list("x"=16, "y"=8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/redcurry/Initialize()
	. = ..()
	reagents.add_reagent("protein", 7, TASTE_DATA(list("aromatic meat" = 7)))

/obj/item/reagent_containers/food/snacks/greencurry
	name = "green curry"
	gender = PLURAL
	desc = "A bowl of creamy green curry with tofu, hot peppers and rice. This one looks spicy!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "greencurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#58b76c"
	nutriment_amt = 7
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("rice" = 2, "very powerful spices" = 3, "sweetness" = 1),
		SPECIES_TESHARI      = list("rice" = 2, "rich and complex spices" = 3, "a pleasant bitter-sour note" = 1)
	)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_DAIRY|ALLERGEN_VEGETABLE
	center_of_mass = list("x"=16, "y"=8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/greencurry/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 6, TASTE_DATA(list("spiced tofu" = 6)))
	reagents.add_reagent("capsaicin", 2)

/obj/item/reagent_containers/food/snacks/yellowcurry
	name = "yellow curry"
	gender = PLURAL
	desc = "A bowl of creamy yellow curry with potatoes, peanuts and rice. This one looks mild."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "yellowcurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#bc9509"
	nutriment_amt = 15
	nutriment_desc = list("rice" = 4, "mildly spiced potatoes" = 4, "creamy herbs and spices" = 4)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_DAIRY|ALLERGEN_VEGETABLE
	center_of_mass = list("x"=16, "y"=8)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/bearburger
	name = "bearburger"
	desc = "The solution to your unbearable hunger."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "bearburger"
	filling_color = "#5d5260"
	center_of_mass = list("x"=15, "y"=11)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/bearburger/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("bear meat" = 4))) //So spawned burgers will not be empty I guess?

/obj/item/reagent_containers/food/snacks/bearchili
	name = "bear chili"
	gender = PLURAL
	desc = "A dark, hearty chili. Can you bear the heat?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "bearchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#702708"
	nutriment_amt = 3
	nutriment_desc = list("dark, hearty chili" = 3)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_MEAT
	center_of_mass = list("x"=15, "y"=9)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/bearchili/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)
	reagents.add_reagent("capsaicin", 3)
	reagents.add_reagent("tomatojuice", 2)
	reagents.add_reagent("hyperzine", 5)

/obj/item/reagent_containers/food/snacks/bearstew
	name = "bear stew"
	gender = PLURAL
	desc = "A thick, dark stew of bear meat and vegetables."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "bearstew"
	filling_color = "#9E673A"
	nutriment_amt = 6
	nutriment_desc = list("hearty stew" = 6)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_MEAT
	center_of_mass = list("x"=16, "y"=5)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/bearstew/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("hyperzine", 5)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("imidazoline", 5)
	reagents.add_reagent("water", 5)

/obj/item/reagent_containers/food/snacks/bibimbap
	name = "bibimbap bowl"
	desc = "A traditional Korean meal of meat and mixed vegetables. It's served on a bed of rice, and topped with a fried egg."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "bibimbap"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#4f2100"
	nutriment_amt = 12
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("fried egg" = 4, "sauted vegetables" = 4, "spicy gochujang" = 4),
		SPECIES_TESHARI = list("fried egg" = 4, "sauted vegetables" = 4, "rich gochujang" = 4)
	)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_EGGS|ALLERGEN_GRAINS
	center_of_mass = list("x"=15, "y"=9)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/bibimbap/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8, TASTE_DATA(list("marinated meat" = 8)))

/obj/item/reagent_containers/food/snacks/lomein
	name = "lo mein"
	gender = PLURAL
	desc = "A popular Chinese noodle dish. Chopsticks optional."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "lomein"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"
	nutriment_amt = 10
	nutriment_desc = list("noodles" = 6, "sesame sauce" = 2, "stir-fried vegetables" = 2)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_GRAINS //Adding seeds for the sesame description when there's none in the recipe would be cruel.
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/lomein/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2, TASTE_DATA(list("stir-fried meat" = 2)))

/obj/item/reagent_containers/food/snacks/friedrice
	name = "fried rice"
	gender = PLURAL
	desc = "A less-boring dish of less-boring rice!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "friedrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	nutriment_amt = 7
	nutriment_desc = list("fried rice" = 4, "fried vegetables" = 2, "soy sauce" = 1)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_GRAINS|ALLERGEN_BEANS
	center_of_mass = list("x"=17, "y"=11)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chickenfillet
	name = "chicken fillet sandwich"
	desc = "Fried chicken, in sandwich format. Beauty is simplicity."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "chickenfillet"
	filling_color = "#E9ADFF"
	nutriment_amt = 4
	nutriment_desc = list("breading" = 4)
	nutriment_allergens = ALLERGEN_GRAINS
	center_of_mass = list("x"=16, "y"=16)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/chickenfillet/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8, TASTE_DATA(list("fried chicken" = 8)))

/obj/item/reagent_containers/food/snacks/chickennoodlesoup
	name = "chicken noodle soup"
	gender = PLURAL
	desc = "A bright bowl of yellow broth with cuts of meat, noodles and carrots."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "chickennoodlesoup"
	filling_color = "#ead90c"
	nutriment_amt = 6
	nutriment_desc = list("bone broth" = 4, "pasta noodles" = 2)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_MEAT|ALLERGEN_VEGETABLE
	center_of_mass = list("x"=16, "y"=5)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/chickennoodlesoup/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("chicken" - 4)))
	reagents.add_reagent("water", 5)

/obj/item/reagent_containers/food/snacks/chilicheesefries
	name = "chili cheese fries"
	gender = PLURAL
	desc = "A mighty plate of fries, drowned in hot chili and cheese sauce. Because your arteries are overrated."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "chilicheesefries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	nutriment_amt = 10
	nutriment_desc = list("fresh fries" = 5, "cheese sauce" = 5)
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_VEGETABLE
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/chilicheesefries/Initialize()
	. = ..()
	reagents.add_reagent("capsaicin", 2)

/obj/item/reagent_containers/food/snacks/friedmushroom
	name = "fried mushroom"
	desc = "A tender, beer-battered plump helmet, fried to crispy perfection."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "friedmushroom"
	filling_color = "#EDDD00"
	nutriment_amt = 6
	nutriment_desc = list("alcoholic mushrooms" = 4, "fried batter" = 2)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_EGGS|ALLERGEN_FUNGI
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 5


/obj/item/reagent_containers/food/snacks/pisanggoreng
	name = "pisang goreng"
	gender = PLURAL
	desc = "Crispy, starchy, sweet banana fritters. Popular street food in parts of Sol."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "pisanggoreng"
	trash = /obj/item/trash/plate
	filling_color = "#301301"
	nutriment_amt = 8
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet bananas" = 6, "fried batter" = 2),
		SPECIES_TESHARI = list("bananas" = 6, "fried batter" = 2)
	)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_EGGS
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/meatbun
	name = "meat and leaf bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with a meat and cabbage filling."
	filling_color = "#DEDEAB"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "meatbun"
	nutriment_amt = 6
	nutriment_desc = list("fried cabbage" = 2, "lightly spiced seasoning" = 2, "steamed dough" = 2)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_GRAINS
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/meatbun/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("fried ground meat" = 4)))

/obj/item/reagent_containers/food/snacks/spicedmeatbun
	name = "char sui meat bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with a traditionally spiced meat filling."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "meatbun"
	filling_color = "#edd7d7"
	nutriment_amt = 6
	nutriment_desc = list("char sui seasoning" = 4, "steamed dough" = 2)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_GRAINS
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/spicedmeatbun/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, TASTE_DATA(list("fried ground meat" = 3)))

/obj/item/reagent_containers/food/snacks/custardbun
	name = "custard bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with an egg custard."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "meatbun"
	nutriment_amt = 6
	nutriment_desc = list("egg custard" = 4, "steamed dough" = 2)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_GRAINS|ALLERGEN_EGGS
	filling_color = "#ebedc2"
	center_of_mass = list("x"=16, "y"=11)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/chickenmomo
	name = "chicken momo"
	gender = PLURAL
	desc = "A plate of spiced and steamed chicken dumplings. The style originates from south Asia."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "momo"
	trash = /obj/item/trash/snacktray
	filling_color = "#edd7d7"
	nutriment_amt = 9
	nutriment_desc = list("chili garlic spices" = 6, "steamed dough" = 3)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE
	center_of_mass = list("x"=15, "y"=9)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/chickenmomo/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("chicken mince" = 6)))

/obj/item/reagent_containers/food/snacks/veggiemomo
	name = "veggie momo"
	gender = PLURAL
	desc = "A plate of spiced and steamed vegetable dumplings. The style originates from south Asia."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "momo"
	trash = /obj/item/trash/snacktray
	filling_color = "#edd7d7"
	nutriment_amt = 13
	nutriment_desc = list("minced vegetables" = 5, "ginger and herb seasoning" = 5, "steamed dough" = 3)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE
	center_of_mass = list("x"=15, "y"=9)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/risotto
	name = "risotto"
	gender = PLURAL
	desc = "A creamy, savory rice dish from southern Europe, typically cooked slowly with wine and broth. This one has bits of mushroom."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "risotto"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#edd7d7"
	nutriment_amt = 10
	nutriment_desc = list("savory rice" = 6, "creamy mushroom" = 4)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE|ALLERGEN_FUNGI
	center_of_mass = list("x"=15, "y"=9)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/risottoballs
	name = "risotto balls"
	gender = PLURAL
	desc = "Mushroom risotto that has been battered and deep fried. The best use of leftovers!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "risottoballs"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#edd7d7"
	nutriment_amt = 12
	nutriment_desc = list("savory rice" = 5, "creamy mushroom" = 5, "fried batter" = 2)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE|ALLERGEN_FUNGI
	center_of_mass = list("x"=15, "y"=9)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/honeytoast
	name = "piece of honeyed toast"
	desc = "For those who like their breakfast sweet."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "honeytoast"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	nutriment_amt = 5
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("toasted bread" = 2, "sweet honey" = 3),
		SPECIES_TESHARI      = list("toasted bread" = 2, "rich honey" = 3, "mild bitterness" = 1)
	)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_SUGARS
	center_of_mass = list("x"=16, "y"=9)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/poachedegg
	name = "poached egg"
	desc = "A delicately poached egg with a runny yolk. Healthier than its fried counterpart."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "poachedegg"
	trash = /obj/item/trash/plate
	filling_color = "#FFDF78"
	nutriment_amt = 1
	nutriment_desc = list("delicate egg whites" = 1)
	center_of_mass = list("x"=16, "y"=14)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/poachedegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 3)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_containers/food/snacks/ribplate
	name = "plate of ribs"
	desc = "A half-rack of ribs, brushed with some sort of honey-glaze. Why are there no napkins on board?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "ribplate"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"
	nutriment_amt = 6
	nutriment_desc = list("barbecue seasonings" = 6)
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 4

/obj/item/reagent_containers/food/snacks/ribplate/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("barbecued meat" = 6)))
	reagents.add_reagent("triglyceride", 2)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("honey", 5)

//Sliceables

/obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	name = "key lime pie"
	desc = "A tart, sweet dessert. What's a key lime, anyway?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "keylimepie"
	slice_path = /obj/item/reagent_containers/food/snacks/keylimepieslice
	slices_num = 5
	filling_color = "#F5B951"
	nutriment_amt = 20
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("zesty lime cream" = 14, "sweet wholewheat crust" = 6),
		SPECIES_TESHARI      = list("zesty lime cream" = 14, "wholewheat crust" = 6)
	)
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_DAIRY|ALLERGEN_SUGARS
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/snacks/keylimepieslice
	name = "slice of key lime pie"
	desc = "A slice of tart pie, with whipped cream on top."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "keylimepieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("zesty lime cream" = 2, "sweet wholewheat crust" = 3),
		SPECIES_TESHARI      = list("zesty lime cream" = 2, "wholewheat crust" = 3)
	)
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_DAIRY|ALLERGEN_SUGARS
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/keylimepieslice/filled
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/sliceable/quiche
	name = "quiche"
	desc = "Real men eat this, contrary to popular belief."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "quiche"
	slice_path = /obj/item/reagent_containers/food/snacks/quicheslice
	slices_num = 5
	filling_color = "#F5B951"
	nutriment_amt = 20
	nutriment_desc = list("savory crust" = 5, "cheese" = 5, "baked egg" = 10)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_DAIRY|ALLERGEN_GRAINS
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/snacks/quicheslice
	name = "slice of quiche"
	desc = "A slice of delicious quiche. Eggy, cheesy goodness."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "quicheslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	nutriment_desc = list("savory crust" = 1, "cheese" = 1, "baked egg" = 2)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_DAIRY|ALLERGEN_GRAINS
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/quicheslice/filled
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/sliceable/brownies
	name = "brownies"
	gender = PLURAL
	desc = "Halfway to fudge, or halfway to cake? Who cares!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "brownies"
	slice_path = /obj/item/reagent_containers/food/snacks/browniesslice
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#301301"
	nutriment_amt = 12
	nutriment_desc = list("chocolate fudge" = 8)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_SUGARS|ALLERGEN_GRAINS
	center_of_mass = list("x"=15, "y"=9)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/browniesslice
	name = "brownie"
	desc = "a dense, decadent chocolate brownie."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "browniesslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2
	nutriment_desc = list("chocolate fudge" = 8)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_SUGARS|ALLERGEN_GRAINS
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/browniesslice/filled
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies
	name = "cosmic brownies"
	gender = PLURAL
	desc = "Like, ultra-trippy. Brownies HAVE no gender, man." //Except I had to add one!
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "cosmicbrownies"
	slice_path = /obj/item/reagent_containers/food/snacks/cosmicbrowniesslice
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#301301"
	nutriment_amt = 10
	nutriment_desc = list("chocolate fudge" = 8, "musky wood" = 2)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_SUGARS|ALLERGEN_GRAINS
	center_of_mass = list("x"=15, "y"=9)
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies/Initialize()
	. = ..()
	reagents.add_reagent("ambrosia_extract", 2)
	reagents.add_reagent("bicaridine", 1)
	reagents.add_reagent("kelotane", 1)
	reagents.add_reagent("toxin", 1)

/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice
	name = "cosmic brownie"
	desc = "a dense, decadent and fun-looking chocolate brownie."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "cosmicbrowniesslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	nutriment_desc = list("chocolate fudge" = 8, "musky wood" = 2)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_SUGARS|ALLERGEN_GRAINS
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice/filled
	nutriment_amt = 1

/obj/item/reagent_containers/food/snacks/lasagna
	name = "lasagna"
	desc = "Meaty, tomato-y, and ready to eat-y. Favorite of cats."
	icon = 'icons/obj/food.dmi'
	icon_state = "lasagna"
	nutriment_amt = 5
	nutriment_desc = list("pasta" = 4, "roast tomato" = 4, "bechamel sauce" = 2)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE|ALLERGEN_FRUIT|ALLERGEN_MEAT

/obj/item/reagent_containers/food/snacks/lasagna/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("baked ground meat" = 4)))

/obj/item/reagent_containers/food/snacks/gigapuddi
	name = "Astro-Pudding"
	desc = "A crème caramel of astronomical size."
	icon = 'icons/obj/food.dmi'
	icon_state = "gigapuddi"
	nutriment_amt = 20
	nutriment_desc = list("caramel" = 10, "custard" = 10)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_SUGARS
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/gigapuddi/happy
	desc = "A crème caramel of astronomical size, made with extra love."
	icon = 'icons/obj/food.dmi'
	icon_state = "happypuddi"

/obj/item/reagent_containers/food/snacks/gigapuddi/anger
	desc = "A crème caramel of astronomical size, made with extra hate."
	icon_state = "angerpuddi"

/obj/item/reagent_containers/food/snacks/sliceable/buchedenoel
	name = "\improper Buche de Noel"
	desc = "Yule love it!"
	icon = 'icons/obj/food.dmi'
	icon_state = "buche"
	slice_path = /obj/item/reagent_containers/food/snacks/bucheslice
	slices_num = 5
	w_class = 2
	nutriment_amt = 20
	nutriment_desc = list("chocolate cake" = 10, "berry-infused cream" = 10)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_SUGARS|ALLERGEN_DAIRY
	bitesize = 3
	trash = /obj/item/trash/tray

/obj/item/reagent_containers/food/snacks/sliceable/buchedenoel/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 9)
	reagents.add_reagent("coco", 5)

/obj/item/reagent_containers/food/snacks/bucheslice
	name = "\improper Buche de Noel slice"
	desc = "A slice of winter magic."
	icon = 'icons/obj/food.dmi'
	icon_state = "buche_slice"
	nutriment_desc = list("chocolate cake" = 10, "berry-infused cream" = 10)
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_SUGARS|ALLERGEN_DAIRY
	trash = /obj/item/trash/plate
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/turkey
	name = "turkey"
	desc = "Tastes like chicken."
	icon = 'icons/obj/food.dmi'
	icon_state = "turkey"
	slice_path = /obj/item/reagent_containers/food/snacks/turkeyslice
	slices_num = 6
	w_class = 2
	nutriment_amt = 5
	nutriment_desc = list("herb stuffing" = 20)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_GRAINS
	bitesize = 5
	trash = /obj/item/trash/tray

/obj/item/reagent_containers/food/snacks/sliceable/turkey/Initialize()
	. = ..()
	reagents.add_reagent("protein", 20, TASTE_DATA(list("turkey meat" = 20)))
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("triglyceride", 1)

/obj/item/reagent_containers/food/snacks/turkeyslice
	name = "turkey drumstick"
	desc = "Forsooth!"
	icon = 'icons/obj/food.dmi'
	icon_state = "turkey_drumstick"
	trash = /obj/item/trash/plate
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/suppermatter
	name = "suppermatter"
	desc = "Extremely dense and powerful food."
	slice_path = /obj/item/reagent_containers/food/snacks/suppermattershard
	slices_num = 10
	icon = 'icons/obj/food.dmi'
	icon_state = "suppermatter"
	nutriment_amt = 48
	nutriment_desc = list("pure power" = 48)
	bitesize = 12
	w_class = 2

/obj/item/reagent_containers/food/snacks/sliceable/suppermatter/Initialize()
	. = ..()
	set_light(1.4,2,"#FFFF00")

/obj/item/reagent_containers/food/snacks/suppermattershard
	name = "suppermatter shard"
	desc = "A single portion of power."
	icon = 'icons/obj/food.dmi'
	icon_state = "suppermattershard"
	bitesize = 3
	trash = null

/obj/item/reagent_containers/food/snacks/suppermattershard/Initialize()
	. = ..()
	set_light(1.4,1.4,"#FFFF00")

/obj/item/reagent_containers/food/snacks/sliceable/excitingsuppermatter
	name = "exciting suppermatter"
	desc = "Extremely dense, powerful and exciting food!"
	slice_path = /obj/item/reagent_containers/food/snacks/excitingsuppermattershard
	slices_num = 10
	icon = 'icons/obj/food.dmi'
	icon_state = "excitingsuppermatter"
	nutriment_amt = 60
	nutriment_desc = list("pure, indescribable power" = 60)
	bitesize = 12
	w_class = 2

/obj/item/reagent_containers/food/snacks/sliceable/excitingsuppermatter/Initialize()
	. = ..()
	set_light(1.4,2,"#FF0000")

/obj/item/reagent_containers/food/snacks/excitingsuppermattershard
	name = "exciting suppermatter shard"
	desc = "A single portion of exciting power!"
	icon = 'icons/obj/food.dmi'
	icon_state = "excitingsuppermattershard"
	bitesize = 4
	trash = null

/obj/item/reagent_containers/food/snacks/excitingsuppermattershard/Initialize()
	. = ..()
	set_light(1.4,1.4,"#FF0000")

/obj/item/reagent_containers/food/snacks/omurice
	name = "omelette rice"
	desc = "Just like your Japanese animes!"
	icon = 'icons/obj/food.dmi'
	icon_state = "omurice"
	trash = /obj/item/trash/plate
	nutriment_amt = 8
	nutriment_desc = list("rice" = 4, "egg" = 4)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/omurice/heart
	icon = 'icons/obj/food.dmi'
	icon_state = "omuriceheart"

/obj/item/reagent_containers/food/snacks/omurice/face
	icon = 'icons/obj/food.dmi'
	icon_state = "omuriceface"

/obj/item/reagent_containers/food/snacks/cinnamonbun
	name = "cinnamon bun"
	desc = "Life needs frosting!"
	icon = 'icons/obj/food.dmi'
	icon_state = "cinnamonbun"
	trash = null
	nutriment_amt = 12
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet pastry" = 4, "cinnamon sugar" = 4, "sugar frosting" = 4),
		SPECIES_TESHARI      = list("dense pastry" = 4, "cinnamon" = 4, "crunchy frosting" = 2, "powerful bitterness" = 4)
	)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_DAIRY|ALLERGEN_GRAINS
	bitesize = 1

////////////////////Candy Vend Items///////////////////////////////////////////////////////////////


/obj/item/reagent_containers/food/snacks/candy
	name = "\improper Grandpa Elliot's Hard Candy"
	desc = "Now without nuts!"
	description_fluff = "Hard candies were banned from many early human colony ships due to the tendency for brittle, sticky chunks to find their way inside vital equipment in zero-G conditions. This only made them all the more popular to new arrivees, and the Grandpa Elliot's brand was Tau Ceti's answer to that demand."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7D5F46"
	center_of_mass = list("x"=15, "y"=15)
	nutriment_amt = 1
	nutriment_desc = list("candy" = 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/candy/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_containers/food/snacks/namagashi
	name = "\improper Ryo-kucha Namagashi"
	desc = "Sweet Japanese gummy like candy that are just bursting with flavor!"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "namagashi"
	trash = /obj/item/trash/namagashi
	filling_color = "#7D5F46"
	center_of_mass = list("x"=15, "y"=15)
	nutriment_amt = 10
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("candy" = 2, "sweetness" = 2, "fruit flavouring" = 2),
		SPECIES_TESHARI      = list("rubbery chewiness" = 2, "chemical bitterness" = 2, "fruit flavouring" = 2)
	)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/namagashi/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_containers/food/snacks/candy/proteinbar
	name = "\improper SwoleMAX protein bar"
	desc = "Guaranteed to get you feeling perfectly overconfident."
	description_fluff = "NanoMed's SwoleMAX boasts the highest density of protein mush per square inch among leading protein bar brands. While formulated for strength training, this high nutrient density in a mostly-solid form makes SwoleMAX a popular alternative for spacers looking to mix up their usual diet of pastes and gooes."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "proteinbar"
	trash = /obj/item/trash/candy/proteinbar
	nutriment_amt = 9
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("artificial sweetener" = 1, "protein" = 8),
		SPECIES_TESHARI      = list("cloying bitterness" = 3, "protein" = 8)
	)
	bitesize = 6

/obj/item/reagent_containers/food/snacks/candy/proteinbar/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("chalk" = 4)))
	reagents.add_reagent("sugar", 4)

/obj/item/reagent_containers/food/snacks/candy/gummy
	name = "\improper AlliCo Gummies"
	desc = "Somehow, there's never enough cola bottles."
	description_fluff = "AlliCo's grab-bags of gummy candies come in over a thousand novelty shapes and dozens of flavours. Shoes, astronauts, bunny rabbits and singularities all make an appearance."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "candy_gums"
	trash = /obj/item/trash/candy/gums
	nutriment_amt = 5
	nutriment_desc = list("artificial fruit flavour" = 5)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/candy/gummy/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 5)

/obj/item/reagent_containers/food/snacks/cookie
	name = "cookie"
	desc = "COOKIE!!!"
	icon_state = "COOKIE!!!"
	filling_color = "#DBC94F"
	center_of_mass = list("x"=17, "y"=18)
	nutriment_amt = 5
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweetness" = 3, "cookie" = 2),
		SPECIES_TESHARI      = list("crispness" = 2, "bitterness" = 1, "cookie" = 2)
	)

	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_GRAINS
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cookiesnack
	name = "Carps Ahoy! miniature cookies"
	desc = "Now 100% carpotoxin free!"
	description_fluff = "Carps Ahoy! cookies are required to sell under the 'Cap'n Choco' name in certain markets, out of concerns that children will become desensitized to the very real dangers of Space Carp."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cookiesnack"
	trash = /obj/item/trash/cookiesnack
	filling_color = "#DBC94F"
	nutriment_amt = 3
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweetness" = 1, "stale cookie" = 2),
		SPECIES_TESHARI      = list("bitterness" = 1, "stale cookie" = 2)
	)

	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_GRAINS
	bitesize = 1

/obj/item/reagent_containers/food/snacks/fruitbar
	name = "\improper ChewMAX fruit bar"
	desc = "Guaranteed to get you feeling comfortably superior."
	description_fluff = "NanoMed's ChewMAX is the low-carb alternative to the SwoleMAX range! Want short-term energy but not really interested in sustaining it? Hate fat but don't entirely understand nutrition? Just really like fruit? ChewMAX is for you!"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "fruitbar"
	trash = /obj/item/trash/candy/fruitbar
	nutriment_amt = 13
	nutriment_desc = list("apricot" = 2, "sugar" = 2, "dates" = 2, "cranberry" = 2, "apple" = 2)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_GRAINS|ALLERGEN_FRUIT
	bitesize = 6

/obj/item/reagent_containers/food/snacks/fruitbar/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)

////////////////////Candy Bars (1-10)///////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/cb01
	name = "\improper Tau Ceti Bar"
	desc = "A dark chocolate caramel and nougat bar made famous on Binma."
	description_fluff = "Binma's signature chocolate bar, the Tau Ceti Bar was originally made with cheap, heavily preserved ingredients available to Sol's first colonists. The modern recipe attempts to recreate this, baffling many not accustomed to its slightly stale taste."
	filling_color = "#552200"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cb01"
	nutriment_amt = 4
	nutriment_desc = list("stale chocolate" = 2, "nougat" = 1, "caramel" = 1)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_GRAINS
	w_class = 1
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cb01/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb02
	name = "\improper Hundred-Thousand Thaler Bar"
	desc = "An ironically cheap puffed rice caramel milk chocolate bar."
	description_fluff = "The Hundred-Thousand Thaler bar has been the focal point of dozens of exonet and radio giveaway pranks over its long history. In 2500 the company got in on the action, offering a prize of one-hundred thousand one-hundred thousand thaler bars to one lucky entrant, who reportedly turned down the prize in favour of a 250 Thaler cash prize."
	filling_color = "#552200"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cb02"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 2, "caramel" = 1, "puffed rice" = 1)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_GRAINS
	w_class = 1
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cb02/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb03
	name = "\improper Aerostat Bar"
	desc = "Bubbly milk chocolate."
	description_fluff = "An early slogan claimed the chocolate's bubbles where made with 'real Venusian gases', which is thought to have seriously harmed sales. The claim remains true, since the main production plant remains on Venus, but the company tries to avoid association with toxic air."
	filling_color = "#552200"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cb03"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 4)
	w_class = 1
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cb03/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb04
	name = "\improper Lars' Saltlakris"
	desc = "Milk chocolate embedded with chunks of salty licorice."
	description_fluff = "Produced exclusively in Kalmar for sale in Vir, Lars' Saltlakris is one of the system's most popular home-grown confectionaries."
	filling_color = "#552200"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cb04"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 2, "salt = 1", "licorice" = 1)
	w_class = 1
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cb04/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb05
	name = "\improper Andromeda Bar"
	desc = "A cheap milk chocolate bar loaded with sugar."
	description_fluff = "The galaxy's top-selling chocolate brand for almost 400 years. Also comes in dozens of varieties, including caramel, cookie, fruit and nut, and almond. This is just the basic stuff, though."
	filling_color = "#552200"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cb05"
	nutriment_amt = 3
	nutriment_desc = list("milk chocolate" = 2)
	w_class = 1
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cb05/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_containers/food/snacks/cb06
	name = "\improper Mocha Crunch"
	desc = "A large latte flavored wafer chocolate bar."
	description_fluff = "Lightly caffeinated, the Mocha Crunch is often considered to be more of an authentic coffee taste than most vending machine coffees."
	filling_color = "#552200"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cb06"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 2, "coffee" = 1, "vanilla wafer" = 1)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_GRAINS|ALLERGEN_COFFEE
	w_class = 1
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cb06/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)
	reagents.add_reagent("coffee", 1)

/obj/item/reagent_containers/food/snacks/cb07
	name = "\improper TaroMilk Bar"
	desc = "A light milk chocolate shell with a Taro paste filling. Chewy!"
	description_fluff = "The best-selling Kishari snack finally made its way to the galactic stage in 2562. Whether it is here to stay remains to be seen, though it has found some popularity with the Skrell.."
	filling_color = "#552200"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cb07"
	nutriment_amt = 4
	nutriment_desc = list("chocolate" = 2, "taro" = 2)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_VEGETABLE
	w_class = 1
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cb07/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_containers/food/snacks/cb08
	name = "\improper Cronk Bar"
	desc = "A large puffed malt milk chocolate bar."
	description_fluff = "The Cronk Bar proudly 'Comes in one flavour, so you'll never pick the wrong one!'. Its enduring popularity may be in part due to a longstanding deal with the SCG Fleet to include Cronk in standard military rations."
	filling_color = "#552200"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cb08"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 2, "malt puffs" = 1)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_GRAINS
	w_class = 1
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cb08/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_containers/food/snacks/cb09
	name = "\improper Kaju Mamma! Bar"
	desc = "A massive cluster of cashews and peanuts covered in a condensed milk solid."
	description_fluff = "Based on traditional South Asian desserts, the Kaju Mamma! is a deceptively soft, sweet bar voted 'Most allergenic candy' nineteen years running."
	filling_color = "#552200"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cb09"
	nutriment_amt = 6
	nutriment_desc = list("peanuts" = 3, "condensed milk" = 1, "cashews" = 2)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_SEEDS|ALLERGEN_DAIRY
	w_class = 1
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cb09/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)
	reagents.add_reagent("peanutoil", 1)

/obj/item/reagent_containers/food/snacks/cb10
	name = "\improper Shantak Bar"
	desc = "Nuts, nougat, peanuts, and caramel covered in chocolate."
	description_fluff = "Despite being often mistaken for a regional favourite, the Shantak Bar is sold under different 'localized' names in almost every human system in the galaxy, and adds up to being the third best selling confection produced by Centauri Provisions."
	filling_color = "#552200"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cb10"
	nutriment_amt = 5
	nutriment_desc = list("chocolate" = 2, "caramel" = 1, "peanuts" = 1, "nougat" = 1)
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_SEEDS
	w_class = 1
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cb10/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 1)
	reagents.add_reagent("protein", 1)
	reagents.add_reagent("peanutoil", 1)

////////////////////Misc Vend Items////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/chips
	name = "\improper What-The-Crisps"
	desc = "Commander Riker's What-The-Crisps, lightly salted."
	description_fluff = "What-The-Crisps' retro-styled starship commander has been a marketing staple for almost 200 years. Actual potatos haven't been used in potato chips for centuries. They're mostly a denatured nutrient slurry pressed into a chip-shaped mold and salted. Still tastes the same."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#E8C31E"
	center_of_mass = list("x"=15, "y"=15)
	nutriment_amt = 3
	nutriment_desc = list("salt" = 1, "chips" = 2)
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 1

/obj/item/reagent_containers/food/snacks/chips/bbq
	name = "\improper Legendary BBQ Chips"
	desc = "You know I can't grab your ghost chips!"
	description_fluff = "A local brand, Legendary Chips have proudly sponsored Vir's anti-drink-piloting campaign since 2558."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "chips_bbq"
	trash = /obj/item/trash/chips/bbq
	nutriment_amt = 3
	nutriment_desc = list("salt" = 1, "barbeque sauce" = 2)
	nutriment_allergens = ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/chips/snv
	name = "\improper Mike's Salt & Vinegar Chips"
	desc = "Painful to eat yet you just can't stop!"
	description_fluff = "Mike's Salt & Vinegar chips have been a staple of parties and events for decades, the chosen secondary dish to ordinary chips."
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "chips_snv"
	trash = /obj/item/trash/chips/snv
	nutriment_amt = 3
	nutriment_desc = list("salt" = 1, "vinegar" = 2)
	nutriment_allergens = ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space-reared cows."
	description_fluff = "Raising cows in low-gravity environments has the natural result of particularly tender meat. The jerking process largely undoes this apparent benefit, but it's just too damn efficient to ship not to."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"
	center_of_mass = list("x"=15, "y"=9)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sosjerky/Initialize()
	. =..()
	reagents.add_reagent("protein", 8, TASTE_DATA(list("dried meat" = 8)))


/obj/item/reagent_containers/food/snacks/tuna
	name = "\improper Tuna Snax"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "tuna"
	desc = "A packaged dried fish snack, guaranteed to do not contain space carp. Actual fish content may vary."
	description_fluff = "Launched by Centuari Provisions to target the Tajaran immigrant market, Tuna Snax also found a surprising niche among Vir's sizable Scandinavian population. Elsewhere, the dried fish flakes are widely considered disgusting."
	trash = /obj/item/trash/tuna
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)
	nutriment_amt = 3
	nutriment_desc = list("smoked fish" = 5)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tuna/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 4, TASTE_DATA(list("dried fish" = 4)))

/obj/item/reagent_containers/food/snacks/pistachios
	name = "pistachios"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "pistachios"
	desc = "Pistachios. There is absolutely nothing remarkable about these."
	trash = /obj/item/trash/pistachios
	filling_color = "#825D26"
	center_of_mass = list("x"=17, "y"=13)
	nutriment_desc = list("nuts" = 1)
	nutriment_amt = 3
	nutriment_allergens = ALLERGEN_SEEDS
	bitesize = 1

/obj/item/reagent_containers/food/snacks/semki
	name = "\improper Semki"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "semki"
	desc = "Sunflower seeds. A favorite among both birds and gopniks."
	trash = /obj/item/trash/semki
	filling_color = "#68645D"
	center_of_mass = list("x"=17, "y"=13)
	nutriment_desc = list("sunflower seeds" = 1)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_SEEDS
	bitesize = 1

/obj/item/reagent_containers/food/snacks/squid
	name = "\improper Calamari Crisps"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "squid"
	desc = "Space squid tentacles, Carefully removed (from the squid) then dried into strips of delicious rubbery goodness!"
	trash = /obj/item/trash/squid
	filling_color = "#c0a9d7"
	center_of_mass = list ("x"=15, "y"=9)
	nutriment_desc = list("salt" = 1)
	nutriment_amt = 3
	bitesize = 1

/obj/item/reagent_containers/food/snacks/squid/true/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 4)

/obj/item/reagent_containers/food/snacks/croutons
	name = "\improper Suhariki"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "croutons"
	desc = "Fried bread cubes. Popular in some Solar territories."
	trash = /obj/item/trash/croutons
	filling_color = "#c6b17f"
	center_of_mass = list ("x"=15, "y"=9)
	nutriment_desc = list("bread" = 1, "salt" = 1)
	nutriment_allergens = ALLERGEN_GRAINS
	nutriment_amt = 3
	bitesize = 1

/obj/item/reagent_containers/food/snacks/salo
	name = "\improper Salo"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "pigfat"
	desc = "Pig fat. Salted. Just as good as it sounds."
	trash = /obj/item/trash/salo
	filling_color = "#e0bcbc"
	center_of_mass = list ("x"=15, "y"=9)
	nutriment_desc = list("fat" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 2

/obj/item/reagent_containers/food/snacks/salo/true/Initialize()
	. = ..()
	reagents.add_reagent("protein", 8, TASTE_DATA(list("greasy dried meat" = 8)))

/obj/item/reagent_containers/food/snacks/driedfish
	name = "\improper Vobla"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "driedfish"
	desc = "Dried salted beer snack fish."
	trash = /obj/item/trash/driedfish
	filling_color = "#c8a5bb"
	center_of_mass = list ("x"=15, "y"=9)
	nutriment_desc = list("salt" = 2)
	nutriment_amt = 2
	bitesize = 1

/obj/item/reagent_containers/food/snacks/driedfish/Initialize()
	.=..()
	reagents.add_reagent("seafood", 4)

/obj/item/reagent_containers/food/snacks/no_raisin
	name = "4no Raisins"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	description_fluff = "Originally Raisin Blend no. 4, 4noraisins obtained their current name in the Skadi Positronic Exclusion Crisis of 2442, where they were rebranded as part of the protests. The exclusion crisis, so the story goes, involved positronic immigration being banned for no raisin."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"
	center_of_mass = list("x"=15, "y"=4)
	nutriment_desc = list("dried raisins" = 6)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_FRUIT

/obj/item/reagent_containers/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth."
	description_fluff = "The origins of the flourescent orange dust produced by Cheesie Honkers is considered a trade secret, despite having been leaked on the exonet decades ago. It's the cheese."
	trash = /obj/item/trash/cheesie
	filling_color = "#FFA305"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_amt = 4
	nutriment_desc = list("cheese" = 5, "corn puffs" = 2)
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/syndicake
	name = "Syndi-Cakes"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	description_fluff = "Spacer Snack Cakes' meaner, tastier cousin. The Syndi-Cakes brand was at risk of dissolution in 2429 when it was revealed that the entire production chain was a Nos Amis joint. The brand was quickly aquired by Centauri Provisions and some mild hallucinogenic 'add-ins' were axed from the recipe."
	trash = /obj/item/trash/syndi_cakes
	filling_color = "#FF5D05"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweetness" = 3, "soggy cake" = 1),
		SPECIES_TESHARI      = list("bitterness" = 3, "soggy cake" = 1)
	)
	nutriment_amt = 4
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_SUGARS
	bitesize = 3

/obj/item/reagent_containers/food/snacks/syndicake/Initialize()
	. = ..()
	reagents.add_reagent("doctorsdelight", 5)

////////////////////sol_vend (Mars Mart)////////////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/triton
	name = "\improper Tidal Gobs"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "tidegobs"
	desc = "Contains over 9000% of your daily recommended intake of salt."
	trash = /obj/item/trash/tidegobs
	filling_color = "#2556b0"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("salt" = 4, "seagull?" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/saturn
	name = "\improper Saturn-Os"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "saturn0s"
	desc = "A peanut flavored snack that looks like the rings of Saturn!"
	trash = /obj/item/trash/saturno
	filling_color = "#dca319"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("salt" = 4, "peanut" = 2,  "wood?" = 1)
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_SEEDS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/jupiter
	name = "\improper Jove Gello"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "jupiter"
	desc = "By Joove! It's some kind of gel."
	trash = /obj/item/trash/jupiter
	filling_color = "#dc1919"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweetness" = 4, "vanilla" = 1),
		SPECIES_TESHARI      = list("mild bitterness" = 1, "vanilla" = 4)
	)
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pluto
	name = "\improper Plutonian Rods"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "pluto"
	desc = "Baseless tasteless nutrithick rods to get you through the day. Now even less rash inducing!"
	trash = /obj/item/trash/pluto
	filling_color = "#ffffff"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("chalk" = 4, "sadness" = 1)
	nutriment_amt = 5
	bitesize = 2

/obj/item/reagent_containers/food/snacks/mars
	name = "\improper Frouka"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "mars"
	desc = "A steaming self-heated bowl of sweet eggs and taters!"
	trash = /obj/item/trash/mars
	filling_color = "#d2c63f"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("eggs" = 4, "potato" = 4, "mustard" = 2)
	nutriment_amt = 8
	nutriment_allergens = ALLERGEN_EGGS|ALLERGEN_VEGETABLE|ALLERGEN_SEEDS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/venus
	name = "\improper Venusian Hot Cakes"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "venus"
	desc = "Hot takes on hot cakes, a timeless classic now finally fit for human consumption!"
	trash = /obj/item/trash/venus
	filling_color = "#d2c63f"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("heat" = 4, "burning!" = 1)
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/venus/Initialize()
	.=..()
	reagents.add_reagent("capsaicin", 5)

/obj/item/reagent_containers/food/snacks/sun_snax
	name = "\improper Sun Snax!"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "sun_snax"
	desc = "A Sol favorite, Sun Snax! Sun dried corn chips coated in a super spicy seasoning!"
	trash = /obj/item/trash/sun_snax
	filling_color = "#d2c63f"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("heat" = 3, "burning!" = 2)
	nutriment_amt = 3
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 1

/obj/item/reagent_containers/food/snacks/sun_snax/Initialize()
	.=..()
	reagents.add_reagent("capsaicin", 6)

/obj/item/reagent_containers/food/snacks/oort
	name = "\improper Oort Cloud Rocks"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "oort"
	desc = "Pop rocks themed on the outermost reaches of the Sol system, new formula guarantees fewer shrapnel induced oral injuries."
	trash = /obj/item/trash/oort
	filling_color = "#3f7dd2"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("fizz" = 4, "sweetness" = 1),
		SPECIES_TESHARI      = list("fizz" = 4, "mild bitterness" = 1)
	)
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/oort/Initialize()
	.=..()
	reagents.add_reagent("frostoil",5)

/obj/item/reagent_containers/food/snacks/pretzels
	name = "\improper Value Pretzel Snack"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "pretzel"
	trash = /obj/item/trash/pretzel
	desc = "A tasty bread like snack that is seasoned with what tastes like salt... but you're not so sure it's actually salt."
	filling_color = "#916E36"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("salt" = 2, "pretzel" = 3)
	nutriment_amt = 3
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 1

/obj/item/reagent_containers/food/snacks/hakarl
	name = "\improper Indigo Co. Hákarl"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "hakarl"
	trash = /obj/item/trash/hakarl
	desc = "Fermented space shark, like chewing a urine soaked mattress."
	description_fluff = "A form of fermented shark that originated on Earth as far back as the 17th century. Modern Hakarl is made from vat-made fermented shark and is distributed across the galaxy as a delicacy. However, few are able to stand the smell or taste of the meat."
	filling_color = "#916E36"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("fish" = 2, "salt" = 2, "ammonia" = 1)
	nutriment_amt = 4
	nutriment_allergens = ALLERGEN_FISH
	bitesize = 1

////////////////////weeb_vend (Nippon-tan!)////////////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/ricecake
	name = "rice cake"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "ricecake"
	desc = "Ancient earth snack food made from balled up rice."
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("rice" = 4, "sweetness" = 1),
		SPECIES_TESHARI      = list("rice" = 4, "mild bitterness" = 1)
	)
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_GRAINS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/dorayaki
	name = "dorayaki"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "dorayaki"
	desc = "Two small pancake-like patties made from castella wrapped around a filling of sweet azuki bean paste."
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 3, "sweetness" = 2),
		SPECIES_TESHARI      = list("cake" = 3, "mild bitterness" = 1)
	)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE|ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/daifuku
	name = "daifuku"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "daifuku"
	desc = "Small round mochi stuffed with sweetened red bean paste."
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 2, "sweetness" = 3),
		SPECIES_TESHARI      = list("cake" = 3, "mild bitterness" = 1)
	)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE
	bitesize = 2

/obj/item/reagent_containers/food/snacks/weebonuts
	name = "\improper Red Alert Nuts!"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "weebonuts"
	trash = /obj/item/trash/weebonuts
	desc = "A bag of Red Alert! brand spicy nuts. Goes well with your beer!"
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("nuts" = 4, "spicyness" = 1),
		SPECIES_TESHARI = list("nuts" = 4, "a strange, cloying aftertaste" = 1)
	)
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_SEEDS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/weebonuts/Initialize()
	.=..()
	reagents.add_reagent("capsaicin",1)

/obj/item/reagent_containers/food/snacks/wasabi_peas
	name = "\improper Hadokikku Peas"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "wasabi_peas"
	trash = /obj/item/trash/wasabi_peas
	desc = "A bag of Hadokikku brand wasabi peas, a delicious snack most definitely not imported directly from Sol, despite the advertisements."
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("peas" = 4, "spicyness" = 1),
		SPECIES_TESHARI = list("peas" = 4, "a strange, cloying aftertaste" = 1)
	)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_VEGETABLE
	bitesize = 2

/obj/item/reagent_containers/food/snacks/wasabi_peas/Initialize()
	.=..()
	reagents.add_reagent("capsaicin",1)

/obj/item/reagent_containers/food/snacks/chocobanana
	name = "\improper Choco Banana"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "chocobanana"
	trash = /obj/item/trash/stick
	desc = "A chocolate and sprinkles coated banana. On a stick."
	nutriment_desc = list("chocolate banana" = 4, "sprinkles" = 1)
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_SUGARS|ALLERGEN_FRUIT
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chocobanana/Initialize()
	.=..()
	reagents.add_reagent("sprinkles", 10)

/obj/item/reagent_containers/food/snacks/goma_dango
	name = "\improper Goma dango"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "goma_dango"
	trash = /obj/item/trash/stick
	desc = "Sticky rice balls served on a skewer with a crispy rice flour outer layer and a thick red bean paste inner layer."
	nutriment_desc = list("rice" = 4, "earthy flavor" = 1)
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE
	bitesize = 2

/obj/item/reagent_containers/food/snacks/hanami_dango
	name = "\improper Hanami dango"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "hanami_dango"
	trash = /obj/item/trash/stick
	desc = "Three rice balls, each with a unique flavoring, served on a skewer. A traditional Japanese treat."
	description_fluff = "Hanami dango is a traditional Japanese treat that is normally served during Hanami, a tradition dated back as early as the 8th century. Hanami, or cherry blossom viewing, is a spring time celebration that celebrates the cherry blossoms turning of color. It is a time of renewal, of life, and of beauty."
	nutriment_desc = list("rice" = 4, "earthy flavor" = 1)
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_VEGETABLE
	bitesize = 2

////////////////////ancient_vend (Hot Food - Old)////////////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/old
	name = "master old-food"
	desc = "they're all inedible and potentially dangerous items"
	center_of_mass = list ("x"=15, "y"=9)
	nutriment_desc = list("rot" = 5, "mold" = 5)
	nutriment_amt = 10
	bitesize = 3
	filling_color = "#336b42"
/obj/item/reagent_containers/food/snacks/old/Initialize()
	.=..()
	reagents.add_reagent(pick(list(
				"fuel",
				"amatoxin",
				"carpotoxin",
				"zombiepowder",
				"cryptobiolin",
				"psilocybin")), 5)

/obj/item/reagent_containers/food/snacks/old/pizza
	name = "\improper Pizza!"
	desc = "It's so stale you could probably cut something with the cheese."
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_FUNGI|ALLERGEN_DAIRY
	icon_state = "ancient_pizza"

/obj/item/reagent_containers/food/snacks/old/burger
	name = "\improper Giga Burger!"
	desc = "At some point in time this probably looked delicious."
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_FUNGI|ALLERGEN_MEAT
	icon_state = "ancient_burger"

/obj/item/reagent_containers/food/snacks/old/horseburger
	name = "\improper Horse Burger!"
	desc = "Even if you were hungry enough to eat a horse, it'd be a bad idea to eat this."
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_FUNGI|ALLERGEN_MEAT
	icon_state = "ancient_horse_burger"

/obj/item/reagent_containers/food/snacks/old/fries
	name = "\improper Space Fries!"
	desc = "The salt appears to have preserved these, still stale and gross."
	nutriment_allergens = ALLERGEN_FUNGI|ALLERGEN_VEGETABLE
	icon_state = "ancient_fries"

/obj/item/reagent_containers/food/snacks/old/hotdog
	name = "\improper Space Dog!"
	desc = "This one is probably only marginally less safe to eat than when it was first created.."
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_FUNGI|ALLERGEN_MEAT
	icon_state = "ancient_hotdog"

/obj/item/reagent_containers/food/snacks/old/taco
	name = "\improper Taco!"
	desc = "Interestingly, the shell has gone soft and the contents have gone stale."
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_FUNGI|ALLERGEN_MEAT
	icon_state = "ancient_taco"

//////////////////////Canned Foods - crack open and eat (ADDED 04/11/2021)//////////////////////

/obj/item/reagent_containers/food/snacks/canned
	name = "void can"
	icon = 'icons/obj/food_canned.dmi'
	atom_flags = EMPTY_BITFIELD
	var/sealed = TRUE

/obj/item/reagent_containers/food/snacks/canned/Initialize()
	. = ..()
	if(!sealed)
		unseal()

/obj/item/reagent_containers/food/snacks/canned/examine(mob/user)
	. = ..()
	to_chat(user, "It is [sealed ? "" : "un"]sealed.")

/obj/item/reagent_containers/food/snacks/canned/proc/unseal()
	atom_flags |= ATOM_REAGENTS_IS_OPEN
	sealed = FALSE
	update_icon()

/obj/item/reagent_containers/food/snacks/canned/attack_self(var/mob/user)
	if(sealed)
		playsound(loc,'sound/effects/tincanopen.ogg', rand(10,50), 1)
		to_chat(user, "<span class='notice'>You unseal \the [src] with a crack of metal.</span>")
		unseal()

/obj/item/reagent_containers/food/snacks/canned/update_icon()
	if(!sealed)
		icon_state = "[initial(icon_state)]-open"

//////////Just a short line of Canned Consumables, great for treasure in faraway abandoned outposts//////////

/obj/item/reagent_containers/food/snacks/canned/beef
	name = "canned beef"
	icon_state = "beef"
	desc = "A can of premium preserved vat-grown holstein beef. Now 99.9% bone free!"
	trash = /obj/item/trash/beef
	filling_color = "#663300"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("corned beef" = 1)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/canned/beef/Initialize()
	.=..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("corned beef" = 4)))
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_containers/food/snacks/canned/beans
	name = "baked beans"
	icon_state = "beans"
	desc = "Luna Colony beans. Carefully synthethized from soy."
	trash = /obj/item/trash/beans
	filling_color = "#ff6633"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("beans" = 1, "tomato sauce" = 1)
	nutriment_allergens = ALLERGEN_BEANS|ALLERGEN_FRUIT
	nutriment_amt = 15
	bitesize = 2

/obj/item/reagent_containers/food/snacks/canned/spinach
	name = "spinach"
	icon_state = "spinach"
	desc = "I-Yam Brand canned spinach. Toot toot!"
	trash = /obj/item/trash/spinach
	filling_color = "#003300"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_amt = 5
	nutriment_desc = list("soggy leaves" = 5)
	nutriment_allergens = ALLERGEN_VEGETABLE
	bitesize = 5

/obj/item/reagent_containers/food/snacks/canned/spinach/Initialize()
	.=..()
	reagents.add_reagent("adrenaline", 5)
	reagents.add_reagent("hyperzine", 5)
	reagents.add_reagent("iron", 5)

//////////////////////////////Advanced Canned Food//////////////////////////////

/obj/item/reagent_containers/food/snacks/canned/caviar
	name = "\improper Soyuz Caviar"
	icon_state = "fisheggs"
	desc = "Soyuz Caviar, or space carp eggs. Carefully treated to eliminate those pesky toxins, though it does lack that delicious signature numbness."
	trash = /obj/item/trash/fishegg
	filling_color = "#000000"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("salt" = 1)
	nutriment_amt = 6
	bitesize = 1

/obj/item/reagent_containers/food/snacks/canned/caviar/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 5, TASTE_DATA(list("salty fish eggs" = 5)))

/obj/item/reagent_containers/food/snacks/canned/caviar/true
	name = "\improper Authentic Soyuz Caviar"
	icon_state = "carpeggs"
	desc = "Soyuz caviar, or space carp eggs. Banned by the Vir Food Health Administration for exceeding the legally set amount of carpotoxins in food stuffs."
	trash = /obj/item/trash/carpegg
	filling_color = "#330066"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("fish" = 1, "salt" = 1, "a numbing sensation" = 1)
	nutriment_amt = 6
	bitesize = 1

/obj/item/reagent_containers/food/snacks/caviar/true/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("carpotoxin", 1)

/obj/item/reagent_containers/food/snacks/canned/maps
	name = "\improper MAPS"
	icon_state = "maps"
	desc = "A re-branding of a classic Earth snack! Contains mostly edible ingredients."
	trash = /obj/item/trash/maps
	filling_color = "#330066"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("salt" = 3)
	nutriment_amt = 8
	bitesize = 2

/obj/item/reagent_containers/food/snacks/maps/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6, TASTE_DATA(list("slimy meat" = 6)))
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_containers/food/snacks/canned/appleberry
	name = "\improper Appleberry Bits"
	icon_state = "appleberry"
	desc = "A classic snack favored by Sol astronauts. Made from dried apple-hybridized berries grown on Venus."
	trash = /obj/item/trash/appleberry
	filling_color = "#FFFFFF"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("dried apple" = 1, "sweetness" = 1),
		SPECIES_TESHARI      = list("dried apple" = 2, "mild bitterness" = 1)
	)
	nutriment_amt = 10
	nutriment_allergens = ALLERGEN_FRUIT
	bitesize = 2

/obj/item/reagent_containers/food/snacks/canned/ntbeans
	name = "baked beans"
	icon_state = "ntbeans"
	desc = "Musical fruit in a slightly less musical container. Now with bacon!"
	trash = /obj/item/trash/ntbeans
	filling_color = "#FC6F28"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_desc = list("beans" = 4)
	nutriment_amt = 6
	nutriment_allergens = ALLERGEN_BEANS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/canned/ntbeans/Initialize()
	. = ..()
	reagents.add_reagent("protein", 2, TASTE_DATA(list("bacon bits" = 2)))

//////////////Packaged Food - break open and eat//////////////

/obj/item/reagent_containers/food/snacks/packaged
	icon = 'icons/obj/food_package.dmi'
	package = TRUE

//////////////Lunar Cakes - proof of concept//////////////

/obj/item/reagent_containers/food/snacks/packaged/lunacake
	name = "\improper Lunar Cake"
	icon_state = "lunacake"
	desc = "Now with 20% less lawsuit enabling rhegolith!"
	package_trash = /obj/item/trash/lunacakewrap
	package_open_state = "lunacake_open"
	filling_color = "#ffffff"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_amt = 6
	nutriment_desc = list("stale cake" = 4, "vanilla" = 1)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/packaged/darklunacake
	name = "\improper Dark Lunar Cake"
	icon_state = "mooncake"
	desc = "Explore the dark side! May contain trace amounts of reconstituted cocoa."
	package_trash = /obj/item/trash/mooncakewrap
	package_open_state = "lunacake_open"
	filling_color = "#ffffff"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_amt = 6
	nutriment_desc = list("stale cake" = 4, "chocolate" = 1)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/packaged/mochicake
	name = "\improper Mochi Cake"
	icon_state = "mochicake"
	desc = "Konnichiwa! Many go lucky rice cakes in future!"
	package_trash = /obj/item/trash/mochicakewrap
	package_open_state = "lunacake_open"
	filling_color = "#ffffff"
	center_of_mass = list("x"=15, "y"=9)
	nutriment_amt = 6
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("rice" = 1, "sweetness" = 4),
		SPECIES_TESHARI      = list("rice" = 2, "mild bitterness" = 1)
	)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_SUGARS
	bitesize = 2

//////////////Advanced Package Foods//////////////

/obj/item/reagent_containers/food/snacks/packaged/spacetwinkie
	name = "\improper Spacer Snack Cake"
	icon_state = "spacer_cake"
	desc = "Guaranteed to survive longer than you will."
	description_fluff = "Despite Spacer advertisements consistently portraying their snack cakes as life-saving, tear-jerking survival food for spacers in all kinds of dramatic scenarios, the Spacer Snack Cake has been statistically proven to lower survival rates on all missions where it is present."
	package_trash = /obj/item/trash/spacer_cake_wrap
	package_open_state = "spacer_cake_open"
	filling_color = "#FFE591"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("stale cake" = 2, "sweetness" = 4),
		SPECIES_TESHARI      = list("stale cake" = 2, "mild bitterness" = 1)
	)
	nutriment_allergens = ALLERGEN_GRAINS|ALLERGEN_SUGARS
	bitesize = 2

/obj/item/reagent_containers/food/snacks/packaged/spacetwinkie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)

/obj/item/reagent_containers/food/snacks/packaged/genration
	name = "generic ration"
	icon_state = "genration"
	desc = "The most basic form of ration - meant to barely sustain life."
	trash = /obj/item/trash/genration
	package_open_state = "genration_open"
	filling_color = "#FFFFFF"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list("chalk" = 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/packaged/meatration
	name = "meat ration"
	icon_state = "meatration"
	desc = "A meat flavored ration. Emphasis on 'meat flavored' as there is likely no real meat in this."
	trash = /obj/item/trash/meatration
	package_open_state = "meatration_open"
	filling_color = "#FFFFFF"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list("chalk" = 3, "meat" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/packaged/meatration/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3)

/obj/item/reagent_containers/food/snacks/packaged/vegration
	name = "veggie ration"
	icon_state = "vegration"
	desc = "Dried veggies in a bag. Depressing and near flavorless."
	trash = /obj/item/trash/vegration
	package_open_state = "vegration_open"
	filling_color = "#FFFFFF"
	center_of_mass = list("x"=15, "y"=11)
	nutriment_amt = 4
	nutriment_desc = list("sadness" = 3, "veggie" = 3)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/packaged/sweetration
	name = "dessert ration"
	icon_state = "baseration"
	desc = "A rare ration from an era gone by filled with a sweet tasty treat that no modern company has been able to recreate."
	trash = /obj/item/trash/sweetration
	package_open_state = "baseration_open"
	filling_color = "#FFFFFF"
	nutriment_amt = 4
	center_of_mass = list("x"=15, "y"=11)
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("cake" = 1, "sweetness" = 5),
		SPECIES_TESHARI      = list("cake" = 2, "mild bitterness" = 1)
	)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/packaged/sweetration/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 6)

/obj/item/reagent_containers/food/snacks/packaged/vendburger
	name = "packaged burger"
	icon_state = "smolburger"
	desc = "A burger stored in a plastic wrapping for vending machine distribution. Surely it tastes fine!"
	package_trash = /obj/item/trash/smolburger
	package_open_state = "smolburger_open"
	nutriment_amt = 3
	nutriment_desc = list("stale burger" = 3)

/obj/item/reagent_containers/food/snacks/packaged/vendburger/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_containers/food/snacks/packaged/vendhotdog
	name = "packaged hotdog"
	icon_state = "smolhotdog"
	desc = "A hotdog stored in a plastic wrapping for vending machine distribution. Surely it tastes fine!"
	package_trash = /obj/item/trash/smolhotdog
	package_open_state = "smolhotdog_open"
	nutriment_amt = 3
	nutriment_desc = list("stale hotdog" = 3)

/obj/item/reagent_containers/food/snacks/packaged/vendhotdog/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_containers/food/snacks/packaged/vendburrito
	name = "packaged burrito"
	icon_state = "smolburrito"
	desc = "A burrito stored in a plastic wrapping for vending machine distribution. Surely it tastes fine!"
	package_trash = /obj/item/trash/smolburrito
	package_open_state = "smolburrito_open"
	nutriment_amt = 3
	nutriment_desc = list("stale burrito" = 3)

/obj/item/reagent_containers/food/snacks/packaged/vendburrito/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_containers/food/snacks/sliceable/sushi
	name = "sushi roll"
	desc = "A whole sushi roll! Slice it up and enjoy with some soy sauce and wasabi."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "sushi"
	slice_path = /obj/item/reagent_containers/food/snacks/slice/sushi/filled
	slices_num = 5
	bitesize = 5
	nutriment_desc = list("rice" = 5, "seaweed" = 5)
	nutriment_amt = 15
	nutriment_allergens = ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/sliceable/sushi/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 10, TASTE_DATA(list("fresh fish" = 10)))

/obj/item/reagent_containers/food/snacks/slice/sushi
	name = "piece of sushi"
	desc = "A slice of a larger sushi roll, ready to devour."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "sushi_s"
	bitesize = 5
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/obj/item/reagent_containers/food/snacks/slice/sushi/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/goulash
	name = "goulash"
	desc = "Hope you're Hungary!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "goulash"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 6
	nutriment_desc = list("stewed vegetables" = 2, "paprika" = 5)
	nutriment_allergens = ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/goulash/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5, TASTE_DATA(list("stewed meat" = 5)))
	reagents.add_reagent("water", 5)


/obj/item/reagent_containers/food/snacks/donerkebab
	name = "doner kebab"
	desc = "Traditional food of the very drunk. The meat is typically cooked on a vertical rotisserie."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "doner_kebab"
	nutriment_amt = 2
	nutriment_desc = list("crisp salad" = 2)
	nutriment_allergens = ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/donerkebab/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5, TASTE_DATA(list("seasoned meat" = 5)))

/obj/item/reagent_containers/food/snacks/roastbeef
	name = "roast beef"
	desc = "It's beef. It's roasted. It's been a staple of dining tradition for centuries."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "roastbeef"
	trash = /obj/item/trash/plate
	bitesize = 2

/obj/item/reagent_containers/food/snacks/roastbeef/Initialize()
	. = ..()
	reagents.add_reagent("protein", 12, TASTE_DATA(list("roasted meat" = 12)))


/obj/item/reagent_containers/food/snacks/reishicup
	name = "reishi's cup"
	desc = "A chocolate treat with an odd flavor."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "reishiscup"
	bitesize = 6
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 4, "colors" = 2)
	nutriment_allergens = ALLERGEN_FUNGI|ALLERGEN_SUGARS

/obj/item/reagent_containers/food/snacks/reishicup/Initialize()
	. = ..()
	reagents.add_reagent("psilocybin", 3)

/obj/item/storage/box/wings //This is kinda like the donut box.
	name = "wing basket"
	desc = "A basket of chicken wings! Get some before they're all gone! Or maybe you're too late..."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "wings5"
	var/icon_base = "wings"
	var/startswith = 5
	max_storage_space = ITEMSIZE_COST_SMALL * 5
	can_hold = list(/obj/item/reagent_containers/food/snacks/chickenwing)
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/chickenwing = 5
	)
	foldable = null

/obj/item/storage/box/wings/Initialize()
	. = ..()
	update_icon()
	return

/obj/item/storage/box/wings/update_icon()
	var/i = 0
	for(var/obj/item/reagent_containers/food/snacks/W in contents)
		i++
	icon_state = "[icon_base][i]"

/obj/item/reagent_containers/food/snacks/chickenwing
	name = "chicken wing"
	desc = "What flavor even is this? Buffalo? Barbecue? Or something more exotic?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "wing"
	bitesize = 3
	nutriment_amt = 2
	nutriment_desc = list("unplacable flavor sauce" = 2)

/obj/item/reagent_containers/food/snacks/chickenwing/Initialize()
	. = ..()
	reagents.add_reagent("protein", 3, TASTE_DATA(list("chicken" = 3)))

/obj/item/reagent_containers/food/snacks/hotandsoursoup
	name = "hot & sour soup"
	desc = "A soup both spicy and sour from ancient Chinese cooking traditions. This one is made with tofu."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "hotandsoursoup"
	trash = /obj/item/trash/asian_bowl
	bitesize = 2
	nutriment_amt = 6
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("spicyness" = 4, "sourness" = 4, "tofu" = 1),
		SPECIES_TESHARI = list("cloying heat" = 4, "sourness" = 4, "tofu" = 1)
	)
	nutriment_allergens = ALLERGEN_FUNGI|ALLERGEN_BEANS|ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/hotandsoursoup/Initialize()
	. = ..()

/obj/item/reagent_containers/food/snacks/kitsuneudon
	name = "kitsune udon"
	desc = "A purported favorite of kitsunes in ancient japanese myth: udon noodles, fried egg, and tofu."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "kitsuneudon"
	trash = /obj/item/trash/asian_bowl
	bitesize = 2
	nutriment_amt = 6
	nutriment_desc = list("savory daishi broth" = 6)

/obj/item/reagent_containers/food/snacks/generalschicken
	name = "general's chicken"
	desc = "Sweet, spicy, and fried. General's Chicken has been around for more than five-hundred years now, and still tastes good."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "generaltso"
	trash = /obj/item/trash/asian_bowl
	bitesize = 2
	nutriment_amt = 6
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet and spicy sauce" = 6),
		SPECIES_TESHARI      = list("spicy, somewhat bitter sauce" = 6)
	)

/obj/item/reagent_containers/food/snacks/generalschicken/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("fried chicken" = 4)))

/obj/item/reagent_containers/food/snacks/mammi
	name = "mämmi"
	desc = "Traditional finnish desert, some like it, others don't. It's drifting in some milk, add sugar!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "mammi"
	trash = /obj/item/trash/plate
	bitesize = 3
	nutriment_amt = 8
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet rye pudding" = 3, "orange zest" = 3, "milk" = 2),
		SPECIES_TESHARI      = list("rye pudding" = 3, "orange zest" = 3, "milk" = 2, "mild bitterness" = 1)
	)
	nutriment_allergens = ALLERGEN_DAIRY|ALLERGEN_FRUIT|ALLERGEN_GRAINS

/obj/item/reagent_containers/food/snacks/lobster
	name = "raw lobster"
	desc = "A shifty lobster. You can try eating it, but its shell is extremely tough."
	icon = 'icons/obj/food_syn.dmi'
	bitesize = 0.1
	icon_state = "lobster_raw"
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_FISH

/obj/item/reagent_containers/food/snacks/lobstercooked
	name = "cooked lobster"
	desc = "A luxurious plate of cooked lobster, its taste accentuated by lemon juice. Reinvigorating!"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "lobster_cooked"
	trash = /obj/item/trash/plate
	nutriment_amt = 20
	bitesize = 5
	nutriment_desc = list("lemon" = 5, "salad" = 5)
	nutriment_allergens = ALLERGEN_FISH|ALLERGEN_FRUIT

/obj/item/reagent_containers/food/snacks/lobstercooked/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 20, TASTE_DATA(list("lobster meat" = 20)))
	reagents.add_reagent("tricordrazine", 5)
	reagents.add_reagent("iron", 5)

/obj/item/reagent_containers/food/snacks/cuttlefish
	name = "raw cuttlefish"
	desc = "It's an adorable squid! You couldn't possibly be thinking about eating this, right?"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "cuttlefish_raw"
	bitesize = 10
	nutriment_amt = 5
	nutriment_allergens = ALLERGEN_FISH

/obj/item/reagent_containers/food/snacks/cuttlefishcooked
	name = "cooked cuttlefish"
	desc = "It's a roasted cuttlefish. Rubbery, squishy, an acquired taste."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "cuttlefish_cooked"
	bitesize = 5
	nutriment_amt = 15
	nutriment_desc = list("rubber" = 5, "grease" = 1)
	nutriment_allergens = ALLERGEN_FISH

/obj/item/reagent_containers/food/snacks/cuttlefishcooked/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 15, TASTE_DATA(list("cuttlefish meat" = 15)))

/obj/item/reagent_containers/food/snacks/sliceable/monkfish
	name = "extra large monkfish"
	desc = "It's a huge monkfish. Better clean it first, you can't possibly eat it like this."
	icon = 'icons/obj/food48x48.dmi'
	icon_state = "monkfish_raw"
	bitesize = 2
	nutriment_amt = 30
	w_class = ITEMSIZE_HUGE //Is that a monkfish in your pocket, or are you just happy to see me?
	slice_path = /obj/item/reagent_containers/food/snacks/monkfishfillet
	slices_num = 6
	trash = /obj/item/reagent_containers/food/snacks/sliceable/monkfishremains
	nutriment_allergens = ALLERGEN_FISH

/obj/item/reagent_containers/food/snacks/monkfishfillet
	name = "monkfish fillet"
	desc = "It's a fillet sliced from a monkfish."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "monkfish_fillet"
	bitesize = 3
	nutriment_allergens = ALLERGEN_FISH

/obj/item/reagent_containers/food/snacks/monkfishfillet/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 5, TASTE_DATA(list("monkfish meat" = 5)))

/obj/item/reagent_containers/food/snacks/monkfishcooked
	name = "seasoned monkfish"
	desc = "A delicious slice of monkfish prepared with sweet chili and spring onion."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "monkfish_cooked"
	bitesize = 4
	nutriment_amt = 10
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("oil" = 1, "sweet chili" = 3, "spring onion" = 2),
		SPECIES_TESHARI      = list("oil" = 1, "chili" = 3, "spring onion" = 2)
	)
	nutriment_allergens = ALLERGEN_FISH

/obj/item/reagent_containers/food/snacks/monkfishcooked/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 8, TASTE_DATA(list("monkfish meat" = 8)))

/obj/item/reagent_containers/food/snacks/sliceable/monkfishremains
	name = "monkfish remains"
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "monkfish_remains"
	desc = "The work of a madman."
	w_class = ITEMSIZE_LARGE
	bitesize = 0.01 //impossible to eat
	nutriment_amt = 10
	slice_path = /obj/item/clothing/head/fish
	slices_num = 1
	nutriment_allergens = ALLERGEN_FISH

/obj/item/reagent_containers/food/snacks/sliceable/monkfishremains/Initialize()
	. = ..()
	reagents.add_reagent("carbon", 5)

/obj/item/reagent_containers/food/snacks/sliceable/sharkchunk
	name = "chunk of shark meat"
	desc = "Still rough, needs to be cut into even smaller chunks."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "sharkmeat_chunk"
	bitesize = 3
	w_class = ITEMSIZE_LARGE
	slice_path = /obj/item/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	slices_num = 5
	nutriment_allergens = ALLERGEN_FISH

/obj/item/reagent_containers/food/snacks/sliceable/sharkchunk/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 35, TASTE_DATA(list("shark meat" = 20)))

/obj/item/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	name = "slice of sharkmeat"
	desc = "Now it's small enough to cook with."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "sharkmeat"
	bitesize = 3
	nutriment_amt = 2
	toxin_amount = null

/obj/item/reagent_containers/food/snacks/carpmeat/fish/sharkmeat/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 2, TASTE_DATA(list("shark meat" = 20)))

/obj/item/reagent_containers/food/snacks/sharkmeatcooked
	name = "shark steak"
	desc = "Finally, some food for real men."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "sharkmeat_cooked"
	trash = /obj/item/trash/small_bowl
	bitesize = 3
	nutriment_amt = 5
	trash = /obj/item/trash/plate
	nutriment_desc = list("manliness" = 1, "fish oil" = 2)

/obj/item/reagent_containers/food/snacks/sharkmeatcooked/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 10, TASTE_DATA(list("shark meat" = 10)))

/obj/item/reagent_containers/food/snacks/sharkmeatdip
	name = "hot shark shank"
	desc = "A shank of shark meat dipped in hot sauce."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "sharkmeat_dip"
	bitesize = 3
	nutriment_amt = 5
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("salt" = 1, "fish oil" = 2)

/obj/item/reagent_containers/food/snacks/sharkmeatdip/Initialize()
	. = ..()
	reagents.add_reagent("capsaicin", 4)
	reagents.add_reagent("seafood", 6, TASTE_DATA(list("spiced shark meat" = 6)))

/obj/item/reagent_containers/food/snacks/sharkmeatcubes
	name = "shark cubes"
	desc = "Foul scented fermented shark cubes, it's said to make men fly, or just make them really fat."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "sharkmeat_cubes"
	bitesize = 10
	nutriment_amt = 8
	trash = /obj/item/trash/plate
	nutriment_desc = list("viking spirit" = 1, "rot" = 2, "fermented sauce" = 2)

/obj/item/reagent_containers/food/snacks/sharkmeatcubes/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 30, TASTE_DATA(list("rotting fish" = 30))) // for people who want to get fat, FAST.

/obj/item/reagent_containers/food/snacks/dynsoup
	name = "dyn soup"
	desc = "An imported skrellian recipe, with certain substitions for ingredients not commonly available outside of Skrellian space."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "dynsoup"
	bitesize = 5
	nutriment_amt = 10
	nutriment_desc = list("peppermint" = 2, "leafy greens" = 4, "umami broth" = 2)
	nutriment_allergens = ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/dynsoup/Initialize()
	. = ..()
	reagents.add_reagent("water", 5)
	reagents.add_reagent("dynjuice", 4)
	reagents.add_reagent("tomatojuice", 2)

/obj/item/reagent_containers/food/snacks/zantiri
	name = "zantiri"
	desc = "A soupy mush comprised of guami and eki, two plants native to Qerr'balak. In a bowl, it looks not unlike staring into a starry sky."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "zantiri"
	bitesize = 5
	nutriment_amt = 15
	nutriment_desc = list("inky mush" = 5, "crunchy lichen" = 4)
	nutriment_allergens = ALLERGEN_VEGETABLE

/obj/item/reagent_containers/food/snacks/zantiri/Initialize()
	. = ..()
	reagents.add_reagent("water", 6)

/obj/item/reagent_containers/food/snacks/stew/neaera
	name = "neaera stew"
	desc = "Neaera meat stewed in a mixture of water and dyn juice, garnished with guami and eki. Often cooked in large batches to feed many teshari pack members."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "neaera_stew"
	filling_color = "#7C66DD"
	nutriment_amt = 6
	nutriment_desc = list("meaty mushroom", "crunchy lichen" = 6, "peppermint" = 6)
	nutriment_allergens = ALLERGEN_VEGETABLE|ALLERGEN_FUNGI|ALLERGEN_MEAT

/obj/item/reagent_containers/food/snacks/stew/neaera/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 6, TASTE_DATA(list("fatty meat" = 6)))
	reagents.add_reagent("dynjuice", 4)

/obj/item/reagent_containers/food/snacks/chipplate/neaeracandy
	name = "plate of jellied neaera eyes"
	desc = "Jellied neaera eyes shaped into cubes. The mix of savoury and creamy is generally acceptable for most species, although many dislike the dish for its texture and habit of making eye contact during the meal."
	icon_state = "neaera_candied_eyes20"
	trash = /obj/item/trash/candybowl
	vendingobject = /obj/item/reagent_containers/food/snacks/neaeracandy
	nutriment_desc = list("savoury goo" = 2)
	bitesize = 1
	unitname = "eye"
	filling_color = "#7C66DD"

/obj/item/reagent_containers/food/snacks/chipplate/neaeracandy/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 20, TASTE_DATA(list("creamy, fatty meat" = 20)))

/obj/item/reagent_containers/food/snacks/chipplate/neaeracandy/update_icon()
	switch(reagents.total_volume)
		if(1)
			icon_state = "neaera_candied_eyes1"
		if(2 to 5)
			icon_state = "neaera_candied_eyes5"
		if(6 to 10)
			icon_state = "neaera_candied_eyes10"
		if(11 to 15)
			icon_state = "neaera_candied_eyes15"
		if(20 to INFINITY)
			icon_state = "neaera_candied_eyes20"

/obj/item/reagent_containers/food/snacks/neaeracandy
	name = "jellied neaera eye"
	desc = "A jellied cube made from neaera eyes. The mix of savoury and creamy is generally acceptable for most species, although many dislike the dish for its texture and habit of making eye contact during the meal."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "neaera_candied_eye"
	bitesize = 2
	filling_color = "#7C66DD"

/obj/item/reagent_containers/food/snacks/neaeracandy/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 3, TASTE_DATA(list("creamy, fatty meat" = 3)))

/obj/item/reagent_containers/food/snacks/neaerakabob
	name = "neaera-kabob"
	desc = "Neaera meat and giblets that have been cooked on a skewer."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "neaera_skewer"
	trash = /obj/item/stack/rods
	filling_color = "#7C66DD"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/neaerakabob/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 4, TASTE_DATA(list("fatty meat" = 2)))

/obj/item/reagent_containers/food/snacks/lortl
	name = "lortl"
	desc = "Dehydrated and salted q'lort slices, a very common Skrellian snack."
	icon = 'icons/obj/hydroponics_misc.dmi'
	filling_color = "#B7D6BF"
	bitesize = 2
	nutriment_amt = 2
	nutriment_desc = list("dried fruit" = 2)
	nutriment_allergens = ALLERGEN_FRUIT

/obj/item/reagent_containers/food/snacks/lortl/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 2)
	if(!fruit_icon_cache["rind-#B1E4BE"])
		var/image/I = image(icon,"fruit_rind")
		I.color = "#B1E4BE"
		fruit_icon_cache["rind-#B1E4BE"] = I
	add_overlay(fruit_icon_cache["rind-#B1E4BE"])
	if(!fruit_icon_cache["slice-#B1E4BE"])
		var/image/I = image(icon,"fruit_slice")
		I.color = "#9FE4B0"
		fruit_icon_cache["slice-#B1E4BE"] = I
	add_overlay(fruit_icon_cache["slice-#B1E4BE"])

/obj/item/reagent_containers/food/snacks/qalozynboiled
	name = "boiled qa'lozyn"
	desc = "A Qerr'balakian vegetable. Poisonous raw, but rendered edible by boiling."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "qalozyn_boiled"
	nutriment_amt = 4
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet turnips" = 4),
		SPECIES_TESHARI      = list("turnips" = 2, "mild bitterness" = 2)
	)
	nutriment_allergens = ALLERGEN_VEGETABLE
	bitesize = 2
	filling_color = "#7C66DD"

/obj/item/reagent_containers/food/snacks/garani
	name = "garani"
	icon = 'icons/obj/food_syn.dmi'
	desc = "Neaera liver stuffed with boiled qa'lozyn and fried in oil. A popular light meal for teshari."
	icon_state = "garani"
	nutriment_amt = 4
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet turnips" = 4),
		SPECIES_TESHARI      = list("turnips" = 2, "mild bitterness" = 2)
	)
	nutriment_allergens = ALLERGEN_FRUIT
	bitesize = 3
	filling_color = "#7C66DD"

/obj/item/reagent_containers/food/snacks/garani/Initialize()
	. = ..()
	reagents.add_reagent("seafood", 4, TASTE_DATA(list("fatty meat" = 4)))

/obj/item/reagent_containers/food/snacks/qazal_dough
	name = "qa'zal dough"
	icon = 'icons/obj/food_syn.dmi'
	desc = "A coarse, stretchy, skrellian dough made from qa'zal flour and ga'uli juice in a striking purple color."
	icon_state = "qazal_dough"
	bitesize = 2
	nutriment_amt = 3
	nutriment_desc = list("minty dough" = 3)
	nutriment_allergens = ALLERGEN_FRUIT //It's not a grain. Skrell might not even HAVE grains for all we know!
	filling_color = "#B97BD9"

/obj/item/reagent_containers/food/snacks/qazal_dough/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/kitchen/rollingpin))
		new /obj/item/reagent_containers/food/snacks/sliceable/qazal_flatdough(src)
		to_chat(user, "You flatten the dough.")
		qdel(src)

/obj/item/reagent_containers/food/snacks/sliceable/qazal_flatdough
	name = "flattened qa'zal dough"
	icon = 'icons/obj/food_syn.dmi'
	desc = "A flattened, stretchy purple dough"
	icon_state = "flat_qazal_dough"
	bitesize = 2
	nutriment_amt = 3
	nutriment_desc = list("minty dough" = 3)
	nutriment_allergens = ALLERGEN_FRUIT
	slice_path = /obj/item/reagent_containers/food/snacks/qazal_doughstrip
	slices_num = 3
	filling_color = "#B97BD9"

/obj/item/reagent_containers/food/snacks/qazal_doughstrip
	name = "qa'zal dough strip"
	icon = 'icons/obj/food_syn.dmi'
	desc = "Thick-cut segments of qa'zal dough formed into what resembles a chewy, purple pasta."
	icon_state = "qazal_pasta"
	bitesize = 2
	nutriment_amt = 3
	nutriment_desc = list("minty pasta" = 1)
	nutriment_allergens = ALLERGEN_FRUIT
	filling_color = "#B97BD9"

/obj/item/reagent_containers/food/snacks/sliceable/qazal_bread
	name = "qa'zal bread"
	icon = 'icons/obj/food_syn.dmi'
	desc = "A loaf of soft qa'zal bread in a striking dark purple color, ready to be cut into slices. It's surprisingly stretchy, and smells quite minty."
	icon_state = "qazal_loaf"
	nutriment_amt = 20
	slices_num = 5
	nutriment_desc = list("minty bread" = 5)
	nutriment_allergens = ALLERGEN_FRUIT
	slice_path = /obj/item/reagent_containers/food/snacks/slice/qazal_bread_slice
	filling_color = "#B97BD9"

/obj/item/reagent_containers/food/snacks/slice/qazal_bread_slice
	name = "qa'zal bread slice"
	icon = 'icons/obj/food_syn.dmi'
	desc = "A slice of stretchy qa'zal bread."
	icon_state = "qazal_bread_slice"
	whole_path = /obj/item/reagent_containers/food/snacks/sliceable/qazal_bread
	nutriment_desc = list("minty bread" = 1)
	nutriment_allergens = ALLERGEN_FRUIT
	filling_color = "#B97BD9"

/obj/item/reagent_containers/food/snacks/slice/qazal_bread_slice/filled
	filled = TRUE

/obj/item/reagent_containers/food/snacks/grilled_qazal_flatbread
	name = "grilled qa'zal flatbread"
	desc = "Crispy, grilled qa'zal flatbread. No longer as stretchy, but it smells absolutely amazing."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "grilled_qazal_flatbread"
	nutriment_amt = 8
	bitesize = 1
	nutriment_desc = list("minty flatbread" = 1)
	nutriment_allergens = ALLERGEN_FRUIT
	filling_color = "#B97BD9"

/obj/item/reagent_containers/food/snacks/baked_gauli
	name = "baked ga'uli"
	icon = 'icons/obj/food_syn.dmi'
	desc = "A ga'uli pod baked in an oven, causing the minty liquid inside to condense and the exterior to soften, giving the vegetable a hard-boiled egg consistency. Remarkably tasty and healthy!"
	icon_state = "baked_gauli"
	nutriment_amt = 4
	nutriment_desc = list("zesty mintyness" = 1)
	nutriment_allergens = ALLERGEN_FRUIT
	filling_color = "#B97BD9"

/obj/item/reagent_containers/food/snacks/baked_kirani
	name = "baked kirani"
	icon = 'icons/obj/food_syn.dmi'
	desc = "A kirani fruit baked in an oven, causing the jelly inside to caramelize into a jelly donut-like crispy treat."
	icon_state = "baked_kirani"
	nutriment_amt = 4
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("crispy sweetness" = 2, "caramelized jelly" = 2),
		SPECIES_TESHARI      = list("crispy richness" = 2, "caramelized jelly" = 2)
	)
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_SUGARS
	filling_color = "#993C5C"

/obj/item/reagent_containers/food/snacks/stuffed_gauli
	name = "stuffed ga'uli pod"
	desc = "A cooked ga'uli pod, stuffed with meat and minced kirani fruit."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "stuffed_gauli_pod"
	nutriment_amt = 4
	nutriment_allergens = ALLERGEN_FRUIT
	bitesize = 1
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("sweet kirani" = 2, "minty ga'uli" = 2),
		SPECIES_TESHARI      = list("rich kirani" = 2, "minty ga'uli" = 2)
	)

/obj/item/reagent_containers/food/snacks/stuffed_gauli/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("steamed meat" = 4)))

/obj/item/reagent_containers/food/snacks/kirani_stew
	name = "kirani stew"
	desc = "Meat mixed with finely sliced qa'zal, drizzled in kirani jelly sauce, just the perfect balance of savory and sweet."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "kirani_stew"
	nutriment_amt = 8
	trash = /obj/item/trash/snack_bowl
	bitesize = 1
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_SUGARS
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("minty qa'zal" = 2, "sweet kirani jelly" = 2),
		SPECIES_TESHARI      = list("minty qa'zal" = 2, "rich kirani jelly" = 2)
	)

/obj/item/reagent_containers/food/snacks/kirani_stew/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4, TASTE_DATA(list("stewed meat" = 4)))

/obj/item/reagent_containers/food/snacks/qazal_noodles
	name = "qa'zal noodles"
	desc = "Qa'zal pasta mixed in a bowl with chopped kirani fruit and gu'ali pods. It looks bizarre and seems kind of slimy, but the taste cannot be denied."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "qazal_noodles"
	trash = /obj/item/trash/snack_bowl
	nutriment_amt = 8
	bitesize = 1
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_SUGARS
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("chewy qa'zal noodles" = 1, "minty gu'ali juice" = 1, "sweet kirani jelly" = 1),
		SPECIES_TESHARI      = list("chewy qa'zal noodles" = 1, "minty gu'ali juice" = 1, "rich kirani jelly" = 1)
	)

/obj/item/reagent_containers/food/snacks/kirani_jellypuff
	name = "kirani jellypuff"
	desc = "A piece of qa'zal bread containing a kirani jelly filling and sprinkled with qa'zal flour. Just one will never be enough."
	icon = 'icons/obj/food_syn.dmi'
	icon_state = "kirani_jellypuff"
	nutriment_allergens = ALLERGEN_FRUIT|ALLERGEN_SUGARS
	nutriment_amt = 8
	bitesize = 2
	nutriment_desc = list(
		TASTE_STRING_DEFAULT = list("puffed minty qa'zal bread" = 1, "super-sweet kirani jelly" = 1),
		SPECIES_TESHARI      = list("puffed minty qa'zal bread" = 1, "rich kirani jelly" = 1)
	)
