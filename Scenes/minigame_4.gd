extends Node2D
@onready var timeIn = 0 #how close you are to winning
@onready var maxTime = 5 # how much time in zone needed to win
@onready var waterStartPos = Vector2(563, 462) # where the water stream starts from. changes based on where gun is pointing
@onready var inZone = false

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
	
	await $ThemedTimer.Timer(10) # 100 for debug dont forget to fix
	
	$TimeTickingSound.stop()
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
	if waterPos[0] < 476:
		$WaterGun.texture = left
		$WaterJet.position = Vector2(475, 492)
	elif waterPos[0] > 676:
		$WaterGun.texture = right
		$WaterJet.position = Vector2(656, 488)
	else:
		$WaterGun.texture = straight
		$WaterJet.position = Vector2(563, 462)
		
	if inZone:
		timeIn += delta
		if timeIn < 0.5:
			$WaterMeter.texture = meterFill1
		elif timeIn < 1:
			$WaterMeter.texture = meterFill2
		elif timeIn < 1.5:
			$WaterMeter.texture = meterFill3
		elif timeIn < 2:
			$WaterMeter.texture = meterFill4
		elif timeIn < 2.5:
			$WaterMeter.texture = meterFill5
		elif timeIn < 3:
			$WaterMeter.texture = meterFill6
		elif timeIn < 3.5:
			$WaterMeter.texture = meterFill7
		elif timeIn < 4:
			$WaterMeter.texture = meterFill8
		elif timeIn < 4.5:
			$WaterMeter.texture = meterFill9
		elif timeIn < 5:
			$WaterMeter.texture = meterFill10
		else:
			$WaterMeter.texture = meterFill11
		
	if timeIn >= maxTime:
		$TimeTickingSound.stop()
		
		if Global.minigames_done == 4:
			get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")


func _on_target_body_entered(body: Node2D) -> void:
	inZone = true


func _on_target_body_exited(body: Node2D) -> void:
	inZone = false
