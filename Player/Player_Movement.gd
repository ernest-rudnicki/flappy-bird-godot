extends CharacterBody3D

@export var gravity: float = 40.0
@export var jumpForce: float = 20.0
@export var canJumpForceTreshold: float = -10.0

@export var minYValue: float = -15.0
@export var maxYValue: float = 10.0

var isStillJumping = false;
var hadFirstJump = false;

func _physics_process(delta: float) -> void:	
	if Input.is_action_pressed("jump") and canJump():
		velocity.y = jumpForce
		isStillJumping = true
		hadFirstJump = true
	elif hadFirstJump:
		velocity.y -= gravity * delta
		
	if velocity.y < canJumpForceTreshold:
		isStillJumping = false
		
	move_and_slide()
	
	global_position.y = clamp(global_position.y, minYValue, maxYValue)
	
	if global_position.y == maxYValue:
		velocity.y = 0.0
	
func canJump():
	return not isStillJumping
