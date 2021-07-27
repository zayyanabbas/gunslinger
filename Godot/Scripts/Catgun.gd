extends Sprite

export (PackedScene) var bullet
export var shoot_time = 5

func unsetup():
	move_local_y(-$".".texture.get_size().y*1.5)
	move_local_x($".".texture.get_size().x/1.75)

func _ready():
	rotation_degrees = 90
	translate($".".texture.get_size())
	move_local_y($".".texture.get_size().x/4)
	show_behind_parent = true
	scale = Vector2(2, 2)

func shoot(var shootables: Array, var blocked: Array, var direction: bool):
	var b = bullet.instance()
	get_tree().get_root().add_child(b)
	
	b.shootables = shootables
	b.blockables = blocked
	#b.scale = Vector2(0.25,0.25)
	#b.global_position = global_position
	b.transform = get_parent().transform
	b.transform.origin = global_position
	b.transform.x /= 2
	b.transform.y /= 2
	
	if direction:
		b.used_transform = b.transform.y
	else:
		b.used_transform = Vector2(b.transform.x.y, b.transform.x.x)
