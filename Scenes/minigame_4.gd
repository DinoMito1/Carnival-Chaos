extends Node2D
@onready var timeIn = 0 #how close you are to winning
@onready var maxTime = 3 # how many seconds in zone needed to win
@onready var waterStartPos = Vector2(563, 462) # where the water stream starts from. changes based on where gun is pointing
@onready var inZone = false
@onready var won = false

@onready var straight = preload("res://Sprites/WaterGun1.png")
@onready var right = preload("res://Sprites/WaterGun2.png")
@onready var left = preload("res://Sprites/WaterGun3.png")

@onready var meterFill1 = preload("res://Sprites/waterMeter1.png")
@onready var meterFill2 = preload("res://Sprites/waterMeter2.png")
@onready var meterFill3 = preload("res://Sprites/waterMeter3.png")
@onready var meterFill4 = preload("res://Sprites/waterMeter4.png")
@onready var meterFill5 = preload("res://Sprites/waterMeter5.png")
@onready var meterFill6 = preload("res://Sprites/waterMeter6.png")
@onready var meterFill7 = preload("res://Sprites/waterMeter7.png")
@onready var meterFill8 = preload("res://Sprites/waterMeter8.png")
@onready var meterFill9 = preload("res://Sprites/waterMeter9.png")
@onready var meterFill10 = preload("res://Sprites/waterMeter10.png")
@onready var meterFill11 = preload("res://Sprites/waterMeter11.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimeTickingSound.play()
	$Target/AnimationPlayer.play("TargetTrackFollow")
	$WaterHitPart/AnimationPlayer.play("waterGunSplash")
	
	var tween = get_tree().create_tween()
	tween.tween_property($SprayIcon, "modulate:a", 0, 2)
	
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$MobileArrowControl.show()
	else:
		$MobileArrowControl.hide()
	
	await $ThemedTimer.Timer(9)
	
	$TimeTickingSound.stop()
	$WaterJetSound.stop()
	if won == false:
		Global.lost_prev = true
		Global.lives -= 1
		Global.minigames_done -= 1
		if Global.lives > 0:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var JetHitDistance = sqrt( ($WaterHitPart.position.x - $WaterJet.position.x)**2 + ($WaterHitPart.position.y - $WaterJet.position.y)**2 )
	$WaterJet.scale.y = JetHitDistance / 550
	$WaterJet.look_at($WaterHitPart.position)
	$WaterJet.rotation_degrees += 90
	var waterPos = $WaterHitPart.position
	#576 x is screen center 648 y is screen bottom
	#if waterPos[0] < 476:
		#$WaterGun.texture = left
		#$WaterJet.position = Vector2(475, 492)
		#pass
	#elif waterPos[0] > 676:
		#$WaterGun.texture = right
		#$WaterJet.position = Vector2(656, 488)
		#pass
	#else:
		#$WaterGun.texture = straight
		#$WaterJet.position = Vector2(563, 462)
		
	if inZone:
		timeIn += delta
		if timeIn < .1 * maxTime:
			$MeterSoundThing.pitch_scale = 0.8
			$WaterMeter.texture = meterFill1
		elif timeIn < .2 * maxTime:
			$MeterSoundThing.pitch_scale = .9
			$WaterMeter.texture = meterFill2
		elif timeIn < .3 * maxTime:
			$MeterSoundThing.pitch_scale = 1
			$WaterMeter.texture = meterFill3
		elif timeIn < .4 * maxTime:
			$MeterSoundThing.pitch_scale = 1.075
			$WaterMeter.texture = meterFill4
		elif timeIn < .5 * maxTime:
			$MeterSoundThing.pitch_scale = 1.15
			$WaterMeter.texture = meterFill5
		elif timeIn < .6 * maxTime:
			$MeterSoundThing.pitch_scale = 1.2
			$WaterMeter.texture = meterFill6
		elif timeIn < .7 * maxTime:
			$MeterSoundThing.pitch_scale = 1.25
			$WaterMeter.texture = meterFill7
		elif timeIn < .8 * maxTime:
			$MeterSoundThing.pitch_scale = 1.3
			$WaterMeter.texture = meterFill8
		elif timeIn < .9 * maxTime:
			$MeterSoundThing.pitch_scale = 1.35
			$WaterMeter.texture = meterFill9
		elif timeIn < maxTime:
			$MeterSoundThing.pitch_scale = 1.45
			$WaterMeter.texture = meterFill10
		else:
			$MeterSoundThing.pitch_scale = 1.6
			$WaterMeter.texture = meterFill11
		
	if timeIn >= maxTime: # if you win
		
		$TimeTickingSound.stop()
		if won == false:
			$WinSound.play()
			var waterTween = get_tree().create_tween()
			#makes the water stream go away after winning
			waterTween.set_parallel(true)
			waterTween.tween_property($WaterHitPart, "modulate:a", 0, 1.9)
			waterTween.tween_property($WaterHitPart, "position", Vector2(564,481), 2).set_trans(Tween.TRANS_CUBIC)
			waterTween.tween_property($WaterJet, "modulate:a", 0, 1)
			waterTween.tween_property($WaterJetSound, "volume_linear", 0, 1.9)
			waterTween.tween_property($Target/AnimationPlayer, "speed_scale", 0, 1)
		won = true
		
		
		await get_tree().create_timer(2).timeout
		
		if Global.minigames_done == 4:
			get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")


func _on_target_body_entered(body: Node2D) -> void:
	inZone = true
	var TargetShrinkTween = get_tree().create_tween()
	TargetShrinkTween.tween_property($Target, "scale", Vector2(.9,.9), .1)


func _on_target_body_exited(body: Node2D) -> void:
	inZone = false
	var TargetGrowTween = get_tree().create_tween()
	TargetGrowTween.tween_property($Target, "scale", Vector2(1,1), .1)


func _on_water_meter_texture_changed() -> void:
	$MeterSoundThing.play()


func _on_time_ticking_sound_finished() -> void: # this gets around sound not looping on web export for some reason
	$TimeTickingSound.play()


func _on_water_jet_sound_finished() -> void: # same as previous function
	$WaterJetSound.play()
