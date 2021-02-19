/obj/machinery/artifact/predefined/hungry_statue
	name = "alien artifact"
	desc = "A large alien device."

	artifact_master = /datum/artifact_master/hungry_statue

	predefined_icon_num = 14

/datum/artifact_master/hungry_statue
	make_effects = list(
		/datum/artifact_effect/animate_anomaly,
		/datum/artifact_effect/vampire
	)
