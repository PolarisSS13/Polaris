/obj/machinery/computer/reputation
	name = "diplomatic terminal" // Needs a better name.
	desc = "Used to review your facility's standing with important groups, ask them for favors, or manage tasks given by them."
	icon_keyboard = "rd_key" // TODO
	icon_screen = "command" // TODO
	circuit = /obj/item/weapon/circuitboard/reputation
	var/datum/faction_relationship/current_viewed_faction = null

/obj/machinery/computer/reputation/attack_hand(mob/living/user)
	interact(user)
	..()

/obj/machinery/computer/reputation/attack_ghost(mob/observer/user)
	interact(user)

/obj/machinery/computer/reputation/proc/display_faction_opinion(faction_decl)

/obj/machinery/computer/reputation/interact(mob/user)
	var/list/html = list()
	var/title = "[using_map.full_name]'s Standing"

	if(!current_viewed_faction)
		html += "<h1>Relationships</h1>"
		var/i = 1
		for(var/type_path in SSreputation.relationships)
			var/datum/faction_relationship/R = SSreputation.relationships[type_path]
			var/decl/faction/faction = GET_DECL(R.faction_tag)
			if(faction.hidden)
				continue
			html += "<b>[faction.name]</b><span class='floatRight'>([faction.class])</span>"

			var/decl/faction_opinion_threshold/threshold = faction.get_opinion_threshold(R.opinion)
			html += "[faction.opinion_name]: <font color='[threshold.color]'>[threshold.name]</font>\
			<span class='floatRight'>[faction.influence_name]: [R.influence] (TODO)</span>"

			html += href(src, list("open_faction" = i), "Open")
			html += "<br>"
			i++
	
	else
		var/decl/faction/faction = GET_DECL(current_viewed_faction.faction_tag)
		title = faction.name
		html += "<h1>[faction.name]</h1>"
		html += "<i>[faction.desc]</i>"

		// List their friends.
		if(LAZYLEN(faction.friends))
			var/list/friend_names = list()
			for(var/type in faction.friends)
				var/decl/faction/friendly_faction = GET_DECL(type)
				friend_names += friendly_faction.short_name
			html += "<span class='highlight'>[faction.short_name] has close ties to [english_list(friend_names)].</span>"
		
		// Now their enemies.
		if(LAZYLEN(faction.enemies))
			var/list/enemy_names = list()
			for(var/type in faction.enemies)
				var/decl/faction/baddie_faction = GET_DECL(type)
				enemy_names += baddie_faction.short_name
			html += "<span class='highlight'>[faction.short_name] is strongly opposed to [english_list(enemy_names)].</span>"
		
		html += "<hr>"
		var/decl/faction_opinion_threshold/threshold = SSreputation.get_opinion_threshold(current_viewed_faction.faction_tag)
		html += "[faction.opinion_name]: <font color='[threshold.color]'>[threshold.name]</font>"
		html += "[faction.influence_name]: [SSreputation.get_influence(current_viewed_faction.faction_tag)] (TODO)"
		html += "[threshold.get_desc()]"

		html += "<h2>Favors</h2>"
		if(LAZYLEN(faction.favors))
			for(var/type in faction.favors)
				var/decl/faction_favor/favor = GET_DECL(type)
				html += "<b>[favor.name]</b>"
				html += "<i>[favor.desc]</i>"
//				if(favor.influence_cost)
//					html += "[favor.influence_cost] [faction.influence_name] TODO"
//				if(favor.opinion_cost)
//					html += "[favor.opinion_cost] [faction.opinion_name] TODO"
//				html += "Odds: [favor.success_chance]% TODO"
				html += href(src, list("favor" = type), "Request")
				html += "<br>"
		else
			html += "There are no favors available."

		html += "<h2>Missions</h2>"
		html += "Not Implemented Yet"

		html += href(src, list("return_to_menu" = 1), "Go Back")

	var/datum/browser/popup = new(user, "reputation_ui", title, 500, 600, src)
	popup.set_content(html.Join("<br>"))
	popup.open()

/obj/machinery/computer/reputation/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=cataloguer_display")
		return TOPIC_NOACTION
	
	if(href_list["close"] )
		usr << browse(null, "window=cataloguer_display")
		return TOPIC_NOACTION
	
	if(href_list["open_faction"])
		var/index = text2num(href_list["open_faction"])
		if(isnull(index))
			return TOPIC_NOACTION
		var/type_path = SSreputation.relationships[index]
		current_viewed_faction = SSreputation.relationships[type_path]
	
	if(href_list["return_to_menu"])
		current_viewed_faction = null

	interact(usr)
	return TOPIC_REFRESH