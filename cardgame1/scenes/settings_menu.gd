extends CanvasLayer

const PANEL_WIDTH = 400.0
const SLIDE_DURATION = 0.3
var screen_width: float
var is_open = false

func _ready() -> void:
	screen_width = get_viewport().size.x
	$Panel.position.x = screen_width
	$Overlay.visible = false
	$Overlay.modulate.a = 0.0
	$Overlay.color = Color(0, 0, 0, 0.5)

	$Overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	$BlurRect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	$BlurRect.material = ShaderMaterial.new()
	$BlurRect.material.shader = load("res://assets/shaders/blur.gdshader")

	$Panel.custom_minimum_size.x = PANEL_WIDTH
	$Panel.set_anchors_and_offsets_preset(Control.PRESET_RIGHT_WIDE)

	$Panel/VBoxContainer/CloseButton.pressed.connect(close_menu)
	$Panel/VBoxContainer/HBoxContainer/MusicSlider.value_changed.connect(
		func(val): AudioManager.set_bgm_volume(val)
	)
	$Panel/VBoxContainer/HBoxContainer2/SFXSlider.value_changed.connect(
		func(val): AudioManager.set_sfx_volume(val)
	)

func open_menu() -> void:
	if is_open:
		return
	is_open = true
	$Overlay.visible = true
	$BlurRect.visible = true

	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($Panel, "position:x", screen_width - PANEL_WIDTH, SLIDE_DURATION)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property($Overlay, "modulate:a", 1.0, SLIDE_DURATION)

func close_menu() -> void:
	if not is_open:
		return
	is_open = false
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($Panel, "position:x", screen_width, SLIDE_DURATION)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	tween.tween_property($Overlay, "modulate:a", 0.0, SLIDE_DURATION)
	await tween.finished
	$Overlay.visible = false
	$BlurRect.visible = false
