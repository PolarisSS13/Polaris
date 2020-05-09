/datum/technomancer_catalog/spell/chroma
	name = "Chroma"
	cost = 25
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/chroma)

/datum/spell_metadata/chroma
	name = "Chroma"
	desc = "Creates light around you, or in a location of your choosing. \
	You can choose what color the light is. This could be useful to trick someone into \
	believing you're casting a different spell, or perhaps just for fun."
	aspect = ASPECT_LIGHT
	icon_state = "tech_chroma"
	spell_path = /obj/item/weapon/spell/technomancer/chroma
	cooldown = 2 SECONDS
	var/color_to_use = "#FFFFFF"


/obj/item/weapon/spell/technomancer/chroma
	name = "chroma"
	icon_state = "chroma"
	desc = "The colors are dazzling."
	cast_methods = CAST_RANGED | CAST_USE

/obj/item/weapon/spell/technomancer/chroma/on_spell_given(mob/user)
	var/datum/spell_metadata/chroma/chroma_meta = meta
	set_light(6, 5, l_color = chroma_meta.color_to_use)

/obj/item/weapon/spell/technomancer/chroma/on_use_cast(mob/user)
	var/datum/spell_metadata/chroma/chroma_meta = meta
	var/new_color = input(user, "Choose the color you want your light to be.", "Color selection", chroma_meta.color_to_use) as null|color
	if(new_color)
		chroma_meta.color_to_use = new_color
		set_light(6, 5, l_color = new_color)
	return TRUE

/obj/item/weapon/spell/technomancer/chroma/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T)
		var/datum/spell_metadata/chroma/chroma_meta = meta
		new /obj/effect/temp_visual/chroma(T, chroma_meta.color_to_use)
		to_chat(user, span("notice", "You create some light on \the [T]."))
		playsound(user, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)
		return TRUE
	return FALSE

/obj/effect/temp_visual/chroma
	name = "chroma"
	desc = "How are you examining what which cannot be seen?"
	invisibility = 101
	duration = 2 MINUTES

/obj/effect/temp_visual/chroma/Initialize(mapload, new_color = "#FFFFFF")
	set_light(6, 5, l_color = new_color)
	return ..()