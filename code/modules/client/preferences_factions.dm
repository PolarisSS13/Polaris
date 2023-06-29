var/global/list/seen_citizenships = list()
var/global/list/seen_systems = list()
var/global/list/seen_factions = list()
var/global/list/seen_antag_factions = list()
var/global/list/seen_religions = list()

//Commenting this out for now until I work the lists it into the event generator/journalist/chaplain.
/proc/UpdateFactionList(mob/living/carbon/human/M)
	/*if(M && M.client && M.client.prefs)
		seen_citizenships |= M.client.prefs.citizenship
		seen_systems      |= M.client.prefs.home_system
		seen_factions     |= M.client.prefs.faction
		seen_religions    |= M.client.prefs.religion*/
	return

var/global/list/citizenship_choices = list(
	"Solar Confederate Government",
	"Almach Protectorate",
	"Five Arrows",
	"Pearlshield Coalition",
	"Moghes Hegemony",
	"Skrellian Kingdoms",
	"Stateless" //Sol might automatically cover stateless humans/maybe posis but this is probably common for teshari/zaddat and ubiqtuous for drones
	)

var/global/list/home_system_choices = list(
	"Sol",
	"Vir",
	"Alpha Centauri",
	"Tau Ceti",
	"El",
	"New Seoul",
	"Relan",
	"Vounna",
	"Qerr'valis",
	"Rarkajar",
	"Uueoa-Esa",
	"Spacer"
	)

var/global/list/faction_choices = list(
	"Sol Central",
	"Vey Med",
	"Einstein Engines",
	"Free Trade Union",
	"NanoTrasen",
	"Ward-Takahashi GMB",
	"Gilthari Exports",
	"Grayson Manufactories Ltd.",
	"Aether Atmospherics",
	"Zeng-Hu Pharmaceuticals",
	"Hephaestus Industries",
	"Morpheus Cyberkinetics",
	"Xion Manufacturing Group",
	"Hedberg-Hammarstrom",
	"Kaleidoscope Cosmetics",
	"Stealth Assault Enterprises",
	"Proxima Centauri Risk Control"
	)

var/global/list/antag_faction_choices = list(
	"Nos Amis",
	"Russian Mafia",
	"Sampatti",
	"Xin Cohong",
	"Golden Tiger Syndicate",
	"Jaguar Gang",
	"Revolutionary Solar People's Party",
	"Vystholm",
	"Qerr-Glia"
	)

var/global/list/antag_visiblity_choices = list(
	"Hidden",
	"Shared",
	"Known"
	)

var/global/list/religion_choices = list(
	"Unitarianism",
	"Neopaganism",
	"Islam",
	"Christianity",
	"Judaism",
	"Hinduism",
	"Buddhism",
	"Pleromanism",
	"Spectralism",
	"Phact Shintoism",
	"Kishari Faith",
	"Hauler Faith",
	"Nock",
	"Starlit Path",
	"Singulitarian Worship",
	"The Unity",
	"Xilar Qall",
	"Tajr-kii Rarkajar",
	"Agnosticism",
	"Deism"
	)
