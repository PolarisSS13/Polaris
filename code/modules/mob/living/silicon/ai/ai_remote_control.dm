/mob/living/silicon/ai
	var/list/connected_robots = list()
	var/mob/living/silicon/robot/deployed_shell = null //For shell control

/mob/living/silicon/ai/proc/deploy_to_shell(var/mob/living/silicon/robot/target)
	set category = "AI Commands"
	set name = "Deploy to Shell"

	if(incapacitated())
		return

	if(control_disabled)
		to_chat(src, span("warning", "Wireless networking module is offline."))
		return

	var/list/possible = list()

	for(var/borgie in GLOB.available_ai_shells)
		var/mob/living/silicon/robot/R = borgie
		if(R.shell && !R.deployed && (R.stat != DEAD) && (!R.connected_ai || (R.connected_ai == src) ) )
			possible += R

	if(!LAZYLEN(possible))
		to_chat(src, span("warning", "No usable AI shell beacons detected."))

	if(!target || !(target in possible)) //If the AI is looking for a new shell, or its pre-selected shell is no longer valid
		target = input(src, "Which body to control?") as null|anything in possible

	if(!target || target.stat == DEAD || target.deployed || !(!target.connected_ai || (target.connected_ai == src) ) )
		return

	else if(mind)
	//	soullink(/datum/soullink/sharedbody, src, target)
		deployed_shell = target
		target.deploy_init(src)
		mind.transfer_to(target)

/mob/living/silicon/ai/verb/deploy_to_shell_act()
	set category = "AI Commands"
	set name = "Deploy to Shell"

	deploy_to_shell() // This is so the AI is not prompted with a list of all mobs when using the 'real' proc.
/*
/mob/living/silicon/ai/verb/deploy_to_shell(var/mob/living/silicon/robot/target)
	set category = "AI Commands"
	set name = "Deploy to Shell"

	if(incapacitated())
		return
	if(control_disabled)
		to_chat(src, "<span class='warning'>Wireless networking module is offline.</span>")
		return

	var/list/possible = list()

	for(var/borgie in GLOB.available_ai_shells)
		var/mob/living/silicon/robot/R = borgie
		if(R.shell && !R.deployed && (R.stat != DEAD) && (!R.connected_ai ||(R.connected_ai == src)))
			possible += R

	if(!LAZYLEN(possible))
		to_chat(src, "No usable AI shell beacons detected.")

	if(!target || !(target in possible)) //If the AI is looking for a new shell, or its pre-selected shell is no longer valid
		target = input(src, "Which body to control?") as null|anything in possible

	if (!target || target.stat == DEAD || target.deployed || !(!target.connected_ai ||(target.connected_ai == src)))
		return

	else if(mind)
		soullink(/datum/soullink/sharedbody, src, target)
		deployed_shell = target
		target.deploy_init(src)
		mind.transfer_to(target)
	diag_hud_set_deployed()

/mob/living/silicon/ai/proc/disconnect_shell()
	if(deployed_shell) //Forcibly call back AI in event of things such as damage, EMP or power loss.
		to_chat(src, "<span class='danger'>Your remote connection has been reset!</span>")
		deployed_shell.undeploy()
	diag_hud_set_deployed()
*/