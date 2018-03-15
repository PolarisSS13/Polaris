/obj/item/integrated_circuit/manipulation
	category_text = "Manipulation"

/obj/item/integrated_circuit/manipulation/weapon_firing
	name = "weapon firing mechanism"
	desc = "This somewhat complicated system allows one to slot in a gun, direct it towards a position, and remotely fire it."
	extended_desc = "The firing mechanism can slot in most ranged weapons, ballistic and energy.  \
	The first and second inputs need to be numbers.  They are coordinates for the gun to fire at, relative to the machine itself.  \
	The 'fire' activator will cause the mechanism to attempt to fire the weapon at the coordinates, if possible.  Note that the \
	normal limitations to firearms, such as ammunition requirements and firing delays, still hold true if fired by the mechanism."
	complexity = 20
	w_class = ITEMSIZE_NORMAL
	size = 3
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER
		)
	outputs = list()
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN
	)
	var/obj/item/weapon/gun/installed_gun = null
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	power_draw_per_use = 50 // The targeting mechanism uses this.  The actual gun uses its own cell for firing if it's an energy weapon.

/obj/item/integrated_circuit/manipulation/weapon_firing/Destroy()
	installed_gun = null // It will be qdel'd by ..() if still in our contents
	return ..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/gun = O
		if(installed_gun)
			user << "<span class='warning'>There's already a weapon installed.</span>"
			return
		user.drop_from_inventory(gun)
		installed_gun = gun
		size += gun.w_class
		gun.forceMove(src)
		user << "<span class='notice'>You slide \the [gun] into the firing mechanism.</span>"
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
	else
		..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attack_self(var/mob/user)
	if(installed_gun)
		installed_gun.forceMove(get_turf(src))
		user << "<span class='notice'>You slide \the [installed_gun] out of the firing mechanism.</span>"
		size = initial(size)
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		installed_gun = null
	else
		user << "<span class='notice'>There's no weapon to remove from the mechanism.</span>"

/obj/item/integrated_circuit/manipulation/weapon_firing/do_work()
	if(!installed_gun)
		return

	var/datum/integrated_io/target_x = inputs[1]
	var/datum/integrated_io/target_y = inputs[2]

	if(src.assembly)
		if(isnum(target_x.data))
			target_x.data = round(target_x.data)
		if(isnum(target_y.data))
			target_y.data = round(target_y.data)

		var/turf/T = get_turf(src.assembly)

		if(target_x.data == 0 && target_y.data == 0) // Don't shoot ourselves.
			return

		// We need to do this in order to enable relative coordinates, as locate() only works for absolute coordinates.
		var/i
		if(target_x.data > 0)
			i = abs(target_x.data)
			while(i > 0)
				T = get_step(T, EAST)
				i--
		else
			i = abs(target_x.data)
			while(i > 0)
				T = get_step(T, WEST)
				i--

		i = 0
		if(target_y.data > 0)
			i = abs(target_y.data)
			while(i > 0)
				T = get_step(T, NORTH)
				i--
		else if(target_y.data < 0)
			i = abs(target_y.data)
			while(i > 0)
				T = get_step(T, SOUTH)
				i--

		if(!T)
			return
		installed_gun.Fire_userless(T)

/obj/item/integrated_circuit/manipulation/locomotion
	name = "locomotion circuit"
	desc = "This allows a machine to move in a given direction."
	icon_state = "locomotion"
	extended_desc = "The circuit accepts a 'dir' number as a direction to move towards.<br>\
	Pulsing the 'step towards dir' activator pin will cause the machine to move a meter in that direction, assuming it is not \
	being held, or anchored in some way.  It should be noted that the ability to move is dependant on the type of assembly that this circuit inhabits."
	w_class = ITEMSIZE_NORMAL
	complexity = 20
//	size = 5
	inputs = list("direction" = IC_PINTYPE_DIR)
	outputs = list()
	activators = list("step towards dir" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 100

/obj/item/integrated_circuit/manipulation/locomotion/do_work()
	..()
	var/turf/T = get_turf(src)
	if(T && assembly)
		if(assembly.anchored || !assembly.can_move())
			return
		if(assembly.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
			var/datum/integrated_io/wanted_dir = inputs[1]
			if(isnum(wanted_dir.data))
				step(assembly, wanted_dir.data)


/obj/item/integrated_circuit/manipulation/grenade
	name = "grenade primer"
	desc = "This circuit comes with the ability to attach most types of grenades at prime them at will."
	extended_desc = "Time between priming and detonation is limited to between 1 to 12 seconds but is optional. \
					If unset, not a number, or a number less than 1 then the grenade's built-in timing will be used. \
					Beware: Once primed there is no aborting the process!"
	icon_state = "grenade"
	complexity = 30
	size = 2
	inputs = list("detonation time" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list("prime grenade" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	var/obj/item/weapon/grenade/attached_grenade
	var/pre_attached_grenade_type

/obj/item/integrated_circuit/manipulation/grenade/New()
	..()
	if(pre_attached_grenade_type)
		var/grenade = new pre_attached_grenade_type(src)
		attach_grenade(grenade)

/obj/item/integrated_circuit/manipulation/grenade/Destroy()
	if(attached_grenade && !attached_grenade.active)
		attached_grenade.dropInto(loc)
	detach_grenade()
	. =..()

/obj/item/integrated_circuit/manipulation/grenade/attackby(var/obj/item/weapon/grenade/G, var/mob/user)
	if(istype(G))
		if(attached_grenade)
			to_chat(user, "<span class='warning'>There is already a grenade attached!</span>")
		else if(user.unEquip(G, force=1))
			user.visible_message("<span class='warning'>\The [user] attaches \a [G] to \the [src]!</span>", "<span class='notice'>You attach \the [G] to \the [src].</span>")
			attach_grenade(G)
			G.forceMove(src)
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/attack_self(var/mob/user)
	if(attached_grenade)
		user.visible_message("<span class='warning'>\The [user] removes \an [attached_grenade] from \the [src]!</span>", "<span class='notice'>You remove \the [attached_grenade] from \the [src].</span>")
		user.put_in_any_hand_if_possible(attached_grenade) || attached_grenade.dropInto(loc)
		detach_grenade()
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/do_work()
	if(attached_grenade && !attached_grenade.active)
		var/datum/integrated_io/detonation_time = inputs[1]
		if(isnum(detonation_time.data) && detonation_time.data > 0)
			attached_grenade.det_time = between(1, detonation_time.data, 12) SECONDS
		attached_grenade.activate()
		var/atom/holder = loc
		log_and_message_admins("activated a grenade assembly. Last touches: Assembly: [holder.fingerprintslast] Circuit: [fingerprintslast] Grenade: [attached_grenade.fingerprintslast]")

// These procs do not relocate the grenade, that's the callers responsibility
/obj/item/integrated_circuit/manipulation/grenade/proc/attach_grenade(var/obj/item/weapon/grenade/G)
	attached_grenade = G
	destroyed_event.register(attached_grenade, src, /obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade)
	size += G.w_class
	desc += " \An [attached_grenade] is attached to it!"

/obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade()
	if(!attached_grenade)
		return
	destroyed_event.unregister(attached_grenade, src, /obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade)
	attached_grenade = null
	size = initial(size)
	desc = initial(desc)

/obj/item/integrated_circuit/manipulation/grenade/frag
	pre_attached_grenade_type = /obj/item/weapon/grenade/explosive
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 10)
	spawn_flags = null			// Used for world initializing, see the #defines above.

/obj/item/integrated_circuit/manipulation/grabber
	name = "grabber"
	desc = "A circuit with it's own inventory for items, used to grab and store things."
	icon_state = "grabber"
	extended_desc = "The circuit accepts a reference to an object to be grabbed and can store up to 10 objects. Modes: 1 to grab, 0 to eject the first object, and -1 to eject all objects."
	w_class = ITEMSIZE_SMALL
	size = 3

	complexity = 10
	inputs = list("target" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER)
	outputs = list("first" = IC_PINTYPE_REF, "last" = IC_PINTYPE_REF, "amount" = IC_PINTYPE_NUMBER,"contents" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50
	var/max_items = 10

/obj/item/integrated_circuit/manipulation/grabber/do_work()
	var/max_w_class = assembly.w_class
	var/atom/movable/acting_object = get_object()
	var/turf/T = get_turf(acting_object)
	var/obj/item/AM = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	if(AM)
		var/mode = get_pin_data(IC_INPUT, 2)
		if(mode == 1)
			if(check_target(AM))
				var/weightcheck = FALSE
				if (AM.w_class < max_w_class)
					weightcheck = TRUE
				else
					weightcheck = FALSE
				if((contents.len < max_items) && (weightcheck))
					AM.forceMove(src)
		if(mode == 0)
			if(contents.len)
				var/obj/item/U = contents[1]
				U.forceMove(T)
		if(mode == -1)
			if(contents.len)
				var/obj/item/U
				for(U in contents)
					U.forceMove(T)
	if(contents.len)
		set_pin_data(IC_OUTPUT, 1, contents[1])
		set_pin_data(IC_OUTPUT, 2, contents[contents.len])
	else
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, contents.len)
	set_pin_data(IC_OUTPUT, 4, contents)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/grabber/attack_self(var/mob/user)
	if(contents.len)
		var/turf/T = get_turf(src)
		var/obj/item/U
		for(U in contents)
			U.forceMove(T)
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, contents.len)
	push_data()

/obj/item/integrated_circuit/manipulation/thrower
	name = "thrower"
	desc = "A compact launcher to throw things from inside or nearby tiles."
	extended_desc = "The first and second inputs need to be numbers which correspond to coordinates to throw objects at relative to the machine itself. \
	The 'fire' activator will cause the mechanism to attempt to throw objects at the coordinates, if possible. Note that the \
	projectile need to be inside the machine, or to be on an adjacent tile, and must be medium sized or smaller."
	complexity = 15
	w_class = ITEMSIZE_SMALL
	size = 2
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER,
		"projectile" = IC_PINTYPE_REF
		)
	outputs = list()
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN
	)
	spawn_flags = IC_SPAWN_RESEARCH
	//action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/thrower/do_work()
	var/max_w_class = assembly.w_class
	var/target_x_rel = round(get_pin_data(IC_INPUT, 1))
	var/target_y_rel = round(get_pin_data(IC_INPUT, 2))
	var/obj/item/A = get_pin_data_as_type(IC_INPUT, 3, /obj/item)

	if(!A || A.anchored || A.throwing)
		return

	if(max_w_class && (A.w_class > max_w_class))
		return

	// Is the target inside the assembly or close to it?
	if(!check_target(A, exclude_components = TRUE))
		return

	var/turf/T = get_turf(get_object())
	if(!T)
		return

	// If the item is in mob's inventory, try to remove it from there.
	if(ismob(A.loc))
		var/mob/living/M = A.loc
		if(!M.unEquip(A))
			return

	var/x_abs = Clamp(T.x + target_x_rel,0,world.maxx)
	var/y_abs = Clamp(T.y + target_y_rel,0,world.maxy)
	var/range = round(Clamp(sqrt(target_x_rel*target_x_rel+target_y_rel*target_y_rel),0,8),1)

	var/atom/L = loc
	var/newmove
	if(!L)
		newmove = null
	if(isturf(L))
		newmove = L
	else
		newmove = get_turf(L)
	A.forceMove(newmove)
	A.throw_at(locate(x_abs, y_abs, T.z), range, 3)