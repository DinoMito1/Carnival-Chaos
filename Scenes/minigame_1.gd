extends Node2D
@onready var themed_timer: Node2D = $ThemedTimer
var coins_collected = 0
var timer_end = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimeTickingSound.play()
	var tween = get_tree().create_tween()
	tween.tween_property($CollectIcon, "modulate:a", 0, 2)
	
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$MobileArrowControl.show()
	else:
		$MobileArrowControl.hide()
	
	# plays the coin floating anim
	$Coin/AnimationPlayer.play("floating")
	$Coin2/AnimationPlayer.play("floating")
	$Coin3/AnimationPlayer.play("floating")
	
	await themed_timer.Timer(8.0)
	timer_end = true # says timer has ended after 7 seconds
	
	# when timer runs out
	$TimeTickingSound.stop()
	Global.lost_prev = true
	Global.minigames_done -= 1
	Global.lives -= 1
	if Global.lives > 0:
		get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if coins_collected == 3:
		Global.lost_prev = false
		themed_timer.Stop()
		if Global.minigames_done == 4:
			get_tree().change_scene_to_file("res://Scenes/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")

func coin_collect() -> void:
	coins_collected += 1
	return


func _on_time_ticking_sound_finished() -> void: #this gets around sound not looping on web export for some reason
	$TimeTickingSound.play()
