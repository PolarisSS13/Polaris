/sound/turntable/test
	file = 'sound/turntable/TestLoop1.ogg'
	falloff = 2
	repeat = 1

/mob/var/music = 0

/obj/machinery/party/turntable
	name = "turntable"
	desc = "A turntable used for parties and shit."
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "turntable"
	var/playing = 0
	anchored = 1

/obj/machinery/party/mixer
	name = "mixer"
	desc = "A mixing board for mixing music"
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "mixer"
	anchored = 1


/obj/machinery/party/turntable/New()
	..()
	sleep(2)
	new /sound/turntable/test(src)
	return

/obj/machinery/party/turntable/attack_hand(mob/user as mob)

	var/t = "<B>Turntable Interface</B><br><br>"
	//t += "<A href='?src=\ref[src];on=1'>On</A><br>"
	t += "<A href='?src=\ref[src];off=1'>Off</A><br><br>"
	t += "<A href='?src=\ref[src];on1=Testloop1'>One</A><br>"
	t += "<A href='?src=\ref[src];on2=Testloop2'>TestLoop2</A><br>"
	t += "<A href='?src=\ref[src];on3=Testloop3'>TestLoop3</A><br>"

	user << browse(t, "window=turntable;size=420x700")


/obj/machinery/party/turntable/Topic(href, href_list)
	..()
	if( href_list["on1"] )
		if(src.playing == 0)
			//world << "Should be working..."
			var/sound/S = sound('sound/turntable/TestLoop1.ogg')
			S.repeat = 1
			S.channel = 10
			S.falloff = 2
			S.wait = 1
			S.environment = 0
			//for(var/mob/M in world)
			//	if(M.loc.loc == src.loc.loc && M.music == 0)
			//		world << "Found the song..."
			//		M << S
			//		M.music = 1
			var/area/A = src.loc.loc

			for(var/obj/machinery/party/lasermachine/L in A)
				L.turnon()
			playing = 1
			while(playing == 1)
				for(var/mob/M in world)
					if((M.loc.loc in A) && M.music == 0)
						//world << "Found the song..."
						M << S
						M.music = 1
					else if(!(M.loc.loc in A) && M.music == 1)
						var/sound/Soff = sound(null)
						Soff.channel = 10
						M << Soff
						M.music = 0
				sleep(10)
			return
	if( href_list["on2"] )
		if(src.playing == 0)
			//world << "Should be working..."
			var/sound/S = sound('sound/turntable/TestLoop2.ogg')
			S.repeat = 1
			S.channel = 10
			S.falloff = 2
			S.wait = 1
			S.environment = 0
			//for(var/mob/M in world)
			//	if(M.loc.loc == src.loc.loc && M.music == 0)
			//		world << "Found the song..."
			//		M << S
			//		M.music = 1
			var/area/A = src.loc.loc
			for(var/obj/machinery/party/lasermachine/L in A)
				L.turnon()
			playing = 1
			while(playing == 1)
				for(var/mob/M in world)
					if(M.loc.loc == src.loc.loc && M.music == 0)
						//world << "Found the song..."
						M << S
						M.music = 1
					else if(M.loc.loc != src.loc.loc && M.music == 1)
						var/sound/Soff = sound(null)
						Soff.channel = 10
						M << Soff
						M.music = 0
				sleep(10)
			return
	if( href_list["on3"] )
		if(src.playing == 0)
			//world << "Should be working..."
			var/sound/S = sound('sound/turntable/TestLoop3.ogg')
			S.repeat = 1
			S.channel = 10
			S.falloff = 2
			S.wait = 1
			S.environment = 0
			//for(var/mob/M in world)
			//	if(M.loc.loc == src.loc.loc && M.music == 0)
			//		world << "Found the song..."
			//		M << S
			//		M.music = 1
			var/area/A = src.loc.loc
			for(var/obj/machinery/party/lasermachine/L in A)
				L.turnon()
			playing = 1
			while(playing == 1)
				for(var/mob/M in world)
					if(M.loc.loc == src.loc.loc && M.music == 0)
						//world << "Found the song..."
						M << S
						M.music = 1
					else if(M.loc.loc != src.loc.loc && M.music == 1)
						var/sound/Soff = sound(null)
						Soff.channel = 10
						M << Soff
						M.music = 0
				sleep(10)
			return


	if( href_list["off"] )
		if(src.playing == 1)
			var/sound/S = sound(null)
			S.channel = 10
			S.wait = 1
			for(var/mob/M in world)
				M << S
				M.music = 0
			playing = 0
			var/area/A = src.loc.loc
			for(var/obj/machinery/party/lasermachine/L in A)
				L.turnoff()

/obj/machinery/party/lasermachine
	name = "laser machine"
	desc = "A laser machine that shoots lasers."
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "lasermachine"
	anchored = 1
	var/mirrored = 0
	var/list/lasers = list()
	var/on

/obj/effects/laser
	name = "laser"
	desc = "A laser..."
	icon = 'icons/effects/lasers2.dmi'
	icon_state = "laserred1"
	anchored = 1
	layer = OBJ_LAYER
	plane = ABOVE_MOB_PLANE

/obj/machinery/party/lasermachine/New()
	turnoff() 		//||so verbs are correctly set
	..()

/obj/machinery/party/lasermachine/Destroy()
	turnoff()
	return ..()

/obj/machinery/party/lasermachine/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/party/lasermachine/attack_hand(mob/user as mob)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	if(!on)
		turnon()
	else
		turnoff()

/obj/machinery/party/lasermachine/verb/turn_on()
	set name = "Turn on"
	set category = "Object"
	set src in view(1)

	if(usr.stat)
		return

	turnon()

	verbs -= /obj/machinery/party/lasermachine/verb/turn_off
	verbs -= /obj/machinery/party/lasermachine/verb/turn_on

	if(on)
		verbs += /obj/machinery/party/lasermachine/verb/turn_off
	else
		verbs += /obj/machinery/party/lasermachine/verb/turn_on
/obj/machinery/party/lasermachine/verb/turn_off()
	set name = "Turn off"
	set category = "Object"
	set src in oview(1)

	if(usr.stat)
		return

	turnoff()

	verbs -= /obj/machinery/party/lasermachine/verb/turn_off
	verbs -= /obj/machinery/party/lasermachine/verb/turn_on

	if(!on)
		verbs += /obj/machinery/party/lasermachine/verb/turn_on
	else
		verbs += /obj/machinery/party/lasermachine/verb/turn_off

/obj/machinery/party/lasermachine/proc/turnon()
	var/wall = 0
	var/cycle = 1
	var/area/A = get_area(src)
	var/X = 1
	var/Y = 0
	on = 1
	if(mirrored == 0 && dir == 2)
		while(wall == 0)
			if(cycle == 1)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred1"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
			if(cycle == 2)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred2"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				Y++
			if(cycle == 3)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred3"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
	if(mirrored == 1 && dir == 2)
		while(wall == 0)
			if(cycle == 1)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred1m"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				Y++
			if(cycle == 2)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred2m"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
			if(cycle == 3)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x+X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred3m"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
	if(mirrored == 0 && dir == 8)
		while(wall == 0)
			if(cycle == 1)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x-X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred3m"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
			if(cycle == 2)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x-X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred2m"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				Y++
			if(cycle == 3)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x-X
				F.y = src.y+Y
				F.z = src.z
				F.icon_state = "laserred1m"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
	if(mirrored == 1 && dir == 8)
		while(wall == 0)
			if(cycle == 1)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x-X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred3"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++
			if(cycle == 2)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x-X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred2"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				Y++
			if(cycle == 3)
				var/obj/effects/laser/F = new/obj/effects/laser(src)
				F.x = src.x-X
				F.y = src.y-Y
				F.z = src.z
				F.icon_state = "laserred1"
				lasers += F
				var/area/AA = get_area(F)
				var/turf/T = get_turf(F)
				if(T.density == 1 || AA.name != A.name)
					lasers -= F
					qdel(F)
					return
				cycle++
				if(cycle > 3)
					cycle = 1
				X++



/obj/machinery/party/lasermachine/proc/turnoff()
	on = 0
	for(var/obj/effects/laser/F in lasers)
		qdel(F)