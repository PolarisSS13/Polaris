//////////////////////////////
//// ERT RANGER COSTUMES /////
//// Purely cosmetic.    /////
//////////////////////////////


//Uniforms
//On-mob sprites go in icons\mob\uniform.dmi with the format "white_ranger_uniform_s" - with 'white' replaced with green, cyan, etc... of course! Note the _s - this is not optional.
//Item sprites go in icons\obj\clothing\ranger.dmi with the format "white_ranger_uniform"
/obj/item/clothing/under/color/ranger
	var/unicolor = "white"
	name = "ranger uniform"
	desc = "Made from a space-proof fibre and tight fitting, this uniform usually gives the agile Rangers all kinds of protection while not inhibiting their movement. \
	This costume is instead made from genuine cotton fibre and is based on the season three uniform."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_uniform"
	rolled_down = 0
	rolled_sleeves = 0

/obj/item/clothing/under/color/ranger/Initialize()
	. = ..()
	if(icon_state == "ranger_uniform") //allows for custom items
		name = "[unicolor] ranger uniform"
		icon_state = "[unicolor]_ranger_uniform"

/obj/item/clothing/under/color/ranger/black
	unicolor = "black"

/obj/item/clothing/under/color/ranger/pink
	unicolor = "pink"

/obj/item/clothing/under/color/ranger/green
	unicolor = "green"

/obj/item/clothing/under/color/ranger/cyan
	unicolor = "cyan"

/obj/item/clothing/under/color/ranger/orange
	unicolor = "orange"

/obj/item/clothing/under/color/ranger/yellow
	unicolor = "yellow"


//Uniforms
//On-mob sprites go in icons\mob\head.dmi with the format "white_ranger_helmet"
//Item sprites go in icons\obj\clothing\ranger.dmi with the format "white_ranger_helmet"
/obj/item/clothing/head/hardhat/ranger
	var/hatcolor = "white"
	name = "ranger helmet"
	desc = "A special helmet designed for the Go Go ERT-Rangers, able to withstand a pressureless environment, filter gas and provide air. It has thermal vision and sometimes \
	mesons to find breaches, as well as an integrated radio... well, only in the show, of course. This one has none of those features- it just has a flashlight instead."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_helmet"
	light_overlay = "helmet_light"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR

/obj/item/clothing/head/hardhat/ranger/Initialize()
	. = ..()
	if(icon_state == "ranger_helmet")
		name = "[hatcolor] ranger helmet"
		icon_state = "[hatcolor]_ranger_helmet"

/obj/item/clothing/head/hardhat/ranger/black
	hatcolor = "black"

/obj/item/clothing/head/hardhat/ranger/pink
	hatcolor = "pink"

/obj/item/clothing/head/hardhat/ranger/green
	hatcolor = "green"

/obj/item/clothing/head/hardhat/ranger/cyan
	hatcolor = "cyan"

/obj/item/clothing/head/hardhat/ranger/orange
	hatcolor = "orange"

/obj/item/clothing/head/hardhat/ranger/yellow
	hatcolor = "yellow"

//Backpack
//On-mob sprites go in icons\mob\back.dmi with the format "ranger_satchel"
//Item sprites go in icons\obj\clothing\ranger.dmi with the format "ranger_satchel"
/obj/item/weapon/storage/backpack/satchel/ranger
	name = "ranger satchel"
	desc = "A satchel designed for the Go Go ERT Rangers series to allow for slightly bigger carry capacity for the ERT-Rangers.\
	 Unlike the show claims, it is not a phoron-enhanced satchel of holding with plot-relevant content."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_satchel"

//Belt
//On-mob sprites go in icons\mob\belt.dmi with the format "ranger_belt"
//Item sprites go in icons\obj\clothing\ranger.dmi with the format "ranger_belt"
/obj/item/weapon/storage/belt/ranger
	name = "ranger belt"
	desc = "The fancy utility-belt holding the tools, cuffs and gadgets of the Go Go ERT-Rangers. The belt buckle is not real phoron, but it is still surprisingly comfortable to wear."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_belt"

//Gloves
//On-mob sprites go in icons\mob\hands.dmi with the format "white_ranger_gloves"
//Item sprites go in icons\obj\clothing\ranger.dmi with the format "white_ranger_gloves"
/obj/item/clothing/gloves/ranger
	var/glovecolor = "white"
	name = "ranger gloves"
	desc = "The gloves of the Rangers are the least memorable part. They're not even insulated in the show, so children \
	don't try and take apart a toaster with inadequate protection. They only serve to complete the fancy outfit."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_gloves"

/obj/item/clothing/gloves/ranger/Initialize()
	. = ..()
	if(icon_state == "ranger_gloves")
		name = "[glovecolor] ranger gloves"
		icon_state = "[glovecolor]_ranger_gloves"

/obj/item/clothing/gloves/ranger/black
	glovecolor = "black"

/obj/item/clothing/gloves/ranger/pink
	glovecolor = "pink"

/obj/item/clothing/gloves/ranger/green
	glovecolor = "green"

/obj/item/clothing/gloves/ranger/cyan
	glovecolor = "cyan"

/obj/item/clothing/gloves/ranger/orange
	glovecolor = "orange"

/obj/item/clothing/gloves/ranger/yellow
	glovecolor = "yellow"


//Boots
//On-mob sprites go in icons\mob\feet.dmi with the format "white_ranger_boots"
//Item sprites go in icons\obj\clothing\ranger.dmi with the format "white_ranger_boots"
/obj/item/clothing/shoes/boots/ranger
	var/bootcolor = "white"
	name = "ranger boots"
	desc = "The Rangers special lightweight hybrid magboots-jetboots perfect for EVA. If only these functions were so easy to copy in reality.\
	 These ones are just a well-made pair of boots in appropriate colours."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_boots"

/obj/item/clothing/shoes/boots/ranger/Initialize()
	. = ..()
	if(icon_state == "ranger_boots")
		name = "[bootcolor] ranger boots"
		icon_state = "[bootcolor]_ranger_boots"

/obj/item/clothing/shoes/boots/ranger/black
	bootcolor = "black"

/obj/item/clothing/shoes/boots/ranger/pink
	bootcolor = "pink"

/obj/item/clothing/shoes/boots/ranger/green
	bootcolor = "green"

/obj/item/clothing/shoes/boots/ranger/cyan
	bootcolor = "cyan"

/obj/item/clothing/shoes/boots/ranger/orange
	bootcolor = "orange"

/obj/item/clothing/shoes/boots/ranger/yellow
	bootcolor = "yellow"