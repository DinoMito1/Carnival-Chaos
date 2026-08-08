extends Node2D
@onready var TicketContainer: HBoxContainer = $TicketContainer
@onready var Ticket1: TextureRect = $TicketContainer/Ticket1
@onready var Ticket2: TextureRect = $TicketContainer/Ticket2
@onready var Ticket3: TextureRect = $TicketContainer/Ticket3
@onready var Ticket4: TextureRect = $TicketContainer/Ticket4
@onready var Ticket5: TextureRect = $TicketContainer/Ticket5
@onready var Level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $timer
@onready var lostTicket = preload("res://Sprites/ticket_death.png")

var time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
		
	$ArrowKeyIcon.scale = Vector2(0,0)
	$MouseIcon.scale = Vector2(0,0)
	
	$"fade to black thing".show()
	var tweenIn = get_tree().create_tween() 
	
	tweenIn.tween_property($"fade to black thing", "modulate:a", 0, .35)
	# above code fades out the black screen when switching to this scene
	
	var controlTween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO) 
	# shows controls for the next minigame
	if Global.minigames_done == 0:
		controlTween.tween_property($ArrowKeyIcon, "scale", Vector2(1,1), 2)
	elif Global.minigames_done == 1:
		controlTween.tween_property($MouseIcon, "scale", Vector2(1,1), 2)
	elif Global.minigames_done == 2:
		controlTween.tween_property($MouseIcon, "scale", Vector2(1,1), 2)

		
	await Timer(3.0)
	
	var tweenOut = get_tree().create_tween() 
	tweenOut.tween_property($"fade to black thing", "modulate:a", 1, .35)
	
	#shows objective for next minigame
	if Global.minigames_done == 0:
		tweenOut.tween_property($CollectIcon, "modulate:a", 1, .25)
	elif Global.minigames_done == 1:
		tweenOut.tween_property($HitIcon, "modulate:a", 1, .25)
	elif Global.minigames_done == 2:
		tweenOut.tween_property($MashIcon, "modulate:a", 1, .25)
	
	if Global.lives == 0:
		get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
	
	await get_tree().create_timer(.5).timeout
	
	if Global.minigames_done < 3:
		Global.minigames_done += 1
		get_tree().change_scene_to_file("res://Scenes/minigame_" + str(Global.minigames_done) + ".tscn")
		#changes scene to the minigame based on how many minigames were played
	else:
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.lost_prev == true:
		var ticketFadeTween = get_tree().create_tween()
		match Global.lives: # makes the tickets invisible as you lose lives
			4:
				Ticket5.texture = lostTicket
				ticketFadeTween.tween_property($TicketContainer/Ticket5, "modulate:a", 0, 1)
			3:
				Ticket5.hide()
				Ticket4.texture = lostTicket
				ticketFadeTween.tween_property($TicketContainer/Ticket4, "modulate:a", 0, 1)
			2:
				Ticket5.hide()
				Ticket4.hide()
				Ticket3.texture = lostTicket
				ticketFadeTween.tween_property($TicketContainer/Ticket3, "modulate:a", 0, 1)
			1:
				Ticket5.hide()
				Ticket4.hide()
				Ticket3.hide()
				Ticket2.texture = lostTicket
				ticketFadeTween.tween_property($TicketContainer/Ticket2, "modulate:a", 0, 1)
			0:
				TicketContainer.hide()
	else:
		match Global.lives: # makes the tickets invisible as you lose lives
			4:
				Ticket5.hide()
			3:
				Ticket5.hide()
				Ticket4.hide()
			2:
				Ticket5.hide()
				Ticket4.hide()
				Ticket3.hide()
			1:
				Ticket5.hide()
				Ticket4.hide()
				Ticket3.hide()
				Ticket2.hide()
			0:
				TicketContainer.hide()
	
	timer.text = str(time) # time until minigame starts
	Level.text = "Level " + str(Global.minigames_done + 1) # shows what number minigame you are on

func Timer(start_time: float): # function for timer countdown
	
	time = start_time
	
	while time >= 0.1: # loop decreases timer
		await get_tree().create_timer(0.1).timeout
		time -= 0.1
	return
