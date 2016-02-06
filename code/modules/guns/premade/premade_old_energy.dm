// laser carbine - An Hesphaistos Industries G40E carbine, designed to kill with concentrated energy blasts.
/obj/item/weapon/gun/composite/premade/laser_rifle
	build_components = list(
		/obj/item/gun_component/chamber/laser/assault/carbine,
		/obj/item/gun_component/body/assault/laser,
		/obj/item/gun_component/barrel/laser/assault,
		/obj/item/gun_component/grip/assault/laser,
		/obj/item/gun_component/stock/assault/laser
		)

// practice laser carbine - A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice.
/obj/item/weapon/gun/composite/premade/prac_laser_rifle
	build_components = list(
		/obj/item/gun_component/chamber/laser/assault/carbine,
		/obj/item/gun_component/body/assault/laser,
		/obj/item/gun_component/barrel/laser/assault/practice,
		/obj/item/gun_component/grip/assault/laser,
		/obj/item/gun_component/stock/assault/laser
		)

// retro laser - An older model of the basic lasergun. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws.
/obj/item/weapon/gun/composite/premade/retro_laser_pistol
	set_model = /decl/weapon_model/retrolaser
	build_components = list(
		/obj/item/gun_component/chamber/laser/pistol/old,
		/obj/item/gun_component/body/pistol/laser,
		/obj/item/gun_component/barrel/laser/pistol,
		/obj/item/gun_component/grip/pistol/laser,
		/obj/item/gun_component/stock/pistol/laser
		)

// antique laser gun - A rare weapon, handcrafted by a now defunct specialty manufacturer on Luna for a small fortune. It's certainly aged well.
/obj/item/weapon/gun/composite/premade/antique_laser_pistol
	set_model = /decl/weapon_model/antiquelaser
	build_components = list(
		/obj/item/gun_component/chamber/laser/pistol/reactor/antique,
		/obj/item/gun_component/body/pistol/laser,
		/obj/item/gun_component/barrel/laser/pistol,
		/obj/item/gun_component/grip/pistol/laser,
		/obj/item/gun_component/stock/pistol/laser
		)

// laser cannon - science technobabble
/obj/item/weapon/gun/composite/premade/laser_cannon
	set_model = /decl/weapon_model/nt/laser_cannon
	build_components = list(
		/obj/item/gun_component/grip/cannon/laser,
		/obj/item/gun_component/body/cannon/laser,
		/obj/item/gun_component/chamber/laser/cannon,
		/obj/item/gun_component/stock/cannon/laser,
		/obj/item/gun_component/barrel/laser/cannon
		)

// xray laser gun - A high-power laser gun capable of expelling concentrated xray blasts.
/obj/item/weapon/gun/composite/premade/xray_smg
	set_model = /decl/weapon_model/hcs/horus
	build_components = list(
		/obj/item/gun_component/grip/smg/laser,
		/obj/item/gun_component/body/smg/laser,
		/obj/item/gun_component/chamber/laser/smg/xray,
		/obj/item/gun_component/stock/smg/laser,
		/obj/item/gun_component/barrel/laser/smg/xray
		)

// marksman energy rifle - The HI DMR 9E is an older design of Hesphaistos Industries. A designated marksman rifle capable of shooting powerful ionized beams, this is a weapon to kill from a distance.
/obj/item/weapon/gun/composite/premade/laser_rifle_rifle
	build_components = list(
		/obj/item/gun_component/grip/rifle/laser,
		/obj/item/gun_component/body/rifle/laser,
		/obj/item/gun_component/chamber/laser/rifle,
		/obj/item/gun_component/stock/rifle/laser,
		/obj/item/gun_component/barrel/laser/rifle,
		/obj/item/gun_component/accessory/chamber/scope
		)

// laser tag gun - Standard issue weapon of the Imperial Guard
/obj/item/weapon/gun/composite/premade/laser_tag_gun
	set_model = /decl/weapon_model/laser_tag
	build_components = list(
		/obj/item/gun_component/chamber/laser/tag,
		/obj/item/gun_component/body/pistol/laser,
		/obj/item/gun_component/barrel/laser/pistol/lasertag,
		/obj/item/gun_component/grip/pistol/laser,
		/obj/item/gun_component/stock/pistol/laser
		)

/obj/item/weapon/gun/composite/premade/laser_tag_gun/red/New()
	..()
	var/obj/item/gun_component/chamber/laser/tag/L = chamber
	L.current_colour = "red"
	L.set_holder_colour()

// energy gun - A versatile energy based sidearm, capable of switching between low and high capacity projectile settings.
/obj/item/weapon/gun/composite/premade/egun
	set_model = /decl/weapon_model/la/perun
	build_components = list(
		/obj/item/gun_component/chamber/laser/pistol,
		/obj/item/gun_component/body/pistol/laser,
		/obj/item/gun_component/barrel/laser/variable,
		/obj/item/gun_component/grip/pistol/laser,
		/obj/item/gun_component/stock/pistol/laser
		)

// advanced energy gun - An energy gun with an experimental miniaturized reactor.
/obj/item/weapon/gun/composite/premade/adv_egun
	set_model = /decl/weapon_model/nt/adv_egun
	build_components = list(
		/obj/item/gun_component/chamber/laser/assault/reactor,
		/obj/item/gun_component/body/assault/laser,
		/obj/item/gun_component/barrel/laser/variable/assault,
		/obj/item/gun_component/grip/assault/laser,
		/obj/item/gun_component/stock/assault/laser
		)

// fm-2t - The FM-2t is a versatile energy based small arm, capable of switching between stun or kill with a three round burst option for both settings.
/obj/item/weapon/gun/composite/premade/burst_laser_smg
	set_model = /decl/weapon_model/hcs/hera
	build_components = list(
		/obj/item/gun_component/grip/smg/laser,
		/obj/item/gun_component/body/smg/laser,
		/obj/item/gun_component/chamber/laser/smg/small,
		/obj/item/gun_component/stock/smg/laser,
		/obj/item/gun_component/barrel/laser/variable/smg
		)

// pulse rifle - A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists.
/obj/item/weapon/gun/composite/premade/pulse_rifle
	set_model = /decl/weapon_model/hi/ecannon
	build_components = list(
		/obj/item/gun_component/grip/rifle/laser,
		/obj/item/gun_component/body/rifle/laser,
		/obj/item/gun_component/chamber/laser/rifle/pulse,
		/obj/item/gun_component/stock/rifle/laser,
		/obj/item/gun_component/barrel/laser/variable/pulse
		)

// ion rifle - The NT Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. Not the best of its type.
/obj/item/weapon/gun/composite/premade/ion_rifle
	set_model = /decl/weapon_model/nt/ion
	build_components = list(
		/obj/item/gun_component/chamber/laser/rifle/ion,
		/obj/item/gun_component/body/rifle/laser,
		/obj/item/gun_component/barrel/laser/rifle/ion,
		/obj/item/gun_component/grip/rifle/laser,
		/obj/item/gun_component/stock/rifle/laser
		)

/obj/item/weapon/gun/composite/premade/taser
	set_model = /decl/weapon_model/nt
	build_components = list(
		/obj/item/gun_component/grip/pistol/laser,
		/obj/item/gun_component/body/pistol/laser,
		/obj/item/gun_component/chamber/laser/pistol/taser,
		/obj/item/gun_component/stock/pistol/laser,
		/obj/item/gun_component/barrel/laser/pistol/taser
		)

/obj/item/weapon/gun/composite/premade/stun_revolver
	set_model = /decl/weapon_model/la
	build_components = list(
		/obj/item/gun_component/body/pistol,
		/obj/item/gun_component/stock/pistol,
		/obj/item/gun_component/grip/pistol,
		/obj/item/gun_component/chamber/ballistic/breech/revolver/stun,
		/obj/item/gun_component/barrel/pistol/stun
		)
