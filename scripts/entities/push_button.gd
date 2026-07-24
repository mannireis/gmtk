extends Area2D
class_name PushButton2D

signal pressed
signal exited

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var pressing_bodies: int = 0

func _on_body_entered(body: Node2D) -> void:
	pressing_bodies += 1
	if not pressing_bodies == 0:
		animated_sprite_2d.play("default")
		pressed.emit()


func _on_body_exited(body: Node2D) -> void:
	pressing_bodies -= 1
	if pressing_bodies == 0:
		animated_sprite_2d.play("default_2")
		pressing_bodies = 0 
		exited.emit()
