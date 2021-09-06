/datum/gear/cane
	display_name = "cane"
	path = /obj/item/weapon/cane

/datum/gear/cane/white
	display_name = "white cane"
	path = /obj/item/weapon/cane/white

/datum/gear/cane/white2
	display_name = "telescopic white cane"
	path = /obj/item/weapon/cane/white/collapsible

/datum/gear/crutch
	display_name = "crutch"
	path = /obj/item/weapon/cane/crutch

/datum/gear/dice
	display_name = "dice pack"
	path = /obj/item/weapon/storage/pill_bottle/dice

/datum/gear/dice/nerd
	display_name = "dice pack (gaming)"
	path = /obj/item/weapon/storage/pill_bottle/dice_nerd

/datum/gear/dice/cup
	display_name = "dice cup and dice"
	path = /obj/item/weapon/storage/dicecup/loaded

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/weapon/deck/cards

/datum/gear/tarot
	display_name = "deck of tarot cards"
	path = /obj/item/weapon/deck/tarot

/datum/gear/deckbox
	display_name = "trading card deck box"
	path = /obj/item/weapon/deck

/datum/gear/deckbox/New()
	..()
	var/boxtype = list()
	boxtype["Cardemon"] = /obj/item/weapon/deck/cardemon
	boxtype["Saints and Sins"] = /obj/item/weapon/deck/saintsandsins
	boxtype["Spaceball"] = /obj/item/weapon/deck/spaceball
	gear_tweaks += new/datum/gear_tweak/path(boxtype)

/datum/gear/boosterpack
	display_name = "trading card booster pack"
	path = /obj/item/weapon/pack

/datum/gear/boosterpack/New()
	..()
	var/packtype = list()
	packtype["Cardemon"] = /obj/item/weapon/pack/cardemon
	packtype["Saints and Sins"] = /obj/item/weapon/pack/saintsandsins/booster
	packtype["Spaceball"] = /obj/item/weapon/pack/spaceball
	gear_tweaks += new/datum/gear_tweak/path(packtype)

/datum/gear/builderdeck
	display_name = "Saints and Sins builder pack"
	path = /obj/item/weapon/pack/saintsandsins

/datum/gear/plushie
	display_name = "plushie selection"
	path = /obj/item/toy/plushie/

/datum/gear/plushie/New()
	..()
	var/list/plushies = list()
	for(var/plushie in subtypesof(/obj/item/toy/plushie/) - /obj/item/toy/plushie/therapy)
		var/obj/item/toy/plushie/plushie_type = plushie
		plushies[initial(plushie_type.name)] = plushie_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(plushies))

/datum/gear/figure
	display_name = "action figure selection"
	description = "A \"Space Life\" brand action figure."
	path = /obj/item/toy/figure/

/datum/gear/figure/New()
	..()
	var/list/figures = list()
	for(var/figure in typesof(/obj/item/toy/figure/) - /obj/item/toy/figure)
		var/obj/item/toy/figure/figure_type = figure
		figures[initial(figure_type.name)] = figure_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(figures))

/datum/gear/toy
	display_name = "toy selection"
	description = "Choose from a number of toys."
	path = /obj/item/toy/

/datum/gear/toy/New()
	..()
	var/toytype = list()
	toytype["Blink toy"] = /obj/item/toy/blink
	toytype["Gravitational singularity"] = /obj/item/toy/spinningtoy
	toytype["Water flower"] = /obj/item/weapon/reagent_containers/spray/waterflower
	toytype["Bosun's whistle"] = /obj/item/toy/bosunwhistle
	toytype["Magic 8 Ball"] = /obj/item/toy/eight_ball
	toytype["Magic Conch shell"] = /obj/item/toy/eight_ball/conch
	gear_tweaks += new/datum/gear_tweak/path(toytype)


/datum/gear/flask
	display_name = "flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_ethanol_reagents())

/datum/gear/vacflask
	display_name = "vacuum-flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/lunchbox
	display_name = "lunchbox"
	description = "A little lunchbox."
	cost = 2
	path = /obj/item/weapon/storage/toolbox/lunchbox

/datum/gear/lunchbox/New()
	..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/weapon/storage/toolbox/lunchbox))
		var/obj/item/weapon/storage/toolbox/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(lunchboxes))
	gear_tweaks += new/datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())

/datum/gear/towel
	display_name = "towel"
	path = /obj/item/weapon/towel

/datum/gear/towel/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/cahwhite
	display_name = "Cards Against The Galaxy (white deck)"
	path = /obj/item/weapon/deck/cah
	description = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the white deck."

/datum/gear/cahblack
	display_name = "Cards Against The Galaxy (black deck)"
	path = /obj/item/weapon/deck/cah/black
	description = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the black deck."
