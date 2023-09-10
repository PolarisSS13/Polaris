/obj/item/poker_chip
	name = "poker chip"
	gender = PLURAL
	icon = 'icons/obj/poker.dmi'
	icon_state = "chip1"
	throw_speed = 3
	throw_range = 10
	w_class = ITEMSIZE_TINY
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'
	var/static/list/chip_worths = list(5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5, 2, 1)
	var/worth = 0


/obj/item/poker_chip/Initialize(mapload, new_worth)
	. = ..()
	if (new_worth)
		worth = new_worth
	name = "[worth] poker chip"
	desc = "A poker chip with a value of [worth]."
	update_icon()


/obj/item/poker_chip/attackby(obj/item/item, mob/living/user)
	if (!istype(item, /obj/item/poker_chip))
		return ..()
	var/obj/item/poker_chip/chip = item
	chip.worth += worth
	chip.update_icon()
	user.visible_message(
		SPAN_ITALIC("\The [user] combines some poker chips."),
		SPAN_ITALIC("You combine some poker chips into a set worth [chip.worth]."),
		SPAN_ITALIC("You hear the click of plastic on plastic."),
		range = 5
	)
	user.unEquip(src)
	user.unEquip(chip)
	user.put_in_hands(chip)
	qdel(src)
	return TRUE


/obj/item/poker_chip/update_icon()
	cut_overlays()
	if (worth in chip_worths)
		name = "[worth] poker chip"
		icon_state = "chip[worth]"
		desc = "A poker chip with a value of [worth]."
		return
	name = "poker chips"
	desc = "Some poker chips with a value of [worth]."
	var/sum = worth
	var/list/chip_overlays = list()
	for (var/chip_worth in chip_worths)
		for (var/i = 1 to 5)
			if (sum < chip_worth)
				break
			sum -= chip_worth
			var/image/chip_overlay = image('icons/obj/poker.dmi', "chip[i]")
			var/matrix/chip_transform = matrix()
			chip_transform.Translate(rand(-3, 3), rand(-4, 4))
			chip_transform.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			chip_overlay.transform = chip_transform
			chip_overlays += chip_overlay
	if (!length(chip_overlays))
		chip_overlays += "chip1"
	add_overlay(chip_overlays)


/obj/item/poker_chip/attack_self(mob/living/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (user.a_intent != I_HELP)
		user.visible_message(
			SPAN_ITALIC("\The [user] kisses \the [src] for luck!"),
			SPAN_ITALIC("You kiss \the [src] for luck!"),
			range = 5
		)
		return
	RemoveChip(user)


/obj/item/poker_chip/MouseDrop(mob/living/user)
	if (user != usr || !istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/human = user
	if (!Adjacent(human))
		return
	if (human.stat || human.restrained())
		to_chat(user, SPAN_WARNING("You're in no condition to do that."))
		return
	if (human.get_active_hand())
		to_chat(user, SPAN_WARNING("Your hand is occupied."))
		return
	var/obj/item/organ/external/hand = human.organs_by_name[human.hand ? "l_hand" : "r_hand"]
	if (!hand || !hand.is_usable())
		to_chat(user, SPAN_WARNING("Your hand is unusable."))
		return
	RemoveChip(user)


/obj/item/poker_chip/proc/RemoveChip(mob/living/user)
	var/biggest_index = 0
	for (var/i = 1 to length(chip_worths))
		if (worth > chip_worths[i])
			biggest_index = i
			break
		else if (worth == chip_worths[i])
			biggest_index = i + 1
			break
	if (!biggest_index || biggest_index > length(chip_worths))
		return
	var/list/available_chips = chip_worths.Copy(biggest_index)
	var/amount = input(user, "Available Chips:") as null | anything in available_chips
	if (QDELETED(src) || !(amount in available_chips) || !Adjacent(user))
		return
	worth -= amount
	update_icon()
	var/obj/item/poker_chip/chip = new(user.loc, amount)
	user.put_in_hands(chip)
	user.visible_message(
		SPAN_ITALIC("\The [user] picks up a poker chip."),
		SPAN_ITALIC("You pick up a poker chip worth [amount]."),
		SPAN_ITALIC("You hear the click of plastic on plastic."),
		range = 5
	)


/obj/item/poker_chip/c1
	icon_state = "chip1"
	worth = 1


/obj/item/poker_chip/c2
	icon_state = "chip2"
	worth = 2


/obj/item/poker_chip/c5
	icon_state = "chip5"
	worth = 5


/obj/item/poker_chip/c10
	icon_state = "chip10"
	worth = 10


/obj/item/poker_chip/c20
	icon_state = "chip20"
	worth = 20


/obj/item/poker_chip/c50
	icon_state = "chip50"
	worth = 50


/obj/item/poker_chip/c100
	icon_state = "chip100"
	worth = 100


/obj/item/poker_chip/c200
	icon_state = "chip200"
	worth = 200


/obj/item/poker_chip/c500
	icon_state = "chip500"
	worth = 500


/obj/item/poker_chip/c1000
	icon_state = "chip1000"
	worth = 1000


/obj/item/poker_chip/c2000
	icon_state = "chip2000"
	worth = 2000


/obj/item/poker_chip/c5000
	icon_state = "chip5000"
	worth = 5000
