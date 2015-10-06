/mob/living
	var/balance = 3 //How many staggers it will take to be knocked down.
	var/max_balance = 3
	var/balance_tick = 0
	var/hide_balance_hud = 1
	var/stop_balance_regen = 0

/mob/living/silicon/robot
	balance = 4
	max_balance = 4

/mob/living/simple_animal
	balance = 2
	max_balance = 2

/mob/living/simple_animal/construct/armoured
	balance = 5
	max_balance = 5

/mob/living/simple_animal/construct/behemoth
	balance = 8
	max_balance = 8

/*
/mob/living/proc/handle_balance()
	return
*/
/mob/living/proc/handle_balance()
	if(balance == max_balance)
		if(!hide_balance_hud)
			balance_tick++
			if(balance_tick >= 10) //If we haven't been staggered in awhile, hide the balance HUD.
				hide_balance_hud = 1
				balance_tick = 0
	else if(balance >= 1 || balance != max_balance)
		hide_balance_hud = 0
		if(stop_balance_regen == 0)
			balance_tick++
			if(balance_tick >= 5)
				balance = min(balance + 1,max_balance)
				balance_tick = 0
	if(balance == 0)
		balance = -1 //This makes us immune to staggering for awhile.
		stop_balance_regen = 1
		spawn(100)
			balance = 1
			stop_balance_regen = 0
			update_balance_hud()

	update_balance_hud()

/mob/living/proc/update_balance_hud()
	return

/mob/living/carbon/human/update_balance_hud()
	if(mind && hud_used)
		if(hide_balance_hud)
			balance_display.invisibility = 101
			return
		else
			balance_display.invisibility = 0
		balance_display.icon_state = "balance[balance]"

/mob/living/silicon/robot/update_balance_hud()
	if(mind && hud_used)
		if(hide_balance_hud)
			balance_display.invisibility = 101
			return
		else
			balance_display.invisibility = 0
		balance_display.icon_state = "balance[balance]"

/mob/living/simple_animal/construct/update_balance_hud()
	if(mind && hud_used)
		if(hide_balance_hud)
			balance_display.invisibility = 101
			return
		else
			balance_display.invisibility = 0
		switch(balance) //Since different constructs use different amounts of balance, and I don't want to make loads of new HUD icons, we need to get creative.
			if(-1) balance_display.icon_state = "balance-1"
			if(0) balance_display.icon_state = "balance0"
			if(1) balance_display.icon_state = "balance1"
			if(2) balance_display.icon_state = "balance5"

/mob/living/simple_animal/construct/armoured/update_balance_hud()
	if(mind && hud_used)
		if(hide_balance_hud)
			balance_display.invisibility = 101
			return
		else
			balance_display.invisibility = 0
		balance_display.icon_state = "balance[balance]"

/mob/living/simple_animal/construct/behemoth/update_balance_hud()
	if(mind && hud_used)
		if(hide_balance_hud)
			balance_display.invisibility = 101
			return
		else
			balance_display.invisibility = 0
		switch(balance)
			if(-1)		balance_display.icon_state = "balance-1"
			if(0)		balance_display.icon_state = "balance0"
			if(1)		balance_display.icon_state = "balance1"
			if(2 to 4)	balance_display.icon_state = "balance2"
			if(5 to 6)	balance_display.icon_state = "balance3"
			if(7)		balance_display.icon_state = "balance4"
			if(8)		balance_display.icon_state = "balance5"