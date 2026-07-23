class_name BaseLevel
extends Node2D

@onready var spawn_point: Marker2D = $SpawnPoint

func _get_spawn_point() -> Vector2:
	return spawn_point.global_position
