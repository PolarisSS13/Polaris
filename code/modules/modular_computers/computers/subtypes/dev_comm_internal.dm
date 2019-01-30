//An internal modular computer for the communicator.

/obj/item/modular_computer/communicator_internal
	name = "integrated communicator computer"
	desc = "A computer integrated into a communicator."
	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 1

	var/obj/item/device/communicator/communicator = null

/obj/item/modular_computer/communicator_internal/install_default_hardware()
	..()
//	processor_unit = new /obj/item/weapon/computer_hardware/processor_unit/small(src)
//	tesla_link = new /obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new /obj/item/weapon/computer_hardware/hard_drive/micro(src)
	network_card = new /obj/item/weapon/computer_hardware/network_card(src)
	battery_module = new /obj/item/weapon/computer_hardware/battery_module/nano(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/communicator_internal/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/chatclient())

/obj/item/modular_computer/communicator_internal/New(obj/item/device/communicator/parent_communicator)
	communicator = parent_communicator
	forceMove(communicator)
	..()

/obj/item/modular_computer/communicator_internal/Destroy()
	communicator = null
	. = ..()

/obj/item/modular_computer/communicator_internal/nano_host()
	return communicator