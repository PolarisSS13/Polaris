var/global/list/medical_bills = list()

/hook/startup/proc/populate_medical_datums()
	instantiate_medical_bills()
	return 1

/proc/instantiate_medical_bills()
	//This proc loads all laws, if they don't exist already.

	for(var/instance in subtypesof(/datum/medical_bill))
		var/datum/medical_bill/M = new instance
		medical_bills += M

/datum/medical_bill

	var/name = "Sample Medical Bill"
	var/description = "n/a"

	var/cost = 0								//	In credits

	var/insurance_coverage = INSURANCE_BASIC	// The type of insurance that covers this treatment.
	var/can_edit = 1							//	Can the minister of health/president edit this?

/datum/medical_bill/basic_treatment
	name = "Damage (Oxyloss, Toxin, Burns, Brute) under 50 ticks"
	description = "A basic treatment which usually involves items within any medical pack under 50 ticks."
	cost = 60
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/basic_treatment_over
	name = "Damage (Oxyloss, Toxin, Burns, Brute) over 50 ticks"
	description = "A basic treatment which usually involves items within any medical pack over 50 ticks."
	cost = 80
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/basic_treatment_vend
	name = "NanoMed Vended Items"
	description = "Items vended from NanoMed Plus."
	cost = 150
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/basic_treatment_iv
	name = "IV Drip"
	description = "Use of IV drip to restore patient blood."
	cost = 250
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/machinery
	name = "Body Scan"
	description = "Scan of patient vitals through body scanner."
	cost = 50
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/machinery_sleep
	name = "Sleeper"
	description = "Use of sleeper."
	cost = 300
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/machinery_cryo
	name = "Cryo Cell"
	description = "Use of cryo cell."
	cost = 350
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/bone_surgery
	name = "Bone Repair Surgery"
	description = "Surgery to mend and repair bones, per bone."
	cost = 700
	insurance_coverage = INSURANCE_INTERMEDIATE

/datum/medical_bill/organ_repair
	name = "Organ Repair Surgery"
	description = "Surgery to mend injured or septic organs, per organ."
	cost = 800
	insurance_coverage = INSURANCE_INTERMEDIATE

/datum/medical_bill/internal_bleeding
	name = "Internal Bleeding"
	description = "Fixing internal bleeding."
	cost = 700
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/organs_limbs
	name = "Organ Replacement"
	description = "Organ replacement surgery. Organs sold separately."
	cost = 2000
	insurance_coverage = INSURANCE_HIGH

/datum/medical_bill/organs_limbs
	name = "Limb Replacement"
	description = "Limb replacement surgery. Limbs sold separately."
	cost = 1750
	insurance_coverage = INSURANCE_HIGH

/datum/medical_bill/facial
	name = "Facial Reconstruction Surgery"
	description = "Surgical reconstruction of a face for cosmetic purposes."
	cost = 500
	insurance_coverage = INSURANCE_HIGH

/datum/medical_bill/miscellaneous_stasis
	name = "Stasis Bag"
	description = "Use of stasis bag to transport an individual."
	cost = 150
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/defib
	name = "Defibrillator"
	description = "Use of Defibrillator to revive."
	cost = 250
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/genetics_treatment
	name = "Genetics Treatment"
	description = "Any form of genetics treatment, that includes dna modification or cloning."
	cost = 2000
	insurance_coverage = INSURANCE_HIGH

/datum/medical_bill/therapy
	name = "Therapy Session"
	description = "A psychotherapy session which is used to treat mental health."
	cost = 150
	insurance_coverage = INSURANCE_BASIC