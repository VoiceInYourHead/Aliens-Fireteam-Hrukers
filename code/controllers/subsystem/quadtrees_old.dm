SUBSYSTEM_DEF(quadtree_old)
	name = "Quadtree"
	wait = 0.5 SECONDS
	priority = SS_PRIORITY_QUADTREE

	var/list/cur_quadtrees_old
	var/list/new_quadtrees_old
	var/list/player_feed

/datum/controller/subsystem/quadtree_old/Initialize()
	cur_quadtrees_old = new/list(world.maxz)
	new_quadtrees_old = new/list(world.maxz)
	var/datum/shape/rectangle/R
	for(var/i in 1 to length(cur_quadtrees_old))
		R = RECT_OLD(world.maxx/2,world.maxy/2, world.maxx, world.maxy)
		new_quadtrees_old[i] = QTREE_OLD(R, i)
	return ..()

/datum/controller/subsystem/quadtree_old/stat_entry(msg)
	msg = "QT:[length(cur_quadtrees_old)]"
	return ..()

/datum/controller/subsystem/quadtree_old/fire(resumed = FALSE)
	if(!resumed)
		player_feed = GLOB.clients.Copy()
		cur_quadtrees_old = new_quadtrees_old.Copy()
		if(new_quadtrees_old.len < world.maxz)
			new_quadtrees_old.len = world.maxz
		for(var/i in 1 to world.maxz)
			new_quadtrees_old[i] = QTREE_OLD(RECT_OLD(world.maxx/2,world.maxy/2, world.maxx, world.maxy), i)

	while(length(player_feed))
		var/client/C = player_feed[player_feed.len]
		player_feed.len--
		if(!C) continue
		var/turf/T = get_turf(C.mob)
		if(!T?.z || new_quadtrees_old.len < T.z)
			continue
		var/datum/coords/qtplayer/p_coords = new
		p_coords.player = C
		p_coords.x_pos = T.x
		p_coords.y_pos = T.y
		p_coords.z_pos = T.z
		if(isobserver(C.mob))
			p_coords.is_observer = TRUE
		var/datum/quadtree_old/QT = new_quadtrees_old[T.z]
		QT.insert_player(p_coords)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/quadtree_old/proc/players_in_range(datum/shape/range, z_level, flags = 0)
	var/list/players = list()
	if(z_level && cur_quadtrees_old.len >= z_level)
		var/datum/quadtree_old/Q = cur_quadtrees_old[z_level]
		if(!Q)
			return players
		players = SEARCH_QTREE_OLD(Q, range, flags)
	return players
