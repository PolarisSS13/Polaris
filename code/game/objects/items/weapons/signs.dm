/obj/item/weapon/picket_sign
	icon_state = "picket"
	name = "blank picket sign"
	desc = "It's blank"
	burn_state = 0 //Burnable
	burntime = SHORT_BURN
	force = 5
	w_class = 4
	attack_verb = list("bashed","smacked")


	var/label = ""
	var/last_wave = 0

/obj/item/weapon/picket_sign/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/weapon/pen/crayon))
		var/txt = sanitize(copytext(input(user, "Enter your picket message.", "Picket Message", null)  as text,1,40))
		if(!txt)
			return
		else
			label = txt
			src.name = "[label] sign"
			desc =	"It reads: [label]"
	..()

/obj/item/weapon/picket_sign/attack_self(mob/living/carbon/human/user)
	if( last_wave + 20 < world.time )
		last_wave = world.time
		if(label)
			user.visible_message("<span class='warning'>[user] waves around \the \"[label]\" sign.</span>")
		else
			user.visible_message("<span class='warning'>[user] waves around blank sign.</span>")
		user.changeNext_move(CLICK_CD_MELEE)