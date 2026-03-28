extends CharacterBody2D

var target: Vector2 = Vector2.ZERO
var base_speed: float = 60.0
var speed_multiplier: float = 1.0
var hp: int = 2

var base_scale_factor: float = 0.5
var target_scale: float = 1.0
var zombie_color: Color

func _ready():
	scale = Vector2(base_scale_factor, base_scale_factor)
	hp = randi_range(1, 2)
	zombie_color = Color(randf_range(0.2, 0.5), randf_range(0.6, 0.8), randf_range(0.2, 0.4), 1.0)
	queue_redraw()

func _physics_process(delta):
	if not GameManager.is_game_running:
		return
	
	var direction = (target - global_position).normalized()
	velocity = direction * base_speed * speed_multiplier
	move_and_slide()
	
	update_scale()
	
	if is_on_screen() and global_position.distance_to(target) < 60:
		damage_player()

func update_scale():
	var screen_size = get_viewport_rect().size
	var distance_to_target = global_position.distance_to(target)
	var max_distance = screen_size.length() / 2
	
	var t = 1.0 - clamp(distance_to_target / max_distance, 0.0, 1.0)
	var new_scale = lerp(base_scale_factor, target_scale, t)
	scale = Vector2(new_scale, new_scale)

func is_on_screen() -> bool:
	var screen_rect = get_viewport_rect()
	return screen_rect.has_point(global_position)

func take_damage(damage: int):
	hp -= damage
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if hp <= 0:
		die()

func die():
	GameManager.add_score(10)
	queue_free()

func damage_player():
	GameManager.game_over_state()
	queue_free()

func _draw():
	draw_circle(Vector2.ZERO, 25, zombie_color)
	draw_circle(Vector2(-8, -8), 6, Color(0.9, 0.2, 0.2))
	draw_circle(Vector2(8, -8), 6, Color(0.9, 0.2, 0.2))
	draw_rect(Rect2(-12, 5, 24, 8), Color(0.1, 0.3, 0.1))
	draw_circle(Vector2(-15, -20), 8, zombie_color.darkened(0.3))
	draw_circle(Vector2(15, -20), 8, zombie_color.darkened(0.3))
