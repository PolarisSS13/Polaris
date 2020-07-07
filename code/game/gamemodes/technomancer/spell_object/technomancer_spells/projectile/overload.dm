/datum/technomancer_catalog/spell/overload
	name = "Overload"
	cost = 100
	category = OFFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/projectile/overload)

/datum/spell_metadata/projectile/overload
	name = "Overload"
	desc = "Fires a bolt of highly unstable energy, that does damage equal to a percentage of the technomancer's current reserve of energy. \
	This energy pierces all known armor. Energy cost is equal to a percentage of maximum core charge."
	enhancement_desc = "Improves energy scaling."
	aspect = ASPECT_UNSTABLE
	icon_state = "tech_overload"
	cooldown = 1 SECOND
	spell_path = /obj/item/weapon/spell/technomancer/projectile/overload


/datum/spell_metadata/projectile/overload/get_spell_info()
	var/obj/item/weapon/spell/technomancer/projectile/overload/spell = spell_path
	. = list()
	.["Core Charge as Damage"] = "[initial(spell.damage_energy_scaling) * 100]%"
	.["Scepter Core Charge as Damage"] = "[initial(spell.scepter_damage_energy_scaling) * 100]%"
	.["Energy Cost per Shot"] = "[initial(spell.max_energy_percentage_cost) * 100]% of Max Core Energy"
	. += ..()


/obj/item/weapon/spell/technomancer/projectile/overload
	name = "overload"
	icon_state = "overload"
	desc = "Hope your Core's full."
	spell_projectile = /obj/item/projectile/overload
	energy_cost_per_shot = 0 // Gets changed before every shot.
	instability_per_shot = 12
	fire_sound = 'sound/effects/supermatter.ogg'
	var/energy_before_firing = 0
	var/damage_energy_scaling = 0.003
	var/scepter_damage_energy_scaling = 0.004
	var/max_energy_percentage_cost = 0.1

/obj/item/weapon/spell/technomancer/projectile/overload/tweak_projectile(obj/item/projectile/overload/P, atom/target, mob/living/user)
	var/scaling = check_for_scepter() ? scepter_damage_energy_scaling : damage_energy_scaling
	P.damage = round(energy_before_firing * scaling)

/obj/item/weapon/spell/technomancer/projectile/overload/on_ranged_cast(atom/hit_atom, mob/living/user)
	energy_cost_per_shot = round(core.max_energy * max_energy_percentage_cost)
	energy_before_firing = core.energy
	..()

/obj/item/projectile/overload
	name = "overloaded bolt"
	icon_state = "dark_pellet"
	icon_scale_x = 2
	icon_scale_y = 2
	damage_type = BURN
	armor_penetration = 100
	impact_effect_type = /obj/effect/temp_visual/impact_effect/purple_laser
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
