//
// Handles current president set laws, contraband and other player-persistent data relating to the colon.
//



SUBSYSTEM_DEF(law)
	name = "Law"
	init_order = INIT_ORDER_LAW
	flags = SS_NO_FIRE

	//income tax rates
	var/tax_rate_upper = 0.20
	var/tax_rate_middle = 0.20
	var/tax_rate_lower = 0.20

	//sales tax rates
	var/general_sales_tax = 0.10
	var/business_income_tax = 0.10

	var/medical_tax = 0.10
	var/weapons_tax = 0.10
	var/alcoholic_tax = 0.10
	var/tobacco_tax = 0.10
	var/recreational_drug_tax = 0.10
	var/gambling_tax = 0.10

	//contraband
	var/list/contraband = list()


