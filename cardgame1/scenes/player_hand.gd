extends Node2D

const MAX_HAND = 5
const CARD_WIDTH = 200
const HAND_Y_POSITION = 890
const DEFAULT_CARD_MOVE_SPEED = 0.1

const PLAYABLE_WIDTH = 1340
const HAND_PADDING = 80  

var player_hand = []

func is_full() -> bool:
	return player_hand.size() >= MAX_HAND

func _ready() -> void:
	pass
	
		
func add_card_to_hand(card,speed):
	if is_full():
		return
	
	if card not in player_hand:
		player_hand.append(card)  
		update_hand_position(speed)
	else:
		animate_card_to_position(card, card.hand_position, DEFAULT_CARD_MOVE_SPEED)
		

	
func update_hand_position(speed):
	var card_count = player_hand.size()
	var spacing = calculate_card_spacing(card_count)

	var total_spread = spacing * (card_count - 1)
	var start_x = (PLAYABLE_WIDTH / 2.0) - (total_spread / 2.0)

	for i in range(card_count):
		var new_position = Vector2(start_x + i * spacing, HAND_Y_POSITION)
		var card = player_hand[i]
		card.hand_position = new_position
		card.z_index = i
		animate_card_to_position(card, new_position, speed)
		
func calculate_card_spacing(card_count: int) -> float:
	if card_count <= 1:
		return 0.0
	var available_width = PLAYABLE_WIDTH - (HAND_PADDING * 2) - CARD_WIDTH
	var ideal_spacing = float(CARD_WIDTH)
	var required_spacing = available_width / float(card_count - 1)
	return min(ideal_spacing, required_spacing)
	
func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_position(DEFAULT_CARD_MOVE_SPEED)
		
