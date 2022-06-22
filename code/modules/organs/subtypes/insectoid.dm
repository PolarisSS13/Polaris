/obj/item/organ/external/arm/insectoid
	name = "left forelimb"
	amputation_point = "coxa"
	encased = "carapace"

/obj/item/organ/external/arm/right/insectoid
	name = "right forelimb"
	amputation_point = "coxa"
	encased = "carapace"

/obj/item/organ/external/leg/insectoid
	encased = "carapace"

/obj/item/organ/external/leg/right/insectoid
	encased = "carapace"

/obj/item/organ/external/foot/insectoid
	name = "left tarsus"
	encased = "carapace"

/obj/item/organ/external/foot/right/insectoid
	name = "right tarsus"
	encased = "carapace"

/obj/item/organ/external/hand/insectoid
	name = "left grasper"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/hand/right/insectoid
	name = "right grasper"
	icon_position = RIGHT
	encased = "carapace"

/obj/item/organ/external/groin/insectoid
	name = "abdomen"
	icon_position = UNDER
	encased = "carapace"

/obj/item/organ/external/chest/insectoid
	name = "thorax"
	encased = "carapace"

/obj/item/organ/external/head/insectoid
	name = "head"
	encased = "carapace"
	eye_icon = "eyes_mantid"
	eye_blend = ICON_MULTIPLY
	organ_verbs = list(
		/mob/living/carbon/human/proc/spit_razorweb,
		/mob/living/carbon/human/proc/weave_razorweb
	)
	var/list/existing_webs = list()
	var/list/max_webs = 4
	var/web_weave_time = 20 SECONDS
	var/cooldown

/obj/item/organ/external/head/insectoid/proc/reset_cooldown()
	if(owner)
		to_chat(owner, SPAN_NOTICE("Your filament channel has refilled."))
	cooldown = FALSE

/obj/item/organ/external/head/insectoid/Destroy()
	for(var/weakref/web_ref in existing_webs)
		var/obj/effect/razorweb/web = web_ref.resolve()
		if(istype(web) && web.owner == owner)
			web.owner = null
	existing_webs.Cut()
	return ..()

/mob/living/carbon/human/proc/weave_razorweb()
	set name = "Weave Razorweb"
	set desc = "Lay a trap made of razor-sharp crystal thread."
	set category = "Abilities"

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You cannot use this ability in this location."))
		return

	if(locate(/obj/effect/razorweb) in loc)
		to_chat(src, SPAN_WARNING("There is already a razorweb here."))
		return

	var/obj/item/organ/external/head/insectoid/organ = organs_by_name[BP_HEAD]
	if(!istype(organ) || organ.is_broken())
		to_chat(src, SPAN_WARNING("You cannot weave a razorweb!"))
		return

	if(length(organ.existing_webs) >= organ.max_webs)
		to_chat(src, SPAN_WARNING("You cannot maintain more than [organ.max_webs] razorweb\s."))
		return

	playsound(src, 'sound/voice/mantid/razorweb_hiss.ogg', 70)
	visible_message(SPAN_NOTICE("\The [src] separates their jaws and begins to carefully weave a web of crystalline filaments..."))
	organ.cooldown = TRUE
	addtimer(CALLBACK(organ, /obj/item/organ/external/head/insectoid/proc/reset_cooldown), 20 SECONDS)
	if(do_after(src, 20 SECONDS) && !QDELETED(organ) && length(organ.existing_webs) < organ.max_webs)
		playsound(src, 'sound/voice/mantid/razorweb.ogg', 70, 0)
		visible_message(SPAN_DANGER("\The [src] completes a razorweb!"))
		var/obj/effect/razorweb/web = new(get_turf(src))
		organ.existing_webs += weakref(web)
		web.owner = weakref(src)

/mob/living/carbon/human/proc/spit_razorweb()
	set name = "Spit Razorweb"
	set desc = "Hock up a mass of razorweb to throw at your prey."
	set category = "Abilities"

	var/obj/item/organ/external/head/insectoid/organ = organs_by_name[BP_HEAD]
	if(!istype(organ) || organ.is_broken())
		to_chat(src, SPAN_WARNING("You cannot spit a razorweb!"))
		return

	if(organ.cooldown)
		to_chat(src, SPAN_WARNING("Your filament channel hasn't refilled yet!"))
		return

	var/obj/item/razorweb/web = new(get_turf(src))
	if(put_in_hands(web))
		playsound(src, 'sound/voice/mantid/razorweb.ogg', 100)
		to_chat(src, SPAN_NOTICE("You <b>burn your filament reserves</b> to spit up a wad of razorweb, ready to throw!"))
		throw_mode_on()
		organ.cooldown = TRUE
		addtimer(CALLBACK(organ, /obj/item/organ/external/head/insectoid/proc/reset_cooldown), 2.5 MINUTES)
	else
		to_chat(src, SPAN_WARNING("You don't have a free hand to hold the razorweb before throwing it."))
		qdel(web)
