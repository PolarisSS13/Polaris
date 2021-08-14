
/*
 * Modifiers applied by Medical sources.
 */

/datum/modifier/bloodpump
	name = "external blood pumping"
	desc = "Your blood flows thanks to the wonderful power of science."

	on_created_text = "<span class='notice'>You feel alive.</span>"
	on_expired_text = "<span class='notice'>You feel.. less alive.</span>"
	stacks = MODIFIER_STACK_EXTEND

	pulse_set_level = PULSE_NORM

/datum/modifier/bloodpump/check_if_valid()
	..()
	if(holder.stat == DEAD)
		src.expire()

/datum/modifier/bloodpump_corpse
	name = "forced blood pumping"
	desc = "Your blood flows thanks to the wonderful power of science."

	on_created_text = "<span class='notice'>You feel alive.</span>"
	on_expired_text = "<span class='notice'>You feel.. less alive.</span>"
	stacks = MODIFIER_STACK_EXTEND

	pulse_set_level = PULSE_SLOW

/datum/modifier/bloodpump_corpse/check_if_valid()
	..()
	if(holder.stat != DEAD)
		src.expire()

/*
 * Modifiers caused by chemicals or organs specifically.
 */

/datum/modifier/cryogelled
	name = "cryogelled"
	desc = "Your body begins to freeze."
	mob_overlay_state = "chilled"

	on_created_text = "<span class='danger'>You feel like you're going to freeze! It's hard to move.</span>"
	on_expired_text = "<span class='warning'>You feel somewhat warmer and more mobile now.</span>"
	stacks = MODIFIER_STACK_ALLOWED

	slowdown = 0.1
	evasion = -5
	attack_speed_percent = 1.1
	disable_duration_percent = 1.05

/datum/modifier/clone_stabilizer
	name = "clone stabilized"
	desc = "Your body's regeneration is highly restricted."

	on_created_text = "<span class='danger'>You feel nauseous.</span>"
	on_expired_text = "<span class='warning'>You feel healthier.</span>"
	stacks = MODIFIER_STACK_EXTEND

	incoming_healing_percent = 0.1

/datum/modifier/risen_corpse
	name = "reanimated"
	desc = "Your body moves to the will of an unnatural force."

	on_created_text = "<span class='notice'>You feel alive.</span>"
	on_expired_text = "<span class='notice'>You feel.. less alive.</span>"
	stacks = MODIFIER_STACK_EXTEND

	pulse_set_level = PULSE_NORM

	slowdown = 0.2
	evasion = -10
	attack_speed_percent = 1.3
	disable_duration_percent = 1.5

	incoming_hal_damage_percent = 0.3	// A mechanically risen corpse is hard to bring down, but will go down hard.

/datum/modifier/risen_corpse/check_if_valid()
	..()
	if(holder.stat == DEAD)
		src.expire()

/datum/modifier/risen_corpse/tick()
	..()
	var/mob/living/carbon/human/H = holder
	if(istype(H))
		H.AdjustParalysis(-1)
		H.AdjustStunned(-1)
		H.AdjustWeakened(-1)
		H.add_chemical_effect(CE_PAINKILLER, 30)
/datum/modifier/mute
	name = "mute"
	desc = "You can't speak!"

	on_created_text = "<span class='notice'>You have no mouth, but you must scream.</span>"
	on_expired_text = "<span class='notice'>You can scream as much as you want, now.</span>"
	stacks = MODIFIER_STACK_EXTEND

	speech_mute = 1
