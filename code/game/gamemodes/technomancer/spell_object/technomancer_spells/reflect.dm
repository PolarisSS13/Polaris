/datum/technomancer_catalog/spell/reflect
	name = "Reflect"
	cost = 100
	category = DEFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/reflect)

/datum/spell_metadata/reflect
	name = "Reflect"
	desc = "Emits a protective portal-shield from your hand in front of you, which when attacked, will cause you to redirect \
	all attacks from in front of you to the attacker for a short period of time."
	enhancement_desc = "Reflected projectiles are made more powerful and more accurate."
	aspect = ASPECT_TELE
	icon_state = "tech_reflect"
	spell_path = /obj/item/weapon/spell/technomancer/reflect

/datum/spell_metadata/reflect/get_spell_info()
	var/obj/item/weapon/spell/technomancer/reflect/spell = spell_path
	. = list()
	.["Reflection Period"] = DisplayTimeText(initial(spell.reflection_period))
	.["Scepter Reflection Damage Multiplier"] = "[initial(spell.scepter_reflection_damage_multiplier) * 100]%"
	.["Energy Cost"] = initial(spell.reflect_energy_cost)
	.["Instability Cost"] = initial(spell.reflect_instability_cost)


/obj/item/weapon/spell/technomancer/reflect
	name = "reflect"
	desc = "A very protective combat portal-shield that'll reflect the next attack at the unfortunate person who tries to shoot you."
	icon_state = "reflect"
	toggled = 1
	var/reflecting = FALSE
	var/reflect_energy_cost = 1000
	var/reflect_instability_cost = 10
	var/reflection_period = 3 SECONDS
	var/scepter_reflection_damage_multiplier = 1.5


/obj/item/weapon/spell/technomancer/reflect/on_spell_given(mob/user)
	playsound(owner, 'sound/effects/magic/technomancer/teleport.ogg', 75, TRUE)
	to_chat(user, span("notice", "You will reflect the next attack against you from in front of you."))

/obj/item/weapon/spell/technomancer/reflect/Destroy()
	playsound(owner, 'sound/effects/magic/technomancer/zap_hit.ogg', 75, TRUE)
	return ..()

/obj/item/weapon/spell/technomancer/reflect/handle_shield(mob/user, damage, atom/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack")
	if(user.incapacitated())
		return 0

	if(!reflecting) // Only pay once.
		if(!pay_energy(reflect_energy_cost))
			to_chat(owner, span("warning", "Your portal is forced to close due to lack of energy!"))
			qdel(src)
			return 0

		reflecting = TRUE
		adjust_instability(reflect_instability_cost)
		QDEL_IN(src, reflection_period)
		to_chat(user, span("notice", "Your portal has activated, and will reflect attacks back for the next few seconds, before expiring."))

	var/bad_arc = reverse_direction(user.dir) // Arc of directions from which we cannot block.
	if(check_shield_arc(user, bad_arc, damage_source, attacker))

		// Reflecting projectiles.
		if(istype(damage_source, /obj/item/projectile))
			var/obj/item/projectile/P = damage_source

			if(P.starting && !P.reflected)
				user.visible_message(span("danger", "\The [P] enters \the [user]'s portal-shield, coming back out towards \the [attacker]!"))

				var/turf/current_loc = get_turf(user)

				// Redirect the projectile.
				P.redirect(P.starting.x, P.starting.y, current_loc, user)
				P.reflected = TRUE
				P.permutated += user
				P.permutated -= P.firer
				P.firer = user

				if(check_for_scepter())
					P.damage *= scepter_reflection_damage_multiplier
					// In case they reflected a taser. Most real projectiles have this at 0 so nothing will happen.
					P.agony *= scepter_reflection_damage_multiplier
					to_chat(span("notice", "\The [src] empowers \the [P] as it leaves the portal-shield."))
					playsound(owner, 'sound/effects/magic/technomancer/magic.ogg', 75, TRUE)

				// Visuals and sound effects.
				reflect_effects()

				// Tell the admins so they don't think someone is shooting themselves on purpose.
				log_and_message_admins("[user] reflected [attacker]'s projectile ([P.type]) back at them.")

				return PROJECTILE_CONTINUE // Complete projectile permutation

		// Reflecting a melee attack.
		else if(istype(damage_source, /obj/item))
			var/obj/item/I = damage_source
			if(attacker)
				I.attack(attacker)
				attacker.visible_message(span("danger", "\The [attacker]'s [I] goes through \the [user]'s \
				portal-shield in one location, then comes out on the same side in a slightly different position, \
				causing \the [attacker] to hit themselves!"))

				// Visuals etc.
				reflect_effects()

				// Admins again.
				log_and_message_admins("[user] reflected [attacker]'s melee attack ([I.type]) back at them.")

		return 1
	return 0

/obj/item/weapon/spell/technomancer/reflect/proc/reflect_effects()
	playsound(owner, 'sound/effects/magic/technomancer/blink.ogg', 75, TRUE)
	new /obj/effect/temp_visual/phase_in(get_turf(owner))


/*
	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))

		if(istype(damage_source, /obj/item/projectile))
			var/obj/item/projectile/P = damage_source

			if(P.starting && !P.reflected)
				visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

				var/turf/curloc = get_turf(user)

				// redirect the projectile
				P.redirect(P.starting.x, P.starting.y, curloc, user)
				P.reflected = 1
				if(check_for_scepter())
					P.damage = P.damage * 1.5

				spark_system.start()
				playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
				// now send a log so that admins don't think they're shooting themselves on purpose.
				log_and_message_admins("[user] reflected [attacker]'s attack back at them.")

				if(!reflecting)
					reflecting = 1
					spawn(2 SECONDS) //To ensure that most or all of a burst fire cycle is reflected.
						to_chat(owner, "<span class='danger'>Your shield fades due being used up!</span>")
						qdel(src)

				return PROJECTILE_CONTINUE // complete projectile permutation

		else if(istype(damage_source, /obj/item/weapon))
			var/obj/item/weapon/W = damage_source
			if(attacker)
				W.attack(attacker)
				to_chat(attacker, "<span class='danger'>Your [damage_source.name] goes through \the [src] in one location, comes out \
				on the same side, and hits you!</span>")

				spark_system.start()
				playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

				log_and_message_admins("[user] reflected [attacker]'s attack back at them.")

				if(!reflecting)
					reflecting = 1
					spawn(2 SECONDS) //To ensure that most or all of a burst fire cycle is reflected.
						to_chat(owner, "<span class='danger'>Your shield fades due being used up!</span>")
						qdel(src)
		return 1
	return 0

*/