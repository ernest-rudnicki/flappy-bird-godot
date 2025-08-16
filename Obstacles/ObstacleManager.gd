extends Node3D


@export var obstacle_scene: PackedScene
@export var speed: float = 5.0;

@export var upper_start_position: float = 10.7;
@export var bottom_start_position: float = -10.0;

@export var minScale: float = 1.0
@export var maxScale: float = 5.0

var obstacles: Array[Node3D] = []
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	create_obstacle()


func _process(delta: float) -> void:
	move_all_obstacles(delta)
	
	
func create_obstacle() -> Node3D:
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)
	
	obstacle.global_position = Vector3(global_position.x, upper_start_position, 0)
	obstacle.scale.y = randomize_scale()
	obstacles.push_front(obstacle)
	
	return obstacle
	
func move_all_obstacles(delta: float) -> void:
	obstacles.all(
		func(el: Node3D):
		el.global_position.x -= speed * delta
		)


func randomize_scale() -> float:
	return rng.randf_range(minScale, maxScale)
