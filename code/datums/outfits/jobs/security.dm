/decl/hierarchy/outfit/job/security
	hierarchy_type = /decl/hierarchy/outfit/job/security
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	l_ear = /obj/item/radio/headset/headset_sec
	head = /obj/item/clothing/head/soft/sec/corp
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/boots/duty
	backpack = /obj/item/storage/backpack/security
	satchel_one = /obj/item/storage/backpack/satchel/sec
	backpack_contents = list(/obj/item/handcuffs = 1)
	messenger_bag = /obj/item/storage/backpack/messenger/sec

/decl/hierarchy/outfit/job/security/sheriff
	name = OUTFIT_JOB_NAME("Head of security")
	l_ear = /obj/item/radio/headset/heads/hos
	uniform = /obj/item/clothing/under/det/grey/waistcoat
	id_type = /obj/item/card/id/security/head
	pda_type = /obj/item/pda/heads/hos

/decl/hierarchy/outfit/job/security/warden
	name = OUTFIT_JOB_NAME("Warden")
	uniform = /obj/item/clothing/under/rank/warden/corp
	id_type = /obj/item/card/id/security
	pda_type = /obj/item/pda/warden

/decl/hierarchy/outfit/job/security/officer
	name = OUTFIT_JOB_NAME("Security Officer")
	uniform = /obj/item/clothing/under/det/grey
	id_type = /obj/item/card/id/security
	pda_type = /obj/item/pda/security

/decl/hierarchy/outfit/job/security/forensic
	name = OUTFIT_JOB_NAME("Forensic technician")
	head = null
	suit = /obj/item/clothing/suit/storage/forensics/red

//unused follows:

/decl/hierarchy/outfit/job/security/detective
	name = OUTFIT_JOB_NAME("Detective")
	head = /obj/item/clothing/head/det
	uniform = /obj/item/clothing/under/det
	suit = /obj/item/clothing/suit/storage/det_trench
	l_pocket = /obj/item/flame/lighter/zippo
	shoes = /obj/item/clothing/shoes/laceup
	r_hand = /obj/item/storage/briefcase/crimekit
	id_type = /obj/item/card/id/security
	pda_type = /obj/item/pda/detective
	backpack = /obj/item/storage/backpack
	satchel_one = /obj/item/storage/backpack/satchel/norm
	backpack_contents = list(/obj/item/storage/box/evidence = 1)