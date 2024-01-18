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
	drying_wetness = 120
	dried_type = /obj/item/stack/material/leather

/obj/item/stack/wetleather/get_drying_state(var/obj/rack)
	return (drying_wetness > 0 ? "leather_wet" : "leather_dry")

/obj/item/stack/wetleather/examine(var/mob/user)
	. = ..()
	. += description_info
	. += "\The [src] is [get_dryness_text()]."

/obj/item/stack/wetleather/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	. = ..()
	if(.) // If it transfers any, do a weighted average of the wetness
		var/obj/item/stack/wetleather/W = S
		var/oldamt = W.amount - .
		W.drying_wetness = round(((oldamt * W.drying_wetness) + (. * drying_wetness)) / W.amount)
