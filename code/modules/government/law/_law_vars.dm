
var/global/voting_age = 13
var/global/drinking_age = 18
var/global/smoking_age = 18
var/global/gambling_age = 18
var/global/synth_vote = TRUE			// Are FBPs allowed to vote?
var/global/citizenship_vote = TRUE		// Are starsystem immigrants allowed to vote?
var/global/criminal_vote = TRUE		// Can people with criminal records vote? (unimplemented)

/proc/is_voting_eligible(var/mob/living/carbon/human/H)
	if(!ishuman(H))
		return 0

	if(!(voting_age >= H.age) )
		return 0

	if(!synth_vote && H.isSynthetic() )
		return 0

	if(!citizenship_vote && H.home_system != using_map.starsys_name)
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

//income tax rates
var/global/tax_rate_upper = 0.20
var/global/tax_rate_middle = 0.20
var/global/tax_rate_lower = 0.20

//sales tax rates
var/global/general_sales_tax = 0.10
var/global/business_income_tax = 0.10

var/global/medical_tax = 0.10
var/global/weapons_tax = 0.10
var/global/alcoholic_tax = 0.10
var/global/tobacco_tax = 0.10
var/global/recreational_drug_tax = 0.10
var/global/gambling_tax = 0.10

//contraband // See law/contraband.dm for potential contraband types.
var/global/law_CANNABIS = PERMIT_POSSESSION
var/global/law_ALCOHOL = PERMIT_SELLING
var/global/law_ECSTASY = ILLEGAL
var/global/law_PSILOCYBIN = LEGAL
var/global/law_CRACK = ILLEGAL
var/global/law_COCAINE = ILLEGAL
var/global/law_HEROIN = ILLEGAL
var/global/law_METH = ILLEGAL
var/global/law_NICOTINE = PERMIT_SELLING
var/global/law_STIMM = LEGAL
var/global/law_CYANIDE = LEGAL
var/global/law_CHLORAL = ILLEGAL

var/global/law_GUNS = PERMIT_POSSESSION
var/global/law_SMALLKNIVES = LEGAL
var/global/law_LARGEKNIVES = PERMIT_POSSESSION
var/global/law_EXPLOSIVES = ILLEGAL