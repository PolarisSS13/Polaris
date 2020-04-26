// This is basically stolen summon item from TG.

/datum/technomancer_catalog/spell/bind_object
	name = "Bind Object"
	desc = "Binds a specific object that is adjacent to you, with an undetectable mark, allowing you to \
	teleport that object to yourself from almost anywhere. Only one object can be bound at a time."
	enhancement_desc = "If the bound object is inside a container, the whole container, along with its contents, will also be teleported to you if possible."
	cost = 100
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/bind_object)

/datum/spell_metadata/bind_object
	name = "Bind Object"
	icon_state = "tech_bind_object"
	spell_path = /obj/item/weapon/spell/technomancer/bind_object
	cooldown = 1 SECOND
	var/obj/bound_object = null // The thing to teleport back.

// Sets a specific object to be tracked by the spell, and tells the spell if the object gets deleted for whatever reason.
/datum/spell_metadata/bind_object/proc/set_bind(obj/O)
	if(bound_object) // Already got one.
		GLOB.destroyed_event.unregister(bound_object, src, /datum/spell_metadata/bind_object/proc/on_bound_object_destroyed)

	bound_object = O
	GLOB.destroyed_event.register(O, src, /datum/spell_metadata/bind_object/proc/on_bound_object_destroyed)

/datum/spell_metadata/bind_object/proc/on_bound_object_destroyed(obj/O)
	bound_object = null // One less reference to the object being deleted.


/obj/item/weapon/spell/technomancer/bind_object
	name = "bind object"
	icon_state = "bind_object"
	desc = "Never lose your Scepter again!"
	aspect = ASPECT_TELE
	cast_methods = CAST_MELEE | CAST_USE

/obj/item/weapon/spell/technomancer/bind_object/on_melee_cast(atom/hit_atom, mob/living/user)
	var/datum/spell_metadata/bind_object/bind_meta = meta

	if(!can_bind(hit_atom))
		to_chat(user, span("warning", "The properties of \the [hit_atom] make it not viable for this kind of teleportation, so binding it would be pointless."))
		return FALSE

	if(bind_meta.bound_object)
		if(hit_atom == bind_meta.bound_object)
			to_chat(user, span("warning", "\The [hit_atom] is already bound to your Core!"))
			return FALSE
		if(alert(user, "You already have \the [bind_meta.bound_object] bound to your Core. \
			Do you want to sever the connection to that, and instead bind \the [hit_atom]?", "Bind Overwrite Warning", "No", "Yes") == "No")
			return FALSE

	bind_meta.set_bind(hit_atom)

	to_chat(user, span("notice", "You've successfully bound \the [hit_atom] to your [core.name]. Now you can teleport it back to you whenever you want."))
	playsound(owner, 'sound/effects/magic/technomancer/generic_cast.ogg', 75, 1)
	return TRUE

/obj/item/weapon/spell/technomancer/bind_object/on_use_cast(mob/living/user)
	var/datum/spell_metadata/bind_object/bind_meta = meta
	if(!bind_meta.bound_object)
		to_chat(user, span("warning", "You never marked an object, or if you did, the object that was bound was destroyed entirely."))
		return FALSE

	if(!pay_energy(1000))
		to_chat(user, span("warning", "You don't have the energy reserves to do that."))
		return FALSE

	var/attempt_container_tele = FALSE
	if(check_for_scepter())
		attempt_container_tele = TRUE
	var/obj/tele_target = bind_meta.bound_object

	var/paranoia = 0 // Juuuuuuust incase.
	while(!isturf(tele_target.loc) && paranoia < 10)
		if(isliving(tele_target.loc))
			var/mob/living/L = tele_target.loc

			// Borgs get a special check to avoid ripping out modules from their bodies and causing a potential bug-pocolypse.
			if(isrobot(L))
				tele_target = bind_meta.bound_object
				break

			L.drop_from_inventory(tele_target, get_turf(L)) // So clothing will get stolen correctly.

		if(!attempt_container_tele)
			break

		if(!can_bind(tele_target.loc)) // Unbindable containers also can't be brought back, but the bound item will still arrive.
			break

		tele_target = tele_target.loc
		paranoia++

	if(!tele_target)
		to_chat(user, span("warning", "Something went wrong, and the spell seems to have lost your bound object despite having an \
			idea where it was a moment ago. You're either extremly unlucky and the object stopped existing mid-tele, \
			or you're the victim of a bug and should adminhelp."))
		return FALSE

	var/datum/teleportation/recall/bound_object/tele = new(tele_target, get_turf(user))
	if(!tele.teleport())
		to_chat(user, span("warning", "Something seems to be interfering with the teleport..."))
		return FALSE

	adjust_instability(10)
	delete_after_cast = TRUE

	// If possible, put the thing we got into our hands.
	if(istype(tele_target, /obj/item))
		dont_qdel_when_dropped = TRUE
		user.drop_item(src)
		src.forceMove(owner)
		user.put_in_hands(tele_target)
		user.visible_message(span("notice", "\The [user] takes hold of \a [tele_target] that appeared just now."))
		log_and_message_admins("has returned \the [bind_meta.bound_object][bind_meta.bound_object != tele_target ? ", along with \the [tele_target]" : ""], using [src].")

	return TRUE


/obj/item/weapon/spell/technomancer/bind_object/proc/can_bind(obj/O)
	if(!istype(O))
		return FALSE
	if(O.anchored)
		return FALSE
	if(istype(O, /obj/item))
		var/obj/item/I = O
		if(I.abstract) // Don't bind to grabs.
			return FALSE
	if(istype(O, /obj/item/weapon/holder))
		return FALSE
	if(istype(O, /obj/screen))
		return FALSE
	return TRUE