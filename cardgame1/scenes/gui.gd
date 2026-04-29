extends Control

@onready var ceiling_label = get_node_or_null("ColorRect/MarginContainer/VBoxContainer/VBoxContainer/CeilingLabel")
@onready var money_label = get_node_or_null("ColorRect/MarginContainer/VBoxContainer/VBoxContainer/MoneyLabel")
@onready var deck_total_label = get_node_or_null("ColorRect/MarginContainer/VBoxContainer/VBoxContainer/DeckTotalLabel")
@onready var deck_remaining_label = get_node_or_null("ColorRect/MarginContainer/VBoxContainer/VBoxContainer/DeckRemainingLabel")
@onready var discard_label = get_node_or_null("ColorRect/MarginContainer/VBoxContainer/VBoxContainer/DiscardLabel")

func _ready() -> void:
	print("ceiling_label: ", ceiling_label)
	print("money_label: ", money_label)
	print("deck_total_label: ", deck_total_label)
	print("deck_remaining_label: ", deck_remaining_label)
	refresh()

func refresh() -> void:
	if ceiling_label:
		ceiling_label.text = "Ceiling: " + str(GameManager.ceiling)
	if money_label:
		money_label.text = "Money: $" + str(GameManager.money)
	if discard_label:
		var discard_slot = get_node_or_null("/root/Main/GameView/DiscardSlot")
		if discard_slot:
			var remaining = discard_slot.MAX_CARDS - discard_slot.cards_in_slot.size()
			discard_label.text = "Discards Left: " + str(remaining)
	#if discard_label:
		#var discard_slot = get_node_or_null("/root/Main/GameView/DiscardSlot")
		#if discard_slot:
			#var remaining = discard_slot.MAX_DISCARDS - discard_slot.discard_count
			#discard_label.text = "Discards Left: " + str(remaining)
	var deck = get_node_or_null("/root/Main/GameView/Deck")
	if deck:
		if deck_total_label:
			deck_total_label.text = "Deck Total: " + str(deck.full_deck_size)
		if deck_remaining_label:
			deck_remaining_label.text = "Cards Remaining: " + str(deck.player_deck.size())
			
