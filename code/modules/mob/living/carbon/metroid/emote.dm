/mob/living/carbon/slime/emote(var/act, var/m_type=1, var/message = null)
	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		//param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/updateicon = 0

	switch(act) //Alphabetical please
		if("bounce")
			message = "<B>[src]</B> bounces in place."
			m_type = 1

		if("jiggle")
			message = "<B>[src]</B> jiggles!"
			m_type = 1

		if("light")
			message = "<B>[src]</B> lights up for a bit, then stops."
			m_type = 1

		if("moan")
			message = "<B>[src]</B> moans."
			m_type = 2

		if("shiver")
			message = "<B>[src]</B> shivers."
			m_type = 2

		if("sway")
			message = "<B>[src]</B> sways around dizzily."
			m_type = 1

		if("twitch")
			message = "<B>[src]</B> twitches."
			m_type = 1

		if("vibrate")
			message = "<B>[src]</B> vibrates!"
			m_type = 1

		if("nomood")
			mood = null
			updateicon = 1

		if("pout")
			mood = "pout"
			updateicon = 1

		if("sad")
			mood = "sad"
			updateicon = 1

		if("angry")
			mood = "angry"
			updateicon = 1

		if("frown")
			mood = "mischevous"
			updateicon = 1

		if("smile")
			mood = ":3"
			updateicon = 1

		if("help") //This is an exception
			to_chat(src, "Help for slime emotes. You can use these emotes with say \"*emote\":\n\nbounce, custom, jiggle, light, moan, shiver, sway, twitch, vibrate. You can also set your face with: \n\nnomood, pout, sad, angry, frown, smile")

	if(message && !stat)
		..(act, m_type, message)