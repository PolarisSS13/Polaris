/obj/item/device/base_key
	name = "mysterious device"
	desc = "Looks like a piece of junk. What does this do?"
	icon = 'icons/obj/radio.dmi'
	icon_state = "cypherkey"
	var/list/base_type

/obj/item/device/base_key/New()
	..()
	base_type = generic_bases

/obj/item/device/base_key/cartel/New()
	..()
	base_type = blue_moon_cartel_bases

/obj/item/device/base_key/fund/New()
	..()
	base_type = trust_fund_bases

/obj/item/device/base_key/union/New()
	..()
	base_type = workers_union_bases

/obj/item/device/base_key/quercus/New()
	..()
	base_type = quercus_coalition_bases

/obj/structure/base_spawner
	name = "strange hole"
	desc = "How did this get here?"
	density = 0
	anchored = 1
	breakable = 0
	unacidable = 0
	icon = 'icons/obj/hoists.dmi'
	icon_state = "hoist_case"

	light_range = 9
	light_power = 2
	light_color = "#ebf7fe"  //white blue


/obj/structure/base_spawner/attackby(obj/item/W as obj, mob/user as mob)
	var/datum/map_template/template
	var/list/datum/map_template/compatible_maps = list()

	if (istype(W, /obj/item/device/base_key))
		var/obj/item/device/base_key/key = W

		compatible_maps = key.base_type

		if(!compatible_maps)
			to_chat(user, "<span class='warning'>[src] beeps several times, then goes quiet.</span>")
			return

		// This loads the base at the location.
		// Shamelessly copy pasted from map_template_loadverb.dm

		var/map = input(usr, "Chose what faction base you'd like to form?","Place Faction Base") as null|anything in compatible_maps
		if(!map)
			return
		template = compatible_maps[map]

		var/turf/T = get_turf(src)
		if(!T)
			return

		var/list/preview = list()
		template.preload_size(template.mappath)
		for(var/S in template.get_affected_turfs(T,centered = TRUE))
			preview += image('icons/misc/debug_group.dmi',S ,"red")
		user.client.images += preview
		if(alert(usr,"Confirm base spawn.", "Base Spawn Confirm","No","Yes") == "Yes")
			if(template.annihilate && alert(usr,"Would you like to spawn your base here? Spawning your base will override all walls and floors in the area, continue?", "Base Confirm","No","Yes") == "No")
				usr.client.images -= preview
				return

			if(template.load(T, centered = TRUE))
				message_admins("<span class='adminnotice'>[user]/[user.client] has spawned a factions base: ([template.name]).</span>")
				qdel(src)
				qdel(W)
			else
				to_chat(user, "Failed to place base.")
		user.client.images -= preview





