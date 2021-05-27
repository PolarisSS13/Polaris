/decl/faction/suzerain/nanotrasen
	name = "NanoTrasen Central Command"
	short_name = "NanoTrasen"
	acronym = "NT"
	desc = "The Company, like many TSCs, have a large number of holdings spread across space. \
	Due to the sheer scale, some decentralization is inevitable, thus the less critical facilities are \
	often granted the privilage of handling the day-to-day operations with a degree of autonomy, \
	so long as nothing goes too wrong, and the cash keeps flowing up to the top."

// The other stations generally exist to give missions. Helping them also improves opinion with NT overall.
/decl/faction/holding/northern_star
	name = "NCS Northern Star"
	short_name = "Northern Star"
	desc = "The Northern Star is an asteroid colony owned and operated by NanoTrasen, \
	located in the Vir system, orbiting a gas giant called Kara, among many other asteroid \
	installations. It's considered home for a large number of NT employees, who receive substantial \
	discounts in housing and amenities. In recent times, the colony has grown rapidly, outstripping its prior \
	self-sufficiency, and now depends on imports from the outside, preferably from other NT holdings, to reduce costs."
	friends = list(/decl/faction/suzerain/nanotrasen)

/decl/faction/holding/southern_cross
	name = "NLS Southern Cross"
	short_name = "Southern Cross"
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
	essential to modern cloning."
	opinion_equilibrium = 350 // Competitor.
	enemies = list(/decl/faction/corporate/zeng_hu)

/decl/faction/corporate/zeng_hu
	name = "Zeng-Hu Pharmaceuticals"
	short_name = "Zeng-Hu"
	acronym = "ZH"
	desc = "Zeng-Hu is an old TSC, based in the Sol system. Until the discovery of Phoron, Zeng-Hu maintained a stranglehold \
	on the market for medications, and many household names are patentted by Zeng-Hu-- Bicaridyne, Dylovene, Tricordrizine, \
	and Dexalin all came from a Zeng-Hu medical laboratory. Zeng-Hu's fortunes have been in decline as Nanotrasen's near monopoly \
	on phoron research cuts into their R&D and Vey-Med's superior medical equipment effectively decimated their own equipment \
	interests. The three-way rivalry between these companies for dominance in the medical field is well-known and a matter of \
	constant economic speculation."
	opinion_equilibrium = 350 // Due to the rivalry with NT as a whole.
	enemies = list(/decl/faction/corporate/vey_med)

/decl/faction/corporate/ward_takahashi
	name = "Ward-Takahashi General Manufacturing Conglomerate"
	short_name = "Ward-Takahashi"
	acronym = "WT"
	desc = "Ward-Takahashi focuses on the sale of small consumer electronics, with its computers, communicators, \
	and even mid-class automobiles a fixture of many households. Less famously, Ward-Takahashi also supplies most \
	of the AI cores on which vital control systems are mounted, and it is this branch of their industry that has \
	led to their tertiary interest in the development and sale of high-grade AI systems. Ward-Takahashi's economies \
	of scale frequently steal market share from Nanotrasen's high-price products, leading to a bitter rivalry in the \
	consumer electronics market."

/decl/faction/corporate/bishop
	name = "Bishop Cybernetics"
	short_name = "Bishop"
	acronym = "BC"
	desc = "Bishop's focus is on high-class, stylish cybernetics. A favorite among transhumanists (and a bête noire for \
	bioconservatives), Bishop manufactures not only prostheses but also brain augmentation, synthetic organ replacements, \
	and odds and ends like implanted wrist-watches. Their business model tends towards smaller, boutique operations, giving \
	it a reputation for high price and luxury, with Bishop cyberware often rivalling Vey-Med's for cost. Bishop's reputation \
	for catering towards the interests of human augmentation enthusiasts instead of positronics have earned it ire from the \
	Positronic Rights Group and puts it in ideological (but not economic) comptetition with Morpheus Cyberkinetics."
	enemies = list(/decl/faction/corporate/morpheus)

/decl/faction/corporate/morpheus
	name = "Morpheus Cyberkinetics"
	short_name = "Morpheus"
	acronym = "MC"
	desc = "The only large corporation run by positronic intelligences, Morpheus caters almost exclusively to their sensibilities \
	and needs. A product of the synthetic colony of Shelf, Morpheus eschews traditional advertising to keep their prices low and \
	relied on word of mouth among positronics to reach their current economic dominance. Morpheus in exchange lobbies heavily for \
	positronic rights, sponsors positronics through their Jans-Fhriede test, and tends to other positronic concerns to earn them \
	the good-will of the positronics, and the ire of those who wish to exploit them."
	enemies = list(/decl/faction/corporate/bishop)

/decl/faction/corporate/hephaestus
	name = "Hephaestus Industries"
	short_name = "Hephaestus"
	acronym = "HI"
	desc = "Hephaestus Industries is the largest supplier of arms, ammunition, and small millitary vehicles in Sol space. \
	Hephaestus products have a reputation for reliability, and the corporation itself has a noted tendency to stay removed \
	from corporate politics. They enforce their neutrality with the help of a fairly large asset-protection contingent which \
	prevents any contracting polities from using their own materiel against them. SolGov itself is one of Hephaestus' largest \
	bulk contractors owing to the above factors."

/decl/faction/corporate/xion
	name = "Xion Manufacturing Group"
	short_name = "Xion"
	desc = "Xion, quietly, controls most of the market for industrial equipment. Their portfolio includes mining exosuits, \
	factory equipment, rugged positronic chassis, and other pieces of equipment vital to the function of the economy. Xion \
	keeps its control of the market by leasing, not selling, their equipment, and through infamous and bloody patent protection \
	lawsuits. Xion are noted to be a favorite contractor for SolGov engineers, owing to their low cost and rugged design."

/decl/faction/corporate/major_bills
	name = "Major Bill's Transportation"
	short_name = "Major Bill's"
	acronym = "MB"
	desc = "The most popular courier service and starliner, Major Bill's is an unassuming corporation whose greatest asset \
	is their low cost and brand recognition. Major Bill's is known, perhaps unfavorably, for its mascot, Major Bill, \
	a cartoonish military figure that spouts quotable slogans. Their motto is \"With Major Bill's, you won't pay major bills!\", \
	an earworm much of the galaxy longs to forget."

/decl/faction/corporate/free_traders
	name = "Free Traders"
	short_name = "Free Trader"
	desc = "Though less common now than they were in the decades before the Sol Economic Organization took power, \
	independent traders remain an important part of the galactic economy, owing in no small part to protective tarrifs \
	established by the Free Trade Union in the late twenty-forth century."

