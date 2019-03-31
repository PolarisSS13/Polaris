// Shimm are small scavengers with an adoration for shiny things. They won't attack you for them, but you will be their friend holding something like a coin.

/datum/category_item/catalogue/fauna/shimm
	name = "Sivian Fauna - Shimm"
	desc = "Classification: S Procyon cogitae \
	<br><br>\
	Small, social omnivores known to collect objects within their dens. \
	The Shimm form colonies that have been known to grow up to a hundred individuals. Primarily carnivorous hunters, \
	they often supplement their diets with nuts, roots, and other fruits. \
	Individuals are known to steal food and reflective objects from unsuspecting Sivian residents. \
	It is advised to keep any valuable items within dull wraps when venturing near the den of a Shimm."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/sif/shimm
	name = "shimm"
	desc = "What appears to be an oversized rodent with hands."
	tt_desc = "S Procyon cogitae"
	catalogue_data = list(/datum/category_item/catalogue/fauna/shimm)

	faction = "shimm"

	icon_state = "raccoon"
	icon_living = "raccoon"
	icon_dead = "raccoon_dead"
	icon = 'icons/mob/animal.dmi'

	maxHealth = 50
	health = 50
	has_hands = TRUE

	movement_cooldown = 0

	melee_damage_lower = 5
	melee_damage_upper = 15
	base_attack_cooldown = 1 SECOND
	attacktext = list("nipped", "bit", "cut", "clawed")

	say_list_type = /datum/say_list/shimm
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

/datum/say_list/shimm
	speak = list("Shurr.", "|R|rr?", "Hss.")
	emote_see = list("sniffs","looks around", "rubs its hands")
	emote_hear = list("chitters", "clicks")

/mob/living/simple_mob/animal/sif/shimm/IIsAlly(mob/living/L)
	. = ..()

	var/mob/living/carbon/human/H = L
	if(!istype(H))
		return .

	if(!.)
		var/has_loot = FALSE
		if(istype(H.get_active_hand(), /obj/item/weapon/coin))
			has_loot = TRUE
		if(has_loot)
			return has_loot

