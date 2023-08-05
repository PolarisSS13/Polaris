/obj/item/organ/external/head/vox
	eye_icon = "vox_eyes_s"
	eye_icon_location = 'icons/mob/eyes_vox.dmi'

//vox got different organs within. This will also help with regular surgeons knowing the organs within an alien as alien as vox.
/obj/item/organ/internal/brain/vox
	icon_state = "brain_prosthetic"
	dead_icon = null

/obj/item/organ/internal/heart/vox
	icon_state = "vox_heart"
	dead_icon = null
	parent_organ = BP_GROIN

/obj/item/organ/internal/lungs/vox
	name = "air capillary sack" //Like birds, Vox absorb gas via air capillaries.
	icon_state = "vox_lung"

/obj/item/organ/internal/kidneys/vox
	name = "filtration bladder"
	icon_state = "lungs" //wow are vox kidneys fat.
	color = "#99ccff"
	parent_organ = BP_TORSO

/obj/item/organ/internal/liver/vox
	name = "waste tract"
	parent_organ = BP_TORSO
	color = "#0033cc"

/obj/item/organ/external/groin/vox //vox have an extended ribcage for extra protection.
	encased = "lower ribcage"

/obj/item/organ/internal/stomach/vox
	name = "processing tuble"
	parent_organ = BP_TORSO
	color = "#0033cc"
	acidtype = "voxenzyme"
	unacidable = TRUE
	stomach_capacity = 20
	// Items to convert into nutriment during processing.
	var/static/list/convert_into_nutriment = list(
		/obj/item/trash                   = 10,
		/obj/item/flame/candle            = 5,
		/obj/item/ore                     = 5,
		/obj/item/soap                    = 5,
		/obj/item/material/shard/shrapnel = 3
	)

/obj/item/organ/internal/stomach/vox/handle_organ_proc_special()
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		for(var/obj/item/thing in contents)
			if(thing.unacidable)
				continue
			for(var/check_type in convert_into_nutriment)
				if(istype(thing, check_type))
					H.ingested.add_reagent("nutriment", convert_into_nutriment[check_type])
					qdel(thing)
					break
	. = ..()
