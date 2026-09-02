extends Node2D
@onready var won = false
@onready var swung = false

@onready var buttonHit1 = preload("res://Sprites/HammerButtonHit1.png")
@onready var buttonHit2 = preload("res://Sprites/HammerButtonHit2.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimeTickingSound.play()
	
	var tween = get_tree().create_tween()
	tween.tween_property($HitIcon, "modulate:a", 0, 2)
	
	$Hammer/AnimationPlayer.play("HammerMove")
	$Hammer/AnimationPlayer.seek(randf_range(0.5,2))
	var animSpeedTween = get_tree().create_tween()
	animSpeedTween.tween_property($Hammer/AnimationPlayer, "speed_scale", 1, .5)
	
	await $ThemedTimer.Timer(4)
	
	$TimeTickingSound.stop()
	if won == false or swung == false:
		Global.lost_prev = true
		Global.lives -= 1
		Global.minigames_done -= 1
		if Global.lives > 0:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spacebar") and swung == false:
		swung = true
		var pos = $Hammer.position
		$Hammer/AnimationPlayer.stop()
		$Hammer.position = pos
		$Hammer/AnimationPlayer.play("hammer_swing")
		await get_tree().create_timer(.9).timeout
		
		if won == false: # if you missed the button
			#lose the minigame
			Global.lost_prev = true
			Global.lives -= 1
			Global.minigames_done -= 1
			if Global.lives > 0:
				get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
			else:
				get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	#when hammer collides with button
	won = true
	$TimeTickingSound.stop()
	$HitSound.play()
	$Button.texture = buttonHit1
	await get_tree().create_timer(.15 ).timeout
	$HammerBell/AnimationPlayer.play("bell_shake")
	$WinSound.play()
	$Button.texture = buttonHit2
	
	await get_tree().create_timer(1.8).timeout
	if Global.minigames_done == 5:
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
