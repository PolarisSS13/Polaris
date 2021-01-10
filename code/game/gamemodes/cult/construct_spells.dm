//cast_method flags, needs to be up to date with Technomancer's. They were, for some reason, not working outside it.
#define CAST_USE		1	// Clicking the spell in your hand.
#define CAST_MELEE		2	// Clicking an atom in melee range.
#define CAST_RANGED		4	// Clicking an atom beyond melee range.
#define CAST_THROW		8	// Throwing the spell and hitting an atom.
#define CAST_COMBINE	16	// Clicking another spell with this spell.
#define CAST_INNATE		32	// Activates upon verb usage, used for mobs without hands.

//Aspects
#define ASPECT_FIRE			"fire" 		//Damage over time and raising body-temp.  Firesuits protect from this.
#define ASPECT_FROST		"frost"		//Slows down the affected, also involves imbedding with icicles.  Winter coats protect from this.
#define ASPECT_SHOCK		"shock"		//Energy-expensive, usually stuns.  Insulated armor protects from this.
#define ASPECT_AIR			"air"		//Mostly involves manipulation of atmos, useless in a vacuum.  Magboots protect from this.
#define ASPECT_FORCE		"force" 	//Manipulates gravity to push things away or towards a location.
#define ASPECT_TELE			"tele"		//Teleportation of self, other objects, or other people.
#define ASPECT_DARK			"dark"		//Makes all those photons vanish using magic-- WITH SCIENCE.  Used for sneaky stuff.
#define ASPECT_LIGHT		"light"		//The opposite of dark, usually blinds, makes holo-illusions, or makes laser lightshows.
#define ASPECT_BIOMED		"biomed"	//Mainly concerned with healing and restoration.
#define ASPECT_EMP			"emp"		//Unused now.
#define ASPECT_UNSTABLE		"unstable"	//Heavily RNG-based, causes instability to the victim.
#define ASPECT_CHROMATIC	"chromatic"	//Used to combine with other spells.
#define ASPECT_UNHOLY		"unholy"	//Involves the dead, blood, and most things against divine beings.

//////////////////////////////Construct Spells/////////////////////////

proc/findNullRod(var/atom/target)
	if(istype(target,/obj/item/weapon/nullrod))
		return 1
	else if(target.contents)
		for(var/atom/A in target.contents)
			if(findNullRod(A))
				return 1
	return 0

/spell/aoe_turf/conjure/construct
	name = "Artificer"
	desc = "This spell conjures a construct which may be controlled by Shades"

	school = "conjuration"
	charge_max = 600
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/constructshell)

	hud_state = "artificer"

/spell/aoe_turf/conjure/construct/lesser
	charge_max = 1800
	summon_type = list(/obj/structure/constructshell/cult)
	hud_state = "const_shell"
	override_base = "const"

/spell/aoe_turf/conjure/floor
	name = "Floor Construction"
	desc = "This spell constructs a cult floor"

	charge_max = 20
	spell_flags = Z2NOCAST | CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/turf/simulated/floor/cult)

	hud_state = "const_floor"

/spell/aoe_turf/conjure/floor/conjure_animation(var/atom/movable/overlay/animation, var/turf/target)
	animation.icon_state = "cultfloor"
	flick("cultfloor",animation)
	spawn(10)
		qdel(animation)

/spell/aoe_turf/conjure/wall
	name = "Lesser Construction"
	desc = "This spell constructs a cult wall"

	charge_max = 100
	spell_flags = Z2NOCAST | CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/turf/simulated/wall/cult)

	hud_state = "const_wall"

/spell/aoe_turf/conjure/wall/conjure_animation(var/atom/movable/overlay/animation, var/turf/target)
	animation.icon_state = "cultwall"
	flick("cultwall",animation)
	spawn(10)
		qdel(animation)

/spell/aoe_turf/conjure/wall/reinforced
	name = "Greater Construction"
	desc = "This spell constructs a reinforced metal wall"

	charge_max = 300
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	cast_delay = 50

	summon_type = list(/turf/simulated/wall/r_wall)

/spell/aoe_turf/conjure/soulstone
	name = "Summon Soulstone"
	desc = "This spell reaches into Nar-Sie's realm, summoning one of the legendary fragments across time and space"

	charge_max = 3000
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/item/device/soulstone/cult)

	hud_state = "const_stone"
	override_base = "const"

/spell/aoe_turf/conjure/pylon
	name = "Red Pylon"
	desc = "This spell conjures a fragile crystal from Nar-Sie's realm. Makes for a convenient light source."

	charge_max = 200
	spell_flags = CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/cult/pylon)

	hud_state = "const_pylon"

/spell/aoe_turf/conjure/pylon/cast(list/targets)
	..()
	var/turf/spawn_place = pick(targets)
	for(var/obj/structure/cult/pylon/P in spawn_place.contents)
		if(P.isbroken)
			P.repair(usr)
		continue
	return

/spell/aoe_turf/conjure/door
	name = "Stone Door"
	desc = "This spell conjures a massive stone door."

	charge_max = 100
	spell_flags = CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/simple_door/cult)

	hud_state = "const_door"

/spell/aoe_turf/conjure/grille
	name = "Arcane Grille"
	desc = "This spell conjures an airtight grille."

	charge_max = 100
	spell_flags = CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/grille/cult)

	hud_state = "const_grille"

/spell/aoe_turf/conjure/forcewall/lesser
	name = "Shield"
	desc = "Allows you to pull up a shield to protect yourself and allies from incoming threats"

	charge_max = 300
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/obj/effect/forcefield/cult)
	duration = 200

	hud_state = "const_juggwall"

//Code for the Juggernaut construct's forcefield, that seemed like a good place to put it.
/obj/effect/forcefield/cult
	desc = "That eerie looking obstacle seems to have been pulled from another dimension through sheer force"
	name = "Juggerwall"
	icon = 'icons/effects/effects.dmi'
	icon_state = "m_shield_cult"
	light_color = "#B40000"
	light_range = 2
	invisibility = 0

/obj/effect/forcefield/cult/cultify()
	return

/spell/aoe_turf/knock/harvester
	name = "Force Doors"
	desc = "Mortal portals are no match for your occult might."

	spell_flags = CONSTRUCT_CHECK

	charge_max = 100
	invocation = ""
	invocation_type = "silent"
	range = 4

	hud_state = "const_knock"

/spell/aoe_turf/knock/harvester/cast(list/targets)
/*	for(var/turf/T in targets) //Disintigrating doors is bad, okay.
		for(var/obj/machinery/door/door in T.contents)
			spawn door.cultify()
	return */
	for(var/turf/T in targets)
		for(var/obj/machinery/door/door in T.contents)
			spawn(1)
				if(istype(door,/obj/machinery/door/airlock))
					var/obj/machinery/door/airlock/AL = door
					AL.locked = 0 //The spirits of the damned care not for your locks.
					AL.welded = 0 //Or your welding tools.
				else if(istype(door, /obj/machinery/door/firedoor))
					var/obj/machinery/door/firedoor/FD = door
					FD.blocked = 0
				door.open(1)
	return

/*
 *
 * Self-targeting spells. Modifiers, auras, instants, etc.
 *
 */

/spell/targeted/ethereal_jaunt/shift
	name = "Phase Shift"
	desc = "This spell allows you to pass through walls"

	charge_max = 200
	spell_flags = Z2NOCAST | INCLUDEUSER | CONSTRUCT_CHECK
	invocation_type = SpI_NONE
	range = -1
	duration = 50 //in deciseconds

	hud_state = "const_shift"

/spell/targeted/ethereal_jaunt/shift/jaunt_disappear(var/atom/movable/overlay/animation, var/mob/living/target)
	animation.icon_state = "phase_shift"
	animation.dir = target.dir
	flick("phase_shift",animation)

/spell/targeted/ethereal_jaunt/shift/jaunt_reappear(var/atom/movable/overlay/animation, var/mob/living/target)
	animation.icon_state = "phase_shift2"
	animation.dir = target.dir
	flick("phase_shift2",animation)

/spell/targeted/ethereal_jaunt/shift/jaunt_steam(var/mobloc)
	return

/*
 * Harvest has been re-enabled with the genesis of pylons that can act as a home point.
 */


/spell/targeted/harvest
	name = "Harvest"
	desc = "Back to where I come from, and you're coming with me."

	school = "transmutation"
	charge_max = 200
	spell_flags = Z2NOCAST | CONSTRUCT_CHECK | INCLUDEUSER
	invocation = ""
	invocation_type = SpI_NONE
	range = 0
	max_targets = 0

	overlay = 1
	overlay_icon = 'icons/effects/effects.dmi'
	overlay_icon_state = "rune_teleport"
	overlay_lifespan = 0

	hud_state = "const_harvest"

/spell/targeted/harvest/cast(list/targets, mob/user)//because harvest is already a proc
	..()

	var/destination = null
	for(var/obj/singularity/narsie/large/N in narsie_list)
		destination = N.loc
		break
	if(destination)
		var/prey = 0
		for(var/mob/living/M in targets)
			if(!findNullRod(M))
				M.forceMove(destination)
				if(M != user)
					prey = 1
		to_chat(user, "<span class='sinister'>You warp back to Nar-Sie[prey ? " along with your prey":""].</span>")
	else
		to_chat(user, "<span class='danger'>...something's wrong!</span>") //There shouldn't be an instance of Harvesters when Nar-Sie isn't in the world.


/spell/targeted/fortify
	name = "Fortify Shell"
	desc = "Emit a field of energy around your shell to reduce incoming damage incredibly, while decreasing your mobility."

	range = -1
	school = "evocation"
	charge_type = Sp_RECHARGE
	invocation_type = SpI_NONE

	spell_flags = CONSTRUCT_CHECK | INCLUDEUSER

	hud_state = "const_fortify"
	smoke_amt = 0

	charge_max = 600

/spell/targeted/fortify/cast(list/targets, mob/living/user)
	if(findNullRod(user) || user.has_modifier_of_type(/datum/modifier/fortify))
		charge_counter = 400
		return
	user.add_modifier(/datum/modifier/fortify, 1 MINUTES)

/spell/targeted/occult_repair_aura
	name = "Repair Aura"
	desc = "Emit a field of energy around your shell to repair nearby constructs at range."

	range = -1
	school = "evocation"
	charge_type = Sp_RECHARGE
	invocation_type = SpI_NONE

	spell_flags = CONSTRUCT_CHECK | INCLUDEUSER

	hud_state = "const_repairaura"
	smoke_amt = 0

	charge_max = 600

/spell/targeted/occult_repair_aura/cast(list/targets, mob/living/user)
	if(findNullRod(user) || user.has_modifier_of_type(/datum/modifier/repair_aura))
		charge_counter = 300
		return
	user.add_modifier(/datum/modifier/repair_aura, 30 SECONDS)

/spell/targeted/ambush_mode
	name = "Toggle Ambush"
	desc = "Phase yourself mostly out of this reality, minimizing your combat ability, but allowing for employance of ambush tactics."

	range = -1
	school = "evocation"
	charge_type = Sp_RECHARGE
	invocation_type = SpI_NONE

	spell_flags = CONSTRUCT_CHECK | INCLUDEUSER

	hud_state = "const_ambush"
	smoke_amt = 0

	charge_max = 100

/spell/targeted/ambush_mode/cast(list/targets, mob/living/user)
	if(findNullRod(user))
		charge_counter = 50
		return
	if(user.has_modifier_of_type(/datum/modifier/ambush))
		user.remove_modifiers_of_type(/datum/modifier/ambush)
		return
	user.add_modifier(/datum/modifier/ambush, 0)

/*
 *
 * These are the spells that place spell-objects into the construct's hands akin to technomancers.
 *
 */

/spell/targeted/construct_advanced
	name = "Base Construct Spell"
	desc = "If you see this, please tell a developer!"

	range = -1
	school = "evocation"
	charge_type = Sp_RECHARGE
	invocation_type = SpI_NONE

	spell_flags = CONSTRUCT_CHECK | INCLUDEUSER

	hud_state = "const_rune"
	smoke_amt = 0

	charge_max = 10

	var/obj/item/weapon/spell/construct/spell_obj = null //This is the var that determines what Technomancer-style spell is put into their hands.

/spell/targeted/construct_advanced/cast(list/targets, mob/living/user)
	if(!findNullRod(user))
		user.place_spell_in_hand(spell_obj)

/spell/targeted/construct_advanced/inversion_beam
	name = "Inversion Beam"
	desc = "Fire a searing beam of darkness at your foes."

	hud_state = "const_beam"
	spell_obj = /obj/item/weapon/spell/construct/projectile/inverted_beam

/spell/targeted/construct_advanced/mend_acolyte
	name = "Mend Acolyte"
	desc = "Mend a target acolyte or construct over time."

	charge_max = 100

	hud_state = "const_mend"
	spell_obj = /obj/item/weapon/spell/construct/mend_occult

/spell/targeted/construct_advanced/agonizing_sphere
	name = "Sphere of Agony"
	desc = "Rend a portal into a plane of naught but pain at the target location."

	charge_max = 100

	hud_state = "const_harvest"
	spell_obj = /obj/item/weapon/spell/construct/spawner/agonizing_sphere

/spell/targeted/construct_advanced/slam
	name = "Slam"
	desc = "Empower your FIST."

	charge_max = 300

	hud_state = "const_fist"
	spell_obj = /obj/item/weapon/spell/construct/slam
