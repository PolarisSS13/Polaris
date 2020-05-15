/obj/structure/closet/secure_closet/captains
	name = "colony director's locker"
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"
	req_access = list(access_captain)

	starts_with = list(
		/obj/item/storage/backpack/dufflebag/captain,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/suit/storage/vest,
		/obj/item/cartridge/captain,
		/obj/item/storage/lockbox/medal,
		/obj/item/radio/headset/heads/captain,
		/obj/item/radio/headset/heads/captain/alt,
		/obj/item/gun/energy/gun,
		/obj/item/melee/telebaton,
		/obj/item/flash,
		/obj/item/storage/box/ids)


/obj/structure/closet/secure_closet/hop
	name = "head of personnel's locker"
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"
	req_access = list(access_hop)

	starts_with = list(
		/obj/item/clothing/suit/storage/vest,
		/obj/item/clothing/head/helmet,
		/obj/item/cartridge/hop,
		/obj/item/radio/headset/heads/hop,
		/obj/item/radio/headset/heads/hop/alt,
		/obj/item/storage/box/ids = 2,
		/obj/item/gun/energy/gun,
		/obj/item/gun/projectile/sec/flash,
		/obj/item/flash)

/obj/structure/closet/secure_closet/hop2
	name = "head of personnel's attire"
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"
	req_access = list(access_hop)

	starts_with = list(
		/obj/item/clothing/under/rank/head_of_personnel,
		/obj/item/clothing/under/dress/dress_hop,
		/obj/item/clothing/under/dress/dress_hr,
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer/black,
		/obj/item/clothing/under/lawyer/black/skirt,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer/red/skirt,
		/obj/item/clothing/under/lawyer/oldman,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/under/rank/head_of_personnel_whimsy,
		/obj/item/clothing/head/caphat/hop,
		/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit,
		/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit/skirt,
		/obj/item/clothing/glasses/sunglasses)


/obj/structure/closet/secure_closet/hos
	name = "head of security's locker"
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"
	req_access = list(access_hos)
	storage_capacity = 2.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/head/helmet/HoS/hat,
		/obj/item/clothing/suit/storage/vest/hos,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/under/rank/head_of_security/corp,
		/obj/item/clothing/suit/storage/vest/hoscoat/jensen,
		/obj/item/clothing/suit/storage/vest/hoscoat,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/cartridge/hos,
		/obj/item/radio/headset/heads/hos,
		/obj/item/radio/headset/heads/hos/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/shield/riot,
		/obj/item/shield/riot/tele,
		/obj/item/storage/box/holobadge/hos,
		/obj/item/clothing/accessory/badge/holo/hos,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/tool/crowbar/red,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/magnetic/railgun/heater/pistol/hos,
		/obj/item/rcd_ammo/large,
		/obj/item/cell/device/weapon,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/melee/telebaton,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/flashlight/maglight,
		/obj/item/clothing/mask/gas/half)

/obj/structure/closet/secure_closet/hos/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	return ..()


/obj/structure/closet/secure_closet/warden
	name = "warden's locker"
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"
	req_access = list(access_armory)

	starts_with = list(
		/obj/item/clothing/suit/storage/vest/warden,
		/obj/item/clothing/under/rank/warden,
		/obj/item/clothing/under/rank/warden/corp,
		/obj/item/clothing/suit/storage/vest/wardencoat,
		/obj/item/clothing/suit/storage/vest/wardencoat/alt,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/clothing/head/helmet/warden,
		/obj/item/clothing/head/helmet/warden/hat,
		/obj/item/cartridge/security,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/headset_sec/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/clothing/accessory/badge/holo/warden,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/cell/device/weapon,
		/obj/item/storage/box/holobadge,
		/obj/item/clothing/head/beret/sec/corporate/warden,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/flashlight/maglight,
		/obj/item/megaphone,
		/obj/item/clothing/mask/gas/half)

/obj/structure/closet/secure_closet/warden/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/security
	name = "security officer's locker"
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"
	req_access = list(access_brig)

	starts_with = list(
		/obj/item/clothing/suit/storage/vest/officer,
		/obj/item/clothing/head/helmet,
		/obj/item/cartridge/security,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/headset_sec/alt,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/grenade/flashbang,
		/obj/item/melee/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/hailer,
		/obj/item/flashlight/flare,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/under/rank/security/corp,
		/obj/item/ammo_magazine/m45/rubber,
		/obj/item/gun/energy/taser,
		/obj/item/cell/device/weapon,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/flashlight/maglight)

/obj/structure/closet/secure_closet/security/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	if(prob(30))
		starts_with += /obj/item/contraband/poster/nanotrasen
	return ..()

/obj/structure/closet/secure_closet/security/cargo/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/cargo
	starts_with += /obj/item/encryptionkey/headset_cargo
	return ..()

/obj/structure/closet/secure_closet/security/engine/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/engine
	starts_with += /obj/item/encryptionkey/headset_eng
	return ..()

/obj/structure/closet/secure_closet/security/science/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/science
	starts_with += /obj/item/encryptionkey/headset_sci
	return ..()

/obj/structure/closet/secure_closet/security/med/Initialize()
	starts_with += /obj/item/clothing/accessory/armband/medblue
	starts_with += /obj/item/encryptionkey/headset_med
	return ..()


/obj/structure/closet/secure_closet/detective
	name = "detective's cabinet"
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"
	req_access = list(access_forensics_lockers)

	starts_with = list(
		/obj/item/clothing/accessory/badge/holo/detective,
		/obj/item/clothing/gloves/black,
		/obj/item/gunbox,
		/obj/item/storage/belt/detective,
		/obj/item/storage/box/evidence,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/headset_sec/alt,
		/obj/item/clothing/suit/storage/vest/detective,
		/obj/item/taperoll/police,
		/obj/item/clothing/accessory/holster/armpit,
		/obj/item/flashlight/maglight,
		/obj/item/reagent_containers/food/drinks/flask/detflask,
		/obj/item/storage/briefcase/crimekit,
		/obj/item/taperecorder,
		/obj/item/storage/bag/detective,
		/obj/item/tape/random = 3)

/obj/structure/closet/secure_closet/detective/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened


/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)

	starts_with = list(
		/obj/item/reagent_containers/syringe/ld50_syringe/choral = 2)

GLOBAL_LIST_BOILERPLATE(all_brig_closets, /obj/structure/closet/secure_closet/brig)

/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_brig)
	anchored = 1
	var/id = null

	starts_with = list(
		/obj/item/clothing/under/color/prison,
		/obj/item/clothing/shoes/orange)

/obj/structure/closet/secure_closet/posters
	name = "morale storage"
	req_access = list(access_security)
	anchored = 1

	starts_with = list(
		/obj/item/contraband/poster/nanotrasen,
		/obj/item/contraband/poster/nanotrasen,
		/obj/item/contraband/poster/nanotrasen,
		/obj/item/contraband/poster/nanotrasen,
		/obj/item/contraband/poster/nanotrasen)

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_lawyer)

	starts_with = list(
		/obj/item/clothing/shoes/brown,
		/obj/item/paper/Court = 3,
		/obj/item/pen,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/clothing/head/powdered_wig,
		/obj/item/storage/briefcase)


/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	icon_state = "wall-locker1"
	icon_closed = "wall-locker"
	icon_locked = "wall-locker1"
	icon_opened = "wall-lockeropen"
	icon_broken = "wall-lockerbroken"
	icon_off = "wall-lockeroff"
	req_access = list(access_security)
	density = 1

	//too small to put a man in
	large = 0

/obj/structure/closet/secure_closet/wall/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened
