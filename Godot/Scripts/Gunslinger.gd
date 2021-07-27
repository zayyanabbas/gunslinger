extends KinematicBody2D

export var speed = 10000
export var run_multiplier = 1.75
export var jump_speed = -40000
export var which_direction = true
export var health = 100
export var force = Vector2.ZERO
var is_running = false
var velocity = Vector2.ZERO
var gravity = 1500
export var g_velocity = 0
var shoot_timer = 0.5

var able_to_move = true

var dialogue_moment = false

var gun_index = 0
var gun_list = []

func _ready():
	gun_list.append(preload("res://Scenes/Peashooter.tscn").instance())
	gun_list[0].position = $Body/ArmR.position
	gun_list[0].name = "gun"
	$Body/ArmR.add_child(gun_list[0])
	
	$Healthbar.max_value = health
	gun_list.append(preload("res://Scenes/Catgun.tscn").instance())
	gun_list[1].name = "gun"

func _input(event):
	if event is InputEventKey:
		if !event.is_pressed():
			$AnimationPlayer.play("Idle")
		if event.scancode == KEY_PERIOD && event.is_pressed() == false:
			gun_index += 1
			if (gun_index >= len(gun_list)):
				gun_index = 0
			$Body/ArmR/gun.replace_by(gun_list[gun_index])
			gun_list[gun_index].position = $Body/ArmR.position
			gun_list[gun_index].name = "gun"
			gun_list[gun_index].unsetup()

func shot(damage):
	health -= damage
	$Healthbar.update_healthbar(health)
	if (health <= 0):
		queue_free()

func _process(delta):
	velocity = Vector2.ZERO
	shoot_timer += delta
	
	get_tree().call_group("hostile", "set_target", self)
	
	if Input.is_key_pressed(KEY_J) and shoot_timer >= get_node("Body/ArmR/gun").shoot_time:
		get_node("Body/ArmR/gun").shoot(["shootable"], ["Player", "Gunslinger"], which_direction)
		shoot_timer = 0
	
	if Input.is_key_pressed(KEY_SHIFT):
		is_running = true
	else:
		is_running = false
	if Input.is_key_pressed(KEY_D) and able_to_move:
		if is_on_floor():
			$AnimationPlayer.play("Walk")
		if !which_direction:
			$Body.transform.x = Vector2(1,0)
		which_direction = true
		if is_running:
			$AnimationPlayer.playback_speed = run_multiplier
			velocity.x += speed * run_multiplier
		else:
			$AnimationPlayer.playback_speed = 1
			velocity.x += speed
	elif Input.is_key_pressed(KEY_A) and able_to_move:
		if is_on_floor():
			$AnimationPlayer.play("Walk")
		if which_direction:
			$Body.transform.x = Vector2(-1,0)
		which_direction = false
		if is_running:
			$AnimationPlayer.playback_speed = run_multiplier
			velocity.x -= speed * run_multiplier
		else:
			$AnimationPlayer.playback_speed = 1
			velocity.x -= speed
	if is_on_floor():
		g_velocity = 0
		if Input.is_key_pressed(KEY_SPACE) and able_to_move:
			g_velocity = jump_speed
			$AnimationPlayer.play("InAir")
		if not Input.is_key_pressed(KEY_A) and not Input.is_key_pressed(KEY_D):
			$AnimationPlayer.play("Idle")
	g_velocity += gravity
	
	var direction = (get_global_mouse_position() - global_position).normalized()
		
	if which_direction:
		direction = Vector2(direction.y, -direction.x)
	else:
		direction = direction - 2*(direction * Vector2(0,1)) * Vector2(0,1)
		direction = Vector2(-direction.y, direction.x)
	$Body/ArmR.rotation = direction.angle()
	
	velocity.y += g_velocity
	
	if force.length_squared() >= 10:
		velocity += force*delta
		force -= (force+velocity)*delta*2
		force.y -= g_velocity*delta
	else:
		force = Vector2(0,0)
	velocity = move_and_slide(velocity*delta, Vector2(0,-1))
