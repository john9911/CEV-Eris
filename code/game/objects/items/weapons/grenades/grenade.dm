/obj/item/weapon/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	flags = CONDUCT
	slot_flags = SLOT_BELT|SLOT_MASK
	var/active = 0
	var/det_time = 50
	var/loadable = TRUE

/obj/item/weapon/grenade/proc/clown_check(var/mob/living/user)
	if((CLUMSY in user.mutations) && prob(50))
		user << SPAN_WARNING("Huh? How does this thing work?")

		activate(user)
		add_fingerprint(user)
		spawn(5)
			prime()
		return 0
	return 1

/obj/item/weapon/grenade/examine(mob/user)
	if(..(user, 0))
		if(det_time > 1)
			user << "The timer is set to [det_time/10] seconds."
			return
		if(det_time == null)
			return
		user << "\The [src] is set for instant detonation."


/obj/item/weapon/grenade/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			user << SPAN_WARNING("You prime \the [name]! [det_time/10] seconds!")

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
	return


/obj/item/weapon/grenade/proc/activate(mob/user as mob)
	if(active)
		return

	if(user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	spawn(det_time)
		prime()
		return


/obj/item/weapon/grenade/proc/prime()
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)


/obj/item/weapon/grenade/attackby(obj/item/I, mob/user as mob)
	if(QUALITY_SCREW_DRIVING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_SCREW_DRIVING, FAILCHANCE_EASY, required_stat = STAT_COG))
			switch(det_time)
				if (1)
					det_time = 10
					user << SPAN_NOTICE("You set the [name] for 1 second detonation time.")
				if (10)
					det_time = 30
					user << SPAN_NOTICE("You set the [name] for 3 second detonation time.")
				if (30)
					det_time = 50
					user << SPAN_NOTICE("You set the [name] for 5 second detonation time.")
				if (50)
					det_time = 1
					user << SPAN_NOTICE("You set the [name] for instant detonation.")
			add_fingerprint(user)
	..()
	return

/obj/item/weapon/grenade/attack_hand()
	walk(src, null, null)
	..()
	return
