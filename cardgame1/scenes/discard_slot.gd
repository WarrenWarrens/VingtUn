#extends Node2D
#
#const MAX_DISCARDS = 4
#var discard_count = 0
#var deck_reference
#var player_hand_reference
#const DIV1 = "/4"
#
#func on_round_reset() -> void:
	#discard_count = 0
		#
#func _ready() -> void:
	#deck_reference = $"../Deck"
	#player_hand_reference = $"../PlayerHand"
#
#
#func is_full() -> bool:
	#return discard_count >= MAX_DISCARDS
#
#func discard_card(card) -> void:
	#if is_full():
		#return
	#discard_count += 1
	#player_hand_reference.remove_card_from_hand(card)
	#card.queue_free()
	#deck_reference.draw_card()
	#
#

extends Node2D

const MAX_CARDS = 4
const CARD_STACK_OFFSET = Vector2(50, -50)  
const MAX_DISCARDS = 4
var discard_count = 0
var deck_reference
var player_hand_reference
const DIV1 = "/4"

var cards_in_slot = []

var base_shape_size: Vector2

func _ready() -> void:
	discard_count = 0
	var shape = $Area2D/CollisionShape2D.shape
	base_shape_size = shape.size

func get_card_in_slot():
	return cards_in_slot.size() > 0

func is_full():
	return cards_in_slot.size() >= MAX_CARDS

	
func add_card(card) -> void:
	var stack_index = cards_in_slot.size()
	cards_in_slot.append(card)
	card.position = position + CARD_STACK_OFFSET * stack_index
	card.z_index = 10 + stack_index
	update_collision_size()

	var deck = get_node_or_null("../Deck")
	if deck and deck.player_deck.size() > 0:
		deck.draw_card()

func update_collision_size():
	var count = cards_in_slot.size()
	if count == 0:
		return
	var shape = $Area2D/CollisionShape2D.shape.duplicate()
	shape.size = base_shape_size + Vector2(
		abs(CARD_STACK_OFFSET.x) * (count - 1),
		abs(CARD_STACK_OFFSET.y) * (count - 1)
	)
	$Area2D/CollisionShape2D.shape = shape
	$Area2D/CollisionShape2D.position = Vector2(
		CARD_STACK_OFFSET.x * (count - 1) / 2.0,
		CARD_STACK_OFFSET.y * (count - 1) / 2.0
	)

func clear_slot():
	print("Clearing ", cards_in_slot.size(), " cards")
	for card in cards_in_slot:
		card.queue_free()
	cards_in_slot.clear()
	var shape = $Area2D/CollisionShape2D.shape.duplicate()
	shape.size = base_shape_size
	$Area2D/CollisionShape2D.shape = shape
	$Area2D/CollisionShape2D.position = Vector2.ZERO

func _on_clear_button_pressed() -> void:
	if cards_in_slot.size() == 0:
		print("No cards played!")
		return
	GameManager.evaluate_play(cards_in_slot)
	clear_slot()


func _on_play_pressed() -> void:
	if cards_in_slot.size() == 0:
		print("No cards played!")
		return
	GameManager.evaluate_play(cards_in_slot)
	clear_slot()
