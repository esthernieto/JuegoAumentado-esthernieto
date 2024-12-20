extends CharacterBody2D

const MOVEMENT_SPEED = 120
const JUMP_FORCE = -300
var facing_direction = 1
var is_ready_to_throw = true
@export var projectile_scene: PackedScene = preload("res://scenes/bullet.tscn")
@export var throw_delay: float = 1

@onready var state_machine_controller = $Player_State_Machine["parameters/playback"]

func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var move_input := Input.get_axis("ui_left", "ui_right")

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		state_machine_controller.travel("jump")

	if Input.is_action_just_pressed("throw_attack") and is_ready_to_throw:
		launch_projectile(move_input)
		is_ready_to_throw = false

	if not is_ready_to_throw:
		throw_delay -= delta
		if throw_delay <= 0:
			is_ready_to_throw = true
			throw_delay = 0.5

	if move_input != 0:
		facing_direction = move_input
		$Player_Sprite.flip_h = move_input < 0
		velocity.x = move_input * MOVEMENT_SPEED
		state_machine_controller.travel("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, MOVEMENT_SPEED)

	if is_on_floor() and velocity.x == 0:
		state_machine_controller.travel("idle")

	if not is_on_floor() and velocity.y < 0:
		state_machine_controller.travel("jump")

	move_and_slide()

func launch_projectile(_input_direction: float):
	state_machine_controller.travel("throw_attack")
	
	var projectile = projectile_scene.instantiate()
	
	projectile.position = global_position + Vector2(facing_direction * 15, -7)
	
	var projectile_direction = Vector2(facing_direction, 0).normalized()

	projectile.initialize_direction(projectile_direction)
	
	get_parent().add_child(projectile)
