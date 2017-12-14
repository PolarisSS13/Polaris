/datum/grab/normal/proc/attack_throat(var/obj/item/grab/G, var/obj/item/W, var/mob/living/carbon/human/user)
	var/mob/living/carbon/human/affecting = G.affecting

	if(user.a_intent != I_HURT)
		return 0 // Not trying to hurt them.

	if(!W.edge || !W.force || W.damtype != BRUTE)
		return 0 //unsuitable weapon
	user.visible_message("<span class='danger'>\The [user] begins to slit [affecting]'s throat with \the [W]!</span>")

	user.next_move = world.time + 20 //also should prevent user from triggering this repeatedly
	if(!do_after(user, 20, progress = 0))
		return 0
	if(!(G && G.affecting == affecting)) //check that we still have a grab
		return 0

	var/damage_mod = 1
	//presumably, if they are wearing a helmet that stops pressure effects, then it probably covers the throat as well
	var/obj/item/clothing/head/helmet = affecting.get_equipped_item(slot_head)
	if(istype(helmet) && (helmet.body_parts_covered & HEAD) && (helmet.flags & STOPPRESSUREDAMAGE))
		//we don't do an armor_check here because this is not an impact effect like a weapon swung with momentum, that either penetrates or glances off.
		damage_mod = 1.0 - (helmet.armor["melee"]/100)

	var/total_damage = 0
	for(var/i in 1 to 3)
		var/damage = min(W.force*1.5, 20)*damage_mod
		affecting.apply_damage(damage, W.damtype, BP_HEAD, 0, 0, used_weapon = W, W.sharp, W.edge)
		total_damage += damage


	if(total_damage)
		user.visible_message("<span class='danger'>\The [user] slit [affecting]'s throat open with \the [W]!</span>")

		if(W.hitsound)
			playsound(affecting.loc, W.hitsound, 50, 1, -1)

	G.last_action = world.time

	admin_attack_log(user, src, "Knifed their victim", "Was knifed", "knifed")
	return 1

/obj/item/organ/external/proc/jointlock(mob/living/carbon/human/target, mob/attacker)
	var/armor = target.run_armor_check(target, "melee")
	if(armor < 100)
		to_chat(target, "<span class='danger'>You feel extreme pain!</span>")

		var/max_halloss = round(target.species.total_health * 0.8 * ((100 - armor) / 100)) //up to 80% of passing out, further reduced by armour
		target.apply_effect(max_halloss, AGONY, armor)

/obj/item/organ/external/proc/inspect(mob/living/carbon/human/H, mob/user)

	var/obj/item/organ/external/E = src

	if(!E || E.is_stump())
		to_chat(user, "<span class='notice'>[H] is missing that bodypart.</span>")
		return

	user.visible_message("<span class='notice'>[user] starts inspecting [H]'s [E.name] carefully.</span>")
	if(!do_mob(user,H, 10))
		to_chat(user, "<span class='notice'>You must stand still to inspect [E] for wounds.</span>")
	else if(E.wounds.len)
		to_chat(user, "<span class='warning'>You find [E.get_wounds_desc()]</span>")
	else
		to_chat(user, "<span class='notice'>You find no visible wounds.</span>")

	to_chat(user, "<span class='notice'>Checking bones now...</span>")
	if(!do_mob(user, H, 20))
		to_chat(user, "<span class='notice'>You must stand still to feel [E] for fractures.</span>")
	else if(E.status & ORGAN_BROKEN)
		to_chat(user, "<span class='warning'>The [E.encased ? E.encased : "bone in the [E.name]"] moves slightly when you poke it!</span>")
		H.custom_pain("Your [E.name] hurts where it's poked.",40, affecting = E)
	else
		to_chat(user, "<span class='notice'>The [E.encased ? E.encased : "bones in the [E.name]"] seem to be fine.</span>")

	to_chat(user, "<span class='notice'>Checking skin now...</span>")
	if(!do_mob(user, H, 10))
		to_chat(user, "<span class='notice'>You must stand still to check [H]'s skin for abnormalities.</span>")
	else
		var/bad = 0
		if(H.getToxLoss() >= 40)
			to_chat(user, "<span class='warning'>[H] has an unhealthy skin discoloration.</span>")
			bad = 1
		if(H.getOxyLoss() >= 20)
			to_chat(user, "<span class='warning'>[H]'s skin is unusaly pale.</span>")
			bad = 1
		if(E.status & ORGAN_DEAD)
			to_chat(user, "<span class='warning'>[E] is decaying!</span>")
			bad = 1
		if(!bad)
			to_chat(user, "<span class='notice'>[H]'s skin is normal.</span>")
	return 1

