// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/blazerskirt
	display_name = "blazer, blue with skirt"
	path = /obj/item/clothing/under/blazer/skirt

/datum/gear/uniform/cheongsam
	description = "Various color variations of an old earth dress style. They are pretty close fitting around the waist."
	display_name = "cheongsam selection"
	path = /obj/item/clothing/under/cheongsam

/datum/gear/uniform/cheongsam/New()
	..()
	var/list/cheongasms = list()
	for(var/cheongasm in typesof(/obj/item/clothing/under/cheongsam))
		var/obj/item/clothing/under/cheongsam/cheongasm_type = cheongasm
		cheongasms[initial(cheongasm_type.name)] = cheongasm_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cheongasms))

/datum/gear/uniform/croptop
	description = "Light shirts which shows the midsection of the wearer."
	display_name = "croptop selection"
	path = /obj/item/clothing/under/croptop

/datum/gear/uniform/croptop/New()
	..()
	var/list/croptops = list()
	for(var/croptop in typesof(/obj/item/clothing/under/croptop))
		var/obj/item/clothing/under/croptop/croptop_type = croptop
		croptops[initial(croptop_type.name)] = croptop_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(croptops))

/datum/gear/uniform/cropsweater
	display_name = "cropped sweater"
	path = /obj/item/clothing/under/wednesday

/datum/gear/uniform/cuttop
	display_name = "cut top selection"
	description = "Loose, low-cut shirts with matching shorts."
	path = /obj/item/clothing/under/cuttop

/datum/gear/uniform/cuttop/New()
	..()
	var/list/cuttoptype = list(
	"cut top, grey" = /obj/item/clothing/under/cuttop,
	"cut top, red" = /obj/item/clothing/under/cuttop/red
	)
	gear_tweaks += new/datum/gear_tweak/path(cuttoptype)

/datum/gear/uniform/jumpsuit
	display_name = "jumpclothes selection"
	description = "Basic solid-colour durable jumpsuits."
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	var/list/jumpclothes = list()
	for(var/jump in typesof(/obj/item/clothing/under/color))
		var/obj/item/clothing/under/color/jumps = jump
		jumpclothes[initial(jumps.name)] = jumps
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(jumpclothes))

/datum/gear/uniform/colorable_jumpsuit
	display_name = "jumpsuit, colorable"
	description = "A durable jumpsuit, in any colour."
	path = /obj/item/clothing/under/colorable

/datum/gear/uniform/colorable_jumpsuit/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/qipao_colorable
	display_name = "qipao, selection (colorable)"
	path = /obj/item/clothing/under/qipao/colorable

/datum/gear/uniform/qipao_colorable/New()
	..()
	var/list/qipaos = list(
	"qipao, gold trim" = /obj/item/clothing/under/qipao/colorable,
	"qipao, slim" = /obj/item/clothing/under/qipao2,
	"qipao, short" = /obj/item/clothing/under/qipao
	)
	gear_tweaks += list(new/datum/gear_tweak/path(qipaos), gear_tweak_free_color_choice)

/datum/gear/uniform/qipao
	display_name = "qipao, pre-colored selection"
	description = "Skirts to cover your lower body, in various styles."
	path = /obj/item/clothing/under/skirt

/datum/gear/uniform/qipao/New()
	..()
	var/list/qipaos = list(
	"qipao, black" = /obj/item/clothing/under/qipao/black,
	"qipao, white" = /obj/item/clothing/under/qipao/white,
	"qipao, red" = /obj/item/clothing/under/qipao/red
	)
	gear_tweaks += new/datum/gear_tweak/path(qipaos)

/datum/gear/uniform/skirt
	display_name = "skirt, selection"
	description = "Skirts to cover your lower body, in various styles."
	path = /obj/item/clothing/under/skirt

/datum/gear/uniform/skirt/New()
	..()
	var/list/skirts = list()
	for(var/skirt in (typesof(/obj/item/clothing/under/skirt)))
		var/obj/item/clothing/under/skirt/skirt_type = skirt
		skirts[initial(skirt_type.name)] = skirt_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(skirts))

/datum/gear/uniform/pants
	display_name = "pants, selection"
	description = "A variety of pants, jeans, chaps, and other long-legged lower body apparel."
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in typesof(/obj/item/clothing/under/pants))
		var/obj/item/clothing/under/pants/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))

/datum/gear/uniform/shorts
	display_name = "shorts, selection"
	description = "A variety of shorts, jorts, and other short-legged lower body apparel."
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorts))

/datum/gear/uniform/job_skirt
	display_name = "skirt, job selection"
	description = "Skirt options for standard job uniforms."
	path = /obj/item/clothing/under/rank/chief_engineer/skirt

/datum/gear/uniform/job_skirt/New()
	..()
	var/list/skirttype = list(
	"skirt, chief engineer" = /obj/item/clothing/under/rank/chief_engineer/skirt,
	"skirt, atmospheric technician" = /obj/item/clothing/under/rank/atmospheric_technician/skirt,
	"skirt, engineer" = /obj/item/clothing/under/rank/engineer/skirt,
	"skirt, roboticist" = /obj/item/clothing/under/rank/roboticist/skirt,
	"skirt, CMO" = /obj/item/clothing/under/rank/chief_medical_officer/skirt,
	"skirt, chemist" = /obj/item/clothing/under/rank/chemist/skirt,
	"skirt, virologist" = /obj/item/clothing/under/rank/virologist/skirt,
	"skirt, medical" = /obj/item/clothing/under/rank/medical/skirt,
	"skirt, scientist" = /obj/item/clothing/under/rank/scientist/skirt
	)
	gear_tweaks += new/datum/gear_tweak/path(skirttype)

/datum/gear/uniform/job_turtle
	display_name = "turtleneck, departmental selection"
	description = "High-necked sweaters in a variety of departmental colours."
	path = /obj/item/clothing/under/rank/scientist/turtleneck

/datum/gear/uniform/job_turtle/New()
	..()
	var/list/turtletype = list(
	"turtleneck, science" = /obj/item/clothing/under/rank/scientist/turtleneck,
	"turtleneck, engineering" = /obj/item/clothing/under/rank/engineer/turtleneck,
	"turtleneck, security" = /obj/item/clothing/under/rank/security/turtleneck,
	"turtleneck, medical" = /obj/item/clothing/under/rank/medical/turtleneck
	)
	gear_tweaks += new/datum/gear_tweak/path(turtletype)

/datum/gear/uniform/uniform_cargo
	display_name = "uniform, cargo selection"
	description = "A selection of standard uniforms for cargo department employees."
	path = /obj/item/clothing/under/rank/cargotech/jeans
	allowed_roles = list("Quartermaster", "Shaft Miner", "Cargo Technician")

/datum/gear/uniform/uniform_cargo/New()
	..()
	var/list/cargotype = list(
	"cargo uniform, shorts" = /obj/item/clothing/under/rank/cargotech/shorts,
	"cargo uniform, jeans" = /obj/item/clothing/under/rank/cargotech/jeans,
	"cargo uniform, feminine jeans" = /obj/item/clothing/under/rank/cargotech/jeans/female,
	"cargo uniform, skirt" = /obj/item/clothing/under/rank/cargotech/skirt
	)
	gear_tweaks += new/datum/gear_tweak/path(cargotype)

/datum/gear/uniform/uniform_qm
	display_name = "uniform, quartermaster selection"
	description = "A selection of standard uniforms for the quartermaster."
	path = /obj/item/clothing/under/rank/cargo/jeans
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/uniform_qm/New()
	..()
	var/list/qmtype = list(
	"quartermaster uniform, jeans" = /obj/item/clothing/under/rank/cargo/jeans,
	"quartermaster uniform, feminine jeans" = /obj/item/clothing/under/rank/cargo/jeans/female,
	"quartermaster uniform, skirt" = /obj/item/clothing/under/rank/cargo/skirt
	)
	gear_tweaks += new/datum/gear_tweak/path(qmtype)

/datum/gear/uniform/old_miner
	display_name = "overalls, purple shirt"
	path = /obj/item/clothing/under/rank/miner/old

/datum/gear/uniform/suit_lawyer
	display_name = "suit, one-piece selection"
	description = "A selection of suits without removable jackets."
	path = /obj/item/clothing/under/lawyer

/datum/gear/uniform/suit_lawyer/New()
	..()
	var/list/lsuits = list()
	for(var/lsuit in typesof(/obj/item/clothing/under/lawyer, /obj/item/clothing/under/sl_suit, /obj/item/clothing/under/gentlesuit))
		var/obj/item/clothing/under/lsuit_type = lsuit
		lsuits[initial(lsuit_type.name)] = lsuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(lsuits))

/datum/gear/uniform/suit_jacket
	display_name = "suit, modular selection"
	description = "A selection of suits with removable jackets, waistcoats, etc."
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/uniform/suit_jacket/New()
	..()
	var/list/msuits = list()
	for(var/msuit in typesof(/obj/item/clothing/under/suit_jacket))
		var/obj/item/clothing/suit/msuit_type = msuit
		msuits[initial(msuit_type.name)] = msuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(msuits))

/datum/gear/uniform/detectiveblack
	display_name = "suit, detective black (Detective)"
	path = /obj/item/clothing/under/det/black_alt
	allowed_roles = list("Detective")

/datum/gear/uniform/detectiveskirt
	display_name = "suit, detective skirt (Detective)"
	path = /obj/item/clothing/under/det/skirt
	allowed_roles = list("Detective")

/datum/gear/uniform/iaskirt
	display_name = "suit, Internal Affairs skirt (Internal Affairs)"
	path = /obj/item/clothing/under/rank/internalaffairs/skirt
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/uniform/bartenderskirt
	display_name = "suit, bartender skirt (Bartender)"
	path = /obj/item/clothing/under/rank/bartender/skirt
	allowed_roles = list("Bartender")

/datum/gear/uniform/scrub
	display_name = "scrubs selection"
	description = "Medical gear made of a special fiber that provides minor protection against biohazards."
	path = /obj/item/clothing/under/rank/medical/scrubs

/datum/gear/uniform/scrub/New()
	..()
	var/list/scrubs = list()
	for(var/scrub in typesof(/obj/item/clothing/under/rank/medical/scrubs))
		var/obj/item/clothing/under/rank/medical/scrubs/scrub_type = scrub
		scrubs[initial(scrub_type.name)] = scrub_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(scrubs))

/datum/gear/uniform/oldwoman
	display_name = "outfit, old woman"
	path = /obj/item/clothing/under/oldwoman

/datum/gear/uniform/sundress
	display_name = "sundress selection"
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/sundress/New()
	..()
	var/list/sdresstype = list(
	"sundress" = /obj/item/clothing/under/sundress,
	"sundress, long blue" = /obj/item/clothing/under/dress/sundress_blue,
	"sundress, pink" = /obj/item/clothing/under/dress/sundress_pink,
	"sundress, pink with bow" = /obj/item/clothing/under/dress/sundress_pinkbow,
	"sundress, short pink" = /obj/item/clothing/under/dress/sundress_pinkshort,
	"sundress, white" = /obj/item/clothing/under/sundress_white,
	"sundress, white alt" = /obj/item/clothing/under/dress/sundress_white
	)
	gear_tweaks += new/datum/gear_tweak/path(sdresstype)

/datum/gear/uniform/dress_fire
	display_name = "dress, flame"
	path = /obj/item/clothing/under/dress/dress_fire

/datum/gear/uniform/uniform_captain
	display_name = "uniform, site manager's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Site Manager")

/datum/gear/uniform/uniform_security
	display_name = "uniform, security selection"
	description = "A selection of standard uniforms for security officers and detectives."
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/uniform/uniform_security/New()
	..()
	var/list/secunitype = list(
	"officer uniform, corporate" = /obj/item/clothing/under/rank/security/corp,
	"officer uniform, navy" = /obj/item/clothing/under/rank/security/navyblue,
	"officer uniform, hedberg-hammarstrom" = /obj/item/clothing/under/hedberg,
	"officer uniform, red skirt" = /obj/item/clothing/under/rank/security/skirt,
	"detective uniform, corporate" = /obj/item/clothing/under/det/corporate
	)
	gear_tweaks += new/datum/gear_tweak/path(secunitype)

/datum/gear/uniform/uniform_warden
	display_name = "uniform, warden selection"
	description = "A selection of standard uniforms for security wardens."
	path = /obj/item/clothing/under/rank/warden/corp
	allowed_roles = list("Head of Security","Warden")

/datum/gear/uniform/uniform_warden/New()
	..()
	var/list/warunitype = list(
	"warden uniform, corporate" = /obj/item/clothing/under/rank/warden/corp,
	"warden uniform, navy" = /obj/item/clothing/under/rank/warden/navyblue,
	"warden uniform, red skirt" = /obj/item/clothing/under/rank/warden/skirt
	)
	gear_tweaks += new/datum/gear_tweak/path(warunitype)

/datum/gear/uniform/uniform_hos
	display_name = "uniform, head of security selection"
	description = "A selection of standard uniforms for heads of security."
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list("Head of Security")

/datum/gear/uniform/uniform_hos/New()
	..()
	var/list/hosunitype = list(
	"HoS uniform, corporate" = /obj/item/clothing/under/rank/head_of_security/corp,
	"HoS uniform, navy" = /obj/item/clothing/under/rank/head_of_security/navyblue,
	"HoS Uniform, red skirt" = /obj/item/clothing/under/rank/head_of_security/skirt
	)
	gear_tweaks += new/datum/gear_tweak/path(hosunitype)

/datum/gear/uniform/uniform_hop
	display_name = "uniform, head of personnel selection"
	description = "A selection of formal uniforms for the Head of Personnel."
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/uniform_hop/New()
	..()
	var/list/hopunitype = list(
	"HoP dress" = /obj/item/clothing/under/dress/dress_hop,
	"HR director" = /obj/item/clothing/under/dress/dress_hr
	)
	gear_tweaks += new/datum/gear_tweak/path(hopunitype)
/datum/gear/uniform/dresses_colorable
	display_name = "dress, colorable selection"
	path = /obj/item/clothing/under/dress/white4

/datum/gear/uniform/dresses_colorable/New()
	..()
	var/list/dresses = list(
	"plain dress" = /obj/item/clothing/under/dress/white3,
	"short, sleeveless dress" = /obj/item/clothing/under/dress/little_strapless,
	"long, sleeveless dress" = /obj/item/clothing/under/dress/long_strapless,
	"long dress" = /obj/item/clothing/under/dress/white2,
	"long, wide dress" = /obj/item/clothing/under/dress/white4
	)
	gear_tweaks += list(new/datum/gear_tweak/path(dresses), gear_tweak_free_color_choice)


/datum/gear/uniform/reddress
	display_name = "dress, red with belt"
	path = /obj/item/clothing/under/dress/darkred

/datum/gear/uniform/whitewedding
	display_name = "dress, white wedding"
	path = /obj/item/clothing/under/wedding/bride_white

/datum/gear/uniform/dresses
	display_name = "dress, sailor"
	path = /obj/item/clothing/under/dress/sailordress

/datum/gear/uniform/dresses/eveninggown
	display_name = "dress, evening gown, red"
	path = /obj/item/clothing/under/dress/redeveninggown

/datum/gear/uniform/dresses/maid
	display_name = "uniform, maid selection"
	description = "A variety of maid uniform styles."
	path = /obj/item/clothing/under/dress/maid

/datum/gear/uniform/dresses/maid/New()
	..()
	var/list/maids = list()
	for(var/maid in typesof(/obj/item/clothing/under/dress/maid))
		var/obj/item/clothing/under/dress/maid/maid_type = maid
		maids[initial(maid_type.name)] = maid_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(maids))

/datum/gear/uniform/utility
	display_name = "jumpsuit, utility selection"
	description = "A selection of especially hard-wearing jumpclothes for heavy duties."
	path = /obj/item/clothing/under/utility

/datum/gear/uniform/utility/New()
	..()
	var/list/utils = list()
	for(var/util in typesof(/obj/item/clothing/under/utility, /obj/item/clothing/under/gsa_work, /obj/item/clothing/under/gsa))
		var/obj/item/clothing/under/util_type = util
		utils[initial(util_type.name)] = util_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(utils))

/datum/gear/uniform/utility_medical
	display_name = "utility, medical"
	path = /obj/item/clothing/under/rank/medical/utility
	allowed_roles = list("Chief Medical Officer", "Paramedic", "Medical Doctor", "Psychiatrist", "Search and Rescue", "Chemist")

/datum/gear/uniform/sweater
	display_name = "sweater, grey"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater

/datum/gear/uniform/sweaterretro
	display_name = "sweater, retro"
	path = /obj/item/clothing/under/retrosweater

/datum/gear/uniform/brandsuit
	display_name = "jumpsuit/uniform, corporate selection"
	description = "Liveried durable jumpclothes and other Trans-Stellar corporate uniforms."
	path = /obj/item/clothing/under/corp/aether

/datum/gear/uniform/brandsuit/New()
	..()
	var/list/brandsuits = list()
	for(var/brandsuit in typesof(/obj/item/clothing/under/corp, /obj/item/clothing/under/hedbergtech) - /obj/item/clothing/under/corp)
		var/obj/item/clothing/under/corp/brandsuit_type = brandsuit
		brandsuits[initial(brandsuit_type.name)] = brandsuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(brandsuits))

/datum/gear/uniform/frontier
	display_name = "outfit, frontier"
	path = 	/obj/item/clothing/under/frontier

/datum/gear/uniform/retro_outdoors
	display_name = "outfit, retro outdoors"
	path = /obj/item/clothing/under/retro_outdoors
/datum/gear/uniform/yogapants
	display_name = "pants, yoga (colorable)"
	path = /obj/item/clothing/under/pants/yogapants

/datum/gear/uniform/yogapants/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/black_corset
	display_name = "black corset"
	path = /obj/item/clothing/under/dress/black_corset

/datum/gear/uniform/flower_dress
	display_name = "dress, flower"
	path = /obj/item/clothing/under/dress/flower_dress

/datum/gear/uniform/red_swept_dress
	display_name = "dress, red swept"
	path = /obj/item/clothing/under/dress/red_swept_dress

/datum/gear/uniform/bathrobe
	display_name = "bathrobe"
	path = /obj/item/clothing/under/bathrobe

/datum/gear/uniform/flamenco
	display_name = "dress, flamenco"
	path = /obj/item/clothing/under/dress/flamenco

/datum/gear/uniform/alpinedress
	display_name = "dress, alpine"
	path = /obj/item/clothing/under/dress/alpine

/datum/gear/uniform/westernbustle
	display_name = "dress, western bustle"
	path = /obj/item/clothing/under/dress/westernbustle

/datum/gear/uniform/circuitry
	display_name = "jumpsuit, circuitry (empty)"
	path = /obj/item/clothing/under/circuitry

/datum/gear/uniform/sleekoverall
	display_name = "overalls, sleek"
	path = /obj/item/clothing/under/overalls/sleek

/datum/gear/uniform/sarired
	display_name = "sari, red"
	path = /obj/item/clothing/under/dress/sari

/datum/gear/uniform/sarigreen
	display_name = "sari, green"
	path = /obj/item/clothing/under/dress/sari/green

/datum/gear/uniform/wrappedcoat
	display_name = "outfit, modern wrapped coat"
	path = /obj/item/clothing/under/moderncoat

/datum/gear/uniform/ascetic
	display_name = "outfit, plain ascetic garb"
	path = /obj/item/clothing/under/ascetic

/datum/gear/uniform/pleated
	display_name = "pleated skirt"
	path = /obj/item/clothing/under/skirt/pleated

/datum/gear/uniform/pleated/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/lilacdress
	display_name = "dress, lilac"
	path = /obj/item/clothing/under/dress/lilacdress

/datum/gear/uniform/polka
	display_name = "dress, polka dot"
	path = /obj/item/clothing/under/dress/polka

/datum/gear/uniform/twistfront
	display_name = "dress, twistfront crop"
	path = /obj/item/clothing/under/dress/twistfront

/datum/gear/uniform/cropdress
	display_name = "dress, crop"
	path = /obj/item/clothing/under/dress/cropdress

/datum/gear/uniform/vneckdress
	display_name = "dress, v-neck"
	path = /obj/item/clothing/under/dress/vneck

/datum/gear/uniform/bluedress
	display_name = "dress, blue"
	path = /obj/item/clothing/under/dress/bluedress

/datum/gear/uniform/wench
	display_name = "dress, wench"
	path = /obj/item/clothing/under/dress/wench

/datum/gear/uniform/littleblackdress
	display_name = "dress, little black"
	path = /obj/item/clothing/under/dress/littleblackdress

/datum/gear/uniform/golddress
	display_name = "dress, golden"
	path =/obj/item/clothing/under/dress/golddress

/datum/gear/uniform/goldwrap
	display_name = "golden wrap"
	path =/obj/item/clothing/under/dress/goldwrap

/datum/gear/uniform/pinktutu
	display_name = "skirt, pink tutu"
	path = /obj/item/clothing/under/dress/pinktutu

/datum/gear/uniform/festivedress
	display_name = "dress, festive"
	path = /obj/item/clothing/under/dress/festivedress

/datum/gear/uniform/haltertop
	display_name = "halter top"
	path = /obj/item/clothing/under/haltertop

/datum/gear/uniform/revealingdress
	display_name = "dress, revealing"
	path = /obj/item/clothing/under/dress/revealingdress

/datum/gear/uniform/rippedpunk
	display_name = "outfit, ripped punk"
	path = /obj/item/clothing/under/rippedpunk

/datum/gear/uniform/gothic
	display_name = "dress, gothic"
	path = /obj/item/clothing/under/dress/gothic

/datum/gear/uniform/formalred
	display_name = "dress, formal red"
	path = /obj/item/clothing/under/dress/formalred

/datum/gear/uniform/pentagram
	display_name = "dress, pentagram"
	path = /obj/item/clothing/under/dress/pentagram

/datum/gear/uniform/yellowswoop
	display_name = "dress, yellow swooped"
	path = /obj/item/clothing/under/dress/yellowswoop

/datum/gear/uniform/greenasym
	display_name = "jumpsuit, green asymmetrical"
	path = /obj/item/clothing/under/greenasym

/datum/gear/uniform/cyberpunkharness
	display_name = "outfit, cyberpunk strapped harness"
	path = /obj/item/clothing/under/cyberpunkharness

/datum/gear/uniform/cyberpunkpants
	display_name = "outfit, cyberpunk split-side ensemble"
	path = /obj/item/clothing/under/cyberpunkpants

/datum/gear/uniform/whitegown
	display_name = "dress, white gown"
	path = /obj/item/clothing/under/wedding/whitegown

/datum/gear/uniform/floofdress
	display_name = "dress, floofy"
	path = /obj/item/clothing/under/wedding/floofdress

/datum/gear/uniform/floofdress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/blackngold
	display_name = "dress, black and gold gown"
	path = /obj/item/clothing/under/blackngold

/datum/gear/uniform/sheerblue
	display_name = "dress, sheer blue"
	path = /obj/item/clothing/under/sheerblue

/datum/gear/uniform/disheveled
	display_name = "suit, disheveled"
	path = /obj/item/clothing/under/disheveled

/datum/gear/uniform/orangedress
	display_name = "dress, orange"
	path = /obj/item/clothing/under/dress/dress_orange

/datum/gear/uniform/twopiece
	display_name = "dress, two-piece"
	path = /obj/item/clothing/under/dress/twopiece

/datum/gear/uniform/gothic2
	display_name = "dress, lacey gothic"
	path = /obj/item/clothing/under/dress/gothic2

/datum/gear/uniform/flowerskirt
	display_name = "skirt, flower"
	path = /obj/item/clothing/under/flower_skirt

/datum/gear/uniform/flowerskirt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/countess
	display_name = "dress, countess"
	path = /obj/item/clothing/under/dress/countess

/datum/gear/uniform/vampire
	display_name = "pants, high-waisted trousers"
	path = /obj/item/clothing/under/hightrousers

/datum/gear/uniform/chaplain_stripe
	display_name = "jumpsuit, chaplain striped"
	path = /obj/item/clothing/under/rank/chaplain/alt
	allowed_roles = list("Chaplain")

/datum/gear/uniform/costumes
	display_name = "costume clothing selection"
	description = "A selection of fancy-dress costumes worn on the clothing slot."
	path = /obj/item/clothing/under/costume

/datum/gear/uniform/costumes/New()
	..()
	var/list/costumes = list()
	for(var/costume in typesof(/obj/item/clothing/under/costume))
		var/obj/item/clothing/under/costume/costume_type = costume
		costumes[initial(costume_type.name)] = costume_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(costumes))

/datum/gear/uniform/ceremonial
	display_name = "outfit, ceremonial selection"
	path = /obj/item/clothing/under/dress/ceremonial

/datum/gear/uniform/ceremonial/New()
	..()
	var/list/hopunitype = list(
	"ceremonial corset with bodystocking" = /obj/item/clothing/under/dress/ceremonial,
	"ceremonial corset without bodystocking" = /obj/item/clothing/under/dress/ceremonial/sheerless
	)
	gear_tweaks += new/datum/gear_tweak/path(hopunitype)

//Colorable skirts
/datum/gear/uniform/coloredskirts
	display_name = "skirt selection, colorable"
	path = /obj/item/clothing/under/skirt/colorable

/datum/gear/uniform/coloredskirts/New()
	..()
	var/list/skirts = list(
	"casual skirt" = /obj/item/clothing/under/skirt/colorable,
	"puffy skirt" = /obj/item/clothing/under/skirt/colorable/puffy,
	"skater skirt" = /obj/item/clothing/under/skirt/colorable/skater,
	"pleated skirt" = /obj/item/clothing/under/skirt/colorable/pleated,
	"pencil skirt" = /obj/item/clothing/under/skirt/colorable/pencil,
	"plaid skirt" = /obj/item/clothing/under/skirt/colorable/plaid,
	"tube skirt" = /obj/item/clothing/under/skirt/colorable/tube,
	"long skirt" = /obj/item/clothing/under/skirt/colorable/long,
	"high skirt" = /obj/item/clothing/under/skirt/colorable/high,
	"swept skirt" = /obj/item/clothing/under/skirt/colorable/swept,
	"jumper skirt" = /obj/item/clothing/under/skirt/colorable/jumper,
	"jumper dress" = /obj/item/clothing/under/skirt/colorable/jumperdress
	)
	gear_tweaks += list(new/datum/gear_tweak/path(skirts), gear_tweak_free_color_choice)
