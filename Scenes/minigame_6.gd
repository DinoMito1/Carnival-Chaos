extends Node2D
@onready var won = false
var inQTEzone = false
signal good_hit
signal bad_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimeTickingSound.play()
	
	var tween = get_tree().create_tween()
	tween.tween_property($PullIcon, "modulate:a", 0, 2)
	$"QTE circle/QTE zone".rotation = randf_range(-180,180)
	if randi_range(0,1) == 1:
		$"QTE circle/QTE cursor/AnimationPlayer".speed_scale = randf_range(.7,1.3)
	else:
		$"QTE circle/QTE cursor/AnimationPlayer".speed_scale = randf_range(.7,1.3)
	$"QTE circle/QTE cursor/AnimationPlayer".seek(randf_range(0,1))
	$"QTE circle/QTE cursor/AnimationPlayer".play("spinn")
	
	await $ThemedTimer.Timer(15)
	
	$TimeTickingSound.stop()
	if won == false:
		Global.lost_prev = true
		Global.lives -= 1
		Global.minigames_done -= 1
		if Global.lives >= 0:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spacebar"):
		if inQTEzone == true:
			emit_signal("good_hit")
			#ANIMATE GOOD HIT WITH NICE SOUNDS AND WHITE FLASH
		else:
			emit_signal("bad_hit")
			#ANIMATE BAD HIT WITH BAD SOUNDS AND RED FLASH
		$"QTE circle/QTE zone".rotation = randf_range(-180,180)
		if randi_range(0,1) == 1:
			$"QTE circle/QTE cursor/AnimationPlayer".speed_scale = randf_range(-.5,-1.4)
		else:
			$"QTE circle/QTE cursor/AnimationPlayer".speed_scale = randf_range(.5,1.4)
			$"QTE circle/QTE cursor/AnimationPlayer".seek(randf_range(0,1))
			$"QTE circle/QTE cursor/AnimationPlayer".play("spinn")
		
	


func _on_time_ticking_sound_finished() -> void:
	# this gets around sound not looping on web export for some reason
	$TimeTickingSound.play()


func _on_area_2d_area_entered(area: Area2D) -> void:
	inQTEzone = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	inQTEzone = false


func _on_win_zone_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	won = true
	$TimeTickingSound.stop()
	#do winning stuff
	if Global.minigames_done == 6:
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")


func _on_lose_zone_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	$TimeTickingSound.stop()
	if won == false:
		Global.lost_prev = true
		Global.lives -= 1
		Global.minigames_done -= 1
		if Global.lives >= 0:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
