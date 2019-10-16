// The base organic-targeting augment.

/obj/item/organ/internal/augment/bioaugment
	name = "bioaugmenting implant"

	icon_state = "augment_hybrid"
	dead_icon = "augment_hybrid_dead"

	robotic = ORGAN_ASSISTED
	target_parent_classes = list(ORGAN_FLESH)

/* Jensen Shades. Your vision can be augmented.
 * This, technically, no longer needs its unique organ verb, however I have chosen to leave it for posterity
 * in the event it needs to be referenced, while still remaining perfectly functional with either system.
 */

/obj/item/organ/internal/augment/bioaugment/thermalshades
	name = "integrated thermolensing implant"
	desc = "A miniscule implant that houses a pair of thermolensed sunglasses. Don't ask how they deploy, you don't want to know."
	icon_state = "augment_shades"
	dead_icon = "augment_shades_dead"

	w_class = ITEMSIZE_TINY

	organ_tag = O_AUG_EYES

	robotic = ORGAN_ROBOT

	parent_organ = BP_HEAD

	organ_verbs = list(
		/mob/living/carbon/human/proc/augment_menu,
		/mob/living/carbon/human/proc/toggle_shades)

	integrated_object_type = /obj/item/clothing/glasses/hud/security/jensenshades

/obj/item/organ/internal/augment/bioaugment/thermalshades/augment_action()
	if(!owner)
		return

	owner.toggle_shades()

/obj/item/organ/internal/augment/bioaugment/sprint_enhance
	name = "locomotive optimization implant"
	desc = "A chunk of meat and metal that can manage an individual's leg musculature."

	organ_tag = O_AUG_PELVIC

	parent_organ = BP_GROIN

	target_parent_classes = list(ORGAN_FLESH, ORGAN_ASSISTED)

	aug_cooldown = 2 MINUTES

/obj/item/organ/internal/augment/bioaugment/sprint_enhance/augment_action()
	if(!owner)
		return

	if(aug_cooldown)
		if(last_activate <= world.time + aug_cooldown)
			last_activate = world.time
		else
			return

	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		H.add_modifier(/datum/modifier/sprinting, 1 MINUTES)

