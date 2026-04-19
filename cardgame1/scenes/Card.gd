extends Node2D

signal hovered
signal hovered_off

var hand_position
var suit: String
var rank: String  
var value: int
var RANK_TO_FILENAME = {
	"ace": "ace", "2": "two", "3": "three", "4": "four",
	"5": "five", "6": "six", "7": "seven", "8": "eight",
	"9": "nine", "10": "ten", "jack": "jack", "queen": "queen", "king": "king"
}


func _ready() -> void:
	get_parent().connect_card_signals(self)

func setup(card_data: Dictionary) -> void:
	suit  = card_data["suit"]
	rank  = card_data["rank"]
	value = card_data["value"]
	var rank_name = RANK_TO_FILENAME.get(rank,rank.to_lower())
	var texture_path = "res://assets/cards/%s_of_%s.png" % [rank_name, suit.to_lower()]
	$CardImage.texture = load(texture_path)

func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered",self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off",self)
