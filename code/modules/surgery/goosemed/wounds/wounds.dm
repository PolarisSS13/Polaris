
/datum/wound
	var/autohealing = TRUE
	var/list/damage = list() // list(DAM_TYPE = DAMAGE)
	var/obj/item/organ/affecting = null
	var/closed = TRUE
	var/remove_when_no_damage = TRUE  // Some wounds have effects beyond simple damage
	var/healing_chem_scale_factor = 1 // Smaller numbers mean chems are less effective against this wound.
	var/list/surgery_steps = list()   // The list of surgery steps added by this wound
	var/is_infected = FALSE           // If the wound has become infected. Open wounds can become infected, and other wounds may have separate logic

/datum/wound/New(var/obj/item/organ/affecting = null, var/list/damage = null)
	if(!istype(affecting))
		return // Wounds exist only to apply suffering.
	src.affecting = affecting
	if(LAZYLEN(damage))
		src.damage = damage

/datum/wound/Destroy()
	affecting?.clear_wound(src)
	affecting = null
	return ..()

/datum/wound/proc/get_damage(var/damage_type)
	return LAZYFIND(damage, damage_type)

/datum/wound/proc/get_damage_total()
	. = 0
	for(var/damage_type in damage)
		. += damage[damage_type]

/datum/wound/proc/process()
	if(!istype(affecting))
		qdel(src)
		return
	
	for(var/damage_type in damage)
		if(autohealing)
			damage[damage_type] -= 0.1
		if(damage[damage_type <= 0])
			damage.Remove(damage_type)
	
	if(!LAZYLEN(damage) && remove_when_no_damage)
		qdel(src)
		return
	
	if(!closed)
		// Infections!
	
	// do the pain

// Oops, you seem to be leaking!
// Only functional if called during affecting's process step, because affecting won't have reagents to bleed otw!
/datum/wound/proc/try_bleed(var/damage_scale_type, var/bleeding_scale_factor)
	var/bloodloss = min(affecting?.reagents.total_volume * damage[damage_scale_type] * bleeding_scale_factor,
	                    affecting?.reagents.total_volume)
	if(bloodloss <= 0)
		return
	
	var/turf/T = get_turf(affecting)
	var/obj/effect/decal/cleanable/blood/drip/D = new(T)
	D.blood_DNA += affecting.dna
	D.basecolor = affecting.reagents.get_color()
	D.update_icon()
	affecting.reagents.remove_any(bloodloss)

// Used to count up the different kinds of injury when examining oneself.
/datum/wound/proc/get_examine_tag()
	return "injury" // That looks painful!

/datum/wound/proc/close(var/obj/item/bandage)
	closed = TRUE

/datum/wound/proc/get_surgery_steps()
	return surgery_steps





	



/*
Wound qualities


Organ Death -- Not really a wound, just the organ itself is dead.
*/