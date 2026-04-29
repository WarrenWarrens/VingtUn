extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const DEFAULT_CARD_MOVE_SPEED = 0.1
const COLLISION_MASK_DISCARD_SLOT = 8  
@onready var drag_layer = $"../Main/DragLayer" 


var card_being_dragged 
var screen_size
var is_hovering_on_card
var player_hand_reference


func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)
	
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(
			clamp(mouse_pos.x,0,screen_size.x), 
		clamp(mouse_pos.y,0,screen_size.y))
		
func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(2.7, 2.7)
	var original_pos = card.global_position
	card.reparent(drag_layer)
	card.global_position = original_pos
	

	#
#func finish_drag():
	#card_being_dragged.scale = Vector2(2.7, 2.7)
#
	#var discard_slot_found = raycast_check_for_discard_slot()
	#if discard_slot_found and discard_slot_found.has_method("discard_card") and not discard_slot_found.is_full():
		#reparent_card_back(card_being_dragged)
		#discard_slot_found.discard_card(card_being_dragged)
		#card_being_dragged = null
		#return
#
	#var card_slot_found = raycast_check_for_card_slot()
	#if card_slot_found and card_slot_found.has_method("add_card") and not card_slot_found.is_full():
		#reparent_card_back(card_being_dragged)
		#player_hand_reference.remove_card_from_hand(card_being_dragged)
		#card_slot_found.add_card(card_being_dragged)
		#card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
	#else:
		#reparent_card_back(card_being_dragged)
		#player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)
	#card_being_dragged = null

func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)

	# Check discard slot first
	var discard_slot_found = raycast_check_for_discard_slot()
	if discard_slot_found and discard_slot_found.has_method("add_card") and not discard_slot_found.is_full():
		reparent_card_back(card_being_dragged)
		player_hand_reference.remove_card_from_hand(card_being_dragged)
		discard_slot_found.add_card(card_being_dragged)
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_being_dragged = null
		return

	# Then check play slot
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found and card_slot_found.has_method("add_card") and not card_slot_found.is_full():
		reparent_card_back(card_being_dragged)
		player_hand_reference.remove_card_from_hand(card_being_dragged)
		card_slot_found.add_card(card_being_dragged)
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
	else:
		reparent_card_back(card_being_dragged)
		player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)
	card_being_dragged = null
	
func reparent_card_back(card):
	var original_pos = card.global_position
	card.reparent(get_node("../CardManager"))  
	card.global_position = original_pos
		

func raycast_check_for_discard_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_DISCARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

func on_left_click_released():
	if card_being_dragged:
		finish_drag()

	
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card,true)

func on_hovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card,false)
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered,true)
		else:
			is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(2.5,2.5)
		card.z_index = 2
	else:
		card.scale = Vector2(2.5,2.5)
		card.z_index = 1
	
func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT 

	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD 

	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	for i in range(1,cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
