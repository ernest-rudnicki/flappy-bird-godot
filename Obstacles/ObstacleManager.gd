extends Node3D


@export var obstacle_scene: PackedScene
@export var speed: float = 5.0;

@export var score_per_obstacle: int = 10;
@export var score_obstacle_group = "score_obstacle"
@export var score_label: Label
@export var game_over_screen: Control
@export var final_score_label: Label
@export var start_again_button: Button

@export var gap_size: float = 4.0
@export var min_center: float = -4.0
@export var max_center: float = 4.0
@export var spawn_interval: float = 2.0
@export var remove_position: float = -20.0

@export var precreated_obstacles_count = 20
@export var player: CharacterBody3D

var obstacles: Array[Area3D] = []
var unused_obstacles: Array[Area3D] = []
var player_raycast: RayCast3D = null
var has_hit: bool = false
var stopped_movement: bool = false

var rng = RandomNumberGenerator.new()

var score: int = 0;

func _ready() -> void:
	precreate_obstacles()
	reuse_unused_obstacle()
	player_raycast = player.get_node("Raycast")

func _on_timer_timeout() -> void:
	reuse_unused_obstacle()

func _process(delta: float) -> void:
	move_all_obstacles(delta)
	check_raycast_hit_obstacle()
	
func move_all_obstacles(delta: float) -> void:
	if stopped_movement: return
	
	var to_remove: Array = []
	
	for obstacle in obstacles:
		obstacle.global_position.x -= speed * delta
		
		if obstacle.global_position.x < remove_position:
			to_remove.append(obstacle)
			
	for removed in to_remove:
		obstacles.erase(removed)
		removed.remove_from_group(score_obstacle_group)
		unused_obstacles.push_back(removed)
		
func precreate_obstacles() -> void:
	for index in precreated_obstacles_count:
		create_obstacle()

func reuse_unused_obstacle() -> void:
	if unused_obstacles.size() != 0:
		var upper_obstacle = unused_obstacles.pop_front()
		var lower_obstacle = unused_obstacles.pop_front()
		lower_obstacle.add_to_group(score_obstacle_group)
		
		setup_obstacle_position(upper_obstacle, lower_obstacle)
		
		obstacles.push_back(upper_obstacle)
		obstacles.push_back(lower_obstacle)
	
	
func create_obstacle() -> void:
	var upper_obstacle = instantiate_obstacle()
	var lower_obstacle = instantiate_obstacle()
	lower_obstacle.rotate_x(PI)
	
	upper_obstacle.body_entered.connect(_on_area_entered.bind(upper_obstacle))
	lower_obstacle.body_entered.connect(_on_area_entered.bind(lower_obstacle))
	
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
	
func _on_area_entered(body: Node, obstacle: Area3D) -> void:
	if body == player:
		var hit_pos = obstacle.global_transform.origin
		var hit_normal = (player.global_transform.origin - hit_pos).normalized()
		player.explode(hit_pos, hit_normal)
		make_game_over_screen()
		stopped_movement = true

func check_raycast_hit_obstacle() -> void:
	if player_raycast.is_colliding():
		var hit = player_raycast.get_collider()
		if hit and hit.is_in_group(score_obstacle_group):
			has_hit = true
	elif has_hit:
		has_hit = false;
		score += score_per_obstacle
		score_label.text = "%d" % score


func make_game_over_screen() -> void:
	score_label.visible = false
	game_over_screen.visible = true
	final_score_label.text = "Your score: %d" % score
	
		
