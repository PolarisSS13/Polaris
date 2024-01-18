/obj/item/stack/material/fuel // abstract type, do not use
	var/bonfire_fuel_time = 1 MINUTE

/obj/item/stack/material/fuel/get_dryness_text(var/obj/rack)
	var/moistness = drying_wetness / initial(drying_wetness)
	if(moistness > 0.65)
		return "fresh-cut"
	if(moistness > 0.35)
		return "somewhat dried"
	if(moistness)
		return "almost dried"
	return "dried"

/obj/item/stack/material/fuel/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	default_type = MAT_WOOD
	strict_color_stacking = TRUE
	apply_colour = 1
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'
	no_variants = FALSE
	drying_wetness = 120
	dried_type = /obj/item/stack/material/fuel/wood/dried
	bonfire_fuel_time = 3 MINUTES

/obj/item/stack/material/fuel/wood/sif
	name = "sifwood plank"
	color = "#0099cc"
	default_type = MAT_SIFWOOD
	dried_type = /obj/item/stack/material/fuel/wood/dried/sif

// Dried subtypes are just used for fuel calc in bonfires, they should be otherwise identical.
/obj/item/stack/material/fuel/wood/dried
	name = "dried wooden plank"
	dried_type = null
	drying_wetness = null
	bonfire_fuel_time = 6 MINUTES

/obj/item/stack/material/fuel/wood/dried/update_strings()
	. = ..()
	name = "dried [name]"

/obj/item/stack/material/fuel/wood/dried/sif
	name = "dried sifwood plank"
	color = "#0099cc"
	default_type = MAT_SIFWOOD

/obj/item/stack/material/fuel/log
	name = "log"
	icon_state = "sheet-log"
	default_type = MAT_LOG
	no_variants = FALSE
	color = WOOD_COLOR_FURNITURE
	max_amount = 25
	w_class = ITEMSIZE_HUGE
	description_info = "Use inhand to craft things, or use a sharp and edged object on this to convert it into two wooden planks."
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'
	drying_wetness = 180
	dried_type = /obj/item/stack/material/fuel/log/dried
	bonfire_fuel_time = 4 MINUTES
	var/plank_type = /obj/item/stack/material/fuel/wood

/obj/item/stack/material/fuel/log/sif
	name = "sifwood log"
	default_type = MAT_SIFLOG
	color = "#0099cc"
	plank_type = /obj/item/stack/material/fuel/wood/sif
	dried_type = /obj/item/stack/material/fuel/log/dried/sif

/obj/item/stack/material/fuel/log/dried
	name = "dried log"
	drying_wetness = null
	dried_type = null
	plank_type = /obj/item/stack/material/fuel/wood/dried
	bonfire_fuel_time = 8 MINUTES

/obj/item/stack/material/fuel/log/dried/update_strings()
	. = ..()
	name = "dried [name]"

/obj/item/stack/material/fuel/log/dried/sif
	name = "dried sifwood log"
	default_type = MAT_SIFLOG
	color = "#0099cc"
	plank_type = /obj/item/stack/material/fuel/wood/dried/sif

/obj/item/stack/material/fuel/log/attackby(var/obj/item/W, var/mob/user)
	if(!istype(W) || W.force <= 0)
		return ..()
	if(W.sharp && W.edge)
		var/time = (3 SECONDS / max(W.force / 10, 1)) * W.toolspeed
		user.setClickCooldown(time)
		if(do_after(user, time, src) && use(1))
			to_chat(user, "<span class='notice'>You cut up a log into planks.</span>")
			playsound(src, 'sound/effects/woodcutting.ogg', 50, 1)
			var/obj/item/stack/material/fuel/wood/existing_wood = null
			for(var/obj/item/stack/material/fuel/wood/M in user.loc)
				if(M.material.name == src.material.name)
					existing_wood = M
					break

			var/obj/item/stack/material/fuel/wood/new_wood = new plank_type(user.loc)
			new_wood.amount = 2
			if(existing_wood && new_wood.transfer_to(existing_wood))
				to_chat(user, "<span class='notice'>You add the newly-formed wood to the stack. It now contains [existing_wood.amount] planks.</span>")
	else
		return ..()

/obj/item/stack/material/grass
	name = "grass"
	icon_state = "tile_grass"
	default_type = "grass"
