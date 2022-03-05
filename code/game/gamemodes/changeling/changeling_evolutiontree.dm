var/list/powers = typesof(/datum/power/changeling) - /datum/power/changeling	//needed for the badmin verb for now
var/list/datum/power/changeling/powerinstances = list()

/datum/power			//Could be used by other antags too
	var/name = "Power"
	var/desc = "Placeholder"
	var/helptext = ""
	var/enhancedtext = ""
	var/isVerb = 1 	// Is it an active power, or passive?
	var/verbpath // Path to a verb that contains the effects.
	var/make_hud_button = 1 // Is this ability significant enough to dedicate screen space for a HUD button?
	var/ability_icon_state = null // icon_state for icons for the ability HUD.  Must be in screen_spells.dmi.

/datum/power/changeling
	var/allowduringlesserform = 0
	var/genomecost = 500000 // Cost for the changling to evolve this power.
	var/power_category = null // _defines/gamemode.dm

/datum/changeling/proc/EvolutionTree() /// Data is in changelingevolution.dm under managed_browsers
	set name = "-Evolution Tree-"
	set category = "Changeling"
	set desc = "Adapt yourself carefully."

	if(!usr || !usr.mind || !usr.mind.changeling)	return

	if(usr.client.changelingevolution)
		usr.client.changelingevolution.display()
	else
		usr.client.changelingevolution = new(usr.client)


/*
/datum/changeling/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/data[0]
	data["geneticpoints"] = list("current" = user.mind.changeling.geneticpoints, "max" = user.mind.changeling.max_geneticpoints)
	data["categories"] = available_categories
	var/powerselect[0]
	var/abilities[0]
	var/purchased[0]

	for(var/P in subtypesof(/datum/power/changeling))
		var/datum/power/changeling/powerdata = P
		abilities[++abilities.len] = list("name" = initial(powerdata.name), "description" = initial(powerdata.desc), \
		"helptext" = initial(powerdata.helptext), "cost" = initial(powerdata.genomecost), "category" = initial(powerdata.power_category), \
		"path" = "[powerdata]")

	for(var/B in purchased_powers)
		var/datum/power/changeling/powerbought = B
		purchased[++purchased.len] = list("name" = initial(powerbought.name))

	if(user.mind.changeling.power_select) /// For currently viewed power.
		var/datum/power/changeling/S = user.mind.changeling.power_select
		powerselect[++powerselect.len] = list("name" = initial(S.name), "description" = initial(S.desc), "helptext" = initial(S.helptext), "cost" = initial(S.genomecost))
		if(powerselect["name"] in purchased)
			powerselect += list("purchased" = 1)

	/*
	var/i = 1
	for(var/C in available_categories)
		categories[++categories.len] = list("name" = C, "page" = i)
		i++
	*/
	data["abilities"] = abilities
	data["menu"] = menu_select
	data["powerselect"] = powerselect

	ui = SSnanoui.try_update_ui(user, user, ui_key, ui, data, force_open)

	if(!ui)
		ui = new(user, user, ui_key, "changeling.tmpl", "Evolution Tree", 475, 700, state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/*
/datum/changeling/Topic(href, href_list)
	..()
	if(!ismob(usr))
		return
///OUTDATED, DELETE LATER
	if(href_list["P"])
		var/datum/mind/M = usr.mind
		if(!istype(M))
			return
		purchasePower(M, href_list["P"])
		call(/datum/changeling/proc/EvolutionMenu)()
/// END OUTDATED
	if(href_list["setcategory"])
		usr.mind.changeling.menu_select = href_list["setcategory"]
	
	if(href_list["currentselection"])
		var/nowviewing = href_list["currentselection"]
		
		if(nowviewing != 0)
			usr.mind.changeling.power_select = text2path(nowviewing)
		else
			usr.mind.changeling.power_select = null

	if(href_list["purchasePower"])
		var/datum/power/changeling/boughtPower = href_list["purchasePower"]
		log_debug("Power purchased: [href_list["purchasePower"]]!")
		for (var/datum/power/changeling/P in powerinstances)
			if(P.name == boughtPower)
				boughtPower = P
				break
			else
				log_debug("Error, purchase power = [boughtPower]")
		usr.mind.changeling.purchased_powers += boughtPower
	
	usr.mind.changeling.ui_interact(usr) /// update_uis just would not work under any circumstance.
*/
*/ 