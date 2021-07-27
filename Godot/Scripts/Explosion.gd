extends Area2D

export var max_explosion_time = 0.1
var explosion_time = 0
export var speed = 2000000
var damage_multiplier = 2000

func _process(delta):
	explosion_time += delta
	if (explosion_time >= max_explosion_time):
		queue_free()

func _on_Explosion_body_entered(body):
	if body.is_in_group("knockable"):
		body.force = Vector2(-1,-1).rotated(global_position.angle_to_point(body.global_position))*speed
		body.shot(abs( 1/((global_position-body.global_position).normalized() * damage_multiplier).x * damage_multiplier))
