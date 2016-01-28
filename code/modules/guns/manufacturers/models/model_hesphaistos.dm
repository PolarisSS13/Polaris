// Letters refer to specific gun models.
// SLP = Self-loading pistol
// MP = Machine Pistol
// UG = Universal Rifle
// UPG = Universal Precision Rifle
// SLC = Striker loaded cannon
// CC = Combat Carbine
// E = Energy/Emission
// NB/WB = Narrow Band/Wide Band.
// Numbers refer to the number of iterations of the prototype for that model before
// it was accepted as a finished model and released/published.

/decl/weapon_model/hi
	producer_path = /decl/weapon_manufacturer/hesphaistos
	model_name = "HI SLP-51 2NB-E"
	model_desc = "It's a modern-looking, powerful energy pistol."

/decl/weapon_model/hi/epistol
	model_name = "HI SLP-50"
	model_desc = "It's a modern-looking, powerful pistol."

/decl/weapon_model/hi/esmg
	model_name = "HI MP-20 2NB-E"
	model_desc = "It's a sleek and dangerous-looking submachine gun."

/decl/weapon_model/hi/smg
	model_name = "HI MP-12"
	model_desc = "It's a sleek and dangerous-looking submachine gun."

/decl/weapon_model/hi/eassault
	model_name = "HI UR 40 2NB-E"
	model_desc = "It's a heavy, swept-back, serious-business energy rifle."

/decl/weapon_model/hi/assault
	force_gun_name = "light machine gun"
	model_name = "HI UR 70"
	model_desc = "It's a heavy, swept-back, serious-business light maching gun with a pleasantly lacquered pistol grip."
	use_icon = 'icons/obj/gun_components/hesphaistos/hi_lmg.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/hesphaistos/hi_lmg.dmi'
	ammo_use_state = "chamber_loaded"
	ammo_indicator_states = 4

/decl/weapon_model/hi/eshotgun
	model_name = "HI CC-10 3WB-E"
	model_desc = "It's a compact but hefty rifle-bored energy shotgun."

/decl/weapon_model/hi/shotgun
	force_gun_name = "combat shotgun"
	model_name = "HI CC-9"
	model_desc = "It's a compact but hefty rifle-bored shotgun. Widely regarded as a weapon of choice for repelling boarders."
	use_icon = 'icons/obj/gun_components/hesphaistos/hi_shotgun.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/hesphaistos/hi_shotgun.dmi'

/decl/weapon_model/hi/erifle
	model_name = "HI UPR 40 3NB-E"
	model_desc = "It's a compact energy rifle that uses induction pulses to do terrible things to unprotected or armoured targets."

/decl/weapon_model/hi/rifle
	model_name = "HI UPR 70"
	model_desc = "A portable anti-armour rifle originally designed to used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease."
	use_icon = 'icons/obj/gun_components/hesphaistos/hi_rifle.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/hesphaistos/hi_rifle.dmi'
	ammo_use_state = "chamber_loaded"
	ammo_indicator_states = 5

/decl/weapon_model/hi/ecannon
	model_name = "HI 3WB-E"
	model_desc = "It's a futuristic shoulder-mounted energy cannon plated in some kind of composite."
	use_icon = 'icons/obj/gun_components/hesphaistos/hi_lasercannon.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/hesphaistos/hi_lasercannon.dmi'
	ammo_use_state = "chamber_loaded"

/decl/weapon_model/hi/cannon
	model_name = "HI SLC X"
	model_desc = "It's a futuristic shoulder-mounted cannon plated in some kind of composite."
