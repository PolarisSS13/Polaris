//////// CRIMINAL LAWS //////////

/datum/law/criminal/eluding
	name = "Fleeing & Eluding"
	description = "To non-violently flee from or elude a lawful arrest."

	fine = 460
	cell_time = 6

	notes = "Running, hiding and other nonviolent forms of resisting arrest \
	can be charged with fleeing & eluding. Anything more physical (pushing, \
	disarming resisting cuffs, etc.) should be charged with resisting arrest"



/datum/law/criminal/disorderly
	name = "Disorderly Conduct"
	description = "To act in a way that creates public disturbance or nuisance."

	fine = 430
	cell_time = 5

	notes = "A catch all charge for minor crimes such as littering, \
	yelling obscenities and generally being a dick. Lawful demonstrators \
	can't be charged with this, nor can people speaking about police \
	activities, unless they're exposing sensitive information."


/datum/law/criminal/green
	name = "Procedure Violation (Green)"
	description = "When the code green procedure is not respected."

	fine = 715
	cell_time = 20


/datum/law/criminal/property
	name = "Property Damage"
	description = "To damage or destroy public or private property."

	fine = 860
	cell_time = 20

	notes = "A step up from vandalism, this covers any actual damage done to the \
	property (including synthetics) and maliciously altering its functions."


/datum/law/criminal/dead
	name = "Disrespect to the Dead"
	description = "To abuse or desecrate a corpse."

	fine = 1000
	cell_time = 25


/datum/law/criminal/animal
	name = "Animal Cruelty"
	description = "To willingly and knowingly cause unnecessary death or suffering of an animal."

	fine = 515
	cell_time = 8

	notes = "This charge applies only to unnecessary harm and death. People that kill animals \
	as part of their usual duties (like the chef or the janitor) or those that have sufficient \
	reason to kill (dispatching rodents or protecting a life) should not be charged with this \
	as long as their means of dispatching animals is fairly humane."



/datum/law/criminal/violation
	name = "Violation of Privacy Laws"
	description = "To invade a person’s privacy, share or access personal \
	information protected by privacy laws without a proper reason."
	fine = 715
	cell_time = 15

	notes = "Your personal records (security, medical and employment), confidential \
	information passed toyour doctor or lawyer as well as your identification card, \
	personal items and property are protected by the Polluxian privacy laws. \
	Spreading suchinformation without your approval,neglecting to properly \
	secure it fallsunder this charge as well as unauthorized searches of \
	your personal property. If a police officer is theoffender, refer \
	to Abuse of Police Powers."


/datum/law/criminal/injuction
	name = "Injunction"
	description = " To violate the terms of a legally filed injunction."
	fine = 715
	cell_time = 15

	notes = "The injunction should be authorized by the judged and handed in \
	a written form to the subject of injunction for it to take legal power."


/datum/law/criminal/theft
	name = "Theft"
	description = "To dishonestly appropriate property of estimated collective value \
	over 400 credits belonging to another person or organisation."
	fine = 970
	cell_time = 24

	notes = "Note that taking items that are meant for public use all for yourself \
	is also considered theft even if you normally have access to them. For example \
	a doctor bagging all the aid kits from the hospital storage would be committing a crime."



/datum/law/criminal/traffic
	name = "General Traffic Violation"
	description = "To disregard traffic safety guidelines."
	fine = 715
	cell_time = 30

	notes = "Speeding, driving on the opposite side of the road, blowing red lights, \
	parking inappropriately, driving while impaired, jaywalking. If it creates a risk \
	on the road it can be considered a \"General Traffic Violation\"."

/datum/law/criminal/gta
	name = "Grand Theft Auto"
	description = "To steal or otherwise unlawfully acquire a vehicle one does not \
	have the ownership right to."
	fine = 740
	cell_time = 16

	notes = "Make sure the car wasn't handed to the suspect before you charge them with GTA."


/datum/law/criminal/id
	name = "Failure to Produce Identification"
	description = "To fail to present a valid form of identification upon a lawful request a \
	representative of local or federal authorities."
	fine = 430
	cell_time = 5

	notes = "An officer asking you to produce your identification should provide a \
	reasonable cause for it if requested. Failure to do by the officer is stepping on your \
	privacy and can be considered a \"Violation of Privacy Laws\"."


/datum/law/criminal/force
	name = "Excessive Use of Force"
	description = "To use more than a necessary amount of force in self defense."
	fine = 860
	cell_time = 20

	notes = "It applies instead of \"Assault\" or \"Assault with a Deadly Weapon\" when a suspect \
	had a reasonable cause to be engaging with another person. Note that severe cases (Ones that \
	end in death or near death) can still be charged with \"Manslaughter\" or even \"Murder\". If a \
	police officer is the offender, refer to Abuse of Police Powers."

/datum/law/criminal/contraband
	name = "Possession of Contraband"
	description = "To be in possession of items controlled or banned by law without proper authorization."
	fine = 715
	cell_time = 15

	notes = "The exceptions are items that the person is required to be in posession of due to the \
	specifics of their profession (like the drugs inside of chemistry lab) \
	although carrying them out of the workplace is discouraged."

/datum/law/criminal/contraband_d
	name = "Contraband with Intent to Distribute"
	description = "To be in possession of items controlled or banned by law without proper authorization \
	with intent to distribute"
	fine = 860
	cell_time = 20

	notes = "To be in possession of items controlled or banned by law without proper authorization \
	with intent to distribute A quantity is usually a good tell. A handful of drug pills is a \
	believable amount for personal use. When it's a bag full of pills chances are the person \
	is probably trying to sell them. 200 credits fine. 20 mins them."

/datum/law/criminal/fraud
	name = "Fraud & Embezzlement"
	description = "To use deliberate deception in order to take advantage of other person or organization."
	fine = 1085
	cell_time = 28

/datum/law/criminal/justice
	name = "Obstruction of Justice"
	description = "To pervert, impede or obstruct the due administration of justice."
	fine = 860
	cell_time = 20

	notes = "Lying to law enforcement officers, tampering with evidence, trespassing on crime scenes, \
	loitering near crime scenes when told to leave, interference or failure to cooperate with lawful \
	actions or requests of law enforcement officers are all examples of what could qualify as obstruction of justice."


/datum/law/criminal/parental
	name = "Neglect of Parental Duties"
	description = "To fail to uphold a reasonable standard of care for a child as that child’s legal guardian."
	fine = 570


/datum/law/criminal/reckless
	name = "Reckless Endangerment"
	description = "To act in a way that creates a risk of potential serious physical injury to another \
	person while disregarding the foreseeable consequences of one’s actions."
	fine = 715

/datum/law/criminal/inciting
	name = "Inciting an Unlawful Demonstration"
	fine = 1140
	cell_time = 30

	description = "Inciting, or attempting to incite, an unlawful demonstration."
	notes = "If a Non-Pollux citizen incites any demonstration, lawful or not, they can be charged with this."

/datum/law/criminal/demo
	name = "Participating in an Unlawful Demonstration"
	fine = 1430
	cell_time = 45

	description = "Participating in any organized demonstration that interferes with the operation of \
	civil services or personnel, has an undue impact on uninvolved people, causes property damage during \
	the course of the demonstration, or is rallying toward an unlawful goal."

	notes = "A protest calling for a law to be changed isn't unlawful, a protest calling for that law to \
	be broken, or breaking that law, is. Radio spam, harassing passersby, blocking roads, etc. is considered \
	undue impact. Non-Pollux citizens participating in demonstrations may be charged with this, whether the \
	demonstration is lawful or not."

/datum/law/criminal/trespass
	name = "Trespassing in a Secure Area."
	description = "To unlawfully access a high security area, including police property, government facilities, or high value storage."

	notes= "Entering the armory, mayor's office, government buildings, prison, or the vault, etc. falls under this."
	fine = 1140
	cell_time = 30

/datum/law/criminal/misconduct
	name = "Weapon Handling Misconduct"
	description = "Any citizen of Pollux with a valid weapon permit found to be committing a crime with it or not following proper concealment protocol for said weapon can be charged for this. \
	After three strikes, counting repeat offender price/timer modifiers, the weapon permit shall be hereby null and the weapon confiscated."

	fine = 1570
	cell_time = 30
	
/datum/law/criminal/impersonating_city
	name = "Impersonating City Officials"
	description = "To impersonate a member of city council, law enforcement, or health personnel."

	fine = 1140
	cell_time = 30
	
/datum/law/criminal/contempt
	name = "Contempt of Court"
	description = "To be disrespectful towards the Court of law, in the form of \
	behaviour that defies the authority, justice and dignity of the Court."

	fine = 650
	cell_time = 20
