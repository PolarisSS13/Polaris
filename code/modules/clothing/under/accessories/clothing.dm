/obj/item/clothing/accessory/vest
	name = "black vest"
	desc = "Slick black suit vest."
	icon_state = "det_vest"
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/jacket
	name = "tan suit jacket"
	desc = "Cozy suit jacket."
	icon_state = "tan_jacket"
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/jacket/charcoal
	name = "charcoal suit jacket"
	desc = "Strict suit jacket."
	icon_state = "charcoal_jacket"

/obj/item/clothing/accessory/jacket/navy
	name = "navy suit jacket"
	desc = "Official suit jacket."
	icon_state = "navy_jacket"

/obj/item/clothing/accessory/jacket/burgundy
	name = "burgundy suit jacket"
	desc = "Expensive suit jacket."
	icon_state = "burgundy_jacket"

/obj/item/clothing/accessory/jacket/checkered
	name = "checkered suit jacket"
	desc = "Lucky suit jacket."
	icon_state = "checkered_jacket"

/obj/item/clothing/accessory/chaps
	name = "brown chaps"
	desc = "A pair of loose, brown leather chaps."
	icon_state = "chaps"

/obj/item/clothing/accessory/chaps/black
	name = "black chaps"
	desc = "A pair of loose, black leather chaps."
	icon_state = "chaps_black"

/*
 * Poncho
 */
/obj/item/clothing/accessory/storage/poncho
	name = "poncho"
	desc = "A simple, comfortable poncho."
	icon_state = "classicponcho"
	item_state = "classicponcho"
	icon_override = 'icons/mob/ties.dmi'
	slots = 2
	allowed = list(/obj/item/tank/emergency/oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/suit.dmi'
	)
	var/icon_override_state		/// Change this for mid-round and paintkit.
	var/fire_resist = T0C+100

/obj/item/clothing/accessory/storage/poncho/equipped() /// Sets override, allows for mid-round changes && custom items. If you improve this code, please update paintkit.dm to accept it.
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_suit == src)
		if(icon_override_state)
			icon_override = icon_override_state
		else
			icon_override = initial(icon_override)
		H.update_inv_wear_suit()

/obj/item/clothing/accessory/storage/poncho/dropped() // Reset override
	if(icon_override_state)
		icon_override = icon_override_state
	else
		icon_override = initial(icon_override)

/obj/item/clothing/accessory/storage/poncho/on_attached(obj/item/clothing/S, mob/user) /// Otherwise gives teshari normal icon.
	. = ..()
	if(icon_override_state)
		icon_override = icon_override_state
	else
		icon_override = initial(icon_override)

/obj/item/clothing/accessory/storage/poncho/green
	name = "green poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is green."
	icon_state = "greenponcho"
	item_state = "greenponcho"

/obj/item/clothing/accessory/storage/poncho/red
	name = "red poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is red."
	icon_state = "redponcho"
	item_state = "redponcho"

/obj/item/clothing/accessory/storage/poncho/purple
	name = "purple poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is purple."
	icon_state = "purpleponcho"
	item_state = "purpleponcho"

/obj/item/clothing/accessory/storage/poncho/blue
	name = "blue poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is blue."
	icon_state = "blueponcho"
	item_state = "blueponcho"

/obj/item/clothing/accessory/storage/poncho/roles/security
	name = "security poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is black and red, standard NanoTrasen Security colors."
	icon_state = "secponcho"
	item_state = "secponcho"

/obj/item/clothing/accessory/storage/poncho/roles/medical
	name = "medical poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with green and blue tint, standard Medical colors."
	icon_state = "medponcho"
	item_state = "medponcho"

/obj/item/clothing/accessory/storage/poncho/roles/engineering
	name = "engineering poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is yellow and orange, standard Engineering colors."
	icon_state = "engiponcho"
	item_state = "engiponcho"

/obj/item/clothing/accessory/storage/poncho/roles/science
	name = "science poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with purple trim, standard NanoTrasen Science colors."
	icon_state = "sciponcho"
	item_state = "sciponcho"

/obj/item/clothing/accessory/storage/poncho/roles/cargo
	name = "cargo poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is tan and grey, the colors of Cargo."
	icon_state = "cargoponcho"
	item_state = "cargoponcho"

/*
 * Cloak
 */
/obj/item/clothing/accessory/storage/poncho/roles/cloak
	name = "quartermaster's cloak"
	desc = "An elaborate brown and gold cloak."
	icon_state = "qmcloak"
	item_state = "qmcloak"
	body_parts_covered = null

/obj/item/clothing/accessory/storage/poncho/roles/cloak/ce
	name = "chief engineer's cloak"
	desc = "An elaborate cloak worn by the chief engineer."
	icon_state = "cecloak"
	item_state = "cecloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "An elaborate cloak meant to be worn by the chief medical officer."
	icon_state = "cmocloak"
	item_state = "cmocloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/hop
	name = "head of personnel's cloak"
	desc = "An elaborate cloak meant to be worn by the head of personnel."
	icon_state = "hopcloak"
	item_state = "hopcloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/rd
	name = "research director's cloak"
	desc = "An elaborate cloak meant to be worn by the research director."
	icon_state = "rdcloak"
	item_state = "rdcloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/qm
	name = "quartermaster's cloak"
	desc = "An elaborate cloak meant to be worn by the quartermaster."
	icon_state = "qmcloak"
	item_state = "qmcloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/hos
	name = "head of security's cloak"
	desc = "An elaborate cloak meant to be worn by the head of security."
	icon_state = "hoscloak"
	item_state = "hoscloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/captain
	name = "site manager's cloak"
	desc = "An elaborate cloak meant to be worn by the site manager."
	icon_state = "capcloak"
	item_state = "capcloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/cargo
	name = "brown cloak"
	desc = "A simple brown and black cloak."
	icon_state = "cargocloak"
	item_state = "cargocloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/mining
	name = "trimmed purple cloak"
	desc = "A trimmed purple and brown cloak."
	icon_state = "miningcloak"
	item_state = "miningcloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/security
	name = "red cloak"
	desc = "A simple red and black cloak."
	icon_state = "seccloak"
	item_state = "seccloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/service
	name = "green cloak"
	desc = "A simple green and blue cloak."
	icon_state = "servicecloak"
	item_state = "servicecloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/engineer
	name = "gold cloak"
	desc = "A simple gold and brown cloak."
	icon_state = "engicloak"
	item_state = "engicloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/atmos
	name = "yellow cloak"
	desc = "A trimmed yellow and blue cloak."
	icon_state = "atmoscloak"
	item_state = "atmoscloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/research
	name = "purple cloak"
	desc = "A simple purple and white cloak."
	icon_state = "scicloak"
	item_state = "scicloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/medical
	name = "blue cloak"
	desc = "A simple blue and white cloak."
	icon_state = "medcloak"
	item_state = "medcloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/custom //A colorable cloak
	name = "cloak"
	desc = "A simple, bland cloak."
	icon_state = "colorcloak"
	item_state = "colorcloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/ceremonial
	name = "ceremonial cloak"
	desc = "A regal looking cloak of white with specks of gold woven into the fabric."
	icon_state = "ceremonial_cloak"
	item_state = "ceremonial_cloak"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/chapel
	name = "\improper Pleromanist cloak"
	desc = "An elaborate white and gold cloak typically worn by clergy during formal Pleromanist ceremonies."
	icon_state = "chap_plem"
	item_state = "chap_plem"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/chapel/alt
	name = "\improper Unitarian cloak"
	desc = "An elaborate black and gold cloak typically worn by clergy during formal Unitarian ceremonies."
	icon_state = "chap_unit"
	item_state = "chap_unit"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/half
	name = "rough half cloak"
	desc = "The latest fashion innovations by NanoThreads; the subtle stylings of slicing a regular cloak in half! All the ponce, half the manufacturing cost!"
	icon_state = "roughcloak"
	item_state = "roughcloak"
	action_button_name = "Adjust Cloak"
	var/open = 0	//0 is closed, 1 is open

/obj/item/clothing/accessory/storage/poncho/roles/cloak/half/update_clothing_icon()
	. = ..()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

/obj/item/clothing/accessory/storage/poncho/roles/cloak/half/attack_self(mob/user as mob)
	if(src.open == 0)
		src.icon_state = "[icon_state]_open"
		src.item_state = "[item_state]_open"
		flags_inv = HIDETIE|HIDEHOLSTER
		open = 1
		to_chat(user, "You flip the cloak over your shoulder.")
	else if(src.open == 1)
		src.icon_state = initial(icon_state)
		src.item_state = initial(item_state)
		flags_inv = HIDEHOLSTER
		open = 0
		to_chat(user, "You pull the cloak over your shoulder.")
	else //in case some goofy admin switches icon states around without switching the icon_open or icon_closed
		to_chat(usr, "You attempt to flip the [src] over your shoulder, but can't quite make sense of it.")
		return
	update_clothing_icon()

/obj/item/clothing/accessory/storage/poncho/roles/cloak/shoulder
	name = "left shoulder cloak"
	desc = "A small cape that primarily covers the left shoulder. Might help you stand out more, not necessarily for the right reasons."
	icon_state = "cape_left"
	item_state = "cape_left"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/shoulder/right
	name = "right shoulder cloak"
	desc = "A small cape that primarily covers the right shoulder. Maybe fashion like this is best left to the professionals."
	icon_state = "cape_right"
	item_state = "cape_right"

//Capelets
/obj/item/clothing/accessory/storage/poncho/roles/cloak/capelet
	name = "shoulder capelet"
	desc = "Not a cloak and not really a cape either, but a silky fabric that rests on the neck and shoulders alone."
	icon_state = "capelet"
	item_state = "capelet"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/capelet/cargo
	name = "cargo capelet"
	desc = "A shoulder capelet bearing the colors of the Supply department, with a gold lapel emblazoned upon the front."
	icon_state = "qmcapelet"
	item_state = "qmcapelet"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/capelet/security
	name = "security capelet"
	desc = "A shoulder capelet bearing the colors of the Security department, featuring rugged molding around the collar."
	icon_state = "hoscapelet"
	item_state = "hoscapelet"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/capelet/engineering
	name = "engineering capelet"
	desc = "A shoulder capelet bearing the colors of the Engineering department, accenting the pristine white fabric."
	icon_state = "cecapelet"
	item_state = "cecapelet"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/capelet/research
	name = "research capelet"
	desc = "A shoulder capelet bearing the colors of the Research department, the material slick and hydrophobic."
	icon_state = "rdcapelet"
	item_state = "rdcapelet"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/capelet/medical
	name = "medical capelet"
	desc = "A shoulder capelet bearing the general colors of the Medical department, dyed a sterile nitrile cyan."
	icon_state = "cmocapelet"
	item_state = "cmocapelet"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/capelet/hop
	name = "management capelet"
	desc = "A shoulder capelet bearing the colors of the Head of Personnel's uniform, featuring the typical royal blue contrasted by authoritative red."
	icon_state = "hocapelet"
	item_state = "hopcapelet"

/obj/item/clothing/accessory/storage/poncho/roles/cloak/capelet/cap
	name = "director capelet"
	desc = "A shoulder capelet bearing NanoTrasen formal uniform colours, a commanding blue with regal gold inlay."
	icon_state = "capcapelet"
	item_state = "capcapelet"


/obj/item/clothing/accessory/hawaii
	name = "flower-pattern shirt"
	desc = "You probably need some welder googles to look at this."
	icon_state = "hawaii"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/hawaii/red
	icon_state = "hawaii2"

/obj/item/clothing/accessory/hawaii/random
	name = "flower-pattern shirt"

/obj/item/clothing/accessory/hawaii/random/Initialize()
	if(prob(50))
		icon_state = "hawaii2"
	color = color_rotation(rand(-11,12)*15)
	. = ..()

/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "vest"
	item_state = "vest"
	icon_override = 'icons/mob/ties.dmi'
	item_state_slots = list(slot_r_hand_str = "wcoat", slot_l_hand_str = "wcoat")
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/wcoat/red
	name = "red waistcoat"
	icon_state = "red_waistcoat"
	item_state = "red_waistcoat"

/obj/item/clothing/accessory/wcoat/grey
	name = "grey waistcoat"
	icon_state = "grey_waistcoat"
	item_state = "grey_waistcoat"

/obj/item/clothing/accessory/wcoat/brown
	name = "brown waistcoat"
	icon_state = "brown_waistcoat"
	item_state = "brown_waistcoat"

/obj/item/clothing/accessory/wcoat/gentleman
	name = "elegant waistcoat"
	icon_state = "elegant_waistcoat"
	item_state = "elegant_waistcoat"

/obj/item/clothing/accessory/wcoat/swvest
	name = "black sweatervest"
	desc = "A sleeveless sweater. Wear this if you don't want your arms to be warm, or if you're a nerd."
	icon_state = "sweatervest"
	item_state = "sweatervest"

/obj/item/clothing/accessory/wcoat/swvest/blue
	name = "blue sweatervest"
	icon_state = "sweatervest_blue"
	item_state = "sweatervest_blue"

/obj/item/clothing/accessory/wcoat/swvest/red
	name = "red sweatervest"
	icon_state = "sweatervest_red"
	item_state = "sweatervest_red"

//Sweaters.

/obj/item/clothing/accessory/sweater
	name = "sweater"
	desc = "A warm knit sweater."
	icon_override = 'icons/mob/ties.dmi'
	icon_state = "sweater"
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/sweater/pink
	name = "pink sweater"
	desc = "A warm knit sweater. This one's pink in color."
	icon_state = "sweater_pink"

/obj/item/clothing/accessory/sweater/mint
	name = "mint sweater"
	desc = "A warm knit sweater. This one has a minty tint to it."
	icon_state = "sweater_mint"

/obj/item/clothing/accessory/sweater/blue
	name = "blue sweater"
	desc = "A warm knit sweater. This one's colored in a lighter blue."
	icon_state = "sweater_blue"

/obj/item/clothing/accessory/sweater/heart
	name = "heart sweater"
	desc = "A warm knit sweater. This one's colored in a lighter blue, and has a big pink heart right in the center!"
	icon_state = "sweater_blueheart"

/obj/item/clothing/accessory/sweater/nt
	name = "dark blue sweater"
	desc = "A warm knit sweater. This one's a darker blue."
	icon_state = "sweater_nt"

/obj/item/clothing/accessory/sweater/keyhole
	name = "keyhole sweater"
	desc = "A lavender sweater with an open chest."
	icon_state = "keyholesweater"

/obj/item/clothing/accessory/sweater/blackneck
	name = "black turtleneck"
	desc = "A tight turtleneck, entirely black in coloration."
	icon_state = "turtleneck_black"

/obj/item/clothing/accessory/sweater/winterneck
	name = "Christmas turtleneck"
	desc = "A really cheesy holiday sweater, it actually kinda itches."
	icon_state = "turtleneck_winterred"

/obj/item/clothing/accessory/sweater/uglyxmas
	name = "ugly Christmas sweater"
	desc = "A gift that probably should've stayed in the back of the closet."
	icon_state = "uglyxmas"

/obj/item/clothing/accessory/sweater/flowersweater
	name = "flowery sweater"
	desc =  "An oversized and flowery pink sweater."
	icon_state = "flowersweater"

/obj/item/clothing/accessory/sweater/redneck
	name = "red turtleneck"
	desc = "A comfortable turtleneck in a dark red."
	icon_state = "turtleneck_red"

/obj/item/clothing/accessory/sweater/virgin
	name = "virgin killer"
	desc = "A knit sweater that leaves little to the imagination."
	icon_state = "virginkiller"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO


//***
// End of sweaters
//***

/obj/item/clothing/accessory/cowledvest
	name = "cowled vest"
	desc = "A body warmer for the 26th century."
	icon_state = "cowled_vest"

/obj/item/clothing/accessory/asymmetric
	name = "blue asymmetrical jacket"
	desc = "Insultingly avant-garde in Prussian blue."
	icon_state = "asym_blue"

/obj/item/clothing/accessory/asymmetric/purple
	name = "purple asymmetrical jacket"
	desc = "Insultingly avant-garde in mauve."
	icon_state = "asym_purple"

/obj/item/clothing/accessory/asymmetric/green
	name = "green asymmetrical jacket"
	desc = "Insultingly avant-garde in aqua."
	icon_state = "asym_green"

/obj/item/clothing/accessory/asymovercoat
	name = "orange asymmetrical overcoat"
	desc = "An asymmetrical orange overcoat in a 2560's fashion."
	icon_state = "asymovercoat"

//The gold trim from one of the qipaos, separated to an accessory to preserve the color
/obj/item/clothing/accessory/qipaogold
	name = "gold trim"
	desc = "Gold trim belonging to a qipao. Why would you remove this?"
	icon_state = "qipaogold"

//Ceremonial armour set
/obj/item/clothing/accessory/ceremonial_bracers
	name = "ceremonial bracers"
	desc = "A pair of metal bracers with gold inlay. They're thin and light."
	icon_state = "ceremonialbracers"
	body_parts_covered = ARMS
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/ceremonial_loins
	name = "ceremonial loincloth"
	desc = "A lengthy loincloth that drapes over the loins, obviously. It's quite long."
	icon_state = "ceremonialloincloth"
	body_parts_covered = LOWER_TORSO
	slot = ACCESSORY_SLOT_DECOR
