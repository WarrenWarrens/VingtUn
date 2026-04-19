extends Node

enum View { GAME, SHOP }
var current_view: View = View.GAME

@onready var game_view = $GameView
@onready var shop_view = $ShopView

@onready var play_button = get_node_or_null("/root/Main/UI/GUI/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/Play")
@onready var continue_button = get_node_or_null("/root/Main/UI/GUI/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/Continue")
@onready var game_bg = get_node_or_null("/root/Main/Background/BG1")  
@onready var shop_bg = get_node_or_null("/root/Main/Background/BG2")
func _ready() -> void:
	show_game()

func show_game() -> void:	
	current_view = View.GAME
	game_view.visible = true
	shop_view.visible = false
	game_view.process_mode = Node.PROCESS_MODE_INHERIT
	shop_view.process_mode = Node.PROCESS_MODE_DISABLED
	if game_bg: game_bg.visible = true
	if shop_bg: shop_bg.visible = false
	if play_button:
		play_button.visible = true
	if continue_button:
		continue_button.visible = false

	await get_tree().process_frame
	var deck = game_view.get_node_or_null("Deck")
	if deck:
		for i in range(5):
			deck.draw_card()
	GameManager.refresh_gui()
	
func show_shop() -> void:
	current_view = View.SHOP
	shop_view.visible = true
	game_view.visible = false
	game_view.process_mode = Node.PROCESS_MODE_DISABLED
	shop_view.process_mode = Node.PROCESS_MODE_INHERIT
	if game_bg: game_bg.visible = false
	if shop_bg: shop_bg.visible = true
	if play_button:
		play_button.visible = false
	if continue_button:
		continue_button.visible = true

func _on_continue_pressed() -> void:
	get_node("/root/Main").show_game()
	
