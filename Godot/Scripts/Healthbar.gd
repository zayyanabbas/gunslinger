extends TextureProgress

var bar_red = preload("res://Textures/UI/redbar.png")
var bar_green = preload("res://Textures/UI/greenbar.png")
var bar_yellow = preload("res://Textures/UI/yellowbar.png")

onready var healthbar = $"."

func _ready():
	hide()
	healthbar.max_value = get_parent().get("health")

func update_healthbar(_value):
	healthbar.texture_progress = bar_green
	if _value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if _value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	if _value < healthbar.max_value:
		show()
	healthbar.value = _value

