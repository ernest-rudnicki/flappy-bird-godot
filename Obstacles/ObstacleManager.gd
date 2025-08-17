extends Node3D


@export var obstacle_scene: PackedScene
@export var speed: float = 5.0;

@export var gap_size: float = 4.0
@export var min_center: float = -4.0
@export var max_center: float = 4.0
@export var spawn_interval: float = 2.0

var obstacles: Array[Node3D] = []
var rng = RandomNumberGenerator.new()

func _ready() -> void:
		create_obstacle()

func _on_timer_timeout() -> void:
	create_obstacle()

func _process(delta: float) -> void:
	move_all_obstacles(delta)
	
func move_all_obstacles(delta: float) -> void:
	var to_remove: Array = []
	
	for obstacle in obstacles:
		obstacle.global_position.x -= speed * delta
		
		if obstacle.global_position.x < -15.0:
			obstacle.queue_free()
			to_remove.append(obstacle)
			
	for removed in to_remove:
		obstacles.erase(removed)
	
func create_obstacle() -> void:
	var upper_obstacle = instantiate_obstacle()
	var lower_obstacle = instantiate_obstacle()
	var gap_center = randomize_gap_center()
	
	lower_obstacle.rotate_x(PI)
	
	upper_obstacle.global_position = Vector3(global_position.x, 0, 0)
	lower_obstacle.global_position = Vector3(global_position.x, 0, 0)
	
	upper_obstacle.global_position.y = gap_center + gap_size
	lower_obstacle.global_position.y = gap_center - gap_size
	
	obstacles.push_back(upper_obstacle)
	obstacles.push_back(lower_obstacle)

func randomize_gap_center() -> float:
	return rng.randf_range(min_center, max_center)

func instantiate_obstacle() -> Node3D:
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)
	return obstacle
