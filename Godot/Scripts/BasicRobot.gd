extends KinematicBody2D

export(NodePath) var target
var which_direction = true
var direction: Vector2
export var speed = 5000
var gravity = 1500
export var g_velocity = 0
var velocity = Vector2.ZERO
export var jump_speed = -40000
export (PackedScene) var GunScene
onready var gun = GunScene.instance()
export var health = 100
export var force = Vector2.ZERO

var aim_duration = 0.25
var aim_time = 0
var aim_timer = 0
var aim_rotation: float

var shooting = false
var shoot_timer: float

func shoot():
	get_node("Robo/ArmR/Peashooter").shoot(["shootable"], ["BasicRobot"], which_direction)

func aim():
	var direction = (target.global_position - global_position)
	
	if which_direction:
		direction = Vector2(direction.y, -direction.x)
	else:
		direction = direction - 2*(direction * Vector2(0,1)) * Vector2(0,1)
		direction = Vector2(-direction.y, direction.x)
	aim_rotation = direction.angle()

func get_direction():
	if (target.position.x < position.x):
		direction = Vector2(-1, 0)
		which_direction = false
	else:
		direction = Vector2(1, 0)
		which_direction = true
	$Robo.transform.x = direction
	if global_position.distance_to(target.global_position) < 250:
		direction = Vector2(0,0)

func _ready():
	gun.position = $Robo/ArmR.position
	$Robo/ArmR.add_child(gun)

func obstacle_nearby():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, global_position + Vector2(75*direction.x,0), [self], ~collision_mask)
	return result

func shot(damage):
	health -= damage
	$Healthbar.update_healthbar(health)
	if (health <= 0):
		queue_free()

func set_target(_target):
	if global_position.distance_squared_to(_target.global_position) <= 300000:
		target = _target

func _process(delta):
	velocity = Vector2.ZERO
	if is_instance_valid(target):
		get_direction()
	else:
		direction.x = 0
	if is_on_floor():
		g_velocity = 0
		if obstacle_nearby():
			g_velocity = jump_speed
	
	g_velocity += gravity
	
	velocity.y += g_velocity
	velocity.x += direction.x * speed
	
	aim_timer += delta
	if (is_instance_valid(target) and aim_timer >= 2):
		aim()
		if aim_time < aim_duration:
			aim_time += delta
			$Robo/ArmR.rotation = lerp(rotation, aim_rotation, aim_time/aim_duration)
		else:
			aim_time = 0
			aim_timer = 0
			shooting = true
	
	if (shooting):
		shoot_timer += delta
		if (shoot_timer >= 1):
			shoot()
			shoot_timer = 0
			shooting = false
	
	if force.length_squared() >= 10:
		velocity += force*delta
		force -= (force+velocity)*delta*2
		force.y -= g_velocity*delta
	else:
		force = Vector2(0,0)
	
	move_and_slide(velocity * delta, Vector2(0,-1))
