// Inherits from /book/ so it can fit on bookshelves.
/obj/item/weapon/book/codex
	name = "Generic Codex: Electric Bugaloo"
	desc = "If you can read this, something is broken!"
	icon_state = "codex"
	unique = TRUE
	var/datum/codex_tree/tree = null
	var/root_type = /datum/lore/codex/category/main_vir_lore	//Runtimes on codex_tree.dm, line 18 with a null here

/obj/item/weapon/book/codex/initialize()
	tree = new(src, root_type)
	. = ..()

/obj/item/weapon/book/codex/attack_self(mob/user)
	if(!tree)
		tree = new(src, root_type)
	icon_state = "[initial(icon_state)]-open"
	tree.display(user)

/obj/item/weapon/book/codex/lore/vir
	name = "The Traveler's Guide to Human Space: Vir Edition"
	desc = "Contains useful information about the world around you.  It seems to have been written for travelers to Vir, human or not.   It also \
	has the words 'Don't Panic' in small, friendly letters on the cover."
	icon_state = "codex"
	root_type = /datum/lore/codex/category/main_vir_lore

/obj/item/weapon/book/codex/lore/news
	name = "Daedalus Pocket Newscaster"
	desc = "A regularly-updating compendium of articles on current events. Essential for new arrivals in the Vir system and anyone interested in politics."
	icon_state = "newscodex"
	w_class = ITEMSIZE_SMALL
	root_type = /datum/lore/codex/category/main_news

// Combines SOP/Regs/Law
/obj/item/weapon/book/codex/corp_regs
	name = "NanoTrasen Regulatory Compendium"
	desc = "Contains large amounts of information on Standard Operating Procedure, Corporate Regulations, and important regional laws.  The best friend of \
	Internal Affairs."
	icon_state = "corp_regs"
	root_type = /datum/lore/codex/category/main_corp_regs
	throwforce = 5 // Throw the book at 'em.
