#define JAN 1
#define FEB 2
#define MAR 3
#define APR 4
#define MAY 5
#define JUN 6
#define JUL 7
#define AUG 8
#define SEP 9
#define OCT 10
#define NOV 11
#define DEC 12

#define THIRTY_DAY_MONTHS list(APR,JUN,SEP,NOV)
#define THIRTY_ONE_DAY_MONTHS list(JAN,MAR,MAY,JUL,AUG,OCT,DEC)
#define TWENTY_EIGHT_DAY_MONTHS list(FEB)

#define SPRING_MONTHS list(FEB,MAR,APR)
#define SUMMER_MONTHS list(MAY,JUN,JUL)
#define AUTUMN_MONTHS list(AUG,SEP,OCT)
#define WINTER_MONTHS list(NOV,DEC,JAN)


/proc/get_month_from_num(var/num)
	switch(num)
		if(JAN)
			return "January"
		if(FEB)
			return "February"
		if(MAR)
			return "March"
		if(APR)
			return "April"
		if(MAY)
			return "May"
		if(JUN)
			return "June"
		if(JUL)
			return "July"
		if(AUG)
			return "August"
		if(SEP)
			return "September"
		if(OCT)
			return "October"
		if(NOV)
			return "November"
		if(DEC)
			return "December"
		else
			return 0



