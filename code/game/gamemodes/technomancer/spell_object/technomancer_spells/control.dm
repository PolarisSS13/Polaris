/datum/technomancer_catalog/spell/control
	name = "Control"
	cost = 100
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/control)

/datum/spell_metadata/control
	name = "Control"
	desc = "This function allows you to exert control over simple-minded entities to an extent, such as spiders and carp.  \
	Controlled entities will not be hostile towards you, and you may direct them to move to specific areas or to attack specific \
	targets. This function will have no effect on entities of higher intelligence, such as humans and similar alien species, as it's \
	not true mind control, but merely pheromone synthesis for living animals, and electronic hacking for simple robots. The green web \
	around the entity is merely a hologram used to allow the user to know if the creature is safe or not."
	enhancement_desc = "Using the scepter inhand alongside Control will teleport all controlled entities to you, \
	one at a time."
	aspect = ASPECT_BIOMED
	icon_state = "tech_control"
	spell_path = /obj/item/weapon/spell/technomancer/control
	cooldown = 1 SECOND
	var/list/selected_weakrefs = list()
	var/set_hostility = FALSE // If true, selected mobs become hostile and attack like regular simplemobs.
	var/static/image/select_overlay = null

/datum/spell_metadata/control/get_spell_info()
	var/obj/item/weapon/spell/technomancer/control/spell = spell_path
	. = list()
	.["Selection Energy Cost"] = initial(spell.select_energy_cost)
	.["Scepter Teleport Delay"] = "[DisplayTimeText(initial(spell.scepter_teleport_delay))] per selected entity"
	.["Scepter Teleport Energy Cost"] = initial(spell.scepter_teleport_cost)
	.["Scepter Teleport Instability Cost"] = initial(spell.scepter_teleport_instability)


/datum/spell_metadata/control/New()
	if(!select_overlay)
		select_overlay = image('icons/obj/spells.dmi',"controlled")

// Removes mobs who die or get deleted from the weakref list.
/datum/spell_metadata/control/proc/on_selected_mob_stat_changed(mob/living/L, old_stat, new_stat)
	if(new_stat == DEAD)
		if(L.weakref)
			selected_weakrefs -= L.weakref
			L.cut_overlay(select_overlay, TRUE)
		GLOB.destroyed_event.unregister(L, src, /datum/spell_metadata/control/proc/on_selected_mob_deleted)
		GLOB.stat_set_event.unregister(L, src, /datum/spell_metadata/control/proc/on_selected_mob_stat_changed)

/datum/spell_metadata/control/proc/on_selected_mob_deleted(mob/living/L)
	if(L.weakref)
		selected_weakrefs -= L.weakref
	GLOB.destroyed_event.unregister(L, src, /datum/spell_metadata/control/proc/on_selected_mob_deleted)
	GLOB.stat_set_event.unregister(L, src, /datum/spell_metadata/control/proc/on_selected_mob_stat_changed)


/obj/item/weapon/spell/technomancer/control
	name = "control"
	icon_state = "control"
	desc = "Now you can command your own army!"
	cast_methods = CAST_RANGED|CAST_USE
	var/allowed_mob_classes = MOB_CLASS_ANIMAL|MOB_CLASS_SYNTHETIC|MOB_CLASS_ILLUSION
	var/select_energy_cost = 200
	var/scepter_teleport_delay = 1 SECOND
	var/scepter_teleport_instability = 1
	var/scepter_teleport_cost = 100

// Ranged click designates things to get moved to, followed, or attacked, based on context.
/obj/item/weapon/spell/technomancer/control/on_ranged_cast(atom/hit_atom, mob/living/user)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom

		// Clicking on themselves.
		if(L == user)
			var/datum/spell_metadata/control/control_meta = meta
			if(!control_meta.selected_weakrefs.len)
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
			if(pay_energy(select_energy_cost))
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

// Self casting toggles hostility.
/obj/item/weapon/spell/technomancer/control/on_use_cast(mob/living/user)
	var/datum/spell_metadata/control/control_meta = meta

	control_meta.set_hostility = !control_meta.set_hostility

	for(var/weakref/WR in control_meta.selected_weakrefs)
		var/mob/living/L = WR.resolve()
		if(!istype(L))
			WR -= control_meta.selected_weakrefs
			continue

		var/datum/ai_holder/AI = L.ai_holder
		if(!istype(AI))
			continue


		AI.hostile = control_meta.set_hostility

	if(control_meta.set_hostility)
		to_chat(user, span("notice", "You grant your controlled minions autonomy in choosing targets."))
		playsound(owner, 'sound/effects/magic/technomancer/death.ogg', 75, 1)
	else
		to_chat(user, span("notice", "You reign in your controlled minions' ability to choose targets."))
		playsound(owner, 'sound/effects/magic/technomancer/healing_cast.ogg', 75, 1)

	return TRUE

// Scepter use casting teleports all selected mobs to you over time.
/obj/item/weapon/spell/technomancer/control/on_scepter_use_cast(mob/user)
	. = FALSE
	var/datum/spell_metadata/control/control_meta = meta
	if(!control_meta.selected_weakrefs.len)
		to_chat(user, span("warning", "There's nothing to teleport to you."))
		return FALSE

	var/mobs_left_to_teleport = control_meta.selected_weakrefs.len

	while(mobs_left_to_teleport)
		var/weakref/WR = control_meta.selected_weakrefs[mobs_left_to_teleport]
		var/mob/living/L = WR.resolve()
		if(!istype(L))
			mobs_left_to_teleport--
			continue

		var/turf/T = get_turf(user)
		var/datum/teleportation/recall/tele = new(L, T)
		tele.choose_destination(T, 3)
		var/obj/effect/temp_visual/summoning/visual = new(tele.destination)

		if(do_after(user, scepter_teleport_delay, get_turf(user)) && pay_energy(scepter_teleport_cost))
			tele.teleport()
			qdel(visual)
			mobs_left_to_teleport--
			adjust_instability(scepter_teleport_instability)
			. = TRUE

		else
			qdel(visual)
			break


/obj/item/weapon/spell/technomancer/control/proc/is_selected(mob/living/L)
	var/datum/spell_metadata/control/control_meta = meta
	return L.weakref in control_meta.selected_weakrefs

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

	var/datum/spell_metadata/control/control_meta = meta

	var/datum/ai_holder/AI = L.ai_holder
	AI.hostile = control_meta.set_hostility // The Technomancer chooses the target, not the AI.
	AI.retaliate = TRUE
	AI.wander = FALSE
	AI.forget_everything()

	if(istype(L, /mob/living/simple_mob))
		var/mob/living/simple_mob/SM = L

		// So selected mobs don't think the apprentice looks tasty.
		for(var/datum/mind/technomancer_mind in technomancers.current_antagonists)
			SM.friends |= technomancer_mind.current

	to_chat(owner, span("notice", "\The [L] is now under your (limited) control."))

	L.add_overlay(control_meta.select_overlay, TRUE)
	playsound(L, 'sound/effects/magic/technomancer/magic.ogg', 75, 1)
	playsound(owner, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)
	control_meta.selected_weakrefs += weakref(L)
	GLOB.destroyed_event.register(L, control_meta, /datum/spell_metadata/control/proc/on_selected_mob_deleted)
	GLOB.stat_set_event.register(L, control_meta, /datum/spell_metadata/control/proc/on_selected_mob_stat_changed)
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

		if(istype(L, /mob/living/simple_mob))
			var/mob/living/simple_mob/SM = L

			for(var/datum/mind/technomancer_mind in technomancers.current_antagonists)
				SM.friends -= technomancer_mind.current

		to_chat(owner, span("notice", "You free \the [L] from your grasp."))

	var/datum/spell_metadata/control/control_meta = meta
	L.cut_overlay(control_meta.select_overlay, TRUE)
	playsound(L, 'sound/effects/magic/technomancer/magic.ogg', 75, 1)
	playsound(owner, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)
	control_meta.selected_weakrefs -= L.weakref
	GLOB.destroyed_event.unregister(L, control_meta, /datum/spell_metadata/control/proc/on_selected_mob_deleted)
	GLOB.stat_set_event.unregister(L, control_meta, /datum/spell_metadata/control/proc/on_selected_mob_stat_changed)

/obj/item/weapon/spell/technomancer/control/proc/relay_command(atom/target, command_string, proc_call)
	var/datum/spell_metadata/control/control_meta = meta
	. = 0
	for(var/thing in control_meta.selected_weakrefs)
		var/weakref/WR = thing
		var/mob/living/L = WR.resolve()
		if(!istype(L) || QDELETED(L)) // Prune the list if the reference is gone.
			control_meta.selected_weakrefs -= WR
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
	playsound(owner, 'sound/effects/magic/technomancer/magic.ogg', 75, 1)

/obj/item/weapon/spell/technomancer/control/proc/attack_command(mob/living/target)
	. = relay_command(target, "attack", /datum/ai_holder/proc/give_target)
	playsound(owner, 'sound/effects/magic/technomancer/magic.ogg', 75, 1)

/obj/item/weapon/spell/technomancer/control/proc/move_command(turf/destination)
	. = relay_command(destination, "move towards", /datum/ai_holder/proc/give_destination)
	playsound(owner, 'sound/effects/magic/technomancer/magic.ogg', 75, 1)