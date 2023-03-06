/obj/item/communicator/desktop
	name = "desktop communicator"
	desc = "A static communicator unit, seen in homes, offices and the receptions of businesses across the galaxy."
	icon_state = "commstatic"
	anchored = 1
	static_name = "fixed communicator"

/obj/item/communicator/desktop/attack_hand(mob/user)
  return attack_self(user)