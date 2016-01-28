// Mass-produced crap; guns only have a model number and
// an indicator for if they're an energy weapon or not.
/decl/weapon_model/nt
	producer_path = /decl/weapon_manufacturer/nanotrasen
	model_name = "NT Mk30-E"
	model_desc = "It's a small gun used for non-lethal takedowns. It's actually a licensed version of an outdated Ward-Takahashi design."
	use_icon = 'icons/obj/gun_components/nanotrasen/nt_taser.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/nanotrasen/nt_taser.dmi'
	ammo_use_state = "chamber_loaded"
	ammo_indicator_states = 4

/decl/weapon_model/nt/secpistol
	model_name = "NT Mk58"
	model_desc = "It's a a cheap, ubiquitous sidearm, produced by a NanoTrasen subsidiary."
	use_icon = 'icons/obj/gun_components/nanotrasen/nt_pistol.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/nanotrasen/nt_pistol.dmi'
	ammo_use_state = "chamber_loaded"

/decl/weapon_model/nt/smg
	model_name = "NT Mk32"
	model_desc = "It's a cheap, lightweight submachine gun. Clearly mass-produced."
	use_icon = 'icons/obj/gun_components/nanotrasen/nt_smg.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/nanotrasen/nt_smg.dmi'
	ammo_use_state = "chamber_loaded"
	ammo_indicator_states = 6

/decl/weapon_model/nt/esmg
	model_name = "NT Mk32-E"
	model_desc = "It's a cheap, lightweight energy submachine gun. Clearly mass-produced."
	use_icon = 'icons/obj/gun_components/nanotrasen/nt_egun.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/nanotrasen/nt_egun.dmi'
	ammo_use_state = "chamber_loaded"
	ammo_indicator_states = 4

/decl/weapon_model/nt/ion
	force_gun_name = "ion rifle"
	model_name = "NT Mk60-E"
	model_desc = "It's a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. Not the best of its type."
	use_icon = 'icons/obj/gun_components/nanotrasen/nt_ion.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/nanotrasen/nt_ion.dmi'
	ammo_use_state = "chamber_loaded"
	ammo_indicator_states = 4

/decl/weapon_model/nt/adv_egun
	force_gun_name = "prototype energy rifle"
	model_name = "Mk I ADV. FISSION C.R.E.W"
	use_icon = 'icons/obj/gun_components/nanotrasen/nt_nukegun.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/nanotrasen/nt_nukegun.dmi'
	ammo_use_state = "chamber_loaded"
	ammo_indicator_states = 4

/decl/weapon_model/nt/laser_cannon
	force_gun_name = "prototype energy cannon"
	model_name = "Mk I ADV. ENERGY CANNON"
	model_desc = "It's a prototype laser cannon. The lasing medium is enclosed in a tube lined with uranium-235 and has been subjected to high neutron flux in a reactor core."
	use_icon = 'icons/obj/gun_components/nanotrasen/nt_lasercannon.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/nanotrasen/nt_lasercannon.dmi'
	ammo_use_state = "chamber_loaded"
	ammo_indicator_states = 5