extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_DRAW_SPEED = 1

var player_deck: Array = []
var full_deck_size: int = 52

const SUITS = ["Hearts", "Diamonds", "Clubs", "Spades"]
const RANKS = [
	{"rank": "2",     "value": 2},
	{"rank": "3",     "value": 3},
	{"rank": "4",     "value": 4},
	{"rank": "5",     "value": 5},
	{"rank": "6",     "value": 6},
	{"rank": "7",     "value": 7},
	{"rank": "8",     "value": 8},
	{"rank": "9",     "value": 9},
	{"rank": "10",    "value": 10},
	{"rank": "Jack",  "value": 10},
	{"rank": "Queen", "value": 10},
	{"rank": "King",  "value": 10},
	{"rank": "Ace",   "value": 11}

]



func _ready() -> void:
	build_deck()
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	
	

func build_deck() -> void:
	player_deck.clear()
	for suit in SUITS:
		for rank_data in RANKS:
			player_deck.append({"suit": suit,"rank": rank_data["rank"],"value": rank_data["value"]})
	full_deck_size = player_deck.size()
			
func draw_card() -> void:
	if player_deck.size() == 0:
		return

	var random_index = randi() % player_deck.size()
	var card_data = player_deck[random_index]
	player_deck.remove_at(random_index)

	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false

	$RichTextLabel.text = str(player_deck.size())

	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	new_card.setup(card_data) 
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("card_flip")


func buy_card(card_data: Dictionary) -> void:
	player_deck.append(card_data)
	full_deck_size += 1          
	GameManager.refresh_gui()  
