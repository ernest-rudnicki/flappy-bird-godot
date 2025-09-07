extends CharacterBody3D

@export var gravity: float = 40.0
@export var jumpForce: float = 20.0
@export var canJumpForceTreshold: float = -10.0

@export var minYValue: float = -15.0
@export var maxYValue: float = 10.0

@export var shard_wreck_scene: PackedScene

var isStillJumping: bool = false
var hadFirstJump: bool = false
var alive: bool = true
var last_vel: Vector3

func _physics_process(delta: float) -> void:	
	if Input.is_action_pressed("jump") and can_jump():
		velocity.y = jumpForce
		isStillJumping = true
		hadFirstJump = true
	elif hadFirstJump:
		velocity.y -= gravity * delta
		
	if velocity.y < canJumpForceTreshold:
		isStillJumping = false

	move_and_slide()
	last_vel = velocity;
	restrict_movement()
	
func can_jump() -> bool:
	return not isStillJumping
	
func restrict_movement() -> void:
	global_position.y = clamp(global_position.y, minYValue, maxYValue)
	
	if global_position.y == maxYValue:
		velocity.y = 0.0

func explode(hit_pos: Vector3, hit_normal: Vector3) -> void:
	if not alive: return
	alive = false
	
	collision_layer = 0
	set_physics_process(false)
	visible = false
	
	var wreck := shard_wreck_scene.instantiate()
	get_tree().current_scene.add_child(wreck)
	wreck.global_transform = global_transform
	
	wreck.init(last_vel, hit_pos, hit_normal)
	
	
