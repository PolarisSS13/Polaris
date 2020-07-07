// Contains a small system which automatically adds and removes overlays from items as needed.
// The overlays are visible when the item is held in someone's hand, worn, or otherwise in thier inventory.
// If the item is on the ground, the overlays are removed, so it looks like a regular item.

/obj/item
	var/list/inventory_overlays = null	// A list of image objects, or icon_states, that will get added and removed as needed.
										// Starts null to avoid needlessly making empty lists and wasting memory.

/obj/item/Destroy()
	inventory_overlays = null
	return ..()

// Adds an icon_state, or an image instance to the list of inventory overlays.
// If the special overlay list is not initialized, it will be initialized automatically.
/obj/item/proc/add_inventory_overlay(image/thing)
	LAZYADD(inventory_overlays, thing)
	handle_inventory_overlays()

// Ditto, but removes it instead.
// Lists that become empty will be removed entirely.
/obj/item/proc/remove_inventory_overlay(image/thing)
	LAZYREMOVE(inventory_overlays, thing)
	handle_inventory_overlays()

// Applies or cuts overlays on the item based on if it's held or not.
// Essentially a mini `update_icon()` for the inventory overlays.
// Not intended to be called outside of inventory manipulation procs.
/obj/item/proc/handle_inventory_overlays()
	// First, remove the overlays, always.
	for(var/thing in inventory_overlays)
		cut_overlay(thing)

	// Determine if we're currently being held in some form. If not, then do nothing.
	var/mob/living/held_by = null
	if(isliving(loc))
		held_by = loc
	else
		var/atom/current_step = loc
		while(current_step.loc)
			current_step = current_step.loc
			if(isliving(current_step))
				held_by = current_step
				break

	if(!istype(held_by))
		return

	// At this point, we're held.
	for(var/thing in inventory_overlays)
		add_overlay(thing)

// Someday these could be replaced with events that get fired when an object is placed in a client's screen var.
/obj/item/dropped(mob/user)
	handle_inventory_overlays()
	return ..()

/obj/item/equipped(mob/user)
	handle_inventory_overlays()
	return ..()