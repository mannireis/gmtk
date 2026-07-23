class_name Level
extends Node2D

@export var spawn_point: Marker2D

func _get_spawn_point() -> Vector2:
	return spawn_point.global_position
