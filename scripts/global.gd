extends Node

var player_current_attack = false

var current_scene = "world" #world cliff_side
var transition_scene = false

var player_exit_cliffside_posx = 63
var player_exit_cliffside_posy = -42
var player_start_posx = -73
var player_start_posy = 10

var game_first_load = true

func finish_changescene():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "cliffside"
		else :
			current_scene = "world"
	
