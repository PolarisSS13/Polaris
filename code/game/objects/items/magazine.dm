/obj/item/tabloid
	name = "tabloid magazine"
	desc = "It's one of those trashy tabloid magazines. It looks pretty out of date."
	icon = 'icons/obj/magazine.dmi'
	icon_state = "magazine"

	var/headline
	var/static/list/tabloid_states = icon_states('icons/obj/magazine.dmi')
	var/static/list/tabloid_publishers = list(
		"\improper Solar Enquirer",
		"\improper Stellar Examiner",
		"\improper Antares Daily",
		"\improper Weekly Galactic News",
		"\improper Spiral"
	)

	var/static/list/tabloid_headlines = list(
		"NARCOALGORITHMS: ARE YOUR CHILDREN SAFE?",
		"ARE GMO HUMANS POISONOUS IN BED?",
		"TOP 10 REASONS WHY OTHER SPECIES ARE A HOAX",
		"CENTENNIAL POSITRONIC EXTENDS LIFESPAN WITH 1 SIMPLE TRICK",
		"TOP 10 DANGEROUS FOODS WITH CHEMICALS",
		"NEW TERRIFYING TEEN TREND: SUN-DIVING",
		"HAS YOUR SPOUSE BEEN REPLACED BY AN ALIEN IMPOSTER? STUDIES SUGGEST YES!",
		"SPACE CAUSES CANCER: DOCTORS CONFIRM",
		"ARE BODY SCANNERS TOO INVASIVE? FIND OUT INSIDE!",
		"HAS SCIENCE GONE TOO FAR? LOCAL SCIENTIST DEBUNKS ALIEN THEORY, DECRIES THEM AS TUBE EXPERIMENTS GONE WRONG",
		"100 DELICIOUS RECIPES LETHAL TO CARBON-BASED LIFE",
		"TOP FIVE SPECIES WE DROVE TO EXTINCTION; NUMBER TWO WILL SHOCK YOU",
		"LOCAL MAN HAS SEIZURE AFTER SAYING SKRELLIAN NAME; FORCED ASSIMILATION SOON?",
		"RELIGION WAS RIGHT? SHOCK FINDINGS SHOW ALIEN SIMILARITY TO ANIMALS, EXISTENCE OF BOATS",
		"TOP TEN REASONS WHY ONLY HUMANS ARE SENTIENT",
		"LOCAL UNATHI SYMPATHIZER: 'I really think you should stop with these spacebaiting articles.'",
		"DO UNATHI SYMPATHIZERS HATE THE HUMAN RACE?",
		"WHICH PLANET HAS THE BEST LOVERS? THIS AND MORE INSIDE!",
		"SHE SAID WE SHOULD SEE OTHER PEOPLE, SO I MARRIED A   PACK: FULL STORY INSIDE",
		"LOSE WEIGHT THREE TIMES FASTER WITH THESE LOW-G MANEUVERS!",
		"SHOCKING FIGURES REVEAL MORE TEENS DIE TO UNATHI HONOUR DUELS THAN GUN VIOLENCE",
		"MY DAUGHTER JOINED A NEURAL COLLECTIVE AND NOW SHE CAN TASTE SPACETIME: FULL STORY INSIDE",
		"WERE THE NAZIS PSYCHIC? ONE HISTORIAN TELLS ALL",
		"TAJARANS: CUTE AND CUDDLY, OR INFILTRATING THE GOVERNMENT? FIND OUT MORE INSIDE",
		"IS THE SOLAR GOVERNMENT CREATING AN AI SUPERINTELLIGENCE NEAR MERCURY? ONE EXPERT REVEALS SHOCKING INSIDER DETAILS!",
		"TOP TEN HISTORICAL FIGURES THAT WERE TWO PROMETHEANS IN A TRENCHCOAT",
		"ZADDAT: FACT OR FICTION?",
		"TOP 10 SECRET AUGMENTS THE GOVERNMENT DOESN'T WANT YOU TO GET",
		"ENLARGE YOUR MENTAL FACULTIES WITH THIS 1 WEIRD HAT",
		"'HELP, MY SON THINKS HE'S A 20TH CENTURY VID CHARACTER CALLED SPOCK' AND MORE SHOCKING TALES INSIDE",
		"18 RADICAL HIP IMPLANTS ALL THE KIDS ARE GETTING!",
		"PRESERVED HEAD OF 21ST CENTURY CAPITALIST INSISTS THAT 'DYSON WALL' ONLY SANE SOLUTION TO RIMWARD MALCONTENTS",
		"50 SHADES OF GREEN; BESTSELLING MULTISPECIES ROMANCE COMING TO CINEMAS",
		"PLUTO: DWARF PLANET, OR SECRET RAMPANT AI FACILITY HELL-BENT ON CORRUPTING YOUR CHILDREN?",
		"TOP TEN ANIME ALIENS. NUMBER 3 WILL SICKEN YOU",
		"OCTUBER X'RALLBRE EXPOSED; NUDE PHOTOSHOOT LEAKS",
		"WAR ON MARS AFTER NAKED MAN WAS FOUND; WERE THE ROMANS RIGHT?",
		"REAL ALIENS ARGUE EARTH MOVIES RACIST!",
		"HELP! I MARRIED A HEGEMONOUS SWARM INTELLIGENCE AND MY SON THINKS HE'S A ROUTER!",
		"POSITRONICS: HUMAN INGENUITY AND GENEROSITY, OR A HORRIBLE MISTAKE? FIND OUT INSIDE!",
		"TENTACLES OF TERROR: SKRELL BLACK OPS SEIGE NYX NAVAL DEPOT. SHOCKING PHOTOGRAPHS INSIDE!",
		"THE FREE TRADER UNION: NEITHER FREE NOR A UNION. SHOCKING EXPOSE!",
		"HAS THE FREE MARKET GONE TOO FAR? LUNA GLITTERPOP STAR AUCTIONS THIRD TESTICLE FOR TRANS-ORBITAL SHIPPING BONDS",
		"THEY SAID IT WAS CANCER, BUT I KNEW IT WAS A TINY, SELF-REPLICATING CLONE OF RAY KURZWEIL: FULL STORY INSIDE",
		"WHAT HAS TECHNOLOGY DONE? INDUSTRY BILLIONAIRE MARRIES OWN INFORMORPH MIND-COPY",
		"REPTILLIAN ICE WARRIORS FROM ANOTHER WORLD LIVE INSIDE YOUR AIR DUCTS: HERE'S HOW TO GET RID OF THEM",
		"10 CRITICAL THINGS YOU NEED TO KNOW ABOUT 'DRONEGATE'",
		"THEY CALL THEM JUMPGATES BUT I'VE NEVER SEEN THEM JUMP: AN INDUSTRY INSIDER SPEAKS FOR THE FIRST TIME",
		"EMERGENT INTELLIGENCES ARE STEALING YOUR BANK DETAILS, FETISHES: FOIL HAT RECIPE INSIDE",
		"TIME TRAVELLERS ARE STEALING YOUR WIFI: 5 TIPS FOR DEFEATING HACKERS FROM THE FUTURE",
		"'My mother was an alien spy': THIS CELEBRITY REVEAL WILL SHOCK AND AMAZE YOU",
		"LUMINARY SCIENTIST SPEAKS: DIABETES IS A HYPERCORP RETROVIRUS!",
		"'I REROUTED MY NEURAL CIRCUITRY SO THAT PAIN TASTES OF STRAWBERRIES' AND FIFTEEN OTHER CRAZY ALMACH STORIES",
		"JOINING THE NAVY? HERE'S 15 EXPERT TIPS FOR AVOIDING BRAIN PARASITES"
	)

/obj/item/tabloid/Initialize()
	. = ..()

	pixel_x = 5-rand(10)
	pixel_x = 5-rand(10)

	icon_state = pick(tabloid_states)
	headline =   pick(tabloid_headlines)
	name =       pick(tabloid_publishers)

/obj/item/tabloid/examine(mob/user, distance)
	. = ..()
	if(headline)
		to_chat(user, "The headline screams, \"[headline]\"")

/obj/item/tabloid/attack_self(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] leafs idly through \the [src]."))
	if(headline)
		to_chat(user, "Most of it is the usual tabloid garbage, but the headline story, \"[headline]\", holds your attention for awhile.")
		if(tabloid_headlines[headline])
			to_chat(user, tabloid_headlines[headline])
	else
		to_chat(user, "Most of it is the usual tabloid garbage. You find nothing of interest.")
	return TRUE
