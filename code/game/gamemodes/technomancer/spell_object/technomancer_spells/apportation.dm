/datum/technomancer_catalog/spell/apportation
	name = "Apportation"
	cost = 25
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/apportation)

/datum/spell_metadata/apportation
	name = "Apportation"
	desc = "This allows you to teleport objects into your hand, \
	ignoring windows and other barriers."
	enhancement_desc = "Range is unlimited."
	aspect = ASPECT_TELE
	icon_state = "tech_apportation"
	spell_path = /obj/item/weapon/spell/technomancer/apportation

/datum/spell_metadata/apportation/get_spell_info()
	var/obj/item/weapon/spell/technomancer/apportation/spell = spell_path
	. = list()
	.["Energy Cost"] = initial(spell.apport_energy_cost)
	.["Instability Cost"] = initial(spell.apport_instability_cost)


/obj/item/weapon/spell/technomancer/apportation
	name = "apportation"
	icon_state = "apportation"
	desc = "Allows you to reach through Bluespace with your hand, and grab something, bringing it to you instantly."
	cast_methods = CAST_RANGED
	var/apport_energy_cost = 200
	var/apport_instability_cost = 1

/obj/item/weapon/spell/technomancer/apportation/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom

		if(!AM.loc) //Don't teleport HUD telements to us.
			return FALSE
		if(AM.anchored)
			to_chat(user, span("warning", "\The [hit_atom] is firmly secured and anchored, you can't move it!"))
			return FALSE

		if(!within_range(hit_atom) && !check_for_scepter())
			to_chat(user, span("warning", "\The [hit_atom] is too far away."))
			return FALSE

		if(istype(hit_atom, /obj/item))
			var/obj/item/I = hit_atom

			var/datum/teleportation/apportation/tele = new(I, get_turf(user))
			if(pay_energy(apport_energy_cost) && tele.teleport())
				dont_qdel_when_dropped = TRUE
				user.drop_item(src)
				src.forceMove(owner)
				user.put_in_hands(I)
				user.visible_message(span("notice", "\A [I] appears in \the [user]'s hand!"))
				log_and_message_admins("has stolen [I] with [src].")
				adjust_instability(apport_instability_cost)
				qdel(src)
				return TRUE
	return FALSE