// For convenience and easier comparing and maintaining of item prices,
// all these will be defined here and sorted in different sections.

// The item price in credits. atom/movable so we can also assign a price to animals and other things.
/atom/movable/var/price_tag = null
/atom/movable/var/tax_type = null

// The proc that is called when the price is being asked for. Use this to refer to another object if necessary.
/atom/movable/proc/get_item_cost()
	return round(price_tag)

// TAXES

/atom/movable/proc/get_tax()
	return tax_type

/datum/reagent/proc/get_tax()
	return

/datum/reagent/proc/get_item_cost()
	return round(price_tag)

//post tax post gets the "extra" money added that is added from tax

/datum/reagent/proc/post_tax_cost()
	if(!get_tax())
		return 0

	return round(get_tax() * get_item_cost())

/atom/movable/proc/post_tax_cost()
	if(!get_tax())
		return 0

	return round(get_tax() * get_item_cost())

/datum/medical_bill/proc/post_tax_cost()
	if(!get_tax())
		return 0

	return round(get_tax() * get_item_cost())

/datum/law/proc/post_tax_cost()
	if(!get_tax())
		return 0

	return round(get_tax() * get_item_cost())

//***************//
//---Beverages---//
//***************//

/datum/reagent/var/price_tag = null		// This is now price per unit. It gets rounded up to the nearest 10 when get_item_cost() is called.
/datum/reagent/var/tax_type = null


///////////////////
//---Law---------//
//***************//

/datum/law/var/price_tag = null

/datum/law/proc/get_item_cost()
	return fine

/datum/law/proc/get_tax()
	return

///////////////////
//---Med---------//
//***************//

/datum/medical_bill/var/price_tag = null

/datum/medical_bill/proc/get_item_cost()
	return cost

/datum/medical_bill/proc/get_tax()
	return MEDICAL_TAX

// Juices, soda and similar //

/datum/reagent/water
	price_tag = 0.05

/datum/reagent/drink/juice
	price_tag = 0.1

/datum/reagent/toxin/poisonberryjuice
	price_tag = 0.2

/datum/reagent/drink/milk
	price_tag = 0.1

/datum/reagent/drink/soda
	price_tag = 0.2

/datum/reagent/drink/doctor_delight
	price_tag = 0.12

/datum/reagent/drink/nothing
	price_tag = 0.08

/datum/reagent/drink/milkshake
	price_tag = 0.12

/datum/reagent/drink/roy_rogers
	price_tag = 0.14

/datum/reagent/drink/shirley_temple
	price_tag = 0.15

/datum/reagent/drink/arnold_palmer
	price_tag = 0.16

/datum/reagent/drink/collins_mix
	price_tag = 0.16



// Hot Drinks //

/datum/reagent/drink/rewriter
	price_tag = 0.14

/datum/reagent/drink/tea
	price_tag = 0.09

/datum/reagent/drink/coffee
	price_tag = 0.09

/datum/reagent/drink/hot_coco
	price_tag = 0.11

// Dynamic Food/Drink Calculation //


/obj/item/weapon/reagent_containers/get_item_cost()
	var/total_price

	if(reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			total_price += R.price_tag * R.volume

	return round(total_price)

/obj/item/weapon/reagent_containers/get_tax()
	if(reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.get_tax())
				return R.get_tax()



/obj/item/pizzabox
	get_item_cost()
		return get_item_cost(pizza)


//***************//
//----Smokes-----//
//***************//

/obj/item/weapon/storage/box/matches
	price_tag = 1

/obj/item/weapon/flame/lighter
	price_tag = 2

/obj/item/weapon/flame/lighter/zippo
	price_tag = 5

////////////////////
// -- Minerals -- //
////////////////////

/obj/item/stack/get_item_cost()
	var/total_price

	if(reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			total_price += R.price_tag * R.volume

	return round(total_price)


/obj/item/stack/get_tax()
	if(reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.get_tax())
				return R.get_tax()
