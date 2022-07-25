/*
 * Bows, Arrows, and Accessories.
 */

/datum/crafting_recipe/shortbow
	name = "Shortbow"
	result = /obj/item/gun/launcher/crossbow/bow
	reqs = list(list(/obj/item/stack/material/wood = 10),
		list(/obj/item/stack/material/cloth = 5))
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/arrow_sandstone
	name = "Wood Arrow (Sandstone Tip)"
	result = /obj/item/arrow/wood
	reqs = list(list(/obj/item/stack/material/wood = 2),
		list(/obj/item/stack/material/sandstone = 2))
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/arrow_marble
	name = "Wood Arrow (Marble Tip)"
	result = /obj/item/arrow/wood
	reqs = list(list(/obj/item/stack/material/wood = 2),
		list(/obj/item/stack/material/marble = 2))
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/arrow/material
	name = "Metal Arrow (Custom Tip)"
	result = /obj/item/material/arrow
	reqs = list(list(/obj/item/handcuffs/cable = 1),
		list(/obj/item/stack/material = 3))
	parts = list(
		/obj/item/stack/material = 3
	)
	tool_paths = list(
		/obj/item/material/sharpeningkit
		)
	time = 5 SECONDS
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/arrow/material/on_craft_completion(mob/user, atom/result)
	var/obj/item/stack/material/M
	for(var/path in parts)
		var/obj/item/material/N = locate(path) in result
		if(istype(N, path))
			if(!istype(M))
				M = N
			else
				N.forceMove(get_turf(result))
	if(!istype(M))
		return

	var/obj/item/material/arrow/A = result
	A.set_material(M.material.name)
	qdel(M)

/datum/crafting_recipe/quiver
	name = "Arrow quiver"
	result = /obj/item/storage/bag/quiver
	reqs = list(list(/obj/item/stack/material/leather = 8))
	time = 60
	category = CAT_STORAGE
