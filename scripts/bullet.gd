extends Area2D
@export var velocity = 300

var movement_direction: Vector2
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D


func initialize_direction(new_direction: Vector2):
	movement_direction = new_direction

func _process(delta):
	position += movement_direction * velocity * delta
	
func _ready():
	await get_tree().create_timer(1).timeout
	initialize_direction(Vector2.ZERO)
	await get_tree().create_timer(1).timeout
	queue_free()
