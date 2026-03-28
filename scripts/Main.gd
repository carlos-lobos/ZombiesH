extends Node2D

@onready var player = $Player
@onready var spawn_area = $SpawnArea
@onready var ui = $UI

var zombie_scene = preload("res://scenes/Zombie.tscn")
var bullet_scene = preload("res://scenes/Bullet.tscn")
var bomb_scene = preload("res://scenes/Bomb.tscn")
var dead_soldier_scene = preload("res://scenes/DeadSoldier.tscn")

var spawn_timer: float = 0.0
var dead_soldier_timer: float = 0.0

var base_spawn_rate: float = 2.0

var window_margin = 80

func _ready():
	spawn_timer = 1.0
	dead_soldier_timer = randf_range(5.0, 15.0)
	GameManager.start_wave()
	connect_signals()

func connect_signals():
	GameManager.score_updated.connect(_on_score_updated)
	GameManager.bombs_updated.connect(_on_bombs_updated)
	GameManager.wave_updated.connect(_on_wave_updated)
	GameManager.phase_changed.connect(_on_phase_changed)
	GameManager.game_over.connect(_on_game_over)
	GameManager.victory.connect(_on_victory)

func _process(delta):
	if not GameManager.is_game_running:
		return
	
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_zombie()
		update_spawn_rate()
	
	dead_soldier_timer -= delta
	if dead_soldier_timer <= 0:
		spawn_dead_soldier()
		dead_soldier_timer = randf_range(15.0, 30.0)

func update_spawn_rate():
	var wave = GameManager.current_wave
	var phase_modifier = 1.0 if GameManager.current_phase == GameManager.GamePhase.ATTACK_SLOW else 0.4
	
	spawn_timer = base_spawn_rate * phase_modifier / (1.0 + wave * 0.15)

func spawn_zombie():
	var zombie = zombie_scene.instantiate()
	var spawn_pos = get_spawn_position_inside_window()
	zombie.position = spawn_pos
	zombie.target = player.global_position
	zombie.speed_multiplier = GameManager.zombie_speed_multiplier
	add_child(zombie)
	zombie.connect("tree_exiting", _on_zombie_killed)

func spawn_dead_soldier():
	var soldier = dead_soldier_scene.instantiate()
	var spawn_pos = get_spawn_position_inside_window()
	soldier.position = spawn_pos
	add_child(soldier)

func get_spawn_position_inside_window() -> Vector2:
	var screen_size = get_viewport_rect().size
	var margin = window_margin
	
	var min_x = margin
	var max_x = screen_size.x - margin
	var min_y = margin + 100
	var max_y = screen_size.y - margin - 80
	
	var corner = randi() % 4
	var pos: Vector2
	
	match corner:
		0:
			pos = Vector2(randf_range(min_x, max_x), min_y)
		1:
			pos = Vector2(randf_range(min_x, max_x), max_y)
		2:
			pos = Vector2(min_x, randf_range(min_y, max_y))
		_:
			pos = Vector2(max_x, randf_range(min_y, max_y))
	
	return pos

func _on_zombie_killed():
	pass

func _on_score_updated(points: int):
	ui.update_score(points)

func _on_bombs_updated(bombs: int):
	ui.update_bombs(bombs)

func _on_wave_updated(wave: int, phase: String = ""):
	ui.update_wave(wave)

func _on_phase_changed(phase: String):
	ui.update_phase(phase)
	if phase == "¡OLAS COMPLETADA!":
		ui.show_wave_complete()

func _on_game_over():
	ui.show_game_over()

func _on_victory():
	ui.show_victory()
