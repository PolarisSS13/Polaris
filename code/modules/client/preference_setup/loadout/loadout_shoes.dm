// Shoelocker
/datum/gear/shoes
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/jackboots
	display_name = "jackboots selection"
	path = /obj/item/clothing/shoes/boots/jackboots
	cost = 2

/datum/gear/shoes/jackboots/New()
	..()
	var/list/jacks = list()
	for(var/jack in typesof(/obj/item/clothing/shoes/boots/jackboots))
		var/obj/item/clothing/shoes/boots/jackboots/jack_type = jack
		jacks[initial(jack_type.name)] = jack_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(jacks))

/datum/gear/shoes/workboots
	display_name = "workboots selection"
	path = /obj/item/clothing/shoes/boots/workboots
	cost = 2

/datum/gear/shoes/workboots/New()
	..()
	var/list/works = list()
	for(var/work in typesof(/obj/item/clothing/shoes/boots/workboots))
		var/obj/item/clothing/shoes/boots/workboots/work_type = work
		works[initial(work_type.name)] = work_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(works))

/datum/gear/shoes/colored
	display_name = "shoes, colored selection"
	path = /obj/item/clothing/shoes/black

/datum/gear/shoes/colored/New()
	..()
	var/list/shoetype = list(
	"shoes, black" = /obj/item/clothing/shoes/black,
	"shoes, blue" = /obj/item/clothing/shoes/blue,
	"shoes, brown" = /obj/item/clothing/shoes/brown,
	"shoes, green" = /obj/item/clothing/shoes/green,
	"shoes, orange" = /obj/item/clothing/shoes/orange,
	"shoes, purple" = /obj/item/clothing/shoes/purple,
	"shoes, rainbow" = /obj/item/clothing/shoes/rainbow,
	"shoes, red" = /obj/item/clothing/shoes/red,
	"shoes, white" = /obj/item/clothing/shoes/white,
	"shoes, yellow" = /obj/item/clothing/shoes/yellow
	)
	gear_tweaks += new/datum/gear_tweak/path(shoetype)

/datum/gear/shoes/lacey
	display_name = "shoes, oxford selection"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/lacey/New()
    ..()
    var/list/laces = list()
    for(var/lace in typesof(/obj/item/clothing/shoes/laceup))
        var/obj/item/clothing/shoes/laceup/lace_type = lace
        laces[initial(lace_type.name)] = lace_type
    gear_tweaks += new/datum/gear_tweak/path(sortAssoc(laces))

/datum/gear/shoes/hitops
	display_name = "shoes, high-top selection"
	path = /obj/item/clothing/shoes/hitops

/datum/gear/shoes/hitops/New()
	..()
	var/list/hitops = list()
	for(var/hitop in typesof(/obj/item/clothing/shoes/hitops))
		var/obj/item/clothing/shoes/hitops/hitop_type = hitop
		hitops[initial(hitop_type.name)] = hitop_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(hitops))

/datum/gear/shoes/flipflops
	display_name = "flip flops (colorable)"
	path = /obj/item/clothing/shoes/flipflop

/datum/gear/shoes/flipflops/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/athletic
	display_name = "shoes, athletic (colorable)"
	path = /obj/item/clothing/shoes/athletic

/datum/gear/shoes/athletic/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/skater
	display_name = "shoes, skater (colorable)"
	path = /obj/item/clothing/shoes/skater

/datum/gear/shoes/skater/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/flats
	display_name = "shoes, flats (colorable)"
	path = /obj/item/clothing/shoes/flats/white/color

/datum/gear/shoes/flats/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/flats/alt
	display_name = "shoes, flats alt (colorable)"
	path = /obj/item/clothing/shoes/flats/white/color/alt

/datum/gear/shoes/cowboy
	display_name = "boots, cowboy selection"
	path = /obj/item/clothing/shoes/boots/cowboy

/datum/gear/shoes/cowboy/New()
	..()
	var/list/cowboys = list()
	for(var/cowboy in typesof(/obj/item/clothing/shoes/boots/cowboy))
		var/obj/item/clothing/shoes/boots/cowboy/cowboy_type = cowboy
		cowboys[initial(cowboy_type.name)] = cowboy_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cowboys))

/datum/gear/shoes/jungle
	display_name = "boots, jungle"
	path = /obj/item/clothing/shoes/boots/jungle
	cost = 2

/datum/gear/shoes/duty
	display_name = "boots, duty"
	path = /obj/item/clothing/shoes/boots/duty
	cost = 2

/datum/gear/shoes/dress
	display_name = "shoes, dress"
	path = 	/obj/item/clothing/shoes/dress

/datum/gear/shoes/dress/white
	display_name = "shoes, dress white"
	path = 	/obj/item/clothing/shoes/dress/white

/datum/gear/shoes/heels
	display_name = "high heels (colorable)"
	path = /obj/item/clothing/shoes/heels

/datum/gear/shoes/heels/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/slippers
	display_name = "bunny slippers"
	path = /obj/item/clothing/shoes/slippers

/datum/gear/shoes/winter_boots
	display_name = "boots, winter selection"
	path = /obj/item/clothing/shoes/boots/winter

/datum/gear/shoes/winter_boots/New()
	..()

	var/list/boottype = list(
	"winter boots, atmospherics" = /obj/item/clothing/shoes/boots/winter/atmos,
	"winter boots, brown" = /obj/item/clothing/shoes/boots/winter,
	"winter boots, engineering" = /obj/item/clothing/shoes/boots/winter/engineering,
	"winter boots, hydroponics" = /obj/item/clothing/shoes/boots/winter/hydro,
	"winter boots, management" = /obj/item/clothing/shoes/boots/winter/command,
	"winter boots, medical" = /obj/item/clothing/shoes/boots/winter/medical,
	"winter boots, mining" = /obj/item/clothing/shoes/boots/winter/mining,
	"winter boots, science" = /obj/item/clothing/shoes/boots/winter/science,
	"winter boots, security" = /obj/item/clothing/shoes/boots/winter/security,
	"winter boots, supply" = /obj/item/clothing/shoes/boots/winter/supply
	)
	gear_tweaks += new/datum/gear_tweak/path(boottype)
/datum/gear/shoes/circuitry
	display_name = "boots, circuitry (empty)"
	path = /obj/item/clothing/shoes/circuitry


/datum/gear/shoes/clogs
	display_name = "clogs (colorable)"
	path = /obj/item/clothing/shoes/sandal/clogs

/datum/gear/shoes/clogs/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
/datum/gear/shoes/ceremonial_guards
	display_name = "ceremonial leg guards"
	path = /obj/item/clothing/shoes/ceremonial_guards