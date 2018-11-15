/datum/species
	var/has_genitals = 1
	var/has_anus = 1

/datum/species/proc/has_penis(var/mob/living/carbon/human/H)
	return has_genitals && (H.gender == MALE)

/datum/species/proc/has_vagina(var/mob/living/carbon/human/H)
	return has_genitals && (H.gender == FEMALE)

/datum/species/proc/has_anus(var/mob/living/carbon/human/H)
	return has_anus