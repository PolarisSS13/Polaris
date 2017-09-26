/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"
	use_screwdriver = 1
	breakout_sound = 'sound/weapons/tablehit1.ogg'

/obj/structure/closet/coffin/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/grave
	name = "grave"
	store_closets = 1
	max_closets = 1
// ALL OF THIS NEEDS TO BE REPLACED
/*	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"
	use_screwdriver = 1
	breakout_sound = 'sound/weapons/tablehit1.ogg'
*/

/obj/structure/closet/grave/return_air_for_internal_lifeform(var/mob/living/L)
	var/gasid = "carbon_dioxide"
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.species && H.species.exhale_type)
			gasid = H.species.exhale_type
	var/datum/gas_mixture/grave_breath = new()
	var/datum/gas_mixture/above_air = return_air()
	grave_breath.adjust_gas(gasid, BREATH_MOLES) // They have no oxygen, but non-zero moles and temp
	grave_breath.temperature = above_air.temperature
	return grave_breath