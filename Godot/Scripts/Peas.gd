extends Area2D

export var speed = 5000
export (float) var custom_rot = 0.0
export (Vector2) var used_transform
export (Array) var shootables = []
export (Array) var blockables = []
export var damage = 10

func _process(delta):
	position += used_transform * delta * speed

func _on_Area2D_body_entered(body):
	for blocked in blockables:
		if body.name == blocked:
			return
	queue_free()
	
	for shoot in shootables:
		if (body.is_in_group(shoot)):
			body.shot(damage)
