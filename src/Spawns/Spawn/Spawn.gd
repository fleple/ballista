extends Node2D

export (Array, PackedScene) var enemies

onready var path_follow := $Path2D/PathFollow2D

var enemies_count := 0
var current_index := 0
var current_speed := 0
var current_instance :KinematicBody2D = null

func _ready() -> void:
	
	enemies_count = enemies.size()
	set_enemy(current_index)

func _physics_process(delta: float) -> void:
	path_follow.offset += current_speed * delta
	#good for now, but better to have a signal and not to check it here every time
	if current_instance != null and current_instance.is_dead:
		path_follow.offset = 0
		current_speed = 0.0
		if current_index + 1 != enemies_count:
			current_index += 1
			set_enemy(current_index)
		else:
			queue_free()

func set_enemy(index: int) -> void:
	current_instance = enemies[index].instance()
	path_follow.loop = current_instance.loop
	yield(get_tree().create_timer(current_instance.delay), "timeout")
	current_speed = current_instance.speed
	path_follow.add_child(current_instance)
