client/verb/JoinasPresident()

	set name = "Join as President"
	set category = "IC"

	var/current_president

	if(istype(usr,/mob/observer/dead) || istype(usr,/mob/new_player))
		if(jobban_isbanned(usr, "President"))
			usr << "<span class='danger'>You are jobbanned from the president role!</span>"
			return

		if(!fexists("data/president.txt"))
			usr << "<span class='danger'>There is no president currently elected.</span>"
			return

		var/list/Lines = file2list("data/president.txt")
		if(Lines.len)
			if(Lines[1])
				current_president = Lines[1]
				if(!(src.ckey in list(current_president)))
					usr << "<span class='danger'>It seems that you're not the current president, go get elected!</span>"
					return


				usr << "Note: Use ''Preferences > Character Setup'' to switch your loaded character to your president character if this is not the elected president."


				spawn_president(usr)
	else
		usr << "You need to be an observer or new player to use this."


/client/proc/spawn_president()

	var/client/picked_client = src

	var/location = alert(src,"Please specify where to spawn them.", "Location", "Right Here", "Cancel")
	if(location == "Cancel")
		return

	if(!location)
		return

	var/announce = alert(src,"Announce as if they had just arrived?", "Announce", "Yes", "No", "Cancel")
	if(announce == "Cancel")
		return

	else if(announce == "Yes") //Too bad buttons can't just have 1/0 values and different display strings
		announce = 1
	else
		announce = 0

	//Name matching is ugly but mind doesn't persist to look at.
	var/charjob = "President"
	var/records = 1
	var/equipment = 1

	//For logging later
	var/player_key = picked_client.key

	var/mob/living/carbon/human/new_character
	var/spawnloc

	//Where did you want to spawn them?
	switch(location)
		if("Right Here") //Spawn them on your turf
			if(!src.mob)
				src << "You can't use 'Right Here' when you are not 'Right Anywhere'!"
				return

			spawnloc = get_turf(src.mob)

		if("Cancel")
			src << "If you say so."
			return

		else //I have no idea how you're here
			src << "Invalid spawn location choice."
			return

	//Did we actually get a loc to spawn them?
	if(!spawnloc)
		src << "Couldn't get valid spawn location."
		return

	new_character = new(spawnloc)

	//We were able to spawn them, right?
	if(!new_character)
		src << "Something went wrong and spawning failed."
		return

	//Write the appearance and whatnot out to the character
	picked_client.prefs.copy_to(new_character)
	if(new_character.dna)
		new_character.dna.ResetUIFrom(new_character)
		new_character.sync_organ_dna()
		new_character.key = player_key
		//Were they any particular special role? If so, copy.
		if(new_character.mind)
			var/datum/antagonist/antag_data = get_antag_data(new_character.mind.special_role)
			if(antag_data)
				antag_data.add_antagonist(new_character.mind)
				antag_data.place_mob(new_character)

	//If desired, apply equipment.
	if(equipment)
		if(charjob)
			job_master.EquipRank(new_character, charjob, 1)
		equip_custom_items(new_character)

	//If desired, add records.
	if(records)
		data_core.manifest_inject(new_character)

	//If we're announcing their arrival
	if(announce)
		AnnounceArrival(new_character, new_character.mind.assigned_role)

	log_admin("President spawned: [player_key]'s character [new_character.real_name].")
	message_admins("President spawned: Spawned [player_key]'s character [new_character.real_name].", 1)

	new_character << "You have been fully spawned. Enjoy the game."

	feedback_add_details("admin_verb","RSPCH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	return new_character


