extends Control

@onready var coin_text = $CoinText
var coin = 0

func change_coin(amount):
	coin += amount
	
	coin_text.text = "Coin: " + str(coin)
