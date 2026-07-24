extends StaticBody2D

@export var button: PushButton2D
@export_enum("Right", "Left") var direction: String = "Right"

@export var rotation_value: float = 45

var final_rotation_value: float 

func _ready() -> void:
	rotation = 0
	button.pressed.connect(_on_push_button_pressed)
	button.exited.connect(_on_push_button_exited)

func _process(delta: float) -> void:
	if direction == "Right":
		final_rotation_value = -rotation_value

	if direction == "Left":
		final_rotation_value = rotation_value


func _on_push_button_pressed() -> void:
	rotation_degrees = final_rotation_value



func _on_push_button_exited() -> void:
	rotation_degrees = 0
