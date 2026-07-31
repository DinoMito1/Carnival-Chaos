extends Node2D
@onready var TicketContainer: HBoxContainer = $TicketContainer
@onready var Ticket1: TextureRect = $TicketContainer/Ticket1
@onready var Ticket2: TextureRect = $TicketContainer/Ticket2
@onready var Ticket3: TextureRect = $TicketContainer/Ticket3
@onready var Ticket4: TextureRect = $TicketContainer/Ticket4
@onready var Ticket5: TextureRect = $TicketContainer/Ticket5
@onready var Level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $timer

var time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"fade to black thing".show()
	var tween = get_tree().create_tween() 
	tween.tween_property($"fade to black thing", "modulate:a", 0, .35)
	# above code fades out the black screen when switching to this scene
	
	await Timer(4.0)
	
	if Global.minigames_done < 3:
		Global.minigames_done += 1
		get_tree().change_scene_to_file("res://Scenes/minigame_" + str(Global.minigames_done) + ".tscn")
		#changes scene to the minigame based on how many minigames were played
	else:
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
			Ticket1.hide()
		0:
			TicketContainer.hide()
	timer.text = str(time) # time until minigame starts
	Level.text = "Level " + str(Global.minigames_done) # shows what number minigame you are on

func Timer(start_time: float): # function for timer countdown
	
	time = start_time
	
	while time >= 0.1: # loop decreases timer
		await get_tree().create_timer(0.1).timeout
		time -= 0.1
	return
