/datum/technomancer_catalog/spell/shield
	name = "Shield"
	cost = 100
	category = DEFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/shield)

/datum/spell_metadata/shield
	name = "Shield"
	desc = "Emits a protective shield fron your hand in front of you, \
	which will protect you from almost anything able to harm you, \
	so long as you can power it.  Stronger attacks blocked cost more energy to sustain. \
	Note that holding two shields will make blocking more energy efficent."
	enhancement_desc = "Blocking costs no energy."
	aspect = ASPECT_FORCE
	icon_state = "tech_shield"
	spell_path = /obj/item/weapon/spell/technomancer/shield

/datum/spell_metadata/shield/get_spell_info()
	var/obj/item/weapon/spell/technomancer/shield/spell = spell_path
	. = list()
	.["Energy Cost Per Damage"] = initial(spell.base_energy_per_damage_cost)
	.["Small User Energy Cost Multiplier"] = initial(spell.small_mob_energy_multiplier)
	.["Double Shield Energy Cost Multiplier"] = initial(spell.double_shield_energy_multiplier)
	.["Instability Cost Per Block"] = initial(spell.block_instability_cost)


/obj/item/weapon/spell/technomancer/shield
	name = "energy shield"
	icon_state = "shield"
	desc = "A very protective combat shield that'll stop almost anything from hitting you, at least from the front."
	cast_methods = CAST_USE
	toggled = TRUE
	var/base_energy_per_damage_cost = 30 // How much energy is needed to stop one unit of damage.
	var/small_mob_energy_multiplier = 0.75 // Tesh get more efficent shields due to their shield being smaller in size.
	var/double_shield_energy_multiplier = 0.5 // Holding two shields at once makes it more efficent.
	var/block_instability_cost = 1

/obj/item/weapon/spell/technomancer/shield/on_spell_given(mob/user)
	set_light(3, 2, l_color = "#006AFF")
	playsound(owner, 'sound/effects/magic/technomancer/repulse.ogg', 75, TRUE)

/obj/item/weapon/spell/technomancer/shield/Destroy()
	playsound(owner, 'sound/effects/magic/technomancer/zap_hit.ogg', 75, TRUE)
	return ..()

// Using inhand toggles direction locking for a little bit of QoL.
/obj/item/weapon/spell/technomancer/shield/on_use_cast(mob/user)
	SEND_SOUND(user, 'sound/effects/pop.ogg')
	if(!user.facing_dir)
		user.set_face_dir(user.dir)
		to_chat(user, span("notice", "You lock your facing direction to the [dir2text(user.facing_dir)]. \
		You can return to turning normally by using this function inhand again, or using the <b>Face Direction</b> verb at any time."))
		return TRUE

	user.set_face_dir(null)
	to_chat(user, span("notice", "You can now turn freely."))
	return TRUE

/obj/item/weapon/spell/technomancer/shield/handle_shield(mob/user, damage, atom/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack")
	if(user.incapacitated())
		return FALSE

	var/damage_to_energy_cost = base_energy_per_damage_cost * damage

	if(check_for_scepter())
		damage_to_energy_cost = 0

	else
		if(issmall(user))
			damage_to_energy_cost *= small_mob_energy_multiplier

		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			if(istype(H.get_other_hand(src), src.type)) // Two shields in both hands.
				damage_to_energy_cost *= double_shield_energy_multiplier

	if(!pay_energy(damage_to_energy_cost))
		to_chat(owner, span("danger", "Your shield fades due to lack of energy!"))
		qdel(src)
		return FALSE

	var/bad_arc = reverse_direction(user.dir) // Arc of directions from which we cannot block.
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		user.visible_message(span("danger", "\The [user] blocks [attack_text] with \the [src]!"))
		playsound(user, 'sound/weapons/blade1.ogg', 50, 1)
		adjust_instability(block_instability_cost)
		return TRUE

	return FALSE
