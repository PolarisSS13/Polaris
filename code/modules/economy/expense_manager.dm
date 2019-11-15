/obj/machinery/expense_manager
	name = "expense manager"
	desc = "Swipe your ID card to manage expenses for a bank account. Put in the client's ID, not your own."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "expense"
	flags = NOBLUDGEON
	req_access = list(access_heads)

	anchored = 1

	var/expense_type = /datum/expense

	var/obj/item/weapon/card/id/stored_id

	var/datum/money_account/current_account

	var/icon_state_active = "expense_1"
	var/icon_state_inactive = "expense"
	var/expense_limit = 500000			// highest expense you can set.

/obj/machinery/expense_manager/update_icon()
	if(stored_id)
		icon_state = icon_state_active
	else
		icon_state = icon_state_inactive

/obj/machinery/expense_manager/police
	name = "police fine manager"
	expense_type = /datum/expense/police
	expense_limit = 10000
	req_access = list(access_sec_doors)

/obj/machinery/expense_manager/hospital
	name = "hospital bill manager"
	expense_type = /datum/expense/hospital
	expense_limit = 100000
	req_access = list(access_medical)

/obj/machinery/expense_manager/court
	name = "court injunction manager"
	expense_type = /datum/expense/law
	expense_limit = 500000

/obj/machinery/expense_manager/attackby(obj/item/I, mob/user)


	if (!istype(I, /obj/item/weapon/card/id) && !stored_id)
		to_chat(user, "\icon[src] <span class='warning'>Error: [src] can only accept identification cards.</span>")
		return

	if(stored_id)
		to_chat(user, "\icon[src] <span class='warning'>Error: [src] already has an ID stored, please sell or eject this ID before continuing.</span>")
		return

	if(insert_id(I, user))
		var/obj/item/weapon/card/id/iden = user.GetIdCard()

		if(!check_access(iden))
			return

		to_chat(user, "You place [I] into [src].")
		playsound(src, 'sound/machines/chime.ogg', 25)
		src.visible_message("\icon[src] \icon[I] <b>[src]</b> chimes, \"<span class='notice'>ID accepted.</span>\"")

		interact(user)
	else
		to_chat(user, "\icon[src] <span class='warning'>Error: Unable to accept ID card, this may be due to incorrect details. Contact an administrator for more information.</span>")

/obj/machinery/expense_manager/proc/insert_id(obj/item/weapon/card/id/I, mob/user)
	current_account = get_account(I.associated_account_number)

	if(!current_account)
		return 0

	stored_id = I
	user.drop_from_inventory(I, src)

	I.forceMove(src)

	update_icon()

	return 1


/obj/machinery/expense_manager/verb/eject_id()
	set name = "Eject ID"
	set category = "Object"
	set desc = "Ejects an item from the machine."
	set src in view(1)

	if(usr.stat)
		to_chat (usr, "<span class='warning'>You can't operate [src] while in this state!</span>")
		return

	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr

		if(stored_id)
			if(!H.get_active_hand())
				H.put_in_hands(stored_id)
			else
				stored_id.forceMove(loc)


			stored_id = null
			current_account = null

			update_icon()
			add_fingerprint(H)
			return 1
		else
			to_chat(usr, "<span class='warning'>There's no cards stored within [src]!</span>")
			return 0


	else
		to_chat(usr, "<span class='warning'>You have trouble operating [src].</span>")
		return 0



/obj/machinery/expense_manager/attack_hand(mob/user)
	add_fingerprint(usr)


	if(istype(user, /mob/living/silicon))
		to_chat(user, "\icon[src] <span class='warning'>A firewall prevents you from interfacing with this device!</span>")
		return

	if(!stored_id)
		to_chat(user, "\icon[src] <span class='warning'>Error: There is no identification card in this device, please insert an ID.</span>")
		return

	var/obj/item/weapon/card/id/iden = user.GetIdCard()

	if(!check_access(iden))
		to_chat(user, "\icon[src] <span class='warning'>Error: You do not have access to this terminal.</span>")
		return

	interact(user)
	updateDialog()

/obj/machinery/expense_manager/interact(mob/user)

	var/dat = "<h1>[src]</h1><hr>"

	dat += "This machine allows you to edit expenses on any active ID card. Please note that it is considered fraud to remove \
	expenses from one's own account, or to illegitimately add or remove expenses outside of official protocol. Prosecution \
	may result from abuse of this machine.<hr>"

	if(get_dist(src,user) <= 1)
		if(!current_account) // Shouldn't happen, but you know.
			dat += "<b>No account found.</b>"

		else

			dat += "<b>Name:</b> [current_account.owner_name]<br>"
			dat += "<b>Account No:</b> [current_account.account_number]<br>"
			dat += "<b>Current Funds:</b> [current_account.money] credits.<br><br>"

			dat += "<a href='?src=\ref[src];choice=add_new_expense'>Add New Expense</a> "
			dat += "<a href='?src=\ref[src];choice=remove_all_expenses'>Remove All Expenses</a>"
			dat += "<a href='?src=\ref[src];choice=refresh'>Refresh</a>"
			dat += "<a href='?src=\ref[src];choice=eject_id'>Eject ID</a> <br>"

			//get expenses
			var/list/datum/expense/expense_list = list()

			for(var/datum/expense/E in current_account.expenses)
				if (istype(E, expense_type))
					expense_list += E

			//show expenses
			dat += "<br><h2>Debts:</h2><hr>"

			if(!isemptylist(expense_list))
				for(var/datum/expense/E in expense_list)

					dat += "<fieldset style='border: 2px solid [E.color]; display: inline'>"

					dat += "Debt: <b>[E.purpose] - ([E.name])</b> ([E.initial_cost] credits)."
					dat += "<br>Charge Per Payroll: [E.cost_per_payroll] credits."
					dat += "<br>Current Debt Left: [E.amount_left] credits."
					dat += "<br>Added By: [E.added_by]"
					dat += "<br>Creation Date: [E.creation_date]"
					dat += "<br>Status: [E.active ? "Active" : "Inactive"]<br><br>"

					dat += "<br>Comments: <i>[E.comments]</i><br>"

					dat += "<a href='?src=\ref[src];choice=edit_expense;expense=\ref[E]''>Edit Expense</a> "
					dat += "<a href='?src=\ref[src];choice=remove_expense;expense=\ref[E]''>Remove Expense</a> "
					dat += "<a href='?src=\ref[src];choice=toggle_expense;expense=\ref[E]'>Toggle Expense</a> "

					dat += "</fieldset>"

					dat += "<br>"

			else
				dat += "No expenses found on this account for this department."

		var/datum/browser/popup = new(user, "expense_machine", "[src]", 550, 650, src)
		popup.set_content(jointext(dat,null))
		popup.open()

		onclose(user, "expense_machine")

/obj/machinery/expense_manager/proc/add_new_expense(mob/user)
	var/expense_purpose = sanitize(input("Enter the purpose of this expense.", "Expense Purpose") as text)
	if(!expense_purpose) return

	var/expense_amount = round(input("Enter amount", "New amount") as num)
	expense_amount = Clamp(expense_amount, 0, expense_limit)

	if(!expense_amount) return

	var/expense_commments = sanitize_text(input(usr, "Enter any comments regarding this expense.", "Expense Comments")  as message,1,100)
	if(!expense_commments) return


	var/new_expense = create_expense(expense_type, expense_purpose, expense_commments, expense_amount, user.name, user.ckey)

	current_account.expenses += new_expense


/obj/machinery/expense_manager/proc/remove_expense(mob/user, var/datum/expense/E)
	var/choice = alert(user,"Would you like to remove this expense?","Remove Expense","No","Yes")
	if(choice == "Yes")
		current_account.expenses -= E
		qdel(E)
	else
		return

/obj/machinery/expense_manager/proc/suspend_expense(mob/user, var/datum/expense/E)
	var/choice = alert(user,"[E.active ? "Suspend" : "Un-suspend"] this expense?","Suspend Expense","Suspend","Un-Suspend")
	if(choice == "Suspend")
		if(E.active)
			E.active = 0
	else
		E.active = 1

/obj/machinery/expense_manager/proc/edit_expense(mob/user, var/datum/expense/E)
	var/expense_purpose = sanitize_text(input(usr, "Enter the purpose of this expense.", "Expense Purpose", E.name)  as text,1,25)
	if(!expense_purpose) return

	var/expense_amount = sanitize_integer(input(usr, "Enter expense amount (in credits).", "Expense Amount", E.amount_left)  as num|null, 1, 10000)
	if(!expense_amount) return

	var/expense_commments = sanitize_text(input(usr, "Enter any comments regarding this expense.", "Expense Comments", E.comments)  as message,1,100)
	if(!expense_commments) return

	E.purpose = expense_purpose
	E.comments = expense_commments
	E.amount_left = expense_amount

	if(!(user.ckey in E.ckey_edit_list))
		E.ckey_edit_list += user.ckey

/obj/machinery/expense_manager/proc/remove_all_expenses(mob/user)

	if(!current_account)
		return
	else
		var/choice = alert(user,"Delete all expenses from account? This cannot be undone!","Delete Expense","No","Yes")
		if(choice == "Yes")
			for(var/datum/expense/E in current_account.expenses)
				if (istype(E, expense_type))
					current_account.expenses -= E
		else if(choice == "No")
			return

/obj/machinery/expense_manager/Topic(var/href, var/href_list)
	if(..())
		return 1
	if(href_list["choice"])
		switch(href_list["choice"])

			if("add_new_expense")
				add_new_expense(usr)

			if("remove_expense")
				var/E = locate(href_list["expense"])
				remove_expense(usr, E)

			if("toggle_expense")
				var/E = locate(href_list["expense"])
				suspend_expense(usr, E)

			if("edit_expense")
				var/E = locate(href_list["expense"])
				edit_expense(usr, E)

			if("remove_all_expenses")
				remove_all_expenses(usr)

			if("refresh")
				updateDialog()

			if("eject_id")
				eject_id(usr)

	updateDialog()
