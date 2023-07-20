/obj/item/robot_module/drone/swarm
	name = "swarm drone module"
	display_name = "Swarm Drone"
	unavailable_by_default = TRUE
	modules = list(
		/obj/item/rcd/electric/mounted/borg/swarm,
		/obj/item/flash/robot,
		/obj/item/handcuffs/cable/tape/cyborg,
		/obj/item/melee/baton/robot,
		/obj/item/gun/energy/taser/mounted/cyborg/swarm,
		/obj/item/matter_decompiler/swarm
	)
	var/id

/obj/item/robot_module/drone/swarm/build_equipment()
	. = ..()
	var/mob/living/silicon/robot/R = loc
	if(istype(R) && R.idcard)
		id = R.idcard
		modules += id

/obj/item/robot_module/drone/swarm/ranged
	name = "swarm gunner module"

/obj/item/robot_module/drone/swarm/ranged/build_equipment()
	. = ..()
	modules += new /obj/item/gun/energy/xray/swarm(src)

/obj/item/robot_module/drone/swarm/melee/build_equipment()
	. = ..()
	modules += new /obj/item/melee/energy/sword/ionic_rapier/lance(src)
