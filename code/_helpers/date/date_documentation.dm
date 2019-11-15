/* ALL RIGHTS RESERVED © 2005 Polaris8920, BYOND and DanTom.

This is library. You are free to include any of its contents
in your projects. Its contents are not for usage in your own library
demo unless credit is given where credit is due. You may not claim it
as your own or imply it as your own in any way. If you do include it
in you own project, please give credit to Polaris8920 where credit
for this project is due. Credit is not due, if you use this as an
idea for your system, but if you use this and modify it, credit would
still greatly be appreciated.

    ~ Polaris8920

******************
****Date Datum****
******************
date
	var
		day					The time and date of the datum.
		month
		year
		second
		minute
		hour
		minute_offset		The hour and minute offsets used in
		hour_offset			updating the datum's time.

	New(_day, _month, _year, _second, _minute, _hour)
		New is is customized to allow easy access to the datum's SetTime()
		proc.

	proc
		SetTime(_day, _month, _year, _second, _minute, _hour)
			If _day is equal to "New" then the datum will find the
			current BYOND time and use _month and _year as the minute and
			hour offset respectively.
			If _day is text, but not equal to "New", it will try and find
			a /timezone whose timezone abbreviation is equal to _day and
			use that timezone's hour and minute offsets instead.
			If _day is not text, then it will set the datum's respective
			variables to their argument counterpart.

		FindTime()
			Finds the time according to the BYOND developer site and sets
			the datum's variables accordingly.

		Update()
			Updates the datum's time.

		ToText(incoming = "H:mm.ss ?M DD/MM/YYYY")
			This returns a text string of the datum's date in a custom
			format.
			The customization arguments are:
			*Text Argument* - *Returns*
			"MONTH" - Name of the datum's month in text.
			"ss" - The datum's second.
			"mm" - The datum's minute.
			"hh" - The datum's hour in military time.
			"H" - The datum's hour in civilian time.
			"?M" - If the datum's date is in the morning or night.
			"DD" - The datum's day in a month.
			"MM" - The datum's month in the form of a number.
			"YYYY" - The datum's year.

		Add_Days(days, months, years)
			This will add days, months, and years to the datum's date.

		Subtract_Days(days, months, years)
			This will remove days, months, and years to the datum's date.

		Add_Time(seconds, minutes, hours)
			This will add seconds, minutes, and hours to the datum's time.
			If a new day, month, and/or year is required it will add them
			to the datum's date accordingly.

		Subtract_Time(seconds, minutes, hours)
			This will remove seconds, minutes, and hours to the datum's
			time. If a day, month, and/or year needs to be removed it will
			remove them from the datum's date accordingly.

proc
	InsertZero(variable,length = 2)
		If a variable is only is shorter than length digits long, it will
		add zeros to the front of it. This is used in /date.ToText()
		to add zeros to its variables.

*******************
****Date Events****
*******************
byonddate
		This is a datum that will find the date from the BYOND site and do
		certain things accordingly.
	var
		check
			This is the variable that will determine how often the date
			holder checks the site in tenths of a second.
		eventsite
			This is the URL of a site that holds the .txt file to parse
			for date specific information.
		date/time
			This is a /date datum to hold what time it is on the BYOND
			site.
	New()
		We override New() to start our loop.
	proc
		FindTime()
			This is the loop that finds the time from the BYOND site and
			acts accordingly.
		FindEvent()
			This finds the events from a specified URL, and acts
			accordingly calling EventTime() for each.
		EventTime(event,argument,date)
			This is probably the only procedure that you will need to
			override, you can use if statements or switch statements to
			declare what each event will do. Some have been included for
			your use already.

var/byonddate/EventDateHolder = new		This is a /byonddate datum that
										will hold all of the current dates
										and events.


**********************
****Date Functions****
**********************
proc
	FindDate(Date as text)
		This procedure will find the the days, months, and years of text.
		A slash (/) should seperate each part. The format is
		"Day/Month/Year" because it is easier for the library to handle.
		It will return them in a list. You probably don't need to call this
		yourself, because most of the other procedures have sanity checks
		which will do it for you.

	ValidateDate(Dates)
		This is used to make a sanity check on the date, we can't have
		32/1/2005, instead, it would become 1/2/2005. It works for months
		that differ from the rest, (February), or it can figure out if the
		month has thirty, or thirty-one days.

	DaysInMonth(Month,Year)
		This is an internal procedure used by ValidateDate() and other
		procedures to check the days in a certain month. You can call it
		yourself, but be sure to include the year for leap year checking.

	DaysTotal(Day,Month,Year)
		This will return the number of days from 01/01/0001. I personally
		wouldn't call this on a modern date, because it will return a large
		number. Also, calling DaysTotal() on a day, then ValidateDate()ing
		it will cause problems, because of loss of leap years.

	DaysToText(Days)
		This will return a text string that will be useful to show players
		in an organized manner. It will return ? Days, ? Months, ? Years.
		If the there are none of the date stamp, then it will not be put
		in.

	AddDays(Date, Days, Months, Years)
		This is a staple of this library, it can add days, months, or even
		years accuratly.

	SubtractDays(Date, Days, Months, Years)
		This is another staple of this library, it can subtract
		days, months, or even years accuratly.

	TextMonth2NumMonth(incoming)
		Used by the /date datum to parse the BYOND developer site for the
		time and date. This will find out what number month has been
		inputted. The month is the first three letters of the full month's
		name.

	NumMonth2TextMonth(incoming)
		This will return the full month name of the number month inputted.
		An example would be NumMonth2TextMonth(1) which would return
		"January".

	Days_Difference(DateOne , DateTwo)
		This will provide the difference between to dates in days.

**********************
****Time Functions****
**********************
proc
	ValidateTime(second, minute, hour)
		This make sure a time doesn't go over its valid numbers. It returns
		a list of new second, new minute, new hour, and how many days to
		add if any.

	AddTime(time, seconds, minutes, hours)
		Adds seconds, minutes, and/or hours to a list of times in the
		format of seconds, minutes, hours. It returns a list of new second,
		new minute, new hour, and how many days to add if any.

	SubtractTime(time, seconds, minutes, hours)
		Subtracts seconds, minutes, and/or hours from a list of times in
		the format of seconds, minutes, hours. It returns a list of new
		second, new minute, new hour, and how many days to subtract if any.


	SecondsTotal(time)
		The total seconds of a time. It returns a number of seconds and
		requires a list in the format of second, minute, hour.

	SecondsToText(second)
		This will return a text string that will be useful to show players
		in an organized manner. It will return ? Seconds, ? Minutes, ?
		Hours. If the there are none of the time stamp, then it will not
		be put in.

	Time_Difference(DateOne, DateTwo)
		This requires a two dates in the format of
		list(second, minute, hour) and returns the second of difference
		between.

*****************
****Timezones****
*****************
timezone
	var
		minute_offset = 0
		hour_offset = 0
This is a datum used by the /date datum for custom time zones that can be
created in /date.SetTime() and /date.New().
The hour and minute offsets are from GMT and should be in the form of a
number.
I have included a small list of basic time zones for developers usage.
*/