extends Node2D
@onready var themed_timer: Node2D = $ThemedTimer

var buttons_pressed := 0
var timer_end = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var tween = get_tree().create_tween()
	tween.tween_property($HitIcon, "modulate:a", 0, 2)
	
	$TimeTickingSound.play()
	
	await themed_timer.Timer(6.0)
	timer_end = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if buttons_pressed == 5:
		
		Global.lost_prev = false
		if Global.minigames_done == 5:
			themed_timer.Stop()
			get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
			
	if timer_end:
		$TimeTickingSound.stop()
		Global.lost_prev = true
		Global.lives -= 1
		Global.minigames_done -= 1
		if Global.lives > 0:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")


func _on_time_ticking_sound_finished() -> void: #this gets around sound not looping on web export for some reason
	$TimeTickingSound.play()
