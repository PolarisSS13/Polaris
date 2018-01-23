/obj/item/weapon/implant/bear
	name = "bear implant"
	desc = "Make bears pop out of an individual."
	implant_color = "r"
	var/phrase = "supercalifragilisticexpialidocious"
	var/num_of_bears = 3

/obj/item/weapon/implant/bear/implanted(mob/source as mob)
	phrase = input("Choose activation phrase:") as text
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	phrase = replace_characters(phrase, replacechars)
	usr.mind.store_memory("Bear implant in [source] can be activated by saying something containing the phrase ''[src.phrase]'', <B>say [src.phrase]</B> to attempt to activate.", 0, 0)
	usr << "The implanted bear implant in [source] can be activated by saying something containing the phrase ''[src.phrase]'', <B>say [src.phrase]</B> to attempt to activate."
	listening_objects |= src
	return 1

/obj/item/weapon/implant/bear/hear_talk(mob/M as mob, msg)
	hear(msg)
	return

/obj/item/weapon/implant/bear/hear(var/msg)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	msg = replace_characters(msg, replacechars)
	if(findtext(msg,phrase))
		activate()
		qdel(src)

/obj/item/weapon/implant/bear/activate()
	if(malfunction == MALFUNCTION_PERMANENT)
		return
	if(istype(imp_in, /mob/))
		var/mob/T = imp_in
		message_admins("Bear implant triggered in [T] ([T.key]). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>) ")
		log_game("Bear implant triggered in [T] ([T.key]).")
		T.visible_message("<span class='warning'>Something growls inside [T][part ? "'s [part.name]" : ""]!</span>")
		playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
		sleep(25)
		for(var/i = 0, i < num_of_bears, i++)
			new /mob/living/simple_animal/hostile/bear(get_turf(T))
		if(prob(90))
			T.gib()

/obj/item/weapon/implant/bear/emp_act(severity)
	if(malfunction)
		return

	malfunction = MALFUNCTION_TEMPORARY

	switch(severity)
		if(1)
			if(prob(50))
				activate()
			else
				meltdown()

		if(2)
			if(prob(20))
				activate()
			else
				meltdown()

		if(3)
			if(prob(5))
				activate()

		if(4)
			if(prob(1))
				activate()

	spawn(20)
		malfunction--


/obj/item/weapon/implant/bear/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Bear Spawner<BR>
<b>Life:</b> one use<BR>
<b>Important Notes:</b> <font color='red'>Bears attack anyone in sight. The implant is also illegal.</font><BR>
<HR>
<b>Implant Details:</b> <BR>
<b>Function:</b> Emits specialized chemicals that link together to form bears.<BR>
<b>Special Features:</b><BR>
<i>Neuro-Scan</i>- Analyzes certain shadow signals in the nervous system<BR>
<b>Integrity:</b> Bear have a high chance to completely decimate the person who is implanted.<HR>
No Implant Specifics"}
	return dat

/obj/item/weapon/implant/bear/islegal()
	return 0