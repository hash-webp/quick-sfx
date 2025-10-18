# QuickSFX

QuickSFX is a Godot 4 utility for managing and playing many sound effects simply and efficiently. It supports pitch shifting, volume overrides, and more.

---
## Quick Start

1. Add `res://quick-sfx/quick_sfx.gd` and `res://quick-sfx/quick_sfx_clip.gd` somewhere in your project.
2. Add a `QuickSFX` node to your scene.  
3. Configure the node's `Clips` property
4. Play sounds with code!
```gdscript
@onready var quick_sfx: QuickSFX = $QuickSFX

func _ready():
  quick_sfx.play("coin")
  quick_sfx.play("coin", 0.8, 1.5) # Optional volume/pitch overrides
```

## Classes

### QuickSFXClip (Resource)
Represents a single sound effect.

**Properties:**
- `stream: AudioStream` – The audio resource.
- `pitch_scale: float = 1.0` – Pitch multiplier for playback.
- `volume_linear: float = 1.0` – Linear volume multiplier.

---

### QuickSFX (Node)
Manages a pool of `AudioStreamPlayer`s and plays `QuickSFXClip`s.

**Properties:**
- `bus: String = "Master"` – Audio bus to play sounds on.
- `pool_size: int = 8` – Number of audio players in the pool.
- `clips: Dictionary[String, QuickSFXClip]` – Map of clip names to `QuickSFXClip` resources.

**Functions:**
- `play(nice_name: String, volume_override: float = INF, pitch_scale_override: float = INF)`  
  Plays a clip by name. Optional overrides for volume and pitch.
- `play_mult(nice_name: String, delay_between: float = 0.1, total_times: int = 5)`  
  Plays a sound in successtion.
- `set_bus(new_bus: String)`  
  Sets the audio bus for all players.
- `set_pool(new_size: int)`  
  Resets the pool size. Stops and frees existing players, recreates new ones.
