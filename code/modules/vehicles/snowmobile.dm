/obj/vehicle/snowmobile
	name = "snowmobile"
	desc = "An electric snowmobile for traversing snow and ice with ease! Other terrain, not so much."
	description_info = "Use ctrl-click to quickly toggle the engine if you're adjacent. Alt-click to quickly remove keys. Click-drag a person to mount as a passenger."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "snowmobile"

	load_item_visible = 1
	mob_offset_y = 5
	health = 100
	maxhealth = 100

	locked = 0
	powered = 1
	paint_color = "#ffffff"
	max_buckled_mobs = 2

	var/speed_mod = 0.6 //Speed on non-specially-defined tiles
	var/outdoors_speed_mod = 0.7 //The general 'outdoors' speed. I.E., the general difference you'll be at when driving outside on ideal terrain (...Snow)
	var/obj/item/weapon/key/key
	var/key_type = /obj/item/weapon/key/snowmobile
	var/snomo_icon = "snowmobile"
	var/riding_datum_type = /datum/riding/snowmobile
	var/datum/looping_sound/vehicle_engine/soundloop

/obj/item/weapon/key/snowmobile
	name = "key"
	desc = "A keyring with a small steel key, and an ice-blue fob reading \"CHILL\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "sno_keys"
	w_class = ITEMSIZE_TINY

/obj/vehicle/snowmobile/Initialize()
	. = ..()
	riding_datum = new riding_datum_type(src)
	key = new key_type(src)
	cell = new /obj/item/weapon/cell/high(src)
	soundloop = new(list(src), FALSE)
	turn_off()
	update_icon()

/obj/vehicle/snowmobile/built/Initialize()
	key = new key_type(src)
	dir = 2
	. = ..()
	turn_off()

/obj/vehicle/snowmobile/random/Initialize()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))
	. = ..()

/obj/vehicle/snowmobile/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/vehicle/snowmobile/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, key_type))
		if(!key)
			user.drop_item()
			W.forceMove(src)
			key = W
			verbs += /obj/vehicle/train/engine/verb/remove_key
		return
	if(istype(W, /obj/item/device/multitool) && open)
		var/new_paint = input("Please select paint color.", "Paint Color", paint_color) as color|null
		if(new_paint)
			paint_color = new_paint
			update_icon()
			return
	..()

/obj/vehicle/snowmobile/CtrlClick(var/mob/user)
	if(!key)
		to_chat(user, "You don't have the key to \the [src].")
		return
	if(Adjacent(user))
		toggle()
	else
		return ..()

/obj/vehicle/snowmobile/verb/toggle()
	set name = "Toggle Engine"
	set category = "Vehicle"
	set src in view(0)

	if(!isliving(usr) || ismouse(usr))
		return

	if(usr.incapacitated())
		return

	if(!key)
		to_chat(usr, "You don't have the key to \the [src].")
		return

	if(!on && cell && cell.charge > charge_use)
		turn_on()
		soundloop.start()
		src.visible_message("\The [src] rumbles to life.", "You hear something rumble deeply.")
	else
		turn_off()


/obj/vehicle/snowmobile/AltClick(var/mob/user)
	if(Adjacent(user))
		remove_key()
	else
		return ..()

/obj/vehicle/snowmobile/turn_off()
	..()
	if(!on)
		soundloop.stop()
		src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")

/obj/vehicle/snowmobile/verb/remove_key()
	set name = "Remove key"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!key || (load && load != usr))
		return

	if(on)
		turn_off()

	key.loc = usr.loc
	if(!usr.get_active_hand())
		usr.put_in_hands(key)
	key = null

	verbs -= /obj/vehicle/train/engine/verb/remove_key

/obj/vehicle/snowmobile/load(var/atom/movable/C, var/mob/user as mob)
	var/mob/living/M = C
	if(!istype(C)) return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M, user)

/obj/vehicle/snowmobile/MouseDrop_T(var/atom/movable/C, var/mob/user as mob)
	if(ismob(C))
		if(C in buckled_mobs)
			user_unbuckle_mob(C, user)
		else
			user_buckle_mob(C, user)
	else
		..(C, user)

/obj/vehicle/snowmobile/attack_hand(var/mob/user as mob)
	if(user == load)
		unload(load, user)
		to_chat(user, "You unbuckle yourself from \the [src].")
		return
	if(user in buckled_mobs)
		unbuckle_mob(user)
		return
	else if(!load && load(user, user))
		to_chat(user, "You buckle yourself to \the [src].")
		return

/obj/vehicle/snowmobile/relaymove(mob/user, direction)
	if(user != load || !on)
		return 0
	if(Move(get_step(src, direction)))
		return 1
	return 0

/obj/vehicle/snowmobile/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..() //Move it move it, so we can test it test it.
	if(!istype(loc, old_loc.type) && !istype(old_loc, loc.type))	//Did we move at all, and are we changing turf types?
		if(istype(loc, /turf/simulated/floor/water))
			speed_mod = outdoors_speed_mod * 6 //Well that was a stupid idea wasn't it?
		else if(istype(loc, /turf/simulated/floor/outdoors/rocks))
			speed_mod = initial(speed_mod) * 1.5 //Rocks are hard, hard and skids don't mix so you're relying on the treads. Basically foot speed.
		else if(istype(loc, /turf/simulated/floor/outdoors/dirt) || istype(loc, /turf/simulated/floor/outdoors/grass) || istype(loc, /turf/simulated/floor/outdoors/newdirt) || istype(loc, /turf/simulated/floor/outdoors/newdirt_nograss))
			speed_mod = outdoors_speed_mod //Dirt and grass aren't strictly what this is designed for but its a baseline.
		else if(istype(loc, /turf/simulated/floor/outdoors/mud))
			speed_mod = outdoors_speed_mod * 1.4 //Workable, not great though.
		else if(istype(loc, /turf/simulated/floor/outdoors/snow) || istype(loc, /turf/simulated/floor/outdoors/ice))
			speed_mod = outdoors_speed_mod * 0.8 //Now we're talking!
		else
			speed_mod = initial(speed_mod)


/obj/vehicle/snowmobile/update_icon()
	cut_overlays()

	var/image/bodypaint = image('icons/obj/vehicles.dmi', "[snomo_icon]_a", src.layer)
	bodypaint.color = paint_color
	add_overlay(bodypaint)
	var/image/overmob = image('icons/obj/vehicles.dmi', "[snomo_icon]_overlay", MOB_LAYER + 1)
	var/image/overmob_color = image('icons/obj/vehicles.dmi', "[snomo_icon]_overlay_a", MOB_LAYER + 1)
	overmob.plane = MOB_PLANE
	overmob_color.plane = MOB_PLANE
	overmob_color.color = paint_color
	add_overlay(overmob)
	add_overlay(overmob_color)
	..()


/obj/vehicle/snowmobile/Bump(atom/Obstacle)
	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T)	//bump things away when hit

	if(istype(A, /mob/living))
		var/mob/living/M = A
		visible_message("<span class='danger'>[src] knocks over [M]!</span>")
		M.apply_effects(2, 2)				// Knock people down for a short moment
		M.apply_damages(8 / move_delay)		// Smaller amount of damage than a tug, since this will always be possible because snowmobiles don't have safeties.
		var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
		if(!emagged)						// By the power of Bumpers TM, it won't throw them ahead of the snowmobile's path unless it's emagged or the person turns.
			health -= round(M.mob_size / 2)
			throw_dirs -= dir
			throw_dirs -= get_dir(M, src) //Don't throw it AT the snowmobile either.
		else
			health -= round(M.mob_size / 4) // Less damage if they actually put the point in to emag it.
		var/turf/T2 = get_step(A, pick(throw_dirs))
		M.throw_at(T2, 1, 1, src)
		if(istype(load, /mob/living/carbon/human))
			var/mob/living/D = load
			to_chat(D, "<span class='danger'>You hit [M]!</span>")
			add_attack_logs(D,M,"Ran over with [src.name]")


/obj/vehicle/snowmobile/RunOver(var/mob/living/M)
	..()
	var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
	if(!emagged)
		throw_dirs -= dir
	var/turf/T = get_step(M, pick(throw_dirs))
	M.throw_at(T, 1, 1, src)