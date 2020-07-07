






/obj/item/weapon/technomancer_core/proc/get_spell_metadata(spell_meta_path)
	var/datum/spell_metadata/meta = spell_metas[spell_meta_path]
	if(!istype(meta))
		return FALSE
	return meta



//Resonance Aperture

//Variants which the wizard can buy.







// Using this can result in abilities costing less energy.  If you're lucky.
/obj/item/weapon/technomancer_core/recycling
	name = "recycling core"
	desc = "A bewilderingly complex 'black box' that allows the wearer to accomplish amazing feats.  This type tries to recover \
	some of the energy lost from using functions due to inefficiency."
	energy = 12000
	max_energy = 12000
	regen_rate = 40 //300 seconds to full
	instability_modifier = 0.6
	energy_cost_modifier = 0.8

/obj/item/weapon/technomancer_core/recycling/pay_energy(amount)
	var/success = ..()
	if(success)
		if(prob(30))
			give_energy(round(amount / 2))
			if(amount >= 50) // Managing to recover less than half of this isn't worth telling the user about.
				to_chat(wearer, "<span class='notice'>\The [src] has recovered [amount/2 >= 1000 ? "a lot of" : "some"] energy.</span>")
	return success



