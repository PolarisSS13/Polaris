/datum/technomancer_catalog/spell/bolt_of_light
	name = "Bolt of Light"
	cost = 50
	category = UTILITY_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/projectile/bolt_of_light)

/datum/spell_metadata/projectile/bolt_of_light
	name = "Bolt of Light"
	desc = "Shoots a bolt that causes anything hit to apply the Corona effect, which makes them glow brightly for awhile, \
	stealth to be impossible, and be easier to hit. The bolt itself is otherwise harmless."
	aspect = ASPECT_LIGHT
	icon_state = "tech_bolt_of_light"
	cooldown = 1 SECOND
	spell_path = /obj/item/weapon/spell/technomancer/projectile/bolt_of_light

/obj/item/weapon/spell/technomancer/projectile/bolt_of_light
	name = "bolt of light"
	icon_state = "bolt_of_light"
	desc = "Light 'em up."
	spell_projectile = /obj/item/projectile/energy/bolt_of_light
	energy_cost_per_shot = 250
	instability_per_shot = 5
	fire_sound = 'sound/effects/magic/technomancer/generic_cast.ogg'

/obj/item/projectile/energy/bolt_of_light
	name = "bolt of light"
	icon_state = "fuel-supermatter"
	damage = 0
	accuracy = 200
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	modifier_type_to_apply = /datum/modifier/technomancer/corona
	modifier_duration = 30 SECONDS


// This modifier existed before COVID-19, just so you know.
// It's actually one of many things stolen from Stone Soup.
/datum/modifier/technomancer/corona
	name = "corona"
	desc = "You appear to be glowing really bright. It doesn't seem to hurt, however hiding will be impossible."

	on_created_text = "<span class='warning'>You start to glow very brightly!</span>"
	on_expired_text = "<span class='notice'>Your glow has ended.</span>"
	evasion = -30
	stacks = MODIFIER_STACK_EXTEND
	filter_parameters = list(type = "outline", size = 1, color = "#FFFF00", flags = OUTLINE_SHARP)

/datum/modifier/technomancer/corona/tick()
	holder.break_cloak()
	animate(filter_instance, size = 3, color = "#FF0000", time = 0.25 SECONDS)
	animate(size = 1, color = "#FFFF00", time = 0.25 SECONDS)
