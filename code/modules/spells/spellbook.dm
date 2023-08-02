/obj/item/spellbook
	name = "nanomachine hive" //"Wizard" may be long deprecated but since these wizard-based items still show up on rare occasion for gimmicks...
	desc = "A secure delivery system for highly experimental nanomachine swarms capable of rapidly installing (often illegal) biotech augments to those both educated in its usage, and reckness enough to try."
	icon = 'icons/obj/wizard.dmi'
	icon_state ="hive"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	var/uses = 5
	var/temp = null
	var/max_uses = 5
	var/op = 1

/obj/item/spellbook/attack_self(mob/user = usr)
	if(!user)
		return
	if((user.mind && !wizards.is_antagonist(user.mind)))
		to_chat(usr, "<span class='warning'>You stare at the hive but cannot make sense of the control interface!</span>")
		return

	user.set_machine(src)
	var/dat
	if(temp)
		dat = "[temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else

		dat = {"<B>Augmentation Library:</B><BR>
			Programmable Nanomachine Uses Remaining: [uses]<BR>
			<HR>
			<B>Deploy which augment:</B><BR>
			<I>The number after the augment name is the cooldown time.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=magicmissile'>Magic Missile</A> (10)<BR>
			<I>This augment fires several, slow moving, magic projectiles at nearby targets. If they hit a target, it is paralyzed and takes minor damage.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=fireball'>Fireball</A> (10)<BR>
			<I>This augment fires a fireball in the direction you're facing and does not require special attire. Be careful not to fire it at people that are standing next to you.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=disabletech'>Disable Technology</A> (60)<BR>
			<I>This augment disables all weapons, cameras and most other technology in range.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=smoke'>Smoke</A> (10)<BR>
			<I>This augment spawns a cloud of choking smoke at your location and does not require special attire.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=blind'>Blind</A> (30)<BR>
			<I>This augment temporarly blinds a single person and does not require special attire.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=subjugation'>Subjugation</A> (30)<BR>
			<I>This augment temporarily subjugates a target's mind and does not require special attire.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=forcewall'>Forcewall</A> (10)<BR>
			<I>This augment creates an unbreakable wall that lasts for 30 seconds and does not need special attire.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=blink'>Blink</A> (2)<BR>
			<I>This augment randomly teleports you a short distance. Useful for evasion or getting into areas if you have patience.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=teleport'>Teleport</A> (60)<BR>
			<I>This augment teleports you to a type of area of your selection. Very useful if you are in danger, but has a decent cooldown, and is unpredictable.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=mutate'>Mutate</A> (60)<BR>
			<I>This augment causes you to turn into a hulk and gain telekinesis for a short while.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=etherealjaunt'>Ethereal Jaunt</A> (60)<BR>
			<I>This augment creates your ethereal form, temporarily making you invisible and able to pass through walls.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=knock'>Knock</A> (10)<BR>
			<I>This augment opens nearby doors and does not require special attire.</I><BR>
			<A href='byond://?src=\ref[src];spell_choice=noclothes'>Remove Clothes Requirement</A> <b>Warning: this takes away 2 augment choices.</b><BR>
			<HR>
			<B>Artefacts:</B><BR>
			Powerful items harnessing powerful nanomachines. Constructing one will count towards your maximum number of augments.<BR>
			It is recommended that only experienced wizards attempt to wield such artefacts.<BR>
			<HR>
			<A href='byond://?src=\ref[src];spell_choice=mentalfocus'>Mental Focus</A><BR>
			<I>An artefact that channels the will of the user into destructive bolts of force.</I><BR>
			<HR>
			<A href='byond://?src=\ref[src];spell_choice=soulstone'>Six Soul Stone Shards and the augment Artificer</A><BR>
			<I>Soul Stone Shards are ancient tools capable of capturing and harnessing the spirits of the dead and dying. The augment Artificer allows you to create arcane machines for the captured souls to pilot.</I><BR>
			<HR>
			<A href='byond://?src=\ref[src];spell_choice=armor'>Mastercrafted Armor Set</A><BR>
			<I>An artefact suit of armor that allows you to use augments while providing more protection against attacks and the void of space.</I><BR>
			<HR>
			<A href='byond://?src=\ref[src];spell_choice=staffanimation'>Staff of Animation</A><BR>
			<I>An arcane staff capable of shooting bolts of eldritch energy which cause inanimate objects to come to life. This magic doesn't affect machines.</I><BR>
			<HR>
			<A href='byond://?src=\ref[src];spell_choice=scrying'>Scrying Orb</A><BR>
			<I>An incandescent orb of crackling energy, using it will allow you to ghost while alive, allowing you to spy upon the station with ease. In addition, buying it will permanently grant you x-ray vision.</I><BR>
			<HR>"}
		// END AUTOFIX
		if(op)
			dat += "<A href='byond://?src=\ref[src];spell_choice=rememorize'>Re-program nanomachines</A><BR>"
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/spellbook/Topic(href, href_list)
	..()
	var/mob/living/carbon/human/H = usr

	if(H.stat || H.restrained())
		return
	if(!istype(H, /mob/living/carbon/human))
		return 1

	if(H.mind.special_role == "apprentice")
		temp = "You don't understand the usage of nanomachine hives well enough to risk messing with it."
		return

	if(loc == H || (in_range(src, H) && istype(loc, /turf)))
		H.set_machine(src)
		if(href_list["spell_choice"])
			if(href_list["spell_choice"] == "rememorize")
				var/area/wizard_station/A = locate()
				if(usr in A.contents)
					uses = max_uses
					H.spellremove()
					temp = "All augments have been removed. You may now memorize a new set of augments."
					feedback_add_details("wizard_spell_learned","UM") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
				else
					temp = "You may only re-program augments whilst located inside the wizard sanctuary."
			else if(uses >= 1 && max_uses >=1)
				if(href_list["spell_choice"] == "noclothes")
					if(uses < 2)
						return
				uses--
			/*
			*/
				var/list/available_spells = list(magicmissile = "Magic Missile", fireball = "Fireball", disabletech = "Disable Tech", smoke = "Smoke", blind = "Blind", subjugation = "Subjugation", mindswap = "Mind Transfer", forcewall = "Forcewall", blink = "Blink", teleport = "Teleport", mutate = "Mutate", etherealjaunt = "Ethereal Jaunt", knock = "Knock", horseman = "Curse of the Horseman", staffchange = "Staff of Change", mentalfocus = "Mental Focus", soulstone = "Six Soul Stone Shards and the augment Artificer", armor = "Mastercrafted Armor Set", staffanimate = "Staff of Animation", noclothes = "No Clothes")
				var/already_knows = 0
				for(var/spell/aspell in H.spell_list)
					if(available_spells[href_list["spell_choice"]] == initial(aspell.name))
						already_knows = 1
						if(!aspell.can_improve())
							temp = "This augment cannot be improved further."
							uses++
							break
						else
							if(aspell.can_improve("speed") && aspell.can_improve("power"))
								switch(alert(src, "Do you want to upgrade this augment's speed or power?", "Select Upgrade", "Speed", "Power", "Cancel"))
									if("Speed")
										temp = aspell.quicken_spell()
									if("Power")
										temp = aspell.empower_spell()
									else
										uses++
										break
							else if (aspell.can_improve("speed"))
								temp = aspell.quicken_spell()
							else if (aspell.can_improve("power"))
								temp = aspell.empower_spell()
			/*
			*/
				if(!already_knows)
					switch(href_list["spell_choice"])
						if("noclothes")
							feedback_add_details("wizard_spell_learned","NC")
							H.add_spell(new/spell/noclothes)
							temp = "This allows you to use your augments without specialist garb, truely you are the nano-wizardest."
							uses--
						if("magicmissile")
							feedback_add_details("wizard_spell_learned","MM") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/targeted/projectile/magic_missile)
							temp = "You have installed magic missile."
						if("fireball")
							feedback_add_details("wizard_spell_learned","FB") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/targeted/projectile/dumbfire/fireball)
							temp = "You have installed fireball."
						if("disabletech")
							feedback_add_details("wizard_spell_learned","DT") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/aoe_turf/disable_tech)
							temp = "You have installed disable technology."
						if("smoke")
							feedback_add_details("wizard_spell_learned","SM") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/aoe_turf/smoke)
							temp = "You have installed smoke."
						if("blind")
							feedback_add_details("wizard_spell_learned","BD") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/targeted/genetic/blind)
							temp = "You have installed blind."
						if("subjugation")
							feedback_add_details("wizard_spell_learned","SJ") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/targeted/subjugation)
							temp = "You have installed subjugate."
//						if("mindswap")
//							feedback_add_details("wizard_spell_learned","MT") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
//							H.add_spell(new/spell/targeted/mind_transfer)
//							temp = "You have learned mindswap."
						if("forcewall")
							feedback_add_details("wizard_spell_learned","FW") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/aoe_turf/conjure/forcewall)
							temp = "You have installed forcewall."
						if("blink")
							feedback_add_details("wizard_spell_learned","BL") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/aoe_turf/blink)
							temp = "You have installed blink."
						if("teleport")
							feedback_add_details("wizard_spell_learned","TP") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/area_teleport)
							temp = "You have installed teleport."
						if("mutate")
							feedback_add_details("wizard_spell_learned","MU") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/targeted/genetic/mutate)
							temp = "You have installed mutate."
						if("etherealjaunt")
							feedback_add_details("wizard_spell_learned","EJ") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/targeted/ethereal_jaunt)
							temp = "You have installed ethereal jaunt."
						if("knock")
							feedback_add_details("wizard_spell_learned","KN") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							H.add_spell(new/spell/aoe_turf/knock)
							temp = "You have installed knock."
//						if("horseman")
//							feedback_add_details("wizard_spell_learned","HH") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
//							H.add_spell(new/spell/targeted/equip_item/horsemask)
//							temp = "You have learned curse of the horseman."
						if("mentalfocus")
							feedback_add_details("wizard_spell_learned","MF") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							new /obj/item/gun/energy/staff/focus(get_turf(H))
							temp = "An artefact that channels the will of the user into destructive bolts of force."
							max_uses--
						if("soulstone")
							feedback_add_details("wizard_spell_learned","SS") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							new /obj/item/storage/belt/soulstone/full(get_turf(H))
							H.add_spell(new/spell/aoe_turf/conjure/construct)
							temp = "You have purchased a belt full of soulstones and have learned the artificer augment."
							max_uses--
						if("armor")
							feedback_add_details("wizard_spell_learned","HS") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							new /obj/item/clothing/shoes/sandal(get_turf(H)) //In case they've lost them.
							new /obj/item/clothing/gloves/purple(get_turf(H))//To complete the outfit
							new /obj/item/clothing/suit/space/void/wizard(get_turf(H))
							new /obj/item/clothing/head/helmet/space/void/wizard(get_turf(H))
							temp = "You have purchased a suit of wizard armor."
							max_uses--
						if("scrying")
							feedback_add_details("wizard_spell_learned","SO") //please do not change the abbreviation to keep data processing consistent. Add a unique id to any new spells
							new /obj/item/scrying(get_turf(H))
							if (!(XRAY in H.mutations))
								H.mutations.Add(XRAY)
								H.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
								H.see_in_dark = 8
								H.see_invisible = SEE_INVISIBLE_LEVEL_TWO
								to_chat(H, "<span class='notice'>The walls suddenly disappear.</span>")
							temp = "You have purchased a scrying orb, and gained x-ray vision."
							max_uses--
		else
			if(href_list["temp"])
				temp = null
		attack_self()

	return

//Single Use Spellbooks//

/obj/item/spellbook/oneuse
	var/spell = /spell/targeted/projectile/magic_missile //just a placeholder to avoid runtimes if someone spawned the generic
	var/spellname = ""
	var/used = 0
	name = "unstable nanomachine hive: "
	uses = 1
	max_uses = 1
	desc = "A secure delivery system for highly experimental nanomachine swarms capable of rapidly installing (often illegal) biotech augments to those both educated in its usage, and reckness enough to try. Insert hand when ready."

/obj/item/spellbook/oneuse/Initialize()
	. = ..()
	name += spellname
	icon_state = "hive[spellname]"

/obj/item/spellbook/oneuse/attack_self(mob/user as mob)
	var/spell/S = new spell(user)
	for(var/spell/knownspell in user.spell_list)
		if(knownspell.type == S.type)
			if(user.mind)
				// TODO: Update to new antagonist system.
				if(user.mind.special_role == "apprentice" || user.mind.special_role == "Wizard")
					to_chat(user, "<span class='notice'>You're already equipped with augments beyond what this small hive can provide.</span>")
				else
					to_chat(user, "<span class='notice'>You've already applied the augment from this hive, the nanomachines remain dormant.</span>")
			return
	if(used)
		recoil(user)
	else
		user.add_spell(S)
		to_chat(user, "<span class='notice'>You place your hand in the hive's receptacle and feel an alien presence course through your body. Once the stinging subsides, you realise your body is capable of something new. You can now [spellname]!</span>")
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[user.real_name] ([user.ckey]) learned the spell [spellname] ([S]).</font>")
		onlearned(user)

/obj/item/spellbook/oneuse/proc/recoil(mob/user as mob)
	playsound(src, 'sound/effects/refill.ogg', 50, 1)
	user.visible_message("<span class='warning'>[src] rattles uncontrollably!</span>")

/obj/item/spellbook/oneuse/proc/onlearned(mob/user as mob)
	playsound(src, 'sound/effects/hypospray.ogg', 50, 1)
	used = 1
	user.visible_message("<span class='caution'>[src] lights up, vibrating softly for a moment!</span>")

/obj/item/spellbook/oneuse/attackby()
	return

/obj/item/spellbook/oneuse/fireball
	spell = /spell/targeted/projectile/dumbfire/fireball
	spellname = "superheat matter"

/obj/item/spellbook/oneuse/fireball/recoil(mob/user as mob)
	..()
	explosion(user.loc, -1, 0, 2, 3, 0)
	qdel(src)

/obj/item/spellbook/oneuse/smoke
	spell = /spell/aoe_turf/smoke
	spellname = "emit smoke"

/obj/item/spellbook/oneuse/smoke/recoil(mob/living/user as mob)
	..()
	to_chat(user, "<span class='caution'>Your stomach lurches, you feel like you haven't eaten in days...</span>")
	if(user.nutrition)
		user.adjust_nutrition(-200)

/obj/item/spellbook/oneuse/blind
	spell = /spell/targeted/genetic/blind
	spellname = "ocular disruption"

/obj/item/spellbook/oneuse/blind/recoil(mob/user as mob)
	..()
	to_chat(user, "<span class='warning'>You go blind!</span>")
	user.Blind(10)

/obj/item/spellbook/oneuse/mindswap
	spell = /spell/targeted/mind_transfer
	spellname = "neural replication"
	var/mob/stored_swap = null //Used in used book recoils to store an identity for mindswaps

/obj/item/spellbook/oneuse/mindswap/onlearned()
	spellname = pick("superheat matter","emit smoke","ocular disruption","restriction field","manipulate lock","horse","charging")
	icon_state = "hive[spellname]"
	name = "spellbook of [spellname]" //Note, desc doesn't change by design
	..()

/obj/item/spellbook/oneuse/mindswap/recoil(mob/user as mob)
	..()
	if(stored_swap in dead_mob_list)
		stored_swap = null
	if(!stored_swap)
		stored_swap = user
		to_chat(user, "<span class='warning'>For a moment you feel like you don't even know who you are anymore.</span>")
		return
	if(stored_swap == user)
		to_chat(user, "<span class='notice'>You insert your hand into the nanomachine hive, but it doesn't seem to do anything more for you...</span>")
		return

	if(user.mind.special_verbs.len)
		for(var/V in user.mind.special_verbs)
			user.verbs -= V

	if(stored_swap.mind.special_verbs.len)
		for(var/V in stored_swap.mind.special_verbs)
			stored_swap.verbs -= V

	var/mob/observer/dead/ghost = stored_swap.ghostize(0)
	ghost.spell_list = stored_swap.spell_list

	user.mind.transfer_to(stored_swap)
	stored_swap.spell_list = user.spell_list

	if(stored_swap.mind.special_verbs.len)
		for(var/V in user.mind.special_verbs)
			user.verbs += V

	ghost.mind.transfer_to(user)
	user.key = ghost.key
	user.spell_list = ghost.spell_list

	if(user.mind.special_verbs.len)
		for(var/V in user.mind.special_verbs)
			user.verbs += V

	to_chat(stored_swap, "<span class='warning'>You're suddenly somewhere else... and someone else?!</span>")
	to_chat(user, "<span class='warning'>Suddenly you're staring at [src] again... where are you, who are you?!</span>")
	stored_swap = null

/obj/item/spellbook/oneuse/forcewall
	spell = /spell/aoe_turf/conjure/forcewall
	spellname = "restriction field"

/obj/item/spellbook/oneuse/forcewall/recoil(mob/user as mob)
	..()
	to_chat(user, "<span class='warning'>You suddenly feel very solid!</span>")
	var/obj/structure/closet/statue/S = new /obj/structure/closet/statue(user.loc, user)
	S.timer = 30
	user.drop_item()


/obj/item/spellbook/oneuse/knock
	spell = /spell/aoe_turf/knock
	spellname = "manipulate lock"

/obj/item/spellbook/oneuse/knock/recoil(mob/user as mob)
	..()
	to_chat(user, "<span class='warning'>Your limb joints go slack!</span>")
	user.Weaken(20)

/obj/item/spellbook/oneuse/horsemask
	spell = /spell/targeted/equip_item/horsemask
	spellname = "horse"

/obj/item/spellbook/oneuse/horsemask/recoil(mob/living/carbon/user as mob)
	if(istype(user, /mob/living/carbon/human))
		to_chat(user, "<font size='15' color='red'><b>HOR-SIE HAS RISEN!</b></font>")
		var/obj/item/clothing/mask/costume/horsehead/magichead = new /obj/item/clothing/mask/costume/horsehead
		magichead.canremove = 0		//curses!
		magichead.flags_inv = null	//so you can still see their face
		magichead.voicechange = 1	//NEEEEIIGHH
		user.drop_from_inventory(user.wear_mask)
		user.equip_to_slot_if_possible(magichead, slot_wear_mask, 1, 1)
		qdel(src)
	else
		to_chat(user, "<span class='notice'>I say thee neigh!</span>")

/obj/item/spellbook/oneuse/charge
	spell = /spell/aoe_turf/charge
	spellname = "charging"

/obj/item/spellbook/oneuse/charge/recoil(mob/user as mob)
	..()
	to_chat(user, "<span class='warning'>[src] suddenly shorts out!</span>")
	empulse(src, 1, 1, 1, 1)
