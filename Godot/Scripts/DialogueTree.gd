extends Node

# ["d", [str. str. str, opt: [dict. str] ]
# ["c", [dict. str] ]

# Array of arrays like above
export(Array) var dialogues
var current = 0

var dialogue_box_preset = preload("res://Scenes/DialogueBox.tscn")
var conversation_box_preset = preload("res://Scenes/ConversationBox.tscn")

export(bool) var dialogue_happening

func create_box():
	#print(dialogues, "\n\n\n\n")
	dialogue_happening = !dialogues.empty()
	if dialogues.empty():
		get_parent().get_tree().get_nodes_in_group("player")[0].able_to_move = true
		return
	get_parent().get_tree().get_nodes_in_group("player")[0].able_to_move = false
	if (dialogues[current][0] == "d"):
		var dialogue_box = dialogue_box_preset.instance()
		dialogue_box.subject_text = dialogues[current][1][0]
		dialogue_box.dialogue_text = dialogues[current][1][1]
		dialogue_box.image_path = dialogues[current][1][2]
		
		if (dialogues[current][1].size() == 4):
			dialogues.insert(1, ["c", dialogues[current][1][3]])
		
		get_tree().get_nodes_in_group("player")[0].get_node("Camera2D/GUI").add_child(dialogue_box)
	else:
		var conversation_box = conversation_box_preset.instance()
		conversation_box.dialogues = dialogues[current][1][0]
		conversation_box.image_path = dialogues[current][1][1]
		conversation_box.tree_idx = 0
		get_tree().get_nodes_in_group("player")[0].get_node("Camera2D/GUI").add_child(conversation_box)
	dialogues.pop_front()

func _ready():
	create_box()

func dialogue_over():
	create_box()
