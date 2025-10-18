extends Control

@onready var quick_sfx: QuickSFX = $QuickSFX
@onready var coin_button: Button = $CoinButton
@onready var explosion_button: Button = $ExplosionButton
@onready var click_button: Button = $ClickButton
@onready var waves_button: Button = $WavesButton
@onready var grid_container: GridContainer = $GridContainer
@onready var total_audio_players_input: TextEdit = $TotalAudioPlayersInput
@onready var option_button: OptionButton = $OptionButton
@onready var coin_drop_button: Button = $CoinDropButton

func _ready() -> void:
	total_audio_players_input.connect("text_changed", func():
		quick_sfx.set_pool(int(total_audio_players_input.text)))
		
	option_button.connect("item_selected", func(index : int):
		quick_sfx.set_bus(option_button.get_item_text(index)))
	
	coin_button.pressed.connect(func(): 
		quick_sfx.play("coin"))
		
	explosion_button.pressed.connect(func(): 
		quick_sfx.play("explosion"))
		
	click_button.pressed.connect(func():
		quick_sfx.play("click"))
		
	waves_button.pressed.connect(func(): 
		quick_sfx.play("waves"))
		
	coin_drop_button.pressed.connect(func():
		quick_sfx.play_mult("coin", 0.1, 12))

	for child in grid_container.get_children():
		if child is Control:
			child.mouse_entered.connect(func():
				var keys = quick_sfx.clips.keys()
				var rand_sfx = keys[randi() % keys.size()]
				quick_sfx.play(rand_sfx, 1, randf_range(0.5, 2))
				child.modulate.a = 0.7
			)

			child.mouse_exited.connect(func():
				child.modulate.a = 1
			)
