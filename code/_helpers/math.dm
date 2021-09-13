/proc/IsPowerOfTwo(var/val)
	return (val & (val-1)) == 0

/proc/RoundUpToPowerOfTwo(var/val)
	return 2 ** -round(-log(2,val))
