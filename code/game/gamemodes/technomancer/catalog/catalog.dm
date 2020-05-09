#define ALL_SPELLS "All"
#define OFFENSIVE_SPELLS "Offensive"
#define DEFENSIVE_SPELLS "Defensive"
#define UTILITY_SPELLS "Utility"
#define SUPPORT_SPELLS "Support"

#define SPELL_TAB 0
#define EQUIPMENT_TAB 1
#define CONSUMABLES_TAB 2
#define ASSISTANCE_TAB 3
#define INFO_TAB 4

GLOBAL_LIST_INIT(technomancer_catalog_spells, init_subtypes_assoc(/datum/technomancer_catalog/spell))
GLOBAL_LIST_INIT(technomancer_catalog_equipment, init_subtypes_assoc(/datum/technomancer_catalog/object/equipment))
GLOBAL_LIST_INIT(technomancer_catalog_consumables, init_subtypes_assoc(/datum/technomancer_catalog/object/consumable))
GLOBAL_LIST_INIT(technomancer_catalog_assistance, init_subtypes_assoc(/datum/technomancer_catalog/object/assistance))

// Holds information about what can be bought in the catalog, by the technomancer's version of the traitor uplink.
// This is a singleton object, unlike the spell metadata objects.
/datum/technomancer_catalog
	var/name = null
	var/desc = null // For spells, you should use the spell metadata's desc instead, unless you're describing a bundle of spells.
	var/cost = 100 // How many catalog points this is worth.

// Catalog entries for physical objects.
/datum/technomancer_catalog/object
	var/list/object_paths = null // A list of physical objects that will appear when this is bought.
	var/forbid_apprentices = FALSE // If true, apprentices can't buy this.

/datum/technomancer_catalog/object/consumable

/datum/technomancer_catalog/object/assistance

// Catalog entries for spells for the core being worn.
/datum/technomancer_catalog/spell
	var/category = ALL_SPELLS // Used for filtering in the catalog.
	var/list/spell_metadata_paths = null // A list of spell metadata paths that someone will get if they buy this thing.
	var/enhancement_desc = null // Blue colored text that describes what happens if the spell is used with the Scepter of Enhancement.
	var/spell_power_desc = null // Purple colored text that describes how the spell scales with 'spell power'.
	var/table = null

/datum/technomancer_catalog/spell/proc/get_description()
	if(!table)
		table = build_table()
	return table

/datum/technomancer_catalog/spell/proc/build_table()
	var/list/dat = list()
	dat += "[desc]<br>"

	for(var/thing in spell_metadata_paths)
		var/datum/spell_metadata/meta = new thing()
		var/image/I = image(icon = 'icons/mob/screen_spells.dmi', icon_state = meta.icon_state)
		var/datum/technomancer_aspect/aspect = GLOB.technomancer_aspects[meta.aspect]


		dat += {"

		<font color='black'>
		<table bgcolor='[aspect.secondary_color]' style='width:100%; border: 1px solid black;'>
			<tr bgcolor='[aspect.primary_color]'>
				<th colspan=2><b>[meta.name]</b></th>
			</tr>
			<tr>
				<td rowspan=2>[bicon(I, TRUE, "sprite64")]</td>
				<td>ASPECT:<br>[uppertext(aspect.name)]</td>
			</tr>
			<tr>
				<td>[meta.desc]</td>
			</tr>
		"}
		if(meta.enhancement_desc)
			dat += {"
			<tr>
				<td colspan=2>Scepter Effect: [meta.enhancement_desc]</td>
			</tr>
			"}
		var/list/lines = meta.get_spell_info() + meta.get_common_spell_info()
		if(lines.len)
			for(var/line in lines)
				dat += {"
				<tr>
					<td colspan=2><b>[line]</b>: [lines[line]]</td>
				</tr>
				"}

		dat += {"
			</table>
			</font>

		"}
	return dat.Join()



// This is deprecated.
/datum/technomancer
	var/name = "technomancer thing"
	var/desc = "If you can see this, something broke."
	var/cost = 100
	var/hidden = 0
	var/obj_path = null
	var/ability_icon_state = null

/datum/technomancer/spell
	var/category = ALL_SPELLS
	var/enhancement_desc = null
	var/spell_power_desc = null
	var/cached_desc = null

// This functions as the traitor uplink for technomancers, letting them buy spells and items for points.
/obj/item/weapon/technomancer_catalog
	name = "catalog"
	desc = "A \"book\" featuring a holographic display, metal cover, and miniaturized teleportation device, allowing the user to \
	requisition various things from.. where ever they came from."
	icon = 'icons/obj/storage.dmi'
	icon_state ="scientology" //placeholder
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	var/budget = 1000
	var/mob/living/carbon/human/owner = null
	var/tab = INFO_TAB // Info tab, so new players will hopefully read it before doing anything.
	var/spell_tab = ALL_SPELLS
	var/apprentice_catalog = FALSE

/obj/item/weapon/technomancer_catalog/apprentice
	name = "apprentice's catalog"
	budget = 700
	apprentice_catalog = TRUE

/obj/item/weapon/technomancer_catalog/master //for badmins, I suppose
	name = "master's catalog"
	budget = 2000


// Links the catalog to hopefully the technomancer, so that only they can access it.
/obj/item/weapon/technomancer_catalog/proc/bind_to_owner(var/mob/living/carbon/human/new_owner)
	if(!owner && technomancers.is_antagonist(new_owner.mind))
		owner = new_owner

/obj/item/weapon/technomancer_catalog/proc/generate_spell_entry_text(datum/technomancer_catalog/spell/spell_entry)



// Shows an href link to go to a spell subcategory if the category is not already selected,
// otherwise it is bold, to reduce code duplicating.
/obj/item/weapon/technomancer_catalog/proc/show_categories(var/category)
	if(category)
		if(spell_tab != category)
			return href(src, list("spell_category" = category), category)
		else
			return "<b>[category]</b>"

// Similar idea as above.
/obj/item/weapon/technomancer_catalog/proc/show_tab(linked_tab_index, tab_text)
	if(tab != linked_tab_index)
		return href(src, list("tab_choice" = linked_tab_index), tab_text)
	return "<b>[tab_text]</b>"

/obj/item/weapon/technomancer_catalog/proc/get_common_window_header()
	var/list/dat = list()
	dat += "<align='center'>"
	dat += "[show_tab(SPELL_TAB, "Functions")] | "
	dat += "[show_tab(EQUIPMENT_TAB, "Equipment")] | "
	dat += "[show_tab(CONSUMABLES_TAB, "Consumables")] | "
	dat += "[show_tab(ASSISTANCE_TAB, "Assistance")] | "
	dat += "[show_tab(INFO_TAB, "Info")]"
	dat += "</align><br>"

	dat += "You currently have a budget of <b>[budget]</b>.<br><br>"
	return dat.Join()

/obj/item/weapon/technomancer_catalog/proc/show_spell_window(mob/user, size_x, size_y)
	var/list/dat = list()
	dat += get_common_window_header()

	dat += "[href(src, list("refund_functions" = 1), "Refund Functions")]<br><br>"

	dat += "[show_categories(ALL_SPELLS)] | [show_categories(OFFENSIVE_SPELLS)] | [show_categories(DEFENSIVE_SPELLS)] | \
	[show_categories(UTILITY_SPELLS)] | [show_categories(SUPPORT_SPELLS)]<br>"

	for(var/path in GLOB.technomancer_catalog_spells)
		var/datum/technomancer_catalog/spell/spell_entry = GLOB.technomancer_catalog_spells[path]

		if(!spell_entry.name)
			continue

		if(spell_tab != ALL_SPELLS && spell_entry.category != spell_tab)
			continue
		dat += spell_entry.get_description()
		/*
		dat += "<b>[spell_entry.name]</b><br>"
		dat += "<i>[spell_entry.desc]</i><br>"

		if(spell_entry.spell_power_desc)
			dat += "<font color='purple'>Spell Power: [spell_entry.spell_power_desc]</font><br>"
		if(spell_entry.enhancement_desc)
			dat += span("highlight", "Scepter Effect: [spell_entry.enhancement_desc]<br>")
		*/
		if(spell_entry.cost <= budget)
			dat += "[href(src, list("spell_choice" = spell_entry), "Purchase")] ([spell_entry.cost])<br><br>"
		else
			dat += "<span class='bad'><b>Cannot afford!</b> ([spell_entry.cost])</span><br><br>"

	var/datum/browser/popup = new(user, "technomancer_catalog", "Catalog - Functions", size_x, size_y, src)
	popup.set_content(dat.Join())
	popup.open()

/obj/item/weapon/technomancer_catalog/proc/show_item_window(mob/user, list/item_list, size_x, size_y)
	var/list/dat = list()
	dat += get_common_window_header()

	for(var/path in item_list)
		var/datum/technomancer_catalog/object/item_entry = item_list[path]

		if(!item_entry.name)
			continue

		if(item_entry.forbid_apprentices && apprentice_catalog) // So we don't get apprentices buying apprentices.
			continue

		dat += "<b>[item_entry.name]</b><br>"
		dat += "<i>[item_entry.desc]</i><br>"
		if(item_entry.cost <= budget)
			dat += "[href(src, list("item_choice" = item_entry), "Purchase")] ([item_entry.cost])<br><br>"
		else
			dat += "<span class='bad'><b>Cannot afford!</b> ([item_entry.cost])</span><br><br>"

	var/datum/browser/popup = new(user, "technomancer_catalog", "Catalog - Items & Equipment", size_x, size_y, src)
	popup.set_content(dat.Join())
	popup.open()

/obj/item/weapon/technomancer_catalog/proc/show_info_window(mob/user, size_x, size_y)
	var/list/dat = list()
	dat += get_common_window_header()

	dat += "<h1>Manipulation Core Owner's Manual</h1><br>"
	dat += "This brief entry in your catalog will try to explain what everything does. For starters, the thing you're \
	probably wearing on your back is known as a <b>Manipulation Core</b>, or just a 'Core'. It allows you to do amazing \
	things with almost no effort, depending on what <b>functions</b> you've purchased for it. Don't lose your core!<br>"
	dat += "<br>"
	dat += "There are a few things you need to keep in mind as you use your Core to manipulate the universe. The core \
	requires a special type of <b>energy</b>, that is referred to as just 'Energy' in the catalog. All cores generate \
	their own energy, some more than others. Most functions require energy be spent in order to work, so make sure not \
	to run out in a critical moment. Besides waiting for your Core to recharge, you can buy certain functions which \
	do something to generate energy.<br>"
	dat += "<br>"
	dat += "The second thing you need to know is that awesome power over the physical world has consquences, in the form \
	of <b>Instability</b>. Instability is the result of your Core's energy being used to fuel it, and so little is \
	understood about it, even among fellow Core owners, however it is almost always a bad thing to have. Instability will \
	'cling' to you as you use functions, with powerful functions creating lots of instability. The effects of holding onto \
	instability are generally harmless or mildly annoying at low levels, with effects such as sparks in the air or forced \
	blinking. Accumulating more and more instability will lead to worse things happening, which can easily be fatal, if not \
	managed properly.<br>"
	dat += "<br>"
	dat += "Fortunately, all Cores come with a meter to tell you how much instability you currently hold. \
	Instability will go away on its own as time goes on. You can tell if you have instability by the characteristic \
	purple colored lightning that appears around something with instability lingering on it. High amounts of instability \
	may cause the object afflicted with it to glow a dark purple, which is often known simply as <b>Glow</b>, which spreads \
	the instability. You should stay far away from anyone afflicted by Glow, as they will be a danger to both themselves and \
	anything nearby. Multiple sources of Glow can perpetuate the glow for a very long time if they are not seperated.<br>"
	dat += "<br>"
	dat += "You should strive to keep you and your apprentices' cores secure. To help with this, each core comes with a \
	locking mechanism, which should make attempts at forceful removal by third parties (or you) futile, until it is \
	unlocked again. Do note that there is a safety mechanism, which will automatically unlock the core if the wearer \
	suffers death. There exists a secondary safety mechanism (safety for the core, not you) that is triggered when \
	the core detects itself being carried, with the carrier not being authorized. It will respond by giving a \
	massive amount of Instability to them, so be careful, or perhaps make use of that.<br>"
	dat += "<br>"
	dat += "<b>You can refund functions, equipment items, and assistance items, so long as you are in your base.</b>  \
	Once you leave, you can't refund anything, however you can still buy things if you still have points remaining.  \
	To refund functions, just click the 'Refund Functions' button on the top, when in the functions tabs.  \
	For equipment items, you need to hit it against the catalog.<br>"
	dat += "<br>"
	dat += "Your blue robes and hat are both stylish, and somewhat protective against hostile energies, which includes \
	EXTERNAL instability sources (like Glow), and mundane electricity.  If you're looking for protection against other \
	things, it's suggested you purchase or otherwise obtain armor.<br>"
	dat += "<br>"
	dat += "There are a few terms you may not understand in the catalog, so this will try to explain them.<br>"
	dat += "A function can be thought of as a 'spell', that you use by holding in your hands and trying to use it on \
	a target of your choice.<br>"
	dat += "Some functions can have their abilities enhanced by a special rod called the Scepter of Enhancement. \
	If a function is able to be boosted with it, it will be shown underneath the description of the function as \
	<span class='highlight'><i>'Scepter Effect:'</i></span>. Note that you must hold the scepter for it to work, so try to avoid losing it.<br>"
	dat += "Functions can also be boosted with the core itself. A function that is able to benefit \
	from this will have <font color='purple'><i>'Spell Power:'</i></font> underneath. Different Cores have different \
	amounts of spell power.<br>"
	dat += "When a function refers to 'allies', it means you, your apprentices, currently controlled entities (with the \
	Control function), and friendly simple-minded entities that you've summoned with the Scepter of Enhancement.<br>"
	dat += "A meter is equal to one 'tile'."

	var/datum/browser/popup = new(user, "technomancer_catalog", "Catalog - Info", size_x, size_y, src)
	popup.set_content(dat.Join())
	popup.open()

// Shows an HTML window, to buy equipment and spells, if the user is the legitimate owner.  Otherwise it cannot be used.
/obj/item/weapon/technomancer_catalog/attack_self(mob/user)
	if(!user)
		return FALSE
	if(owner && user != owner)
		to_chat(user, "<span class='danger'>\The [src] knows that you're not the original owner, and has locked you out of it!</span>")
		return FALSE
	else if(!owner)
		bind_to_owner(user)

	var/size_x = 500
	var/size_y = 700

	switch(tab)
		if(SPELL_TAB)
			show_spell_window(user, size_x, size_y)
		if(EQUIPMENT_TAB)
			show_item_window(user, GLOB.technomancer_catalog_equipment, size_x, size_y)
		if(CONSUMABLES_TAB)
			show_item_window(user, GLOB.technomancer_catalog_consumables, size_x, size_y)
		if(ASSISTANCE_TAB)
			show_item_window(user, GLOB.technomancer_catalog_assistance, size_x, size_y)
		if(INFO_TAB)
			show_info_window(user, size_x, size_y)

// Acts upon clicks on links for the catalog, if they are the rightful owner.
/obj/item/weapon/technomancer_catalog/Topic(href, href_list)
	..()
	var/mob/living/carbon/human/H = usr

	if(H.stat || H.restrained())
		return
	if(!istype(H, /mob/living/carbon/human))
		return 1 //why does this return 1?

	if(H != owner)
		to_chat(H, "\The [src] won't allow you to do that, as you don't own \the [src]!")
		return

	if(loc == H || (in_range(src, H) && istype(loc, /turf)))
		H.set_machine(src)
		if(href_list["close"]) // So we don't open a new window when the close button is clicked.
			return
		if(href_list["tab_choice"])
			tab = text2num(href_list["tab_choice"])

		if(href_list["spell_category"])
			spell_tab = href_list["spell_category"]

		if(href_list["spell_choice"])
			var/datum/technomancer_catalog/spell/spell_entry = locate(href_list["spell_choice"])
			if(!istype(spell_entry))
				return

			var/obj/item/weapon/technomancer_core/core = null
			if(istype(H.back, /obj/item/weapon/technomancer_core))
				core = H.back

			if(!core)
				to_chat(H, span("warning", "You need to be wearing a Manipulation Core in order to buy Functions."))
				return

			if(spell_entry.cost <= budget)
				if(spell_entry in core.spell_catalog_entries_bought)
					to_chat(H, span("warning", "You already have [spell_entry.name]!"))
					return
				else
					budget -= spell_entry.cost
					core.spell_catalog_entries_bought += spell_entry
					for(var/path in spell_entry.spell_metadata_paths)
						var/datum/spell_metadata/meta = new path()
						core.add_spell(meta)
						core.spell_metas[path] = meta
						to_chat(H, span("notice", "You have just bought [meta.name]."))
			else
				to_chat(H, span("warning", "You can't afford that!"))
				return

		if(href_list["item_choice"])
			var/datum/technomancer_catalog/object/item_entry = locate(href_list["item_choice"])
			if(!istype(item_entry))
				return

			if(item_entry.cost <= budget)
				budget -= item_entry.cost

				for(var/path in item_entry.object_paths)
					var/obj/O = new path(get_turf(H))
					to_chat(H, span("notice", "You have just bought \a [O]."))
					GLOB.technomancer_belongings += O // Used for the Track spell.
			else
				to_chat(H, span("warning", "You can't afford that!"))

		if(href_list["refund_functions"])
	// Yell at Neerti if this is still commented out and it makes it live.
	//		var/turf/T = get_turf(H)
	//		if(T.z in using_map.player_levels)
	//			to_chat(H, "<span class='danger'>You can only refund at your base, it's too late now!</span>")
	//			return
			var/obj/item/weapon/technomancer_core/core = H.get_technomancer_core()
			if(!core)
				to_chat(H, span("warning", "You need to be wearing a core to refund its functions."))
				return

			for(var/thing in core.spell_catalog_entries_bought)
				var/datum/technomancer_catalog/spell/spell_entry = thing

				budget += spell_entry.cost
				core.spell_catalog_entries_bought -= spell_entry

				for(var/path in spell_entry.spell_metadata_paths)
					var/datum/spell_metadata/meta = core.spell_metas[path]

					for(var/obj/spellbutton/button in core.spells)
						if(button.spellpath == meta.spell_path)
							core.remove_spell(button)

					core.spell_metas -= path
					to_chat(H, span("notice", "You have refunded [meta]."))
		attack_self(H)

/obj/item/weapon/technomancer_catalog/attackby(var/atom/movable/AM, var/mob/user)
	var/turf/T = get_turf(user)
	if(T.z in using_map.player_levels)
		to_chat(user, "<span class='danger'>You can only refund at your base, it's too late now!</span>")
		return
	/*
	for(var/datum/technomancer/equipment/E in equipment_instances + assistance_instances)
		if(AM.type == E.obj_path) // We got a match.
			budget = budget + E.cost
			to_chat(user, "<span class='notice'>You've refunded \the [AM].</span>")

			// We sadly need to do special stuff here or else people who refund cores with spells will lose points permanently.
			if(istype(AM, /obj/item/weapon/technomancer_core))
				var/obj/item/weapon/technomancer_core/core = AM
				for(var/obj/spellbutton/spell in core.spells)
					for(var/datum/technomancer/spell/spell_datum in spell_instances)
						if(spell_datum.obj_path == spell.spellpath)
							budget += spell_datum.cost
							to_chat(user, "<span class='notice'>[spell.name] was inside \the [core], and was refunded.</span>")
							core.remove_spell(spell)
							break
			qdel(AM)
			return
	*/
	to_chat(user, "<span class='warn'>\The [src] is unable to refund \the [AM].</span>")


#undef SPELL_TAB
#undef EQUIPMENT_TAB
#undef CONSUMABLES_TAB
#undef ASSISTANCE_TAB
#undef INFO_TAB