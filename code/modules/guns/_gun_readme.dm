/*
	MODULAR/COMPOSITE GUN SYSTEM

	Think of it like Borderlands. Guns are composed of five pieces, these being the barrel,
	body, chamber, grip and stock. Gun size/weight/accuracy/combat values are all calculated
	by combining the aspects of each of these components.

	The barrel determines the maximum bore (caliber) and overall accuracy of the gun. In the case
	of laser weapons this also determines the type of projectile fired.

	The body determines a lot of the physical aspects of the gun (weight, inventory slots).

	The chamber determines the available fire modes, load method, ammo, firing style, etc.

	The grip and stock both modify accuracy and recoil and may increase overall weapon size.

	Each component may belong to a model, which changes the aesthetic and combat aspects of the
	component. Building a gun from components from the same model will give a series of overall
	quality bonuses and may offer unique benefits/mods depending on the manufacturer.

	Accessories can also be installed into guns if the components are compatible with them. These
	will include bayonets, stabilizers, scopes, brass catchers, ammo fabricators, so on, so forth.
	Accessories are limited; only one accessory can be installed per component.

	Guns may be field stripped for parts and rebuilt using other components.

	MODELS

	Models provide cosmetic icons and strings to a gun, as well as a possible set of bonuses due
	to their manufacturer if all components are of the same model.

	An example model:

	/decl/weapon_model/nt/ion
		force_gun_name = "ion rifle" // Override the generated gun name.
		model_name = "NT Mk60-E"     // Show this as the gun model in the desc, along with the below line.
		model_desc = "It's a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. Not the best of its type."

		// Use these icons for model components and ammo overlays accordingly.
		use_icon = 'icons/obj/gun_components/nanotrasen/nt_ion.dmi'
		ammo_indicator_icon = 'icons/obj/gun_components/nanotrasen/nt_ion.dmi'

	MANUFACTURERS

	When all parts of a gun share a model, the gun may recieve manufacturer bonuses and cosmetic information
	according to the appropriate manufacturer datum, as specified in the model datum.

	An example manufacturer:

	/decl/weapon_manufacturer/hesphaistos
		manufacturer_name = "Hesphaistos Industries" // Long-form manufacturer name, used in gun desc.
		manufacturer_short = "HI"                    // Short-form name, used in gun name.

		// This string only appears in the extended information seen in the examine tab when the gun is examined.
		manufacturer_description = "Hesphaistos Industries are one of the largest and oldest weapon manufacturers in human space. \
			Serious and business-like, they have no qualms about supplying their goods to some of the nastiest elements of galactic \
			society. Their weapons are regarded as highly reliable, rugged and tailored towards the needs of professional soldiers or \
			mercenaries."

		accuracy =  1.2      // 20% higher accuracy.
		recoil =    0.8      // 20% lower recoil.
		fire_rate = 1.2      // 20% lower fire delay.
		damage_mod = 1.2     // 20% damage increase.
		weight = 1.5         // 50% weight increase.

		casing_desc = "The casing is green and gold composite plating." // All Hesphaistos models will have this string.


	Modifiers are multiplicative; if they are not null, the corresponding values on the finished gun
	will be multiplied by the value of the modifier.

	ADDING PREBUILT GUN ITEMS:

	Prebuilt (ie. mapped or spawned) weapons require one to four pieces of information. The first
	and most important is the list of components making up the weapon. The second is a model, if
	any, for the components to be produced by. The third/fourth are override icon information and
	are optional; these are solely used for making the object appear properly in the mapper.

	An example premade gun:

	/obj/item/weapon/gun/composite/premade/ion_rifle

		name = "ion rifle"                                    // Will be reset at spawn.
		icon = 'icons/obj/gun_components/previews.dmi'        // As will these.
		icon_state = "ion_gun"                                // Etc.

		set_model = /decl/weapon_model/nt/ion                 // Set the model to this and update
		                                                      // components accordingly at spawn.

		build_components = list(                              // Use the following components.
			/obj/item/gun_component/chamber/laser/rifle/ion,
			/obj/item/gun_component/body/rifle/laser,
			/obj/item/gun_component/barrel/laser/rifle/ion,
			/obj/item/gun_component/grip/rifle/laser,
			/obj/item/gun_component/stock/rifle/laser
			)


*/