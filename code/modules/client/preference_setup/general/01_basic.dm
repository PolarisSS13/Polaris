datum/preferences
	var/biological_gender = MALE
	var/identifying_gender = MALE

datum/preferences/proc/set_biological_gender(var/gender)
	biological_gender = gender
	identifying_gender = gender

/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/general/basic/load_character(var/savefile/S)
	S["real_name"]				>> pref.real_name
	S["nickname"]				>> pref.nickname
//	S["name_is_always_random"]	>> pref.be_random_name
	S["gender"]				>> pref.biological_gender
	S["id_gender"]				>> pref.identifying_gender
	S["age"]					>> pref.age
	S["birth_day"]				>> pref.birth_day
	S["birth_month"]			>> pref.birth_month
	S["birth_year"]			>> pref.birth_year
	S["spawnpoint"]			>> pref.spawnpoint
	S["OOC_Notes"]				>> pref.metadata
	S["email"]				>> pref.email
	S["existing_character"]		>> pref.existing_character
	S["played"]				>> pref.played
	S["unique_id"]				>> pref.unique_id

/datum/category_item/player_setup_item/general/basic/save_character(var/savefile/S)
	S["real_name"]				<< pref.real_name
	S["nickname"]				<< pref.nickname
//	S["name_is_always_random"]	<< pref.be_random_name
	S["gender"]				<< pref.biological_gender
	S["id_gender"]				<< pref.identifying_gender
	S["age"]					<< pref.age
	S["birth_day"]				<< pref.birth_day
	S["birth_month"]			<< pref.birth_month
	S["birth_year"]			<< pref.birth_year
	S["spawnpoint"]			<< pref.spawnpoint
	S["OOC_Notes"]				<< pref.metadata
	S["email"]				<< pref.email
	S["existing_character"]		<< pref.existing_character
	S["played"]				<< pref.played
	S["unique_id"]				<< pref.unique_id

/datum/category_item/player_setup_item/general/basic/delete_character()
	pref.real_name = null
	pref.nickname = null
//	pref.be_random_name = null
	pref.biological_gender = null
	pref.identifying_gender = null
	pref.age = null
	pref.birth_day = null
	pref.birth_month = null
	pref.birth_year = null
	pref.spawnpoint = null
	pref.metadata = null
	pref.existing_character = null
	pref.played = null
	pref.unique_id = null
	if(fdel("data/persistent/emails/[pref.email].sav"))
		pref.email = null


/datum/category_item/player_setup_item/general/basic/sanitize_character()

	pref.biological_gender  = sanitize_inlist(pref.biological_gender, get_genders(), pick(get_genders()))
	pref.identifying_gender = (pref.identifying_gender in all_genders_define_list) ? pref.identifying_gender : pref.biological_gender
	pref.real_name		= sanitize_name(pref.real_name, pref.species, is_FBP())
	if(!pref.real_name)
		pref.real_name      = random_name(pref.identifying_gender, pref.species)

	if(!pref.birth_year)
		adjust_year()

	pref.age                = sanitize_integer(pref.age, get_min_age(), get_max_age(), initial(pref.age))
	pref.birth_day          = sanitize_integer(pref.birth_day, 1, 31, initial(pref.birth_day))
	pref.birth_month        = sanitize_integer(pref.birth_month, 1, 12, initial(pref.birth_month))


	pref.nickname		= sanitize_name(pref.nickname)
	pref.spawnpoint         = sanitize_inlist(pref.spawnpoint, spawntypes, initial(pref.spawnpoint))
//	pref.be_random_name     = sanitize_integer(pref.be_random_name, 0, 1, initial(pref.be_random_name))
	if(!pref.unique_id)
		pref.unique_id			= md5("[pref.client_ckey][rand(30,50)]")

	if(!pref.email)
		var/new_email = SSemails.generate_email(pref.real_name)

		if(!ntnet_global.does_email_exist(new_email) || !SSemails.check_persistent_email(new_email))
			pref.email = new_email



// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/basic/copy_to_mob(var/mob/living/carbon/human/character)
	if(config.humans_need_surnames && !is_FBP())
		var/firstspace = findtext(pref.real_name, " ")
		var/name_length = length(pref.real_name)
		if(!firstspace)	//we need a surname
			pref.real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			pref.real_name += "[pick(last_names)]"

	if(is_FBP() && !pref.real_name)
		pref.real_name = "[pick(last_names)]"

	character.real_name = pref.real_name
	character.name = character.real_name
	if(character.dna)
		character.dna.real_name = character.real_name

	character.nickname = pref.nickname

	character.gender = pref.biological_gender
	character.identifying_gender = pref.identifying_gender
	character.age = pref.age
	character.birth_year = pref.birth_year
	character.birth_month = pref.birth_month

F

/datum/category_item/player_setup_item/general/basic/content()
	. = list()
	. += "<h1>Basic Information:</h1><hr>"
	if(!pref.existing_character)
		. += "Set your character's general details here. Once your name, age, and sex are set, <b>you cannot modify them again.</b> Your nickname and languages can be edited and you will age automatically, however.<br><br>"
	. += "<b>Name:</b><br>"
	if(!pref.existing_character)
		. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
		. += "<a href='?src=\ref[src];random_name=1'>Randomize Name</A><br>"
	else
		. += "[pref.real_name]<br>"
//	. += "<a href='?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a><br>"
	. += "<b>Nickname:</b><br>"
	. += "<a href='?src=\ref[src];nickname=1'><b>[pref.nickname]</b></a>"
	. += "<br>"
	. += "<b>Biological Sex:</b><br>"
	if(!pref.existing_character)
		. += "<a href='?src=\ref[src];bio_gender=1'><b>[gender2text(pref.biological_gender)]</b></a><br>"
	else
		. += "[gender2text(pref.biological_gender)]<br>"

	. += "<b>Gender Identity:</b><br> <a href='?src=\ref[src];id_gender=1'><b>[gender2text(pref.identifying_gender)]</b></a><br>"

	. += "<b>Age:</b><br>"
	. += "<a href='?src=\ref[src];age=1'>[pref.age] ([age2agedescription(pref.age)])</a><br><br>"

	. += "<b>Email Address:</b><br>"

	if(!pref.existing_character)
		. += "Email: <a href='?src=\ref[src];email_domain=1'>[pref.email]</a><br><br>"
	else
		. += "Login: [pref.email]<br>Password: [SSemails.get_persistent_email_password(pref.email)] <br><br>"

	if(pref.existing_character)
		. += "<b>Unique Character ID:</b> [pref.unique_id]<br>"


	. += "<b>Birthday:</b><br>"

	if(!pref.existing_character)
		. += "<a href='?src=\ref[src];birth_day=1'>[pref.birth_day]</a>/"
		. += "<a href='?src=\ref[src];birth_month=1'>[pref.birth_month]</a>/"
		. += "[pref.birth_year]<br><br>"
	else
		. += "[pref.birth_day]/[pref.birth_month]/[pref.birth_year]<br><br>"

	. += "<b>Spawn Point</b>:<br> <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a><br>"
	if(config.allow_Metadata)
		. += "<b>OOC Notes:</b><br> <a href='?src=\ref[src];metadata=1'> Edit </a><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/general/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["rename"])
		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species, is_FBP())
			if(new_name)
				pref.real_name = new_name
				return TOPIC_REFRESH
			else
				user << "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>"
				return TOPIC_NOACTION

	else if(href_list["random_name"])
		pref.real_name = random_name(pref.identifying_gender, pref.species)
		return TOPIC_REFRESH
/*
	else if(href_list["always_random_name"])
		pref.be_random_name = !pref.be_random_name
		return TOPIC_REFRESH
*/
	else if(href_list["nickname"])
		var/raw_nickname = input(user, "Choose your character's nickname:", "Character Nickname")  as text|null
		if (!isnull(raw_nickname) && CanUseTopic(user))
			var/new_nickname = sanitize_name(raw_nickname, pref.species, is_FBP())
			if(new_nickname)
				pref.nickname = new_nickname
				return TOPIC_REFRESH
			else
				user << "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>"
				return TOPIC_NOACTION

	else if(href_list["bio_gender"])
		var/new_gender = input(user, "Choose your character's biological gender:", "Character Preference", pref.biological_gender) as null|anything in get_genders()
		if(new_gender && CanUseTopic(user))
			pref.set_biological_gender(new_gender)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["id_gender"])
		var/new_gender = input(user, "Choose your character's identifying gender:", "Character Preference", pref.identifying_gender) as null|anything in all_genders_define_list
		if(new_gender && CanUseTopic(user))
			pref.identifying_gender = new_gender
		return TOPIC_REFRESH

	else if(href_list["age"])
		var/min_age = get_min_age()
		var/max_age = get_max_age()
		var/new_age = input(user, "Choose your character's age:\n([min_age]-[max_age])", "Character Preference", pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)), max_age), min_age)
			adjust_year()
			return TOPIC_REFRESH


	else if(href_list["email_domain"])
		var/list/domains = using_map.usable_email_tlds
		var/prefix = input(user, "Enter your email username.", "Email Username")  as text|null
		if(!prefix)
			return

		var/domain = input(user, "What is the email domain provider you use?", "Email Provider") as null|anything in domains
		if(!domain)
			return

		var/full_email = "[prefix]@[domain]"

		if(full_email && SSemails.check_persistent_email(full_email))
			alert(user, "This email already exists, please choose another.")
			return

		if(full_email && !SSemails.check_persistent_email(pref.email))
			SSemails.new_persistent_email(full_email)


		fcopy("data/persistent/emails/[pref.email].sav","data/persistent/emails/[full_email].sav")
		fdel("data/persistent/emails/[pref.email].sav")
		SSemails.change_persistent_email_address(pref.email, full_email)

		pref.email = "[prefix]@[domain]"


		return TOPIC_REFRESH


	else if(href_list["birth_day"])
		var/min_day = 1
		var/max_day

		if(pref.birth_month in THIRTY_ONE_DAY_MONTHS) //Please don't look, I have shame.
			max_day = 31

		if(pref.birth_month in THIRTY_DAY_MONTHS)
			max_day = 30

		if(pref.birth_month in TWENTY_EIGHT_DAY_MONTHS)
			max_day = 28

		var/new_day = input(user, "Choose your character's birth day:\n([min_day]-[max_day])", "Character Preference", pref.birth_day) as num|null
		if(new_day && CanUseTopic(user))
			pref.birth_day = max(min(round(text2num(new_day)), max_day), min_day)
			adjust_year()
			return TOPIC_REFRESH

	else if(href_list["birth_month"])
		var/month_min = 1
		var/month_max = 12

		var/new_month = input(user, "Choose your character's birth month:\n([month_min]-[month_max])", "Character Preference", pref.birth_month) as num|null
		if(new_month && CanUseTopic(user))
			pref.birth_month = max(min(round(text2num(new_month)), month_max), month_min)
			if(pref.birth_month in THIRTY_DAY_MONTHS)
				if(pref.birth_day > 30)
					pref.birth_day = 30
			if(pref.birth_month in TWENTY_EIGHT_DAY_MONTHS)
				if(pref.birth_day > 28)
					pref.birth_day = 28
			adjust_year()
			return TOPIC_REFRESH

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/spawntype in spawntypes)
			spawnkeys += spawntype
		var/choice = input(user, "Where would you like to spawn when late-joining?") as null|anything in spawnkeys
		if(!choice || !spawntypes[choice] || !CanUseTopic(user))	return TOPIC_NOACTION
		pref.spawnpoint = choice
		return TOPIC_REFRESH

	else if(href_list["metadata"])
		var/new_metadata = sanitize(input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , pref.metadata)) as message|null
		if(new_metadata && CanUseTopic(user))
			pref.metadata = new_metadata
			return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/general/basic/proc/get_genders()
	var/datum/species/S
	if(pref.species)
		S = all_species[pref.species]
	else
		S = all_species[SPECIES_HUMAN]
	var/list/possible_genders = S.genders
	if(!pref.organ_data || pref.organ_data[BP_TORSO] != "cyborg")
		return possible_genders
	possible_genders = possible_genders.Copy()
	possible_genders |= NEUTER
	return possible_genders

/datum/category_item/player_setup_item/general/basic/proc/adjust_year()
	//this should only be set once, ever
	pref.birth_year = (get_game_year() - pref.age)

	//if it hasn't been their most recent birthday yet...
	if((get_game_month() < pref.birth_month) && (get_game_day() < pref.birth_day))
		pref.birth_year --

	return TOPIC_REFRESH
