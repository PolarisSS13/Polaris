/mob/living/carbon
	gender = MALE
	var/datum/species/species //Contains icon generation and language information, set during New().

	var/list/datum/disease2/disease/virus2 = list()
	var/list/antibodies = list()

	var/life_tick = 0      // The amount of life ticks that have processed on this mob.

	var/obj/item/handcuffed = null // Whether or not the mob is handcuffed
	var/obj/item/legcuffed = null  // Same as handcuffs but for legs. Bear traps use this.

	var/pose = null // Active emote/pose

	var/does_not_breathe = FALSE // Used for specific mobs that can't take advantage of the species flags (changelings)


	var/last_taste_time = 0  // The last time a taste message was shown to the player.
	var/last_taste_text = "" // The taste message in question.