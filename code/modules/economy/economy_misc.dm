
#define RIOTS 1
#define WILD_ANIMAL_ATTACK 2
#define INDUSTRIAL_ACCIDENT 3
#define BIOHAZARD_OUTBREAK 4
#define WARSHIPS_ARRIVE 5
#define PIRATES 6
#define CORPORATE_ATTACK 7
#define ALIEN_RAIDERS 8
#define AI_LIBERATION 9
#define MOURNING 10
#define CULT_CELL_REVEALED 11
#define SECURITY_BREACH 12
#define ANIMAL_RIGHTS_RAID 13
#define FESTIVAL 14

#define RESEARCH_BREAKTHROUGH 15
#define BARGAINS 16
#define SONG_DEBUT 17
#define MOVIE_RELEASE 18
#define BIG_GAME_HUNTERS 19
#define ELECTION 20
#define GOSSIP 21
#define TOURISM 22
#define CELEBRITY_DEATH 23
#define RESIGNATION 24

#define DEFAULT 1

#define ADMINISTRATIVE 2
#define CLOTHING 3
#define SECURITY 4
#define SPECIAL_SECURITY 5

#define FOOD 6
#define ANIMALS 7

#define MINERALS 8

#define EMERGENCY 9
#define GAS 10
#define MAINTENANCE 11
#define ELECTRICAL 12
#define ROBOTICS 13
#define BIOMEDICAL 14

#define GEAR_EVA 15


//---- The following corporations are friendly with NanoTrasen and loosely enable trade and travel:
//Corporation NanoTrasen - Generalised / high tech research and phoron exploitation.
//Corporation Vessel Contracting - Ship and station construction, materials research.
//Corporation Osiris Atmospherics - Atmospherics machinery construction and chemical research.
//Corporation Second Red Cross Society - 26th century Red Cross reborn as a dominating economic force in biomedical science (research and materials).
//Corporation Blue Industries - High tech and high energy research, in particular into the mysteries of bluespace manipulation and power generation.
//Corporation Kusanagi Robotics - Founded by robotics legend Kaito Kusanagi in the 2070s, they have been on the forefront of mechanical augmentation and robotics development ever since.
//Corporation Free traders - Not so much a corporation as a loose coalition of spacers, Free Traders are a roving band of smugglers, traders and fringe elements following a rigid (if informal) code of loyalty and honour. Mistrusted by most corporations, they are tolerated because of their uncanny ability to smell out a profit.

//---- Descriptions of destination types
//Space stations can be purpose built for a number of different things, but generally require regular shipments of essential supplies.
//Corvettes are small, fast warships generally assigned to border patrol or chasing down smugglers.
//Battleships are large, heavy cruisers designed for slugging it out with other heavies or razing planets.
//Yachts are fast civilian craft, often used for pleasure or smuggling.
//Destroyers are medium sized vessels, often used for escorting larger ships but able to go toe-to-toe with them if need be.
//Frigates are medium sized vessels, often used for escorting larger ships. They will rapidly find themselves outclassed if forced to face heavy warships head on.

var/global/current_date_string



var/global/datum/money_account/vendor_account
var/global/datum/money_account/station_account
var/global/list/datum/money_account/department_accounts = list()
var/global/num_financial_terminals = 1
var/global/next_account_number = 0
var/global/list/all_money_accounts = list()
var/global/list/transaction_devices = list()
var/global/economy_init = 0

var/global/datum/economy/bank_accounts/persistent_economy
var/global/list/datum/money_account/department_acc_list = list()

var/global/list/station_departments = list("City Council", "Public Healthcare", "Emergency and Maintenance", "Research and Science", "Police", "Cargo", "Bar", "Botany", "Civilian")

/proc/setup_economy()
	if(economy_init)
		return 2

	//news_network.CreateFeedChannel("The [using_map.starsys_name] Times", "[using_map.starsys_name] Times ExoNode - [using_map.station_short]", 1, 1)
	//news_network.CreateFeedChannel("The Gibson Gazette", "Editor Mike Hammers", 1, 1)
	//news_network.CreateFeedChannel("Oculum Content Aggregator", "Oculus v6rev7", 1, 1)

	for(var/loc_type in typesof(/datum/trade_destination) - /datum/trade_destination)
		var/datum/trade_destination/D = new loc_type
		weighted_randomevent_locations[D] = D.viable_random_events.len
		weighted_mundaneevent_locations[D] = D.viable_mundane_events.len


	create_station_account()

	for(var/department in station_departments)
		create_department_account(department)
	create_department_account("Vendor")
	vendor_account = department_accounts["Vendor"]

	current_date_string = "[get_game_day()] [get_month_from_num(get_game_month())], [get_game_year()]"

	//starts economy persistence

	persistent_economy = new /datum/economy/bank_accounts

	persistent_economy.set_economy()
	persistent_economy.load_accounts()

	//end economy persistence

	link_economy_accounts()

	economy_init = 1
	return 1

/proc/create_station_account()
	if(!station_account)
		next_account_number = rand(111111, 999999)

		station_account = new()
		station_account.owner_name = "[station_name()] Funds"
		station_account.account_number = rand(111111, 999999)
		station_account.remote_access_pin = rand(1111, 9999)
		station_account.money = 950000
		station_account.department = "[station_name()] Funds"
		//create an entry in the account transaction log for when it was created
		var/datum/transaction/T = new()
		T.target_name = station_account.owner_name
		T.purpose = "Account creation"
		T.amount = 950000
		T.date = current_date_string
		T.time = "11:24"
		T.source_terminal = "Pollux Gov Terminal #277"

		//add the account
		station_account.transaction_log.Add(T)
		department_acc_list.Add(station_account)
//		all_money_accounts.Add(station_account)

/proc/create_department_account(department)
	next_account_number = rand(111111, 999999)

	var/datum/money_account/department_account = new()
	department_account.owner_name = "[department] Funds Account"
	department_account.account_number = rand(111111, 999999)
	department_account.remote_access_pin = rand(1111, 9999)
	department_account.money = 1500
	department_account.department = department

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new()
	T.target_name = department_account.owner_name
	T.purpose = "Account creation"
	T.amount = department_account.money
	T.date = current_date_string
	T.time = "11:24"
	T.source_terminal = "Pollux Gov Terminal #277"

	//add the account
	department_account.transaction_log.Add(T)
//	all_money_accounts.Add(department_account)
	department_acc_list.Add(department_account)
	department_accounts[department] = department_account

/datum/money_account/proc/charge(var/transaction_amount,var/datum/money_account/dest,var/transaction_purpose, var/terminal_name="", var/terminal_id=0, var/dest_name = "UNKNOWN")
	if(transaction_amount <= money)
		//transfer the money
		money -= transaction_amount
		if(dest)
			dest.money += transaction_amount

		//create entries in the two account transaction logs
		var/datum/transaction/T
		if(dest)
			T = new()
			T.target_name = owner_name
			if(terminal_name!="")
				T.target_name += " (via [terminal_name])"
			T.purpose = transaction_purpose
			T.amount = "[transaction_amount]"
			T.source_terminal = terminal_name
			T.date = current_date_string
			T.time = stationtime2text()
			dest.transaction_log.Add(T)
		//
		T = new()
		T.target_name = (!dest) ? dest_name : dest.owner_name
		if(terminal_name!="")
			T.target_name += " (via [terminal_name])"
		T.purpose = transaction_purpose
		if(transaction_amount < 0)
			T.amount = "[-1*transaction_amount]"
		else
			T.amount = "-[transaction_amount]"
		T.source_terminal = terminal_name
		T.date = current_date_string
		T.time = stationtime2text()
		transaction_log.Add(T)
		return 1
	else
		to_chat(usr, "\icon[src]<span class='warning'>You don't have that much money!</span>")
		return 0


/proc/link_economy_accounts()

	for(var/obj/item/device/retail_scanner/RS in transaction_devices)
		if(RS.account_to_connect)
			RS.linked_account = department_accounts[RS.account_to_connect]
	for(var/obj/machinery/cash_register/CR in transaction_devices)
		if(CR.account_to_connect)
			CR.linked_account = department_accounts[CR.account_to_connect]

