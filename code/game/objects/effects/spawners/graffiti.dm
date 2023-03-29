/obj/effect/spawner/graffiti
	name = "old scrawling"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "graffiti"

	/// Determines the appearance of the spawned graffiti. `rune` and `graffiti` both have unique appearances; otherwise this is jut an icon state overide.
	var/graffiti_type
	/// The hexcode for the desired secondary color of your graffiti. If blank, it will inherit this effect's color (unless it doesn't have one, in which case it'll be a random color).
	var/color_secondary

/obj/effect/spawner/graffiti/do_spawn()
	if (!color)
		color = rgb(rand(1,255), rand(1,255), rand(1,255))

	if (!color_secondary)
		color_secondary = color

	if (!graffiti_type)
		graffiti_type = pick("rune", "graffiti", "left", "right", "up", "down")

	var/obj/effect/decal/cleanable/crayon/C = new(get_turf(src), color, color_secondary, graffiti_type)
	C.name = name
