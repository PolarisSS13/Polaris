// It do the succ
/datum/artifact_effect/extreme/singularity
	name = "singularity"
	var/pull_range = 7
	var/pull_power = STAGE_THREE

/datum/artifact_effect/extreme/singularity/New()
	..()
	effect = pick(EFFECT_PULSE)
	effect_type = pick(EFFECT_ENERGY, EFFECT_BLUESPACE, EFFECT_PSIONIC)
	pull_range = 7 + rand(-2, 2)
	pull_power = rand(STAGE_ONE, STAGE_FOUR)

/datum/artifact_effect/extreme/singularity/DoEffectPulse(atom/holder)
	for(var/atom/A in range(pull_range, src))
		A.singularity_pull(src, pull_power)
