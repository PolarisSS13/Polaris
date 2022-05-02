// Rash -- annoying itchy messages
// Treatable by applying ointment, or with chems
/datum/wound/rash
	name = "rash"
	autohealing = FALSE
	var/p_message = 0 // Ticks up probability of making itchy messages

/datum/wound/rash/New(var/obj/item/organ/affecting = null, var/itchiness = 1)
	..(affecting, list(HALLOSS = itchiness))

/datum/wound/rash/get_examine_tag()
	return "rash"

/datum/wound/rash/process()
	// Oh gods, it's so itchy!
	if(prob(p_message++))
		to_chat(affecting?.holder, span("warning", "Your [affecting] itches."))
		p_message = 0
