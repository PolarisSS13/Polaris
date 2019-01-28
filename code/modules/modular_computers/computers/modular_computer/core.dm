// Used to perform preset-specific hardware changes.
/obj/item/modular_computer/proc/install_default_hardware()
	return 1

// Used to install preset-specific programs
/obj/item/modular_computer/proc/install_default_programs()
	return 1


/obj/item/modular_computer/proc/enable_computer(var/mob/user = null)
	enabled = 1

	//Not so fast!
/*	if(updates)
		handle_updates(FALSE)

	update_icon()

	// Autorun feature
	if(!updates)
		var/datum/computer_file/data/autorun = hard_drive ? hard_drive.find_file_by_name("autorun") : null
		if(istype(autorun))
			run_program(autorun.stored_data)
*/
	if(user)
		ui_interact(user)

/obj/item/modular_computer/New()
	install_default_hardware()
	if(hard_drive)
		install_default_programs()
	. = ..()