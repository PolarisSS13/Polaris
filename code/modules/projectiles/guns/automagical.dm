//True automagic gun modes. Dakka dakka.
//A significant portion of this code was donated by Mport from SS:CM

//This is used by guns shooting in automatic mode
/obj/screen/auto_target
	name = "targeter"
	icon = null//We dont want people to see this guy
	density = 0
	anchored = 1
	var/obj/item/weapon/gun/gun
	var/active = 0//Just tells us that it was clicked on so we should start shooting
	var/delay_del = 0//Delays the del if we retarget without shooting

	New(loc, var/obj/item/weapon/gun/G)
		..()
		gun = G
		var/image/I = image('icons/effects/Targeted.dmi', src, "locked")
		I.override = 1
		usr << I
		//autodel() //Currently doesn't really work right.
		return

	CanPass()//Everything should ignore this guy and just pass by
		return 1

	//Used to get rid of this if they target but dont actually shoot or stop shooting (no ammo) yet are still dragging us around
/obj/screen/auto_target/proc/autodel()
	set waitfor=0
	if(active == 1)
		return
	sleep(20)
	if(!src) return//Might not really be needed
	if(delay_del)//This says we want to wait another X seconds before trying to del
		delay_del = 0
		autodel()
		return
	if(gun.shooting == 0)
		del(src)
	else
		autodel()//Yes in theory this could hit the inf loop
	return

	//When the player clicks on the target it will disable the autodel and tell the gun to shoot
/obj/screen/auto_target/MouseDown(location,control,params)
	active += 1//Tell the autodel that we are actually using this now
	if(gun.shooting == 0)//If we are not shooting start shooting, we need this here or they have to drag to a new turf before it starts shooting, felt weird
		gun.Fire(loc, usr, params)
	return

	//Called when they drag the object somewhere else
	//If its not already shooting (should be though due to the above, but this does let it click at you when it runs dry) then start shooting,
/obj/screen/auto_target/MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
	if(gun.shooting == 0)//If we are not shooting start shooting
		gun.Fire(loc, usr, params)
	if(over_location != loc)//This updates the loc to our new location when we drag it to a new turf
		loc = over_location
	if((usr.get_active_hand() != gun))
		del(src)

	//This gets rid of us when they let go of the click, but only after they actually drag the target to a new turf which is why the below also has to exist
/obj/screen/auto_target/MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
	del(src)
	return
	//This is needed so if they just MouseDown and then let go it will stop shooting, otherwise we stick around till they run out of bullets
/obj/screen/auto_target/MouseUp(object,location,control,params)
	del(src)
	return
/*

//This pseudo code is being left in place to serve as references to the modifications to gun.dm, the Fire() proc, and the afterattack() proc. -k22
//Code donated by Mport.



//In our gun afterattack() when we want to use full auto we make sure we can shoot
//Then if we dont have a targeter in play we create one
//Should we already have one in play then we just update its

/GUNTYPEPATHHERE

    //This just holds a ref to any auto_target object we have, this is used for automatic fire
    var/obj/screen/auto_target/auto_target


    afterattack(atom/A, mob/living/user, flag, params)
        //OTHER CODE HERE mainly sanity
        if(FIREMODE_IS_AUTOMATIC)//Are we are going to be using automatic shooting
            //We check to make sure they can fire
            if(!CAN_WE_FIRE_PROC(user)) return//Need this here so the icon doesnt show up when they cant actually shoot

            //NOTE: dono if you have this var but we keep track of when we shot the gun last to figure out when we can shoot again
            last_fired = 0//Reset this so they can start shooting right away, have to do it as we set our last_fired in our "CAN_WE_FIRE_PROC" proc

            if(auto_target)//If they already have one then update it
                auto_target.loc = get_turf(A)
                auto_target.delay_del = 1//And reset the del so its like they got a new one and doesnt instantly vanish
                user << "\blue You ready \the [src]!  Click and drag the target around to shoot."
            else//Otherwise just make a new one
                auto_target = new/obj/screen/auto_target(get_turf(A), src)
            user << "\blue You ready \the [src]!  Click and drag the target around to shoot."
            return
        //You want the above code to prevent regular shooting
        //OTHER FIRING CODE HERE


//In the actual proc where the shooting is going to happen
//In ours this is where we are checking how many shots we should fire, we can set burst to any number
    if(auto_target && auto_target.active)//When we are going to shoot and have an auto_target AND its active meaning we clicked on it we tell it to burstfire 1000 rounds
        VAR_FOR_HOW_MANY_TO_SHOOT = 1000//Yes its not EXACTLY full auto but when are we shooting more than 1000 normally and it can easily be made higher

//In our for loop that runs 0 to how many bullets we are going to shoot

    if(FIREMODE_IS_AUTOMATIC)//If we are shooting automatic then check our target
        if(!auto_target) break//Stopped shooting
        //Otherwise if the targeter loc change then update the turf/target we are shooting at
        if(auto_target.loc != TURF_WE_ARE_SHOOTING)
            TURF_WE_ARE_SHOOTING = auto_target.loc
        //Lastly just update our dir if needed
        if(user.dir != get_dir(user, auto_target))
            user.face_atom(auto_target)
*/