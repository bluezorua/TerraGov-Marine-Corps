/obj/effect/temp_visual/telekinesis
	name = "telekinetic force"
	icon_state = "empdisable"
	duration = 0.5 SECONDS

/obj/effect/temp_visual/explosion
	name = "explosion"
	icon = 'icons/effects/explosion.dmi'
	icon_state = "explosion"
	duration = 8
	light_system = STATIC_LIGHT

/obj/effect/temp_visual/explosion/Initialize(mapload, radius, color)
	. = ..()
	set_light(radius, radius, color)

	var/image/I = image(icon, src, icon_state, 10, pixel_x = -16, pixel_y = -16)
	var/matrix/rotate = matrix()
	rotate.Turn(rand(0, 359))
	I.transform = rotate
	overlays += I //we use an overlay so the explosion and light source are both in the correct location
	icon_state = null

GLOBAL_LIST_EMPTY(blood_particles)
/particles/splatter
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	width = 500
	height = 500
	count = 20
	spawning = 20
	lifespan = 0.5 SECONDS
	fade = 0.7 SECONDS
	grow = 0.1
	scale = 0.2
	spin = generator(GEN_NUM, -20, 20)
	velocity = list(50, 0)
	friction = generator(GEN_NUM, 0.1, 0.5)
	position = generator(GEN_CIRCLE, 6, 6)

/particles/splatter/New(set_color)
	..()
	if(set_color != "red") // we're already red colored by default
		color = set_color

//unsorted miscellaneous temporary visuals
/obj/effect/temp_visual/dir_setting/bloodsplatter
	icon = 'icons/effects/blood.dmi'
	duration = 0.5 SECONDS
	randomdir = FALSE
	layer = ABOVE_MOB_LAYER
	alpha = 175
	var/splatter_type = "splatter"

/obj/effect/temp_visual/dir_setting/bloodsplatter/Initialize(mapload, angle, blood_color)
	if(!blood_color)
		CRASH("Tried to create a blood splatter without a blood_color")
	var/x_component = sin(angle) * -15
	var/y_component = cos(angle) * -15
	if(!GLOB.blood_particles[blood_color])
		GLOB.blood_particles[blood_color] = new /particles/splatter(blood_color)
	particles = GLOB.blood_particles[blood_color]
	particles.velocity = list(x_component, y_component)
	color = blood_color
	icon_state = "[splatter_type][pick(1, 2, 3, 4, 5, 6)]"
	. = ..()
	var/target_pixel_x = 0
	var/target_pixel_y = 0
	switch(angle)
		if(0, 360)
			target_pixel_x = 0
			target_pixel_y = 8
		if(1 to 44)
			target_pixel_x = round(4 * ((angle) / 45))
			target_pixel_y = 8
		if(45)
			target_pixel_x = 8
			target_pixel_y = 8
		if(46 to 89)
			target_pixel_x = 8
			target_pixel_y = round(4 * ((90 - angle) / 45))
		if(90)
			target_pixel_x = 8
			target_pixel_y = 0
		if(91 to 134)
			target_pixel_x = 8
			target_pixel_y = round(-3 * ((angle - 90) / 45))
		if(135)
			target_pixel_x = 8
			target_pixel_y = -6
		if(136 to 179)
			target_pixel_x = round(4 * ((180 - angle) / 45))
			target_pixel_y = -6
		if(180)
			target_pixel_x = 0
			target_pixel_y = -6
		if(181 to 224)
			target_pixel_x = round(-6 * ((angle - 180) / 45))
			target_pixel_y = -6
		if(225)
			target_pixel_x = -6
			target_pixel_y = -6
		if(226 to 269)
			target_pixel_x = -6
			target_pixel_y = round(-6 * ((270 - angle) / 45))
		if(270)
			target_pixel_x = -6
			target_pixel_y = 0
		if(271 to 314)
			target_pixel_x = -6
			target_pixel_y = round(8 * ((angle - 270) / 45))
		if(315)
			target_pixel_x = -6
			target_pixel_y = 8
		if(316 to 359)
			target_pixel_x = round(-6 * ((360 - angle) / 45))
			target_pixel_y = 8
	animate(src, pixel_x = target_pixel_x, pixel_y = target_pixel_y, alpha = 0, time = duration)

/obj/effect/temp_visual/transfer_plasma
	name = "transfer plasma"
	icon_state = "transfer_plasma"
	duration = 0.5 SECONDS


/obj/effect/temp_visual/xenomorph/afterimage
	name = "afterimage"
	layer = MOB_LAYER
	alpha = 64 //Translucent
	duration = 0.5 SECONDS
	density = FALSE
	opacity = FALSE
	anchored = FALSE
	animate_movement = SLIDE_STEPS

/obj/effect/temp_visual/xenomorph/afterimage/Initialize(mapload, atom/owner)
	. = ..()
	appearance = owner.appearance
	setDir(owner.dir)
	alpha = initial(alpha)
	layer = initial(layer)
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/heavyimpact
	name = "heavy impact"
	icon = 'icons/effects/heavyimpact.dmi'
	icon_state = ""
	duration = 13

/obj/effect/temp_visual/heavyimpact/Initialize(mapload)
	. = ..()
	flick("heavyimpact", src)

/obj/effect/temp_visual/order
	icon = 'icons/Marine/marine-items.dmi'
	var/icon_state_on
	hud_possible = list(SQUAD_HUD_TERRAGOV, SQUAD_HUD_SOM)
	duration = ORDER_DURATION
	layer = TURF_LAYER

/obj/effect/temp_visual/order/Initialize(mapload, faction)
	. = ..()
	prepare_huds()
	var/marker_flags
	var/hud_type
	if(faction == FACTION_TERRAGOV)
		hud_type = DATA_HUD_SQUAD_TERRAGOV
	else if(faction == FACTION_SOM)
		hud_type = DATA_HUD_SQUAD_SOM
	else
		return
	if(hud_type == DATA_HUD_SQUAD_TERRAGOV)
		marker_flags = MINIMAP_FLAG_MARINE
	else if(hud_type == DATA_HUD_SQUAD_SOM)
		marker_flags = MINIMAP_FLAG_MARINE_SOM
	else
		return
	var/datum/atom_hud/squad/squad_hud = GLOB.huds[hud_type]
	squad_hud.add_to_hud(src)
	SSminimaps.add_marker(src, marker_flags, image('icons/UI_icons/map_blips_large.dmi', null, icon_state_on))
	set_visuals(faction)

/obj/effect/temp_visual/order/attack_order
	name = "attack order"
	icon_state_on = "attack"

/obj/effect/temp_visual/order/defend_order
	name = "defend order"
	icon_state_on = "defend"

/obj/effect/temp_visual/order/retreat_order
	name = "retreat order"
	icon_state_on = "retreat"

/obj/effect/temp_visual/order/rally_order
	name = "rally order"
	icon_state_on = "rally"
	duration = RALLY_ORDER_DURATION

///Set visuals for the hud
/obj/effect/temp_visual/order/proc/set_visuals(faction)
	var/hud_type
	if(faction == FACTION_TERRAGOV)
		hud_type = SQUAD_HUD_TERRAGOV
	else if(faction == FACTION_SOM)
		hud_type = SQUAD_HUD_SOM
	else
		return
	var/image/holder = hud_list[hud_type]
	if(!holder)
		return
	holder.icon = 'icons/Marine/marine-items.dmi'
	holder.icon_state = icon_state_on
	hud_list[hud_type] = holder

/obj/effect/temp_visual/healing
	name = "healing"
	icon = 'icons/effects/progressicons.dmi'
	icon_state = "busy_medical"
	duration = 0.8 SECONDS


/obj/effect/temp_visual/alien_fruit_eaten
	name = "glitters"
	icon_state = "shieldsparkles"
	duration = 0.5 SECONDS

/obj/effect/temp_visual/smoke
	name = "smoke"
	icon = 'icons/obj/items/jetpack.dmi'
	icon_state = "smoke"
	duration = 1.2 SECONDS

/obj/effect/temp_visual/blink_portal
	name = "blink portal"
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	layer = ABOVE_LYING_MOB_LAYER
	duration = 0.5 SECONDS

/obj/effect/temp_visual/banishment_portal
	name = "banishment portal"
	icon = 'icons/obj/objects.dmi'
	icon_state = "bhole3"
	layer = ABOVE_LYING_MOB_LAYER
	duration = WRAITH_BANISH_BASE_DURATION+1 //So we don't delete our contents early

/obj/effect/temp_visual/acid_splatter
	name = "acid_splatter"
	icon = 'icons/Xeno/Effects.dmi'
	icon_state = "splatter"
	duration = 0.8 SECONDS

/obj/effect/temp_visual/acid_bath
	name = "acid bath"
	icon = 'icons/obj/items/projectiles.dmi'
	icon_state = "boiler_gas"
	duration = 0.8 SECONDS

/obj/effect/temp_visual/wraith_warp
	icon = 'icons/effects/light_overlays/light_128.dmi'
	icon_state = "light"
	plane = GRAVITY_PULSE_PLANE
	pixel_x = -48
	pixel_y = -48
	duration = 8

/obj/effect/temp_visual/wraith_warp/Initialize(mapload)
	. = ..()
	animate(src, time=duration, transform=matrix().Scale(0.1,0.1))

/obj/effect/temp_visual/blink_drive
	icon = 'icons/effects/light_overlays/light_128.dmi'
	icon_state = "light"
	plane = GRAVITY_PULSE_PLANE
	duration = 8

/obj/effect/temp_visual/blink_drive/Initialize(mapload)
	. = ..()
	var/image/I = image(icon, src, icon_state, 10, pixel_x = -48, pixel_y = -48)
	overlays += I //we use an overlay so the icon and light source are both in the correct location
	icon_state = null
	animate(src, time=duration, transform=matrix().Scale(0.1,0.1))
	set_light(2, 2, LIGHT_COLOR_DARK_BLUE)

/obj/effect/temp_visual/shockwave
	icon = 'icons/effects/light_overlays/shockwave.dmi'
	icon_state = "shockwave"
	plane = GRAVITY_PULSE_PLANE
	pixel_x = -496
	pixel_y = -496

/obj/effect/temp_visual/shockwave/Initialize(mapload, radius)
	. = ..()
	deltimer(timerid)
	timerid = QDEL_IN(src, 0.5 * radius)
	transform = matrix().Scale(32 / 1024, 32 / 1024)
	animate(src, time = 1/2 * radius, transform=matrix().Scale((32 / 1024) * radius * 1.5, (32 / 1024) * radius * 1.5))

/obj/effect/temp_visual/dir_setting/water_splash
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	duration = 0.5 SECONDS
