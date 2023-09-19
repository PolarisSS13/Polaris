// There are different kinds of blobs, with different colors, properties, weaknesses, etc.  This datum tells the blob objects what kind they are, without a million typepaths.
/datum/blob_type
	var/name = "base blob"
	var/desc = "This shouldn't exist."	// Shown on examine.
	var/effect_desc = "This does nothing special."	// For examine panel.
	var/ai_desc = "default" // Shown when examining the overmind.
	var/difficulty = BLOB_DIFFICULTY_EASY // A rough guess on how hard a blob is to kill.
	                                      // When a harder blob spawns by event, the crew is given more information than usual from the announcement.
	var/color = "#FFFFFF"	// The actual blob's color.
	var/complementary_color = "#000000" //a color that's complementary to the normal blob color.  Blob mobs are colored in this.

	var/faction = "blob"				// The blob's faction.

	var/attack_message = "The blob attacks you" // Base message the mob gets when blob_act() gets called on them by the blob.  An exclamation point is added to the end.
	var/attack_message_living = null	// Appended to attack_message, if the target fails isSynthetic() check.
	var/attack_message_synth = null		// Ditto, but if they pass isSynthetic().
	var/attack_verb = "attacks"			// Used for the visible_message(), as the above is shown to the mob getting hit directly.
										// Format is '\The [blob name] [attack_verb] [victim]!' E.g. 'The explosive lattice blasts John Doe!'

	var/damage_type = BRUTE				// What kind of damage to do to living mobs via blob_act()
	var/armor_check = "melee"			// What armor to check for when blob_act()-ing living mobs.
	var/armor_pen = 0					// How much armor to penetrate(ignore) when attacking via blob_act().
	var/damage_lower = 30				// Lower bound for amount of damage to do for attacks.
	var/damage_upper = 40				// Upper bound.

	var/brute_multiplier = 0.5			// Adjust to make blobs stronger or weaker against brute damage.
	var/burn_multiplier = 1.0			// Ditto, for burns.
	var/spread_modifier = 0.5			// A multiplier on how fast the blob should naturally spread from the core and nodes.
	var/slow_spread_with_size = TRUE	// Blobs that get really huge will slow down in expansion.

	var/ai_aggressiveness = 10			// Probability of the blob AI attempting to attack someone next to the blob, independent of the attacks from node/core pulsing.

	var/can_build_factories = FALSE		// Forbids this blob type from building factories.  Set to true to enable.
	var/can_build_resources = FALSE		// Ditto, for resource blobs.
	var/can_build_nodes = TRUE			// Ditto, for nodes.

	var/spore_type = /mob/living/simple_mob/blob/spore
	var/ranged_spores = FALSE			// For proper spores of the type above.
	var/spore_firesound = 'sound/effects/slime_squish.ogg'
	var/spore_range = 7					// The range the spore can fire.
	var/spore_projectile = /obj/item/projectile/energy/blob
	var/spore_accuracy = 0	// Projectile accuracy
	var/spore_dispersion = 0	// Dispersion.

	var/factory_type = /obj/structure/blob/factory
	var/resource_type = /obj/structure/blob/resource
	var/node_type = /obj/structure/blob/node
	var/shield_type = /obj/structure/blob/shield


// Called when a blob receives damage.  This needs to return the final damage or blobs will be immortal.
/datum/blob_type/proc/on_received_damage(var/obj/structure/blob/B, damage, damage_type)
	return damage

// Called when a blob dies due to integrity depletion.  Not called if deleted by other means.
/datum/blob_type/proc/on_death(var/obj/structure/blob/B)
	return

// Called when a blob expands onto another tile.
/datum/blob_type/proc/on_expand(var/obj/structure/blob/B, var/obj/structure/blob/new_B, var/turf/T, var/mob/observer/blob/O)
	return

// Called when blob_act() is called on a living mob.
/datum/blob_type/proc/on_attack(var/obj/structure/blob/B, var/mob/living/victim, var/def_zone)
	return

// Called when the blob is pulsed by a node or the core.
/datum/blob_type/proc/on_pulse(var/obj/structure/blob/B)
	return

// Called when the core processes.
/datum/blob_type/proc/on_core_process(var/obj/structure/blob/B)
	return

// Called when a node processes.
/datum/blob_type/proc/on_node_process(var/obj/structure/blob/B)
	return

// Called when hit by EMP.
/datum/blob_type/proc/on_emp(obj/structure/blob/B, severity)
	return

// Called when hit by water.
/datum/blob_type/proc/on_water(obj/structure/blob/B, amount)
	return

// Spore death
/datum/blob_type/proc/on_spore_death(mob/living/simple_mob/blob/spore/S)
	return

// Spore handle_special call.
/datum/blob_type/proc/on_spore_lifetick(mob/living/simple_mob/blob/spore/S)
	return

/datum/blob_type/proc/listify_vars()
	var/list/transfer_vars = list()

	transfer_vars["blob_type"] = type
	transfer_vars["name"] = name
	transfer_vars["desc"] = desc
	transfer_vars["effect_desc"] = effect_desc
	transfer_vars["ai_desc"] = ai_desc
	transfer_vars["color"] = color
	transfer_vars["complementary_color"] = complementary_color

	transfer_vars["faction"] = faction

	transfer_vars["attack_message"] = attack_message
	transfer_vars["attack_message_living"] = attack_message_living
	transfer_vars["attack_message_synth"] = attack_message_synth
	transfer_vars["attack_verb"] = attack_verb
	transfer_vars["damage_type"] = damage_type
	transfer_vars["armor_check"] = armor_check
	transfer_vars["armor_pen"] = armor_pen
	transfer_vars["damage_lower"] = damage_lower
	transfer_vars["damage_upper"] = damage_upper

	transfer_vars["brute_multiplier"] = brute_multiplier
	transfer_vars["burn_multiplier"] = burn_multiplier
	transfer_vars["spread_modifier"] = spread_modifier
	transfer_vars["slow_spread_with_size"] = slow_spread_with_size
	transfer_vars["ai_aggressiveness"] = ai_aggressiveness

	transfer_vars["can_build_factories"] = can_build_factories
	transfer_vars["can_build_resources"] = can_build_resources
	transfer_vars["can_build_nodes"] = can_build_nodes

	transfer_vars["spore_type"] = spore_type
	transfer_vars["ranged_spores"] = ranged_spores
	transfer_vars["spore_firesound"] = spore_firesound
	transfer_vars["spore_range"] = spore_range
	transfer_vars["spore_projectile"] = spore_projectile
	transfer_vars["spore_accuracy"] = spore_accuracy
	transfer_vars["spore_dispersion"] = spore_dispersion

	transfer_vars["factory_type"] = factory_type
	transfer_vars["resource_type"] = resource_type
	transfer_vars["node_type"] = node_type
	transfer_vars["shield_type"] = shield_type

	transfer_vars["core_tech"] = core_tech.Copy()

	transfer_vars["chunk_type"] = chunk_type
	transfer_vars["chunk_effect_cooldown"] = chunk_effect_cooldown
	transfer_vars["chunk_effect_range"] = chunk_effect_range

	transfer_vars["generation"] = generation

	return transfer_vars

/datum/blob_type/proc/apply_vars(var/list/incoming_vars)
	if(LAZYLEN(incoming_vars))
		name = incoming_vars["name"]
		desc = incoming_vars["desc"]
		effect_desc = incoming_vars["effect_desc"]
		ai_desc = incoming_vars["ai_desc"]
		color = incoming_vars["color"]
		complementary_color = incoming_vars["complementary_color"]

		faction = incoming_vars["faction"]

		attack_message = incoming_vars["attack_message"]
		attack_message_living = incoming_vars["attack_message_living"]
		attack_message_synth = incoming_vars["attack_message_synth"]
		attack_verb = incoming_vars["attack_verb"]
		damage_type = incoming_vars["damage_type"]
		armor_check = incoming_vars["armor_check"]
		armor_pen = incoming_vars["armor_pen"]
		damage_lower = incoming_vars["damage_lower"]
		damage_upper = incoming_vars["damage_upper"]

		brute_multiplier = incoming_vars["brute_multiplier"]
		burn_multiplier = incoming_vars["burn_multiplier"]
		spread_modifier = incoming_vars["spread_modifier"]
		slow_spread_with_size = incoming_vars["slow_spread_with_size"]
		ai_aggressiveness = incoming_vars["ai_aggressiveness"]

		can_build_factories = incoming_vars["can_build_factories"]
		can_build_resources = incoming_vars["can_build_resources"]
		can_build_nodes = incoming_vars["can_build_nodes"]

		spore_type = incoming_vars["spore_type"]
		ranged_spores = incoming_vars["ranged_spores"]
		spore_firesound = incoming_vars["spore_firesound"]
		spore_range = incoming_vars["spore_range"]
		spore_projectile = incoming_vars["spore_projectile"]
		spore_accuracy = incoming_vars["spore_accuracy"]
		spore_dispersion = incoming_vars["spore_dispersion"]

		factory_type = incoming_vars["factory_type"]
		resource_type = incoming_vars["resource_type"]
		node_type = incoming_vars["node_type"]
		shield_type = incoming_vars["shield_type"]

		var/list/new_core_tech = incoming_vars["core_tech"]
		core_tech = islist(new_core_tech) ? new_core_tech : list()

		chunk_type = incoming_vars["chunk_type"]
		chunk_effect_cooldown = incoming_vars["chunk_effect_cooldown"]
		chunk_effect_range = incoming_vars["chunk_effect_range"]

		generation = incoming_vars["generation"] + 1
