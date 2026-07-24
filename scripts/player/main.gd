extends CharacterBody2D

signal player_respawned

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var Collision = $CollisionShape2D
@onready var animation = $AnimatedSprite2D

@export var corpse_scene: PackedScene

const jump_height: float = -150
const max_gravity: float = 14.5
const max_speed: float = 120.0
const accelaration: float = 8.0
const friction: float = 10.0
const push_force: float = 100.0

var coyote_time_activated: bool = false

var gravity: float = 12.0

var spawn_point: Vector2

var meow = 0

func _ready() -> void:
	var level := get_tree().current_scene as Level
	if level:
		spawn_point = level._get_spawn_point()

func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_axis("Left", "Right")
	var velocity_weight: float = delta * (accelaration if x_input else friction)
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	
	if x_input:
		animation.play("walk")
	if x_input == -1:
		animation.flip_h = true
	elif x_input == 1:
		animation.flip_h = false
	
	if is_on_floor():
		if velocity.x == 0:
			animation.play("idle")
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
			animation.play("jump")
			velocity.y = jump_height
			jump_buffer_timer.stop()
			coyote_timer.stop()
			coyote_time_activated = true
	
	velocity.y += gravity
	
	# this is how you move corpses around! but it needs a LOT of work
	# good luck x -mart
	var pushed_bodies: Array[RigidBody2D] = []
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D and not collider in pushed_bodies:
			var push_dir = -collision.get_normal()
			push_dir.y = 0
			collider.apply_central_impulse(push_dir.normalized() * push_force * delta * 60.0)
			pushed_bodies.append(collider)

	move_and_slide()



func _spawn_corpse() -> void:
	# We need to create a scene that is called corpse that is a RigidBody2D and then spawn that scene in the players location - maddy [X]
	var death_pos = global_position
	print("spawning corpse")
	var corpse = corpse_scene.instantiate()
	corpse.global_position = death_pos
	get_parent().add_child(corpse)


func _respawn() -> void:
	global_position = spawn_point
	velocity = Vector2.ZERO
	player_respawned.emit()
	meow += 1
	print(meow)
