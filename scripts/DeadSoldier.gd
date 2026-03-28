extends Area2D

var lifetime: float = 12.0
var is_collected: bool = false
var hover_timer: float = 0.0
var soldier_color: Color

func _ready():
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(_on_timeout)
	scale = Vector2(0.7, 0.7)
	soldier_color = Color(0.3, 0.5, 0.3)
	queue_redraw()

func _process(delta):
	if is_collected:
		return
	
	var mouse_pos = get_global_mouse_position()
	var dist = global_position.distance_to(mouse_pos)
	
	if dist < 40:
		hover_timer += delta
		scale = Vector2(0.7 + sin(hover_timer * 10) * 0.1, 0.7 + sin(hover_timer * 10) * 0.1)
		if dist < 30:
			collect()
	else:
		hover_timer = 0.0
		scale = Vector2(0.7, 0.7)

func collect():
	if is_collected:
		return
	is_collected = true
	
	GameManager.add_bomb()
	queue_free()

func _on_timeout():
	queue_free()

func _draw():
	draw_rect(Rect2(-20, -15, 40, 30), soldier_color)
	draw_circle(Vector2(0, -18), 12, Color(0.8, 0.7, 0.5))
	draw_rect(Rect2(-18, 0, 36, 12), Color(0.2, 0.3, 0.2))
	draw_circle(Vector2(-8, -22), 4, Color(0.3, 0.6, 0.9))
	draw_circle(Vector2(8, -22), 4, Color(0.3, 0.6, 0.9))
	draw_circle(Vector2(0, -5), 3, Color(1, 1, 0.5))
