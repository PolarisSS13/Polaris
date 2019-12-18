/obj/item/weapon/lipstick
	gender = PLURAL
	name = "lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "lipstick"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/colour = COLOR_RED
	var/open = 0
	drop_sound = 'sound/items/drop/glass.ogg'

	var/lip_type = "lipstick"
	var/body_area = "lips"

/obj/item/weapon/lipstick/red
	name = "red lipstick"
	colour = COLOR_RED

/obj/item/weapon/lipstick/purple
	name = "purple lipstick"
	colour = COLOR_PURPLE

/obj/item/weapon/lipstick/jade
	name = "jade lipstick"
	colour = COLOR_PAKISTAN_GREEN

/obj/item/weapon/lipstick/black
	name = "black lipstick"
	colour = COLOR_BLACK

/obj/item/weapon/lipstick/maroon
	name = "maroon lipstick"
	colour = COLOR_MAROON

/obj/item/weapon/lipstick/pink
	name = "pink lipstick"
	colour = COLOR_PINK

/obj/item/weapon/lipstick/brown
	name = "brown lipstick"
	colour = COLOR_BROWN

/obj/item/weapon/lipstick/nude
	name = "nude lipstick"
	colour = COLOR_BEIGE

/obj/item/weapon/lipstick/random
	name = "lipstick"

/obj/item/weapon/lipstick/random/New()
	colour = pick(COLOR_RED, COLOR_PURPLE, COLOR_PAKISTAN_GREEN, COLOR_BLACK, COLOR_MAROON, COLOR_PINK, COLOR_BROWN, COLOR_BEIGE)

/obj/item/weapon/lipstick/blusher	// I'll make it it's own thing, eventually.
	name = "blusher"
	desc = "A classier way to apply it."

	icon_state = "blusher"
	lip_type = "blush"
	body_area = "cheeks"

/obj/item/weapon/lipstick/blusher/red
	name = "red blusher"
	colour = COLOR_RED

/obj/item/weapon/lipstick/blusher/purple
	name = "purple blusher"
	colour = COLOR_PURPLE

/obj/item/weapon/lipstick/blusher/jade
	name = "jade lipstick"
	colour = COLOR_PAKISTAN_GREEN

/obj/item/weapon/lipstick/blusher/black
	name = "black blusher"
	colour = COLOR_BLACK

/obj/item/weapon/lipstick/blusher/maroon
	name = "maroon blusher"
	colour = COLOR_MAROON

/obj/item/weapon/lipstick/blusher/pink
	name = "pink blusher"
	colour = COLOR_PINK

/obj/item/weapon/lipstick/blusher/brown
	name = "brown blusher"
	colour = COLOR_BROWN

/obj/item/weapon/lipstick/blusher/nude
	name = "nude blusher"
	colour = COLOR_BEIGE

/obj/item/weapon/lipstick/blusher/random/New()
	colour = pick(COLOR_RED, COLOR_ORANGE, COLOR_MAROON, COLOR_PINK, COLOR_BROWN, COLOR_BEIGE)

/obj/item/weapon/lipstick/eyeshadow
	name = "eyeshadow brush"
	desc = "Get that evening look."

	icon_state = "eyeshadow_brush"
	lip_type = "eyeshadow"
	body_area = "eyes"

/obj/item/weapon/lipstick/eyeshadow/random/New()
	colour = pick(COLOR_RED, COLOR_ORANGE, COLOR_MAROON, COLOR_PINK, COLOR_BROWN, COLOR_BEIGE)


/obj/item/weapon/lipstick/eyeshadow/red
	name = "red eyeshadow"
	colour = COLOR_RED

/obj/item/weapon/lipstick/eyeshadow/purple
	name = "purple eyeshadow"
	colour = COLOR_PURPLE

/obj/item/weapon/lipstick/eyeshadow/jade
	name = "jade lipstick"
	colour = COLOR_PAKISTAN_GREEN

/obj/item/weapon/lipstick/eyeshadow/black
	name = "black eyeshadow"
	colour = COLOR_BLACK

/obj/item/weapon/lipstick/eyeshadow/maroon
	name = "maroon eyeshadow"
	colour = COLOR_MAROON

/obj/item/weapon/lipstick/eyeshadow/pink
	name = "pink eyeshadow"
	colour = COLOR_PINK

/obj/item/weapon/lipstick/eyeshadow/brown
	name = "brown eyeshadow"
	colour = COLOR_BROWN

/obj/item/weapon/lipstick/eyeshadow/nude
	name = "nude eyeshadow"
	colour = COLOR_BEIGE

/obj/item/weapon/lipstick/shadow_blush
	name = "shadow and blush set"
	desc = "What will your parents think?"

	icon_state = "blush_shadow"
	lip_type = "blush_shadow"
	body_area = "eyes"

	colour = COLOR_WHITE


/obj/item/weapon/lipstick/shadow_blush/spooky
	name = "spooky makeup kit"
	desc = "Can't tell if you're doing this unironically or dressing for halloween."

	icon_state = "blush_shadow_clowny"
	lip_type = "clowny"


/obj/item/weapon/lipstick/attack_self(mob/user as mob)
	user << "<span class='notice'>You [open ? "close" : "open"] \the [src].</span>"
	playsound(loc, 'sound/effects/pop.ogg', 5, 1, 5)
	open = !open

	update_icon()

/obj/item/weapon/lipstick/update_icon()
	overlays.Cut()

	if(open)
		icon_state = "[initial(icon_state)]_open"
		if(colour)
			var/image/I =  image(icon, "[initial(icon_state)]_overlay")
			I.color = colour
			overlays |= I
	else
		icon_state = initial(icon_state)



/obj/item/weapon/lipstick/attack(mob/M as mob, mob/user as mob)
	if(!open)	return

	if(!istype(M, /mob))	return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.lip_style)	//if they already have lipstick on
			user << "<span class='notice'>You need to wipe off the old makeup first!</span>"
			return

		if(H == user)
			user.visible_message("<span class='notice'>[user] does their [body_area] with \the [src].</span>", \
								 "<span class='notice'>You take a moment to apply \the [src]. Perfect!</span>")
			H.set_face_style(lip_type, colour)
			H.update_icons_body()
		else
			user.visible_message("<span class='warning'>[user] begins to do [H]'s [body_area] with \the [src].</span>", \
								 "<span class='notice'>You begin to apply \the [src].</span>")
			if(do_after(user, 20) && do_after(user, 20, H, 5, 0))	//user needs to keep their active hand, H does not.
				user.visible_message("<span class='notice'>[user] does [H]'s [body_area] with \the [src].</span>", \
									 "<span class='notice'>You apply \the [src].</span>")
				H.set_face_style(lip_type, colour)
				H.update_icons_body()
	else
		user << "<span class='notice'>Where are the [body_area] on that?</span>"

//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/attack()

/obj/item/weapon/haircomb
	name = "comb"
	desc = "A pristine comb made from flexible plastic."
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "purplecomb"
	drop_sound = 'sound/items/drop/accessory.ogg'
	color = COLOR_PURPLE

/obj/item/weapon/haircomb/random/New()
	color = "#"+get_random_colour()
	..()

/obj/item/weapon/haircomb/attack(mob/living/carbon/human/H, mob/user)
	var/text = "person"

	if(ishuman(H))
		if(H.h_style == "Bald" || H.h_style == "Balding Hair" || H.h_style == "Skinhead")
			if(H == user) //shaving yourself
				H.visible_message(text("<span class='notice'>[user] lifts [src] and stares at it for a moment with longing, for they are bald. How pathetic. </span>"))
			else
				user.visible_message(text("<span class='notice'>[user] lifts [src] and realises there's no hair to actually shave. Awkward. </span>"))
			return

		switch(H.identifying_gender)
			if(MALE)
				text = "guy"
			if(FEMALE)
				text = "lady"
	else
		switch(H.gender)
			if(MALE)
				text = "guy"
			if(FEMALE)
				text = "lady"

	if(H == user) //shaving yourself
		user.visible_message("<span class='notice'>[user] uses [src] to comb their hair with incredible style and sophistication. What a [text].</span>")
	else
		H.visible_message("<span class='notice'>[user] uses [src] to comb [H]'s hair with incredible style and sophistication. The [text] sure looks pampered.</span>")

/obj/item/weapon/razor
	name = "electric razor"
	desc = "The latest and greatest power razor born from the science of shaving."
	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "razor"
	flags = CONDUCT
	w_class = 1
	var/shave_sound = 'sound/items/Welder2.ogg'


/obj/item/weapon/razor/proc/shave(mob/living/carbon/human/H, location = "mouth")
	if(location == "mouth")
		H.f_style = "Shaved"
	else
		H.h_style = "Skinhead"

	H.update_hair()
	if(shave_sound)
		playsound(loc, shave_sound, 20, 1)


/obj/item/weapon/razor/attack(mob/M, mob/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/location = user.zone_sel.selecting
		if(location == "mouth")
/*			if(!get_location_accessible(H, location))
				user << "<span class='warning'>The mask is in the way!</span>"
				return */
			if(H.f_style == "Shaved")
				user << "<span class='warning'>Already clean-shaven!</span>"
				return

			if(H == user) //shaving yourself
				user.visible_message("[user] starts to shave their facial hair with [src].", \
									 "<span class='notice'>You take a moment to shave your facial hair with [src]...</span>")
				if(do_after(user, 50, target = H))
					user.visible_message("[user] shaves his facial hair clean with [src].", \
										 "<span class='notice'>You finish shaving with [src]. Fast and clean!</span>")
					shave(H, location)
			else
				var/turf/H_loc = H.loc
				user.visible_message("<span class='warning'>[user] tries to shave [H]'s facial hair with [src].</span>", \
									 "<span class='notice'>You start shaving [H]'s facial hair...</span>")
				if(do_after(user, 50, target = H))
					if(H_loc == H.loc)
						user.visible_message("<span class='warning'>[user] shaves off [H]'s facial hair with [src].</span>", \
											 "<span class='notice'>You shave [H]'s facial hair clean off.</span>")
						shave(H, location)

		else if(location == "head")
/*			if(!get_location_accessible(H, location))
				user << "<span class='warning'>The headgear is in the way!</span>"
				return */
			if(H.h_style == "Bald" || H.h_style == "Balding Hair" || H.h_style == "Skinhead")
				user << "<span class='warning'>There is not enough hair left to shave!</span>"
				return

			if(H == user) //shaving yourself
				user.visible_message("[user] starts to shave their head with [src].", \
									 "<span class='notice'>You start to shave your head with [src]...</span>")
				if(do_after(user, 5, target = H))
					user.visible_message("[user] shaves his head with [src].", \
										 "<span class='notice'>You finish shaving with [src].</span>")
					shave(H, location)
			else
				var/turf/H_loc = H.loc
				user.visible_message("<span class='warning'>[user] tries to shave [H]'s head with [src]!</span>", \
									 "<span class='notice'>You start shaving [H]'s head...</span>")
				if(do_after(user, 50, target = H))
					if(H_loc == H.loc)
						user.visible_message("<span class='warning'>[user] shaves [H]'s head bald with [src]!</span>", \
											 "<span class='notice'>You shave [H]'s head bald.</span>")
						shave(H, location)
		else
			..()
	else
		..()

/obj/item/weapon/razor/blade
	name = "razor blade"
	desc = "Careful not to cut yourself on that edge."
	icon_state = "razorblade"
	shave_sound = null

//Pure fluff.

/obj/item/weapon/cosmetic
	name = "shampoo"
	desc = "A generic brand shampoo."

	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "shampoo"

	var/cosmetic_sound = 'sound/effects/bubbles2.ogg'

	var/use_msg = "You foam up their hair with the shampoo."
	var/use_msg_see = "They have their hair foamed up with the shampoo."

	var/use_msg_self = "You foam up your hair with the shampoo."
	var/use_msg_self_see = "You see them foam up them hair with the shampoo."

	var/after_use_self_see = "They finish foaming up their hair. They smell good."
	var/after_use_see = "You delicately shampoo your own hair, how great!"


	var/after_use = "They just get their hair shampooed, it looks great."
	var/after_use_self = "You shampoo your own hair, it looks amazing."

	var/scent //if it has a scent, otherwise, leave blank.

	var/usage_time = 40

	var/zone_requirement = "head"

	var/uses = 20

/obj/item/weapon/cosmetic/New()
	if(scent)
		name = "[scent] [initial(name)]"
		desc = "This is a [initial(name)] that has the label \"[scent]\" on it. Even the packaging smells nice."

	..()

/obj/item/weapon/cosmetic/proc/conditionals() // add a conditional here, if 1, will continue. if 0, will end behaviour
	return 1


/obj/item/weapon/cosmetic/proc/activate() // add custom behaviour here.
	return

/obj/item/weapon/cosmetic/proc/post_activate() // add custom behaviour here.
	return

/obj/item/weapon/cosmetic/proc/set_text(mob/M, mob/user) // add custom behaviour here.
	return

/obj/item/weapon/cosmetic/attack(mob/M, mob/user)
	if(!uses)
		to_chat(user, "<span class='notice'>It looks like [src] is empty...</span>")
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/location = user.zone_sel.selecting
		if(!location == zone_requirement && zone_requirement)
			H.visible_message("<span class='notice'>You must aim for the [zone_requirement] to use this.</span>")
		else

			if(!conditionals())
				return

			set_text(M, user)

			if(cosmetic_sound)
				playsound(loc, cosmetic_sound, 5, 1, 5)

			activate()

			if(H == user)
				H.visible_message("<span class='notice'>[use_msg_self_see]</span>", "<span class='notice'>[use_msg_self]</span>")
			else
				H.visible_message("<span class='notice'>[use_msg]</span>", "<span class='notice'>[use_msg_see]</span>")

			if(scent)
				spawn(8)
					H.visible_message("<b>You can smell the scent of <i>[scent]</i>...</b>")

			if(do_after(user, usage_time, target = H))
				if(H == user)
					H.visible_message("<span class='notice'>[after_use_self_see]</span>", "<span class='notice'>[after_use_self]</span>")
				else
					H.visible_message("<span class='notice'>[after_use]</span>", "<span class='notice'>[after_use_see]</span>")

			uses--
			post_activate(M, user)

	return

/obj/item/weapon/cosmetic/shampoo/set_text(mob/M, mob/user)
	use_msg = "You foam up [M]'s hair with the [src]."
	use_msg_see = "[M] has their hair foamed up with the [src]."

	use_msg_self = "You foam up your hair with the [src]."
	use_msg_self_see = "You see [M] foam up their hair with the [src]."

	after_use_self_see = "[M] finishes foaming up their own hair. They smell good."
	after_use_see = "You have your own hair shampoo'ed. You feel prestiged."

	after_use = "[M] has their hair shampooed, it smells <b>amazing.</b>"
	after_use_self = "You shampoo your own hair delicately with the [src]."

/obj/item/weapon/cosmetic/conditioner/set_text(mob/M, mob/user)
	use_msg = "You gently condition [M]'s hair with the [src]."
	use_msg_see = "[M] has their hair moisturized and conditioned with the [src]."

	use_msg_self = "You apply conditioning lotion up your hair with the [src]."
	use_msg_self_see = "You see [M] add a dollop of [src] to their hair."

	after_use_self_see = "[M] finishes conditioning their own hair. The smell of [scent] is really noticeable."
	after_use_see = "You smell [scent] in your hair, after it gets conditioned by the [src]"

	after_use = "[M]'s hair is fully conditioned with the [src]."
	after_use_self = "You condition your own hair with [src], making sure it's distrubuted properly. It feels silky"


/obj/item/weapon/cosmetic/perfume/set_text(mob/M, mob/user)
	use_msg = "You spray [M] carefully with the [src]."
	use_msg_see = "[M] is being sprayed with the [src]."

	use_msg_self = "You daintily spray [src] behind your ears and around you."
	use_msg_self_see = "You see [M] lavish themselves with [src]."

	after_use_self_see = "The smell of [scent] wafts in the air as [M] sprays the [initial(name)]."
	after_use_see = "The smell of [scent] fills your senses as you get sprayed with [src]."

	after_use = "[M] is sprayed with [src] and the aroma is strong in the air."
	after_use_self = "You generously spray yourself with [src], the [initial(name)] wafts in the air."


/obj/item/weapon/cosmetic/cologne/set_text(mob/M, mob/user)
	use_msg = "You spray [M] around their ears and neck [src]."
	use_msg_see = "[M] is being sprayed generously with the [src]."

	use_msg_self = "You lavishly spray [src] around your ears and neck."
	use_msg_self_see = "You see [M] spray themselves generously themselves with [src]."

	after_use_self_see = "The smell of [scent] wafts in the air as [M] sprays the [initial(name)]."
	after_use_see = "The smell of [scent] fills your senses as you get sprayed with [initial(name)]."

	after_use = "[M] is sprayed with [src] and the aroma is strong in the air."
	after_use_self = "After you spray yourself with [src], the [initial(name)] wafts in the air."

/obj/item/weapon/cosmetic/aftershave/set_text(mob/M, mob/user)
	use_msg = "You apply some [src] to your hands and begin patting [M]'s face."
	use_msg_see = "[M] is being patted down by [user] with [src]."

	use_msg_self = "You add some [src] to your hands and begin patting your cheeks with it."
	use_msg_self_see = "You see [M] apply [src] to their hands and begin patting their cheeks down."

	after_use_self_see = "The smell of [scent] wafts in the air as [M] applies the [initial(name)]."
	after_use_see = "The smell of [scent] fills your senses as you pat yourself down with [initial(name)]."

	after_use = "[user] finishes applying [src] to [M] and the aroma is strong in the air."
	after_use_self = "After you pamper yourself with [src], the [initial(name)]'s [scent] blends strongly in the air."

/obj/item/weapon/cosmetic/shampoo
	name = "shampoo"
	desc = "A generic brand shampoo."

	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "shampoo"


	cosmetic_sound = 'sound/items/soda_shaking.ogg'

	lemongrass
		scent = "lemongrass and ginger"
		color = COLOR_BEIGE

	rose
		scent = "rose water"
		color = COLOR_PINK

	cinnamon
		scent = "cinnamon"
		color = COLOR_BROWN

	sandalwood
		scent = "sandalwood"
		color = COLOR_ORANGE

	strawberry
		scent = "strawberry"
		color = COLOR_PALE_RED_GRAY

	apple
		scent = "apple"
		color = COLOR_PALE_GREEN_GRAY

	chamomile
		scent = "chamomile"
		color = COLOR_SILVER

	ginger
		scent = "ginger"
		color = COLOR_YELLOW

/obj/item/weapon/cosmetic/conditioner
	name = "conditioner"
	desc = "A generic brand conditioner."

	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "conditioner"

	cosmetic_sound = 'sound/effects/squelch1.ogg'

	lemongrass
		scent = "lemongrass and ginger"
		color = COLOR_BEIGE

	rose
		scent = "rose water"
		color = COLOR_PINK

	cinnamon
		scent = "cinnamon"
		color = COLOR_BROWN

	apple
		scent = "apple"
		color = COLOR_PALE_GREEN_GRAY

	strawberry
		scent = "strawberry"
		color = COLOR_PALE_RED_GRAY

	sandalwood
		scent = "sandalwood"
		color = COLOR_ORANGE

	chamomile
		scent = "chamomile"
		color = COLOR_SILVER

	ginger
		scent = "ginger"
		color = COLOR_YELLOW

/obj/item/weapon/cosmetic/perfume
	name = "perfume"
	desc = "A generic brand perfume."

	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "perfume"

	cosmetic_sound = 'sound/effects/spray2.ogg'


	vanilla
		scent = "vanilla"
		color = COLOR_BEIGE

	rose
		scent = "rose water"
		color = COLOR_PINK

	musk
		scent = "sol musk"
		color = COLOR_BROWN

	sandalwood
		scent = "sandalwood"
		color = COLOR_PALE_GREEN_GRAY

	lavender
		scent = "lavender"
		color = COLOR_PALE_PURPLE_GRAY

	orange_blossom
		scent = "orange blossom"
		color = COLOR_ORANGE

/obj/item/weapon/cosmetic/cologne
	name = "cologne"
	desc = "A generic brand cologne."

	icon = 'icons/obj/cosmetics.dmi'
	icon_state = "cologne"

	cosmetic_sound = 'sound/effects/spray2.ogg'


	cotton
		scent = "fresh cotton"
		color = COLOR_BEIGE

	greek_rose
		scent = "rose water"
		color = COLOR_PINK

	cocoa
		scent = "cocoa"
		color = COLOR_BROWN

	sandalwood
		scent = "sandalwood"
		color = COLOR_PALE_GREEN_GRAY

	lavender
		scent = "lavender"
		color = COLOR_PALE_PURPLE_GRAY

	ginger
		scent = "ginger"
		color = COLOR_ORANGE


/obj/item/weapon/cosmetic/aftershave
	name = "aftershave"
	desc = "A generic brand aftershave."

	icon_state = "aftershave"

	cosmetic_sound = 'sound/effects/spray2.ogg'


	cotton
		scent = "fresh cotton"
		color = COLOR_BEIGE

	greek_rose
		scent = "rose water"
		color = COLOR_PINK

	cocoa
		scent = "cocoa"
		color = COLOR_BROWN

	sandalwood
		scent = "sandalwood"
		color = COLOR_PALE_GREEN_GRAY

	lavender
		scent = "lavender"
		color = COLOR_PALE_PURPLE_GRAY

	ginger
		scent = "ginger"
		color = COLOR_ORANGE

/obj/item/weapon/cosmetic/aftershave/tonic
	name = "tonic"
	desc = "Skin firming action, for pores that don't look like craters."

	icon_state = "tonic"
	scent = "alcohol"

	cosmetic_sound = 'sound/items/soda_shaking.ogg'

