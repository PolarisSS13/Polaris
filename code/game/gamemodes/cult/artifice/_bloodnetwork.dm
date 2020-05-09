
GLOBAL_LIST_EMPTY(blood_networks)

/hook/startup/proc/globalBloodnet()
	var/datum/bloodnet/globalnet = new()
	globalnet.max_volume = 3000
	globalnet.current_volume = 200

	globalnet.assign(CULT_BLOODNETWORK_GLOBAL)

/datum/bloodnet
	var/name = "blood network"
	var/current_volume = 0 	// Amount of 'blood' stored in this network.
	var/max_volume = 200	// Amount of 'blood' that can be stored in this network. 1 unit = 1 bloodpoint.

	var/network_tag	// The variable this network will be associated with in the global blood network list.

	var/weakref/ownerMindRef

/datum/bloodnet/Destroy()
	ownerMindRef = null
	unassign()

	STOP_PROCESSING(SSobj,src)

	..()

// Assigning itself to the blood network list, and processing list.
/datum/bloodnet/proc/assign(var/key)
	network_tag = key

	GLOB.blood_networks[network_tag] = src

/datum/bloodnet/proc/unassign()
	GLOB.blood_networks[network_tag] = null
	GLOB.blood_networks -= network_tag

/datum/bloodnet/proc/set_ref(var/datum/mind/M)
	if(M)
		ownerMindRef = weakref(M)

		START_PROCESSING(SSobj, src)

/datum/bloodnet/proc/adjustBlood(var/amount = 0, var/ignore_failure = TRUE)
	var/adjusted_blood = current_volume + amount

	if(amount < 0 && adjusted_blood < 0 && ignore_failure)	// We can't afford it, and we're told to ignore failure consequences.
		return CULT_BLOODNETWORK_EMPTIED

	current_volume = between(0, current_volume + amount, max_volume)

	if((adjusted_blood < 0) && !ignore_failure)	// Do we have consequences?
		return CULT_BLOODNETWORK_EXHAUSTED

	else if(adjusted_blood > max_volume)
		return CULT_BLOODNETWORK_OVERFLOW

	return CULT_BLOODNETWORK_SHIFT

// Sacrifice checks.

/datum/bloodnet/proc/valid_sacrifice(var/mob/living/target, var/safety = TRUE)
	if(!target)
		return FALSE

	if(current_volume >= max_volume)	// Don't be greedy.
		return FALSE

	if(istype(target, /mob/living/simple_mob/construct))	// Not a valid sacrifice, they're unliving.
		return FALSE

	if(target.stat >= UNCONSCIOUS && safety)
		return FALSE

	if(iscultist(target))
		if(target.getOxyLoss() > 20 || target.getToxLoss() > 20)
			return FALSE

		if(ishuman(target))
			var/mob/living/carbon/human/H = target

			if(!H.isSynthetic())
				if(H.internal_organs_by_name[O_HEART])
					if(H.vessel.total_volume < H.species.blood_volume * 0.9)
						return FALSE
				else
					if(H.getFireLoss() > 20)
						return FALSE

	else if(safety && !istype(target,/mob/living/simple_mob))
		return FALSE

	else if(safety && target.faction == "cult")
		return FALSE

	return TRUE

/datum/bloodnet/proc/sacrifice(var/mob/living/target, var/multiplier = 1)
	if(!target)
		return

	if(target.isSynthetic() && !ishuman(target))
		target.adjustFireLoss(2 * multiplier)

	else
		if(ishuman(target))
			var/mob/living/carbon/human/H = target

			if(H.isSynthetic())
				H.adjustToxLoss(2 * multiplier)
			else if(H.internal_organs_by_name[O_HEART])
				H.vessel.remove_reagent("blood", 1 * multiplier)
			else
				H.adjustFireLoss(2 * multiplier)
		else
			target.adjustBruteLoss(2 * multiplier)

	adjustBlood(1 * multiplier)

// Checks if we can take the entirety of the queried blood volume.
// Considering using adjustBlood directly can allow for spells / effects using it to backfire, it's safer to check this.

/datum/bloodnet/proc/check_adjustBlood(var/amount = 0)
	if(current_volume + amount >= 0)
		return TRUE

	return FALSE

// Procs to get the blood net from a key reference, or from a mob directly.
/proc/getBloodnetFromKey(var/key = null)
	if(isnull(key))
		return GLOB.blood_networks[CULT_BLOODNETWORK_GLOBAL]

	if(!(key in GLOB.blood_networks))	// No network associated, sorry!
		return FALSE

/mob/proc/getBloodnet()
	return FALSE

/mob/living/getBloodnet()
	if((!client || !ckey) && !(mob_class & MOB_CLASS_DEMONIC))
		return ..()

	if(!client && (mob_class & MOB_CLASS_DEMONIC))
		return GLOB.blood_networks[CULT_BLOODNETWORK_GLOBAL]

	if(!iscultist(src) && !istype(src, /mob/living/simple_mob/construct))	// No network, sorry!
		return FALSE

	if(!(ckey in GLOB.blood_networks))
		var/datum/bloodnet/newnet = new()
		newnet.assign(ckey)
		newnet.set_ref(mind)

	return GLOB.blood_networks[ckey]

// Processing the personal bloodnets.
/datum/bloodnet/process()
	if(ownerMindRef)
		var/datum/mind/M = ownerMindRef.resolve()

		var/mob/living/L = M.current

		if(istype(L, /mob/living/simple_mob/construct))	// The legions of the damned have already paid their blood. They have a refilling reserve.
			adjustBlood(5)
