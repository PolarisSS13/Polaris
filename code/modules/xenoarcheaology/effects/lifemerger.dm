/datum/artifact_effect/extreme/lifemerger
	name = "lifemerger"
	effect_color = "#3b1f3b"
	effect_type = EFFECT_ENERGY
	var/list/active_beams
	var/merging = FALSE

/datum/artifact_effect/extreme/lifemerger/DoEffectTouch()
	mergelife()

/datum/artifact_effect/extreme/lifemerger/DoEffectPulse()
	mergelife()

/datum/artifact_effect/extreme/lifemerger/DoEffectAura()
	mergelife()

/datum/artifact_effect/extreme/lifemerger/proc/mergelife()
	var/atom/holder = get_master_holder()

	if(!holder)
		return

	var/turf/T = get_turf(holder)

	var/list/nearby_mobs = list()
	for(var/mob/living/L in view(world.view, T) - holder)
		if(L.stat != DEAD)
			nearby_mobs |= L

	if(nearby_mobs.len > 2)
		listclearnulls(active_beams)
		for(var/mob/living/L in nearby_mobs)
			if(L.stat == DEAD)
				continue
			if(!prob(5))
				continue
			var/beamtarget_exists = FALSE

			if(active_beams.len)
				for(var/datum/beam/Beam in active_beams)
					if(Beam.target == L)
						beamtarget_exists = TRUE
						break

			if(beamtarget_exists || GetAnomalySusceptibility(L) < 0.5)
				continue

			holder.visible_message(
				"<span class='danger'>A bright beam beam lashes out from [bicon(get_master_holder())] \the [get_master_holder()] at \the [L]!</span>")
			var/datum/beam/drain_beam = holder.Beam(L, icon_state = "medbeam", time = 3 SECONDS * nearby_mobs.len)
			active_beams |= drain_beam
		if(!merging)	// Don't add a ton of timers if this procs faster than 2 seconds, just average every 2.
			merging = TRUE
			addtimer(CALLBACK(src, .proc/averagelife), 2 SECONDS)

/datum/artifact_effect/extreme/lifemerger/proc/averagelife()
	listclearnulls(active_beams)	// Clear nulls from mobs leaving the range.
	if(active_beams.len >= 2)	// Work with remaining beams to find still-valid targets, if we still have 2 or more.
		var/list/remaining_mobs = list()
		var/brute_avg = 0
		var/burn_avg = 0
		var/oxy_avg = 0
		var/tox_avg = 0
		for(var/datum/beam/Beam in active_beams)	// Find remaining beams' targets and their damage values.
			if(isliving(Beam.target))
				remaining_mobs |= Beam.target
				var/mob/living/L = Beam.target
				brute_avg += L.getBruteLoss()
				burn_avg += L.getFireLoss()
				oxy_avg += L.getOxyLoss()
				tox_avg += L.getToxLoss()

		if(remaining_mobs.len)	// Average by the number of remaining mobs.
			brute_avg /= remaining_mobs.len
			burn_avg /= remaining_mobs.len
			oxy_avg /= remaining_mobs.len
			tox_avg /= remaining_mobs.len

		for(var/mob/living/L in remaining_mobs)	// Adjust brute, burn, oxy, and tox of remaining mobs to the average
			L.adjustBruteLoss(brute_avg - L.getBruteLoss())
			L.adjustFireLoss(burn_avg - L.getFireLoss())
			L.adjustOxyLoss(oxy_avg - L.getOxyLoss())
			L.adjustToxLoss(tox_avg - L.getToxLoss())

			L.add_modifier(/datum/modifier/berserk_exhaustion, remaining_mobs.len * 2 SECONDS)

		for(var/datum/beam/Beam in active_beams)	// Cull the beams.
			Beam.End()

		listclearnulls(active_beams)	// Cull the nulls.
	merging = FALSE	// We're done!
