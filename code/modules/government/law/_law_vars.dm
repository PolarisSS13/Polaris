

/proc/is_voting_eligible(var/mob/living/carbon/human/H)
	if(!ishuman(H))
		return 0

	if(!(persistent_economy.voting_age >= H.age) )
		return 0

	if(!persistent_economy.synth_vote && H.isSynthetic() )
		return 0

	if(!persistent_economy.citizenship_vote && H.home_system != using_map.starsys_name)
		return 0

	return 1

/atom/movable/proc/is_contraband()
	return

var/global/list/potential_contraband = list(
	"Cannabis",
	"Alcohol",
	"Ecstasy",
	"Psilocybin",
	"Crack",
	"Cocaine",
	"Heroin",
	"Meth",
	"Nicotine",
	"Stimm",
	"Cyanide",
	"Chloral Hydrate",
	"Guns",
	"Short Knives",
	"Long Knives",
	"Explosives"
	)

var/global/list/tax_groups = list(
	"General Sales Tax",
	"Business Income Tax",
	"Medical Tax",
	"Weapons Tax",
	"Alcoholic Tax",
	"Tobacco Tax",
	"Recreational Drug Tax",
	"Gambling Tax"
	)

var/global/list/contraband_classifications = list(
	ILLEGAL,
	PROFESSIONAL_ONLY,
	PERMIT_SELLING,
	PERMIT_POSSESSION,
	LEGAL
	)

