extends CharacterBody2D
var time = 0
var finish = false
const SPEED = 90.0

@onready var playerBaseHead = preload("res://Sprites/tugofwarPersonPlayerHead.png")
@onready var playerWinningHead = preload("res://Sprites/tugofwarPersonPlayerWinning.png")
@onready var playerLosingHead = preload("res://Sprites/tugofwarPersonPlayerLosing.png")
@onready var personBaseHead = preload("res://Sprites/tugofwarPerson2Head.png")
@onready var personWinningHead = preload("res://Sprites/tugofwarPerson2winning.png")
@onready var personLosingHead = preload("res://Sprites/tugofwarPerson2losing.png")
@onready var playerLost = preload("res://Sprites/tugofwarPersonPlayeLost.png")
@onready var personLost = preload("res://Sprites/tugofwarPersonLose.png")

func _physics_process(delta: float) -> void:
	if time >= .6 and finish == false:
		velocity.x += -60
		time = 0
	if finish == false:
		if velocity.x < -100:
			$PersonHead.texture = personWinningHead
			$PlayerHead.texture = playerLosingHead
			$PersonBody.position.x = $PersonHands.position.x - .4
			$PlayerBody.position.x = $PlayerHands.position.x - .4
		elif velocity.x > 50:
			$PersonHead.texture = personLosingHead
			$PlayerHead.texture = playerWinningHead
			$PersonBody.position.x = $PersonHands.position.x + .4
			$PlayerBody.position.x = $PlayerHands.position.x + .4
		elif velocity.x < 30 and velocity.x > - 40:
			$PersonHead.texture = personBaseHead
			$PlayerHead.texture = playerBaseHead
			$PersonBody.position.x = $PersonHands.position.x
			$PlayerBody.position.x = $PlayerHands.position.x
		
	velocity.x += (velocity.x * -4 * delta)
		
	time += delta
	move_and_slide()


func _on_node_2d_good_hit() -> void:
	velocity.x += 310


func _on_node_2d_bad_hit() -> void:
	if finish == false:
		velocity.x -= 150


func _on_win_zone_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	finish = true
	velocity.x += 300
	$PersonHead.texture = personLost
	#when finish is true the rope will stop being pulled


func _on_lose_zone_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	finish = true 
	velocity.x -= 300
	$PlayerHead.texture = playerLost
	#when finish is true the rope will stop being pulled
