/datum/artifact_effect/extreme/spines
	name = "spines"
	effect_color = "#8db6b2"
	effect_type = EFFECT_ORGANIC

	var/obj/item/projectile_type = /obj/item/projectile/bullet/thorn


/datum/artifact_effect/extreme/spines/New()
	. = ..()
	effect = pick(EFFECT_TOUCH, EFFECT_PULSE)


/datum/artifact_effect/extreme/spines/proc/shoot(var/list/exempt = list())
	var/atom/A = get_master_holder()
	A.visible_message("<span class='danger'>\The [get_master_holder()] fires spines wildly in all directions!</span>")
	for(var/i in rand(1, round(chargelevel / 3)))
		var/atom/target = pick(oview(world.view, get_turf(get_master_holder())))

		if(target in exempt)
			continue

		var/obj/item/projectile/P = new projectile_type(get_turf(get_master_holder()))
		P.launch_projectile(target, BP_TORSO, get_master_holder())
		chargelevel -= 3


/datum/artifact_effect/extreme/spines/DoEffectTouch(mob/living/user)
	if(chargelevel < 3)
		return
	shoot(list(user))


/datum/artifact_effect/extreme/spines/DoEffectPulse()
	if(chargelevel < 3)
		return
	shoot()

/datum/artifact_effect/extreme/spines/spore
	name = "bombarding"

	projectile_type = /obj/item/projectile/arc/spore

/datum/artifact_effect/extreme/spines/spore/shoot(var/list/exempt = list())
	var/atom/A = get_master_holder()
	A.visible_message("<span class='danger'>\The [get_master_holder()] launches spores wildly in all directions!</span>")
	for(var/i in rand(1, round(chargelevel / 3)))
		var/atom/target = check_trajectory(pick(oview(world.view, get_turf(get_master_holder()))), get_master_holder(), PASSTABLE)

		if(target in exempt)
			continue

		var/obj/item/projectile/P = new projectile_type(get_turf(get_master_holder()))
		P.launch_projectile(target, BP_TORSO, get_master_holder())
		chargelevel -= 3
