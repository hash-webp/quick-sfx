# QuickSFX

QuickSFX is a Godot 4 utility for managing and playing many sound effects simply and efficiently. It supports pitch shifting, volume overrides, and more.

---
## Quick Start

1. Add `res://quick-sfx/quick_sfx.gd` and `res://quick-sfx/quick_sfx_clip.gd` somewhere in your project.
2. Add a `QuickSFX` node to your scene.  
3. Configure the node's `Clips` property by creating a Dictionary of key/values.
4. Play sounds with code by referencing a key!
```gdscript
@onready var quick_sfx: QuickSFX = $QuickSFX

func _ready():
  quick_sfx.play("coin")
  quick_sfx.play("coin", 0.8)                # Optional volume override
  quick_sfx.play("coin", 1.0, 2)             # Optional semitone override
```

## Classes

### QuickSFXClip (Resource)
Represents a single sound effect.

**Properties:**
- `stream: AudioStream` – The audio resource.
- `pitch_shift: float = 0.0` – Default semitone offset.
- `pitch_scale: float = 1.0` – Default pitch_scale multiplier.
- `volume_linear: float = 1.0` – Linear volume multiplier.

---

### QuickSFX (Node)
Manages a pool of `AudioStreamPlayer`s and plays `QuickSFXClip`s.

**Properties:**
- `bus: String = "Master"` – Audio bus to play sounds on.
- `pool_size: int = 8` – Number of audio players in the pool.
- `clips: Dictionary[String, QuickSFXClip]` – Map of clip names to `QuickSFXClip` resources.

**Functions:**
- `play(nice_name: String, volume_override: float = INF, semitone_override: float = INF)`  
  Plays a clip by name. Optional overrides for volume and pitch.
- `set_bus(new_bus: String)`  
  Sets the audio bus for all players.
- `set_pool(new_size: int)`  
  Resets the pool size. Stops and frees existing players, recreates new ones.
