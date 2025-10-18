class_name QuickSFX
extends Node

@export var bus: String = "Master"
@export var pool_size: int = 8
@export var clips: Dictionary[String, QuickSFXClip] = {} # Resource should be QuickSFXClip

var _players: Array[AudioStreamPlayer] = []
var _queue: Array[AudioStreamPlayer] = []

func _ready() -> void:
	for i in range(pool_size):
		var player = AudioStreamPlayer.new()
		player.bus = bus
		add_child(player)
		_players.append(player)
		_queue.append(player)

func play(
	nice_name: String,
	volume_override: float = INF,
	pitch_scale_override: float = INF
) -> void:
	if not clips.has(nice_name):
		push_error("QuickSFX: clip '%s' not found" % nice_name)
		return

	var clip: QuickSFXClip = clips[nice_name]
	var player: AudioStreamPlayer = null

	# Find available player
	for p in _queue:
		if not p.playing:
			player = p
			break
	if player == null:
		player = _queue[0]

	_queue.erase(player)
	_queue.append(player)

	player.stream = clip.stream
	player.volume_linear = volume_override if volume_override != INF else clip.volume_linear
	player.pitch_scale = pitch_scale_override if pitch_scale_override != INF else clip.pitch_scale
	player.play()


func play_mult(nice_name: String, delay_between: float = 0.1, total_times: int = 5) -> void:
	_call_play_mult_loop(nice_name, delay_between, total_times)

func _call_play_mult_loop(nice_name: String, delay_between: float, remaining: int) -> void:
	if remaining <= 0:
		return
	play(nice_name)
	await get_tree().create_timer(delay_between).timeout
	_call_play_mult_loop(nice_name, delay_between, remaining - 1)

func set_bus(new_bus : String) -> void:
	bus = new_bus
	for p in _players:
		p.bus = new_bus

func set_pool(new_size: int) -> void:
	if new_size <= 0:
		return

	# Stop and free all existing players
	for p in _players:
		p.stop()
		p.queue_free()

	_players.clear()
	_queue.clear()

	# Create new pool
	for i in range(new_size):
		var p = AudioStreamPlayer.new()
		p.bus = bus
		add_child(p)
		_players.append(p)
		_queue.append(p)

	pool_size = new_size
