/mob/living
	var/balance = 3 //How many staggers it will take to be knocked down.
	var/max_balance = 3
	var/balance_tick = 0
	var/hide_balance_hud = 1
	var/stop_balance_regen = 0

/mob/living/proc/handle_balance()
	return

/mob/living/carbon/human/handle_balance()
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
			if(balance_tick >= 10)
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
		switch(src.balance)
			if(-1)
				balance_display.icon_state = "balance-1"
			if(0)
				balance_display.icon_state = "balance0"
			if(1)
				balance_display.icon_state = "balance1"
			if(2)
				balance_display.icon_state = "balance2"
			if(3)
				balance_display.icon_state = "balance3"

		balance_display.maptext = "[balance]"