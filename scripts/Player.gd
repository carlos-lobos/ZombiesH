extends Node2D

@onready var gun_position = $GunPosition
@onready var sprite = $Sprite2D

var bullet_scene = preload("res://scenes/Bullet.tscn")
var bomb_scene = preload("res://scenes/Bomb.tscn")

var shoot_cooldown: float = 0.08
var last_shoot_time: float = 0.0

func _ready():
	position = get_viewport_rect().size / 2

func _process(delta):
	if not GameManager.is_game_running:
		return
	
	handle_input()
	queue_redraw()

func handle_input():
	if Input.is_action_pressed("shoot"):
		shoot()
	
	if Input.is_action_just_pressed("throw_bomb"):
		throw_bomb()

func shoot():
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_shoot_time < shoot_cooldown:
		return
	
	last_shoot_time = current_time
	
	var bullet = bullet_scene.instantiate()
	bullet.position = gun_position.global_position
	bullet.direction = get_aim_direction()
	get_parent().add_child(bullet)

func throw_bomb():
	if GameManager.use_bomb():
		var bomb = bomb_scene.instantiate()
		bomb.position = gun_position.global_position
		bomb.direction = get_aim_direction()
		get_parent().add_child(bomb)

func get_aim_direction() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	return (mouse_pos - global_position).normalized()

func _draw():
	draw_circle(Vector2(0, 0), 30, Color(0.2, 0.4, 0.6))
	draw_circle(Vector2(0, -15), 20, Color(0.9, 0.8, 0.7))
	draw_circle(Vector2(-8, -20), 5, Color(0.2, 0.2, 0.8))
	draw_circle(Vector2(8, -20), 5, Color(0.2, 0.2, 0.8))
	draw_rect(Rect2(-10, -5, 20, 8), Color(0.3, 0.2, 0.2))
	
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	draw_line(Vector2(0, 0), dir * 40, Color(0.5, 0.5, 0.5), 3)
	draw_circle(dir * 40, 5, Color(0.8, 0.2, 0.2))
