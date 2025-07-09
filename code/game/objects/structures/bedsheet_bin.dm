/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet"
	slot_flags = SLOT_BACK
	plane = MOB_PLANE
	layer = BELOW_MOB_LAYER
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/clothing.ogg'
	pickup_sound = 'sound/items/pickup/clothing.ogg'
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/back.dmi')

/obj/item/bedsheet/attack_self(mob/user as mob)
	user.drop_item()
	if(layer == initial(layer))
		layer = ABOVE_MOB_LAYER
	else
		reset_plane_and_layer()
	add_fingerprint(user)
	return

/obj/item/bedsheet/attackby(obj/item/I, mob/user)
	if(is_sharp(I))
		user.visible_message("<span class='notice'>\The [user] begins cutting up [src] with [I].</span>", "<span class='notice'>You begin cutting up [src] with [I].</span>")
		if(do_after(user, 50))
			to_chat(user, "<span class='notice'>You cut [src] into pieces!</span>")
			for(var/i in 1 to rand(2,5))
				new /obj/item/reagent_containers/glass/rag(drop_location())
			qdel(src)
		return
	..()

/obj/item/bedsheet/blue
	icon_state = "sheetblue"

/obj/item/bedsheet/green
	icon_state = "sheetgreen"

/obj/item/bedsheet/orange
	icon_state = "sheetorange"

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"

/obj/item/bedsheet/rainbow
	icon_state = "sheetrainbow"

/obj/item/bedsheet/red
	icon_state = "sheetred"

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"

/obj/item/bedsheet/mime
	icon_state = "sheetmime"

/obj/item/bedsheet/clown
	icon_state = "sheetclown"
	item_state = "sheetrainbow"

/obj/item/bedsheet/captain
	icon_state = "sheetcaptain"

/obj/item/bedsheet/rd
	icon_state = "sheetrd"

/obj/item/bedsheet/medical
	icon_state = "sheetmedical"

/obj/item/bedsheet/hos
	icon_state = "sheethos"

/obj/item/bedsheet/hop
	icon_state = "sheethop"

/obj/item/bedsheet/ce
	icon_state = "sheetce"

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"

/obj/item/bedsheet/ian
	icon_state = "sheetian"

/obj/item/bedsheet/double
	icon_state = "doublesheet"
	item_state = "sheet"

/obj/item/bedsheet/bluedouble
	icon_state = "doublesheetblue"
	item_state = "sheetblue"

/obj/item/bedsheet/greendouble
	icon_state = "doublesheetgreen"
	item_state = "sheetgreen"

/obj/item/bedsheet/orangedouble
	icon_state = "doublesheetorange"
	item_state = "sheetorange"

/obj/item/bedsheet/purpledouble
	icon_state = "doublesheetpurple"
	item_state = "sheetpurple"

/obj/item/bedsheet/rainbowdouble //all the way across the sky.
	icon_state = "doublesheetrainbow"
	item_state = "sheetrainbow"

/obj/item/bedsheet/reddouble
	icon_state = "doublesheetred"
	item_state = "sheetred"

/obj/item/bedsheet/yellowdouble
	icon_state = "doublesheetyellow"
	item_state = "sheetyellow"

/obj/item/bedsheet/mimedouble
	icon_state = "doublesheetmime"
	item_state = "sheetmime"

/obj/item/bedsheet/clowndouble
	icon_state = "doublesheetclown"
	item_state = "sheetrainbow"

/obj/item/bedsheet/captaindouble
	icon_state = "doublesheetcaptain"
	item_state = "sheetcaptain"

/obj/item/bedsheet/rddouble
	icon_state = "doublesheetrd"
	item_state = "sheetrd"

/obj/item/bedsheet/hosdouble
	icon_state = "doublesheethos"
	item_state = "sheethos"

/obj/item/bedsheet/hopdouble
	icon_state = "doublesheethop"
	item_state = "sheethop"

/obj/item/bedsheet/cedouble
	icon_state = "doublesheetce"
	item_state = "sheetce"

/obj/item/bedsheet/browndouble
	icon_state = "doublesheetbrown"
	item_state = "sheetbrown"

/obj/item/bedsheet/iandouble
	icon_state = "doublesheetian"
	item_state = "sheetian"


/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = TRUE
	var/max_amount = 10
	var/min_amount
	var/amount
	var/list/sheets = list()
	var/obj/item/hidden


/obj/structure/bedsheetbin/Destroy()
	QDEL_NULL_LIST(sheets)
	QDEL_NULL(hidden)
	return ..()


/obj/structure/bedsheetbin/Initialize()
	. = ..()
	amount = max_amount


/obj/structure/bedsheetbin/examine(mob/user, distance, infix, suffix)
	. = ..()
	if (amount < 1)
		. += "There are no bed sheets in the bin."
	else if (amount == 1)
		. += "There is one bed sheet in the bin."
	else
		. += "There are [amount] bed sheets in the bin."


/obj/structure/bedsheetbin/update_icon()
	var/scale = clamp((amount / max_amount) * 100, 0, 100)
	switch (scale)
		if (0)
			icon_state = "linenbin-empty"
		if (1 to 50)
			icon_state = "linenbin-half"
		else
			icon_state = "linenbin-full"


/obj/structure/bedsheetbin/attackby(obj/item/item, mob/living/user)
	if (istype(item, /obj/item/bedsheet))
		user.drop_item()
		item.loc = src
		sheets += item
		amount++
		to_chat(user, "<span class='notice'>You put [item] in [src].</span>")
	else if (amount && !hidden && item.w_class < ITEMSIZE_LARGE)
		user.drop_item()
		item.loc = src
		hidden = item
		to_chat(user, "<span class='notice'>You hide [item] among the sheets.</span>")


/obj/structure/bedsheetbin/attack_hand(mob/living/user)
	if(amount < 1)
		return
	add_fingerprint(user)
	amount--
	var/obj/item/bedsheet/sheet = length(sheets)
	if (sheet)
		sheet = sheets[sheet]
		--sheets.len
	else
		sheet = new /obj/item/bedsheet
	user.put_in_hands(sheet)
	to_chat(user, "<span class='notice'>You take [sheet] out of [src].</span>")
	if (hidden)
		hidden.dropInto(loc)
		hidden = null
		to_chat(user, "<span class='notice'>[hidden] falls out of [src]!</span>")
	update_icon()


/obj/structure/bedsheetbin/attack_tk(mob/living/user)
	if(amount < 1)
		return
	add_fingerprint(user)
	amount--
	var/obj/item/bedsheet/sheet = length(sheets)
	if (sheet)
		sheet = sheets[sheet]
		--sheets.len
	else
		sheet = new /obj/item/bedsheet
	sheet.dropInto(loc)
	to_chat(user, "<span class='notice'>You telekinetically remove [sheet] from [src].</span>")
	if (hidden)
		hidden.dropInto(loc)
		hidden = null
		to_chat(user, "<span class='notice'>[hidden] falls out of [src]!</span>")
	update_icon()
