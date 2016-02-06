/obj/item/weapon/gun/composite/premade/pistol_10mm
	set_model = /decl/weapon_model/tdg
	build_components = list(
		/obj/item/gun_component/grip/pistol,
		/obj/item/gun_component/body/pistol,
		/obj/item/gun_component/chamber/ballistic/pistol,
		/obj/item/gun_component/stock/pistol,
		/obj/item/gun_component/barrel/pistol/a10
		)

/obj/item/weapon/gun/composite/premade/autocannon
	build_components = list(
		/obj/item/gun_component/grip/cannon,
		/obj/item/gun_component/body/cannon,
		/obj/item/gun_component/chamber/ballistic/autocannon,
		/obj/item/gun_component/stock/cannon,
		/obj/item/gun_component/barrel/cannon
		)

/obj/item/weapon/gun/composite/premade/grenade_launcher
	build_components = list(
		/obj/item/gun_component/grip/cannon,
		/obj/item/gun_component/body/cannon,
		/obj/item/gun_component/stock/cannon,
		/obj/item/gun_component/chamber/ballistic/pump/cannon,
		/obj/item/gun_component/barrel/cannon/rocket
		)

/obj/item/weapon/gun/composite/premade/rocket_launcher
	build_components = list(
		/obj/item/gun_component/grip/cannon,
		/obj/item/gun_component/body/cannon,
		/obj/item/gun_component/stock/cannon,
		/obj/item/gun_component/chamber/ballistic/launcher,
		/obj/item/gun_component/barrel/cannon/grenade
		)