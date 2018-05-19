//Just made this a child of the AI eye because it's a lot easier
//Than making a whole new eye itself.
/mob/hacker
	name = "Hacker"
	desc = "You cannot read this."
	icon = 'icons/effects/static.dmi'
	icon_state = "hacker_static"

//Basically a copy/paste from the AI eye code.

/mob/hacker/proc/destroy_eyeobj(var/atom/new_eye)
	if(!eyeobj) return
	if(!new_eye)
		new_eye = src
	eyeobj.owner = null
	qdel(eyeobj)
	eyeobj = null
	if(client)
		client.eye = new_eye

/mob/hacker/proc/create_eyeobj(var/newloc)
	if(eyeobj) destroy_eyeobj()
	if(!newloc) newloc = src.loc
	eyeobj = new /mob/observer/eye/aiEye/hacker(newloc)
	eyeobj.owner = src
	eyeobj.name = "[src.name] (Hacker Eye)" // Give it a name
	if(client) client.eye = eyeobj

/mob/hacker/New()
	..()
	create_eyeobj()
	spawn(5)
		if(eyeobj)
			eyeobj.loc = src.loc

/mob/hacker/Destroy()
	destroy_eyeobj()
	return ..()

/mob/hacker/proc/toggle_acceleration()
	set category = "Hacker Settings"
	set name = "Toggle Camera Acceleration"

	if(!eyeobj)
		return

	eyeobj.acceleration = !eyeobj.acceleration
	to_chat(usr, "Camera acceleration has been toggled [eyeobj.acceleration ? "on" : "off"].")

/mob/observer/eye/aiEye/hacker
	name = "Hacker's Eye"
	icon_state = "hacker-eye"

	var/examine_time = 10

/mob/observer/eye/aiEye/hacker/examinate(mob/user)
	..()