/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = "357"
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	matter = list(DEFAULT_WALL_MATERIAL = 210)

/obj/item/ammo_casing/a50
	desc = "A .50AE bullet casing."
	caliber = ".50"
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	matter = list(DEFAULT_WALL_MATERIAL = 210)

/obj/item/ammo_casing/a75
	desc = "A .75 gyrojet rocket sheathe."
	caliber = "75"
	projectile_type = /obj/item/projectile/bullet/gyro
	matter = list(DEFAULT_WALL_MATERIAL = 4000)

/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	caliber = "38"
	projectile_type = /obj/item/projectile/bullet/pistol
	matter = list(DEFAULT_WALL_MATERIAL = 60)

/obj/item/ammo_casing/c38r
	desc = "A .38 rubber bullet casing."
	caliber = "38"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	matter = list(DEFAULT_WALL_MATERIAL = 60)

/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/pistol
	atter = list(DEFAULT_WALL_MATERIAL = 60)

/obj/item/ammo_casing/c9mm/ap
	desc = "A 9mm armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/ap
	atter = list(DEFAULT_WALL_MATERIAL = 80)

/obj/item/ammo_casing/c9mmf
	desc = "A 9mm flash shell casing."
	caliber = "9mm"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/energy/flash
	atter = list(DEFAULT_WALL_MATERIAL = 60)

/obj/item/ammo_casing/c9mmr
	desc = "A 9mm rubber bullet casing."
	caliber = "9mm"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	atter = list(DEFAULT_WALL_MATERIAL = 60)

/obj/item/ammo_casing/c9mmp
	desc = "A 9mm practice bullet casing."
	caliber = "9mm"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	atter = list(DEFAULT_WALL_MATERIAL = 60)

/*
/obj/item/ammo_casing/c5mm
	desc = "A 5mm bullet casing."
	caliber = "5mm"
	projectile_type = /obj/item/projectile/bullet/pistol/ap
*/

/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	atter = list(DEFAULT_WALL_MATERIAL = 75)

/obj/item/ammo_casing/c45p
	desc = "A .45 practice bullet casing."
	caliber = ".45"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	atter = list(DEFAULT_WALL_MATERIAL = 60)

/obj/item/ammo_casing/c45r
	desc = "A .45 rubber bullet casing."
	caliber = ".45"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	atter = list(DEFAULT_WALL_MATERIAL = 60)

/obj/item/ammo_casing/c45f
	desc = "A .45 flash shell casing."
	caliber = ".45"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/energy/flash
	atter = list(DEFAULT_WALL_MATERIAL = 60)

/obj/item/ammo_casing/a10mm
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	atter = list(DEFAULT_WALL_MATERIAL = 75)

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "slshell"
	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360)

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360)

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	matter = list("metal" = 90)
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(DEFAULT_WALL_MATERIAL = 180)

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stunshell"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	matter = list(DEFAULT_WALL_MATERIAL = 360, "glass" = 720)

/obj/item/ammo_casing/shotgun/stunshell/emp_act(severity)
	if(prob(100/severity)) BB = null
	update_icon()

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(DEFAULT_WALL_MATERIAL = 90, "glass" = 90)

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	icon_state = "rifle-casing"
	projectile_type = /obj/item/projectile/bullet/rifle/a762
	matter = list(DEFAULT_WALL_MATERIAL = 200)

/obj/item/ammo_casing/a762/ap
	desc = "A 7.62mm armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a762/ap
	matter = list(DEFAULT_WALL_MATERIAL = 300)

/obj/item/ammo_casing/a762p
	desc = "A 7.62mm practice bullet casing."
	caliber = "a762"
	icon_state = "rifle-casing" // Need to make an icon for these
	projectile_type = /obj/item/projectile/bullet/rifle/practice
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/a762/blank
	desc = "A blank 7.62mm bullet casing."
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/a145
	desc = "A 14.5mm shell."
	icon_state = "lcasing"
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	matter = list(DEFAULT_WALL_MATERIAL = 1250)

/obj/item/ammo_casing/a556
	desc = "A 5.56mm bullet casing."
	caliber = "a556"
	icon_state = "rifle-casing"
	projectile_type = /obj/item/projectile/bullet/rifle/a556
	matter = list(DEFAULT_WALL_MATERIAL = 180)

/obj/item/ammo_casing/a556/ap
	desc = "A 5.56mm armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a556/ap
	matter = list(DEFAULT_WALL_MATERIAL = 270)

/obj/item/ammo_casing/a556p
	desc = "A 5.56mm practice bullet casing."
	caliber = "a556"
	icon_state = "rifle-casing" // Need to make an icon for these
	projectile_type = /obj/item/projectile/bullet/rifle/practice
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = /obj/item/missile
	caliber = "rocket"
	matter = list(DEFAULT_WALL_MATERIAL = 10000)

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = "caps"
	icon_state = "r-casing"
	color = "#FF0000"
	projectile_type = /obj/item/projectile/bullet/pistol/cap
	matter = list(DEFAULT_WALL_MATERIAL = 85)

/obj/item/ammo_casing/spent // For simple hostile mobs only, so they don't cough up usable bullets when firing. This is for literally nothing else.
	icon_state = "s-casing-spent"
	BB = null
	projectile_type = null