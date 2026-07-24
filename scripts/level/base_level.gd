class_name Level
extends Node2D

signal death_timer_timed_out

@export var spawn_point: Marker2D

@onready var player = $CharacterBody2D
@onready var camera = $Camera2D
@onready var death_timer = $DeathTimer
@onready var hud = $HUD


func _ready() -> void:
	death_timer.start()


func _physics_process(delta: float) -> void:
	hud.set_timer_label(death_timer.time_left)
	camera.position.x = player.position.x


func _get_spawn_point() -> Vector2:
	return spawn_point.global_position


func _on_death_timer_timeout() -> void:
	player._spawn_corpse()
	await get_tree().create_timer(0.05).timeout
	player._respawn()


func _on_character_body_2d_player_respawned() -> void:
	death_timer.start()
