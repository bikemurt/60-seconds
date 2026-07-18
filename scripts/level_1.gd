extends Node3D

const LEVEL_2 = preload("uid://yo6k0nd4uhdl")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"character"):
		get_tree().change_scene_to_packed.call_deferred(LEVEL_2)
