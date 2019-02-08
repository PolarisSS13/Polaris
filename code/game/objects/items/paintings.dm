//The paintings in the following list are those that have a chance to be bought in merch computers, or to appear when spawned randomly.
var/list/available_paintings = list(
	"duck",
	"mario",
	"gradius",
	"kudzu",
	"dwarf",
	"xenolisa",
	"bottles",
	"aymao",
	"flowey",
	"sunset",
	"Flowereater",
	"Sadclown",
	"hospital",
	"prophecy",
	"Mime",
	"wizard",
	"bland",
	"Blu",
	"Kate",
	"jmwt0",
	"jmwt1",
	"jmwt2",
	"jmwt3",
	"jmwt4",
	"starry",
	"desert",
	"still",
	"snowy",
	"wave",
	"dogpoker",
	"persistance",
	"sonman",
	"thescream",

	)
	//The following paintings either appear under certain conditions or have to be varedited by admins
	//"narsie", transformed from other paintings by Nar-Sie. Has a chance to spawn on the asteroid in temple ruins.
	//"justice", spawned in the courtroom/IAA office if there is no courtroom
	//"blank", crafted with wood, TODO: give a way to players to paint on them
	//"anatomy", TODO: add one in medbay/surgery.
	//"daddy", TODO: well it's not a painting...so make it its own item...?

/obj/structure/painting
	name = "painting"
	desc = "A blank painting."
	icon = 'icons/obj/paintings.dmi'
	icon_state = "item"
	item_state = "painting"
	anchored = 1
	burn_state = 0 //Buuuurn baby burn. Disco inferno!
	burntime = SHORT_BURN
//	flags = FPRINT
//	w_type = RECYK_WOOD
//	frame_material = /obj/item/stack/sheet/wood
//	sheets_refunded = 2
//	autoignition_temperature = AUTOIGNITION_WOOD
	var/paint = ""

/obj/structure/painting/New()
	..()
	pixel_y = 32

	update_painting()

/obj/structure/painting/proc/update_painting()
	switch(paint)
		if("narsie")
			name = "\improper Papa Narnar"
			desc = "A painting of Nar-Sie. You feel as if it's watching you."
		if("monkey")
			name = "\improper Mr. Deempisi portrait"
			desc = "Under the painting is a small plaque. It reads: 'While the meat grinder may not have spared you, fear not. Not one part of you has gone to waste... You were delicious.'"
		if("duck")
			name = "\improper Duck"
			desc = "A painting of a duck. It has a crazed look in its eyes. You can almost imagine him asking you for some grapes."
		if("mario")
			name = "\improper Mario and Coin"
			desc = "A painting of an italian plumber and an oversized golden plate. Apparently he's a video game mascot of sorts."
		if("gradius")
			name = "\improper Vic Viper"
			desc = "A painting of a space ship. It makes you feel like diving right into an alien base and releasing your blasters right onto its core."
		if("justice")
			name = "\improper Justice"
			desc = "A painting of a golden scale. These are often found within courtrooms."
		if("kudzu")
			name = "\improper Scythe on Kudzu"
			desc = "A painting of a scythe and some vines."
		if("dwarf")
			name = "\improper Dwarven Miner"
			desc = "A painting of a dwarf. He's mining adamantine; a long lost, high-value metal that was said to be impossibly lightweight, strong, and sharp. The craftsmanship of this painting is of the utmost quality."
		if("xenolisa")
			name = "\improper Xeno Lisa"
			desc = "A painting of a xenomorph queen wearing some human clothing. The hands are particularly well-painted."
		if("bottles")
			name = "\improper Bottle and Bottle"
			desc = "A painting of two glass bottles filled with blue and red liquids. You can almost feel the intensity of the artistic discussions that led to this creation."
		if("aymao")
			name = "\improper Ay Mao"
			desc = "A painting of the glorious leader of the Grey Democratic Republic. He looks dignified, and a bit high too."
		if("flowey")
			name = "\improper Flowey the Flower"
			desc = "A painting of your best friend. Who's also a SERIAL MURDERER."
		if("sunset")
			name = "\improper Path toward the Sunset"
			desc = "A painting by D.T.Link. The colours fill you with hope and determination."
		if("Flowereater")
			name = "\improper Blumenliebhaber"
			desc = "A painting by Guertena Weiss. An odd painting that fills you with hesitation. It's said you can hear cackling at night wherever it's hung."
		if("Sadclown")
			name = "\improper Pagliacci"
			desc = "A morose painting of a sad clown. Is it possible that beneath that cheerful latex mask lays a somber and tired heart? Probably not."
		if("hospital")
			name = "\improper Kattelox Hospital"
			desc = "A painting depicting a compact but efficient hospital. The red really helps make the otherwise drab pallete pop."
		if("prophecy")
			name = "\improper Prophetic Mural"
			desc = "A copy of an ancient mural. It depicts a blue armored warrior fighting off an inhuman monstrosity. It's said that many still wait for its conclusion."
		if("anatomy")
			name = "\improper Anatomy Poster"
			desc = "A NT approved anatomy poster! Remember, eat a burger every 20-30 minutes. For your health."
		if("Mime")
			name = "\improper Pretentious Mime Painting"
			desc = "There are no words to describe this painting."
		if("wizard")
			name = "\improper Nauseating Glow in the Dark Velvet Wizard Poster"
			desc = "Oh god he's looking right at me, what do I do what do I do!?"
		if("bland")
			name = "\improper Pitcher and Orange"
			desc = "A painfully standard painting, used to decorate dining rooms and bathrooms alike."
		if("Blu")
			name = "\improper Wai-Blu"
			desc = "Faithfully serving Nanotrasen during her shift, gladly serving YOU after."
		if("Kate")
			name = "\improper Cindy Kate"
			desc = "Through the carnage and bloodshed she's gunning for you, champ."
		if("jmwt0")
			name = "\improper Self-portrait"
			desc = "Under the painting is a small plaque. It reads: Joseph Mallord William Turner - 1799"
		if("jmwt1")
			name = "\improper Snow Storm - Steam-Boat off a Harbour's"
			desc = "Under the painting is a small plaque. It reads: Joseph Mallord William Turner - 1842"
		if("jmwt2")
			name = "\improper Zurich"
			desc = "Under the painting is a small plaque. It reads: Joseph Mallord William Turner - 1842"
		if("jmwt3")
			name = "\improper The fighting Temeraire"
			desc = "Under the painting is a small plaque. It reads: Joseph Mallord William Turner - 1838"
		if("jmwt4")
			name = "\improper Snow Storm - Steam-Boat off a Harbour's"
			desc = "Under the painting is a small plaque. It reads: Joseph Mallord William Turner - 1817"
		if("daddy")
			name = "\improper I <3 Daddy!"
			desc = "'Nanotrasen respects the right for all associates and their families to be able to express their individuality though many media. However, soliciting Nanotrasen related merchandise without proper warrant is strictly prohibited. Luckily for you, you can now own your very own contraband Nanotrasen merch without the threat of *REDACTED*!'"
		if("carp")
			name = "\improper 'Singing' Mounted Carp"
			desc = "Too unrobust to beat a carp to death with your bare hands and mount it on a plank of wood? Then this professionally taxidermied trophy is just for you! Note: Does not actually sing."
		if("starry")
			name = "\improper beautiful landscape painting"
			desc = "A beautiful painting with swirling stars and a twisting skyline."
		if("desert")
			name = "\improper desert painting"
			desc = "A painting of what appears to be bones cast out in the desert, it looks quite melancholy and haunting..."
		if("still")
			name = "\improper still-life painting"
			desc = "A painting that shows what appears to be fruit on a table in great detail."
		if("snowy")
			name = "\improper snowy painting"
			desc = "A calming picture of a cabin surronded by velvety snow."
		if("wave")
			name = "\improper tidal wave painting"
			desc = "A painting of a huge wave, written in an old ancient language you cannot seem to understand."
		if("dogpoker")
			name = "\improper Dogs Playing Poker"
			desc = "A painting of some dogs playing poker... is that Ian?"
		if("persistance")
			name = "\improper surreal painting"
			desc = "A surreal painting focusing on clocks melting into the landscape, almost trippy to look at."
		if("sonman")
			name = "\improper surreal potrait"
			desc = "A strange surreal painting of a man with an apple for a face. Sounds like something Botany would do."
		if("thescream")
			name = "\improper eerie painting"
			desc = "An odd picture showing a figure with his hands clasped over his face, screaming in a cacophony of agony, disturbing"



		else
			name = "painting"
			desc = "A blank painting."



/obj/structure/painting/blank
	paint = "blank"

/obj/structure/painting/cultify()
	new /obj/structure/painting/narsie(loc)
	update_painting()
	..()

/obj/structure/painting/narsie
	paint = "narsie"

/obj/structure/painting/narsie/cultify()
	return


/obj/structure/painting/random/New()
	..()
	icon_state = pick(available_paintings)
	update_painting()




/obj/structure/painting/hospital/New()
	paint = "hospital"
	icon_state = "hospital"
	..()
