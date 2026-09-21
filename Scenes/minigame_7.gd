extends Node2D
var won = false

@onready var canvasImage = Image.load_from_file("res://Sprites/PlayerHeadPaint.png")
@onready var paintTexture = ImageTexture.create_from_image(canvasImage)
			#was going to use CanvasTexture but apparently thats already a class in GDScript???
var skinColor
var faceColor
var paintOrange
var paintBlack
var paintWhite
var skyColor

var currentPaint
var drawSize

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
	
	await $ThemedTimer.Timer(90)
	
	$TimeTickingSound.stop()
	if won == false:
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

	
	if Global.lost_prev == false and Input.is_action_pressed("left click"):
		#only runs if game hasnt ended and left mouse is clicked down
		edit_canvas()
	
func edit_canvas():

	await RenderingServer.frame_post_draw
	var mousepos = get_global_mouse_position()
	var currentViewport = get_viewport().get_texture().get_image()
	
	#print(currentViewport.get_pixelv(mousepos)) #current pixel color
	
	if mousepos.y < 630 and mousepos.x < 650 and ( currentViewport.get_pixelv(mousepos).is_equal_approx( skinColor ) or currentViewport.get_pixelv(mousepos).is_equal_approx( faceColor ) or currentViewport.get_pixelv(mousepos).is_equal_approx( paintOrange ) or currentViewport.get_pixelv(mousepos).is_equal_approx( paintWhite ) or currentViewport.get_pixelv(mousepos).is_equal_approx( paintBlack ) ):
		#only paints if pixel is certain color (face skin color, face color and the paint colors)                       
		#paints in a square 'drawSize' big
		
		for x in range(drawSize):
			for y in range(drawSize):
				if mousepos.y-(drawSize/2-1)+y<648 and mousepos.y-(drawSize/2-1)+y>0 and mousepos.x-(drawSize/2-1)+x>0 and mousepos.x-(drawSize/2-1)+x<649:
				#this stops the next if statement from looking at pixels not in the viewport and throwing an error
					print(not currentViewport.get_pixel(mousepos.x-(drawSize/2-1)+x,mousepos.y-(drawSize/2-1)+y).is_equal_approx( skyColor ))
					if not currentViewport.get_pixel(mousepos.x-(drawSize/2-1)+x,mousepos.y-(drawSize/2-1)+y).is_equal_approx( skyColor ):
						canvasImage.set_pixel(mousepos.x-(drawSize/2-1)+x, mousepos.y-(drawSize/2-1)+y,currentPaint)
		
		RenderingServer.texture_2d_update(paintTexture.get_rid(), canvasImage, 0)
		$PlayerHeadPaint.texture = paintTexture

func _on_time_ticking_sound_finished() -> void:
	# this gets around sound not looping on web export for some reason
	$TimeTickingSound.play()


func _on_paint_1_button_button_down() -> void:
	currentPaint = paintOrange
	drawSize = 128

func _on_paint_1_button_2_button_down() -> void:
	currentPaint = paintOrange
	drawSize = 128

func _on_paint_2_button_button_down() -> void:
	currentPaint = paintWhite
	drawSize = 64


func _on_paint_3_button_button_down() -> void:
	currentPaint = paintBlack
	drawSize = 16


func _on_paint_3_button_2_button_down() -> void:
	currentPaint = paintBlack
	drawSize = 16


func _on_paint_3_button_3_button_down() -> void:
	currentPaint = paintBlack
	drawSize = 16
