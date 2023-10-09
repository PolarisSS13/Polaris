/// This is a unique talisman given to roundstart cultists, and is the only source of soul stones and construct shells for them until they make an artificer.
/obj/item/paper/talisman/supply
	talisman_name = "Supply"
	talisman_desc = "An irreplaceable talisman densely packed with varying invocations, providing all the tools you need to start a new cult. Make sure you get a tome, if you don't have one already."
	delete_self = FALSE
	invocation = null
	var/uses = 5

/obj/item/paper/talisman/supply/examine(mob/user)
	. = ..()
	if (iscultist(user) || isobserver(user))
		to_chat(user, SPAN_OCCULT("[uses] use\s remain\s."))

/obj/item/paper/talisman/supply/invoke(mob/living/user)
	var/dat = "There are <b>[uses]</b> bloody runes on the parchment.<br/>"
	dat += "Please choose the chant to be imbued into the fabric of reality.<br/>"
	dat += "<hr>"
	dat += "<a href='?src=\ref[src];rune=newtome'>N'ath reth sh'yro eth d'raggathnor!</a> - Allows you to summon a new arcane tome.<br/>"
	dat += "<a href='?src=\ref[src];rune=teleport'>Sas'so c'arta forbici!</a> - Allows you to move to a random rune with a provided key word.<br/>"
	dat += "<a href='?src=\ref[src];rune=emp'>Ta'gh fara'qha fel d'amar det!</a> - Allows you to destroy technology in a short range.<br/>"
	dat += "<a href='?src=\ref[src];rune=conceal'>Kla'atu barada nikt'o!</a> - Allows you to conceal the runes you placed on the floor.<br/>"
	dat += "<a href='?src=\ref[src];rune=communicate'>O bidai nabora se'sma!</a> - Allows you to coordinate with others of your cult.<br/>"
	dat += "<a href='?src=\ref[src];rune=runestun'>Fuu ma'jin!</a> - Allows you to stun a person by attacking them with the talisman.<br/>"
	dat += "<a href='?src=\ref[src];rune=armor'>Sa tatha najin!</a> - Allows you to summon armoured robes and an unholy blade<br/>"
	dat += "<a href='?src=\ref[src];rune=soulstone'>Kal om neth!</a> - Summons a soul stone<br/>"
	dat += "<a href='?src=\ref[src];rune=construct'>Da a'ig osk!</a> - Summons a construct shell for use with captured souls. It is too large to carry on your person.<br/>"
	var/datum/browser/popup = new(user, "supply_talisman", "Supply Talisman")
	popup.set_content(dat)
	popup.open()

/obj/item/paper/talisman/supply/Topic(href, href_list)
	var/mob/living/L = usr
	if (QDELETED(src) || !iscultist(L) || L.incapacitated() || !in_range(src, L))
		return
	var/atom/movable/atom_type
	switch (href_list["rune"])
		if ("newtome")
			atom_type = /obj/item/paper/talisman/summon_tome
		if ("teleport")
			var/word = input(L, "Choose a key word for the talisman. When used, it will teleport you to a random Teleport rune with the same key word.", name) as null|anything in cult.english_words
			if (QDELETED(src) || QDELETED(L) || !iscultist(L) || !word)
				return
			var/obj/item/paper/talisman/teleport/T = new(get_turf(L))
			T.key_word = word
			to_chat(L, SPAN_OCCULT("You etch the talisman into the fabric of reality with the key word \"[word]\"."))
		if ("emp")
			atom_type = /obj/item/paper/talisman/emp
		if ("conceal")
			atom_type = /obj/item/paper/talisman/hide_runes
		if ("communicate")
			atom_type = /obj/item/paper/talisman/communicate
		if ("runestun")
			atom_type = /obj/item/paper/talisman/stun
		if ("armor")
			atom_type = /obj/item/paper/talisman/armor
		if ("soulstone")
			atom_type = /obj/item/soulstone
		if ("construct")
			atom_type = /obj/structure/constructshell/cult
	if (atom_type)
		var/atom/movable/AM = new atom_type (get_turf(L))
		if (isitem(AM))
			L.put_in_hands(AM)
		to_chat(L, SPAN_OCCULT("You etch [istype(AM, /obj/item/paper/talisman) ? "the talisman" : "\the [AM]"] into the fabric of reality."))
	uses--
	if (!uses)
		to_chat(L, SPAN_WARNING("\The [src] dissolves into hot ash as the last of its power is used."))
		qdel(src)
		return
	invoke(L)
