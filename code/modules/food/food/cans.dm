/obj/item/reagent_containers/food/drinks/cans
	volume = 40 //just over one and a half cups
	amount_per_transfer_from_this = 5
	atom_flags = EMPTY_BITFIELD //starts closed
	drop_sound = 'sound/items/drop/soda.ogg'
	pickup_sound = 'sound/items/pickup/soda.ogg'

//DRINKS

/obj/item/reagent_containers/food/drinks/cans/cola
	name = "\improper Space Cola"
	desc = "Reassuringly artificial. Contains caffeine."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "cola"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/cola/Initialize()
	. = ..()
	reagents.add_reagent("cola", 30)

/obj/item/reagent_containers/food/drinks/cans/decaf_cola
	name = "\improper Space Cola Free"
	desc = "More reassuringly artificial than ever before."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "decafcola"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/decaf_cola/Initialize()
	. = ..()
	reagents.add_reagent("decafcola", 30)

/obj/item/reagent_containers/food/drinks/cans/waterbottle
	name = "bottled water"
	desc = "Ice cold and utterly tasteless, this 'all-natural' mineral water comes 'fresh' from one of NanoTrasen's heavy-duty bottling plants in the Sivian poles."
	description_fluff = "This is a generic, NanoTrasen branded bottle of water.  The company swears on the quality of the water, saying it comes from the Sivian poles.  Most people disregard that and assume it's recycled from hydroponics trays."
	icon_state = "waterbottle"
	center_of_mass = list("x"=16, "y"=8)
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'

/obj/item/reagent_containers/food/drinks/cans/waterbottle/Initialize()
	. = ..()
	reagents.add_reagent("water", 30)

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind. Contains caffeine."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "space_mountain_wind"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind/Initialize()
	. = ..()
	reagents.add_reagent("spacemountainwind", 30)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko
	name = "\improper Thirteen Loko"
	desc = "The Vir Health Board has advised consumers that consumption of Thirteen Loko may result in seizures, blindness, drunkenness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko/Initialize()
	. = ..()
	reagents.add_reagent("thirteenloko", 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors. Contains caffine."
	description_fluff = "Following a 2490 lawsuit and a spate of deaths, Gilthari Exports reminds customers that the 'Dr.' legally stands for 'Drink'."
	icon_state = "dr_gibb"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb/Initialize()
	. = ..()
	reagents.add_reagent("dr_gibb", 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb_diet
	name = "\improper Diet Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors, one of which is water. Contains caffeine."
	description_fluff = "Following a 2490 lawsuit and a spate of deaths, Gilthari Exports reminds customers that the 'Dr.' legally stands for 'Drink'."
	icon_state = "dr_gibb_diet"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb_diet/Initialize()
	. =..()
	reagents.add_reagent("diet_dr_gibb", 30)

/obj/item/reagent_containers/food/drinks/cans/starkist
	name = "\improper Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...? Contains caffeine."
	description_fluff = "Brought back by popular demand in 2515 after a limited-run release in 2510, the cult success of this bizarre tasting soda has never truly been accounted for by economists."
	icon_state = "starkist"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/starkist/Initialize()
	. = ..()
	reagents.add_reagent("brownstar", 30)

/obj/item/reagent_containers/food/drinks/cans/starkistdecaf
	name = "\improper Star-kist Classic"
	desc = "The taste of a star in liquid form, in a special decaffineated blend. Still tastes faintly of tuna?"
	description_fluff = "A special variant of the Starkist brand soda introduced after popular outcry following a reformulation of the basic drink decades ago. This decaffineated variant outsells 'New' Starkist in many markets."
	icon_state = "decafstarkist"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/starkistdecaf/Initialize()
	. = ..()
	reagents.add_reagent("brownstar_decaf", 30)

/obj/item/reagent_containers/food/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	description_fluff = "The 'Space' branding was originally added to the 'Alpha Cola' product line in order to justify selling cans for 50% higher prices to 'off-world' retailers. Despite being chemically identical, Space Cola proved so popular that Centauri Provisions eventually applied the name to the entire product line - price hike and all."
	icon_state = "space-up"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/space_up/Initialize()
	. = ..()
	reagents.add_reagent("space_up", 30)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon-Lime."
	description_fluff = "Not to be confused with 'lemon & lime soda', Lemon-Lime is specially formulated using the highly propriatary Lemon-Lime Fruit. Growing the Lemon-Lime without a license is punishable by fines or jail time. Accept no immitations."
	icon_state = "lemon-lime"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime/Initialize()
	. = ..()
	reagents.add_reagent("lemon_lime", 30)

/obj/item/reagent_containers/food/drinks/cans/iced_tea
	name = "\improper Vrisk Serket Iced Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth? Contains caffeine."
	description_fluff = "Produced exclusively on the planet Oasis, Vrisk Serket Iced Tea is not sold outside of the Golden Crescent, let alone Earth."
	icon_state = "ice_tea_can"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/iced_tea/Initialize()
	. = ..()
	reagents.add_reagent("icetea", 30)

/obj/item/reagent_containers/food/drinks/cans/grape_juice
	name = "\improper Grapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	description_fluff = "Strangely, this unassuming grape soda is a product of Hephaestus Industries."
	icon_state = "purple_can"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/grape_juice/Initialize()
	. = ..()
	reagents.add_reagent("grapejuice", 30)

/obj/item/reagent_containers/food/drinks/cans/tonic
	name = "\improper T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep the Malaria away."
	description_fluff = "Due to its technically medicinal properties and the complexities of chemical copyright law, T-Borg's Tonic Water is a rare product of Zeng-Hu's 'LifeWater' refreshments division."
	icon_state = "tonic"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/tonic/Initialize()
	. = ..()
	reagents.add_reagent("tonic", 30)

/obj/item/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	description_fluff = "This is a NanoTrasen branded can of soda water.  They use the same water for this that they use for the bottled water that they sell, which may explain why the stuff isn't exactly flying off of the shelves."
	icon_state = "sodawater"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/sodawater/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 30)

/obj/item/reagent_containers/food/drinks/cans/gingerale
	name = "\improper Classic Ginger Ale"
	desc = "For when you need to be more retro than NanoTrasen already pays you for."
	description_fluff = "'Classic' beverages is a registered trademark of the Centauri Provisions corporation."
	icon_state = "gingerale"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/gingerale/Initialize()
	. = ..()
	reagents.add_reagent("gingerale", 30)

/obj/item/reagent_containers/food/drinks/cans/root_beer
	name = "\improper R&D Root Beer"
	desc = "Guaranteed to be both Rootin' and Tootin'."
	description_fluff = "Despite centuries of humanity's expansion, this particular soda is still produced almost exclusively on Earth, in North America."
	icon_state = "root_beer"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/root_beer/Initialize()
	. = ..()
	reagents.add_reagent("rootbeer", 30)

/////////////////////////BODA VENDOR DRINKS/////////////////////////

/obj/item/reagent_containers/food/drinks/cans/kvass
	name = "\improper Kvass"
	desc = "A true Slavic soda."
	description_fluff = "A classic Slavic beverage which many space-faring Slavs still enjoy to this day. Fun fact, it is actually considered a weak beer by non-Russians."
	icon_state = "kvass"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/kvass/Initialize()
	. = ..()
	reagents.add_reagent("kvass", 30)

/obj/item/reagent_containers/food/drinks/cans/kompot
	name = "\improper Kompot"
	desc = "A taste of Russia in the summertime - canned for you consumption."
	description_fluff = "A sweet and fruity beverage that was traditionally used to preserve fruits in harsh Russian winters that is now available for widespread consumption."
	icon_state = "kompot"
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/drinks/cans/kompot/Initialize()
	. = ..()
	reagents.add_reagent("kompot", 30)

/obj/item/reagent_containers/food/drinks/cans/boda
	name = "\improper Boda"
	desc = "State regulated soda beverage. Enjoy comrades."
	icon_state = "boda"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/boda/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 30)

/obj/item/reagent_containers/food/drinks/cans/bodaplus
	name = "\improper Boda-Plyus"
	desc = "State regulated soda beverage, now with added surplus flavoring. Enjoy comrades."
	icon_state = "bodaplus"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/bodaplus/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 15)
	reagents.add_reagent(pick(list(
				"applejuice",
				"grapejuice",
				"lemonjuice",
				"limejuice",
				"watermelonjuice",
				"banana",
				"berryjuice",
				"pineapplejuice")), 15)

/obj/item/reagent_containers/food/drinks/cans/redarmy
	name = "\improper Red Army Twist"
	desc = "A taste of what keeps our glorious nation running! Served as Space Commissariat Stahlin prefers it! Luke warm."
	icon_state = "red_army"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/redarmy/Initialize()
	. = ..()
	reagents.add_reagent("potatojuice", 15)
	reagents.add_reagent("sodawater", 15)

/obj/item/reagent_containers/food/drinks/cans/arstbru
	name = "\improper Arstotzka Brü"
	desc = "Just what any bureaucrat needs to get through the day. Keep stamping those papers!"
	icon_state = "arst_bru"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/arstbru/Initialize()
	. = ..()
	reagents.add_reagent("turnipjuice", 30)

/obj/item/reagent_containers/food/drinks/cans/terra_cola
	name = "\improper Terra-Cola"
	desc = "Made by the people. Served to the people."
	description_fluff = "A can of the only soft drink state approved for the benefit of the people. Served at room temperature regardless of ambient temperatures thanks to innovative 'Terran' insulation technology."
	icon_state = "terra_cola"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/terra_cola/Initialize()
	. = ..()
	reagents.add_reagent("water", 25)
	reagents.add_reagent("iron", 5)

/////////////////////////MISC VENDOR DRINKS/////////////////////////

/obj/item/reagent_containers/food/drinks/cans/straw_cola
	name = "\improper Superior Strawberry"
	desc = "Feel superior above all with Superior Strawberry!"
	icon_state = "strawcoke"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/straw_cola/Initialize()
	. = ..()
	reagents.add_reagent("strawsoda", 30)

/obj/item/reagent_containers/food/drinks/cans/apple_cola
	name = "\improper Andromeda Apple"
	desc = "Look to the stars and prepare to explore with Andromeda Apple!"
	icon_state = "applecoke"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/apple_cola/Initialize()
	. = ..()
	reagents.add_reagent("applesoda", 30)

/obj/item/reagent_containers/food/drinks/cans/lemon_cola
	name = "\improper Lunar Lemon"
	desc = "Feel back at home on the Lunar Colonies with this classic berverage straight from the source!"
	icon_state = "lemoncoke"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/lemon_cola/Initialize()
	. = ..()
	reagents.add_reagent("lemonsoda", 30)

/obj/item/reagent_containers/food/drinks/cans/sarsaparilla
	name = "\improper Starship Sarsaparilla"
	desc = "Take off and shoot for the stars with this classic cowboy cola!"
	icon_state = "sarsaparilla"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/sarsaparilla/Initialize()
	. = ..()
	reagents.add_reagent("sarsaparilla", 30)

/obj/item/reagent_containers/food/drinks/cans/grape_cola
	name = "\improper Gravity Grape"
	desc = "Get down with Newton's favorite carbonated science experiment!"
	icon_state = "grapesoda"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/grape_cola/Initialize()
	. = ..()
	reagents.add_reagent("grapesoda", 30)

/obj/item/reagent_containers/food/drinks/cans/orange_cola
	name = "\improper Orion Orange"
	desc = "Take a taste-tastic trip to Orion's Belt with Orion Orange!"
	icon_state = "orangesoda"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/orange_cola/Initialize()
	. = ..()
	reagents.add_reagent("orangesoda", 30)

/obj/item/reagent_containers/food/drinks/cans/baconsoda
	name = "\improper Bacon Soda"
	desc = "Taste something out of this world with Bacon Soda!"
	icon_state = "porkcoke"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/baconsoda/Initialize()
	. = ..()
	reagents.add_reagent("porksoda", 30)

/obj/item/reagent_containers/food/drinks/cans/dyn
	name = "\improper Cooling Breeze"
	desc = "The most refreshing thing you can find on the market, based on a Qerr'balakian medicinal plant. Contains no salt or sugar."
	description_fluff = "A drink imported from Qerr'balak, now available in human space!"
	icon_state = "dyncan"

/obj/item/reagent_containers/food/drinks/cans/dyn/Initialize()
	. = ..()
	reagents.add_reagent("dyncold", 30)

/////////////////////////CANNED BOOZE DRINKS/////////////////////////

/obj/item/reagent_containers/food/drinks/cans/beercan
	name = "\improper Sunshine Brew"
	desc = "Beat the heat with this refreshing brewed beverage."
	icon_state = "beercan"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/beercan/Initialize()
	. = ..()
	reagents.add_reagent("beer", 30)

/obj/item/reagent_containers/food/drinks/cans/alecan
	name = "\improper Hushed Whisper Pale Ale"
	desc = "A delicious Sivian IPA that's canned for your pleasure. Drink up!"
	description_fluff = "Named for one of history's most infamous pirates, Qar’raqel, who ruled over Natuna before suffering a mysterious fate. This ale is brewed on Sif by a small company... Owned by Centauri Provisions."
	icon_state = "alecan"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/cans/alecan/Initialize()
	. = ..()
	reagents.add_reagent("ale", 30)
