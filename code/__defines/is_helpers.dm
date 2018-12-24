
#define isatom(A) istype(A, /atom)
#define isdatum(A) istype(A, /datum)

//#define isarea(A) istype(A, /area)		Built-in

//#define isobj(A) istype(A, /obj)			Built-in
#define isitem(A) istype(A, /obj/item)

//#define ismob(A) istype(A, /mob)			Built-in
#define isliving(A) istype(A, /mob/living)
#define iscarbon(A) istype(A, /mob/living/carbon)

//#define isturf(A) istype(A, /turf)		Built-in

