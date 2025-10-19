class_name QuickSFX
extends Node

@export var bus: String = "Master"
@export var pool_size: int = 8
@export var clips: Dictionary[String, QuickSFXClip] = {} # Resource should be QuickSFXClip
@export var pitch_shift_range: int = 0 # semitones above/below original

var _players: Array[AudioStreamPlayer] = []
var _queue: Array[AudioStreamPlayer] = []
var _variant_clips := {} # name -> Array[QuickSFXClip]

func _ready() -> void:
	_generate_pitch_variants()
	for i in range(pool_size):
		var player := AudioStreamPlayer.new()
		player.bus = bus
		add_child(player)
		_players.append(player)
		_queue.append(player)

func _generate_pitch_variants() -> void:
	_variant_clips.clear()
	for nice_name in clips.keys():
		var base_clip: QuickSFXClip = clips[nice_name]
		if base_clip.stream == null:
			continue
		var variants: Array[QuickSFXClip] = []
		for step in range(-pitch_shift_range, pitch_shift_range + 1):
			if step == 0:
				variants.append(base_clip)
				continue
			if base_clip.stream is AudioStreamWAV:
				var wav := base_clip.stream.duplicate()
				wav.mix_rate = int(base_clip.stream.mix_rate * pow(2.0, step / 12.0))
				var new_clip := QuickSFXClip.new()
				new_clip.stream = wav
				new_clip.pitch_scale = base_clip.pitch_scale
				new_clip.volume_linear = base_clip.volume_linear
				variants.append(new_clip)
			else:
				variants.append(base_clip) # fallback for non-WAV streams
		_variant_clips[nice_name] = variants

func play(nice_name: String, volume_override: float = INF, semitone_override: float = INF, pitch_scale_override : float = INF) -> void:
	if not clips.has(nice_name):
		push_error("QuickSFX: clip '%s' not found" % nice_name)
		return

	var variants: Array[QuickSFXClip] = _variant_clips.get(nice_name, [clips[nice_name]])

	if semitone_override == INF:
		# Use the original clip's pitch_shift
		var original_clip: QuickSFXClip = clips[nice_name]
		semitone_override = original_clip.pitch_shift

	var index: int = clamp(semitone_override + pitch_shift_range, 0, variants.size() - 1)
	var selected_clip: QuickSFXClip = variants[index]

	var player: AudioStreamPlayer = null
	for p in _queue:
		if not p.playing:
			player = p
			break
	if player == null:
		player = _queue[0]

	_queue.erase(player)
	_queue.append(player)

	player.stream = selected_clip.stream
	player.pitch_scale = pitch_scale_override if pitch_scale_override != INF else selected_clip.pitch_scale
	player.volume_linear = volume_override if volume_override != INF else selected_clip.volume_linear
	player.play()



func play_mult(nice_name: String, delay_between: float = 0.1, total_times: int = 5) -> void:
	_call_debug_loop(nice_name, delay_between, total_times)

func _call_debug_loop(nice_name: String, delay_between: float, remaining: int) -> void:
	if remaining <= 0:
		return
	play(nice_name)
	await get_tree().create_timer(delay_between).timeout
	_call_debug_loop(nice_name, delay_between, remaining - 1)

func set_bus(new_bus: String) -> void:
	bus = new_bus
	for p in _players:
		p.bus = new_bus

func set_pool(new_size: int) -> void:
	if new_size <= 0:
		return
	for p in _players:
		p.stop()
		p.queue_free()
	_players.clear()
	_queue.clear()
	for i in range(new_size):
		var p := AudioStreamPlayer.new()
		p.bus = bus
		add_child(p)
		_players.append(p)
		_queue.append(p)
	pool_size = new_size
