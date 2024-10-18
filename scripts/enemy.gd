extends CharacterBody2D



var speed = 20
var player_chase = false
var player = null
var health = 100
var player_inattack_zone = false
var direction : Vector2
var test : Vector2
var can_take_damage = true
@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	test = velocity
	damages()
	update_health()
	if player_chase :
		direction = player.get_global_position() - position
		velocity = (player.get_global_position() - position).normalized() * speed
		if direction.angle()>=-PI/4 && direction.angle()<PI/4:
			animated_sprite_2d.flip_h=false
			animated_sprite_2d.play('move_side')
		elif direction.angle()>=PI/4 && direction.angle()<3*PI/4:
			animated_sprite_2d.flip_h=false
			animated_sprite_2d.play('move_front')
		elif direction.angle()>=3*PI/4 || direction.angle()<-3*PI/4:
			animated_sprite_2d.flip_h=true
			animated_sprite_2d.play('move_side')
		elif direction.angle()>=-3*PI/4 && direction.angle()<-PI/4:
			animated_sprite_2d.flip_h=false
			animated_sprite_2d.play('move_back')
	else:
		velocity = lerp(velocity, Vector2.ZERO, delta*3)
		if direction.angle()>=-PI/4 && direction.angle()<PI/4:
			animated_sprite_2d.flip_h=false
			animated_sprite_2d.play('idle_side')
		elif direction.angle()>=PI/4 && direction.angle()<3*PI/4:
			animated_sprite_2d.flip_h=false
			animated_sprite_2d.play('idle_front')
		elif direction.angle()>=3*PI/4 || direction.angle()<-3*PI/4:
			animated_sprite_2d.flip_h=true
			animated_sprite_2d.play('idle_side')
		elif direction.angle()>=-3*PI/4 && direction.angle()<-PI/4:
			animated_sprite_2d.flip_h=false
			animated_sprite_2d.play('idle_back')
	move_and_collide(velocity * delta)

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player = null
		player_chase = false

func enemy():
	pass

func _on_enemyhitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone=true


func _on_enemyhitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone=false

func damages():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true :
			health = health - 20
			$hit_cool.start()
			can_take_damage = false
			print("slime health = ", health)
			if health <=0:
				
				self.queue_free()


func _on_hit_cool_timeout():
	can_take_damage = true

func update_health():
	var healthbar = $health_bar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
