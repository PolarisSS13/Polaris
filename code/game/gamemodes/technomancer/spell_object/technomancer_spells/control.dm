/datum/technomancer_catalog/spell/control
	name = "Control"
	desc = "This function allows you to exert control over simple-minded entities to an extent, such as spiders and carp.  \
	Controlled entities will not be hostile towards you, and you may direct them to move to specific areas or to attack specific \
	targets. This function will have no effect on entities of higher intelligence, such as humans and similar alien species, as it's \
	not true mind control, but merely pheromone synthesis for living animals, and electronic hacking for simple robots. The green web \
	around the entity is merely a hologram used to allow the user to know if the creature is safe or not."
	cost = 100
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/control)

/datum/spell_metadata/control
	name = "Control"
	icon_state = "tech_control"
	spell_path = /obj/item/weapon/spell/technomancer/control
	cooldown = 1 SECOND
	var/list/selected_weakrefs = list()


/obj/item/weapon/spell/technomancer/control
	name = "control"
	icon_state = "control"
	desc = "Now you can command your own army!"
	cast_methods = CAST_RANGED|CAST_USE
	aspect = ASPECT_BIOMED //Not sure if this should be something else.
	var/allowed_mob_classes = MOB_CLASS_ANIMAL|MOB_CLASS_SYNTHETIC
	var/static/image/control_overlay = null

/obj/item/weapon/spell/technomancer/control/Initialize()
	if(!control_overlay)
		control_overlay = image('icons/obj/spells.dmi',"controlled")
	return ..()

/obj/item/weapon/spell/technomancer/control/on_ranged_cast(atom/hit_atom, mob/living/user)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom

		// Clicking on themselves.
		if(L == user)
			var/datum/spell_metadata/control/meta = get_meta()
			if(!meta.selected_weakrefs.len)
				to_chat(user, span("warning", "This function doesn't work on higher-intelligence entities, \
				however since you're trying to use it on yourself, perhaps you're an exception? \
				Regardless, nothing happens."))
				return FALSE
			else
				return follow_command(L)

		// Clicking on allies.
		if(is_ally(L))
			return follow_command(L)

		// Selection.
		if(L.mob_class & allowed_mob_classes)
			if(is_selected(L))
				return deselect(L) // Deselects are free.
			if(pay_energy(200))
				return select(L)

		else // Can't be selected, meaning they could be attacked.
			return attack_command(L)

	// Clicking on turfs.
	if(isturf(hit_atom))
		var/turf/T = hit_atom
		if(T.density) // Bash down the wall.
			return attack_command(T)
		// Otherwise just move to the floor.
		return move_command(T)

	// Clicking on objects.
	if(isobj(hit_atom))
		var/obj/O = hit_atom
		return attack_command(O)

	return FALSE

/obj/item/weapon/spell/technomancer/control/proc/is_selected(mob/living/L)
	var/datum/spell_metadata/control/meta = get_meta()
	return L.weakref in meta.selected_weakrefs

/obj/item/weapon/spell/technomancer/control/proc/select(mob/living/L)
	if(L.client)
		to_chat(owner, span("warning", "\The [L] seems to resist you!"))
		to_chat(L, span("danger", "\The [owner] attempted to fool you into serving them, but you know better."))
		return FALSE

	if(!(L.mob_class & allowed_mob_classes))
		to_chat(owner, span("warning", "This won't work on that kind of thing."))
		return FALSE

	if(!L.has_AI())
		to_chat(owner, span("warning", "\The [L] seems too dim for this to work on them."))
		return FALSE

	var/datum/ai_holder/AI = L.ai_holder
	AI.hostile = FALSE // The Technomancer chooses the target, not the AI.
	AI.retaliate = TRUE
	AI.wander = FALSE
	AI.forget_everything()

	to_chat(owner, span("notice", "\The [L] is now under your (limited) control."))

	L.add_overlay(control_overlay, TRUE)
	var/datum/spell_metadata/control/meta = get_meta()
	meta.selected_weakrefs += weakref(L)
	return TRUE


/obj/item/weapon/spell/technomancer/control/proc/deselect(var/mob/living/L)
	if(!istype(L))
		return FALSE // In case the mob got deleted while dying or something.
	if(!is_selected(L))
		return FALSE

	if(L.has_AI())
		var/datum/ai_holder/AI = L.ai_holder
		AI.hostile = initial(AI.hostile)
		AI.retaliate = initial(AI.retaliate)
		AI.wander = initial(AI.wander)
		AI.forget_everything()

		to_chat(owner, span("notice", "You free \the [L] from your grasp."))

	L.cut_overlay(control_overlay, TRUE)
	var/datum/spell_metadata/control/meta = get_meta()
	meta.selected_weakrefs -= L.weakref

/obj/item/weapon/spell/technomancer/control/proc/relay_command(atom/target, command_string, proc_call)
	var/datum/spell_metadata/control/meta = get_meta()
	. = 0
	for(var/thing in meta.selected_weakrefs)
		var/weakref/WR = thing
		var/mob/living/L = WR.resolve()
		if(!istype(L) || QDELETED(L)) // Prune the list if the reference is gone.
			meta.selected_weakrefs -= WR
			continue
		if(L.stat == DEAD)
			deselect(L)
			continue

		var/datum/ai_holder/AI = L.ai_holder
		call(AI, proc_call)(target)
		.++

	if(.)
		to_chat(owner, span("notice", "You command [.] [. > 1 ? "entities" : "entity"] to [command_string] \the [target]."))
	else
		to_chat(owner, span("warning", "You don't have anything under your command to [command_string] \the [target]."))

/obj/item/weapon/spell/technomancer/control/proc/follow_command(mob/living/target)
	. = relay_command(target, "follow", /datum/ai_holder/proc/set_follow)

/obj/item/weapon/spell/technomancer/control/proc/attack_command(mob/living/target)
	. = relay_command(target, "attack", /datum/ai_holder/proc/give_target)

/obj/item/weapon/spell/technomancer/control/proc/move_command(turf/destination)
	. = relay_command(destination, "move towards", /datum/ai_holder/proc/give_destination)