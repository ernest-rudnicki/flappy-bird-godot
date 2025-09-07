extends Node3D

@export var cleanup_after: float = 7.0
@export var impulse_min: float = 2.0
@export var impulse_max: float = 6.0
@export var spin_max = 8.0


func init(base_vel: Vector3, hit_pos: Vector3, hit_normal: Vector3) -> void:
	for c in get_children():
		if c is RigidBody3D:
			var rb = c as RigidBody3D
			rb.linear_velocity = base_vel
			
			var dir = (rb.global_transform.origin - hit_pos).normalized()
			var tangent = (dir.cross(Vector3.UP)).normalized()
			
			var impulse = dir * randf_range(impulse_min, impulse_max) + hit_normal * randf_range(impulse_min, impulse_max) + tangent * randf_range(-impulse_max, impulse_max)
			
			rb.apply_impulse(impulse)
			rb.angular_velocity = Vector3(randf_range(-spin_max, spin_max), randf_range(-spin_max, spin_max), randf_range(-spin_max, spin_max))
