/obj/item/integrated_circuit/manipulation
	category = /obj/item/integrated_circuit/manipulation
	category_text = "Manipulation"

/obj/item/integrated_circuit/manipulation/weapon_firing
	name = "weapon firing mechanism"
	desc = "This somewhat complicated system allows one to slot in a gun, direct it towards a position, and remotely fire it."
	extended_desc = "The firing mechanism can slot in most ranged weapons, ballistic and energy.  \
	The first and second inputs need to be numbers.  They are coordinates for the gun to fire at, relative to the machine itself.  \
	The 'fire' activator will cause the mechanism to attempt to fire the weapon at the coordinates, if possible.  Note that the \
	normal limitations to firearms, such as ammunition requirements and firing delays, still hold true if fired by the mechanism."
	complexity = 20
	spawn_flags = IC_RESEARCH
	inputs = list(
		"target X rel",
		"target Y rel"
		)
	outputs = list()
	activators = list(
		"fire"
	)
	var/obj/item/weapon/gun/installed_gun = null
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)

/obj/item/integrated_circuit/manipulation/weapon_firing/Destroy()
	qdel(installed_gun)
	..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/gun = O
		if(installed_gun)
			user << "<span class='warning'>There's already a weapon installed.</span>"
			return
		user.drop_from_inventory(gun)
		installed_gun = gun
		gun.forceMove(src)
		user << "<span class='notice'>You slide \the [gun] into the firing mechanism.</span>"
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
	else
		..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attack_self(var/mob/user)
	if(installed_gun)
		installed_gun.forceMove(get_turf(src))
		user << "<span class='notice'>You slide \the [installed_gun] out of the firing mechanism.</span>"
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		installed_gun = null
	else
		user << "<span class='notice'>There's no weapon to remove from the mechanism.</span>"

/obj/item/integrated_circuit/manipulation/weapon_firing/do_work()
	if(..())
		if(!installed_gun)
			return

		var/datum/integrated_io/target_x = inputs[1]
		var/datum/integrated_io/target_y = inputs[2]

		if(target_x.data && target_y.data && isnum(target_x.data) && isnum(target_y.data))
			var/turf/T = get_turf(src)

			if(target_x.data == 0 && target_y.data == 0) // Don't shoot ourselves.
				return

			// We need to do this in order to enable relative coordinates, as locate() only works for absolute coordinates.
			var/i
			if(target_x.data > 0)
				i = abs(target_x.data)
				while(i)
					T = get_step(T, EAST)
					i--
			else if(target_x.data < 0)
				i = abs(target_x.data)
				while(i)
					T = get_step(T, WEST)
					i--

			if(target_y.data > 0)
				i = abs(target_y.data)
				while(i)
					T = get_step(T, NORTH)
					i--
			else if(target_y.data < 0)
				i = abs(target_y.data)
				while(i)
					T = get_step(T, SOUTH)
					i--

			if(!T)
				return
			installed_gun.Fire_userless(T)

/obj/item/integrated_circuit/manipulation/smoke
	name = "smoke generator"
	desc = "Unlike most electronics, creating smoke is completely intentional."
	icon_state = "smoke"
	spawn_flags = IC_RESEARCH
	extended_desc = "This smoke generator creates clouds of smoke on command.  It can also hold liquids inside, which will go \
	into the smoke clouds when activated."
	flags = OPENCONTAINER
	complexity = 20
	cooldown_per_use = 30 SECONDS
	inputs = list()
	outputs = list()
	activators = list("create smoke")

/obj/item/integrated_circuit/manipulation/smoke/New()
	..()
	create_reagents(100)

/obj/item/integrated_circuit/manipulation/smoke/do_work()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	var/datum/effect/effect/system/smoke_spread/chem/smoke_system = new()
	smoke_system.set_up(reagents, 10, 0, get_turf(src))
	spawn(0)
		for(var/i = 1 to 8)
			smoke_system.start()
		reagents.clear_reagents()

/obj/item/integrated_circuit/manipulation/injector
	name = "integrated hypo-injector"
	desc = "This scary looking thing is able to pump liquids into whatever it's pointed at."
	icon_state = "injector"
	spawn_flags = IC_DEFAULT|IC_RESEARCH
	extended_desc = "This autoinjector can push reagents into another container or someone else outside of the machine.  The target \
	must be adjacent to the machine, and if it is a person, they cannot be wearing thick clothing."
	flags = OPENCONTAINER
	complexity = 20
	cooldown_per_use = 6 SECONDS
	inputs = list("target ref", "injection amount" = 5)
	outputs = list()
	activators = list("inject")
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 3)

/obj/item/integrated_circuit/manipulation/injector/New()
	..()
	create_reagents(30)

/obj/item/integrated_circuit/manipulation/injector/proc/inject_amount()
	var/datum/integrated_io/amount = inputs[2]
	if(isnum(amount.data))
		return Clamp(amount.data, 0, 30)

/obj/item/integrated_circuit/manipulation/injector/do_work()
	set waitfor = 0 // Don't sleep in a proc that is called by a processor without this set, otherwise it'll delay the entire thing

	var/datum/integrated_io/target = inputs[1]
	var/atom/movable/AM = target.data_as_type(/atom/movable)
	if(!istype(AM)) //Invalid input
		return
	if(!reagents.total_volume) // Empty
		return
	if(AM.can_be_injected_by(src))
		if(isliving(AM))
			var/turf/T = get_turf(AM)
			T.visible_message("<span class='warning'>[src] is trying to inject [AM]!</span>")
			sleep(3 SECONDS)
			if(!AM.can_be_injected_by(src))
				return
			var/contained = reagents.get_reagents()
			var/trans = reagents.trans_to_mob(target, inject_amount(), CHEM_BLOOD)
			message_admins("[src] injected \the [AM] with [trans]u of [contained].")
			to_chat(AM, "<span class='notice'>You feel a tiny prick!</span>")
			visible_message("<span class='warning'>[src] injects [AM]!</span>")
		else
			reagents.trans_to(AM, inject_amount())

/obj/item/integrated_circuit/manipulation/reagent_pump
	name = "reagent pump"
	desc = "Moves liquids safely inside a machine, or even nearby it."
	icon_state = "reagent_pump"
	spawn_flags = IC_DEFAULT|IC_RESEARCH
	extended_desc = "This is a pump, which will move liquids from the source ref to the target ref.  The third pin determines \
	how much liquid is moved per pulse, between 0 and 50.  The pump can move reagents to any open container inside the machine, or \
	outside the machine if it is next to the machine.  Note that this cannot be used on entities."
	flags = OPENCONTAINER
	complexity = 8
	inputs = list("source ref", "target ref", "injection amount" = 10)
	outputs = list()
	activators = list("transfer reagents")
	var/transfer_amount = 10
	origin_tech = list(TECH_ENGINEERING = 1, TECH_DATA = 1, TECH_BIO = 2)

/obj/item/integrated_circuit/manipulation/reagent_pump/on_data_written()
	var/datum/integrated_io/amount = inputs[3]
	if(isnum(amount.data))
		amount.data = Clamp(amount.data, 0, 50)
		transfer_amount = amount.data

/obj/item/integrated_circuit/manipulation/reagent_pump/do_work()
	var/datum/integrated_io/A = inputs[1]
	var/datum/integrated_io/B = inputs[2]
	var/atom/movable/source = A.data_as_type(/atom/movable)
	var/atom/movable/target = B.data_as_type(/atom/movable)
	if(!istype(source) || !istype(target)) //Invalid input
		return
	var/turf/T = get_turf(src)
	if(source.Adjacent(T) && target.Adjacent(T))
		if(!source.reagents || !target.reagents)
			return
		if(ismob(source) || ismob(target))
			return
		if(!source.is_open_container() || !target.is_open_container())
			return
		if(!source.reagents.get_free_space() || !target.reagents.get_free_space())
			return

		source.reagents.trans_to(target, transfer_amount)

// May make a reagent subclass of circuits in future.
/obj/item/integrated_circuit/manipulation/reagent_storage
	name = "reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u."
	icon_state = "reagent_storage"
	spawn_flags = IC_DEFAULT|IC_RESEARCH
	extended_desc = "This is effectively an internal beaker."
	flags = OPENCONTAINER
	complexity = 4
	inputs = list()
	outputs = list("volume used")
	activators = list()
	origin_tech = list(TECH_ENGINEERING = 1, TECH_DATA = 1, TECH_BIO = 1)

/obj/item/integrated_circuit/manipulation/reagent_storage/New()
	..()
	create_reagents(60)

/obj/item/integrated_circuit/manipulation/reagent_storage/on_reagent_change()
	var/datum/integrated_io/A = outputs[1]
	A.data = reagents.total_volume
	A.push_data()

/obj/item/integrated_circuit/manipulation/reagent_storage/cryo
	name = "cryo reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u.  This will also suppress reactions."
	icon_state = "reagent_storage_cryo"
	spawn_flags = IC_RESEARCH
	extended_desc = "This is effectively an internal cryo beaker."
	flags = OPENCONTAINER | NOREACT
	complexity = 8
	inputs = list()
	outputs = list("volume used")
	activators = list()
	origin_tech = list(TECH_MATERIALS = 3, TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)

/obj/item/integrated_circuit/manipulation/locomotion
	name = "locomotion circuit"
	desc = "This allows a machine to move in a given direction."
	icon_state = "locomotion"
	spawn_flags = IC_DEFAULT|IC_RESEARCH
	extended_desc = "The circuit accepts a number as a direction to move towards.<br>  \
	North/Fore = 1,<br>\
	South/Aft = 2,<br>\
	East/Starboard = 4,<br>\
	West/Port = 8,<br>\
	Northeast = 5,<br>\
	Northwest = 9,<br>\
	Southeast = 6,<br>\
	Southwest = 10<br>\
	<br>\
	Pulsing the 'step towards dir' activator pin will cause the machine to move a meter in that direction, assuming it is not \
	being held, or anchored in some way.  It should be noted that heavy machines will be unable to move."
	complexity = 20
	inputs = list("dir num")
	outputs = list()
	activators = list("step towards dir")
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)

/obj/item/integrated_circuit/manipulation/locomotion/do_work()
	..()
	var/turf/T = get_turf(src)
	if(T && istype(loc, /obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/machine = loc
		if(machine.anchored || machine.w_class >= ITEMSIZE_LARGE)
			return
		if(machine.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
			var/datum/integrated_io/wanted_dir = inputs[1]
			if(isnum(wanted_dir.data))
				step(machine, wanted_dir.data)

/obj/item/integrated_circuit/manipulation/grenade
	name = "grenade primer"
	desc = "This circuit comes with the ability to attach most types of grenades at prime them at will."
	extended_desc = "Time between priming and detonation is limited to between 1 to 12 seconds but is optional. \
					If unset, not a number, or a number less than 1 then the grenade's built-in timing will be used. \
					Beware: Once primed there is no aborting the process!"
	icon_state = "grenade"
	spawn_flags = IC_RESEARCH
	complexity = 30
	size = 2
	inputs = list("detonation time")
	outputs = list()
	activators = list("prime grenade")
	var/obj/item/weapon/grenade/attached_grenade

/obj/item/integrated_circuit/manipulation/grenade/Destroy()
	if(attached_grenade && !attached_grenade.active)
		attached_grenade.dropInto(loc)
	attached_grenade = null
	. = ..()

/obj/item/integrated_circuit/manipulation/grenade/attackby(var/obj/item/weapon/grenade/G, var/mob/user)
	if(istype(G))
		if(attached_grenade)
			to_chat(user, "<span class='warning'>There is already a grenade attached!</span>")
		else if(user.unEquip(G, target = src))
			attached_grenade = G
			size += G.w_class
			desc += " \An [attached_grenade] is attached to it!"
			user.visible_message("<span class='warning'>\The [user] attaches \a [G] to \the [src]!</span>", "<span class='notice'>You attach \the [G] to \the [src].</span>")
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/attack_self(var/mob/user)
	if(attached_grenade)
		user.visible_message("<span class='warning'>\The [user] removes \an [attached_grenade] from \the [src]!</span>", "<span class='notice'>You remove \the [attached_grenade] from \the [src].</span>")
		user.put_in_any_hand_if_possible(attached_grenade) || attached_grenade.dropInto(loc)
		attached_grenade = null
		size = initial(size)
		desc = initial(desc)
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

/obj/item/integrated_circuit/manipulation/bluespace_rift
	name = "bluespace rift generator"
	desc = "This powerful circuit can open rifts to another realspace location through bluespace."
	extended_desc = "If a valid teleporter console is supplied as input then its selected teleporter beacon will be used as \
	destination point, and if not an undefined destination point is selected. Rift direction is a cardinal value determening in \
	which direction the rift will be opened, relative to the local north. A direction value of 0 will open the rift on top of \
	the assembly, and any other non-cardinal values will open the rift in the assembly's current facing."
	icon_state = "bluespace"
	spawn_flags = IC_RESEARCH
	flags = OPENCONTAINER
	complexity = 25
	size = 3
	cooldown_per_use = 10 SECONDS
	inputs = list("teleporter", "rift direction" = 0)
	outputs = list()
	activators = list("open rift")
	origin_tech = list(TECH_MAGNET = 3, TECH_BLUESPACE = 4)
	matter = list(DEFAULT_WALL_MATERIAL = 10000)

/obj/item/integrated_circuit/manipulation/bluespace_rift/do_work()
	var/datum/integrated_io/tdata = inputs[1]
	var/datum/integrated_io/step_dir = inputs[2]

	var/turf/rift_location = get_turf(src)
	if(!rift_location || !isPlayerLevel(rift_location.z))
		playsound(src, 'sound/effects/sparks2.ogg', 50, 1)
		return

	if(isnum(step_dir.data) && (!step_dir.data || step_dir.data in cardinal))
		rift_location = get_step(rift_location, step_dir.data) || rift_location
	else
		rift_location = get_step(rift_location, dir) || rift_location

	var/obj/machinery/computer/teleporter/tporter = tdata.data_as_type(/obj/machinery/computer/teleporter)
	if(tporter && tporter.locked && !tporter.one_time_use && tporter.operable())
		new /obj/effect/portal(rift_location, get_turf(tporter.locked))
	else
		var/turf/destination = get_random_turf_in_range(src, 10)
		if(destination)
			new /obj/effect/portal(rift_location, destination)
		else
			playsound(src, 'sound/effects/sparks2.ogg', 50, 1)