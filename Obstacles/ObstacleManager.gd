extends Node3D


@export var obstacle_scene: PackedScene
@export var speed: float = 5.0;

@export var gap_size: float = 4.0
@export var min_center: float = -4.0
@export var max_center: float = 4.0
@export var spawn_interval: float = 2.0
@export var remove_position: float = -20.0

@export var precreated_obstacles_count = 20;

var obstacles: Array[Node3D] = []
var unused_obstacles: Array[Node3D] = []

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	precreate_obstacles()
	reuse_unused_obstacle()

func _on_timer_timeout() -> void:
	reuse_unused_obstacle()

func _process(delta: float) -> void:
	move_all_obstacles(delta)
	
func move_all_obstacles(delta: float) -> void:
	var to_remove: Array = []
	
	for obstacle in obstacles:
		obstacle.global_position.x -= speed * delta
		
		if obstacle.global_position.x < remove_position:
			to_remove.append(obstacle)
			
	for removed in to_remove:
		obstacles.erase(removed)
		unused_obstacles.push_back(removed)
		
func precreate_obstacles() -> void:
	for index in precreated_obstacles_count:
		create_obstacle()

func reuse_unused_obstacle() -> void:
	if unused_obstacles.size() != 0:
		var upper_obstacle = unused_obstacles.pop_front()
		var lower_obstacle = unused_obstacles.pop_front()
		
		setup_obstacle_position(upper_obstacle, lower_obstacle)
		
		obstacles.push_back(upper_obstacle)
		obstacles.push_back(lower_obstacle)
	
	
func create_obstacle() -> void:
	var upper_obstacle = instantiate_obstacle()
	var lower_obstacle = instantiate_obstacle()
	lower_obstacle.rotate_x(PI)
	
	setup_obstacle_position(upper_obstacle, lower_obstacle)
	
	unused_obstacles.push_back(upper_obstacle)
	unused_obstacles.push_back(lower_obstacle)
	
func setup_obstacle_position(upper_obstacle: Node3D, lower_obstacle: Node3D) -> void:
	var gap_center = randomize_gap_center()
	
	upper_obstacle.global_position = Vector3(global_position.x, 0, 0)
	lower_obstacle.global_position = Vector3(global_position.x, 0, 0)
	
	upper_obstacle.global_position.y = gap_center + gap_size
	lower_obstacle.global_position.y = gap_center - gap_size

func randomize_gap_center() -> float:
	return rng.randf_range(min_center, max_center)

func instantiate_obstacle() -> Node3D:
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)
	return obstacle
