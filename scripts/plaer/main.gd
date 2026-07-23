extends CharacterBody2D

@onready var death_timer: Timer = $DeathTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer

@export var corpse_scene: PackedScene

const jump_height: float = -230.0
const max_gravity: float = 14.5
const max_speed: float = 120.0
const accelaration: float = 8.0
const friction: float = 10.0

var coyote_time_activated: bool = false

var gravity: float = 12.0

var spawn_point: Vector2


func _ready() -> void:
	var level := get_tree().current_scene as Level
	death_timer.start()
	if level:
		spawn_point = level._get_spawn_point()

func _physics_process(delta: float) -> void:
	$CanvasLayer/Label.text = str(death_timer.time_left)
	
	
	var x_input: float = Input.get_axis("Left", "Right")
	var velocity_weight: float = delta * (accelaration if x_input else friction)
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	
	if is_on_floor():
		coyote_time_activated = false
		gravity = lerp(gravity, 12.8, 12.0 * delta)
	else:
		if coyote_timer.is_stopped() and !coyote_time_activated:
			coyote_timer.start()
			coyote_time_activated = true
		
		if Input.is_action_just_released("Jump") or is_on_ceiling():
			velocity.y *= 0.5
		
		gravity = lerp(gravity, max_gravity, 12.3 * delta)

	if Input.is_action_just_pressed("Jump"):
		if jump_buffer_timer.is_stopped():
			jump_buffer_timer.start()
		if not jump_buffer_timer.is_stopped() and (not coyote_timer.is_stopped()) or is_on_floor():
			velocity.y = jump_height
			jump_buffer_timer.stop()
			coyote_timer.stop()
			coyote_time_activated = true
	
	velocity.y += gravity
	
	move_and_slide()


func _spawn_corpse() -> void:
	# We need to create a scene that is called corpse that is a RigidBody2D and then spawn that scene in the players location - maddy [X]
	print("spawning corpse")
	var corpse = corpse_scene.instantiate()
	corpse.global_position = global_position
	get_parent().add_child(corpse)


func _respawn() -> void:
	_spawn_corpse()
	global_position = spawn_point
	velocity = Vector2.ZERO
	death_timer.start()


func _on_death_timer_timeout() -> void:
	_respawn()
