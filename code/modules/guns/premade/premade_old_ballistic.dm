/obj/item/weapon/gun/composite/premade/smg_9mm
	build_components = list(
		/obj/item/gun_component/grip/smg,
		/obj/item/gun_component/body/smg,
		/obj/item/gun_component/chamber/ballistic/smg,
		/obj/item/gun_component/stock/smg,
		/obj/item/gun_component/barrel/smg/a9
		)

/obj/item/weapon/gun/composite/premade/smg_9mm/wt
	set_model = /decl/weapon_model/wt/saber

/obj/item/weapon/gun/composite/premade/smg_uzi
	set_model = /decl/weapon_model/uzi
	build_components = list(
		/obj/item/gun_component/grip/smg,
		/obj/item/gun_component/body/smg,
		/obj/item/gun_component/chamber/ballistic/smg,
		/obj/item/gun_component/stock/smg,
		/obj/item/gun_component/barrel/smg/a45
		)

/obj/item/weapon/gun/composite/premade/smg_10mm
	build_components = list(
		/obj/item/gun_component/grip/smg,
		/obj/item/gun_component/body/smg,
		/obj/item/gun_component/chamber/ballistic/smg,
		/obj/item/gun_component/stock/smg,
		/obj/item/gun_component/barrel/smg/a10
		)

/obj/item/weapon/gun/composite/premade/ar_a762
	build_components = list(
		/obj/item/gun_component/grip/assault,
		/obj/item/gun_component/body/assault,
		/obj/item/gun_component/chamber/ballistic/assault,
		/obj/item/gun_component/stock/assault,
		/obj/item/gun_component/barrel/assault/a762
		)

/obj/item/weapon/gun/composite/premade/ar_a556
	set_model = /decl/weapon_model/carbine
	build_components = list(
		/obj/item/gun_component/grip/assault,
		/obj/item/gun_component/body/assault,
		/obj/item/gun_component/chamber/ballistic/assault/eject,
		/obj/item/gun_component/stock/assault,
		/obj/item/gun_component/barrel/assault,
		/obj/item/gun_component/accessory/body/launcher
		)

/obj/item/weapon/gun/composite/premade/lmg_saw
	set_model = /decl/weapon_model/lmg_saw
	build_components = list(
		/obj/item/gun_component/grip/assault,
		/obj/item/gun_component/body/assault,
		/obj/item/gun_component/chamber/ballistic/assault/large,
		/obj/item/gun_component/stock/assault,
		/obj/item/gun_component/barrel/assault/a762
		)

/obj/item/weapon/gun/composite/premade/combat_shotgun
	set_model = /decl/weapon_model/auto_shotgun
	build_components = list(
		/obj/item/gun_component/grip/shotgun,
		/obj/item/gun_component/body/shotgun,
		/obj/item/gun_component/chamber/ballistic/shotgun/auto,
		/obj/item/gun_component/stock/shotgun,
		/obj/item/gun_component/barrel/shotgun
		)

// vintage .45 pistol - A cheap Martian knock-off of a Colt M1911. Uses .45 rounds.
/obj/item/weapon/gun/composite/premade/pistol_a45
	set_model = /decl/weapon_model/nt/secpistol
	build_components = list(
		/obj/item/gun_component/grip/pistol,
		/obj/item/gun_component/body/pistol,
		/obj/item/gun_component/chamber/ballistic/pistol,
		/obj/item/gun_component/stock/pistol,
		/obj/item/gun_component/barrel/pistol/a45
		)

// silenced pistol - A small, quiet, easily concealable gun. Uses .45 rounds.
/obj/item/weapon/gun/composite/premade/pistol_silenced
	build_components = list(
		/obj/item/gun_component/grip/pistol/small,
		/obj/item/gun_component/body/pistol/small,
		/obj/item/gun_component/stock/pistol/small,
		/obj/item/gun_component/chamber/ballistic/pistol,
		/obj/item/gun_component/barrel/pistol/a9,
		/obj/item/gun_component/accessory/barrel/silencer
		)

// holdout pistol - The Lumoco Arms P3 Whisper. A small, easily concealable gun. Uses 9mm rounds.
/obj/item/weapon/gun/composite/premade/pistol_holdout
	build_components = list(
		/obj/item/gun_component/grip/pistol/small,
		/obj/item/gun_component/body/pistol/small,
		/obj/item/gun_component/stock/pistol/small,
		/obj/item/gun_component/chamber/ballistic/pistol,
		/obj/item/gun_component/barrel/pistol/a9
		)

// zip gun  - Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
/obj/item/weapon/gun/composite/premade/zipgun
	build_components = list(
		/obj/item/gun_component/grip/shotgun,
		/obj/item/gun_component/body/shotgun,
		/obj/item/gun_component/chamber/ballistic/breech,
		/obj/item/gun_component/stock/shotgun,
		/obj/item/gun_component/barrel/shotgun
		)

/obj/item/weapon/gun/composite/premade/zipgun/New()
	..()
	barrel.caliber = pick(list(CALIBER_357,CALIBER_PISTOL_MEDIUM,CALIBER_45,CALIBER_PISTOL_LARGE,CALIBER_SHOTGUN,CALIBER_RIFLE_LARGE,CALIBER_RIFLE_SMALL))
	barrel.update_strings()
	update_from_components()

/obj/item/weapon/gun/composite/premade/zipgun/update_strings()
	..()
	name = "[caliber] zipgun"

/obj/item/weapon/gun/composite/premade/revolver_a357
	set_model = /decl/weapon_model/la/revolver
	build_components = list(
		/obj/item/gun_component/grip/pistol,
		/obj/item/gun_component/body/pistol,
		/obj/item/gun_component/chamber/ballistic/breech/revolver,
		/obj/item/gun_component/stock/pistol,
		/obj/item/gun_component/barrel/pistol/revolver
		)

/obj/item/weapon/gun/composite/premade/revolver_a38
	set_model = /decl/weapon_model/la/revolver_detective
	build_components = list(
		/obj/item/gun_component/grip/pistol,
		/obj/item/gun_component/body/pistol,
		/obj/item/gun_component/chamber/ballistic/breech/revolver,
		/obj/item/gun_component/stock/pistol,
		/obj/item/gun_component/barrel/pistol/a38
		)

/obj/item/weapon/gun/composite/premade/capgun
	set_model = /decl/weapon_model/capgun
	build_components = list(
		/obj/item/gun_component/grip/pistol/small,
		/obj/item/gun_component/body/pistol/small,
		/obj/item/gun_component/chamber/ballistic/breech/revolver,
		/obj/item/gun_component/stock/pistol/small,
		/obj/item/gun_component/barrel/pistol/toy
		)

/obj/item/weapon/gun/composite/premade/pump_shotgun
	set_model = /decl/weapon_model/pump_shotgun
	build_components = list(
		/obj/item/gun_component/grip/shotgun,
		/obj/item/gun_component/body/shotgun,
		/obj/item/gun_component/chamber/ballistic/pump,
		/obj/item/gun_component/stock/shotgun,
		/obj/item/gun_component/barrel/shotgun
		)

/obj/item/weapon/gun/composite/premade/combat_shotgun
	set_model = /decl/weapon_model/hi/shotgun
	build_components = list(
		/obj/item/gun_component/grip/shotgun,
		/obj/item/gun_component/body/shotgun,
		/obj/item/gun_component/chamber/ballistic/pump/large,
		/obj/item/gun_component/stock/shotgun,
		/obj/item/gun_component/barrel/shotgun
		)

/obj/item/weapon/gun/composite/premade/heavy_rifle
	set_model = /decl/weapon_model/hi/rifle
	build_components = list(
		/obj/item/gun_component/grip/rifle,
		/obj/item/gun_component/body/rifle,
		/obj/item/gun_component/chamber/ballistic/breech/rifle,
		/obj/item/gun_component/stock/rifle,
		/obj/item/gun_component/barrel/rifle,
		/obj/item/gun_component/accessory/chamber/scope
		)

/obj/item/weapon/gun/composite/premade/double_shotgun
	build_components = list(
		/obj/item/gun_component/grip/shotgun,
		/obj/item/gun_component/body/shotgun,
		/obj/item/gun_component/chamber/ballistic/breech,
		/obj/item/gun_component/stock/shotgun,
		/obj/item/gun_component/barrel/shotgun/double
		)

/*
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = 4
	burst_delay = 0

*/

// sawn-off shotgun - Omar's coming!
/*
	As above+
	w_class = 3
	force = 5
*/