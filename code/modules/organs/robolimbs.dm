var/list/all_robolimbs = list()
var/list/robolimb_data = list()
var/list/chargen_robolimbs = list()
var/datum/robolimb/basic_robolimb

/proc/populate_robolimb_list()
	basic_robolimb = new()
	for(var/limb_type in typesof(/datum/robolimb))
		var/datum/robolimb/R = new limb_type()
		all_robolimbs[R.company] = R
		if(!R.unavailable_at_chargen)
			if(R.has_subtypes) //Ensures solos get added to the list as we'll be incorporating has_subtypes == 1 and has_subtypes == 2.
				chargen_robolimbs[R.company] = R //List only main brands and solo parts.

/datum/robolimb
	var/company = "Unbranded"                            // Shown when selecting the limb.
	var/desc = "A generic unbranded robotic prosthesis." // Seen when examining a limb.
	var/icon = 'icons/mob/human_races/robotic.dmi'       // Icon base to draw from.
	var/unavailable_at_chargen                           // If set, not available at chargen.
	var/list/species_cannot_use = list("Teshari")
	var/is_monitor										 /*If 1, limb is a monitor and should be getting crt monitor styles. If greater than 1, it's a monitor, but it's not the default CRT-looking one.
														   1 = standard, 2 = Hesphiastos alt. */
	var/has_subtypes = 2								 //If null, object is a model. If 1, object is a brand (that serves as the default model) with child models. If 2, object is a brand that has no child models and thus also serves as the model.
	var/parts = BP_ALL						 			 //Defines what parts said brand can replace on a body.

/datum/robolimb/bishop
	company = "Bishop"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_main.dmi'
	has_subtypes = 1

/datum/robolimb/bishop/alt1
	company = "Bishop alt."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_alt1.dmi'
	parts = list(BP_HEAD)
	has_subtypes = null

/datum/robolimb/bishop/monitor
	company = "Bishop mtr."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_monitor.dmi'
	parts = list(BP_HEAD)
	is_monitor = 1
	has_subtypes = null

/datum/robolimb/hesphiastos
	company = "Hesphiastos"
	desc = "This limb has a militaristic black and green casing with gold stripes."
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_main.dmi'
	has_subtypes = 1

/datum/robolimb/hesphiastos/alt1
	company = "Hesphiastos alt."
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_alt1.dmi'
	parts = list(BP_HEAD)
	is_monitor = 2
	has_subtypes = null

/datum/robolimb/hesphiastos/monitor
	company = "Hesphiastos mtr."
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_monitor.dmi'
	parts = list(BP_HEAD)
	is_monitor = 1
	has_subtypes = null

/datum/robolimb/morpheus
	company = "Morpheus"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_main.dmi'
	is_monitor = 1
	has_subtypes = 1

/datum/robolimb/morpheus/alt1
	company = "Morpheus alt."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_alt1.dmi'
	parts = list(BP_HEAD)
	unavailable_at_chargen = null
	is_monitor = null
	has_subtypes = null

/datum/robolimb/veymed
	company = "Vey-Med"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon = 'icons/mob/human_races/cyberlimbs/veymed/veymed_main.dmi'

/datum/robolimb/wardtakahashi
	company = "Ward-Takahashi"
	desc = "This limb features sleek black and white polymers."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	has_subtypes = 1

/datum/robolimb/wardtakahashi/alt1
	company = "Ward-Takahashi alt."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_alt1.dmi'
	parts = list(BP_HEAD)
	has_subtypes = null

/datum/robolimb/wardtakahashi/monitor
	company = "Ward-Takahashi mtr."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_monitor.dmi'
	parts = list(BP_HEAD)
	is_monitor = 1
	has_subtypes = null

/datum/robolimb/xion
	company = "Xion"
	desc = "This limb has a minimalist black and red casing."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_main.dmi'
	has_subtypes = 1

/datum/robolimb/xion/alt1
	company = "Xion Manufacturing Group alt."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_alt1.dmi'
	parts = list(BP_HEAD)
	has_subtypes = null

/datum/robolimb/xion/monitor
	company = "Xion Manufacturing Group mtr."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_monitor.dmi'
	parts = list(BP_HEAD)
	is_monitor = 1
	has_subtypes = null

/datum/robolimb/zenghu
	company = "Zeng-Hu"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_main.dmi'
