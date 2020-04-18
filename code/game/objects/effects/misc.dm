//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items.dmi'
	icon_state = "strangepresent"
	density = 1
	anchored = 0

// Shown really briefly when attacking with axes.
/obj/effect/temp_visual/cleave_attack
	name = "cleaving attack"
	desc = "Something swinging really wide."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "cleave"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	duration = 6
	alpha = 140
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32

/obj/effect/temp_visual/cleave_attack/Initialize() // Makes the slash fade smoothly. When completely transparent it should qdel itself.
	. = ..()
	animate(src, alpha = 0, time = duration - 1)

/obj/effect/temp_visual/shuttle_landing
	name = "shuttle landing"
	desc = "You better move if you don't want to go splat!"
	icon_state = "shuttle_warning_still"
	duration = 4.9 SECONDS

/obj/effect/temp_visual/shuttle_landing/Initialize()
	flick("shuttle_warning", src) // flick() forces the animation to always begin at the start.
	. = ..()

// The manifestation of Zeus's might. Or just a really unlucky day.
// This is purely a visual effect, this isn't the part of the code that hurts things.
/obj/effect/temp_visual/lightning_strike
	name = "lightning"
	desc = "How <i>shocked</i> you must be, to see this text. You must have <i>lightning</i> reflexes. \
	The humor in this description is just so <i>electrifying</i>."
	icon = 'icons/effects/96x256.dmi'
	icon_state = "lightning_strike"
	plane = PLANE_LIGHTING_ABOVE
	duration = 1 SECOND
	pixel_x = -32

/obj/effect/temp_visual/lightning_strike/Initialize()
	icon_state += "[rand(1,2)]" // To have two variants of lightning sprites.
	animate(src, alpha = 0, time = duration - 1)
	. = ..()