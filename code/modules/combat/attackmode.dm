//Similar to firemodes for guns, but for melee weapons, and has a wider range of possibilities.

/datum/attackmode
	var/name = "attack"
	var/name_short = null
	var/list/attack_verb = list("attacked")
	var/force = 10
	var/stagger = 0
	var/edge = 0
	var/sharp = 0
	var/attack_delay = 0
	var/attack_cooldown = 0
	var/icon = 'icons/mob/screen1_attackmodes.dmi'
	var/icon_state = null

/datum/attackmode/default //Most weapons will have this.
	name = "attack normally"
	name_short = "attack"

/datum/attackmode/New()
	if(!name_short)
		name_short = name

/datum/attackmode/material //Because material weapon force works weirdly, we need more variables to add.  Don't apply this datum to non-material weapons.
	var/force_divisor = 0.5
	var/thrown_force_divisor = 0.5

/datum/attackmode/material/default //Horrible but we need default stats...
	name = "attack normally"
	name_short = "attack"

//This is mostly used for the default attackmode datum.
/datum/attackmode/proc/copy_weapon_stats(var/obj/item/weapon/W)
	attack_verb = W.attack_verb.Copy()
	force = W.force
	stagger = W.stagger
	edge = W.edge
	sharp = W.sharp

/datum/attackmode/material/copy_weapon_stats(var/obj/item/weapon/material/W)
	..()
	force_divisor = W.force_divisor
	thrown_force_divisor = W.thrown_force_divisor

/obj/item/weapon
	var/attackmode_index = 1 //index of the currently selected mode
	var/list/attackmodes = list()
	var/datum/attackmode/current_attackmode = null

/obj/item/weapon/dropped(user)
	..()
	if(isliving(user))
		var/mob/living/L = user
		if(L.mind && L.hud_used)
			L.attackmode_display.update_icon()

/obj/item/weapon/pickup(user)
	..()
	if(isliving(user))
		var/mob/living/L = user
		if(L.mind && L.hud_used)
			spawn(0) //It takes some time for the item to actually get in our hands.  Otherwise the icon won't be updated properly.
				L.attackmode_display.update_icon()

//swap_hand() also calls update_icon on the button, inside code/modules/mob/living/carbon/carbon.dm.  DM complains if I put the override here.

/obj/item/weapon/New()
	. = ..()
	if(!attackmodes.len) //We're a normal weapon, with only one way of robusting someone.
		if(istype(src,/obj/item/weapon/material))
			current_attackmode = new /datum/attackmode/material/default(src)
		else
			current_attackmode = new /datum/attackmode/default(src)
		attackmodes += current_attackmode
		current_attackmode.copy_weapon_stats(src)
	else //We're so special that we can robust someone in more ways than one.
		if(istype(src,/obj/item/weapon/material))
			for(var/datum/attackmode/material/default/AM in attackmodes)
				AM.copy_weapon_stats(src)
		else
			for(var/datum/attackmode/default/AM in attackmodes)
				AM.copy_weapon_stats(src)
		current_attackmode = attackmodes[1]

//Cycles the attackmode of the weapon.
/obj/item/weapon/proc/switch_attackmode(user as mob)
	if(attackmodes.len == 1) //Just in case.
		user << "You can only attack with \the [src.name] in one way."
		return
	attackmode_index++
	if(attackmode_index > attackmodes.len)
		attackmode_index = 1


	current_attackmode = attackmodes[attackmode_index]
	apply_attackmode_to_weapon(user)
	return

/obj/item/weapon/proc/get_number_of_attackmodes()
	if(!attackmodes)
		return 0
	return attackmodes.len

//The reason we have a proc call another proc is so that if a weapon needs special checks before switching (like fireaxes being held in two hands),
//we can check inside this proc and then call switch_attackmode() when all the special checks pass.
/obj/item/weapon/proc/handle_switch_attackmode(user as mob)
	switch_attackmode(user)

//Copies the properities of the datum to the weapon.
/obj/item/weapon/proc/apply_attackmode_to_weapon(user as mob)
	if(!current_attackmode)
		return

	var/datum/attackmode/AM = current_attackmode
	attack_verb = AM.attack_verb.Copy()
	force = AM.force
	sharp = AM.sharp
	edge = AM.edge
	stagger = AM.stagger
	if(user)
		user << "You will now [AM.name_short] with \the [src.name]."

//For whatever reason, stuff made from Zuhayr's material stuff doesn't use the force variable like everything else.
//So we gotta snowflake around that.
/obj/item/weapon/material/apply_attackmode_to_weapon(user as mob)
	..()
	var/datum/attackmode/material/AM = current_attackmode
	force_divisor = AM.force_divisor
	thrown_force_divisor = AM.thrown_force_divisor
	update_force()

/datum/attackmode/crush
	name = "crush"
	name_short = "crush"
	stagger = 1
	force = 5
	attack_verb = list("crushed", "smashed")

/datum/attackmode/destroy //debugging only!
	name = "destroy"
	force = 250
	attack_verb = list("destroyed", "wrecked")

/obj/item/weapon/multi_weapon
	name = "multi-weapon"
	desc = "For debugging only!"
	icon = 'icons/obj/items.dmi'
	icon_state = "ppickaxe"
	force = 15
	attackmodes = list(
		new /datum/attackmode/default,
		new /datum/attackmode/crush,
		new /datum/attackmode/destroy
		)