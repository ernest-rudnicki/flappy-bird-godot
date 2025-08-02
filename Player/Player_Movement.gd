extends CharacterBody3D


@export var gravity: float = 40;
@export var jumpForce: float = 20;
@export var canJumpForceTreshold: float = -10;

var cannotJump = false;
var hadFirstJump = false;

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("jump") and not cannotJump:
		velocity.y = jumpForce
		cannotJump = true
		hadFirstJump = true
	elif hadFirstJump:
		velocity.y -= gravity * delta
		
	if velocity.y < canJumpForceTreshold:
		cannotJump = false
		
	move_and_slide()
