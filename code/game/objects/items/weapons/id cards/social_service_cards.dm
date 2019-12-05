//Meal Card Code//

/obj/item/weapon/card/foodstamp
	name = "social service card"
	desc = "An Electronic Benefits Transfer card to access social service benefits. This one is capable of contactless fund transfers."
	icon_state = "foodstamp"

	var/age = "\[UNSET\]"
	var/registered_name = "Unknown" // The name registered_name on the card
	slot_flags = SLOT_ID | SLOT_EARS
	var/assignment = null	//can be alt title or the actual job
	var/mob/registered_user = null
	var/meals_remaining = 3

/obj/item/weapon/card/foodstamp/proc/update_name()
	name = "[src.registered_name]'s social service card"

/***
 * UNUSED FOR NOW

 /obj/item/weapon/card/foodstamp/proc/food_dat()
	var/food_dat = ("<table><tr><td>")
	food_dat += text("Name: []</A><BR>", registered_name)
	food_dat += text("Age: []</A><BR>\n", age)
	food_dat += text("Job: []</A><BR>\n", assignment)
	food_dat += text("Daily Meals Remaining: []</A><BR>\n", meals_remaining)
	food_dat += "</tr></table>"
	return food_dat

*/

/obj/item/weapon/card/foodstamp/verb/read_meal_card()
	set name = "Check Remaining Meals"
	set category = "Object"
	set src in usr

	usr << "There are [meals_remaining] remaining meals on the card."
	return

/obj/item/weapon/card/foodstamp/attack_self(mob/user as mob)
	// We use the fact that registered_name is not unset should the owner be vaporized, to ensure the id doesn't magically become unlocked.
	if(!registered_user && register_user(user))
		to_chat(user, "<span class='notice'>The microscanner marks you as a registered social service provider, preventing others from editing its information.</span>")
	if(registered_user == user)
		switch(alert("Would you like edit the card, or show it?","Show or Edit?", "Edit","Show"))
			if("Edit")
				ui_interact(user)
			if("Show")
				user.visible_message("\The [user] shows you: \icon[src] [src.name].",\
					"You flash your social service card: \icon[src] [src.name].")
	else
		..()

/obj/item/weapon/card/foodstamp/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/entries[0]
	entries[++entries.len] = list("name" = "Name", 				"value" = registered_name)
	entries[++entries.len] = list("name" = "Age", 				"value" = age)
	entries[++entries.len] = list("name" = "Assignment",		"value" = assignment)
	entries[++entries.len] = list("name" = "Meals Remaining",	"value" = meals_remaining)
	entries[++entries.len] = list("name" = "Factory Reset",		"value" = "Use With Care")
	data["entries"] = entries

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "social_service_card.tmpl", "Social Service Card", 600, 400)
		ui.set_initial_data(data)
		ui.open()

/obj/item/weapon/card/foodstamp/proc/register_user(var/mob/user)
	if(!istype(user) || user == registered_user)
		return FALSE
	unset_registered_user()
	registered_user = user
	user.set_id_info(src)
	user.register(OBSERVER_EVENT_DESTROY, src, /obj/item/weapon/card/foodstamp/proc/unset_registered_user)
	return TRUE

/obj/item/weapon/card/foodstamp/proc/unset_registered_user(var/mob/user)
	if(!registered_user || (user && user != registered_user))
		return
	registered_user.unregister(OBSERVER_EVENT_DESTROY, src)
	registered_user = null

/obj/item/weapon/card/foodstamp/CanUseTopic(mob/user)
	if(user != registered_user)
		return STATUS_CLOSE
	return ..()

/obj/item/weapon/card/foodstamp/Topic(href, href_list, var/datum/topic_state/state)
	if(..())
		return 1

	var/user = usr
	if(href_list["set"])
		switch(href_list["set"])
			if("Age")
				var/new_age = input(user,"What age would you like to put on this card?","Social Service Card Age", age) as null|num
				if(!isnull(new_age) && CanUseTopic(user, state))
					if(new_age < 0)
						age = initial(age)
					else
						age = new_age
					user << "<span class='notice'>Age has been set to '[age]'.</span>"
					. = 1
			if("Assignment")
				var/new_job = sanitize(input(user,"What assignment would you like to put on this card?\nChanging assignment will not grant or remove any access levels.","Social Service Card Assignment", assignment) as null|text)
				if(!isnull(new_job) && CanUseTopic(user, state))
					src.assignment = new_job
					user << "<span class='notice'>Occupation changed to '[new_job]'.</span>"
					update_name()
					. = 1
			if("Name")
				var/new_name = sanitizeName(input(user,"What name would you like to put on this card?","Social Service Card Name", registered_name) as null|text)
				if(!isnull(new_name) && CanUseTopic(user, state))
					src.registered_name = new_name
					update_name()
					user << "<span class='notice'>Name changed to '[new_name]'.</span>"
					. = 1
			if("Remaining Meals")
				var/new_meals_remaining = input(user, "How many meals would you like to put on this card?","Social Service Card Remaining Meals", meals_remaining) as null|num
				if(!isnull(new_meals_remaining) && CanUseTopic(user, state))
					if(new_meals_remaining <= 0)
						src.meals_remaining = new_meals_remaining
					else
						src.meals_remaining = initial(meals_remaining)
					user << "<span class='notice'>Remaining meals updated to '[meals_remaining]'.</span>"
			if("Factory Reset")
				if(alert("This will factory reset the card, including access and owner. Continue?", "Factory Reset", "No", "Yes") == "Yes" && CanUseTopic(user, state))
					age = initial(age)
					assignment = initial(assignment)
					name = initial(name)
					registered_name = initial(registered_name)
					unset_registered_user()
					user << "<span class='notice'>All information has been deleted from \the [src].</span>"
					. = 1

	// Always update the UI, or buttons will spin indefinitely
	SSnanoui.update_uis(src)


