// XYY[A][CR] == [legality (1 civilian legal, 2 restricted, 3 milspec)][caliber][automatic][energy weapon].
// So 1-09-A is a fully automatic civilian 9mm pistol (and kinda weird in concept).
// Laser caliber is WB for wide band, NB for narrow band, and SL for 'soft light' or practice rounds.

/decl/weapon_model/wt
	producer_path = /decl/weapon_manufacturer/wardtakahashi
	model_name = "W-T 109 Dagger"
	model_desc = "It's a low-cost, easily maintainable pistol."

/decl/weapon_model/wt/tanto
	model_name = "W-T 2WB-CR Tanto"
	model_desc = "It's a low-cost, easily maintainable energy pistol."

/decl/weapon_model/wt/odachi
	model_name = "W-T 3NB-CR Odachi"
	model_desc = "It's a heavy energy rifle. Tends to degrade quickly without maintenance."

/decl/weapon_model/wt/rapier
	model_name = "W-T 350 Rapier"
	model_desc = "It's a heavy rifle. Tends to degrade quickly without maintenance."

/decl/weapon_model/wt/kodach
	model_name = "W-T 2WB-CR Kodachi"
	model_desc = "It's a short-nosed energy shotgun. A favourite of many border worlds due to being cheap and reliable."

/decl/weapon_model/wt/cutlass
	model_name = "W-T 112 Cutlass"
	model_desc = "It's a short-nosed shotgun. A favourite of many border worlds due to being cheap and reliable."

/decl/weapon_model/wt/naginata
	model_name = "W-T 3WB-CR Naginata"
	model_desc = "It's a powerful, sleek energy cannon."

/decl/weapon_model/wt/halberd
	model_name = "W-T 3XX Halberd"
	model_desc = "It's a powerful, sleek cannon."

/decl/weapon_model/wt/saber
	model_name = "W-T 212-A Saber"
	model_desc = "It's a cheap self-defense weapon, mass-produced for paramilitary and private use."
	use_icon = 'icons/obj/gun_components/wardtakahashi/wt_saber.dmi'
	ammo_indicator_icon = 'icons/obj/gun_components/wardtakahashi/wt_saber.dmi'
	ammo_use_state = "chamber_loaded"
	ammo_indicator_states = 5

/decl/weapon_model/wt/
	model_name = "W-T 3NB-ACR Wazikashi"
	model_desc = "It's a lightweight, relatively accurate and easy to use energy submachine gun."

/decl/weapon_model/wt/
	model_name = "W-T 3NB-ACR Katana"
	model_desc = "It's a lightweight energy rifle. Generally considered a cheap entry-level weapon."

/decl/weapon_model/wt/
	model_name = "W-T 212-A Longsword"
	model_desc = "It's a lightweight assault rifle. Generally considered a cheap entry-level weapon."

