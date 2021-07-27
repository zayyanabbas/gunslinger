extends Node2D
export (PackedScene) var bullet
export var shoot_time = 0.1

func unsetup():
	move_local_x($".".texture.get_size().x*1.5)
	move_local_y(-$".".texture.get_size().y*2)

func _ready():
	rotation_degrees = 90
	translate($".".texture.get_size())
	move_local_x($".".texture.get_size().x)
	show_behind_parent = true

func shoot(var shootables: Array, var blocked: Array, var direction: bool):
	var b = bullet.instance()
	get_tree().get_root().add_child(b)
	
	b.shootables = shootables
	b.blockables = blocked
	
	b.transform = get_parent().transform
	b.move_local_x(100)
	b.transform.origin = global_position
	b.transform.x /= 5
	b.transform.y /= 5
	
	if direction:
		b.used_transform = b.transform.y
	else:
		b.used_transform = Vector2(b.transform.x.y, b.transform.x.x)
