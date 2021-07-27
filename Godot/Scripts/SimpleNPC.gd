extends KinematicBody2D

export(String) var textures_dir
var gravity = 1500
export var g_velocity = 0
var in_area: bool

var dialogue_1 = [
	"Strange Man",
	"You don't look like you're from around here.",
	"res://Textures/Sheriff/Body.png",
	[
		{
			"I've lived here all my life!": [
				"Strange Man",
				"Oh really? Then you must know Mr. Bowler.",
				"res://Textures/Sheriff/Body.png",
				[
				{
					"Mr. Bowler is a good friend of mine!": [
							"Strange Man",
							"You liar! There ain't no Mr. Bowler, I made him up!",
							"res://Textures/Sheriff/Body.png"
						],
						"Who?": [
							"Strange Man",
							"Don't you worry about it.",
							"res://Textures/Sheriff/Body.png"
						]
					},
					"res://Textures/Gunslinger/Body.png"
				]
			],
			"I came here from Newton.": [
				"Strange Man",
				"Newton, eh? I heard there's trouble brewing down there.",
				"res://Textures/Sheriff/Body.png",
				[
					{
						"I haven't heard about any trouble.": [
							"Strange Man",
							"Don't you worry about it.",
							"res://Textures/Sheriff/Body.png"
						]
					},
					"res://Textures/Gunslinger/Body.png"
				]
			]
		},
		"res://Textures/Gunslinger/Body.png"
	]
]

func _ready():
	$Sprites/Torso.texture = load(textures_dir + "Body.png")
	$Sprites/LegR.texture = load(textures_dir + "Shoe.png")
	$Sprites/ArmR.texture = load(textures_dir + "Arm.png")
	$Sprites/LegL.texture = load(textures_dir + "Shoe.png")
	$Sprites/ArmL.texture = load(textures_dir + "Arm.png")
	$Sprites/LegL.flip_h = true
	$Sprites/ArmL.flip_h = true
	get_tree().get_nodes_in_group("dialoguetree")[0].dialogues.append(["d",dialogue_1])
	$Sprites/Ping.visible = false

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ENTER and event.is_pressed() == false:
			do_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_on_floor():
		g_velocity = 0
	g_velocity += gravity
	move_and_slide(Vector2(0,g_velocity),Vector2(0,-1))

func do_dialogue():
	if !get_tree().get_nodes_in_group("dialoguetree")[0].dialogue_happening:
		get_tree().get_nodes_in_group("dialoguetree")[0].create_box()

func _on_ConvBox_body_entered(body):
	$Sprites/Ping.visible = true
	in_area = true

func _on_ConvBox_body_exited(body):
	$Sprites/Ping.visible = false
	in_area = false
	if get_tree().get_nodes_in_group("dialoguetree")[0].dialogues.has(["d", dialogue_1]) == false:
		get_tree().get_nodes_in_group("dialoguetree")[0].dialogues.append(["d",dialogue_1])
