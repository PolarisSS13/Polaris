/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = UNDER_JUNK_LAYER
	w_class = ITEMSIZE_NORMAL

/obj/structure/sign/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

/obj/structure/sign/attackby(obj/item/tool as obj, mob/user as mob)	//deconstruction
	if(tool.is_screwdriver() && !istype(src, /obj/structure/sign/double))
		playsound(src, tool.usesound, 50, 1)
		to_chat(user, "You unfasten the sign with your [tool].")
		var/obj/item/sign/S = new(src.loc)
		S.name = name
		S.desc = desc
		S.icon_state = icon_state
		//var/icon/I = icon('icons/obj/decals.dmi', icon_state)
		//S.icon = I.Scale(24, 24)
		S.sign_state = icon_state
		qdel(src)
	else ..()

/obj/item/sign
	name = "sign"
	desc = ""
	icon = 'icons/obj/decals.dmi'
	w_class = ITEMSIZE_NORMAL		//big
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/tool as obj, mob/user as mob)	//construction
	if(tool.is_screwdriver() && isturf(user.loc))
		var/direction = input("In which direction?", "Select direction.") in list("North", "East", "South", "West", "Cancel")
		if(direction == "Cancel") return
		var/obj/structure/sign/S = new(user.loc)
		switch(direction)
			if("North")
				S.pixel_y = 32
			if("East")
				S.pixel_x = 32
			if("South")
				S.pixel_y = -32
			if("West")
				S.pixel_x = -32
			else return
		S.name = name
		S.desc = desc
		S.icon_state = sign_state
		to_chat(user, "You fasten \the [S] with your [tool].")
		qdel(src)
	else ..()

/obj/structure/sign/double/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/double/map/left
	icon_state = "map-left"

/obj/structure/sign/double/map/right
	icon_state = "map-right"

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'."
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'."
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM"
	desc = "A guidance sign which reads 'EXAM ROOM'."
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'."
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL LEADS TO SPACE'."
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'."
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'."
	icon_state = "fire"

/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking"

/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking2"

/obj/structure/sign/warning
	name = "\improper WARNING"
	icon_state = "securearea"

/obj/structure/sign/warning/New()
	..()
	desc = "A warning sign which reads '[name]'."

/obj/structure/sign/warning/airlock
	name = "\improper EXTERNAL AIRLOCK"
	icon_state = "doors"

/obj/structure/sign/warning/biohazard
	name = "\improper BIOHAZARD"
	icon_state = "bio"

/obj/structure/sign/warning/bomb_range
	name = "\improper BOMB RANGE"
	icon_state = "blast"

/obj/structure/sign/warning/caution
	name = "\improper CAUTION"

/obj/structure/sign/warning/compressed_gas
	name = "\improper COMPRESSED GAS"
	icon_state = "hikpa"

/obj/structure/sign/warning/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE"
	icon_state = "deathsposal"

/obj/structure/sign/warning/docking_area
	name = "\improper KEEP CLEAR: DOCKING AREA"

/obj/structure/sign/warning/evac
	name = "\improper KEEP CLEAR: EVAC DOCKING AREA"
	icon_state = "evac"

/obj/structure/sign/warning/engineering_access
	name = "\improper ENGINEERING ACCESS"
	icon_state = "engine"

/obj/structure/sign/warning/fire
	name = "\improper DANGER: FIRE"
	icon_state = "fire"

/obj/structure/sign/warning/high_voltage
	name = "\improper HIGH VOLTAGE"
	icon_state = "shock"

/obj/structure/sign/warning/hot_exhaust
	name = "\improper HOT EXHAUST"
	icon_state = "fire"

/obj/structure/sign/warning/internals_required
	name = "\improper INTERNALS REQUIRED"

/obj/structure/sign/warning/lethal_turrets
	name = "\improper LETHAL TURRETS"
	icon_state = "turrets"

/obj/structure/sign/warning/lethal_turrets/New()
	..()
	desc += " Enter at own risk!."

/obj/structure/sign/warning/mail_delivery
	name = "\improper MAIL DELIVERY"
	icon_state = "mail"

/obj/structure/sign/warning/moving_parts
	name = "\improper MOVING PARTS"
	icon_state = "movingparts"

/obj/structure/sign/warning/nosmoking_1
	name = "\improper NO SMOKING"
	icon_state = "nosmoking"

/obj/structure/sign/warning/nosmoking_2
	name = "\improper NO SMOKING"
	icon_state = "nosmoking2"

/obj/structure/sign/warning/pods
	name = "\improper ESCAPE PODS"
	icon_state = "pods"

/obj/structure/sign/warning/radioactive
	name = "\improper RADIOACTIVE AREA"
	icon_state = "radiation"

/obj/structure/sign/warning/secure_area
	name = "\improper SECURE AREA"
	icon_state = "securearea2"

/obj/structure/sign/warning/secure_area/armory
	name = "\improper ARMORY"
	icon_state = "armory"

/obj/structure/sign/warning/server_room
	name = "\improper SERVER ROOM"
	icon_state = "server"

/obj/structure/sign/warning/siphon_valve
	name = "\improper SIPHON VALVE"

/obj/structure/sign/warning/vacuum
	name = "\improper HARD VACUUM AHEAD"
	icon_state = "space"

/obj/structure/sign/warning/vent_port
	name = "\improper EJECTION/VENTING PORT"

/obj/structure/sign/warning/emergence
	name = "\improper EMERGENT INTELLIGENCE DETAILS"
	icon_state = "rogueai"

/obj/structure/sign/warning/falling
	name = "\improper FALL HAZARD"
	icon_state = "falling"

/obj/structure/sign/warning/lava
	name = "\improper MOLTEN SURFACE"
	icon_state = "lava"

/obj/structure/sign/warning/acid
	name = "\improper ACIDIC SURFACE"
	icon_state = "acid"

/obj/structure/sign/redcross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "bluecross"

/obj/structure/sign/greencross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "bluecross2"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "\improper AI developers plaque"
	desc = "Next to the extremely long list of names and job titles. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA atmospherics division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/periodic
	name = "periodic table"
	desc = "A sign reminding those visiting of the elements of the periodic table- though, they should have memorized them by now."
	icon_state = "periodic"

/obj/structure/sign/double/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/double/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/maltesefalcon/right
	icon_state = "maltesefalcon-right"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE'."
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'."
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'."
	icon_state = "hydro1"

/obj/structure/sign/hydro
	name = "\improper HYDROPONICS"
	desc = "A sign labelling an area as a place where plants are grown."
	icon_state = "hydro2"

/obj/structure/sign/hydrostorage
	name = "\improper HYDROPONICS STORAGE"
	desc = "A sign labelling an area as a place where plant growing supplies are kept."
	icon_state = "hydro3"

/obj/structure/sign/xenobio
	name = "\improper XENOBIOLOGY"
	desc = "A warning sign which reads XENOBIOLOGY."
	icon_state = "xenobio3"

/obj/structure/sign/directions
	name = "direction sign"
	desc = "A direction sign, claiming to know the way."
	icon_state = "direction"
	icon = 'icons/obj/decals_directions.dmi'

/obj/structure/sign/directions/New()
	..()
	desc = "A direction sign, pointing out which way \the [src] is."

/obj/structure/sign/directions/science
	name = "\improper Science department"
	desc = "A direction sign, pointing out which way the Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "\improper Engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "\improper Security department"
	desc = "A direction sign, pointing out which way the Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/armory
	name = "\improper Armory"
	desc = "A direction sign, pointing out which way the Armory is."
	icon_state = "direction_armory"

/obj/structure/sign/directions/medical
	name = "\improper Medical Bay"
	desc = "A direction sign, pointing out which way the Medical Bay is."
	icon_state = "direction_med"

/obj/structure/sign/directions/virology
	name = "\improper Virology"
	desc = "A direction sign, pointing out which way the Virology Lab is."
	icon_state = "direction_viro"

/obj/structure/sign/directions/evac
	name = "\improper Evacuation"
	desc = "A direction sign, pointing out which way the Escape Shuttle dock is."
	icon_state = "direction_evac"

/obj/structure/sign/directions/bridge
	name = "\improper Bridge"
	icon_state = "direction_bridge"
	desc = "A direction sign, pointing out which way the Bridge is."

/obj/structure/sign/directions/command
	name = "\improper Command"
	icon_state = "direction_command"
	desc = "A direction sign, pointing out which way the Command center is."

/obj/structure/sign/directions/elevator
	name = "\improper Elevator"
	desc = "A direction sign, pointing out the way to the nearest elevator."
	icon_state = "direction_elv"

/obj/structure/sign/directions/stairwell
	name = "\improper Stairwell"
	desc = "A direction sign, pointing out the way to the nearest stairwell."
	icon_state = "stairwell"

/obj/structure/sign/directions/stairs_up
	name = "\improper Stairs Up"
	desc = "A direction sign, pointing out the way to the nearest set of stairs that go up."
	icon_state = "stairs_up"

/obj/structure/sign/directions/stairs_down
	name = "\improper Stairs Down"
	desc = "A direction sign, pointing out the way to the nearest set of stairs that go down."
	icon_state = "stairs_down"

/obj/structure/sign/directions/ladderwell
	name = "\improper Access Shaft"
	desc = "A direction sign, pointing out the way to the nearest access shaft."
	icon_state = "ladderwell"

/obj/structure/sign/directions/ladder_up
	name = "\improper Ladder Up"
	desc = "A direction sign, pointing out the way to the nearest ladder that goes up."
	icon_state = "ladder_up"

/obj/structure/sign/directions/ladder_down
	name = "\improper Ladder Down"
	desc = "A direction sign, pointing out the way to the nearest ladder that goes down."
	icon_state = "ladder_down"

/obj/structure/sign/directions/cargo
	name = "\improper Cargo department"
	desc = "A direction sign, pointing out which way the Cargo department is."
	icon_state = "direction_crg"

/obj/structure/sign/directions/mining
	name = "\improper Mining department"
	desc = "A direction sign, pointing out which way the Mining department is."
	icon_state = "direction_crg"

/obj/structure/sign/directions/refinery
	name = "\improper Refinery"
	desc = "A direction sign, pointing out which way the Refinery is."
	icon_state = "direction_crg"

/obj/structure/sign/directions/cryo
	name = "\improper Cryogenic Storage"
	desc = "A direction sign, pointing out which way Cryogenic storage is."
	icon_state = "direction_cry"

/obj/structure/sign/directions/exit
	name = "\improper Emergency Exit"
	desc = "A lurid green sign that unmistakably identifies that the door it's next to as an emergency exit route."
	icon_state = "exit_sign"
	
/obj/structure/sign/directions/vines/
	name = "\improper Overgrown Sign"
	desc = "A direction sign that's overgrown with vines. <b>You shouldn't be able to find this: please inform a member of staff!</b>"
	icon_state = "vines"

/obj/structure/sign/directions/vines/science
	name = "\improper Science department"
	desc = "A direction sign, pointing out which way the Science department is. It appears to be a bit overgrown."
	icon_state = "direction_sci_vines"

/obj/structure/sign/directions/vines/engineering
	name = "\improper Engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is. It appears to be a bit overgrown."
	icon_state = "direction_eng_vines"

/obj/structure/sign/directions/vines/security
	name = "\improper Security department"
	desc = "A direction sign, pointing out which way the Security department is. It appears to be a bit overgrown."
	icon_state = "direction_sec_vines"

/obj/structure/sign/directions/vines/armory
	name = "\improper Armory"
	desc = "A direction sign, pointing out which way the Armory is. It appears to be a bit overgrown."
	icon_state = "direction_armory_vines"

/obj/structure/sign/directions/vines/medical
	name = "\improper Medical Bay"
	desc = "A direction sign, pointing out which way the Medical Bay is. It appears to be a bit overgrown."
	icon_state = "direction_med_vines"

/obj/structure/sign/directions/vines/virology
	name = "\improper Virology"
	desc = "A direction sign, pointing out which way the Virology Lab is. It appears to be a bit overgrown."
	icon_state = "direction_viro_vines"

/obj/structure/sign/directions/vines/evac
	name = "\improper Evacuation"
	desc = "A direction sign, pointing out which way the Escape Shuttle dock is. It appears to be a bit overgrown."
	icon_state = "direction_evac_vines"

/obj/structure/sign/directions/vines/bridge
	name = "\improper Bridge"
	icon_state = "direction_bridge_vines"
	desc = "A direction sign, pointing out which way the Bridge is. It appears to be a bit overgrown."

/obj/structure/sign/directions/vines/command
	name = "\improper Command"
	icon_state = "direction_command_vines"
	desc = "A direction sign, pointing out which way the Command center is. It appears to be a bit overgrown."

/obj/structure/sign/directions/vines/elevator
	name = "\improper Elevator"
	desc = "A direction sign, pointing out the way to the nearest elevator. It appears to be a bit overgrown."
	icon_state = "direction_elv_vines"

/obj/structure/sign/directions/vines/stairwell
	name = "\improper Stairwell"
	desc = "A direction sign, pointing out the way to the nearest stairwell. It appears to be a bit overgrown."
	icon_state = "stairwell_vines"

/obj/structure/sign/directions/vines/stairs_up
	name = "\improper Stairs Up"
	desc = "A direction sign, pointing out the way to the nearest set of stairs that go up. It appears to be a bit overgrown."
	icon_state = "stairs_up_vines"

/obj/structure/sign/directions/vines/stairs_down
	name = "\improper Stairs Down"
	desc = "A direction sign, pointing out the way to the nearest set of stairs that go down. It appears to be a bit overgrown."
	icon_state = "stairs_down_vines"

/obj/structure/sign/directions/vines/ladderwell
	name = "\improper Access Shaft"
	desc = "A direction sign, pointing out the way to the nearest access shaft. It appears to be a bit overgrown."
	icon_state = "ladderwell_vines"

/obj/structure/sign/directions/vines/ladder_up
	name = "\improper Ladder Up"
	desc = "A direction sign, pointing out the way to the nearest ladder that goes up. It appears to be a bit overgrown."
	icon_state = "ladder_up_vines"

/obj/structure/sign/directions/vines/ladder_down
	name = "\improper Ladder Down"
	desc = "A direction sign, pointing out the way to the nearest ladder that goes down. It appears to be a bit overgrown."
	icon_state = "ladder_down_vines"

/obj/structure/sign/directions/vines/cargo
	name = "\improper Cargo department"
	desc = "A direction sign, pointing out which way the Cargo department is. It appears to be a bit overgrown."
	icon_state = "direction_crg_vines"

/obj/structure/sign/directions/vines/mining
	name = "\improper Mining department"
	desc = "A direction sign, pointing out which way the Mining department is. It appears to be a bit overgrown."
	icon_state = "direction_mining_vines"

/obj/structure/sign/directions/vines/refinery
	name = "\improper Refinery"
	desc = "A direction sign, pointing out which way the Refinery is. It appears to be a bit overgrown."
	icon_state = "direction_refinery_vines"

/obj/structure/sign/directions/vines/cryo
	name = "\improper Cryogenic Storage"
	desc = "A direction sign, pointing out which way Cryogenic storage is. It appears to be a bit overgrown."
	icon_state = "direction_cry_vines"

/obj/structure/sign/directions/vines/exit
	name = "\improper Emergency Exit"
	desc = "A lurid green sign that unmistakably identifies that the door it's next to as an emergency exit route. It appears to be a bit overgrown."
	icon_state = "exit_sign_vines"

/obj/structure/sign/directions/snowy/
	name = "\improper Snow-coated Sign"
	desc = "A direction sign that's coated in a dusting of snow. <b>You shouldn't be able to find this: please inform a member of staff!</b>"
	icon_state = "snowy"

/obj/structure/sign/directions/snowy/science
	name = "\improper Science department"
	desc = "A direction sign, pointing out which way the Science department is. It's covered in snow, but is still just about legible."
	icon_state = "direction_sci_snowy"

/obj/structure/sign/directions/snowy/engineering
	name = "\improper Engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is. It's covered in snow, but is still just about legible."
	icon_state = "direction_eng_snowy"

/obj/structure/sign/directions/snowy/security
	name = "\improper Security department"
	desc = "A direction sign, pointing out which way the Security department is. It's covered in snow, but is still just about legible."
	icon_state = "direction_sec_snowy"

/obj/structure/sign/directions/snowy/armory
	name = "\improper Armory"
	desc = "A direction sign, pointing out which way the Armory is. It's covered in snow, but is still just about legible."
	icon_state = "direction_armory_snowy"

/obj/structure/sign/directions/snowy/medical
	name = "\improper Medical Bay"
	desc = "A direction sign, pointing out which way the Medical Bay is. It's covered in snow, but is still just about legible."
	icon_state = "direction_med_snowy"

/obj/structure/sign/directions/snowy/virology
	name = "\improper Virology"
	desc = "A direction sign, pointing out which way the Virology Lab is. It's covered in snow, but is still just about legible."
	icon_state = "direction_viro_snowy"

/obj/structure/sign/directions/snowy/evac
	name = "\improper Evacuation"
	desc = "A direction sign, pointing out which way the Escape Shuttle dock is. It's covered in snow, but is still just about legible."
	icon_state = "direction_evac_snowy"

/obj/structure/sign/directions/snowy/bridge
	name = "\improper Bridge"
	icon_state = "direction_bridge_snowy"
	desc = "A direction sign, pointing out which way the Bridge is. It's covered in snow, but is still just about legible."

/obj/structure/sign/directions/snowy/command
	name = "\improper Command"
	icon_state = "direction_command_snowy"
	desc = "A direction sign, pointing out which way the Command center is. It's covered in snow, but is still just about legible."

/obj/structure/sign/directions/snowy/elevator
	name = "\improper Elevator"
	desc = "A direction sign, pointing out the way to the nearest elevator. It's covered in snow, but is still just about legible."
	icon_state = "direction_elv_snowy"

/obj/structure/sign/directions/snowy/stairwell
	name = "\improper Stairwell"
	desc = "A direction sign, pointing out the way to the nearest stairwell. It's covered in snow, but is still just about legible."
	icon_state = "stairwell_snowy"

/obj/structure/sign/directions/snowy/stairs_up
	name = "\improper Stairs Up"
	desc = "A direction sign, pointing out the way to the nearest set of stairs that go up. It's covered in snow, but is still just about legible."
	icon_state = "stairs_up_snowy"

/obj/structure/sign/directions/snowy/stairs_down
	name = "\improper Stairs Down"
	desc = "A direction sign, pointing out the way to the nearest set of stairs that go down. It's covered in snow, but is still just about legible."
	icon_state = "stairs_down_snowy"

/obj/structure/sign/directions/snowy/ladderwell
	name = "\improper Access Shaft"
	desc = "A direction sign, pointing out the way to the nearest access shaft. It's covered in snow, but is still just about legible."
	icon_state = "ladderwell_snowy"

/obj/structure/sign/directions/snowy/ladder_up
	name = "\improper Ladder Up"
	desc = "A direction sign, pointing out the way to the nearest ladder that goes up. It's covered in snow, but is still just about legible."
	icon_state = "ladder_up_snowy"

/obj/structure/sign/directions/snowy/ladder_down
	name = "\improper Ladder Down"
	desc = "A direction sign, pointing out the way to the nearest ladder that goes down. It's covered in snow, but is still just about legible."
	icon_state = "ladder_down_snowy"

/obj/structure/sign/directions/snowy/cargo
	name = "\improper Cargo department"
	desc = "A direction sign, pointing out which way the Cargo department is. It's covered in snow, but is still just about legible."
	icon_state = "direction_crg_snowy"

/obj/structure/sign/directions/snowy/mining
	name = "\improper Mining department"
	desc = "A direction sign, pointing out which way the Mining department is. It's covered in snow, but is still just about legible."
	icon_state = "direction_mining_snowy"

/obj/structure/sign/directions/snowy/refinery
	name = "\improper Refinery"
	desc = "A direction sign, pointing out which way the Refinery is. It's covered in snow, but is still just about legible."
	icon_state = "direction_refinery_snowy"

/obj/structure/sign/directions/snowy/cryo
	name = "\improper Cryogenic Storage"
	desc = "A direction sign, pointing out which way Cryogenic storage is. It's covered in snow, but is still just about legible."
	icon_state = "direction_cry_snowy"

/obj/structure/sign/directions/snowy/exit
	name = "\improper Emergency Exit"
	desc = "A lurid green sign that unmistakably identifies that the door it's next to as an emergency exit route. It's covered in snow, but is still plenty legible."
	icon_state = "exit_sign_snowy"
	
/obj/structure/sign/directions/rusted/
	name = "\improper Rusted Sign"
	desc = "A direction sign that's covered in a layer of rust. <b>You shouldn't be able to find this: please inform a member of staff!</b>"
	icon_state = "rusted"

/obj/structure/sign/directions/rusted/science
	name = "\improper Science department"
	desc = "A direction sign, pointing out which way the Science department is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_sci_rusted"

/obj/structure/sign/directions/rusted/engineering
	name = "\improper Engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_eng_rusted"

/obj/structure/sign/directions/rusted/security
	name = "\improper Security department"
	desc = "A direction sign, pointing out which way the Security department is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_sec_rusted"

/obj/structure/sign/directions/rusted/armory
	name = "\improper Armory"
	desc = "A direction sign, pointing out which way the Armory is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_armory_rusted"

/obj/structure/sign/directions/rusted/medical
	name = "\improper Medical Bay"
	desc = "A direction sign, pointing out which way the Medical Bay is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_med_rusted"

/obj/structure/sign/directions/rusted/virology
	name = "\improper Virology"
	desc = "A direction sign, pointing out which way the Virology Lab is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_viro_rusted"

/obj/structure/sign/directions/rusted/evac
	name = "\improper Evacuation"
	desc = "A direction sign, pointing out which way the Escape Shuttle dock is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_evac_rusted"

/obj/structure/sign/directions/rusted/bridge
	name = "\improper Bridge"
	icon_state = "direction_bridge_rusted"
	desc = "A direction sign, pointing out which way the Bridge is. It's old and rusty, but you can just about make out the direction."

/obj/structure/sign/directions/rusted/command
	name = "\improper Command"
	icon_state = "direction_command_rusted"
	desc = "A direction sign, pointing out which way the Command center is. It's old and rusty, but you can just about make out the direction."

/obj/structure/sign/directions/rusted/elevator
	name = "\improper Elevator"
	desc = "A direction sign, pointing out the way to the nearest elevator. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_elv_rusted"

/obj/structure/sign/directions/rusted/stairwell
	name = "\improper Stairwell"
	desc = "A direction sign, pointing out the way to the nearest stairwell. It's old and rusty, but you can just about make out the direction."
	icon_state = "stairwell_rusted"

/obj/structure/sign/directions/rusted/stairs_up
	name = "\improper Stairs Up"
	desc = "A direction sign, pointing out the way to the nearest set of stairs that go up. It's old and rusty, but you can just about make out the direction."
	icon_state = "stairs_up_rusted"

/obj/structure/sign/directions/rusted/stairs_down
	name = "\improper Stairs Down"
	desc = "A direction sign, pointing out the way to the nearest set of stairs that go down. It's old and rusty, but you can just about make out the direction."
	icon_state = "stairs_down_rusted"

/obj/structure/sign/directions/rusted/ladderwell
	name = "\improper Access Shaft"
	desc = "A direction sign, pointing out the way to the nearest access shaft. It's old and rusty, but you can just about make out the direction."
	icon_state = "ladderwell_rusted"

/obj/structure/sign/directions/rusted/ladder_up
	name = "\improper Ladder Up"
	desc = "A direction sign, pointing out the way to the nearest ladder that goes up. It's old and rusty, but you can just about make out the direction."
	icon_state = "ladder_up_rusted"

/obj/structure/sign/directions/rusted/ladder_down
	name = "\improper Ladder Down"
	desc = "A direction sign, pointing out the way to the nearest ladder that goes down. It's old and rusty, but you can just about make out the direction."
	icon_state = "ladder_down_rusted"

/obj/structure/sign/directions/rusted/cargo
	name = "\improper Cargo department"
	desc = "A direction sign, pointing out which way the Cargo department is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_crg_rusted"

/obj/structure/sign/directions/rusted/mining
	name = "\improper Mining department"
	desc = "A direction sign, pointing out which way the Mining department is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_mining_rusted"

/obj/structure/sign/directions/rusted/refinery
	name = "\improper Refinery"
	desc = "A direction sign, pointing out which way the Refinery is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_refinery_rusted"

/obj/structure/sign/directions/rusted/cryo
	name = "\improper Cryogenic Storage"
	desc = "A direction sign, pointing out which way Cryogenic storage is. It's old and rusty, but you can just about make out the direction."
	icon_state = "direction_cry_rusted"

/obj/structure/sign/directions/rusted/exit
	name = "\improper Emergency Exit"
	desc = "A lurid green sign that unmistakably identifies that the door it's next to as an emergency exit route. It's old and rusty, but still easy to read."
	icon_state = "exit_sign_rusted"

//OTHER STUFF

/obj/structure/sign/directions/roomnum
	name = "room number"
	desc = "A sign detailing the number of the room beside it."
	icon_state = "roomnum"

/obj/structure/sign/christmas/lights
	name = "Christmas lights"
	desc = "Flashy and pretty."
	icon = 'icons/obj/christmas.dmi'
	icon_state = "xmaslights"

/obj/structure/sign/christmas/wreath
	name = "wreath"
	desc = "Prickly and festive."
	icon = 'icons/obj/christmas.dmi'
	icon_state = "doorwreath"

/obj/structure/sign/deck/first
	name = "\improper First Deck"
	icon_state = "deck-1"

/obj/structure/sign/deck/second
	name = "\improper Second Deck"
	icon_state = "deck-2"

/obj/structure/sign/deck/third
	name = "\improper Third Deck"
	icon_state = "deck-3"

/obj/structure/sign/deck/fourth
	name = "\improper Fourth Deck"
	icon_state = "deck-4"

/obj/structure/sign/hangar/one
	name = "\improper Hangar One"
	icon_state = "hangar-1"

/obj/structure/sign/hangar/two
	name = "\improper Hangar Two"
	icon_state = "hangar-2"

/obj/structure/sign/hangar/three
	name = "\improper Hangar Three"
	icon_state = "hangar-3"

/obj/structure/sign/atmos
	name = "\improper WASTE"
	icon_state = "atmos_waste"

/obj/structure/sign/atmos/o2
	name = "\improper OXYGEN"
	icon_state = "atmos_o2"

/obj/structure/sign/atmos/co2
	name = "\improper CARBON DIOXIDE"
	icon_state = "atmos_co2"

/obj/structure/sign/atmos/phoron
	name = "\improper PHORON"
	icon_state = "atmos_phoron"

/obj/structure/sign/atmos/n2o
	name = "\improper NITROUS OXIDE"
	icon_state = "atmos_n2o"

/obj/structure/sign/atmos/n2
	name = "\improper NITROGEN"
	icon_state = "atmos_n2"

/obj/structure/sign/atmos/air
	name = "\improper AIR"
	icon_state = "atmos_air"

/obj/structure/sign/poi/engineleft
	name = "I.C.V."
	desc = "The charred name of a cargo ship of some description."
	icon_state = "poi_engine1"

/obj/structure/sign/poi/engineright
	name = "I.C.V."
	desc = "The charred name of a cargo ship of some description."
	icon_state = "poi_engine2"