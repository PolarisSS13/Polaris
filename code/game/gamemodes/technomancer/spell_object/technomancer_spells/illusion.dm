/datum/technomancer_catalog/spell/illusion
	name = "Illusion"
	cost = 25
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/illusion)

/datum/spell_metadata/illusion
	name = "Illusion"
	desc = "Allows you to create and control a holographic illusion, that can take the form of most objects or entities."
	enhancement_desc = "Illusions will be made of hard light, allowing the interception of attacks, which can make them appear more realistic in a fight."
	aspect = ASPECT_LIGHT
	icon_state = "tech_illusion"
	spell_path = /obj/item/weapon/spell/technomancer/illusion
	cooldown = 1 SECOND
	var/atom/movable/thing_to_copy = null // An obj or mob that the spell will use to steal its appearance.
	var/mob/living/simple_mob/illusion/illusion = null // Ref to the active illusion, if one exists.

/datum/spell_metadata/illusion/get_spell_info()
	var/obj/item/weapon/spell/technomancer/illusion/spell = spell_path
	. = list()
	.["Copy Appearance Energy Cost"] = initial(spell.illusion_copy_energy_cost)
	.["Illusion Energy Cost"] = initial(spell.illusion_creation_energy_cost)


/obj/item/weapon/spell/technomancer/illusion
	name = "illusion"
	icon_state = "illusion"
	desc = "Now you can toy with the minds of the whole colony."
	cast_methods = CAST_RANGED | CAST_USE
	var/static/radial_speak = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_say")
	var/static/radial_emote = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_emote")
	var/static/radial_delete = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_reset")
	var/illusion_creation_energy_cost = 500
	var/illusion_copy_energy_cost = 500


/obj/item/weapon/spell/technomancer/illusion/on_ranged_cast(atom/hit_atom, mob/user)
	var/datum/spell_metadata/illusion/illusion_meta = meta

	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom
		if(AM == illusion_meta.illusion)
			user << 'sound/effects/pop.ogg' // Only the caster can hear this.
			QDEL_NULL(illusion_meta.illusion)
			return TRUE

		else if(pay_energy(illusion_copy_energy_cost))
			illusion_meta.thing_to_copy = AM
			update_icon()
			to_chat(user, span("notice", "You've copied \the [AM]'s appearance."))
			user << 'sound/weapons/flash.ogg' // Only the caster can hear this.
			return TRUE

	else if(istype(hit_atom, /turf))
		var/turf/T = hit_atom
		if(!illusion_meta.illusion)
			if(!illusion_meta.thing_to_copy)
				illusion_meta.thing_to_copy = user
			if(pay_energy(illusion_creation_energy_cost))
				illusion_meta.illusion = new(T)
				illusion_meta.illusion.copy_appearance(illusion_meta.thing_to_copy)
				if(check_for_scepter())
					illusion_meta.illusion.realistic = TRUE

				to_chat(user, span("notice", "An illusion of \the [illusion_meta.thing_to_copy] is made on \the [T]."))
				SEND_SOUND(user, 'sound/effects/pop.ogg') // Only the caster can hear this.
				return TRUE
		else
			var/datum/ai_holder/AI = illusion_meta.illusion.ai_holder
			AI.give_destination(new_destination = T, min_distance = 0)
			return TRUE
	return FALSE

/obj/item/weapon/spell/technomancer/illusion/on_use_cast(mob/user)
	var/datum/spell_metadata/illusion/illusion_meta = meta
	if(!illusion_meta.illusion)
		to_chat(span("warning", "You need an illusion active to use this form of casting. Click on a floor tile first."))
		return FALSE

	var/list/options = list()

	options["delete"] = radial_delete
	options["speak"] = radial_speak
	options["emote"] = radial_emote

	var/choice = show_radial_menu(user, src, options, require_near = TRUE)
	switch(choice)
		if("delete")
			QDEL_NULL(illusion_meta.illusion)
			to_chat(user, span("notice", "You dismiss your illusion."))
			SEND_SOUND(user, 'sound/weapons/flash.ogg') // Only the caster can hear this.
		if("speak")
			var/what_to_say = input(user, "What do you want \the [illusion_meta.illusion] to say?", "Illusion Speak") as null|text
			if(what_to_say)
				illusion_meta.illusion.say_verb(what_to_say) //Sanitize occurs inside say() already.
		if("emote")
			var/what_to_emote = sanitize(input(user, "What do you want \the [illusion_meta.illusion] to do?", "Illusion Emote") as null|text)
			if(what_to_emote)
				illusion_meta.illusion.custom_emote(user.emote_type, what_to_emote)
	return TRUE
