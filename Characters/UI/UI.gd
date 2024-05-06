extends Control

@onready var coin_text = $CoinText
var coin = 0

func _ready():
	GlobalSignals.connect("change_coin", change_coin)
	
	change_coin(Game.souls)

func change_coin(amount):
	coin = amount
	
	coin_text.text = "Coin: " + str(coin)
