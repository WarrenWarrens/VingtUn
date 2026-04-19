
extends Node

const STARTING_CEILING = 21
var ceiling := STARTING_CEILING
var money := 100
var round_number := 1
var last_played_sum: int = 0


func evaluate_play(cards: Array) -> void:
	last_played_sum = calculate_best_sum(cards)
	print("Cards played sum: ", last_played_sum, " | Ceiling: ", ceiling)
	if last_played_sum > ceiling:
		trigger_game_over()
	else:
		trigger_round_win()
		

	
func calculate_best_sum(cards: Array) -> int:
	var sum = 0
	var ace_count = 0

	for card in cards:
		if card.rank == "Ace":
			ace_count += 1
			sum += 11  
		else:
			sum += card.value

	for i in range(ace_count):
		if sum > ceiling:
			sum -= 10 
		else:
			break

	return sum
	
func trigger_game_over() -> void:
	print("Game Over!")
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()


func trigger_round_win() -> void:
	
	ceiling -= 1
	round_number += 1
	var payout = calculate_payout(last_played_sum)
	if payout > 0:
		add_money(payout)
		print("Payout: $", payout)
	refresh_gui()

	var deck = get_node("/root/Main/GameView/Deck")
	var player_hand = get_node("/root/Main/GameView/PlayerHand")
	var discard_slot = get_node("/root/Main/GameView/DiscardSlot")

	for card in player_hand.player_hand:
		deck.player_deck.append({
			"suit": card.suit,
			"rank": card.rank,
			"value": card.value
		})

	for card in player_hand.player_hand:
		card.queue_free()
	player_hand.player_hand.clear()

	discard_slot.discard_count = 0

	if deck.player_deck.size() < 5:
		deck.build_deck()
		deck.player_deck.shuffle()

	deck.get_node("Area2D/CollisionShape2D").disabled = false
	deck.get_node("Sprite2D").visible = true
	deck.get_node("RichTextLabel").visible = true

	refresh_gui()

	await get_tree().create_timer(0.5).timeout
	get_node("/root/Main/ShopView").populate_shop()
	get_node("/root/Main").show_shop()

func calculate_payout(sum: int) -> int:
	var distance = ceiling + 1 - sum 
	var payout = 4 - distance
	return max(payout, 0)
	
func add_money(amount: int) -> void:
	money += amount
	refresh_gui()

func spend_money(amount: int) -> bool:
	if money < amount:
		return false
	money -= amount
	refresh_gui()
	return true

func refresh_gui() -> void:
	var gui = get_node_or_null("/root/Main/UI/GUI")
	if gui:
		gui.refresh()
