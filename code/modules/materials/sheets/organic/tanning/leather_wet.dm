//Step three - drying
/obj/item/stack/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	description_info = "To finish tanning the leather, you need to dry it. \
						You could place it under a <b><font color='red'>fire</font></b>, \
						put it in a <b><font color='blue'>drying oven</font></b>, \
						or build a <b><font color='brown'>drying rack</font></b> from steel or wooden boards."
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	no_variants = FALSE
	max_amount = 20
	stacktype = "wetleather"
	var/wetness = 30 //Reduced when exposed to high temperautres

/obj/item/stack/wetleather/is_dryable()
	return wetness > 0

/obj/item/stack/wetleather/get_drying_state(var/obj/rack)
	if(wetness)
		return "leather_wet"
	return "leather_dry"

/obj/item/stack/wetleather/examine(var/mob/user)
	. = ..()
	. += description_info
	. += "\The [src] is [get_dryness_text()]."

/obj/item/stack/wetleather/get_dryness_text(var/obj/rack)
	if(wetness > 20)
		return "wet"
	if(wetness > 10)
		return "damp"
	if(wetness)
		return "almost dry"
	return ..()

/obj/item/stack/wetleather/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	. = ..()
	if(.) // If it transfers any, do a weighted average of the wetness
		var/obj/item/stack/wetleather/W = S
		var/oldamt = W.amount - .
		W.wetness = round(((oldamt * W.wetness) + (. * wetness)) / W.amount)

/obj/item/stack/wetleather/dry_out(var/obj/rack, var/drying_power = 1)
	if(wetness <= 0)
		return null
	wetness -= drying_power
	if(wetness <= 0)
		. = new /obj/item/stack/material/leather(loc, amount)
		rack?.visible_message(SPAN_NOTICE("The [src] is dry!"))
		qdel(src)
