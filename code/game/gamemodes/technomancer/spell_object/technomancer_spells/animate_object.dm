/datum/technomancer_catalog/spell/animate_object
	name = "Animate Object"
	cost = 100
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/animate_object, /datum/spell_metadata/abjuration)

/datum/spell_metadata/animate_object
	name = "Animate Object"
	desc = "Brings a targeted object \"\"to life\"\" by infusing it with a force field that makes the object \
	glow, float, and is able to be directed by a very basic intelligence in order to attack everyone who is not \
	a Technomancer or an ally to them. The combat performance of an animated object varies based on what kind of \
	object is animated. Animated objects will cease being animated if they suffer from too much \
	harm, dropping the object onto the ground. This also occurs if an animated gun runs out of ammo and cannot self-recharge. \
	Each animated object takes one summon slot, or three if it is a ranged weapon."
	aspect = ASPECT_FORCE
	icon_state = "tech_animate_object"
	spell_path = /obj/item/weapon/spell/technomancer/animate_object
	cooldown = 1 SECOND

/datum/spell_metadata/animate_object/get_spell_info()
	var/obj/item/weapon/spell/technomancer/animate_object/spell = spell_path
	. = list()
	.["Summon Slot Cost"] = initial(spell.default_summon_slot_cost)
	.["Gun Summon Slot Cost"] = initial(spell.gun_summon_slot_cost)
	.["Energy Cost"] = initial(spell.animate_energy_cost)
	.["Instability Cost"] = initial(spell.animate_instability_cost)


/obj/item/weapon/spell/technomancer/animate_object
	name = "animate object"
	desc = "A quick trip to the armory and you'll have some new friends!"
	icon_state = "animate_object"
	cast_methods = CAST_RANGED
	var/default_summon_slot_cost = 1
	var/gun_summon_slot_cost = 3
	var/animate_energy_cost = 500
	var/animate_instability_cost = 5

/obj/item/weapon/spell/technomancer/animate_object/on_ranged_cast(atom/hit_atom, mob/user)
	if(!istype(hit_atom, /obj))
		to_chat(user, span("warning", "\The [hit_atom] cannot be animated."))
		return FALSE

	var/obj/O = hit_atom
	if(O.anchored)
		to_chat(user, span("warning", "\The [O] is anchored to the floor, and animating it would be pointless."))
		return FALSE

	var/summon_slot_cost = istype(hit_atom, /obj/item/weapon/gun) ? gun_summon_slot_cost : default_summon_slot_cost


	if(!core.can_afford_summon_slot(summon_slot_cost))
		to_chat(user, span("warning", "\The [core] on your back can't support more animated objects."))
		return FALSE

	if(!pay_energy(animate_energy_cost))
		to_chat(user, span("warning", "You need more energy to be able to animate this."))
		return FALSE

	var/mob/living/simple_mob/artificial_construct/animated_object/technomancer/animated = new(get_turf(O), O)
	core.add_summon_slot(animated, summon_slot_cost)
	adjust_instability(animate_instability_cost)

	playsound(animated, 'sound/effects/magic/technomancer/repulse.ogg', 75, TRUE)
	playsound(user, 'sound/effects/magic/technomancer/staff_animation.ogg', 75, TRUE)

	return TRUE