/decl/hierarchy/outfit/job/medical
	hierarchy_type = /decl/hierarchy/outfit/job/medical
	l_ear = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/boots/duty
	pda_type = /obj/item/pda/medical
	pda_slot = slot_l_store
	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med

//CMO

/decl/hierarchy/outfit/job/medical/cmo
	name = OUTFIT_JOB_NAME("Chief Medical Officer")
	l_ear  =/obj/item/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	shoes = /obj/item/clothing/shoes/dress
	id_type = /obj/item/card/id/medical/head
	pda_type = /obj/item/pda/heads/cmo

//Doc+

/decl/hierarchy/outfit/job/medical/doctor
	name = OUTFIT_JOB_NAME("Medical Officer")
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/miljacket/alt
	id_type = /obj/item/card/id/medical

/decl/hierarchy/outfit/job/medical/doctor/surgeon
	name = OUTFIT_JOB_NAME("Surgeon")
	uniform = /obj/item/clothing/under/rank/medical/scrubs
	head = /obj/item/clothing/head/surgery/blue
	mask = /obj/item/clothing/mask/surgical


/decl/hierarchy/outfit/job/medical/doctor/virologist
	name = OUTFIT_JOB_NAME("Virologist")
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/virologist
	mask = /obj/item/clothing/mask/surgical

/decl/hierarchy/outfit/job/medical/doctor/nurse
	name = OUTFIT_JOB_NAME("Nurse")
	suit = null

/decl/hierarchy/outfit/job/medical/doctor/nurse/pre_equip(mob/living/carbon/human/H)
	if(H.gender == FEMALE)
		if(prob(50))
			uniform = /obj/item/clothing/under/rank/nursesuit
		else
			uniform = /obj/item/clothing/under/rank/nurse
		head = /obj/item/clothing/head/nursehat
	else
		uniform = /obj/item/clothing/under/rank/medical/scrubs/navyblue
	..()

//intern

/decl/hierarchy/outfit/job/medical/cadet
	name = OUTFIT_JOB_NAME("Medical Cadet")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/black
	suit = /obj/item/clothing/suit/storage/miljacket
	belt = /obj/item/storage/belt/medical/emt
	id_type = /obj/item/card/id/medical

//clerical

/decl/hierarchy/outfit/job/medical/chaplain
	name = OUTFIT_JOB_NAME("Chaplain")
	uniform = /obj/item/clothing/under/rank/chaplain
	suit = /obj/item/clothing/suit/storage/miljacket/alt
	l_hand = /obj/item/storage/bible
	id_type = /obj/item/card/id/medical
	pda_type = /obj/item/pda/chaplain

/decl/hierarchy/outfit/job/medical/psychiatrist
	name = OUTFIT_JOB_NAME("Psychiatrist")
	uniform = /obj/item/clothing/under/rank/psych
	suit = /obj/item/clothing/suit/storage/miljacket/alt
	l_hand = /obj/item/storage/bible
	id_type = /obj/item/card/id/medical

//troopers

/decl/hierarchy/outfit/job/medical/commando
	name = OUTFIT_JOB_NAME("Commando")
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/storage/miljacket
	pda_slot = slot_l_store
	id_type = /obj/item/card/id/medical
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
