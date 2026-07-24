extends StaticBody2D

@export var button: PushButton2D

@onready var collision_shape = $CollisionShape2D
@onready var animation = $AnimatedSprite2D

func _ready() -> void:
	collision_shape.set_deferred("disabled", false)
	button.pressed.connect(_on_push_button_pressed)
	button.exited.connect(_on_push_button_exited)

func _on_push_button_pressed() -> void:
	animation.play("up")
	collision_shape.set_deferred("disabled", true)


func _on_push_button_exited() -> void:
	animation.play("down")
	collision_shape.set_deferred("disabled", false)
