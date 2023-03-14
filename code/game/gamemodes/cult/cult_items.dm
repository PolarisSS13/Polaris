/obj/item/melee/cultblade
	name = "cult blade"
	desc = "A wicked sword made of serrated black metal, with a very slightly curving blade evoking a khopesh. The grip is studded with dull spikes."
	description_antag = "Through some anomalous means, this weapon refuses to be wielded by any other than the followers of Nar-Sie. Attempting to wield it without being a cultist yourself is like to result in disaster."
	icon_state = "cultblade"
	origin_tech = list(TECH_COMBAT = 1, TECH_ARCANE = 1)
	w_class = ITEMSIZE_LARGE
	force = 30
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	edge = TRUE
	sharp = TRUE

/obj/item/melee/cultblade/cultify()
	return

/obj/item/melee/cultblade/attack(mob/living/M, mob/living/user, target_zone)
	if (iscultist(user) && !isconstruct(user))
		return ..()

	var/zone = (user.hand ? BP_L_ARM : BP_R_ARM)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		to_chat(user, SPAN_DANGER("An inexplicable force rips through your [affecting.name], tearing \the [src] from your grip!"))
		user.apply_damage(rand(force / 2, force), damtype, zone, 0, sharp = sharp, edge = edge)
		user.Weaken(5)
	else if (isconstruct(user))
		to_chat(user, SPAN_WARNING("The blade hisses, forcing itself from your manipulators. \The [src] will only allow mortals to wield it against foes, not kin."))
	else
		to_chat(user, SPAN_DANGER("An inexplicable force rips through you, tearing the sword from your grip!"))

	user.drop_from_inventory(src, get_turf(user))
	throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1, 3), throw_speed)

	var/spooky = pick('sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg', 'sound/hallucinations/wail.ogg')
	playsound(src, spooky, 50, TRUE)

	return TRUE

/obj/item/melee/cultblade/pickup(mob/living/user)
	. = ..()
	if (!iscultist(user))
		to_chat(user, SPAN_WARNING("An overwhelming feeling of dread comes over you as you pick up \the [src]. It would be wise to be rid of this blade quickly."))
		user.make_dizzy(120)
	else if (isconstruct(user))
		to_chat(user, SPAN_WARNING("The [src] hisses, as it is discontent with your acquisition of it. It would be wise to return it to a worthy mortal quickly."))


// Actual cultists spawn with a hooded variant found in hooded.dm; everything below here is legacy for older maps, and has yet to be gutted
/obj/item/clothing/head/culthood
	name = "cult hood"
	icon_state = "culthood"
	desc = "Chips of wet magmellite and strips of leathery textile are melded together into stiff cloth. Its surface is warm and shudders at the touch."
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	flags_inv = HIDEFACE
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 80, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/culthood/cultify()
	return

/obj/item/clothing/head/culthood/magus
	name = "magus helm"
	icon_state = "magus"
	desc = "A helm worn by the followers of an unknown god."
	flags_inv = HIDEFACE | BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/culthood/alt
	icon_state = "cult_hoodalt"

/obj/item/clothing/suit/cultrobes
	name = "cult robes"
	desc = "Chips of wet magmellite and strips of leathery textile are melded together into stiff cloth. Its surface is warm and shudders at the touch."
	icon_state = "cultrobes"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/arcane_tome,/obj/item/melee/cultblade)
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 80, bomb = 25, bio = 10, rad = 0)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0

/obj/item/clothing/suit/cultrobes/cultify()
	return

/obj/item/clothing/suit/cultrobes/alt
	icon_state = "cultrobesalt"

/obj/item/clothing/suit/cultrobes/magusred
	name = "magus robes"
	desc = "A set of armored robes worn by the followers of an unknown god."
	icon_state = "magusred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/head/helmet/space/cult
	name = "cult helmet"
	desc = "A space worthy helmet used by the followers of an unknown god."
	icon_state = "cult_helmet"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 80, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0

/obj/item/clothing/head/helmet/space/cult/cultify()
	return

/obj/item/clothing/suit/space/cult
	name = "cult armour"
	icon_state = "cult_armour"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ARCANE = 1)
	desc = "A bulky suit of armour, bristling with spikes. It looks space-worthy."
	w_class = ITEMSIZE_NORMAL
	allowed = list(/obj/item/arcane_tome,/obj/item/melee/cultblade,/obj/item/tank/emergency/oxygen,/obj/item/suit_cooling_unit)
	slowdown = 0.5
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 80, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS

/obj/item/clothing/suit/space/cult/cultify()
	return
