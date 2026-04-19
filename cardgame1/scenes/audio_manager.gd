extends Node

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

const BGM_TRACK = "res://assets/song12.mp3"
const SFX_PATHS = {
	#"card_draw":    "res://assets/audio/sfx/card_draw.wav",
	#"card_place":   "res://assets/audio/sfx/card_place.wav",
	#"card_discard": "res://assets/audio/sfx/card_discard.wav",
	#"card_flip":    "res://assets/audio/sfx/card_flip.wav",
	#"button_click": "res://assets/audio/sfx/button_click.wav",
}
func set_bgm_volume(linear: float) -> void:
	var bus_index = AudioServer.get_bus_index("BGM")
	if linear <= 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear))
		
func _ready() -> void:
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "BGM"
	add_child(bgm_player)

	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	add_child(sfx_player)

	play_bgm()

func play_bgm() -> void:
	if ResourceLoader.exists(BGM_TRACK):
		bgm_player.stream = load(BGM_TRACK)
		bgm_player.stream.loop = true
		bgm_player.play()

func play_sfx(sfx_name: String) -> void:
	if sfx_name in SFX_PATHS and ResourceLoader.exists(SFX_PATHS[sfx_name]):
		sfx_player.stream = load(SFX_PATHS[sfx_name])
		sfx_player.play()

#func set_bgm_volume(linear: float) -> void:
	#AudioServer.set_bus_volume_db(
		#AudioServer.get_bus_index("BGM"),
		#linear_to_db(linear)
	#)

func set_sfx_volume(linear: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(linear)
	)
