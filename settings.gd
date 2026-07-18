extends Node

const SETTINGS_PATH := "user://settings.save"

signal settings_changed

var settings := {
	&"sens_x": 0.07,
	&"sens_y": 0.07,
	&"invert_y": true,
}

func _ready() -> void:
	load_settings()

func update_setting(setting_name: StringName, value: float) -> void:
	settings[setting_name] = value
	settings_changed.emit()
	save_settings()

func get_setting(setting_name: StringName) -> Variant:
	return settings[setting_name]

func save_settings() -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(settings, "\t"))
		file.close()

func load_settings() -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		var result: Variant = JSON.parse_string(file.get_as_text())
		if result is Dictionary:
			settings = result
		file.close()
