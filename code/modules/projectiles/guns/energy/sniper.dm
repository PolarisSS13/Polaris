/obj/item/weapon/gun/energy/sniperrifle
	name = "marksman energy rifle"
	desc = "The HI DMR 9E is an older design of Hesphaistos Industries. A designated marksman rifle capable of shooting powerful \
	ionized beams, this is a weapon to kill from a distance."
	icon_state = "sniper"
	item_state_slots = list(slot_r_hand_str = "laser", slot_l_hand_str = "laser") //placeholder
	fire_sound = 'sound/weapons/gauss_shoot.ogg'
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	charge_cost = 400
	max_shots = 4
	fire_delay = 35
	force = 10
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	accuracy = -3 //shooting at the hip
	scoped_accuracy = 0
//	requires_two_hands = 1
	one_handed_penalty = 4 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.

/obj/item/weapon/gun/energy/sniperrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)