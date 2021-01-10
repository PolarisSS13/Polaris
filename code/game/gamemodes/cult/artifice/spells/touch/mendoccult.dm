
/datum/cultist/spell/mendoccult
	name = "Mend Occult"
	desc = "Channel occult energy through your hands, using the power of the prime proteon itself to mend a target creature or construct. This will cause severe agony to non-practicioners of the arts."
	cost = 300
	ability_icon_state = "const_mend"
	obj_path = /obj/item/weapon/spell/construct/mend_occult
	category = CULT_SUPPORT_SPELLS

//Artificer Heal

/obj/item/weapon/spell/construct/mend_occult
	name = "mend acolyte"
	desc = "Mend the wounds of a cultist, or construct, over time."
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_UNHOLY
	light_color = "#FF5C5C"
	light_power = -2

/obj/item/weapon/spell/construct/mend_occult/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(isliving(hit_atom) && pay_energy(bloodcost))
		var/mob/living/L = hit_atom
		L.add_modifier(/datum/modifier/mend_occult, 150)
	qdel(src)
