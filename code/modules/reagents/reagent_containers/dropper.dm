////////////////////////////////////////////////////////////////////////////////
/// Droppers.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/dropper
	name = "Dropper"
	desc = "A dropper. Transfers 5 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,2,3,4,5)
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	volume = 5

	afterattack(var/obj/target, var/mob/user, var/flag)
		if(!target.reagents || !flag) return

		if(reagents.total_volume)

			if(!target.reagents.get_free_space())
				user << SPAN_NOTICE("[target] is full.")
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/weapon/reagent_containers/food) && !istype(target, /obj/item/clothing/mask/smokable/cigarette)) //You can inject humans and food but you cant remove the shit.
				user << SPAN_NOTICE("You cannot directly fill this object.")
				return

			var/trans = 0

			if(ismob(target))

				var/time = 20 //2/3rds the time of a syringe
				user.visible_message(SPAN_WARNING("[user] is trying to squirt something into [target]'s eyes!"))

				if(!do_mob(user, target, time))
					return

				if(ishuman(target))
					var/mob/living/carbon/human/victim = target

					var/obj/item/safe_thing = null
					if(victim.wear_mask)
						if (victim.wear_mask.body_parts_covered & EYES)
							safe_thing = victim.wear_mask
					if(victim.head)
						if (victim.head.body_parts_covered & EYES)
							safe_thing = victim.head
					if(victim.glasses)
						if (!safe_thing)
							safe_thing = victim.glasses

					if(safe_thing)
						trans = reagents.trans_to_obj(safe_thing, amount_per_transfer_from_this)
						user.visible_message(SPAN_WARNING("[user] tries to squirt something into [target]'s eyes, but fails!"), SPAN_NOTICE("You transfer [trans] units of the solution."))
						return

				var/mob/living/M = target
				var/contained = reagentlist()
				M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been squirted with [name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to squirt [M.name] ([M.key]). Reagents: [contained]</font>")
				msg_admin_attack("[user.name] ([user.ckey]) squirted [M.name] ([M.key]) with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

				trans = reagents.trans_to_mob(target, reagents.total_volume, CHEM_INGEST)
				user.visible_message(SPAN_WARNING("[user] squirts something into [target]'s eyes!"), SPAN_NOTICE("You transfer [trans] units of the solution."))


				return

			else
				trans = reagents.trans_to(target, amount_per_transfer_from_this) //sprinkling reagents on generic non-mobs
				user << SPAN_NOTICE("You transfer [trans] units of the solution.")

		else // Taking from something

			if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
				user << SPAN_NOTICE("You cannot directly remove reagents from [target].")
				return

			if(!target.reagents || !target.reagents.total_volume)
				user << SPAN_NOTICE("[target] is empty.")
				return

			var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)

			user << SPAN_NOTICE("You fill the dropper with [trans] units of the solution.")

		return

	on_reagent_change()
		update_icon()

	update_icon()
		if(reagents.total_volume)
			icon_state = "dropper1"
		else
			icon_state = "dropper0"

/obj/item/weapon/reagent_containers/dropper/industrial
	name = "Industrial Dropper"
	desc = "A larger dropper. Transfers 10 units."
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1,2,3,4,5,6,7,8,9,10)
	volume = 10

////////////////////////////////////////////////////////////////////////////////
/// Droppers. END
////////////////////////////////////////////////////////////////////////////////
