/* Toys!
 * Contains:
 *		Balloons
 *		Fake telebeacon
 *		Fake singularity
 *		Toy gun
 *		Toy swords
 *		Toy bosun's whistle
 *		Snap pops
 *		Water flower
 *      Therapy dolls
 *      Toddler doll
 *      Inflatable duck
 *		Action figures
 *		Plushies
 *		Toy cult sword
 *		Bouquets
 *		Stick Horse
 */


/obj/item/toy
	name = "generic toy"
	desc = "It's just for fun!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "glitched"
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0
	drop_sound = 'sound/items/drop/gloves.ogg'


/*
 * Balloons
 */
/obj/item/toy/waterballoon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon_state = "waterballoon-e"
	drop_sound = 'sound/items/drop/rubber.ogg'

/obj/item/toy/waterballoon/Initialize()
	. = ..()
	var/datum/reagents/R = new/datum/reagents(10)
	reagents = R
	R.my_atom = src

/obj/item/toy/waterballoon/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/waterballoon/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to_obj(src, 10)
		to_chat(user, "<span class='notice'>You fill the balloon with the contents of [A].</span>")
		src.desc = "A translucent balloon with some form of liquid sloshing around in it."
		src.update_icon()
	return

/obj/item/toy/waterballoon/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/glass))
		if(O.reagents)
			if(O.reagents.total_volume < 1)
				to_chat(user, "The [O] is empty.")
			else if(O.reagents.total_volume >= 1)
				if(O.reagents.has_reagent("pacid", 1))
					to_chat(user, "The acid chews through the balloon!")
					O.reagents.splash(user, reagents.total_volume)
					qdel(src)
				else
					src.desc = "A translucent balloon with some form of liquid sloshing around in it."
					to_chat(user, "<span class='notice'>You fill the balloon with the contents of [O].</span>")
					O.reagents.trans_to_obj(src, 10)
	src.update_icon()
	return

/obj/item/toy/waterballoon/throw_impact(atom/hit_atom)
	if(src.reagents.total_volume >= 1)
		src.visible_message("<span class='warning'>\The [src] bursts!</span>","You hear a pop and a splash.")
		src.reagents.touch_turf(get_turf(hit_atom))
		for(var/atom/A in get_turf(hit_atom))
			src.reagents.touch(A)
		src.icon_state = "burst"
		spawn(5)
			if(src)
				qdel(src)
	return

/obj/item/toy/waterballoon/update_icon()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
	else
		icon_state = "waterballoon-e"

//BLOONS

#define BALLOON_NORMAL	0
#define BALLOON_BLOW	1
#define BALLOON_BURST	2

/obj/item/toy/balloon /// To color it, VV the 'color' var with a hex color code with the # included.
	name = "balloon"
	desc = "It's a plain little balloon. Comes in many colors!"
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0
	icon_state = "colorballoon"
	w_class = ITEMSIZE_LARGE
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'
	var/datum/gas_mixture/air_contents = null
	var/status = 0 // 0 = normal, 1 = blow, 2 = burst

/obj/item/toy/balloon/attack_self(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(user.a_intent == I_HELP)
		user.visible_message("<span class='notice'><b>\The [user]</b> pokes [src]!</span>","<span class='notice'>You poke [src]!</span>")
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'><b>\The [user]</b> punches [src]!</span>","<span class='warning'>You punch [src]!</span>")
	else if (user.a_intent == I_GRAB)
		if(prob(66))
			user.visible_message("<span class='warning'><b>\The [user]</b> attempts to pop [src]!</span>","<span class='warning'>You attempt to pop [src]!</span>")
		else
			user.visible_message("<span class='warning'><b>\The [user]</b> pops [src]!</span>","<span class='warning'>You pop [src]!</span>")
			burst()
	else
		user.visible_message("<span class='notice'><b>\The [user]</b> lightly bats the [src].</span>","<span class='notice'>You lightly bat the [src].</span>")

/obj/item/toy/balloon/update_icon()
	switch(status)
		if(BALLOON_BURST)
			if(("[initial(icon_state)]_burst") in icon_states(icon))
				icon_state = "[initial(icon_state)]_burst"
				item_state = icon_state
			else
				qdel(src) // Just qdel it if it doesn't have a burst state.
		if(BALLOON_BLOW)
			if(("[initial(icon_state)]_blow") in icon_states(icon)) //Only give blow icon_state if it has one. For those who can't be bothered to sprite. (Also a catch to prevent invisible sprites.)
				icon_state = "[initial(icon_state)]_blow"
	update_held_icon()

/obj/item/toy/balloon/proc/blow(obj/item/tank/T)
	if(status == BALLOON_BURST)
		return
	else
		src.air_contents = T.remove_air_volume(3)
		status = BALLOON_BLOW
		update_icon()

/obj/item/toy/balloon/proc/burst()
	playsound(src, 'sound/weapons/Gunshot_old.ogg', 100, 1)
	status = BALLOON_BURST
	update_icon()
	if(air_contents)
		loc.assume_air(air_contents)

/obj/item/toy/balloon/ex_act(severity)
	burst()
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)

/obj/item/toy/balloon/bullet_act()
	burst()

/obj/item/toy/balloon/fire_act(datum/gas_mixture/air, temperature, volume)
	if(temperature > T0C+100)
		burst()
	return

/obj/item/toy/balloon/attackby(obj/item/W as obj, mob/user as mob)
	if(can_puncture(W))
		burst()

/obj/item/toy/balloon/random/Initialize()
	. = ..()
	color = pick(COLOR_BLUE, COLOR_RED, COLOR_PINK, COLOR_PURPLE, COLOR_GREEN, COLOR_CYAN, COLOR_SUN, COLOR_YELLOW)
	update_icon()
	randpixel_xy()

/obj/item/toy/balloon/syndicate
	name = "criminal balloon"
	desc = "There is a tag on the back that reads \"FUK NT!11!\"."
	icon_state = "syndballoon"

/obj/item/toy/balloon/nanotrasen
	name = "corporate balloon"
	desc = "Across the balloon the following is printed: \"Man, I love NanoTrasen soooo much. I use only NT products. You have NO idea.\""
	icon_state = "ntballoon"

/obj/item/toy/balloon/latex
	desc = "Leaves a starchy taste in your mouth after blowing into it."
	icon_state = "latexballoon"
	item_state = "latexballoon"

/obj/item/toy/balloon/nitrile
	desc = "I hope you aren't going to re-use these for medical purposes."
	icon_state = "nitrileballoon"
	item_state = "nitrileballoon"

#undef BALLOON_NORMAL
#undef BALLOON_BLOW
#undef BALLOON_BURST


/*
 * Fake telebeacon
 */
/obj/item/toy/blink
	name = "electronic blink toy game"
	desc = "Blink.  Blink.  Blink. Ages 8 and up."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	item_state = "signaler"

/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "gravitational singularity"
	desc = "\"Singulo\" brand spinning toy."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"

/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "toy sword"
	desc = "A cheap, plastic replica of an energy sword. Realistic sounds! Ages 8 and up."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "esword"
	drop_sound = 'sound/items/drop/gun.ogg'
	var/lcolor
	var/rainbow = FALSE
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
		)
	var/active = 0
	w_class = ITEMSIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")

/obj/item/toy/sword/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		to_chat(user, "<span class='notice'>You extend the plastic blade with a quick flick of your wrist.</span>")
		playsound(src, 'sound/weapons/saberon.ogg', 50, 1)
		src.item_state = "[icon_state]_blade"
		src.w_class = ITEMSIZE_LARGE
	else
		to_chat(user, "<span class='notice'>You push the plastic blade back down into the handle.</span>")
		playsound(src, 'sound/weapons/saberoff.ogg', 50, 1)
		src.item_state = "[icon_state]"
		src.w_class = ITEMSIZE_SMALL
	update_icon()
	src.add_fingerprint(user)
	return

/obj/item/toy/sword/update_icon()
	. = ..()
	var/mutable_appearance/blade_overlay = mutable_appearance(icon, "[icon_state]_blade")
	blade_overlay.color = lcolor
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(active)
		add_overlay(blade_overlay)
	if(istype(usr,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = usr
		H.update_inv_l_hand()
		H.update_inv_r_hand()

/obj/item/toy/sword/AltClick(mob/living/user)
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return

	if(alert("Are you sure you want to recolor your blade?", "Confirm Recolor", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"","Choose Energy Color",lcolor) as color|null
		if(energy_color_input)
			lcolor = sanitize_hexcolor(energy_color_input)
		update_icon()

/obj/item/toy/sword/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to recolor it.</span>"

/obj/item/toy/sword/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/multitool) && !active)
		if(!rainbow)
			rainbow = TRUE
		else
			rainbow = FALSE
		to_chat(user, "<span class='notice'>You manipulate the color controller in [src].</span>")
		update_icon()
/obj/item/toy/katana
	name = "replica katana"
	desc = "Woefully underpowered in D20."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "katana"
	item_state = "katana"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
		)
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 5
	throwforce = 5
	w_class = ITEMSIZE_NORMAL
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")

/*
 * Snap pops
 */
/obj/item/toy/snappop
	name = "snap pop"
	desc = "Wow!"
	icon_state = "snappop"
	w_class = ITEMSIZE_TINY
	drop_sound = null

/obj/item/toy/snappop/throw_impact(atom/hit_atom)
	..()
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	new /obj/effect/decal/cleanable/ash(src.loc)
	src.visible_message("<span class='warning'>The [src.name] explodes!</span>","<span class='warning'>You hear a snap!</span>")
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	qdel(src)

/obj/item/toy/snappop/Crossed(atom/movable/H as mob|obj)
	if(H.is_incorporeal())
		return
	if((ishuman(H))) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(IS_RUNNING(M))
			to_chat(M, "<span class='warning'>You step on the snap pop!</span>")

			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(2, 0, src)
			s.start()
			new /obj/effect/decal/cleanable/ash(src.loc)
			src.visible_message("<span class='warning'>The [src.name] explodes!</span>","<span class='warning'>You hear a snap!</span>")
			playsound(src, 'sound/effects/snap.ogg', 50, 1)
			qdel(src)

/*
 * Bosun's whistle
 */

/obj/item/toy/bosunwhistle
	name = "bosun's whistle"
	desc = "A genuine Admiral Krush Bosun's Whistle, for the aspiring ship's captain! Suitable for ages 8 and up, do not swallow."
	icon_state = "bosunwhistle"
	drop_sound = 'sound/items/drop/card.ogg'
	var/cooldown = 0
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS | SLOT_HOLSTER

/obj/item/toy/bosunwhistle/attack_self(mob/user as mob)
	if(cooldown < world.time - 35)
		to_chat(user, "<span class='notice'>You blow on [src], creating an ear-splitting noise!</span>")
		playsound(src, 'sound/misc/boatswain.ogg', 20, 1)
		cooldown = world.time

/*
 * Action figures
 */
/obj/item/toy/figure
	name = "Non-Specific Action Figure action figure"
	desc = "A \"Space Life\" brand... wait, what the hell is this thing?"
	icon_state = "nuketoy"
	w_class = ITEMSIZE_TINY
	var/cooldown = 0
	var/toysay = "What the fuck did you do?"
	drop_sound = 'sound/items/drop/accessory.ogg'

/obj/item/toy/figure/Initialize()
	. = ..()
	desc = "A \"Space Life\" brand [name]"

/obj/item/toy/figure/attack_self(mob/user as mob)
	if(cooldown < world.time)
		cooldown = (world.time + 30) //3 second cooldown
		user.visible_message("<span class='notice'>The [src] says \"[toysay]\".</span>")
		playsound(src, 'sound/machines/click.ogg', 20, 1)

/obj/item/toy/figure/cmo
	name = "Chief Medical Officer action figure"
	desc = "A \"Space Life\" brand Chief Medical Officer action figure."
	icon_state = "cmo"
	toysay = "Suit sensors!"

/obj/item/toy/figure/assistant
	name = "Assistant action figure"
	desc = "A \"Space Life\" brand Assistant action figure."
	icon_state = "assistant"
	toysay = "Grey tide station wide!"

/obj/item/toy/figure/atmos
	name = "Atmospheric Technician action figure"
	desc = "A \"Space Life\" brand Atmospheric Technician action figure."
	icon_state = "atmos"
	toysay = "Glory to Atmosia!"

/obj/item/toy/figure/bartender
	name = "Bartender action figure"
	desc = "A \"Space Life\" brand Bartender action figure."
	icon_state = "bartender"
	toysay = "Where's my monkey?"

/obj/item/toy/figure/borg
	name = "Drone action figure"
	desc = "A \"Space Life\" brand Drone action figure."
	icon_state = "borg"
	toysay = "I. LIVE. AGAIN."

/obj/item/toy/figure/gardener
	name = "Gardener action figure"
	desc = "A \"Space Life\" brand Gardener action figure."
	icon_state = "botanist"
	toysay = "Dude, I see colors..."

/obj/item/toy/figure/captain
	name = "Site Manager action figure"
	desc = "A \"Space Life\" brand Site Manager action figure."
	icon_state = "captain"
	toysay = "How do I open this display case?"

/obj/item/toy/figure/cargotech
	name = "Cargo Technician action figure"
	desc = "A \"Space Life\" brand Cargo Technician action figure."
	icon_state = "cargotech"
	toysay = "For Cargonia!"

/obj/item/toy/figure/ce
	name = "Chief Engineer action figure"
	desc = "A \"Space Life\" brand Chief Engineer action figure."
	icon_state = "ce"
	toysay = "Wire the solars!"

/obj/item/toy/figure/chaplain
	name = "Chaplain action figure"
	desc = "A \"Space Life\" brand Chaplain action figure."
	icon_state = "chaplain"
	toysay = "Gods make me a killing machine please!"

/obj/item/toy/figure/chef
	name = "Chef action figure"
	desc = "A \"Space Life\" brand Chef action figure."
	icon_state = "chef"
	toysay = "I swear it's not human meat."

/obj/item/toy/figure/chemist
	name = "Chemist action figure"
	desc = "A \"Space Life\" brand Chemist action figure."
	icon_state = "chemist"
	toysay = "Get your pills!"

/obj/item/toy/figure/clown
	name = "Clown action figure"
	desc = "A \"Space Life\" brand Clown action figure."
	icon_state = "clown"
	toysay = "<font face='comic sans ms'><b>Honk!</b></font>"

/obj/item/toy/figure/corgi
	name = "Corgi action figure"
	desc = "A \"Space Life\" brand Corgi action figure."
	icon_state = "ian"
	toysay = "Arf!"

/obj/item/toy/figure/detective
	name = "Detective action figure"
	desc = "A \"Space Life\" brand Detective action figure."
	icon_state = "detective"
	toysay = "This airlock has grey jumpsuit and insulated glove fibers on it."

/obj/item/toy/figure/dsquad
	name = "Space Commando action figure"
	desc = "A \"Space Life\" brand Space Commando action figure."
	icon_state = "dsquad"
	toysay = "Eliminate all threats!"

/obj/item/toy/figure/engineer
	name = "Engineer action figure"
	desc = "A \"Space Life\" brand Engineer action figure."
	icon_state = "engineer"
	toysay = "Oh god, the engine is gonna go!"

/obj/item/toy/figure/geneticist
	name = "Geneticist action figure"
	desc = "A \"Space Life\" brand Geneticist action figure, which was recently dicontinued."
	icon_state = "geneticist"
	toysay = "I'm not qualified for this job."

/obj/item/toy/figure/hop
	name = "Head of Personnel action figure"
	desc = "A \"Space Life\" brand Head of Personnel action figure."
	icon_state = "hop"
	toysay = "Giving out all access!"

/obj/item/toy/figure/hos
	name = "Head of Security action figure"
	desc = "A \"Space Life\" brand Head of Security action figure."
	icon_state = "hos"
	toysay = "I'm here to win, anything else is secondary."

/obj/item/toy/figure/qm
	name = "Quartermaster action figure"
	desc = "A \"Space Life\" brand Quartermaster action figure."
	icon_state = "qm"
	toysay = "Hail Cargonia!"

/obj/item/toy/figure/janitor
	name = "Janitor action figure"
	desc = "A \"Space Life\" brand Janitor action figure."
	icon_state = "janitor"
	toysay = "Look at the signs, you idiot."

/obj/item/toy/figure/agent
	name = "Internal Affairs Agent action figure"
	desc = "A \"Space Life\" brand Internal Affairs Agent action figure."
	icon_state = "agent"
	toysay = "Standard Operating Procedure says they're guilty! Hacking is proof they're an Enemy of the Corporation!"

/obj/item/toy/figure/librarian
	name = "Librarian action figure"
	desc = "A \"Space Life\" brand Librarian action figure."
	icon_state = "librarian"
	toysay = "One day while..."

/obj/item/toy/figure/md
	name = "Medical Doctor action figure"
	desc = "A \"Space Life\" brand Medical Doctor action figure."
	icon_state = "md"
	toysay = "The patient is already dead!"

/obj/item/toy/figure/mime
	name = "Mime action figure"
	desc = "A \"Space Life\" brand Mime action figure."
	icon_state = "mime"
	toysay = "..."

/obj/item/toy/figure/miner
	name = "Shaft Miner action figure"
	desc = "A \"Space Life\" brand Shaft Miner action figure."
	icon_state = "miner"
	toysay = "Oh god, it's eating my intestines!"

/obj/item/toy/figure/ninja
	name = "Space Ninja action figure"
	desc = "A \"Space Life\" brand Space Ninja action figure."
	icon_state = "ninja"
	toysay = "Oh god! Stop shooting, I'm friendly!"

/obj/item/toy/figure/wizard
	name = "Wizard action figure"
	desc = "A \"Space Life\" brand Wizard action figure."
	icon_state = "wizard"
	toysay = "Ei Nath!"

/obj/item/toy/figure/rd
	name = "Research Director action figure"
	desc = "A \"Space Life\" brand Research Director action figure."
	icon_state = "rd"
	toysay = "Blowing all of the borgs!"

/obj/item/toy/figure/roboticist
	name = "Roboticist action figure"
	desc = "A \"Space Life\" brand Roboticist action figure."
	icon_state = "roboticist"
	toysay = "He asked to be borged!"

/obj/item/toy/figure/scientist
	name = "Scientist action figure"
	desc = "A \"Space Life\" brand Scientist action figure."
	icon_state = "scientist"
	toysay = "Someone else must have made those bombs!"

/obj/item/toy/figure/syndie
	name = "Doom Operative action figure"
	desc = "A \"Space Life\" brand Doom Operative action figure."
	icon_state = "syndie"
	toysay = "Get that fucking disk!"

/obj/item/toy/figure/secofficer
	name = "Security Officer action figure"
	desc = "A \"Space Life\" brand Security Officer action figure."
	icon_state = "secofficer"
	toysay = "I am the law!"

/obj/item/toy/figure/virologist
	name = "Virologist action figure"
	desc = "A \"Space Life\" brand Virologist action figure."
	icon_state = "virologist"
	toysay = "The cure is potassium!"

/obj/item/toy/figure/warden
	name = "Warden action figure"
	desc = "A \"Space Life\" brand Warden action figure."
	icon_state = "warden"
	toysay = "Execute him for breaking in!"

/obj/item/toy/figure/psychologist
	name = "Psychologist action figure"
	desc = "A \"Space Life\" brand Psychologist action figure."
	icon_state = "psychologist"
	toysay = "The analyzer says you're fine!"

/obj/item/toy/figure/paramedic
	name = "Paramedic action figure"
	desc = "A \"Space Life\" brand Paramedic action figure."
	icon_state = "paramedic"
	toysay = "WHERE ARE YOU??"

/obj/item/toy/figure/ert
	name = "Emergency Response Team Commander action figure"
	desc = "A \"Space Life\" brand Emergency Response Team Commander action figure."
	icon_state = "ert"
	toysay = "We're probably the good guys!"


// Eris
/obj/item/toy/figure/un
	name = "UN soldier figurine"
	desc = "A FunFig 'History's Heroes and Curios' branded figurine of a United Nations soldier, adorned in their iconic 22nd century armor. There is still a price tag on the back of the base, six-hundred credits, people collect these things?"
	icon_state = "unitednations"
	toysay = "For unity!"

/obj/item/toy/figure/selene
	name = "Selene Federation figurine"
	desc = "A FunFig 'History's Heroes and Curios' branded figurine, the basic olive drab a popular pick for many in the Selene Federation's rag-tag colonial militia. Farming accessories not included."
	icon_state = "selene"
	toysay = "We will not be shackled by Earth!"

/obj/item/toy/figure/nock
	name = "Nock acolyte figurine"
	desc = "A FunFig 'Horrors Beyond' branded figurine, depicting a follower of the oft-maligned Nock religion. The sinister design doesn't do much to challenge perceptions of the group as a 'blood cult'."
	icon_state = "acolyte"
	toysay = "Praise the Outworlders, and be born anew!"

/obj/item/toy/figure/carrion
	name = "carrion figurine"
	desc = "A FunFig 'Horrors Beyond' branded figurine depicting a grotesque head of flesh, the Human features seem almost underdeveloped, its skull bulging outwards, mouth agape with torn flesh. \
	Whoever made this certainly knew how to thin their paints."
	icon_state = "carrion"
	toysay = "Kill me!"

/obj/item/toy/figure/zaddat
	name = "Zaddat figurine"
	desc = "A 'History's Heroes and Curios' branded figurine which attempts to depict a Zaddat prior to their species' genetic degradation and confinement to suits. It doesn't seem all that accurate."
	icon_state = "zaddat"
	toysay = "Recycle!"

/obj/item/toy/figure/discovery
	name = "Galactic Survey figurine"
	desc = "A FunFig 'Discovery' branded figurine showcasing a member of the Galactic Survey Administration, wearing the typical safety-orange uniform of the branch."
	icon_state = "discovery"
	toysay = "No star is too far!"

/obj/item/toy/figure/rooster
	name = "rooster figurine"
	desc = "A \"Space Vice\" brand figurine, there is no further manufacturer information. It's a man wearing a rooster mask, and a varsity jacket with the letter \"B\" emblazoned on the front."
	icon_state = "rooster"
	toysay = "Do you like hurting other people?"

/obj/item/toy/figure/barking_dog
	name = "barking dog figurine"
	desc = "A FunFig 'Movie Madness IX'. A metal soldier with the mask of a hound stands upon the base, the plaque seems smeared with caked grime."
	icon_state = "barking_dog"
	toysay = "A dog barks on its master's orders, lest its pack runs astray. Whatever the task, the grim dog mask would tell you that your life was done."

/obj/item/toy/figure/red_soldier
	name = "red soldier figurine"
	desc = "A curiously unbranded, cheap looking figurine of a red soldier fighting in the tides of war, their humanity hidden by a gas mask."
	icon_state = "red_soldier"
	toysay = "Why do we fight? To win the war, of course."

/obj/item/toy/figure/tajaran
	name = "Tajaran pioneer figurine"
	desc = "A FunFig 'History's Heroes and Curios' branded figurine depicting a Tajaran in a rudimentary voidsuit typical of early space exploration efforts by the species."
	icon_state = "tajaran"
	toysay = "Meow!"

/obj/item/toy/figure/shitcurity
	name = "NanoTrasen officer figurine"
	desc = "A figurine of a classic redshirt of 'Nanotrasen's finest' apparently produced by Hedberg-Hammarstrom. Their belly distends out into an obvious beer gut, revealing no form of manufacturer bias what-so-ever."
	icon_state = "shitcurity"
	toysay = "I joined just to kill people!"

/obj/item/toy/figure/vir_patrolman
	name = "SifGuard patrolman figurine"
	desc = "A figurine depicting a sharply dressed SifGuard law enforcement patrolman with the acronym 'VGA' on their left shoulder and cap. Apparently produced by Hedberg-Hammarstrom."
	icon_state = "vir_patrolman"
	toysay = "Trust in us to keep your family safe!"


/*
 * Plushies
 */

/*
 * Carp plushie
 */

/obj/item/toy/plushie/carp
	name = "space carp plushie"
	desc = "An adorable stuffed toy that resembles a space carp."
	icon_state = "basecarp"
	attack_verb = list("bitten", "eaten", "fin slapped")
	var/bitesound = 'sound/weapons/bite.ogg'

// Attack mob
/obj/item/toy/plushie/carp/attack(mob/M as mob, mob/user as mob)
	playsound(src, bitesound, 20, 1)	// Play bite sound in local area
	return ..()

// Attack self
/obj/item/toy/plushie/carp/attack_self(mob/user as mob)
	playsound(src, bitesound, 20, 1)
	return ..()


/obj/random/carp_plushie
	name = "Random Carp Plushie"
	desc = "This is a random plushie"
	icon = 'icons/obj/toy.dmi'
	icon_state = "basecarp"

/obj/random/carp_plushie/item_to_spawn()
	return pick(typesof(/obj/item/toy/plushie/carp)) //can pick any carp plushie, even the original.

/obj/item/toy/plushie/carp/ice
	name = "ice carp plushie"
	icon_state = "icecarp"

/obj/item/toy/plushie/carp/silent
	name = "monochrome carp plushie"
	icon_state = "silentcarp"

/obj/item/toy/plushie/carp/electric
	name = "electric carp plushie"
	icon_state = "electriccarp"

/obj/item/toy/plushie/carp/gold
	name = "golden carp plushie"
	icon_state = "goldcarp"

/obj/item/toy/plushie/carp/toxin
	name = "toxic carp plushie"
	icon_state = "toxincarp"

/obj/item/toy/plushie/carp/dragon
	name = "dragon carp plushie"
	icon_state = "dragoncarp"

/obj/item/toy/plushie/carp/pink
	name = "pink carp plushie"
	icon_state = "pinkcarp"

/obj/item/toy/plushie/carp/candy
	name = "candy carp plushie"
	icon_state = "candycarp"

/obj/item/toy/plushie/carp/nebula
	name = "nebula carp plushie"
	icon_state = "nebulacarp"

/obj/item/toy/plushie/carp/void
	name = "void carp plushie"
	icon_state = "voidcarp"

//Large plushies.
/obj/structure/plushie
	name = "generic plush"
	desc = "A very generic plushie. It seems to not want to exist."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ianplushie"
	anchored = 0
	density = 1
	var/phrase = "I don't want to exist anymore!"
	var/searching = FALSE
	var/opened = FALSE	// has this been slit open? this will allow you to store an object in a plushie.
	var/obj/item/stored_item	// Note: Stored items can't be bigger than the plushie itself.

/obj/structure/plushie/examine(mob/user)
	. = ..()
	if(opened)
		. += "<i>You notice an incision has been made on [src].</i>"
		if(in_range(user, src) && stored_item)
			. += "<i>You can see something in there...</i>"

/obj/structure/plushie/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(stored_item && opened && !searching)
		searching = TRUE
		if(do_after(user, 10))
			to_chat(user, "You find \icon[stored_item] [stored_item] in [src]!")
			stored_item.forceMove(get_turf(src))
			stored_item = null
			searching = FALSE
			return
		else
			searching = FALSE

	if(user.a_intent == I_HELP)
		user.visible_message("<span class='notice'><b>\The [user]</b> hugs [src]!</span>","<span class='notice'>You hug [src]!</span>")
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'><b>\The [user]</b> punches [src]!</span>","<span class='warning'>You punch [src]!</span>")
	else if (user.a_intent == I_GRAB)
		user.visible_message("<span class='warning'><b>\The [user]</b> attempts to strangle [src]!</span>","<span class='warning'>You attempt to strangle [src]!</span>")
	else
		user.visible_message("<span class='notice'><b>\The [user]</b> pokes the [src].</span>","<span class='notice'>You poke the [src].</span>")
		visible_message("[src] says, \"[phrase]\"")


/obj/structure/plushie/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/threadneedle) && opened)
		to_chat(user, "You sew the hole in [src].")
		opened = FALSE
		return

	if(is_sharp(I) && !opened)
		to_chat(user, "You open a small incision in [src]. You can place tiny items inside.")
		opened = TRUE
		return

	if(opened)
		if(stored_item)
			to_chat(user, "There is already something in here.")
			return

		if(!(I.w_class > w_class))
			to_chat(user, "You place [I] inside [src].")
			user.drop_from_inventory(I, src)
			I.forceMove(src)
			stored_item = I
			return
		else
			to_chat(user, "You open a small incision in [src]. You can place tiny items inside.")


	..()

/obj/structure/plushie/ian
	name = "plush corgi"
	desc = "A plushie of an adorable corgi! Don't you just want to hug it and squeeze it and call it \"Ian\"?"
	icon_state = "ianplushie"
	phrase = "Arf!"

/obj/structure/plushie/drone
	name = "plush drone"
	desc = "A plushie of a happy drone! It appears to be smiling."
	icon_state = "droneplushie"
	phrase = "Beep boop!"

/obj/structure/plushie/carp
	name = "plush carp"
	desc = "A plushie of an elated carp! Straight from the wilds of the Vir frontier, now right here in your hands."
	icon_state = "carpplushie"
	phrase = "Glorf!"

/obj/structure/plushie/beepsky
	name = "plush Officer Sweepsky"
	desc = "A plushie of a popular industrious cleaning robot! If it could feel emotions, it would love you."
	icon_state = "beepskyplushie"
	phrase = "Ping!"

//Small plushies.
/obj/item/toy/plushie
	name = "generic small plush"
	desc = "A small toy plushie. It's very cute."
	icon_state = "nymphplushie"
	drop_sound = 'sound/items/drop/plushie.ogg'
	w_class = ITEMSIZE_TINY
	var/last_message = 0
	var/pokephrase = "Uww!"
	var/searching = FALSE
	var/opened = FALSE	// has this been slit open? this will allow you to store an object in a plushie.
	var/obj/item/stored_item	// Note: Stored items can't be bigger than the plushie itself.


/obj/item/toy/plushie/examine(mob/user)
	. = ..()
	if(opened)
		. += "<i>You notice an incision has been made on [src].</i>"
		if(in_range(user, src) && stored_item)
			. += "<i>You can see something in there...</i>"

/obj/item/toy/plushie/attack_self(mob/user as mob)
	if(stored_item && opened && !searching)
		searching = TRUE
		if(do_after(user, 10))
			to_chat(user, "You find \icon[stored_item] [stored_item] in [src]!")
			stored_item.forceMove(get_turf(src))
			stored_item = null
			searching = FALSE
			return
		else
			searching = FALSE

	if(world.time - last_message <= 1 SECOND)
		return
	if(user.a_intent == I_HELP)
		user.visible_message("<span class='notice'><b>\The [user]</b> hugs [src]!</span>","<span class='notice'>You hug [src]!</span>")
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'><b>\The [user]</b> punches [src]!</span>","<span class='warning'>You punch [src]!</span>")
	else if (user.a_intent == I_GRAB)
		user.visible_message("<span class='warning'><b>\The [user]</b> attempts to strangle [src]!</span>","<span class='warning'>You attempt to strangle [src]!</span>")
	else
		user.visible_message("<span class='notice'><b>\The [user]</b> pokes [src].</span>","<span class='notice'>You poke [src].</span>")
		playsound(src, 'sound/items/drop/plushie.ogg', 25, 0)
		visible_message("[src] says, \"[pokephrase]\"")
	last_message = world.time

/obj/item/toy/plushie/verb/rename_plushie()
	set name = "Name Plushie"
	set category = "Object"
	set desc = "Give your plushie a cute name!"
	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input("What do you want to name the plushie?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the plushie [input], giving it a hug for good luck.")
		return 1

/obj/item/toy/plushie/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/toy/plushie) || istype(I, /obj/item/organ/external/head))
		user.visible_message("<span class='notice'>[user] makes \the [I] kiss \the [src]!.</span>", \
		"<span class='notice'>You make \the [I] kiss \the [src]!.</span>")
		return


	if(istype(I, /obj/item/threadneedle) && opened)
		to_chat(user, "You sew the hole underneath [src].")
		opened = FALSE
		return

	if(is_sharp(I) && !opened)
		to_chat(user, "You open a small incision in [src]. You can place tiny items inside.")
		opened = TRUE
		return

	if( (!(I.w_class > w_class)) && opened)
		if(stored_item)
			to_chat(user, "There is already something in here.")
			return

		to_chat(user, "You place [I] inside [src].")
		user.drop_from_inventory(I, src)
		I.forceMove(src)
		stored_item = I
		to_chat(user, "You placed [I] into [src].")
		return

	return ..()

/obj/item/toy/plushie/nymph
	name = "diona nymph plush"
	desc = "A plushie of an adorable diona nymph! While its level of self-awareness is still being debated, its level of cuteness is not."
	icon_state = "nymphplushie"
	pokephrase = "Chirp!"

/obj/item/toy/plushie/teshari
	name = "teshari plush"
	desc = "This is a plush teshari. Very soft, with a pompom on the tail. The toy is made well, as if alive. Looks like she is sleeping. Shhh!"
	icon_state = "teshariplushie"
	pokephrase = "Rya!"

/obj/item/toy/plushie/mouse
	name = "mouse plush"
	desc = "A plushie of a delightful mouse! What was once considered a vile rodent is now your very best friend."
	icon_state = "mouseplushie"
	pokephrase = "Squeak!"

/obj/item/toy/plushie/kitten
	name = "kitten plush"
	desc = "A plushie of a cute kitten! Watch as it purrs its way right into your heart."
	icon_state = "kittenplushie"
	pokephrase = "Mrow!"

/obj/item/toy/plushie/lizard
	name = "lizard plush"
	desc = "A plushie of a scaly lizard! Very controversial, after being accused as \"racist\" by some Unathi."
	icon_state = "lizardplushie"
	pokephrase = "Hiss!"

/obj/item/toy/plushie/spider
	name = "spider plush"
	desc = "A plushie of a fuzzy spider! It has eight legs - all the better to hug you with."
	icon_state = "spiderplushie"
	pokephrase = "Sksksk!"

/obj/item/toy/plushie/farwa
	name = "farwa plush"
	desc = "A farwa plush doll. It's soft and comforting!"
	icon_state = "farwaplushie"
	pokephrase = "Squaw!"

/obj/item/toy/plushie/corgi
	name = "corgi plushie"
	icon_state = "corgi"
	pokephrase = "Woof!"

/obj/item/toy/plushie/girly_corgi
	name = "corgi plushie"
	icon_state = "girlycorgi"
	pokephrase = "Arf!"

/obj/item/toy/plushie/robo_corgi
	name = "borgi plushie"
	icon_state = "robotcorgi"
	pokephrase = "Bark."

/obj/item/toy/plushie/octopus
	name = "octopus plushie"
	icon_state = "loveable"
	pokephrase = "Squish!"

/obj/item/toy/plushie/face_hugger
	name = "facehugger plushie"
	icon_state = "huggable"
	pokephrase = "Hug!"

//foxes are basically the best

/obj/item/toy/plushie/red_fox
	name = "red fox plushie"
	icon_state = "redfox"
	pokephrase = "Gecker!"

/obj/item/toy/plushie/black_fox
	name = "black fox plushie"
	icon_state = "blackfox"
	pokephrase = "Ack!"

/obj/item/toy/plushie/marble_fox
	name = "marble fox plushie"
	icon_state = "marblefox"
	pokephrase = "Awoo!"

/obj/item/toy/plushie/blue_fox
	name = "blue fox plushie"
	icon_state = "bluefox"
	pokephrase = "Yoww!"

/obj/item/toy/plushie/orange_fox
	name = "orange fox plushie"
	icon_state = "orangefox"
	pokephrase = "Yagh!"

/obj/item/toy/plushie/coffee_fox
	name = "coffee fox plushie"
	icon_state = "coffeefox"
	pokephrase = "Gerr!"

/obj/item/toy/plushie/pink_fox
	name = "pink fox plushie"
	icon_state = "pinkfox"
	pokephrase = "Yack!"

/obj/item/toy/plushie/purple_fox
	name = "purple fox plushie"
	icon_state = "purplefox"
	pokephrase = "Whine!"

/obj/item/toy/plushie/crimson_fox
	name = "crimson fox plushie"
	icon_state = "crimsonfox"
	pokephrase = "Auuu!"

/obj/item/toy/plushie/deer
	name = "deer plushie"
	icon_state = "deer"
	pokephrase = "Bleat!"

/obj/item/toy/plushie/black_cat
	name = "black cat plushie"
	icon_state = "blackcat"
	pokephrase = "Mlem!"

/obj/item/toy/plushie/grey_cat
	name = "grey cat plushie"
	icon_state = "greycat"
	pokephrase = "Mraw!"

/obj/item/toy/plushie/white_cat
	name = "white cat plushie"
	icon_state = "whitecat"
	pokephrase = "Mew!"

/obj/item/toy/plushie/orange_cat
	name = "orange cat plushie"
	icon_state = "orangecat"
	pokephrase = "Meow!"

/obj/item/toy/plushie/siamese_cat
	name = "siamese cat plushie"
	icon_state = "siamesecat"
	pokephrase = "Mrew?"

/obj/item/toy/plushie/tabby_cat
	name = "tabby cat plushie"
	icon_state = "tabbycat"
	pokephrase = "Purr!"

/obj/item/toy/plushie/tuxedo_cat
	name = "tuxedo cat plushie"
	icon_state = "tuxedocat"
	pokephrase = "Mrowww!!"

// nah, squids are better than foxes :>

/obj/item/toy/plushie/squid/green
	name = "green squid plushie"
	desc = "A small, cute and loveable squid friend. This one is green."
	icon = 'icons/obj/toy.dmi'
	icon_state = "greensquid"
	slot_flags = SLOT_HEAD
	pokephrase = "Squrr!"

/obj/item/toy/plushie/squid/mint
	name = "mint squid plushie"
	desc = "A small, cute and loveable squid friend. This one is mint coloured."
	icon = 'icons/obj/toy.dmi'
	icon_state = "mintsquid"
	slot_flags = SLOT_HEAD
	pokephrase = "Blurble!"

/obj/item/toy/plushie/squid/blue
	name = "blue squid plushie"
	desc = "A small, cute and loveable squid friend. This one is blue."
	icon = 'icons/obj/toy.dmi'
	icon_state = "bluesquid"
	slot_flags = SLOT_HEAD
	pokephrase = "Blob!"

/obj/item/toy/plushie/squid/orange
	name = "orange squid plushie"
	desc = "A small, cute and loveable squid friend. This one is orange."
	icon = 'icons/obj/toy.dmi'
	icon_state = "orangesquid"
	slot_flags = SLOT_HEAD
	pokephrase = "Squash!"

/obj/item/toy/plushie/squid/yellow
	name = "yellow squid plushie"
	desc = "A small, cute and loveable squid friend. This one is yellow."
	icon = 'icons/obj/toy.dmi'
	icon_state = "yellowsquid"
	slot_flags = SLOT_HEAD
	pokephrase = "Glorble!"

/obj/item/toy/plushie/squid/pink
	name = "pink squid plushie"
	desc = "A small, cute and loveable squid friend. This one is pink."
	icon = 'icons/obj/toy.dmi'
	icon_state = "pinksquid"
	slot_flags = SLOT_HEAD
	pokephrase = "Wobble!"

/obj/item/toy/plushie/therapy/red
	name = "red therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is red."
	icon = 'icons/obj/toy.dmi'
	icon_state = "therapyred"
	item_state = "egg4" // It's the red egg in items_left/righthand

/obj/item/toy/plushie/therapy/purple
	name = "purple therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is purple."
	icon = 'icons/obj/toy.dmi'
	icon_state = "therapypurple"
	item_state = "egg1" // It's the magenta egg in items_left/righthand

/obj/item/toy/plushie/therapy/blue
	name = "blue therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is blue."
	icon = 'icons/obj/toy.dmi'
	icon_state = "therapyblue"
	item_state = "egg2" // It's the blue egg in items_left/righthand

/obj/item/toy/plushie/therapy/yellow
	name = "yellow therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is yellow."
	icon = 'icons/obj/toy.dmi'
	icon_state = "therapyyellow"
	item_state = "egg5" // It's the yellow egg in items_left/righthand

/obj/item/toy/plushie/therapy/orange
	name = "orange therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is orange."
	icon = 'icons/obj/toy.dmi'
	icon_state = "therapyorange"
	item_state = "egg4" // It's the red one again, lacking an orange item_state and making a new one is pointless

/obj/item/toy/plushie/therapy/green
	name = "green therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is green."
	icon = 'icons/obj/toy.dmi'
	icon_state = "therapygreen"
	item_state = "egg3" // It's the green egg in items_left/righthand

/obj/item/toy/plushie/fumo
	name = "Fumo"
	desc = "A plushie of a....?."
	icon_state = "fumoplushie"
	pokephrase = "I just don't think about losing."

//Toy cult sword
/obj/item/toy/cultsword
	name = "foam sword"
	desc = "An arcane weapon (made of foam) wielded by the followers of the hit Saturday morning cartoon \"King Nursee and the Acolytes of Heroism\"."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cultblade"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
		)
	w_class = ITEMSIZE_LARGE
	attack_verb = list("attacked", "slashed", "stabbed", "poked")

//Flowers fake & real

/obj/item/toy/bouquet
	name = "bouquet"
	desc = "A lovely bouquet of flowers. Smells nice!"
	icon = 'icons/obj/items.dmi'
	icon_state = "bouquet"
	w_class = ITEMSIZE_SMALL

/obj/item/toy/bouquet/fake
	name = "plastic bouquet"
	desc = "A cheap plastic bouquet of flowers. Smells like cheap, toxic plastic."

/obj/item/toy/stickhorse
	name = "stick horse"
	desc = "A pretend horse on a stick for any aspiring little cowboy to ride."
	icon_state = "stickhorse"
	w_class = ITEMSIZE_LARGE

//////////////////////////////////////////////////////
//				Magic 8-Ball / Conch				//
//////////////////////////////////////////////////////

/obj/item/toy/eight_ball
	name = "\improper Magic 8-Ball"
	desc = "Mystical! Magical! Ages 8+!"
	icon_state = "eight-ball"
	var/use_action = "shakes the ball"
	var/cooldown = 0
	var/list/possible_answers = list("Definitely.", "All signs point to yes.", "Most likely.", "Yes.", "Ask again later.", "Better not tell you now.", "Future unclear.", "Maybe.", "Doubtful.", "No.", "Don't count on it.", "Never.")

/obj/item/toy/eight_ball/attack_self(mob/user as mob)
	if(!cooldown)
		var/answer = pick(possible_answers)
		user.visible_message("<span class='notice'>[user] focuses on their question and [use_action]...</span>")
		user.visible_message("<span class='notice'>The [src] says \"[answer]\"</span>")
		spawn(30)
			cooldown = 0
		return

/obj/item/toy/eight_ball/conch
	name = "Magic Conch shell"
	desc = "All hail the Magic Conch!"
	icon_state = "conch"
	use_action = "pulls the string"
	possible_answers = list("Yes.", "No.", "Try asking again.", "Nothing.", "I don't think so.", "Neither.", "Maybe someday.")

// DND Character minis. Use the naming convention (type)character for the icon states.
/obj/item/toy/character
	w_class = ITEMSIZE_SMALL
	pixel_z = 5

/obj/item/toy/character/alien
	name = "xenomorph xiniature"
	desc = "A miniature xenomorph. Scary!"
	icon_state = "aliencharacter"
/obj/item/toy/character/cleric
	name = "cleric miniature"
	desc = "A wee little cleric, with his wee little staff."
	icon_state = "clericcharacter"
/obj/item/toy/character/warrior
	name = "warrior miniature"
	desc = "That sword would make a decent toothpick."
	icon_state = "warriorcharacter"
/obj/item/toy/character/thief
	name = "thief miniature"
	desc = "Hey, where did my wallet go!?"
	icon_state = "thiefcharacter"
/obj/item/toy/character/wizard
	name = "wizard miniature"
	desc = "MAGIC!"
	icon_state = "wizardcharacter"
/obj/item/toy/character/voidone
	name = "void one miniature"
	desc = "The dark lord has risen!"
	icon_state = "darkmastercharacter"
/obj/item/toy/character/lich
	name = "lich miniature"
	desc = "Murderboner extraordinaire."
	icon_state = "lichcharacter"
/obj/item/storage/box/characters
	name = "box of miniatures"
	desc = "The nerd's best friends."
	icon_state = "box"
/obj/item/storage/box/characters/starts_with = list(
//	/obj/item/toy/character/alien,
	/obj/item/toy/character/cleric,
	/obj/item/toy/character/warrior,
	/obj/item/toy/character/thief,
	/obj/item/toy/character/wizard,
	/obj/item/toy/character/voidone,
	/obj/item/toy/character/lich
	)

/obj/item/toy/AI
	name = "toy AI"
	desc = "A little toy model AI core!"// with real law announcing action!" //Alas, requires a rewrite of how ion laws work.
	icon_state = "AI"
	w_class = ITEMSIZE_SMALL
	var/cooldown = 0
/*
/obj/item/toy/AI/attack_self(mob/user)
	if(!cooldown) //for the sanity of everyone
		var/message = generate_ion_law()
		to_chat(user, "<span class='notice'>You press the button on [src].</span>")
		playsound(src, 'sound/machines/click.ogg', 20, 1)
		visible_message("<span class='danger'>[message]</span>")
		cooldown = 1
		spawn(30) cooldown = 0
		return
	..()
*/
/obj/item/toy/owl
	name = "owl action figure"
	desc = "An action figure modeled after 'The Owl', defender of justice."
	icon_state = "owlprize"
	w_class = ITEMSIZE_SMALL
	var/cooldown = 0

/obj/item/toy/owl/attack_self(mob/user)
	if(!cooldown) //for the sanity of everyone
		var/message = pick("You won't get away this time, Griffin!", "Stop right there, criminal!", "Hoot! Hoot!", "I am the night!")
		to_chat(user, "<span class='notice'>You pull the string on the [src].</span>")
		//playsound(src, 'sound/misc/hoot.ogg', 25, 1)
		visible_message("<span class='danger'>[message]</span>")
		cooldown = 1
		spawn(30) cooldown = 0
		return
	..()

/obj/item/toy/griffin
	name = "griffin action figure"
	desc = "An action figure modeled after 'The Griffin', criminal mastermind."
	icon_state = "griffinprize"
	w_class = ITEMSIZE_SMALL
	var/cooldown = 0

/obj/item/toy/griffin/attack_self(mob/user)
	if(!cooldown) //for the sanity of everyone
		var/message = pick("You can't stop me, Owl!", "My plan is flawless! The vault is mine!", "Caaaawwww!", "You will never catch me!")
		to_chat(user, "<span class='notice'>You pull the string on the [src].</span>")
		//playsound(src, 'sound/misc/caw.ogg', 25, 1)
		visible_message("<span class='danger'>[message]</span>")
		cooldown = 1
		spawn(30) cooldown = 0
		return
	..()

//This should really be somewhere else but I don't know where. w/e

/obj/item/inflatable_duck
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	icon = 'icons/obj/clothing/belts.dmi'
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/rubber.ogg'

/obj/item/toy/xmastree
	name = "Miniature Christmas tree"
	desc = "Tiny cute Christmas tree."
	icon_state = "tinyxmastree"
	w_class = ITEMSIZE_TINY
	force = 1
	throwforce = 1
	drop_sound = 'sound/items/drop/box.ogg'

//////////////////////////////////////////////////////
//					Chess Pieces					//
//////////////////////////////////////////////////////

/obj/item/toy/chess
	name = "chess piece"
	desc = "This should never display."
	icon = 'icons/obj/chess.dmi'
	w_class = ITEMSIZE_SMALL
	force = 1
	throwforce = 1
	drop_sound = 'sound/items/drop/glass.ogg'

/obj/item/toy/chess/pawn_white
	name = "blue pawn"
	desc = "A large pawn piece for playing chess. It's made of a blue-colored glass."
	description_info = "Pawns can move forward one square, if that square is unoccupied. If the pawn has not yet moved, it has the option of moving two squares forward provided both squares in front of the pawn are unoccupied. A pawn cannot move backward. They can only capture an enemy piece on either of the two tiles diagonally in front of them, but not the tile directly in front of them."
	icon_state = "w-pawn"
/obj/item/toy/chess/pawn_black
	name = "purple pawn"
	desc = "A large pawn piece for playing chess. It's made of a purple-colored glass."
	description_info = "Pawns can move forward one square, if that square is unoccupied. If the pawn has not yet moved, it has the option of moving two squares forward provided both squares in front of the pawn are unoccupied. A pawn cannot move backward. They can only capture an enemy piece on either of the two tiles diagonally in front of them, but not the tile directly in front of them."
	icon_state = "b-pawn"
/obj/item/toy/chess/rook_white
	name = "blue rook"
	desc = "A large rook piece for playing chess. It's made of a blue-colored glass."
	description_info = "The Rook can move any number of vacant squares vertically or horizontally."
	icon_state = "w-rook"
/obj/item/toy/chess/rook_black
	name = "purple rook"
	desc = "A large rook piece for playing chess. It's made of a purple-colored glass."
	description_info = "The Rook can move any number of vacant squares vertically or horizontally."
	icon_state = "b-rook"
/obj/item/toy/chess/knight_white
	name = "blue knight"
	desc = "A large knight piece for playing chess. It's made of a blue-colored glass. Sadly, you can't ride it."
	description_info = "The Knight can either move two squares horizontally and one square vertically or two squares vertically and one square horizontally. The knight's movement can also be viewed as an 'L' laid out at any horizontal or vertical angle."
	icon_state = "w-knight"
/obj/item/toy/chess/knight_black
	name = "purple knight"
	desc = "A large knight piece for playing chess. It's made of a purple-colored glass. 'Just a flesh wound.'"
	description_info = "The Knight can either move two squares horizontally and one square vertically or two squares vertically and one square horizontally. The knight's movement can also be viewed as an 'L' laid out at any horizontal or vertical angle."
	icon_state = "b-knight"
/obj/item/toy/chess/bishop_white
	name = "blue bishop"
	desc = "A large bishop piece for playing chess. It's made of a blue-colored glass."
	description_info = "The Bishop can move any number of vacant squares in any diagonal direction."
	icon_state = "w-bishop"
/obj/item/toy/chess/bishop_black
	name = "purple bishop"
	desc = "A large bishop piece for playing chess. It's made of a purple-colored glass."
	description_info = "The Bishop can move any number of vacant squares in any diagonal direction."
	icon_state = "b-bishop"
/obj/item/toy/chess/queen_white
	name = "blue queen"
	desc = "A large queen piece for playing chess. It's made of a blue-colored glass."
	description_info = "The Queen can move any number of vacant squares diagonally, horizontally, or vertically."
	icon_state = "w-queen"
/obj/item/toy/chess/queen_black
	name = "purple queen"
	desc = "A large queen piece for playing chess. It's made of a purple-colored glass."
	description_info = "The Queen can move any number of vacant squares diagonally, horizontally, or vertically."
	icon_state = "b-queen"
/obj/item/toy/chess/king_white
	name = "blue king"
	desc = "A large king piece for playing chess. It's made of a blue-colored glass."
	description_info = "The King can move exactly one square horizontally, vertically, or diagonally. If your opponent captures this piece, you lose."
	icon_state = "w-king"
/obj/item/toy/chess/king_black
	name = "purple king"
	desc = "A large king piece for playing chess. It's made of a purple-colored glass."
	description_info = "The King can move exactly one square horizontally, vertically, or diagonally. If your opponent captures this piece, you lose."
	icon_state = "b-king"

/// Balloon structures

/obj/structure/balloon
	name = "generic balloon"
	desc = "A generic balloon. How boring."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ghostballoon"
	anchored = 0
	density = 0

/obj/structure/balloon/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(user.a_intent == I_HELP)
		user.visible_message("<span class='notice'><b>\The [user]</b> pokes [src]!</span>","<span class='notice'>You poke [src]!</span>")
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'><b>\The [user]</b> punches [src]!</span>","<span class='warning'>You punch [src]!</span>")
	else if (user.a_intent == I_GRAB)
		if(prob(66))
			user.visible_message("<span class='warning'><b>\The [user]</b> attempts to pop [src]!</span>","<span class='warning'>You attempt to pop [src]!</span>")
		else
			user.visible_message("<span class='warning'><b>\The [user]</b> pops [src]!</span>","<span class='warning'>You pop [src]!</span>")
			burst()
	else
		user.visible_message("<span class='notice'><b>\The [user]</b> lightly bats the [src].</span>","<span class='notice'>You lightly bat the [src].</span>")

/obj/structure/balloon/bullet_act()
	burst()

/obj/structure/balloon/proc/burst()
	playsound(src, 'sound/weapons/Gunshot_old.ogg', 100, 1)
	if(("[initial(icon_state)]_burst") in icon_states(icon))
		icon_state = "[initial(icon_state)]_burst"
	else
		qdel(src) // Just qdel it if it doesn't have a burst state.

/obj/structure/balloon/bat
	name = "giant bat balloon"
	desc = "A large balloon in the shape of a spooky bat with orange eyes."
	icon_state = "batballoon"

/obj/structure/balloon/ghost
	name = "giant ghost balloon"
	desc = "Oh no, it's a ghost! Oh wait, it's just a balloon. Phew!"
	icon_state = "ghostballoon"

/obj/structure/balloon/xmas
	name = "giant xmas tree balloon"
	desc = "Gather round the inflatable winter tree and exchange inflatable winter gifts. Non-Unitarians welcome."
	icon_state = "xmastreeballoon"

/obj/structure/balloon/candycane
	name = "giant candy cane balloon"
	desc = "A small tag reads 'Not for consumption'."
	icon_state = "candycaneballoon"

//ship models
/obj/item/toy/modelship
	name = "Model ship"
	desc = "A model of a SolGov ship, in 1:250th scale, on a handsome wooden stand. Small lights blink on the hull and at the engine exhaust."
	icon_state = "ship_model_1"

/obj/item/toy/modelship/two
	desc = "A small model of a spaceship, in 1:278th scale, it has small lights iluminating it's windows and engines."
	icon_state = "ship_model_2"

//desk toys
/obj/item/toy/desk
	name = "desk toy master"
	desc = "A object that does not exist. Parent Item"

	var/on = 0
	var/activation_sound = 'sound/weapons/empty.ogg'

/obj/item/toy/desk/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/toy/desk/attack_self(mob/user)
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 15, 1, -3)
	update_icon()
	return 1

/obj/item/toy/desk/newtoncradle
	name = "\improper Newton's cradle"
	desc = "An ancient 21th century super-weapon model demonstrating that Sir Isaac Newton is the deadliest sonuvabitch in space."
	icon_state = "newtoncradle"

/obj/item/toy/desk/fan
	name = "desk fan"
	desc = "Your greatest fan."
	icon_state= "fan"

/obj/item/toy/desk/officetoy
	name = "office toy"
	desc = "A generic microfusion powered office desk toy. Only generates magnetism and ennui."
	icon_state= "desktoy"

/obj/item/toy/desk/dippingbird
	name = "dipping bird toy"
	desc = "An ancient human bird idol, worshipped by clerks and desk jockeys."
	icon_state= "dippybird"
