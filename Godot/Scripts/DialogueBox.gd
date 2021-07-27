extends Control

var lapsed = 0
export (String) var subject_text
export (String) var dialogue_text
export (String) var image_path

func _input(event):
	if event is InputEventKey:
		if event.is_pressed() == false:
			if event.scancode == KEY_ENTER:
				if  $TextPanel/Dialogue.visible_characters >= $TextPanel/Dialogue.get_total_character_count():
					queue_free()
					get_tree().call_group("dialoguetree", "dialogue_over")
				else:
					$TextPanel/Dialogue.visible_characters = $TextPanel/Dialogue.get_total_character_count()

func _ready():
	$TextPanel/Subject.text = subject_text
	$TextPanel/Dialogue.text = dialogue_text
	$PicturePanel/TextureRect.texture = load(image_path)
	$PicturePanel/TextureRect.set_scale(Vector2(0.8,0.8))

func _process(delta):
	lapsed += delta
	if $TextPanel/Dialogue.visible_characters < $TextPanel/Dialogue.get_total_character_count():
		$TextPanel/Dialogue.visible_characters = lapsed/0.1
