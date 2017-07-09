//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
//						FACE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/face
	priority = 2
	req_open = 0
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (!affected || (affected.robotic >= ORGAN_ROBOT))
			return 0
		return target_zone == O_MOUTH

/datum/surgery_step/generic/cut_face
	allowed_tools = list(
	/obj/item/weapon/surgical/scalpel = 100,		\
	/obj/item/weapon/material/knife = 75,	\
	/obj/item/weapon/material/shard = 50, 		\
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target_zone == O_MOUTH && target.op_stage.face == 0

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to cut open [target]'s face and neck with \the [tool].</font>", \
		"You start to cut open [target]'s face and neck with \the [tool].</font>")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<font color='blue'> [user] has cut open [target]'s face and neck with \the [tool].</font>" , \
		"<font color='blue'> You have cut open [target]'s face and neck with \the [tool].</font>",)
		target.op_stage.face = 1

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<font color='red'> [user]'s hand slips, slicing [target]'s throat wth \the [tool]!</font>" , \
		"<font color='red'> Your hand slips, slicing [target]'s throat wth \the [tool]!</font>" )
		affected.createwound(CUT, 60)
		target.losebreath += 10

/datum/surgery_step/face/mend_vocal
	allowed_tools = list(
	/obj/item/weapon/surgical/hemostat = 100, 	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts mending [target]'s vocal cords with \the [tool].</font>", \
		"You start mending [target]'s vocal cords with \the [tool].</font>")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<font color='blue'> [user] mends [target]'s vocal cords with \the [tool].</font>", \
		"<font color='blue'> You mend [target]'s vocal cords with \the [tool].</font>")
		target.op_stage.face = 2

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<font color='red'> [user]'s hand slips, clamping [target]'s trachea shut for a moment with \the [tool]!</font>", \
		"<font color='red'> Your hand slips, clamping [user]'s trachea shut for a moment with \the [tool]!</font>")
		target.losebreath += 10

/datum/surgery_step/face/fix_face
	allowed_tools = list(
	/obj/item/weapon/surgical/retractor = 100, 	\
	/obj/item/weapon/crowbar = 55,	\
	/obj/item/weapon/material/kitchen/utensil/fork = 75)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts pulling the skin on [target]'s face back in place with \the [tool].</font>", \
		"You start pulling the skin on [target]'s face back in place with \the [tool].</font>")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<font color='blue'> [user] pulls the skin on [target]'s face back in place with \the [tool].</font>",	\
		"<font color='blue'> You pull the skin on [target]'s face back in place with \the [tool].</font>")
		target.op_stage.face = 3

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<font color='red'> [user]'s hand slips, tearing skin on [target]'s face with \the [tool]!</font>", \
		"<font color='red'> Your hand slips, tearing skin on [target]'s face with \the [tool]!</font>")
		target.apply_damage(10, BRUTE, affected, sharp=1, sharp=1)

/datum/surgery_step/face/cauterize
	allowed_tools = list(
	/obj/item/weapon/surgical/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/weapon/flame/lighter = 50,			\
	/obj/item/weapon/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face > 0

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] is beginning to cauterize the incision on [target]'s face and neck with \the [tool].</font>" , \
		"You are beginning to cauterize the incision on [target]'s face and neck with \the [tool].</font>")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<font color='blue'> [user] cauterizes the incision on [target]'s face and neck with \the [tool].</font>", \
		"<font color='blue'> You cauterize the incision on [target]'s face and neck with \the [tool].</font>")
		affected.open = 0
		affected.status &= ~ORGAN_BLEEDING
		if (target.op_stage.face == 3)
			var/obj/item/organ/external/head/h = affected
			h.disfigured = 0
		target.op_stage.face = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<font color='red'> [user]'s hand slips, leaving a small burn on [target]'s face with \the [tool]!", \
		"<font color='red'> Your hand slips, leaving a small burn on [target]'s face with \the [tool]!")
		target.apply_damage(4, BURN, affected)