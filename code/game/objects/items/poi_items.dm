
/obj/item/poi
	icon = 'icons/obj/objects.dmi'
	desc = "This is definitely something cool."

/datum/category_item/catalogue/information/objects/pascalb
	name = "Object - Pascal B Steel Shaft Cap"
	desc = "In the year 1957, the United States of America - an Earth nation - performed a series \
	of earth nuclear weapons tests codenamed 'Operation Plumbbob', which remain the largest and \
	longest running nuclear test series performed on the American continent. Test data included \
	various altitude detonations, effects on several materials and structures at various \
	distances, and the effects of radiation on military hardware and the human body. \
	<br><br>\
	On the 27th of August that year, in a test named 'Pascal-B' a 300t nuclear payload \
	was buried in a shaft capped by a 900kg steel plate cap. The test was intended to \
	verify the safety of underground detonation, but the shaft was not sufficient to \
	contain the shockwave. According to experiment designer Robert Brownlee, the steel \
	cap was propelled upwards at a velocity of 240,000km/h - over six times Earth's \
	escape velocity. The cap appeared in only one frame of high-speed camera recording. \
	<br><br>\
	It had been theorized that the cap had exited earth's atmosphere and entered orbit. \
	It would seem the cap traveled farther than had been possibly imagined."
	value = CATALOGUER_REWARD_MEDIUM

/obj/item/poi/pascalb
	icon_state = "pascalb"
	name = "misshapen manhole cover"
	desc = "The top of this twisted chunk of metal is faintly stamped with a five pointed star. 'Property of US Army, Pascal B - 1957'."
	catalogue_data = list(/datum/category_item/catalogue/information/objects/pascalb)

/obj/item/poi/pascalb/Initialize()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/item/poi/pascalb/process()
	SSradiation.radiate(src, 5)

/obj/item/poi/pascalb/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/category_item/catalogue/information/objects/oldreactor
	name = "Object - 24th Century Fission Reactor Rack"
	desc = "Prior to the discovery of Phoron in 2380, and the development of the hydrophoron \
	supermatter reactor, most spacecraft operated on nuclear fission reactors, using processed \
	radioactive material as fuel. While the design had been near-perfected by the 24th century, \
	with some models capable of holding hundreds of fuel rods at one time and operating almost \
	unsupervised for weeks at a time.\
	<br><br>\
	However, as accidents were not uncommon due to the inherent dangers of space travel and the \
	nature of reactor racks such as this one fully containing the unstable fuel material, many \
	fission vessels were built capable of jettisoning their entire engine sections as it was seen \
	as preferable to evacuating a ship's crew and potentially losing the entire craft and its cargo. \
	<br><br>\
	VifGov records indicate that the colony ship ICV Kauai declared a major onboard emergency in Sif orbit \
	on the 14th April 2353, citing major systems malfunction following a fire in the engine compartment. \
	Due to the relatively sparse population of the planet, it was deemed safe to jettison both engine \
	blocks, and the colonists were safely towed to port with no hands lost."
	value = CATALOGUER_REWARD_MEDIUM

/obj/structure/closet/crate/oldreactor
	name = "fission reactor rack"
	desc = "Used in older models of nuclear reactors, essentially a cooling rack for high volumes of radioactive material."
	icon = 'icons/obj/closets/poireactor.dmi'
	closet_appearance = null
	catalogue_data = list(/datum/category_item/catalogue/information/objects/oldreactor)
	climbable = 0
	door_anim_time = 0 //Unsupported
	open_sound = 'sound/machines/door/hatchforced.ogg'
	close_sound = 'sound/machines/door/hatchclose.ogg'

	starts_with = list(
		/obj/item/fuel_assembly/deuterium = 6)

/obj/item/poi/brokenoldreactor
	icon_state = "poireactor_broken"
	name = "ruptured fission reactor rack"
	desc = "This broken hunk of machinery looks extremely dangerous."
	catalogue_data = list(/datum/category_item/catalogue/information/objects/oldreactor)

/obj/item/poi/brokenoldreactor/Initialize()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/item/poi/brokenoldreactor/process()
	SSradiation.radiate(src, 25)

/obj/item/poi/brokenoldreactor/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/category_item/catalogue/information/objects/growthcanister
	name = "Object - Growth Inhibitor 78-1"
	desc = "The production of Vatborn humans is a process which involves the synthesis of over two hundred \
	distinct chemical compounds. While most Vatborn are 'produced' as infants and merely genetically modified \
	to encourage rapid early maturation, the specific development of the controversial 'Expedited' Vatborn calls for \
	a far more intensive process.\
	<br><br>\
	Growth Inhibitor Type 78-1 is used in the rapid artificial maturation process to prevent the 'overdevelopment' of\
	particular cell structures in the Vatborn's body, halting the otherwise inevitable development of aggressive cancerous\
	growths which would be detrimental or lethal to the subject. Exposure to the compound in its pure form can cause\
	devastating damage to living tissue, ceasing all regenerative activity in an organism's cells. While immediate effects\
	can be halted by recent medical innovations, exposure can severely shorten a sapient's life expectancy.\
	<br><br>\
	In early 2564, the NanoTrasen corporation was implicated in the accidental spillage of over a dozen full cargo containers\
	of Growth Inhibitor 78-1 in the Ullran Expanse of Sif, and were charged by the Sif Environmental Agency with extreme \
	environmental damage and neglect."
	value = CATALOGUER_REWARD_MEDIUM

/obj/structure/prop/poicanister
	name = "Ruptured Chemical Canister"
	desc = "A cracked open chemical canister labelled 'Growth Inhibitor 78-1'"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "yellow-1"
	catalogue_data = list(/datum/category_item/catalogue/information/objects/growthcanister)
	anchored = 0
	density = 1

/mob/living/carbon/human/monkey/simeon/Initialize()
	. = ..()
	name = "Simeon"
	real_name = name
	desc = "This lab monkey has a certain glint in their eye."
	
/obj/item/paper/bittersweet_transcript
	name = "bittersweet transcript"
	
/obj/item/paper/bittersweet_transcript/Initialize()	
	. = ..()
	info = {"<b>Transcript:</b><br><br>\[00:00] Recording started.<br>\[00:12] "Say what you want about them, and I sure have a lot to say, but H-H set me up with a beautiful plot to retire to."<br>\[00:26] "There's plenty of space, plenty of windows to look out into the nearby forest and watch the wildlife. They told us it's pretty safe for this part of the frontier, though I'm still glad they let me keep some surplus armor."<br>\[00:38] "The fridge is full, the tables are all set, and I even started growing lillies. They help keep the boredom away."<br>\[00:41] (Unrecognized sound) <br>\[01:02] "It doesn't stop her side of the bed from being any less cold and empty, though."<br>\[01:03] Recording stopped."}

/obj/item/paper/uneasey_transcript
	name = "uneasy transcript"

/obj/item/paper/uneasey_transcript/Initialize()
	. = ..()
	info = {"<b>Transcript:</b><br><br>\[00:00] Recording started.<br>\[00:06] "Well, it`s been a few months."<br>\[00:17] "Everything`s great, really, I`ve been recording these short little logs to give me something to do."<br>\[00:23] "I feel less insane talking to myself if it`s into a little blinking red light, anyway, haha."<br>\[00:27] (Unrecognized sound) <br>\[00:40] "There it is, though. I don`t know if this thing picked it up, but it sounds like there`s ... pacing. I thought it was just the house settling the first few times but..."<br>\[00:48] "Looking back at other transcripts, apparently it doesn`t like anything else other than talking."<br>\[00:57] "This place feels like an enclosure sometimes. All these windows feel like they have eyes, and every tree outside has become a hiding place."<br>\[01:12] "... I think I'm losing it."<br>\[01:14] Recording stopped."}

/obj/item/paper/determined_transcript
	name = "determined transcript"

/obj/item/paper/determined_transcript/Initialize()
	. = ..()
	info = {"<b>Transcript:</b><br><br>\[00:00] Recording started.<br>\[00:12] "It`s coming from inside the closet, but I think I get it now."<br>\[00:13] (Unrecognized sound)<br>\[00:19] "It won`t stop unless I make it."<br>\[00:29] "I`ll take a light and the recorder with me so I can have a record of what happens."<br>\[00:31] (Unrecognized sound)<br>\[00:42] "And I guess if it`s bad..."<br>\[00:45] "Lilly, I`ll see you soon."<br>\[00:59] Recording stopped."}

/obj/item/paper/crumpled/crumpled_transcript
	name = "crumpled transcript"

/obj/item/paper/crumpled/crumpled_transcript/Initialize()
	. = ..()
	info = {"<b>Transcript:</b><br><br>\[00:00] Recording started.<br>\[00:02] (Unrecognized sound)<br>\[00:02] (Unrecognized sound)<br>\[00:07] (Unrecognized sound)<br>\[00:12] "WHAT ARE Y-"<br>\[00:12] (Unrecognized sound)<br>\[00:13] (Unrecognized sound)<br>\[00:17] (Unrecognized sound)<br>\[15:06] (Unrecognized sound)<br>\[15:06] Recording stopped."}
