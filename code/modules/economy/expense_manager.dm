/obj/machinery/expense_manager
	name = "expense manager"
	desc = "Swipe your ID card to manage expenses for a bank account."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "expense"
	flags = NOBLUDGEON
	req_access = list(access_heads)

	anchored = 1

	var/list/expense_types = list(datum/expense/police, datum/expense/hospital, datum/expense/law)

/obj/machinery/expense_manager/attackby(obj/item/I, mob/user)

	return