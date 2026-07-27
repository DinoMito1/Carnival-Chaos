extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween() #fades to black
	tween.tween_property($"fade to black thing", "modulate:a", 0, .35)
	await get_tree().create_timer(.6).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
