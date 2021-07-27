extends Control

# Dict { string -> array [ subject, body, path ] }
export (Dictionary) var dialogues
export (String) var image_path
export var tree_idx = 0

var original_pos: Vector2
var chosen_index = 0

func _input(event):
	if event is InputEventKey:
		if event.is_pressed() == false:
			if event.scancode == KEY_DOWN:
				chosen_index += 1
				if chosen_index > dialogues.keys().size()-1:
					chosen_index = dialogues.keys().size()-1
			if event.scancode == KEY_UP:
				chosen_index -= 1
				if chosen_index < 0:
					chosen_index = 0
			if event.scancode == KEY_ENTER:
				queue_free()
				get_tree().get_nodes_in_group("dialoguetree")[0].dialogues.insert(tree_idx, ["d",dialogues[dialogues.keys()[chosen_index]]])
				get_tree().call_group("dialoguetree", "dialogue_over")

func _ready():
	original_pos = $TextPanel/Cursor.position
	$TextPanel/Dialogue.text = ""
	$PicturePanel/TextureRect.texture = load(image_path)
	$PicturePanel/TextureRect.set_scale(Vector2(0.8,0.8))
	$TextPanel/Subject.text = "What do you wanna say?"
	for text in dialogues.keys():
		$TextPanel/Dialogue.text += text + "\n"

func _process(delta):
	$TextPanel/Cursor.position.y = original_pos.y + chosen_index*75
