extends Area2D

@export var target_scene: String
@export var scene = "res://scenes/game2.tscn"

func change_scene():
	get_tree().change_scene_to_file(scene)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		call_deferred("change_scene")
