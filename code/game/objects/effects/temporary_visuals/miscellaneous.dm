/obj/effect/temp_visual/decoy
	desc = "It's a decoy!"
	duration = 15

/obj/effect/temp_visual/decoy/Initialize(mapload, atom/mimiced_atom, var/customappearance)
	. = ..()
	alpha = initial(alpha)
	if(mimiced_atom)
		name = mimiced_atom.name
		appearance = mimiced_atom.appearance
		set_dir(mimiced_atom.dir)
		mouse_opacity = 0
	if(customappearance)
		appearance = customappearance

/obj/effect/temp_visual/decoy/fading/Initialize(mapload, atom/mimiced_atom)
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/decoy/fading/fivesecond
	duration = 50

/obj/effect/temp_visual/small_smoke
	icon_state = "smoke"
	duration = 50

// VOREStation Add - Used by Kinetic Accelerator
/obj/effect/temp_visual/kinetic_blast
	name = "kinetic explosion"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "kinetic_blast"
	layer = ABOVE_MOB_LAYER
	duration = 4

/obj/effect/temp_visual/explosion
	name = "explosion"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	pixel_x = -32
	pixel_y = -32
	duration = 8

/obj/effect/temp_visual/explosion/fast
	icon_state = "explosionfast"
	duration = 4
// VOREStation Add End

/obj/effect/temp_visual/impact_effect
	icon_state = "impact_bullet"
	plane = PLANE_LIGHTING_ABOVE // So they're visible even in a shootout in maint.
	duration = 5

/obj/effect/temp_visual/impact_effect/Initialize(mapload, obj/item/projectile/P, x, y)
	pixel_x = x
	pixel_y = y
	return ..()

/obj/effect/temp_visual/impact_effect/red_laser
	icon_state = "impact_laser"
	duration = 4

/obj/effect/temp_visual/impact_effect/red_laser/wall
	icon_state = "impact_laser_wall"
	duration = 10

/obj/effect/temp_visual/impact_effect/blue_laser
	icon_state = "impact_laser_blue"
	duration = 4

/obj/effect/temp_visual/impact_effect/green_laser
	icon_state = "impact_laser_green"
	duration = 4

/obj/effect/temp_visual/impact_effect/purple_laser
	icon_state = "impact_laser_purple"
	duration = 4

// Colors itself based on the projectile.
// Checks light_color and color.
/obj/effect/temp_visual/impact_effect/monochrome_laser
	icon_state = "impact_laser_monochrome"
	duration = 4

/obj/effect/temp_visual/impact_effect/monochrome_laser/Initialize(mapload, obj/item/projectile/P, x, y)
	if(P.light_color)
		color = P.light_color
	else if(P.color)
		color = P.color
	return ..()

/obj/effect/temp_visual/impact_effect/ion
	icon_state = "shieldsparkles"
	duration = 6

/obj/effect/temp_visual/phase_in
	icon_state = "phase_in"
	plane = PLANE_LIGHTING_ABOVE
	duration = 5

/obj/effect/temp_visual/phase_out
	icon_state = "phase_out"
	plane = PLANE_LIGHTING_ABOVE
	duration = 5

/obj/effect/temp_visual/summoning
	icon_state = "summoning"
	plane = PLANE_LIGHTING_ABOVE
	duration = 5 SECONDS

/obj/effect/temp_visual/heal //color is white by default, set to whatever is needed
	name = "healing glow"
	icon_state = "heal"
	plane = ABOVE_PLANE
	duration = 15

/obj/effect/temp_visual/heal/Initialize(mapload, set_color)
	if(set_color)
		color = set_color
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/obj/effect/temp_visual/love_heart
	name = "love heart"
	icon = 'icons/effects/effects.dmi'
	icon_state = "heart"
	plane = ABOVE_PLANE
	duration = 25

/obj/effect/temp_visual/love_heart/Initialize(mapload)
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	animate(src, pixel_y = pixel_y + 32, alpha = 0, time = duration)


/obj/effect/temp_visual/medical_holosign
	name = "medical holosign"
	desc = "A small holographic glow in the shape of a medical cross."
	icon_state = "medi_holo_blue"
	plane = ABOVE_PLANE
	duration = 30

/obj/effect/temp_visual/medical_holosign/green
	icon_state = "medi_holo_green"
