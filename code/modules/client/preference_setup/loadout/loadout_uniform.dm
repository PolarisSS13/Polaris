// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/cheongsam
	display_name = "cheongsam, white"
	path = /obj/item/clothing/under/cheongsam

/datum/gear/uniform/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/croptop
	display_name = "croptop, NT"
	path = /obj/item/clothing/under/croptop

/datum/gear/uniform/croptop/grey
	display_name = "croptop, grey"
	path = /obj/item/clothing/under/croptop/grey

/datum/gear/uniform/croptop/red
	display_name = "croptop, red"
	path = /obj/item/clothing/under/croptop/red

/datum/gear/uniform/cuttop
	display_name = "cut top, grey"
	path = /obj/item/clothing/under/cuttop

/datum/gear/uniform/cuttop/red
	display_name = "cut top, red"
	path = /obj/item/clothing/under/cuttop/red

/datum/gear/uniform/jumpsuit
	display_name = "jumpclothes selection"
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	var/list/jumpclothes = list()
	for(var/jump in typesof(/obj/item/clothing/under/color))
		var/obj/item/clothing/under/color/jumps = jump
		jumpclothes[initial(jumps.name)] = jumps
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(jumpclothes))

/datum/gear/uniform/skirt
	display_name = "plaid skirt, blue"
	path = /obj/item/clothing/under/dress/plaid_blue

/datum/gear/uniform/skirt/purple
	display_name = "plaid skirt, purple"
	path = /obj/item/clothing/under/dress/plaid_purple

/datum/gear/uniform/skirt/red
	display_name = "plaid skirt, red"
	path = /obj/item/clothing/under/dress/plaid_red

/datum/gear/uniform/skirt/black
	display_name = "skirt, black"
	path = /obj/item/clothing/under/blackskirt

/datum/gear/uniform/skirt/ce
	display_name = "skirt, ce"
	path = /obj/item/clothing/under/rank/chief_engineer/skirt
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/skirt/atmos
	display_name = "skirt, atmos"
	path = /obj/item/clothing/under/rank/atmospheric_technician/skirt
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/uniform/skirt/eng
	display_name = "skirt, engineer"
	path = /obj/item/clothing/under/rank/engineer/skirt
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/uniform/skirt/roboticist
	display_name = "skirt, roboticist"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/uniform/skirt/cmo
	display_name = "skirt, cmo"
	path = /obj/item/clothing/under/rank/chief_medical_officer
	allowed_roles = list("Chief Medical Officer")

/datum/gear/uniform/skirt/chem
	display_name = "skirt, chemist"
	path = /obj/item/clothing/under/rank/chemist/skirt
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/uniform/skirt/viro
	display_name = "skirt, virologist"
	path = /obj/item/clothing/under/rank/virologist/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor")

/datum/gear/uniform/skirt/med
	display_name = "skirt, medical"
	path = /obj/item/clothing/under/rank/medical/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic")

/datum/gear/uniform/skirt/sci
	display_name = "skirt, scientist"
	path = /obj/item/clothing/under/rank/scientist/skirt
	allowed_roles = list("Research Director","Scientist")

/datum/gear/uniform/skirt/cargo
	display_name = "skirt, cargo"
	path = /obj/item/clothing/under/rank/cargotech/skirt
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/skirt/qm
	display_name = "skirt, QM"
	path = /obj/item/clothing/under/rank/cargo/skirt
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/skirt/warden
	display_name = "skirt, warden"
	path = /obj/item/clothing/under/rank/warden/skirt
	allowed_roles = list("Head of Security", "Warden")

/datum/gear/uniform/skirt/security
	display_name = "skirt, security"
	path = /obj/item/clothing/under/rank/security/skirt
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/uniform/skirt/head_of_security
	display_name = "skirt, hos"
	path = /obj/item/clothing/under/rank/head_of_security/skirt
	allowed_roles = list("Head of Security")

/datum/gear/uniform/jeans_qm
	display_name = "jeans, QM"
	path = /obj/item/clothing/under/rank/cargo/jeans
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/jeans_qmf
	display_name = "female jeans, QM"
	path = /obj/item/clothing/under/rank/cargo/jeans/female
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/jeans_cargo
	display_name = "jeans, cargo"
	path = /obj/item/clothing/under/rank/cargotech/jeans
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/jeans_cargof
	display_name = "female jeans, cargo"
	path = /obj/item/clothing/under/rank/cargotech/jeans/female
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/pants
	display_name = "pants selection"
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in typesof(/obj/item/clothing/under/pants))
		var/obj/item/clothing/under/pants/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))

/datum/gear/uniform/shorts
	display_name = "shorts selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorts))

/datum/gear/uniform/suit  //amish
	display_name = "suit, amish"
	path = /obj/item/clothing/under/sl_suit

/datum/gear/uniform/suit/black
	display_name = "suit, black"
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/uniform/suit/shinyblack
	display_name = "suit, shiny-black"
	path = /obj/item/clothing/under/lawyer/black

/datum/gear/uniform/suit/blue
	display_name = "suit, blue"
	path = /obj/item/clothing/under/lawyer/blue

/datum/gear/uniform/suit/burgundy
	display_name = "suit, burgundy"
	path = /obj/item/clothing/under/suit_jacket/burgundy

/datum/gear/uniform/suit/checkered
	display_name = "suit, checkered"
	path = /obj/item/clothing/under/suit_jacket/checkered

/datum/gear/uniform/suit/charcoal
	display_name = "suit, charcoal"
	path = /obj/item/clothing/under/suit_jacket/charcoal

/datum/gear/uniform/suit/exec
	display_name = "suit, executive"
	path = /obj/item/clothing/under/suit_jacket/really_black

/datum/gear/uniform/suit/femaleexec
	display_name = "suit, female-executive"
	path = /obj/item/clothing/under/suit_jacket/female

/datum/gear/uniform/suit/gentle
	display_name = "suit, gentlemen"
	path = /obj/item/clothing/under/gentlesuit

/datum/gear/uniform/suit/navy
	display_name = "suit, navy"
	path = /obj/item/clothing/under/suit_jacket/navy

/datum/gear/uniform/suit/red
	display_name = "suit, red"
	path = /obj/item/clothing/under/suit_jacket/red

/datum/gear/uniform/suit/redlawyer
	display_name = "suit, lawyer-red"
	path = /obj/item/clothing/under/lawyer/red

/datum/gear/uniform/suit/oldman
	display_name = "suit, old-man"
	path = /obj/item/clothing/under/lawyer/oldman

/datum/gear/uniform/suit/purple
	display_name = "suit, purple"
	path = /obj/item/clothing/under/lawyer/purpsuit

/datum/gear/uniform/suit/tan
	display_name = "suit, tan"
	path = /obj/item/clothing/under/suit_jacket/tan

/datum/gear/uniform/suit/white
	display_name = "suit, white"
	path = /obj/item/clothing/under/scratch

/datum/gear/uniform/suit/whiteblue
	display_name = "suit, white-blue"
	path = /obj/item/clothing/under/lawyer/bluesuit

/datum/gear/uniform/scrubs
	display_name = "scrubs, black"
	path = /obj/item/clothing/under/rank/medical/black
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Roboticist")

/datum/gear/uniform/scrubs/blue
	display_name = "scrubs, blue"
	path = /obj/item/clothing/under/rank/medical/blue

/datum/gear/uniform/scrubs/purple
	display_name = "scrubs, purple"
	path = /obj/item/clothing/under/rank/medical/purple

/datum/gear/uniform/scrubs/green
	display_name = "scrubs, green"
	path = /obj/item/clothing/under/rank/medical/green

/datum/gear/uniform/scrubs/navyblue
	display_name = "scrubs, navy blue"
	path = /obj/item/clothing/under/rank/medical/navyblue

/datum/gear/uniform/sundress
	display_name = "sundress"
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/sundress/white
	display_name = "sundress, white"
	path = /obj/item/clothing/under/sundress_white

/datum/gear/uniform/dress_fire
	display_name = "flame dress"
	path = /obj/item/clothing/under/dress/dress_fire

/datum/gear/uniform/uniform_captain
	display_name = "uniform, captain's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Captain")

/datum/gear/uniform/corpdetsuit
	display_name = "uniform, corporate (Detective)"
	path = /obj/item/clothing/under/det/corporate
	allowed_roles = list("Detective","Head of Security")

/datum/gear/uniform/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/uniform_hr
	display_name = "uniform, HR director (HoP)"
	path = /obj/item/clothing/under/dress/dress_hr

	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/navysecsuit
	display_name = "uniform, navyblue (Security)"
	path = /obj/item/clothing/under/rank/security/navyblue
	allowed_roles = list("Security Officer","Head of Security","Warden")