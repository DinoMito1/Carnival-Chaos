extends Node2D
@onready var clicks = 0
@onready var won = false
@onready var targetTween = get_tree().create_tween()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Tank/AnimationPlayer.play('Tank_Idle')
	targetTween.kill()
	
	var tween = get_tree().create_tween()
	tween.tween_property($MashIcon, "modulate:a", 0, 2)
	
	$TimeTickingSound.play()
	
	await $ThemedTimer.Timer(6)
	
	if won == false:
		$TimeTickingSound.stop()
		Global.lost_prev = true
		Global.lives -= 1
		Global.minigames_done -=1
		if Global.lives > 0:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if clicks >= 20 and won == false:
		won = true
		$TimeTickingSound.stop()
		# do the silly win animation
		$Tank/AnimationPlayer.stop()
		$Tank/AnimationPlayer.play("tank_splash")
		$SplashSound.play()
		
		await get_tree().create_timer(2).timeout
		
		if Global.minigames_done == 4:
			get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")

func _on_target_button_down() -> void:
	if clicks < 20:
		if targetTween:
			targetTween.kill()
		targetTween = get_tree().create_tween()
		targetTween.tween_property($Target, "scale", Vector2(1.2, 1.2), 1)
		clicks += 1
		$HitSound.pitch_scale = randf_range(0.7, 1.03) + (clicks * 0.025)
		$HitSound.play()
		$Target.scale += Vector2(0.025, 0.025)


func _on_time_ticking_sound_finished() -> void: #this gets around sound not looping on web export for some reason
	$TimeTickingSound.play()
