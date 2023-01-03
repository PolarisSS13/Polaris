/datum/gear/cane
	display_name = "cane selection"
	path = /obj/item/cane

/datum/gear/cane/New()
	..()
	var/canetype = list()
	canetype["walking cane"] = /obj/item/cane
	canetype["telescopic walking cane"] = /obj/item/cane/telescopic
	canetype["white cane"] = /obj/item/cane/white
	canetype["telescopic white cane"] = /obj/item/cane/white/collapsible
	canetype["folding white cane"] = /obj/item/cane/white/collapsible/folding
	canetype["crutch"] = /obj/item/cane/crutch
	gear_tweaks += new/datum/gear_tweak/path(canetype)

/datum/gear/dice
	display_name = "dice pack"
	path = /obj/item/storage/pill_bottle/dice

/datum/gear/dice/nerd
	display_name = "dice pack (gaming)"
	path = /obj/item/storage/pill_bottle/dice_nerd

/datum/gear/dice/cup
	display_name = "dice cup and dice"
	path = /obj/item/storage/dicecup/loaded

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/deck/cards

/datum/gear/tarot
	display_name = "deck of tarot cards"
	path = /obj/item/deck/tarot

/datum/gear/holder
	display_name = "card holder"
	path = /obj/item/deck/holder

/datum/gear/cardemon_pack
	display_name = "Cardemon booster pack"
	path = /obj/item/pack/cardemon

/datum/gear/spaceball_pack
	display_name = "Spaceball booster pack"
	path = /obj/item/pack/spaceball

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
	toytype["Water flower"] = /obj/item/reagent_containers/spray/waterflower
	toytype["Bosun's whistle"] = /obj/item/toy/bosunwhistle
	toytype["Magic 8 Ball"] = /obj/item/toy/eight_ball
	toytype["Magic Conch shell"] = /obj/item/toy/eight_ball/conch
	gear_tweaks += new/datum/gear_tweak/path(toytype)


/datum/gear/flask
	display_name = "flask, standard"
	path = /obj/item/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_ethanol_reagents())

/datum/gear/vacflask
	display_name = "flask, vacuum"
	path = /obj/item/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/lunchbox
	display_name = "lunchbox"
	description = "A little lunchbox."
	cost = 2
	path = /obj/item/storage/toolbox/lunchbox

/datum/gear/lunchbox/New()
	..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/storage/toolbox/lunchbox))
		var/obj/item/storage/toolbox/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(lunchboxes))
	gear_tweaks += new/datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())

/datum/gear/coffeemug
	display_name = "coffee mugs"
	description = "A coffee mug in various designs."
	cost = 1
	path = /obj/item/reagent_containers/food/drinks/glass2/coffeemug

/datum/gear/coffeemug/New()
	..()
	var/list/coffeemugs = list()
	coffeemugs["plain coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug
	coffeemugs["SCG coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/sol
	coffeemugs["Fleet coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/fleet
	coffeemugs["Five Arrows coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/fivearrows
	coffeemugs["Pearlshield coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/psc
	coffeemugs["Almach Association coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/alma
	coffeemugs["Almach Protectorate coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/almp
	coffeemugs["NT coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/nt
	coffeemugs["Wulf Aeronautics mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/metal/wulf
	coffeemugs["Gilthari Exports coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/gilthari
	coffeemugs["Zeng-Hu coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/zeng
	coffeemugs["Ward-Takahashi coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/wt
	coffeemugs["Aether Atmospherics coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/aether
	coffeemugs["Bishop Cybernetics coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/bishop
	coffeemugs["Oculum Broadcast coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/oculum
	coffeemugs["#1 coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/one
	coffeemugs["#1 monkey coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/puni
	coffeemugs["heart coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/heart
	coffeemugs["pawn coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/pawn
	coffeemugs["diona coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/diona
	coffeemugs["british coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/britcup
	coffeemugs["NCS Northern Star coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/tourist
	coffeemugs["flame coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/flame
	coffeemugs["blue coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/blue
	coffeemugs["black coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/black
	coffeemugs["green coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/green
	coffeemugs["dark green coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/green/dark
	coffeemugs["rainbow coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/rainbow
	coffeemugs["metal coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/metal
	coffeemugs["glass coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/glass
	coffeemugs["tall coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/tall
	coffeemugs["tall black coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/tall/black
	coffeemugs["tall metal coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/tall/metal
	coffeemugs["tall rainbow coffee mug"] = /obj/item/reagent_containers/food/drinks/glass2/coffeemug/tall/rainbow
	gear_tweaks += new /datum/gear_tweak/path(coffeemugs)
	gear_tweaks += new /datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/towel
	display_name = "towel"
	path = /obj/item/towel

/datum/gear/towel/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/cahwhite
	display_name = "Cards Against The Galaxy (white deck)"
	path = /obj/item/deck/cah
	description = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the white deck."

/datum/gear/cahblack
	display_name = "Cards Against The Galaxy (black deck)"
	path = /obj/item/deck/cah/black
	description = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the black deck."
