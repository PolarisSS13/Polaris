/*
 * Crayons
 */

/obj/item/weapon/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = ITEMSIZE_TINY
	attack_verb = list("attacked", "coloured")
	colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	var/list/validSurfaces = list(/turf/simulated/floor)
	var/edible = 1 //so you can't eat a spraycan

/obj/item/weapon/pen/crayon/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	viewers(user) << "<font color='red'><b>[user] is jamming the [src.name] up [TU.his] nose and into [TU.his] brain. It looks like [TU.he] [TU.is] trying to commit suicide.</b></font>"
	return (BRUTELOSS|OXYLOSS)

/obj/item/weapon/pen/crayon/New()
	name = "[colourName] crayon"

/obj/item/weapon/pen/crayon/marker
	name = "marker"
	desc = "A chisel-tip permanent marker. Hopefully non-toxic."
	icon_state = "markerred"

/obj/item/weapon/pen/crayon/marker/New()
	name = "[colourName] marker"


/obj/item/weapon/pen/crayon/red
	icon_state = "crayonred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/weapon/pen/crayon/orange
	icon_state = "crayonorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"

/obj/item/weapon/pen/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/weapon/pen/crayon/green
	icon_state = "crayongreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"

/obj/item/weapon/pen/crayon/blue
	icon_state = "crayonblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/weapon/pen/crayon/purple
	icon_state = "crayonpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/weapon/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/weapon/pen/crayon/mime/attack_self(mob/living/user as mob) //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this crayon.")
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this crayon.")
	return

/obj/item/weapon/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	uses = 0

/obj/item/weapon/pen/crayon/rainbow/attack_self(mob/living/user as mob)
	colour = input(user, "Please select the main colour.", "Crayon colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Crayon colour") as color
	return

/obj/item/weapon/pen/crayon/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(is_type_in_list(target,validSurfaces))
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter","arrow")
		if(get_dist(target, user) > 1 || !(user.z == target.z))
			return
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				if(get_dist(target, user) > 1 || !(user.z == target.z))
					return
				to_chat(user, "You start drawing a letter on the [target.name].")
			if("graffiti")
				to_chat(user, "You start drawing graffiti on the [target.name].")
			if("rune")
				to_chat(user, "You start drawing a rune on the [target.name].")
			if("arrow")
				drawtype = input("Choose the arrow.", "Crayon scribbles") in list("left", "right", "up", "down")
				if(get_dist(target, user) > 1 || !(user.z == target.z))
					return
				to_chat(user, "You start drawing an arrow on the [target.name].")

		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/crayon(target,colour,shadeColour,drawtype)
			to_chat(user, "You finish drawing.")
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='warning'>You used up your crayon!</span>")
					qdel(src)
	return

/obj/item/weapon/pen/crayon/attack(mob/M as mob, mob/user as mob)
	if(edible && (M == user))
		user << "You take a bite of the crayon and swallow it."
		user.nutrition += 1
		user.reagents.add_reagent("crayon_dust",min(5,uses)/3)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate your crayon!</span>")
				qdel(src)
	else
		..()

/obj/item/weapon/pen/crayon/marker/black
	icon_state = "markerblack"
	colour = "#2D2D2D"
	shadeColour = "#000000"
	colourName = "black"

/obj/item/weapon/pen/crayon/marker/red
	icon_state = "markerred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/weapon/pen/crayon/marker/orange
	icon_state = "markerorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"

/obj/item/weapon/pen/crayon/marker/yellow
	icon_state = "markeryellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/weapon/pen/crayon/marker/green
	icon_state = "markergreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"

/obj/item/weapon/pen/crayon/marker/blue
	icon_state = "markerblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/weapon/pen/crayon/marker/purple
	icon_state = "markerpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/weapon/pen/crayon/marker/mime
	icon_state = "markermime"
	desc = "A very sad-looking marker."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/weapon/pen/crayon/marker/mime/attack_self(mob/living/user as mob) //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		to_chat(user, "You will now draw in white and black with this marker.")
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		to_chat(user, "You will now draw in black and white with this marker.")
	return

/obj/item/weapon/pen/crayon/marker/rainbow
	icon_state = "markerrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	uses = 0

/obj/item/weapon/pen/crayon/marker/rainbow/attack_self(mob/living/user as mob)
	colour = input(user, "Please select the main colour.", "Marker colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Marker colour") as color
	return

/obj/item/weapon/pen/crayon/marker/attack(mob/M as mob, mob/user as mob)
	if(M == user)
		to_chat(user, "You take a bite of the marker and swallow it.")
		user.nutrition += 1
		user.reagents.add_reagent("marker_ink",6)
		if(uses)
			uses -= 5
			if(uses <= 0)
				to_chat(user,"<span class='warning'>You ate the marker!</span>")
				qdel(src)
	else
		..()

//|Spraycan stuff

/obj/item/weapon/pen/crayon/spraycan
	name = "spray can"
	icon_state = "spraycan_cap"
	item_state = "spraycan"
	desc = "A metallic container containing tasty paint."
	var/capped = 1
	var/drawtype = "graffiti"
	instant = 0
	edible = 0
	validSurfaces = list(/turf/simulated/wall)

/obj/item/weapon/pen/crayon/spraycan/suicide_act(mob/user)
	var/mob/living/carbon/human/H = user
	if(capped)
		user.visible_message("<span class='suicide'>[user] shakes up the [src] with a rattle and lifts it to their mouth, but nothing happens! Maybe they should have uncapped it first! Nonetheless--</span>")
	else
		user.visible_message("<span class='suicide'>[user] shakes up the [src] with a rattle and lifts it to their mouth, spraying silver paint across their teeth!</span>")

		playsound(loc, 'sound/effects/spray.ogg', 5, 1, 5)
		update_icon()
		H.set_face_style("spray_face", colour)
		H.update_icons_body()

		uses = max(0, uses - 10)
	return (OXYLOSS)
/obj/item/weapon/pen/crayon/spraycan/New()
	..()
	name = "spray can"
	colour = pick("#DA0000","#FF9300","#FFF200","#A8E61D","#00B7EF","#DA00FF")
	update_icon()
/obj/item/weapon/pen/crayon/spraycan/examine(mob/user)
	..()
	if(uses)
		user << "It has [uses] uses left."
	else
		user << "It is empty."
/obj/item/weapon/pen/crayon/spraycan/attack_self(mob/living/user)
	var/choice = input(user,"Spraycan options") as null|anything in list("Toggle Cap","Change Color")
	switch(choice)
		if("Toggle Cap")
			user << "<span class='notice'>You [capped ? "Remove" : "Replace"] the cap of the [src]</span>"
			capped = capped ? 0 : 1
			icon_state = "spraycan[capped ? "_cap" : ""]"
			update_icon()
		if("Change Color")
			colour = input(user,"Choose Color") as color
			update_icon()
/obj/item/weapon/pen/crayon/spraycan/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(capped)
		user << "<span class='warning'>Take the cap off first!</span>"
		return
	else
		if(iscarbon(target))
			var/mob/living/carbon/human/C = target
			if(uses)
				playsound(user.loc, 'sound/effects/spray.ogg', 5, 1, 5)
				user.visible_message("<span class='danger'>[user] sprays [src] into the face of [target]!</span>")
				target << "<span class='userdanger'>[user] sprays [src] into your face!</span>"
				if(C.client)
					C.eye_blurry = max(C.eye_blurry, 3)
					C.eye_blind = max(C.eye_blind, 1)
					if(C.eyecheck() <= 0) // no eye protection? ARGH IT BURNS.
						C.confused = max(C.confused, 3)
						C.Weaken(3)
				C.set_face_style("spray_face", colour)
				C.update_icons_body()

				uses = max(0,uses-10)
	if(is_type_in_list(target,validSurfaces))
		playsound(loc, 'sound/effects/spraycan_shake.ogg', 5, 1, 5)
		user << "You start drawing graffiti on the [target.name]."
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/crayon(target,colour,shadeColour,drawtype)
			playsound(loc, 'sound/effects/spray.ogg', 5, 1, 5)
			user << "You finish drawing."
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			if(uses)
				uses--
				if(!uses)
					to_chat(user, "<span class='warning'>Your spraycan runs empty!</span>")
					qdel(src)

	return

/obj/item/weapon/pen/crayon/spraycan/update_icon()
	overlays.Cut()
	var/image/I = image('icons/obj/crayons.dmi',icon_state = "[capped ? "spraycan_cap_colors" : "spraycan_colors"]")
	I.color = colour
	overlays += I

/obj/item/weapon/pen/crayon/attack_self(var/mob/user)
	return

