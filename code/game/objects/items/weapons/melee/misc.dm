/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

	suicide_act(mob/user)
		var/datum/gender/T = gender_datums[user.get_visible_gender()]
		user.visible_message(span("danger", "\The [user] [T.is] strangling [T.himself] with \the [src]! It looks like [T.he] [T.is] trying to commit suicide."), span("danger", "You start to strangle yourself with \the [src]!"), span("danger", "You hear the sound of someone choking!"))
		return (OXYLOSS)

/obj/item/weapon/melee/cursedblade
	name = "crystal blade"
	desc = "The red crystal blade's polished surface glints in the light, giving off a faint glow."
	icon_state = "soulblade"
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 30
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	can_speak = 1
	var/list/voice_mobs = list() //The curse of the sword is that it has someone trapped inside.


/obj/item/weapon/melee/cursedblade/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/melee/cursedblade/proc/ghost_inhabit(var/mob/candidate)
	if(!isobserver(candidate))
		return
	//Handle moving the ghost into the new shell.
	announce_ghost_joinleave(candidate, 0, "They are occupying a cursed sword now.")
	var/mob/living/voice/new_voice = new /mob/living/voice(src) 	//Make the voice mob the ghost is going to be.
	new_voice.transfer_identity(candidate) 	//Now make the voice mob load from the ghost's active character in preferences.
	new_voice.mind = candidate.mind			//Transfer the mind, if any.
	new_voice.ckey = candidate.ckey			//Finally, bring the client over.
	new_voice.name = "cursed sword"			//Cursed swords shouldn't be known characters.
	new_voice.real_name = "cursed sword"
	voice_mobs.Add(new_voice)
	listening_objects |= src


/obj/item/weapon/melee/unathiknife
	name = "duelling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")
	w_class = ITEMSIZE_SMALL
	force = 12
	throwforce = 15
	var/hits = 0

/obj/item/weapon/melee/unathiknife/attack(mob/M as mob, mob/user as mob)
	if(hits > 0)
		return
	var/obj/item/I = user.get_inactive_hand()
	if(istype(I, /obj/item/weapon/melee/unathiknife))
		hits ++
		var/obj/item/weapon/W = I
		W.attack(M, user)
		W.afterattack(M, user)
	..()

/obj/item/weapon/melee/unathiknife/afterattack(mob/M as mob, mob/user as mob)
	hits = initial(hits)
	..()

/obj/item/weapon/melee/unathiknife/is_knife()
	return TRUE