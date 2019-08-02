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
	name = "Basic Treatment"
	description = "A basic treatment which usually involves items within any medical pack."
	cost = 8
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/bone_surgery
	name = "Bone Repair Surgery"
	description = "Surgery to mend and repair bones, per bone."
	cost = 450
	insurance_coverage = INSURANCE_INTERMEDIATE

/datum/medical_bill/organ_repair
	name = "Organ Repair Surgery"
	description = "Surgery to mend injured or septic organs, per organ."
	cost = 550
	insurance_coverage = INSURANCE_INTERMEDIATE

/datum/medical_bill/internal_bleeding
	name = "Internal Bleeding"
	description = "Fixing internal bleeding."
	cost = 350
	insurance_coverage = INSURANCE_BASIC

/datum/medical_bill/organs_limbs
	name = "Organ and Limb Replacement"
	description = "Replacement of organs and limbs. Limbs and organs sold separately."
	cost = 2500
	insurance_coverage = INSURANCE_HIGH


/datum/medical_bill/genetics_treatment
	name = "Genetics Treatment"
	description = "Any form of genetics treatment, that includes dna modification or cloning."
	cost = 2000
	insurance_coverage = INSURANCE_HIGH
