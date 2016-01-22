/obj/item/gun_component/chamber/laser/tag
	weapon_type = GUN_PISTOL
	name = "defocusing tinted lens"
	max_shots = 10
	self_recharge_time = 4
	var/current_colour = "blue"

/obj/item/gun_component/chamber/laser/tag/installed()
	set_holder_colour()

/obj/item/gun_component/chamber/laser/tag/proc/set_holder_colour()
	if(!holder)
		return
	switch(current_colour)
		if("red")
			holder.color = "#FF0000"
		if("blue")
			holder.color = "#0000FF"
		else
			holder.color = null

/obj/item/gun_component/chamber/laser/tag/do_user_interaction(var/mob/user)
	current_colour = (current_colour == "blue" ? "red" : "blue")
	user << "<span class='notice'>You set the gun to fire [current_colour] beams.</span>"
	set_holder_colour()
	return

/obj/item/gun_component/chamber/laser/tag/consume_next_projectile()
	if(!power_supply || !power_supply.checked_use(charge_cost))
		return null
	switch(current_colour)
		if("blue")
			return new /obj/item/projectile/beam/lastertag/blue(src)
		if("red")
			return new /obj/item/projectile/beam/lastertag/red(src)
		if("omni")
			return new /obj/item/projectile/beam/lastertag/omni(src)
	return null
