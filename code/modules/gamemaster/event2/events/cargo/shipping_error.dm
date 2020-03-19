/datum/event2/meta/shipping_error
	name = "shipping error"
	departments = list(DEPARTMENT_CARGO)
	chaos = -10 // A helpful event.
	reusable = TRUE
	event_type = /datum/event2/event/shipping_error

/datum/event2/meta/shipping_error/get_weight()
	return metric.count_people_in_department(DEPARTMENT_CARGO) * 40

/datum/event2/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	O.object = supply_controller.supply_pack[pick(supply_controller.supply_pack)]
	O.ordered_by = random_name(pick(MALE,FEMALE), species = "Human")
	supply_controller.shoppinglist += O
