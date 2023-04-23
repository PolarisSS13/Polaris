/client/proc/spawn_tanktransferbomb()
	set category = "Debug"
	set desc = "Spawn a tank transfer valve bomb"
	set name = "Instant TTV"

	if(!check_rights(R_SPAWN)) return

	var/obj/effect/spawner/newbomb/proto = /obj/effect/spawner/newbomb

	var/p = input("Enter phoron amount (mol):","Phoron", initial(proto.phoron_amt)) as num|null
	if(p == null) return

	var/o = input("Enter oxygen amount (mol):","Oxygen", initial(proto.oxygen_amt)) as num|null
	if(o == null) return

	var/c = input("Enter carbon dioxide amount (mol):","Carbon Dioxide", initial(proto.carbon_amt)) as num|null
	if(c == null) return

	new /obj/effect/spawner/newbomb(get_turf(mob), p, o, c)

/obj/effect/spawner/newbomb
	name = "TTV bomb spawner"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

	var/assembly_type = /obj/item/assembly/signaler

	//Note that the maximum amount of gas you can put in a 70L air tank at 1013.25 kPa and 519K is 16.44 mol.
	var/phoron_amt = 12
	var/oxygen_amt = 18
	var/carbon_amt = 0

/obj/effect/spawner/newbomb/do_spawn(mapload, phoron, oxygen, carbon)
	if (!assembly_type)
		stack_trace("[type] attempted to spawn with a null assembly type")
		return
	to_world("[phoron], [oxygen], [carbon]")
	phoron_amt = !isnull(phoron) ? phoron : phoron_amt
	oxygen_amt = !isnull(oxygen) ? oxygen : oxygen_amt
	carbon_amt = !isnull(carbon) ? carbon : carbon_amt

	var/obj/item/transfer_valve/V = new(get_turf(src))
	var/obj/item/tank/phoron/PT = new(V)
	var/obj/item/tank/oxygen/OT = new(V)

	V.tank_one = PT
	V.tank_two = OT

	PT.master = V
	OT.master = V

	PT.valve_welded = TRUE
	PT.air_contents.gas["phoron"] = phoron_amt
	PT.air_contents.gas["carbon_dioxide"] = carbon_amt
	PT.air_contents.total_moles = phoron_amt + carbon_amt
	PT.air_contents.temperature = PHORON_MINIMUM_BURN_TEMPERATURE + 1
	PT.air_contents.update_values()

	OT.valve_welded = TRUE
	OT.air_contents.gas["oxygen"] = oxygen_amt
	OT.air_contents.total_moles = oxygen_amt
	OT.air_contents.temperature = PHORON_MINIMUM_BURN_TEMPERATURE + 1
	OT.air_contents.update_values()

	var/obj/item/assembly/S = new assembly_type(V)
	V.attached_device = S

	S.holder = V
	S.toggle_secure()

	V.update_icon()

/obj/effect/spawner/newbomb/timer
	name = "TTV bomb spawner - timer"
	assembly_type = /obj/item/assembly/timer

/obj/effect/spawner/newbomb/timer/syndicate
	name = "TTV bomb spawner - merc"
	//High yield bombs. Yes, it is possible to make these with toxins
	phoron_amt = 18.5
	oxygen_amt = 28.5

/obj/effect/spawner/newbomb/proximity
	name = "TTV bomb spawner - proximity"
	assembly_type = /obj/item/assembly/prox_sensor
