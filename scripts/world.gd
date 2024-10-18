extends Node2D


func _ready():
	if global.game_first_load == true :
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	else :
		$player.position.x = global.player_exit_cliffside_posx
		$player.position.y = global.player_exit_cliffside_posy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	change_scene()


func _on_cliffside_tp_body_entered(body):
	if body.has_method("player"):
		global.transition_scene=true


func _on_cliffside_tp_body_exited(body):
	if body.has_method("player"):
		global.transition_scene=false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			global.finish_changescene()
			get_tree().change_scene_to_file("res://scenes/cliffside.tscn")
			global.game_first_load = false
