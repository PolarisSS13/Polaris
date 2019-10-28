proc
/*Date Functions*/
	FindDate(Date as text)
		if(!Date) return null
		var
			list/Dates = splittext(Date,"/")
			Day		= Dates[1]
			Month	= Dates[2]
			Year	= Dates[3]
		return list(Day, Month, Year)

	ValidateDate(Dates)
		if(istext(Dates)) Dates = FindDate(Dates)
		else if(istype(Dates,/list))
		else return
		var
			Day		= text2num(Dates[1])
			Month	= text2num(Dates[2])
			Year	= text2num(Dates[3])
		while(Month > 12)
			Month -= 12
			Year++
		while(Day > DaysInMonth(Month,Year))
			Day -= DaysInMonth(Month,Year)
			Month++
			while(Month > 12)
				Month -= 12
				Year++
		while(Day <= 0)
			Month--
			Day += DaysInMonth(Month,Year)
		while(Month <= 0)
			Year--
			Month += 12
		return "[Day]/[Month]/[Year]"

	DaysInMonth(Month,Year)
		if(Month == 2)
			if(!(Year%4))
				if(!(Year%100))
					if(!(Year%400)) return 29
					else return 28
				else return 29
			else return 28
		else
			if(Month < 8)
				if(Month % 2) return 31
				else return 30
			else if(Month == 8) return 31
			else
				if(Month % 2) return 30
				else return 31

	DaysTotal(Day,Month,Year)
		var/Total = Day
		while(Month)
			Total += DaysInMonth(Month,Year)
			Month--
		while(Year)
			if(DaysInMonth(2,Year) == 29) Total += 366
			else Total += 365
			Year--
		return Total

	DaysToText(Days)
		if(!Days||!(isnum(Days))) return
		var
			Months = 0
			Years = 0
			MonthNum = 1
		. = new/list
		while(Days > DaysInMonth(MonthNum))
			Days -= DaysInMonth(MonthNum)
			MonthNum++
			if(MonthNum > 12) MonthNum = 1
			Months++
		while(Months >= 12)
			Months -= 12
			Years++
		if(Days) . += "[Days] Day[Days==1?"" : "s"]"
		if(Months) . += "[Months] Month[Months==1?"" : "s"]"
		if(Years) . += "[Years] Year[Years==1?"" : "s"]"
		return jointext(.,", ")

	AddDays(Date, Days, Months, Years)
		if(istext(Date)) Date = FindDate(Date)
		else if(istype(Date,/list))
		else return
		while(Years)
			Days += DaysInMonth(2,Years)==28?365:366
			Years--
		while(Months)
			Days += DaysInMonth(Months)
			Months--
		Date[1] = text2num(Date[1])+Days
		return ValidateDate(Date)

	SubtractDays(Date, Days, Months, Years)
		if(istext(Date)) Date = FindDate(Date)
		else if(istype(Date,/list))
		else return
		var
			StartDay	= text2num(Date[1])
			StartMonth	= text2num(Date[2]) - Months
			StartYear	= text2num(Date[3]) - Years
		StartDay -= Days
		while(StartMonth <= 0)
			StartMonth += 12
			StartYear--
		while(StartDay <= 0)
			while(StartMonth <= 0)
				StartMonth += 12
				StartYear--
			var/NewDays = DaysInMonth(StartMonth,StartYear)
			StartDay = NewDays + StartDay
		return ValidateDate("[StartDay]/[StartMonth]/[StartYear]")

	TextMonth2NumMonth(incoming)
		switch(incoming)
			if("Jan") return 1
			if("Feb") return 2
			if("Mar") return 3
			if("Apr") return 4
			if("May") return 5
			if("Jun") return 6
			if("Jul") return 7
			if("Aug") return 8
			if("Sep") return 9
			if("Oct") return 10
			if("Nov") return 11
			if("Dec") return 12

	NumMonth2TextMonth(incoming)
		switch(incoming)
			if(1) return "January"
			if(2) return "February"
			if(3) return "March"
			if(4) return "April"
			if(5) return "May"
			if(6) return "June"
			if(7) return "July"
			if(8) return "August"
			if(9) return "September"
			if(10) return "October"
			if(11) return "November"
			if(12) return "December"

	Days_Difference(DateOne , DateTwo)
		var
			ListOne = ValidateDate(DateOne)
			ListTwo = ValidateDate(DateTwo)
		DateOne = FindDate(ListOne)
		DateTwo = FindDate(ListTwo)
		for(var/O = 1 to length(DateOne))DateOne[O] = text2num(DateOne[O])
		for(var/T = 1 to length(DateTwo))DateTwo[T] = text2num(DateTwo[T])
		var
			TotalOne = DaysTotal(DateOne[1],DateOne[2],DateOne[3])
			TotalTwo = DaysTotal(DateTwo[1],DateTwo[2],DateTwo[3])
		return abs(TotalOne - TotalTwo)