extends Area2D

export var speed = 1000
export (float) var custom_rot = 0.0
export (Vector2) var used_transform
export (Array) var shootables = []
export (Array) var blockables = []
export (PackedScene) var explosion
export var damage = 50

func _process(delta):
	position += used_transform * delta * speed
	rotate(deg2rad(15))

func _on_Kitty_body_entered(body):
	for blocked in blockables:
		if body.name == blocked:
			return
	queue_free()
	
	for shoot in shootables:
		if (body.is_in_group(shoot)):
			body.shot(damage)
	
	var b = explosion.instance()
	get_tree().get_root().add_child(b)
	b.global_position = global_position
