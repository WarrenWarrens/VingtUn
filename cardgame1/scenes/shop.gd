extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"
var RANK_TO_FILENAME = {
	"Ace": "ace", "2": "two", "3": "three", "4": "four",
	"5": "five", "6": "six", "7": "seven", "8": "eight",
	"9": "nine", "10": "ten", "Jack": "jack", "Queen": "queen", "King": "king"
}
var shop_cards = []

func generate_shop_cards() -> Array:
	var pool = []
	var suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
	var ranks = [
		{"rank": "Ace", "value": 11}, {"rank": "2", "value": 2},
		{"rank": "3", "value": 3},    {"rank": "4", "value": 4},
		{"rank": "5", "value": 5},    {"rank": "6", "value": 6},
		{"rank": "7", "value": 7},    {"rank": "8", "value": 8},
		{"rank": "9", "value": 9},    {"rank": "10", "value": 10},
		{"rank": "Jack", "value": 10},{"rank": "Queen", "value": 10},
		{"rank": "King", "value": 10}
	]
	for suit in suits:
		for rank in ranks:
			pool.append({
				"suit": suit,
				"rank": rank["rank"],
				"value": rank["value"],
				"price": calculate_price(rank["rank"])
			})
	pool.shuffle()

	var regular_pool = pool.filter(func(c): 
		return c["rank"] not in ["Ace", "Jack", "Queen", "King"])
	
	var special_pool = pool.filter(func(c): 
		return c["rank"] in ["Ace", "Jack", "Queen", "King"])
	special_pool.shuffle()
	var special_card = special_pool[0].duplicate()
	special_card["price"] = 1

	return regular_pool.slice(0, 5) + [special_card]

func calculate_price(rank: String) -> int:
	if rank == "Ace":
		return 3
	if rank in ["10", "Jack", "Queen", "King"]:
		return 2
	return 1

func refresh_display() -> void:
	var slots = [
		$Control/ShopContainer/CardsSection/ShopSlot1,
		$Control/ShopContainer/CardsSection/ShopSlot2,
		$Control/ShopContainer/CardsSection/ShopSlot3,
		$Control/ShopContainer/CardsSection/ShopSlot4,
		$Control/ShopContainer/CardsSection/ShopSlot5,
		$Control/ShopContainer/SpecialSection
	]
	for i in range(slots.size()):
		if i < shop_cards.size():
			var card_data = shop_cards[i]
			var display = slots[i].get_node_or_null("CardDisplay")
			var button = slots[i].get_node_or_null("BuyButton")

			if display == null or button == null:
				continue

			if button.pressed.is_connected(Callable(self, "buy_card")):
				button.pressed.disconnect(Callable(self, "buy_card"))

			if card_data.get("sold_out", false):
				display.texture = null
				button.text = "Sold Out!"
				button.disabled = true
				continue

			var rank_name = RANK_TO_FILENAME.get(card_data["rank"], card_data["rank"].to_lower())
			var texture_path = "res://assets/cards/%s_of_%s.png" % [rank_name, card_data["suit"].to_lower()]
			if ResourceLoader.exists(texture_path):
				display.texture = load(texture_path)
			display.custom_minimum_size = Vector2(150, 200)
			display.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			display.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

			button.text = str(card_data["price"]) + "$"
			button.disabled = false
			button.pressed.connect(func(): buy_card(card_data), CONNECT_ONE_SHOT)

func buy_card(card_data: Dictionary) -> void:
	if card_data.get("sold_out", false):
		return
	if not GameManager.spend_money(card_data["price"]):
		print("Not enough money!")
		return

	print("Buying: ", card_data["rank"], " of ", card_data["suit"])
	get_node("../GameView/Deck").player_deck.append(card_data)
	get_node("../GameView/Deck").full_deck_size += 1

	card_data["sold_out"] = true
	GameManager.refresh_gui()
	refresh_display()
	
func _ready() -> void:
	$Control/TabBar/CardsTabButton.pressed.connect(
		func(): show_section(true))
	$Control/TabBar/SpecialTabButton.pressed.connect(
		func(): show_section(false))

func populate_shop() -> void:
	shop_cards = generate_shop_cards()
	refresh_display()


func show_section(cards_tab: bool) -> void:
	$Control/ShopContainer/CardsSection.visible = cards_tab
	$Control/ShopContainer/SpecialSection.visible = !cards_tab
