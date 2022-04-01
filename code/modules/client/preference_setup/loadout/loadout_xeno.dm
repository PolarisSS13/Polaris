// Alien clothing.

/datum/gear/suit/zhan_furs
	display_name = "Zhan-Khazan furs (Tajaran)"
	path = /obj/item/clothing/suit/tajaran/furs
	sort_category = "Xenowear"

/datum/gear/head/zhan_scarf
	display_name = "Zhan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	whitelisted = SPECIES_TAJ

/datum/gear/suit/unathi_mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	sort_category = "Xenowear"

/datum/gear/ears/skrell/chains	//Chains
	display_name = "headtail chain selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(chaintypes))

/datum/gear/ears/skrell/bands
	display_name = "headtail band selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandtypes))

/datum/gear/ears/skrell/cloth/short
	display_name = "short headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_male/black
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/cloth/short/New()
	..()
	var/list/shorttypes = list()
	for(var/short_style in typesof(/obj/item/clothing/ears/skrell/cloth_male))
		var/obj/item/clothing/ears/skrell/cloth_male/short = short_style
		shorttypes[initial(short.name)] = short
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorttypes))

/datum/gear/ears/skrell/cloth/long
	display_name = "long headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_female/black
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/cloth/long/New()
	..()
	var/list/longtypes = list()
	for(var/long_style in typesof(/obj/item/clothing/ears/skrell/cloth_female))
		var/obj/item/clothing/ears/skrell/cloth_female/long = long_style
		longtypes[initial(long.name)] = long
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(longtypes))

/datum/gear/ears/skrell/colored/band
	display_name = "Colored bands (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/band
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/band/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/ears/skrell/colored/chain
	display_name = "Colored chain (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/chain/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/smock
	display_name = "smock selection ( )"
	path = /obj/item/clothing/under/ /smock
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/uniform/smock/New()
	..()
	var/list/smocks = list()
	for(var/smock in typesof(/obj/item/clothing/under/ /smock))
		var/obj/item/clothing/under/ /smock/smock_type = smock
		smocks[initial(smock_type.name)] = smock_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(smocks))

/datum/gear/uniform/undercoat
	display_name = "undercoat selection ( )"
	path = /obj/item/clothing/under/ /undercoat/standard
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/uniform/undercoat/New()
	..()
	var/list/undercoats = list()
	for(var/undercoat in typesof(/obj/item/clothing/under/ /undercoat/standard))
		var/obj/item/clothing/under/ /undercoat/standard/undercoat_type = undercoat
		undercoats[initial(undercoat_type.name)] = undercoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(undercoats))

/datum/gear/suit/cloak
	display_name = "cloak selection ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/standard
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/suit/cloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/standard))
		var/obj/item/clothing/suit/storage/ /cloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/uniform/harness
	display_name = "gear harness (Full Body Prosthetic, Diona)"
	path = /obj/item/clothing/under/harness
	sort_category = "Xenowear"

/datum/gear/shoes/footwraps
	display_name = "cloth footwraps"
	path = /obj/item/clothing/shoes/footwraps
	sort_category = "Xenowear"
	cost = 1

/datum/gear/shoes/footwraps/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/cohesionsuits
	display_name = "cohesion suit selection (Promethean)"
	path = /obj/item/clothing/under/cohesion
	sort_category = "Xenowear"

/datum/gear/uniform/cohesionsuits/New()
	..()
	var/list/cohesionsuits = list()
	for(var/cohesionsuit in (typesof(/obj/item/clothing/under/cohesion)))
		var/obj/item/clothing/under/cohesion/cohesion_type = cohesionsuit
		cohesionsuits[initial(cohesion_type.name)] = cohesion_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cohesionsuits))

/datum/gear/uniform/dept
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/uniform/dept/undercoat/cap
	display_name = "facility director undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/cap
	allowed_roles = list("Facility Director")

/datum/gear/uniform/dept/undercoat/hop
	display_name = "head of personnel undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/dept/undercoat/rd
	display_name = "research director undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/rd
	allowed_roles = list("Research Director")

/datum/gear/uniform/dept/undercoat/hos
	display_name = "head of security undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/hos
	allowed_roles = list("Head of Security")

/datum/gear/uniform/dept/undercoat/ce
	display_name = "chief engineer undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/dept/undercoat/cmo
	display_name = "chief medical officer undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/uniform/dept/undercoat/qm
	display_name = "quartermaster undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/qm
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/dept/undercoat/cargo
	display_name = "cargo undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/cargo
	allowed_roles = list("Cargo Technician","Quartermaster","Shaft Miner")

/datum/gear/uniform/dept/undercoat/mining
	display_name = "mining undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/mining
	allowed_roles = list("Quartermaster","Shaft Miner")

/datum/gear/uniform/dept/undercoat/security
	display_name = "security undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/sec
	allowed_roles = list("Head of Security","Detective","Warden","Security Officer",)

/datum/gear/uniform/dept/undercoat/service
	display_name = "service undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/service
	allowed_roles = list("Head of Personnel","Bartender","Botanist","Janitor","Chef","Librarian","Chaplain")

/datum/gear/uniform/dept/undercoat/engineer
	display_name = "engineering undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/engineer
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/uniform/dept/undercoat/atmos
	display_name = "atmospherics undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/atmos
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/uniform/dept/undercoat/research
	display_name = "scientist undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/sci
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/uniform/dept/undercoat/robo
	display_name = "roboticist undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/robo
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/uniform/dept/undercoat/medical
	display_name = "medical undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Psychiatrist")

/datum/gear/uniform/dept/undercoat/chemistry
	display_name = "chemist undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/chemistry
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/uniform/dept/undercoat/virology
	display_name = "virologist undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/viro
	allowed_roles = list("Chief Medical Officer","Medical Doctor")

/datum/gear/uniform/dept/undercoat/psych
	display_name = "psychiatrist undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/psych
	allowed_roles = list("Chief Medical Officer","Psychiatrist")

/datum/gear/uniform/dept/undercoat/paramedic
	display_name = "paramedic undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/para
	allowed_roles = list("Chief Medical Officer","Paramedic")

/datum/gear/uniform/dept/undercoat/iaa
	display_name = "internal affairs undercoat ( )"
	path = /obj/item/clothing/under/ /undercoat/jobs/iaa
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/suit/dept/cloak
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/suit/dept/cloak/cap
	display_name = "facility director cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs
	allowed_roles = list("Facility Director")

/datum/gear/suit/dept/cloak/hop
	display_name = "head of personnel cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/suit/dept/cloak/rd
	display_name = "research director cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/rd
	allowed_roles = list("Research Director")

/datum/gear/suit/dept/cloak/hos
	display_name = "head of security cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/hos
	allowed_roles = list("Head of Security")

/datum/gear/suit/dept/cloak/hos/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/hos,/obj/item/clothing/suit/storage/ /beltcloak/jobs/hos))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/cloak/dept/ce
	display_name = "chief engineer cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/suit/dept/cloak/ce/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/ce,/obj/item/clothing/suit/storage/ /beltcloak/jobs/ce))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/cmo
	display_name = "chief medical officer cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/suit/dept/cloak/cmo/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/cmo,/obj/item/clothing/suit/storage/ /beltcloak/jobs/cmo))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/qm
	display_name = "quartermaster cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/qm
	allowed_roles = list("Chief Medical Officer")

/datum/gear/suit/dept/cloak/qm/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/qm,/obj/item/clothing/suit/storage/ /beltcloak/jobs/qm))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/cargo
	display_name = "cargo cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/cargo
	allowed_roles = list("Quartermaster","Shaft Miner","Cargo Technician")

/datum/gear/suit/dept/cloak/cargo/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/cargo,/obj/item/clothing/suit/storage/ /beltcloak/jobs/cargo))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/mining
	display_name = "mining cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/mining
	allowed_roles = list("Quartermaster","Shaft Miner")

/datum/gear/suit/dept/cloak/mining/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/mining,/obj/item/clothing/suit/storage/ /beltcloak/jobs/mining))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/security
	display_name = "security cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/sec
	allowed_roles = list("Head of Security","Detective","Warden","Security Officer")

/datum/gear/suit/dept/cloak/security/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/sec,/obj/item/clothing/suit/storage/ /beltcloak/jobs/sec))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/service
	display_name = "service cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/service
	allowed_roles = list("Head of Personnel","Bartender","Botanist","Janitor","Chef","Librarian","Chaplain")

/datum/gear/suit/dept/cloak/service/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/service,/obj/item/clothing/suit/storage/ /beltcloak/jobs/service))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/engineer
	display_name = "engineering cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/engineer
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/suit/dept/cloak/engineer/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/engineer,/obj/item/clothing/suit/storage/ /beltcloak/jobs/engineer))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/atmos
	display_name = "atmospherics cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/atmos
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/suit/dept/cloak/atmos/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/atmos,/obj/item/clothing/suit/storage/ /beltcloak/jobs/atmos))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/research
	display_name = "scientist cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/sci
	allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist")

/datum/gear/suit/dept/cloak/research/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/sci,/obj/item/clothing/suit/storage/ /beltcloak/jobs/sci))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/robo
	display_name = "roboticist cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/robo
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/suit/dept/cloak/robo/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/robo,/obj/item/clothing/suit/storage/ /beltcloak/jobs/robo))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/medical
	display_name = "medical cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/suit/dept/cloak/medical/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/medical,/obj/item/clothing/suit/storage/ /beltcloak/jobs/medical))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/chemistry
	display_name = "chemist cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/chemistry
	allowed_roles = list("Chemist")

/datum/gear/suit/dept/cloak/chemistry/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/chemistry,/obj/item/clothing/suit/storage/ /beltcloak/jobs/chemistry))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/virology
	display_name = "virologist cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/viro
	allowed_roles = list("Medical Doctor")

/datum/gear/suit/dept/cloak/virology/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/viro,/obj/item/clothing/suit/storage/ /beltcloak/jobs/viro))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/psych
	display_name = "psychiatrist cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/psych
	allowed_roles = list("Chief Medical Officer","Psychiatrist")

/datum/gear/suit/dept/cloak/paramedic
	display_name = "paramedic cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/para
	allowed_roles = list("Chief Medical Officer","Paramedic")

/datum/gear/suit/dept/cloak/paramedic/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/para,/obj/item/clothing/suit/storage/ /beltcloak/jobs/para))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/iaa
	display_name = "internal affairs cloak ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/jobs/iaa
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/suit/dept/cloak/iaa/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /cloak/jobs/iaa,/obj/item/clothing/suit/storage/ /beltcloak/jobs/iaa))
		var/obj/item/clothing/suit/storage/ /beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/uniform/smockcolor
	display_name = "smock, recolorable ( )"
	path = /obj/item/clothing/under/ /smock/white
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/uniform/smockcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/beltcloak
	display_name = "belted cloak selection ( )"
	path = /obj/item/clothing/suit/storage/ /beltcloak/standard
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/suit/beltcloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/ /beltcloak/standard))
		var/obj/item/clothing/suit/storage/ /beltcloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/beltcloak_color
	display_name = "belted cloak, recolorable ( )"
	path = /obj/item/clothing/suit/storage/ /beltcloak/standard/white_grey
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/suit/beltcloak_color/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/dept/beltcloak/wrdn
	display_name = "warden belted cloak ( )"
	path = /obj/item/clothing/suit/storage/ /beltcloak/jobs/wrdn
	allowed_roles = list("Head of Security","Warden")

/datum/gear/suit/dept/beltcloak/jani
	display_name = "janitor belted cloak ( )"
	path = /obj/item/clothing/suit/storage/ /beltcloak/jobs/jani
	allowed_roles = list("Janitor")

/datum/gear/suit/dept/beltcloak/cmd
	display_name = "command belted cloak ( )"
	path = /obj/item/clothing/suit/storage/ /beltcloak/jobs/command
	allowed_roles = list("Site Manager","Head of Personnel","Head of Security","Chief Engineer","Chief Medical Officer","Research Director")

/datum/gear/suit/cloak_hood
	display_name = "hooded cloak selection ( )"
	path = /obj/item/clothing/suit/storage/hooded/ /standard
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/suit/cloak_hood/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/hooded/ /standard))
		var/obj/item/clothing/suit/storage/ /cloak/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/uniform/worksuit
	display_name = "worksuit selection ( )"
	path = /obj/item/clothing/under/ /undercoat/standard/worksuit
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/uniform/worksuit/New()
	..()
	var/list/worksuits = list()
	for(var/worksuit in typesof(/obj/item/clothing/under/ /undercoat/standard/worksuit))
		var/obj/item/clothing/under/ /undercoat/standard/worksuit/worksuit_type = worksuit
		worksuits[initial(worksuit_type.name)] = worksuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(worksuits))

/datum/gear/uniform/undercoatcolor
	display_name = "undercoat, recolorable ( )"
	path = /obj/item/clothing/under/ /undercoat/standard/white_grey
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/uniform/undercoatcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cloakcolor
	display_name = "cloak, recolorable ( )"
	path = /obj/item/clothing/suit/storage/ /cloak/standard/white_grey
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/suit/cloakcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/labcoat_tesh
	display_name = "labcoat, colorable ( )"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/suit/labcoat_tesh/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/teshcoat
	display_name = "small black coat, recolorable stripes ( )"
	path = /obj/item/clothing/suit/storage/toggle/ coat
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/suit/teshcoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/teshcoatwhite
	display_name = "smallcoat, recolorable ( )"
	path = /obj/item/clothing/suit/storage/toggle/ coatwhite
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/suit/teshcoatwhite/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshneckscarf
	display_name = "neckscarf, recolorable ( )"
	path = /obj/item/clothing/accessory/scarf/ /neckscarf
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/accessory/teshneckscarf/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/toelessjack
	display_name = "toe-less jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless

/datum/gear/shoes/toelessknee
	display_name = "toe-less jackboots, knee-length"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless/knee

/datum/gear/shoes/toelessthigh
	display_name = "toe-less jackboots, thigh-length"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless/thigh

/datum/gear/eyes/aerogelgoggles
	display_name = "airtight orange goggles ( )"
	path = /obj/item/clothing/glasses/aerogelgoggles
	whitelisted = SPECIES_
	sort_category = "Xenowear"

/datum/gear/utility/teshchair
	display_name = "small electric wheelchair ( )"
	path = /obj/item/wheelchair/motor/small
	whitelisted = SPECIES_
	sort_category = "Xenowear"
	cost = 4

/datum/gear/shoes/teshwrap
	display_name = "  legwraps"
	path = /obj/item/clothing/shoes/footwraps/
	sort_category = "Xenowear"
	whitelisted = SPECIES_
	cost = 1

/datum/gear/shoes/teshwrap/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
