/decl/faction/suzerain/nanotrasen
	name = "NanoTrasen Central Command"
	short_name = "NanoTrasen"
	acronym = "NT"
	desc = "The Company, like many TSCs, have a large number of holdings spread across space. \
	Due to the sheer scale, some decentralization is inevitable, thus the less critical facilities are \
	often granted the privilage of handling the day-to-day operations with a degree of autonomy, \
	so long as nothing goes too wrong, and the cash keeps flowing up to the top."
	enemies = list(/decl/faction/corporate/vey_med, /decl/faction/corporate/zeng_hu)
	favors = list(
		/decl/faction_favor/generic/discount/nanotrasen,
		/decl/faction_favor/nanotrasen/medical_aid,
		/decl/faction_favor/nanotrasen/combat_drones,
		/decl/faction_favor/nanotrasen/bailout
	)

// The other stations generally exist to give missions. Helping them also improves opinion with NT overall.
/decl/faction/holding/northern_star
	name = "NCS Northern Star"
	short_name = "Northern Star"
	acronym = "NS"
	desc = "The Northern Star is an asteroid colony owned and operated by NanoTrasen, \
	located in the Vir system, orbiting a gas giant called Kara, among many other asteroid \
	installations. It's considered home for a large number of NT employees, who receive substantial \
	discounts in housing and amenities. In recent times, the colony has grown rapidly, outstripping its prior \
	self-sufficiency, and now depends on imports from the outside, preferably from other NT holdings, to reduce costs."
	friends = list(/decl/faction/suzerain/nanotrasen)

/decl/faction/holding/southern_cross
	name = "NLS Southern Cross"
	short_name = "Southern Cross"
	acronym = "SC"
	desc = "The Southern Cross is a NanoTrasen owned logistics station that orbits Sif. \
	It helps support distant outposts on the surface of Sif, generally tasked with resource extraction, \
	ranging from mineral wealth to xeno-archaeological artifacts. The strain of having to prop up those \
	outposts has made the Southern Cross rather receptive to assistance from others."
	friends = list(/decl/faction/suzerain/nanotrasen)


/decl/faction/government/virgov
	name = "Vir Governmental Authority"
	short_name = "VirGov"
	acronym = "VGA"
	desc = "The Vir Governmental Authority, often shortened to VirGov, is the sole governing body of the Vir system, \
	and all the planets inside it, including Sif. As the facility operates within Vir, it is under the jurisdiction of the local government, \
	Corporate entities such as Nanotrasen which operate on Sif, in Vir space, or on other bodies in the Vir system must \
	all comply with legislation as determined by the VGA and SolGov."


/decl/faction/corporate/vey_med
	name = "Vey-Medical"
	short_name = "Vey-Med"
	acronym = "VM"
	desc = "Vey-Med is one of the newer TSCs on the block and is notable for being largely owned and opperated by Skrell. \
	Despite the suspicion and prejudice leveled at them for their alien origin, Vey-Med has obtained market dominance in \
	the sale of medical equipment-- from surgical tools to large medical devices to the Oddyseus trauma response mecha \
	and everything in between. Their equipment tends to be top-of-the-line, most obviously shown by their incredibly \
	human-like FBP designs. Vey's rise to stardom came from their introduction of ressurective cloning, although in \
	recent years they've been forced to diversify as their patents expired and NanoTrasen-made medications became \
	essential to modern cloning." // TODO rewrite.
	opinion_equilibrium = 350 // Competitor.
	enemies = list(/decl/faction/suzerain/nanotrasen, /decl/faction/corporate/zeng_hu)
	enemy_opinion_multiplier = 0.3

/decl/faction/corporate/zeng_hu
	name = "Zeng-Hu Pharmaceuticals"
	short_name = "Zeng-Hu"
	acronym = "ZH"
	desc = "Zeng-Hu is an old TSC, based in the Sol system. Until the discovery of Phoron, Zeng-Hu maintained a stranglehold \
	on the market for medications, and many household names are patentted by Zeng-Hu-- Bicaridyne, Dylovene, Tricordrizine, \
	and Dexalin all came from a Zeng-Hu medical laboratory. Zeng-Hu's fortunes have been in decline as Nanotrasen's near monopoly \
	on phoron research cuts into their R&D and Vey-Med's superior medical equipment effectively decimated their own equipment \
	interests. The three-way rivalry between these companies for dominance in the medical field is well-known and a matter of \
	constant economic speculation." // TODO rewrite.
	opinion_equilibrium = 350 // Due to the rivalry with NT as a whole.
	enemies = list(/decl/faction/suzerain/nanotrasen, /decl/faction/corporate/vey_med)
	enemy_opinion_multiplier = 0.3

/decl/faction/corporate/ward_takahashi
	name = "Ward-Takahashi GMC"
	short_name = "Ward-Takahashi"
	acronym = "WT"
	desc = "Ward-Takahashi focuses on the sale of small consumer electronics, with its computers, communicators, \
	and even mid-class automobiles a fixture of many households. Less famously, Ward-Takahashi also supplies most \
	of the AI cores on which vital control systems are mounted, and it is this branch of their industry that has \
	led to their tertiary interest in the development and sale of high-grade AI systems. Ward-Takahashi's economies \
	of scale frequently steal market share from Nanotrasen's high-price products, leading to a bitter rivalry in the \
	consumer electronics market." // TODO rewrite.

/decl/faction/corporate/bishop
	name = "Bishop Cybernetics"
	short_name = "Bishop"
	acronym = "BC"
	desc = "Bishop's focus is on high-class, stylish cybernetics. A favorite among transhumanists (and a bête noire for \
	bioconservatives), Bishop manufactures not only prostheses but also brain augmentation, synthetic organ replacements, \
	and odds and ends like implanted wrist-watches. Their business model tends towards smaller, boutique operations, giving \
	it a reputation for high price and luxury, with Bishop cyberware often rivalling Vey-Med's for cost. Bishop's reputation \
	for catering towards the interests of human augmentation enthusiasts instead of positronics have earned it ire from the \
	Positronic Rights Group and puts it in ideological (but not economic) comptetition with Morpheus Cyberkinetics." // TODO rewrite.
	enemies = list(/decl/faction/corporate/morpheus)

/decl/faction/corporate/morpheus
	name = "Morpheus Cyberkinetics"
	short_name = "Morpheus"
	acronym = "MC"
	desc = "The only large corporation run by positronic intelligences, Morpheus caters almost exclusively to their sensibilities \
	and needs. A product of the synthetic colony of Shelf, Morpheus eschews traditional advertising to keep their prices low and \
	relied on word of mouth among positronics to reach their current economic dominance. Morpheus in exchange lobbies heavily for \
	positronic rights, sponsors positronics through their Jans-Fhriede test, and tends to other positronic concerns to earn them \
	the good-will of the positronics, and the ire of those who wish to exploit them." // TODO rewrite.
	enemies = list(/decl/faction/corporate/bishop)

/decl/faction/corporate/hephaestus
	name = "Hephaestus Industries"
	short_name = "Hephaestus"
	acronym = "HI"
	desc = "Hephaestus Industries is the largest supplier of arms, ammunition, and small millitary vehicles in Sol space. \
	Hephaestus products have a reputation for reliability, and the corporation itself has a noted tendency to stay removed \
	from corporate politics. They enforce their neutrality with the help of a fairly large asset-protection contingent which \
	prevents any contracting polities from using their own materiel against them. SolGov itself is one of Hephaestus' largest \
	bulk contractors owing to the above factors." // TODO rewrite.

/decl/faction/corporate/xion
	name = "Xion Manufacturing Group"
	short_name = "Xion"
	acronym = "XI"
	desc = "Xion, quietly, controls most of the market for industrial equipment. Their portfolio includes mining exosuits, \
	factory equipment, rugged positronic chassis, and other pieces of equipment vital to the function of the economy. Xion \
	keeps its control of the market by leasing, not selling, their equipment, and through infamous and bloody patent protection \
	lawsuits. Xion are noted to be a favorite contractor for SolGov engineers, owing to their low cost and rugged design." // TODO rewrite.

/decl/faction/corporate/major_bills
	name = "Major Bill's Transportation"
	short_name = "Major Bill's"
	acronym = "MB"
	desc = "The most popular courier service and starliner, Major Bill's is an unassuming corporation whose greatest asset \
	is their low cost and brand recognition. Major Bill's is known, perhaps unfavorably, for its mascot, Major Bill, \
	a cartoonish military figure that spouts quotable slogans. Their motto is \"With Major Bill's, you won't pay major bills!\", \
	an earworm much of the galaxy longs to forget." // TODO rewrite.
	influence_name = "BillBucks"

/decl/faction/corporate/free_traders
	name = "Free Traders"
	short_name = "Free Trader"
	acronym = "FT"
	desc = "Though less common now than they were in the decades before the Sol Economic Organization took power, \
	independent traders remain an important part of the galactic economy, owing in no small part to protective tarrifs \
	established by the Free Trade Union in the late twenty-forth century." // TODO rewrite.

/decl/faction/corporate/gilthari
	name = "Gilthari Exports"
	short_name = "Gilthari"
	acronym = "GI"
	desc = "Gilthari is Sol’s premier supplier of luxury goods, specializing in extracting money from the rich and successful. \
	Their largest holdings are in gambling, but they maintain subsidiaries in everything from VR equipment to luxury watches. \
	Their holdings in mass media are a smaller but still important part of their empire." // TODO rewrite.

/decl/faction/corporate/aether
	name = "Aether Atmospherics and Recycling"
	short_name = "Aether"
	acronym = "AE"
	desc = "Aether has found its niche in bulk gas collection and supply. They conduct atmospheric mining of gas giants \
	and sell the products to space colonies throughout the galaxy and to the various low-grade terraforming operations \
	on Sol’s garden worlds. Aether is headquartered on Titan, and the success of this home-grown TSC gives hope to many \
	Titaners who want increased self-reliance for Titan." // TODO rewrite.

/decl/faction/corporate/grayson
	name = "Grayson Manufactories LTD"
	short_name = "Grayson"
	acronym = "GR"
	desc = "Grayson is the largest bulk parts supplier in SolGov space, with significant secondary interests in mining. \
	While unable to obtain total market dominance owing to the ease of setting up competing operations, \
	Grayson’s vertical integration of the market gives them a competitive edge, \
	frequently building factories on the same asteroids they mine out. Many other TSCs have Grayson \
	parts at the beginning of their chain of supply." // TODO rewrite.

/decl/faction/corporate/centauri_provisions
	name = "Centauri Provisions"
	short_name = "Centauri"
	acronym = "CP"
	desc = "Headquartered in Alpha Centauri, Centauri Provisions made a name in the snack-food \
	industry primarily by being the first to focus on colonial holdings. \
	The various brands of Centauri snackfoods are now household names, \
	from SkrellSnaks to Space Mountain Wind to the ubiquitous and edible Bread Tube. \
	Their staying power is legendary, and many spacers have grown up on a mix of their \
	cheap crap and protein shakes." // TODO rewrite.

/decl/faction/corporate/proxima_centauri
	name = "Proxima Centauri Risk Control"
	short_name = "Proxima Centauri"
	acronym = "PCRC"
	desc = "PCRC is the softer, PR-friendlier version of SAARE, specializing in defense and security ops. \
	PCRC is a favorite for those with more money than troops, such as certain colonial governments and other TSCs. \
	Competition with SAARE is fairly low, as PCRC enjoys its reputation because SAARE exists. \
	PCRC is also known for corporate bodyguarding and other low-risk security operations." // TODO rewrite.


/decl/faction/corporate/focal_point
	name = "Focal Point Energistics"
	short_name = "Focal Point"
	acronym = "FP"
	desc = "Focal Point casts a wide net over the various markets relating to electrical power. \
	Primarily catering towards the developing market, they supply both electrical power itself \
	(using a massive fleet of FTL-equipped solar arrays) and the generators, APC control chips, \
	and other amenities that help ensure loyal clientele." // TODO rewrite.
	enemies = list(/decl/faction/corporate/einstein_engines)

/decl/faction/corporate/einstein_engines
	name = "Einstein Engines"
	short_name = "Einstein"
	acronym = "EE"
	desc = "Einstein is an old company that has survived through rampant respecialization. \
	In the age of phoron-powered exotic engines and ubiquitous solar power, \
	Einstein makes its living through the sale of engine designs for power sources it has no \
	access to and emergency fission or hydrocarbon power supplies. Accusations of corporate \
	espionage against research-heavy corporations like NanoTrasen and its chief rival \
	Focal Point are probably unfounded." // TODO rewrite.
	enemies = list(/decl/faction/corporate/focal_point)

/decl/faction/corporate/wulf
	name = "Wulf Aeronautics"
	short_name = "Wulf"
	acronym = "WA"
	desc = "Wulf Aeronautics is the chief producer of transport and hauling spacecraft. \
	A favorite contractor of SolGov, Wulf manufactures most of their diplomatic and logistics craft, \
	and does a brisk business with most other TSCs. \
	The quiet reliance of the economy on their craft has kept them out of the spotlight and \
	uninvolved in other corporations’ back-room dealings." // TODO rewrite.

/decl/faction/corporate/kaleidoscope
	name = "Kaleidoscope Cosmetics"
	short_name = "Kaleidoscope"
	acronym = "KC"
	desc = "The newest TSC on the galactic stage, Kaleidoscope products are already found almost everywhere in human space, \
	with a massive market share in personal care and textile products. Originally known for their high-quality ingredients \
	and natural fibres obtained through genetically modified plants and animals, in recent years the company has \
	branched into the emerging market for cosmetic body modifications, \
	pushing the envelope - or the limit - on what the Five Points allow, and has immediately \
	come under Transgressive Technologies Commission scrutiny." // TODO rewrite.

/decl/faction/media/oculum
	name = "Oculum Broadcast"
	short_name = "Oculum"
	acronym = "OB"
	desc = "Oculum owns approximately 30% of Sol-wide news networks, including microblogging aggregate sites, \
	network and comedy news, and even old-fashioned newspapers. Staunchly apolitical, they specialize in delivering \
	the most popular news available– which means telling people what they already want to hear. \
	Oculum is a specialist in branding, and most people don't know that the reactionary Daedalus Dispatch newsletter \
	and the radically transhuman Liquid Steel webcrawler are controlled by the same organization." // TODO rewrite.

/decl/faction/paramilitary/saare
	name = "Stealth Assault Enterprises"
	short_name = "SAARE" //???
	acronym = "SAE"
	desc = "SAARE have consistently the worst reputation of any TSC. \
	This is because they are a paramilitary group specializing in deniability and secrecy. \
	Although publically they work in asset recovery, they have a substantiated reputation \
	for info-theft and piracy that has lead to them butting heads with the law on more \
	than one occasion. Nonetheless, they are an invaluable part of the Solar economy, \
	and other TSCs and small colonial governments keep them in business." // TODO rewrite.
	opinion_equilibrium = 350