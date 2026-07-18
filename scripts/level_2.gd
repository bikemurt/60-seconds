extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"character"):
		get_tree().change_scene_to_file.call_deferred("res://scenes/level_1.tscn")
