/datum/game_mode/zombie
	name = "Zombie Invasion"
	config_tag = "zombie"
	round_description = "Zombies are taking over the city, all civilians must defend and fight back against the invasion!"
	extended_round_description = "Zombies - Infect and kill all humans. Civillians must kill all zombies."
	required_players = 2 //should be enough for a decent manifest, hopefullyc
	required_enemies = 1
	required_players_secret = 1
	end_on_antag_death = 1
	restricted_jobs = list("AI", "Cyborg","Chief Medical Officer", "Doctor", "Virologist") //We need some hippocratic oath slaves to actually help, y'know.


/datum/game_mode/zombie/proc/pick_zombie()
	var/mob/human/killer = pick(get_synd_list())
	ticker.killer = killer
	var/objective = "Braaiiinnns....(What do you think? Eat them all.)"
	ticker.objective = objective
	killer.traitor_infect()
	killer << "\red<font size=3><B>You are Patient Zero!</B>Braaiiinnns....(What do you think? Eat them all.)"
	killer.store_memory("Either turn or kill all humans!.")

/datum/game_mode/zombie/proc/pick_immune()
	var/mob/human/M = pick(get_human_list())
	M.zombieimmune = 1

/datum/game_mode/zombie/pre_setup()

	var/list/possible_zombies = get_players_for_role(ROLE_ZOMBIE)

	// stop setup if no possible traitors
	if(!possible_zombies.len)
		log_admin("Failed to set-up a round of zombie invasion. Couldn't find any volunteers to be a zombie.")
		message_admins("Failed to set-up a round of zombie invasion. Couldn't find any volunteers to be zombie.")
		return 0

	doctors = 0
	for(var/mob/new_player/player in mob_list)
		if(player.mind.assigned_role in list("Chief Medical Officer","Medical Doctor","Virologist"))
			doctors++
			break

	if(doctors < 1)
		return 0

	return 1

/datum/game_mode/zombie/send_intercept()
	virus_name = "X-[rand(1,99)]&trade;"
	var/intercepttext = {"<FONT size = 3 color='red'><B>CONFIDENTIAL REPORT</FONT><HR>
		<B>Warning: Pathogen [virus_name] has been detected on [station_name()].</B><BR><BR>
		<B>Code violet quarantine of [station_name()] put under immediate effect.</B><BR>
		<B>Class [rand(2,5)] cruiser has been dispatched. ETA: [round(cruiser_seconds() / 60)] minutes.</B><BR>
		<BR><B><FONT size = 2 color='blue'>Instructions</FONT></B><BR>
		<B>* ELIMINATE THREAT WITH EXTREME PREJUDICE. [virus_name] IS HIGHLY CONTAGIOUS. INFECTED CREW MEMBERS MUST BE QUARANTINED IMMEDIATELY.</B><BR>
		<B>* [station_name()] is under QUARANTINE. Any vessels outbound from [station_name()] will be tracked down and destroyed.</B><BR>"}

	for (var/obj/machinery/computer/communications/comm in machines)
		if (!(comm.stat & (BROKEN | NOPOWER)) && comm.prints_intercept)
			var/obj/item/weapon/paper/intercept = new /obj/item/weapon/paper( comm.loc )
			intercept.name = "paper"
			intercept.info = intercepttext

			comm.messagetitle.Add("Cent. Com. CONFIDENTIAL REPORT")
			comm.messagetext.Add(intercepttext)

	world << sound('sound/AI/commandreport.ogg')


/datum/game_mode/epidemic/post_setup()
	// make sure viral outbreak events don't happen on this mode
	EventTypes.Remove(/datum/event/viralinfection)

	// scan the crew for possible infectees
	var/list/crew = list()
	for(var/mob/living/carbon/human/H in mob_list) if(H.client)
		// heads should not be infected
		if(H.mind.assigned_role in command_positions)
			continue
		crew += H

	if(crew.len < 2)
		to_chat(world, "<span class='warning'>There aren't enough players for this mode!</span>")
		to_chat(world, "<span class='warning'>Rebooting world in 5 seconds.</span>")

		if(blackbox)
			blackbox.save_all_data_to_sql()
		sleep(50)
		world.Reboot()

	var/datum/disease2/disease/lethal = new
	lethal.makerandom(1)
	lethal.infectionchance = 5

	// the more doctors, the more will be infected
	var/lethal_amount = doctors * 2

	// keep track of initial infectees
	var/list/infectees = list()

	for(var/i = 0, i < lethal_amount, i++)
		var/mob/living/carbon/human/H = pick(crew)
		if(lethal.uniqueID in H.virus2)
			i--
			continue
		H.virus2["[lethal.uniqueID]"] = lethal.getcopy()
		infectees += H

	var/mob/living/carbon/human/patient_zero = pick(infectees)
	var/datum/disease2/disease/V = patient_zero.virus2["[lethal.uniqueID]"]
	V.stage = 3

	cruiser_arrival = world.time + (10 * 90 * 60)
	stage = 1

	spawn (rand(waittime_l, waittime_h))
		if(!mixed)
			send_intercept()


	..()
