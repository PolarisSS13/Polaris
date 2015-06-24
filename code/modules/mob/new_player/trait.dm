var/global/const
	TRAIT_NONE = 0
	TRAIT_BASIC = 1
	TRAIT_ADEPT = 2
	TRAIT_EXPERT = 3

datum/trait/var
    ID = "none" // ID of the trait, used in code
    name = "None" // name of the trait
    desc = "Placeholder trait" // detailed description of the trait
    field = "Misc" // the field under which the trait will be listed

var/global/list/TRAITS = null
var/list/TRAIT_MEDIUM = list("field" = "Physical", "height" = TRAIT_BASIC, "size" = TRAIT_BASIC, "motorskills" = TRAIT_BASIC, "problemsolving" = TRAIT_BASIC)
var/global/list/TRAIT_PRE = list("Medium" = TRAIT_MEDIUM)

datum/trait/height
	ID = "height"
	name = "Height"
	desc = "Height"
	field = "Physical"

datum/trait/size
	ID = "size"
	name = "Size"
	desc = "Size"
	field = "Physical"

datum/trait/motorskills
	ID = "motorskills"
	name = "Motor Skills"
	desc = "Fine motor skills"
	field = " Non Physical"

datum/trait/problemsolving
	ID = "problemsolving"
	name = "Problem Solving"
	desc = "Ability to solve problems"
	field = "Non Physical"





proc/setup_traits()
	if(TRAITS == null)
		TRAITS = list()
		for(var/T in (typesof(/datum/trait)-/datum/trait))
			var/datum/trait/S = new T
			if(S.ID != "none")
				if(!TRAITS.Find(S.field))
					TRAITS[S.field] = list()
				var/list/L = TRAITS[S.field]
				L += S


mob/living/carbon/human/proc/GetTraitClass(points)
	return CalculateTraitClass(points, age)

proc/show_trait_window(var/mob/user, var/mob/living/carbon/human/M)
	if(!istype(M)) return
	if(TRAITS == null)
		setup_traits()

	if(!M.traits || M.traits.len == 0)
		user << "There are no traits to display."
		return

	var/HTML = "<body>"
	HTML += "<b>Select your Traits</b><br>"
	HTML += "Current trait level: <b>[M.GetTraitClass(M.used_traitpoints)]</b> ([M.used_traitpoints])<br>"
	HTML += "<table>"
	for(var/V in TRAITS)
		HTML += "<tr><th colspan = 5><b>[V]</b>"
		HTML += "</th></tr>"
		for(var/datum/trait/S in TRAITS[V])
			var/level = M.traits[S.ID]
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th>[S.name]</th>"
			HTML += "<th><font color=[(level == TRAIT_NONE) ? "red" : "black"]>\[Low\]</font></th>"
			// secondary traits don't have an amateur level
			HTML += "<th><font color=[(level == TRAIT_BASIC) ? "red" : "black"]>\[Medium\]</font></th>"
			HTML += "<th><font color=[(level == TRAIT_ADEPT) ? "red" : "black"]>\[High\]</font></th>"
			HTML += "<th><font color=[(level == TRAIT_EXPERT) ? "red" : "black"]>\[Very High\]</font></th>"
			HTML += "</tr>"
	HTML += "</table>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=show_traits;size=600x800")
	return

mob/living/carbon/human/verb/show_traits()
	set category = "IC"
	set name = "Show Own Traits"

	show_trait_window(src, src)
