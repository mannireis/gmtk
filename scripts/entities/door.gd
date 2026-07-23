extends StaticBody2D

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

enum states {IDLE, PRESSED}


func _on_push_button_state_changed(state: states) -> void:
	if state == states.PRESSED:
		collision_shape.set_deferred("disabled", true)
		sprite.modulate.a = 0.7 # transparency
	else: 
		collision_shape.set_deferred("disabled", false)
		sprite.modulate.a = 1.0
