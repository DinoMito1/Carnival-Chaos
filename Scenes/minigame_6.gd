extends Node2D
@onready var won = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimeTickingSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($JumpIcon, "modulate:a", 0, 2)
	
	await $ThemedTimer.Timer(10)
	
	$TimeTickingSound.stop()
	if won == false:
		Global.lost_prev = true
		Global.lives -= 1
		Global.minigames_done -= 1
		if Global.lives >= 0:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
	


func _on_time_ticking_sound_finished() -> void:
	# this gets around sound not looping on web export for some reason
	$TimeTickingSound.play()
