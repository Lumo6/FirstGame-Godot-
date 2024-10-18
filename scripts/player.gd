extends CharacterBody2D

const speed = 100
var current_dir : String = "down"

var enemy_inrange = false
var enemy_attcooldown = true
var health = 100
var player_alive = true

var attack_ip = false

func player():
	pass

func _ready():
	$AnimatedSprite2D.play("idle_front")
	var tilemap_rect = get_parent().get_node("TileMap").get_used_rect() # I think think this gets all the tiles in your tile map.
	var tilemap_cell_size = get_parent().get_node("TileMap").tile_set.tile_size # this gets the size of each tile map to help with the math later
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x # this will set the limit to the camera to the left. you get the position of the last tile to the left and multiply by its size to get the exact pixle size
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x # same as above but for the right of the map. Im not sure why you use end. plz help explain.
	$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y # same as above but for the bottom
	$Camera2D.limit_top = tilemap_rect.position.y * tilemap_cell_size.y # same but for the top.

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	update_health()
	
	if health <=0:
		player_alive=false
		health = 0
		print("player has been killed")
		self.queue_free()

func player_movement(_delta):
	
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
		velocity.y = 0
		current_dir = "right"
		play_anim(1)
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
		velocity.y = 0
		current_dir = "left"
		play_anim(1)
	elif Input.is_action_pressed("move_down"):
		velocity.x = 0
		velocity.y = speed
		current_dir = "down"
		play_anim(1)
	elif Input.is_action_pressed("move_up"):
		velocity.x = 0
		velocity.y = -speed
		current_dir = "up"
		play_anim(1)
	else :
		velocity.x = 0
		velocity.y = 0
		play_anim(0)
	
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	match dir:
		"right":
			anim.flip_h = false
			if movement == 1:
				anim.play("move_side")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_side")
		"left":
			anim.flip_h = true
			if movement == 1:
				anim.play("move_side")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_side")
		"down":
			anim.flip_h = false
			if movement == 1:
				anim.play("move_front")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_front")
		"up":
			anim.flip_h = false
			if movement == 1:
				anim.play("move_back")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_back")



func _on_playerhitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inrange = true


func _on_playerhitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inrange = false

func enemy_attack():
	if enemy_inrange and enemy_attcooldown == true:
		health-=20
		enemy_attcooldown=false
		$hit_cool.start()
		print(health)


func _on_att_cool_timeout():
	enemy_attcooldown=true

func attack():
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack=true
		attack_ip = true
		match dir:
			"right":
				anim.flip_h = false
				anim.play("attack_side")
				$attack_timer.start()
			"left":
				anim.flip_h = true
				anim.play("attack_side")
				$attack_timer.start()
			"down":
				anim.flip_h = false
				anim.play("attack_front")
				$attack_timer.start()
			"up":
				anim.flip_h = false
				anim.play("attack_back")
				$attack_timer.start()


func _on_attack_timer_timeout():
	$attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

func update_health():
	var healthbar = $health_bar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regain_timer_timeout():
	if health <100 :
		health += 20
		if health >100 :
			health = 100
	if health <= 0:
		health = 0
