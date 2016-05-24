/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

	suicide_act(mob/user)
		viewers(user) << "<span class='danger'>\The [user] is strangling \himself with \the [src]! It looks like \he's trying to commit suicide.</span>"
		return (OXYLOSS)

/obj/item/weapon/fluff/dildos/attack_self(mob/user as mob)
	if(user.a_intent == I_HELP)
		user.visible_message("<span class='notice'><b>\The [user]</b> teases \himself with the [src]!</span>","<span class='notice'>You tease yourself with the [src]!</span>")
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'><b>\The [user]</b> fuck \himself with the [src]!</span>","<span class='warning'>You fuck yourself with the [src]!</span>")
	else if (user.a_intent == I_GRAB)
		user.visible_message("<span class='warning'><b>\The [user]</b> violates \himself with the [src]!</span>","<span class='warning'>You violate yourself with the [src]!</span>")
	else
		user.visible_message("<span class='notice'><b>\The [user]</b> prods \himself with the [src].</span>","<span class='notice'>You prod yourself with the [src].</span>")


/obj/item/weapon/fluff/dildos/bigblackdick
	name = "big black dick"
	desc = "Bigger. Blacker. For when the real thing just doesn't cut it."
	icon = 'icons/obj/adult.dmi'
	icon_state = "bigblackdick"
	item_state = "bigblackdick"
	attack_verb = list("fucked", "probed", "violated", "teased", "prodded")

/obj/item/weapon/fluff/dildos/metal_dildo
	name = "metal dildo"
	desc = "That metal is unyielding and unforgiving."
	icon = 'icons/obj/adult.dmi'
	icon_state = "metal_dildo"
	item_state = "metal_dildo"
	attack_verb = list("fucked", "probed", "violated", "teased", "prodded")

/obj/item/weapon/fluff/dildos/canine
	name = "canine dildo"
	desc = "It has a bulbous knot."
	icon = 'icons/obj/adult.dmi'
	icon_state = "canine"
	item_state = "canine"
	attack_verb = list("fucked", "probed", "violated", "teased", "prodded")

/obj/item/weapon/fluff/dildos/floppydick
	name = "floppy dick"
	desc = "The silicone on this toy is particularly soft and, well, kind of flaccid."
	icon = 'icons/obj/adult.dmi'
	icon_state = "floppydick"
	item_state = "floppydick"
	attack_verb = list("fucked", "probed", "violated", "teased", "prodded")

/obj/item/weapon/fluff/dildos/purpledong
	name = "purple dildo"
	desc = "It's a playful shade of purple."
	icon = 'icons/obj/adult.dmi'
	icon_state = "purple-dong"
	item_state = "purple-dong"
	attack_verb = list("fucked", "probed", "violated", "teased", "prodded")
