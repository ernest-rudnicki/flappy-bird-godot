extends Node3D


@export var obstacle_scene: PackedScene
@export var speed: float = 5.0;

@export var upper_start_position: float = 14.6;
@export var lower_start_position: float = -8.0;

@export var minScale: float = 2.0
@export var maxScale: float = 7.0

var obstacles: Array[Node3D] = []
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	create_obstacle()


func _process(delta: float) -> void:
	move_all_obstacles(delta)
	
func move_all_obstacles(delta: float) -> void:
	for obstacle in obstacles:
		obstacle.global_position.x -= speed * delta

	
func create_obstacle() -> void:
	var upper_obstacle = instantiate_obstacle()
	var lower_obstacle = instantiate_obstacle()
	
	upper_obstacle.rotate_x(PI)
	
	upper_obstacle.global_position = Vector3(global_position.x, upper_start_position, 0)
	lower_obstacle.global_position = Vector3(global_position.x, lower_start_position, 0)
	
	#upper_obstacle.scale.y = 12.0
	#lower_obstacle.scale.y = randomize_scale()
	
	obstacles.push_back(upper_obstacle)
	#obstacles.push_back(lower_obstacle)

func randomize_scale() -> float:
	return rng.randf_range(minScale, maxScale)

func instantiate_obstacle() -> Node3D:
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)
	return obstacle
