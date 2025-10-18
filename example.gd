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
@onready var coins_rise_up_button: Button = $CoinsRiseUpButton
@onready var boop_button: Button = $BoopButton

func _ready() -> void:	
	coin_button.pressed.connect(func(): 
		quick_sfx.play("coin"))
		
	explosion_button.pressed.connect(func(): 
		quick_sfx.play("explosion"))
		
	click_button.pressed.connect(func():
		quick_sfx.play("click"))
		
	boop_button.pressed.connect(func():
		quick_sfx.play("boop"))
		
	waves_button.pressed.connect(func(): 
		quick_sfx.play("waves"))
		
	coin_drop_button.pressed.connect(func():
		for i in 12:
			quick_sfx.play("coin")
			await get_tree().create_timer(0.075).timeout
	)
		
	total_audio_players_input.connect("text_changed", func():
		quick_sfx.set_pool(int(total_audio_players_input.text)))
		
	option_button.connect("item_selected", func(index : int):
		quick_sfx.set_bus(option_button.get_item_text(index)))
		
	coins_rise_up_button.pressed.connect(func():
		var melody = [
			{ "note": 0, "dur": 0.2 },
			{ "note": 0, "dur": 0.2 },
			{ "note": 7, "dur": 0.2 },
			{ "note": 7, "dur": 0.2 },
			{ "note": 9, "dur": 0.2 },
			{ "note": 9, "dur": 0.2 },
			{ "note": 7, "dur": 0.4 },

			{ "note": 5, "dur": 0.2 },
			{ "note": 5, "dur": 0.2 },
			{ "note": 4, "dur": 0.2 },
			{ "note": 4, "dur": 0.2 },
			{ "note": 2, "dur": 0.2 },
			{ "note": 2, "dur": 0.2 },
			{ "note": 0, "dur": 0.4 },

			{ "note": 7, "dur": 0.2 },
			{ "note": 7, "dur": 0.2 },
			{ "note": 5, "dur": 0.2 },
			{ "note": 5, "dur": 0.2 },
			{ "note": 4, "dur": 0.2 },
			{ "note": 4, "dur": 0.2 },
			{ "note": 2, "dur": 0.4 },

			{ "note": 7, "dur": 0.2 },
			{ "note": 7, "dur": 0.2 },
			{ "note": 5, "dur": 0.2 },
			{ "note": 5, "dur": 0.2 },
			{ "note": 4, "dur": 0.2 },
			{ "note": 4, "dur": 0.2 },
			{ "note": 2, "dur": 0.4 },

			{ "note": 0, "dur": 0.2 },
			{ "note": 0, "dur": 0.2 },
			{ "note": 7, "dur": 0.2 },
			{ "note": 7, "dur": 0.2 },
			{ "note": 9, "dur": 0.2 },
			{ "note": 9, "dur": 0.2 },
			{ "note": 7, "dur": 0.4 },

			{ "note": 5, "dur": 0.2 },
			{ "note": 5, "dur": 0.2 },
			{ "note": 4, "dur": 0.2 },
			{ "note": 4, "dur": 0.2 },
			{ "note": 2, "dur": 0.2 },
			{ "note": 2, "dur": 0.2 },
			{ "note": 0, "dur": 0.4 }
		]

		for n in melody:
			quick_sfx.play("boop", 1, n.note)
			await get_tree().create_timer(n.dur).timeout
	)
		
	for child in grid_container.get_children():
		if child is Control:
			child.mouse_entered.connect(func():
				var keys = quick_sfx.clips.keys()
				var rand_sfx = keys[randi() % keys.size()]
				quick_sfx.play(rand_sfx, 1, randi_range(-quick_sfx.pitch_shift_range, quick_sfx.pitch_shift_range + 1))
				child.modulate.a = 0.7
			)

			child.mouse_exited.connect(func():
				child.modulate.a = 1
			)
			
