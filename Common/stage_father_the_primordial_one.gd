extends Node2D

@export_file("res://Environments/tutorial_level_2.tscn") var next_level_path : String

var total_coins: int = 0

func _ready() -> void:
	var coins = $CoinsMain.get_children()
	
	for coin in coins:
		if coin is Node2D and coin.has_signal("item_collected"):
			total_coins += 1
			coin.item_collected.connect(_on_coin_collected)
			
func _on_coin_collected() -> void:
	total_coins -= 1
	
	if total_coins <= 0:
		advance_level()
		
func advance_level() -> void:
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
