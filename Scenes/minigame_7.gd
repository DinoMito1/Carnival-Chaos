extends Node2D
var won = false

var guideImage = Image.load_from_file("res://Sprites/templateTigerPaint.png")
var canvasImage = Image.load_from_file("res://Sprites/PlayerHeadPaint.png")
var paintTexture = ImageTexture.create_from_image(canvasImage)
			#was going to use CanvasTexture but apparently thats already a class in GDScript???

var skinColor
var faceColor
var paintOrange
var paintBlack
var paintWhite
var skyColor

var currentPaint
var drawSize
var currentPixel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimeTickingSound.play()
	
	var tween = get_tree().create_tween()
	tween.tween_property($PaintIcon, "modulate:a", 0, 2) #change the icon
	
	
	await RenderingServer.frame_post_draw
	
	skinColor = get_viewport().get_texture().get_image().get_pixelv(Vector2i(200,645))
	faceColor = get_viewport().get_texture().get_image().get_pixelv(Vector2i(412,477))
	paintOrange = get_viewport().get_texture().get_image().get_pixelv(Vector2i(900,250))
	paintBlack = get_viewport().get_texture().get_image().get_pixelv(Vector2i(900,280))
	paintWhite = get_viewport().get_texture().get_image().get_pixelv(Vector2i(1000,350))
	skyColor = get_viewport().get_texture().get_image().get_pixelv(Vector2i(10,10))
	currentPaint = paintOrange
	drawSize = 128
	
	$paintHolder/paint1.self_modulate = paintOrange
	$paintHolder/paint2.self_modulate = paintBlack
	$paintHolder/paint3.self_modulate = paintWhite
	
	await $ThemedTimer.Timer(80)
	
	if won == false: #checks if you win when time is out
		checkWin()
	
	$TimeTickingSound.stop()
	if won == false:
		won = true #this is so
		Global.lost_prev = true
		Global.lives -= 1
		Global.minigames_done -= 1
		#do losing stuff
		await get_tree().create_timer(.5).timeout
		if Global.lives > 0:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#if get_global_mouse_position().x < 650 and get_global_mouse_position().y < 630:
		#$PaintSquare.position = get_global_mouse_position()
		#$PaintSquare.modulate = currentPaint
	#else:
		#$PaintSquare.position = Vector2i(-100,-100)
	#commented out becuase it broke the painting code since
	#your mouse would always be on a colored spot

	
	if won == false and Input.is_action_pressed("left click"):
		#only runs if game hasnt ended and left mouse is clicked down
		edit_canvas()
	
func edit_canvas():

	await RenderingServer.frame_post_draw
	var mousepos = get_global_mouse_position()
	var currentViewport = get_viewport().get_texture().get_image()
	
	#print(currentViewport.get_pixelv(mousepos)) #current pixel color
	
	if mousepos.y < 630 and mousepos.x < 650:
		#only paints if pixel is certain color (face skin color, face color and the paint colors)                       
		#paints in a square 'drawSize' big
		if $paintingSound.playing == false:
			$paintingSound.play()
		for x in range(drawSize):
			for y in range(drawSize):
				if mousepos.y-(drawSize/2-1)+y<648 and mousepos.y-(drawSize/2-1)+y>0 and mousepos.x-(drawSize/2-1)+x>0 and mousepos.x-(drawSize/2-1)+x<649:
				#this stops the next if statement from looking at pixels not in the viewport and throwing an error
					currentPixel = currentViewport.get_pixel(mousepos.x-(drawSize/2-1)+x,mousepos.y-(drawSize/2-1)+y)
					#print(currentPixel.is_equal_approx( skinColor ) or currentPixel.is_equal_approx( faceColor ) or currentPixel.is_equal_approx( paintOrange ) or currentPixel.is_equal_approx( paintWhite ) or currentPixel.is_equal_approx( paintBlack ))
					if currentPixel.is_equal_approx( skinColor ) or currentPixel.is_equal_approx( faceColor ) or currentPixel.is_equal_approx( paintOrange ) or currentPixel.is_equal_approx( paintWhite ) or currentPixel.is_equal_approx( paintBlack ):
						canvasImage.set_pixel(mousepos.x-(drawSize/2-1)+x, mousepos.y-(drawSize/2-1)+y,currentPaint)
		
		
		#RenderingServer.texture_2d_update(paintTexture.get_rid(), canvasImage, 0)
		#$PlayerHeadPaint.texture = paintTexture
		
		paintTexture.update(canvasImage)
		$PlayerHeadPaint.texture = paintTexture
		

func _on_time_ticking_sound_finished() -> void:
	# this gets around sound not looping on web export for some reason
	$TimeTickingSound.play()


func _on_paint_1_button_button_down() -> void:
	currentPaint = paintOrange
	drawSize = 128
	$paintHolder/paint1.modulate = Color(.75,.75,.75,1)
	await get_tree().create_timer(.25).timeout
	$paintHolder/paint1.modulate = Color(1,1,1,1)

func _on_paint_1_button_2_button_down() -> void:
	currentPaint = paintOrange
	drawSize = 128
	$paintHolder/paint1.modulate = Color(.75,.75,.75,1)
	await get_tree().create_timer(.25).timeout
	$paintHolder/paint1.modulate = Color(1,1,1,1)

func _on_paint_2_button_button_down() -> void:
	currentPaint = paintWhite
	drawSize = 64
	$paintHolder/paint3.modulate = Color(.75,.75,.75,1)
	await get_tree().create_timer(.25).timeout
	$paintHolder/paint3.modulate = Color(1,1,1,1)


func _on_paint_3_button_button_down() -> void:
	currentPaint = paintBlack
	drawSize = 16
	$paintHolder/paint2.modulate = Color(.75,.75,.75,1)
	await get_tree().create_timer(.25).timeout
	$paintHolder/paint2.modulate = Color(1,1,1,1)


func _on_paint_3_button_2_button_down() -> void:
	currentPaint = paintBlack
	drawSize = 16
	$paintHolder/paint2.modulate = Color(.75,.75,.75,1)
	await get_tree().create_timer(.25).timeout
	$paintHolder/paint2.modulate = Color(1,1,1,1)

func _on_paint_3_button_3_button_down() -> void:
	currentPaint = paintBlack
	drawSize = 16
	$paintHolder/paint2.modulate = Color(.75,.75,.75,1)
	await get_tree().create_timer(.25).timeout
	$paintHolder/paint2.modulate = Color(1,1,1,1)

func checkWin():
	var paintedImage = paintTexture.get_image()
	var numCorrect = 0
	for x in range(649):
		for y in range(658):
			if guideImage.get_pixel(x,y).is_equal_approx(paintedImage.get_pixel(x,y)):
				numCorrect += 1
	if (numCorrect / 427042.0 > 0.7): # percent accuracy required to win
		won = true
		$TimeTickingSound.stop()
		$VoiceClips.stream = load("res://audio/VoiceClipYay.mp3")
		$VoiceClips.play()
		#do winning stuff
		await get_tree().create_timer(1.2).timeout
		if Global.minigames_done == 7:
			get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/level_scene.tscn")
	elif (numCorrect / 427042.0 > 0.55): # not correct but over 55% accurate
		$VoiceClips.stream = load("res://audio/VoiceClip6.mp3")
		$VoiceClips.play()
		
		$RichTextLabel.position = Vector2i(576,138)
		$RichTextLabel.modulate = Color(1.0, 0.851, 0.4)
		$RichTextLabel.text = 'Almost there... (' + str( snapped(( numCorrect / (649.0*658.0) ) * 100, 0.1) ) + '%)'
		$RichTextLabel/AnimationPlayer.play("text_slide")
	
	else: # less than 55% accurate
		#picks a random voice clip
		$VoiceClips.stream = load("res://audio/VoiceClip" + str(randi_range(1,4)) + ".mp3")
		$VoiceClips.play()
		
		$RichTextLabel.position = Vector2i(576,138)
		$RichTextLabel.modulate = Color(1.0, 0.4, 0.4)
		$RichTextLabel.text = 'Incorrect (' + str( snapped(( numCorrect / (649.0*658.0) ) * 100, 0.1) ) + '%)'
		#$RichTextLabel.text = ( str(snapped( ( numCorrect / (649.0*658.0) ) * 100, .1)) )
		$RichTextLabel/AnimationPlayer.play("text_slide")
		
	print( str(( numCorrect / (649.0*658.0) ) * 100) + '% correct' )

func _on_yes_button_button_down() -> void:
	checkWin()

func _on_no_button_button_down() -> void:
	#resets paint
	canvasImage = Image.load_from_file("res://Sprites/PlayerHeadPaint.png")
	paintTexture = ImageTexture.create_from_image(canvasImage)
	$PlayerHeadPaint.texture = paintTexture
