// all weapons are H[blank]W, standing for H[energy/kinetic]weapon, the letter afterwards
// designates a weapon as a pistol[p], rifle[r], or cannon[c]. A weapons are civilian-spec,
// B are restricted/private security-spec, C are military-spec. ballistic calibers are in
// millimeters.
/decl/weapon_model/hcs
	producer_path = /decl/weapon_manufacturer/halicon
	model_name = "HKW c-63/20-C Set"
	model_desc = "A cannon made with lightweight carbon fiber components, stamped with a bird of prey on the receiver."

/decl/weapon_model/hcs/ares
	model_name = "HEW c-30/WB-C Ares"
	model_desc = "An energy cannon with a short barrel, stamped with a bird of prey on the receiver."

/decl/weapon_model/hcs/anubis
	model_name = "HKW r-60/7.62-C Anubis"
	model_desc = "A light marksman rifle with a collapsable stock, stamped with a bird of prey on the receiver."

/decl/weapon_model/hcs/artemis
	model_name = "HEW r-22/NB-C Artemis"
	model_desc = "An self-charging energy rifle with a body built from lightweight carbon fiber and titanium components, stamped with a bird of prey on the stock."

/decl/weapon_model/hcs/ammut
	model_name = "HCS HKW r-57/12g-A Ammut"
	model_desc = "A short-barreled shotgun, stamped with a bird of prey on the receiver."

/decl/weapon_model/hcs/hades
	model_name = "HCS HEW r-07/WB-B Hades"
	model_desc = "An energy shotgun with a shortened stock, stamped with a bird of prey on the receiver."

/decl/weapon_model/hcs/osiris
	model_name = "HCS HKW r-38/5.56-C Osiris"
	model_desc = "A bullpup assault rifle, stamped with a bird of prey on the stock."

/decl/weapon_model/hcs/nike
	model_name = "HCS HEW r-41/WB-C Nike"
	model_desc = "An energy rifle with a lightweight frame and compact barrel, stamped with a bird of prey on the stock."

/decl/weapon_model/hcs/horus
	model_name = "HCS HKW p-44/10-B Horus"
	model_desc = "A compact submachine gun, stamped with a bird of prey on the stock."

/decl/weapon_model/hcs/hera
	model_name = "HCS HEW p-27/WB-A Hera"
	model_desc = "An energy PDW with a small frame, stamped with a bird of prey on the grip. It's capable of switching between stun or kill with a three round burst option for both settings."
	use_icon = 'icons/obj/gun_components/halicon/hcs_smg.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/halicon/hcs_smg.dmi'
	ammo_use_state = "chamber_loaded"

/decl/weapon_model/hcs/isis
	model_name = "HCS HKW p-17/10-A Isis"
	model_desc = "A lightweight pistol, stamped with a bird of prey on the receiver."

/decl/weapon_model/hcs/pan
	model_name = "HCS HEW p-14/NB-A Pan"
	model_desc = "An extremely compact energy pistol, stamped with a bird of prey on the grip."
