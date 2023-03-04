//Uncommenting ALLOW_HOLIDAYS in config.txt will enable Holidays
var/global/list/Holiday = list() //Holidays are lists now, so we can have more than one holiday at the same time (hey, you never know).

//Just thinking ahead! Here's the foundations to a more robust Holiday event system.
//It's easy as hell to add stuff. Just set Holiday to something using the switch (or something else)
//then use if(Holiday == "MyHoliday") to make stuff happen on that specific day only
//Please, Don't spam stuff up with easter eggs, I'd rather somebody just delete this than people cause
//the game to lag even more in the name of one-day content.

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//ALSO, MOST IMPORTANTLY: Don't add stupid stuff! Discuss bonus content with Project-Heads first please!//
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//																							~Carn

/hook/startup/proc/updateHoliday()
	Get_Holiday()
	return 1

//sets up the Holiday global variable. Should be called on game configuration or something.
/proc/Get_Holiday()
	if(!Holiday)	return		// Holiday stuff was not enabled in the config!

	Holiday = list()			// reset our switch now so we can recycle it as our Holiday name

	//var/YY	=	text2num(time2text(world.timeofday, "YY")) 	// get the current year - unused currently but can be used for floating dates
	var/MM	=	text2num(time2text(world.timeofday, "MM")) 	// get the current month
	var/DD	=	text2num(time2text(world.timeofday, "DD")) 	// get the current day

	//Main switch. If any of these are too dumb/inappropriate, or you have better ones, feel free to change whatever
	//Holidays are now associate lists.  You should write holidays like this.
	//Holiday["Holiday Name Here"] = "Blurb about the holiday here."
	switch(MM)
		if(1)	//Jan
			switch(DD)
				if(1)
					Holiday["New Years's Day"] = "The day of the new solar year on Sol, and by extension the SolGov \
					Standard Calendar."
				if(12)
					Holiday["Vertalliq-Qerr"] = "Vertalliq-Qerr, translated to mean 'Festival of the Royals', is a \
					Skrell holiday that celebrates the Qerr-Katish and all they have provided for the rest of Skrell society, \
					it often features colourful displays and skilled performers take this time to show off some of their more \
					elaborate displays."
				if(14)
					Holiday["Lohri"] = "A human festival traditionally celebrating the end of winter on the Indian subcontinent. \
					The holiday is now celebrated independently of seasons in many colonies with large populations of Indian \
					descent. Traditions include the burning of bonfires, dancing, and door-to-door singing in exchange for treats."
				if(30)
					Holiday["Lunar New Year"] = "Originally the new year on the ancient lunisolar calendar, the Lunar New Year is \
					celebrated with a wide variety of east Asian traditions with roots in Chinese, Japanese, Korean, Vietnamese, \
					Tibetan, Mongolian, and Ryukyu cultures. Elaborate parades, performances, dances and meals are usual staples. \
					The date was standardized by resolution of the SCG Assembly in the mid 23rd century."

		if(2)	//Feb
			switch(DD)
				if(2)
					Holiday["Groundhog Day"] = "An unofficial holiday based on medieval folklore that originated on Earth, \
					that involves the reverence of a prophetic animal - traditionally a badger, fox or groundhog - that was \
					said to be able to predict, or even control the changing of the seasons. In Vir, the humble Siffet  \
					sometimes assumes this role."
				if(14)
					Holiday["Valentine's Day"] = "A human holiday that revolves around expressions of romance and love. \
					In particular, the exchanging of gifts, letters and cards is traditional."
				if(15)
					Holiday["Lantern Festival"] = "A human holiday with origins in Chinese new year celebrations. Participants \
					carry or hang elaborate paper lanterns that are thought to bring good luck. Today, electric lights are often used \
					in environments where open flames would be hazardous or non-functional."
				if(17)
					Holiday["Random Acts of Kindness Day"] = "An unofficial holiday that challenges everyone to perform \
					acts of kindness to their friends, co-workers, and strangers, with no strings attached."
				if(23)
					Holiday["Vir Friendship Day"] = "A day observing the anniversary of the end of the Karan Wars, formation of VirGov, \
					and Vir's entry into the SCG as a full member state. Marked by memorials to those lost during the conflict between \
					Sif settlers and Karan corporate miners, 2364-2412."

		if(3)	//Mar
			switch(DD)
				if(3)
					Holiday["Qixm-tes"] = "Qixm-tes, or 'Day of mourning', is a Skrell holiday where Skrell gather at places \
					of worship and sing a song of mourning for all those who have died in service to their kingdoms."
				if(14)
					Holiday["Pi Day"] = "An unofficial holiday celebrating the mathematical constant Pi.  It is celebrated on \
					March 14th, as the digits form 3 14, the first three significant digits of Pi.  Observance of Pi Day generally \
					involve eating (or throwing) pie, due to a pun.  Pies also tend to be round, and thus relatable to Pi."
				if(17)
					Holiday["St. Patrick's Day"] = "A holiday originating on Earth, celebrating a popular version of Irish culture. \
					Traditions include elaborate parades, wearing of the colour green, and drinking alcohol."
				if(18)
					Holiday["Holi"] = "Also known as the Festival of Colours, a human Hindu festival celebrating divine love and the \
					triumph of good over evil. Traditionally a bonfire is lit overnight, followed by the free-for-all smearing of \
					celebrants with colourful pigments, and the forgiveness of past wrongs."
				if(21)
					Holiday["Nowruz"] = "Originally New Year on the Persian calendar , this Unitarian holiday celebrates the Earth \
					spring Equinox. Traditions include the cleaning of one's living space, gift-giving, and the lighting of fires."
				if(27)
					Holiday["Easter"] = "A Earth springtime festival variously celebrating rebirth and the beginning of the planting \
					season. Traditionally celebrated with the painting and exchange of eggs, sometimes made from chocolate. \
					The holiday's date was standardized by the Unitarian Church in the 22nd century."

		if(4)	//Apr
			switch(DD)
				if(1)
					Holiday["April Fool's Day"] = "A human holiday that endeavours one to pull pranks and spread hoaxes on their friends."
				if(5)
					Holiday["First Day of Passover"] = "The first of eight days of a human holiday celebrating the exodus of ancient Jewish people \
					from slavery, and of the spring harvest. On Pluto and Kishar, the holiday is also sometimes associated with their \
					arrival on those worlds. The most well-known tradition is the Sedar meal. The date was standardized by the Unitarian \
					Church in the 22nd century."
				if(14)
					Holiday["Beginning of Ramadan"] = "The first day of a month-long fasting period observed by many Unitarians. \
					Observants abstain from sexual relations, and from eating or drinking during Galactic Standard day-time, as well \
					as performing regular prayers and charitable acts. Traditionally lasting one Earth lunar cycle, the dates were \
					standardized by the Unitarian Church in the 22nd century."
				if(15)
					Holiday["Ka'merr Heritage Day"] = "A Skrell-instituted formal holiday intended to standardize the dating of a wide \
					range of varying Teshari cultural festivals onto one day. Official celebrations mostly involve time set aside for \
					the veneration of spirits, but many Teshari resent the attempt to homogenize their pack cultures."
				if(22)
					Holiday["Environment Day"] = "A celebration of environmentalism. Originally named Earth Day, in honour of its \
					originating planet, but since expanded to encompass all worlds and their natural environments, whatever they \
					may be."

		if(5)	//May
			switch(DD)
				if(1)
					Holiday["Interstellar Workers' Day"] = "Also known as May Day, this holiday celebrates the work of laborers and \
					the working class. It is not designated as a public holiday in most colonies due to a perceived association with \
					'union agitation'."
				if(14)
					Holiday["Eid al-Fitr"] = "A feast day marking the end of the month-long Ramadan fasting period observed by many Unitarians. \
					The date was standardized by the Unitarian Church in the 22nd century."
				if(18)
					Holiday["Remembrance Day"] = "Remembrance Day (or, as it is more informally known, Armistice Day) is a confederation-wide holiday \
					mostly observed by its member states since late 2520. Officially, it is a day of remembering the men and women who died in various armed conflicts \
					throughout human history. Unofficially, however, it is commonly treated as a holiday honoring the victims of the Human-Unathi war. \
					Observance of this day varies throughout human space, but most common traditions are the act of bringing flowers to graves,\
					attending parades, and the wearing of poppies (either paper or real) in one's clothing."
				if(28)
					Holiday["Jiql-tes"] = "A Skrellian holiday that translates to 'Day of Celebration', Skrell communities \
					gather for a grand feast and give gifts to friends and close relatives."

		if(6)	//Jun
			switch(DD)
				if(6)
					Holiday["Sapient Rights Day"] = "This holiday celebrates the passing of the Declaration of Sapient Rights by SolGov, which guarantees the \
					same protections humans are granted to all sapient, living species."
				if(14)
					Holiday["Blood Donor Day"] = "This holiday was created to raise awareness of the need for safe blood and blood products, \
					and to thank blood donors for their voluntary, life-saving gifts of blood."
				if(20)
					Holiday["Civil Servant's Day"] = "Civil Servant's Day is a holiday observed in SCG member states that honors civil servants everywhere,\
					(especially those who are members of the armed forces and the emergency services), or have been or have been civil servants in the past."
				if(25)
					Holiday["Merhyat Njarha"] = "A Njarir'Akhan Tajaran tradition translating to \"Harmony of the House\", in which Njarjirii citizens pay \
					homage to their ruling house and their ancestors. Traditions include large communal meals and dances hosted by the ruling house, \
					and the intensive upkeep of community spaces."

		if(7)	//Jul
			switch(DD)
				if(1)
					Holiday["Doctors' Day"] = "A holiday that recognizes the services of physicians, commonly celebrated \
					in healthcare organizations and facilities."
				if(7)
					Holiday["Unification Day"] = "The anniversary of the formation of the Solar Confederate Government in 2108, following the \
					Annexation of Ceres and Selene Federation territories on Luna, Mars and Venus by the United Nations after \
					7 years of war. A public holiday in most workplaces since 2118, but not this one."
				if(30)
					Holiday["Friendship Day"] = "An unofficial holiday that recognizes the value of friends and companionship.  Indeed, not having someone watch \
					your back while in space can be dangerous, and the cold, isolating nature of space makes friends all the more important."

		if(8)	//Aug
			switch(DD)
				if(11)
					Holiday["Tajaran Contact Day"] = "The anniversary of first contact between SolGov and the Tajaran species, widely observed\
					throughout Tajaran and human space. Marks the date that in 2513, a human exploration team investigating electromagnetic \
					emissions from the Meralar system made radio contact with the Tajaran scientific outpost that had broadcast them."
				if(20)
					Holiday["Obon"] = "An ancient Earth holiday originating in east Asia, for the honouring of one's ancestral spirits. \
					Traditions include the maintenance of grave sites and memorials, and community traditional dance performances."
				if(27)
					Holiday["Forgiveness Day"] = "A time to forgive and be forgiven."

		if(9)	//Sep
			switch(DD)
				if(17)
					Holiday["Qill-xamr"] = "Translated to 'Night of the dead', it is a Skrell holiday where Skrell \
					communities hold parties in order to remember loved ones who passed, unlike Qixm-tes, this applies to everyone \
					and is a joyful celebration."
				if(19)
					Holiday["Talk-Like-a-Pirate Day"] = "Ahoy, matey! It be the unofficial holiday celebratin' the salty \
					sea humor of speakin' like the pirates of old."
				if(20)
					Holiday["Rosh Hashanah"] = "An old human holiday that marks the traditional Hebrew new year, and the first of \
					the High Holy Days in modern Unitarianism, beginning with ten-day period of penitence and prayer."
				if(28)
					Holiday["Stupid-Questions Day"] = "Known as Ask A Stupid Question Day, it is an unofficial holiday \
					created by teachers in Sol, very long ago, to encourage students to ask more questions in the classroom."
				if(30)
					Holiday["Yom Kippur"] = "A day of fasting, abstinence, and intensive prayer. One of the most holy days \
					in the Unitarian Church, who standardized the date in the 22nd century."

		if(10)	//Oct
			switch(DD)
				if(9)
					Holiday["Leif Eriksson Day"] = "A day commemorating Norse explorer Leif Eriksson, an early Scandinavian cultural figure \
					who is thought to have been the first European to set foot in North America. He continues to be celebrated on Sif as a symbol of \
					Nordic adventuring spirit, and seen by many as a spiritual forerunner to the colonization of Vir."
				if(10)
					Holiday["SCV Leif Eriksson Day"] = "A day commemorating the official establishment of New Reykjavik by a Scandinavian Union colony \
					ship - the SCV Leif Eriksson - in 2209, marking the first human settlement on the surface of Sif. Some believe the exact date was fudged."
				if(16)
					Holiday["Boss' Day"] = "Boss' Day has traditionally been a day for employees to thank their bosses for the difficult work that they do \
					throughout the year. This day was created for the purpose of strengthening the bond between employer and employee."
				if(21)
					Holiday["First Day of Diwali"] = "An ancient Hindu, Jain and Sikh festival lasting five days, celebrating victory of light over darkness, good over \
					evil, and knowledge over ignorance. It is celebrated by the wearing of your finest clothes, decorating with oil lamps and rangolis, \
					fireworks, and gift-giving. Electric lights are often used in modern times where oil lamps would be hazardous or inoperable."
				if(31)
					Holiday["Halloween"] = "Originating from Earth, Halloween is also known as All Saints' Eve, and \
					is celebrated by some by attending costume parties, trick-or-treating, carving faces in pumpkins, or visiting \
					'haunted' locations.  Some people make it a goal to scare other people."

		if(11)	//Nov
			switch(DD)
				if(1)
					Holiday["Day of the Dead"] = "An old human holiday celebrating the lives of deceased friends and family members, \
					by means of good humour and joyful parties. Offerings are often left at altars to the dead, and exchanging gifts \
					among the living is not uncommon."
				if(13)
					Holiday["Kindness Day"] = "Kindness Day is an unofficial holiday to highlight good deeds in the \
					community, focusing on the positive power and the common thread of kindness which binds humanity and \
					friends together."
				if(28) //Space thanksgiving.
					Holiday["Appreciation Day"] = "Based on an old holiday from Earth, Appreciation Day follows many of the \
					traditions that its North American predecessor did, such as having a large feast (turkey often included), gathering with family, \
					and being thankful for what one has in life."

		if(12)	//Dec
			switch(DD)
				if(10)
					Holiday["Human-Rights Day"] = "An old holiday created by an intergovernmental organization known back than as the United Nations, \
					human rights were not recognized globally at the time, and the holiday was made in honor of the Universal Declaration of Human Rights.  \
					These days, SolGov ensures that past efforts were not in vein, and continues to honor this holiday across the galaxy as a historical \
					reminder."
				if(22)
					Holiday["Vertalliq-qixim"] = "A Skrellian holiday that celebrates the Skrell's first landing on one of \
					their moons. It's often celebrated with grand festivals."
				if(24)
					Holiday["Christmas Eve"] = "The eve of Christmas, an old holiday from Earth that mainly involves gift \
					giving, decorating, family reunions, and a fat red human breaking into people's homes to steal milk and cookies."
				if(25)
					Holiday["Christmas"] = "Christmas is a very old holiday that originated in Earth, Sol.  It was a \
					religious holiday for the Christian religion, which would later form Unitarianism. Nowadays, the holiday is celebrated \
					generally by giving gifts, symbolic decoration, and reuniting with one's family.  It also features a mythical fat \
					red human, known as Santa, who broke into people's homes to loot cookies and milk."
				if(31)
					Holiday["New Year's Eve"] = "The eve of the New Year for Sol.  It is traditionally celebrated by counting down to midnight, as that is \
					when the new year begins.  Other activities include planning for self-improvement over the new year, attending New Year's parties, or \
					watching a timer count to zero, a large object descending, and fireworks exploding in the sky, in person or on broadcast."

	if(!Holiday)
		//Friday the 13th
		if(DD == 13)
			if(time2text(world.timeofday, "DDD") == "Fri")
				Holiday["Friday the 13th"] = "Friday the 13th is a superstitious day, associated with bad luck and misfortune."

//Allows GA and GM to set the Holiday variable
/client/proc/Set_Holiday()
	set name = ".Set Holiday"
	set category = "Fun"
	set desc = "Force-set the Holiday variable to make the game think it's a certain day."
	if(!check_rights(R_SERVER))	return

	Holiday = list()

	var/H = input(src,"What holiday is it today?","Set Holiday") as text
	var/B = input(src,"Now explain what the holiday is about","Set Holiday") as message


	Holiday[H] = B

	//update our hub status
	world.update_status()
	Holiday_Game_Start()

	message_admins("<span class='notice'>ADMIN: Event: [key_name(src)] force-set Holiday to \"[Holiday]\"</span>")
	log_admin("[key_name(src)] force-set Holiday to \"[Holiday]\"")


//Run at the  start of a round
/proc/Holiday_Game_Start()
	if(Holiday.len != 0)
		var/list/holidays = list()
		var/list/holiday_blurbs = list()
		for(var/p in Holiday)
			holidays.Add(p)
			holiday_blurbs.Add("[Holiday[p]]")
		var/holidays_string = english_list(holidays, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )
		to_world("<font color='blue'>and...</font>")
		to_world("<h4>Happy [holidays_string] Everybody!</h4>")
		if(holiday_blurbs.len != 0)
			for(var/blurb in holiday_blurbs)
				to_world("<div align='center'><font color='blue'>[blurb]</font></div>")
		switch(Holiday)			//special holidays
			if("Easter")
				//do easter stuff
			if("Christmas Eve","Christmas")
				Christmas_Game_Start()

	return

//Nested in the random events loop. Will be triggered every 2 minutes
/proc/Holiday_Random_Event()
	if(isemptylist(Holiday))
		return 0
	switch(Holiday)			//special holidays
		if("Easter")		//I'll make this into some helper procs at some point
/*			var/list/turf/simulated/floor/Floorlist = list()
			for(var/turf/simulated/floor/T)
				if(T.contents)
					Floorlist += T
			var/turf/simulated/floor/F = Floorlist[rand(1,Floorlist.len)]
			Floorlist = null
			var/obj/structure/closet/C = locate(/obj/structure/closet) in F
			var/obj/item/reagent_containers/food/snacks/chocolateegg/wrapped/Egg
			if( C )			Egg = new(C)
			else			Egg = new(F)
*/
/*			var/list/obj/containers = list()
			for(var/obj/item/storage/S in world)
				if(isNotStationLevel(S.z))	continue
				containers += S

			message_admins("<span class='notice'>DEBUG: Event: Egg spawned at [Egg.loc] ([Egg.x],[Egg.y],[Egg.z])</span>")*/
		if("End of the World")
			if(prob(eventchance))	GameOver()

		if("Christmas","Christmas Eve")
			if(prob(eventchance))	ChristmasEvent()
