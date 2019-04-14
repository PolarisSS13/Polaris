/obj/item/projectile/nonlethal // This type of stun relies on pain in order to work.
	name = "taser electrode"
	icon_state = "spark"
	fire_sound = 'sound/weapons/Taser.ogg'
	nodamage = 1
	light_range = 2
	light_power = 0.5
	light_color = "#33CC00"
	embed_chance = 0
	stun = 8
	weaken = 8
	stutter = 8
	accuracy = 95
	agony = 5
	combustion = FALSE

/obj/item/projectile/nonlethal/on_hit(var/atom/target, var/blocked = 0)
	if(!ishuman(target))
		return

	var/mob/living/carbon/human/M = target

	if(M.species.flags & NO_PAIN)
		return

	if(M.chem_effects[CE_PAINKILLER])
		return

	M.emote("scream")
	..()
