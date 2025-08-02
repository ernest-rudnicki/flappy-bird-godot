extends CharacterBody3D


@export var gravity: float = 9.81;
@export var jumpForce: float = 20;


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		velocity.y = jumpForce
	else:
		velocity.y -= gravity * delta
