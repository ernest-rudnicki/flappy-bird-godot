extends CharacterBody3D


@export var gravity: float = 9.81;

func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta;
	
	move_and_slide()
