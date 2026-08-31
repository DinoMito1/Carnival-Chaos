extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimeTickingSound.play()
	
	var tween = get_tree().create_tween()
	tween.tween_property($HitIcon, "modulate:a", 0, 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
