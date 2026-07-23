extends Area2D


@onready var sprite = $Sprite2D


enum states {IDLE, PRESSED}
var state = states.IDLE


func _process(delta: float) -> void:
	if state == states.PRESSED:
		sprite.scale.y = 0.06
	else:
		sprite.scale.y = 0.08


func _change_state() -> void:
	state = states.PRESSED if state == states.IDLE else states.IDLE


func _on_body_exited(body: Node2D) -> void:
	_change_state()
	print("collide yay")


func _on_body_entered(body: Node2D) -> void:
	_change_state()
