// Aegis spells give an armor buff to the target for awhile, typically offering immunity in the specific aspect.
// Only one can exist on a target at a time.

/datum/technomancer_catalog/spell/elemental_aegises
	name = "Elemental Aegises" // `Aegides` is also apparently a plural form of `aegis`.
	desc = "Contains several types of functions which protect from specific types of harm. \
	Only one type can be on someone at a time."
	cost = 100
	category = DEFENSIVE_SPELLS
	spell_metadata_paths = list(/datum/spell_metadata/modifier/aegis/fire, /datum/spell_metadata/modifier/aegis/frost, /datum/spell_metadata/modifier/aegis/shock)

// Generic aegis type.
/datum/spell_metadata/modifier/aegis

/datum/spell_metadata/modifier/aegis/get_spell_info()
	var/obj/item/weapon/spell/technomancer/modifier/aegis/spell = spell_path
	// Sadly we can't use `initial()` for lists since they're initialized at runtime.
	var/modifier_type = initial(spell.modifier_type)
	var/datum/modifier/aegis/modifier = new modifier_type()

	. = list()
	if(!isnull(modifier.heat_protection))
		.["Heat Protection"] = "[initial(modifier.heat_protection) * 100]%"
	if(!isnull(modifier.cold_protection))
		.["Cold Protection"] = "[initial(modifier.cold_protection) * 100]%"
	if(!isnull(modifier.siemens_coefficient))
		.["Shock Protection"] = "[(1 - initial(modifier.siemens_coefficient)) * 100]%"
	var/list/armor = modifier.armor_percent.Copy()
	for(var/thing in armor)
		.["Armor Added: [uppertext(thing)]"] = "[armor[thing]]%"
	. += ..()

/obj/item/weapon/spell/technomancer/modifier/aegis
	cast_methods = CAST_RANGED
	modifier_duration = 10 MINUTES
	modifier_energy_cost = 500
	modifier_instability_cost = 5
	delete_after_cast = TRUE

/obj/item/weapon/spell/technomancer/modifier/aegis/give_modifier(mob/living/L)
	L.remove_modifiers_of_type(/datum/modifier/aegis) // Get rid of the other aegis modifiers.
	return ..(L) // Apply the modifier.

/datum/modifier/aegis
	stacks = MODIFIER_STACK_EXTEND
	technomancer_dispellable = TRUE



// Fire Aegis.
/datum/spell_metadata/modifier/aegis/fire
	name = "Fire Aegis"
	desc = "Places an energy field around the target that attempts to keep high temperatures away from the inside, \
	shielding them from things such as fire, and making them more resistant to lasers and explosions."
	icon_state = "tech_fire_aegis"
	aspect = ASPECT_FIRE
	spell_path = /obj/item/weapon/spell/technomancer/modifier/aegis/fire

/obj/item/weapon/spell/technomancer/modifier/aegis/fire
	name = "fire aegis"
	desc = "Firesuits are so last centuary."
	modifier_type = /datum/modifier/aegis/fire

/datum/modifier/aegis/fire
	name = "Fire Aegis"
	desc = "You are fully protected from fire, and are resistant to lasers and explosions."

	on_created_text = "<span class='notice'>A protective field envelopes you. You feel rather cold...</span>"
	on_expired_text = "<span class='warning'>Your protective field has expired. You feel warmer...</span>"
	filter_parameters = list(type = "drop_shadow", color = "#FDB768", size = 3)
	armor_percent = list("laser" = 30, "bomb" = 30)
	heat_protection = 1.0



// Frost Aegis
/datum/spell_metadata/modifier/aegis/frost
	name = "Frost Aegis"
	desc = "Places an energy field around the target that attempts to shift heat from outside towards the inside, \
	making the inside warm, and an icy layer to accumulate outside. This results in protecting the target from \
	the cold, as well as making them more resilient to kinetic energy from close quarters combat \
	and ballistic weaponry."
	icon_state = "tech_frost_aegis"
	aspect = ASPECT_FROST
	spell_path = /obj/item/weapon/spell/technomancer/modifier/aegis/frost

/obj/item/weapon/spell/technomancer/modifier/aegis/frost
	name = "frost aegis"
	desc = "Winter coats are so last centuary."
	modifier_type = /datum/modifier/aegis/frost

/datum/modifier/aegis/frost
	name = "Frost Aegis"
	desc = "You are fully protected from the cold, and are resistant to melee weapons and bullets."

	on_created_text = "<span class='notice'>A protective field envelopes you. You feel rather warm...</span>"
	on_expired_text = "<span class='warning'>Your protective field has expired. You feel colder...</span>"
	filter_parameters = list(type = "drop_shadow", color = "#6395F2", size = 3)
	armor_percent = list("melee" = 30, "bullet" = 30)
	cold_protection = 1.0



// Shock Aegis
/datum/spell_metadata/modifier/aegis/shock
	name = "Energy Aegis"
	desc = "Places an energy field around the target that protects them from various forms of energy (not thermal, unfortunately). \
	They will be immune to both electric shock, as well as ionizing radiation, and be resistant towards strange energies such as \
	external sources of Instability."
	icon_state = "tech_shock_aegis"
	aspect = ASPECT_SHOCK
	spell_path = /obj/item/weapon/spell/technomancer/modifier/aegis/shock

/obj/item/weapon/spell/technomancer/modifier/aegis/shock
	name = "energy aegis"
	desc = "Faraday suits are so last centuary."
	modifier_type = /datum/modifier/aegis/shock

/datum/modifier/aegis/shock
	name = "Energy Aegis"
	desc = "You are fully protected from electrical shock and radiation, and are resistant to strange energies."

	on_created_text = "<span class='notice'>A protective field envelopes you. You feel a tingly sensation in your fingertips...</span>"
	on_expired_text = "<span class='warning'>Your protective field has expired. The tingly sensation has stopped...</span>"
	filter_parameters = list(type = "drop_shadow", color = "#FEEC86", size = 3)
	armor_percent = list("energy" = 30, "rad" = 100)
	siemens_coefficient = 0 // Immunity to shock.