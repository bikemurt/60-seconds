@tool
class_name ProtoSimplePause
extends CanvasLayer

@export_tool_button("Generate Nodes") var initialize_nodes := func() -> void:
	for c in get_children(): c.free()
	
	var panel := Panel.new()
	panel.custom_minimum_size = Vector2(400,400)
	panel.position = Vector2(50, 50)
	Proto.add_node(self, panel)
	
	var vbox := VBoxContainer.new()
	vbox.size = Vector2(400,400)
	Proto.add_node(panel, vbox)
	
	var label := Label.new()
	label.text = "Pause Menu"
	Proto.add_node(vbox, label)
	
	resume_button = Button.new()
	resume_button.text = "Resume"
	Proto.add_node(vbox, resume_button)
	
	quit_button = Button.new()
	quit_button.text = "Quit"
	Proto.add_node(vbox, quit_button)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	Proto.proto_print("Simple pause nodes configured")

@export var load_on_ready := true

@export var hidden_mouse_mode := Input.MOUSE_MODE_CAPTURED
@export var visible_mouse_mode := Input.MOUSE_MODE_VISIBLE

@export var resume_button: Button
@export var quit_button: Button

@onready var sens_xh_slider: HSlider = %SensXHSlider
@onready var sens_yh_slider: HSlider = %SensYHSlider
@onready var invert_y_check_box: CheckButton = %InvertYCheckBox

func _ready() -> void:
	if Engine.is_editor_hint():
		if load_on_ready:
			if get_child_count() == 0: initialize_nodes.call()
		
		set_process(false)
	else:
		hide()
		visibility_changed.connect(on_visibility_changed)
		resume_button.pressed.connect(func() -> void:
			visible = false
			Input.mouse_mode = hidden_mouse_mode
			)
		quit_button.pressed.connect(get_tree().quit)
		
		update_settings()

func _process(_delta: float) -> void:
	if InputMap.has_action(&"pause"):
		if Input.is_action_just_pressed(&"pause"):
			visible = not visible

func on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		Input.mouse_mode = visible_mouse_mode
	else:
		get_tree().paused = false
		Input.mouse_mode = hidden_mouse_mode

func update_settings() -> void:
	sens_xh_slider.value = Settings.get_setting(&"sens_x")
	sens_yh_slider.value = Settings.get_setting(&"sens_y")
	invert_y_check_box.button_pressed = Settings.get_setting(&"invert_y")

func _on_sens_xh_slider_drag_ended(_value_changed: bool) -> void:
	Settings.update_setting(&"sens_x", sens_xh_slider.value)

func _on_sens_yh_slider_drag_ended(_value_changed: bool) -> void:
	Settings.update_setting(&"sens_y", sens_yh_slider.value)

func _on_invert_y_check_box_pressed() -> void:
	Settings.update_setting(&"invert_y", invert_y_check_box.button_pressed)
