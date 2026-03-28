extends Area2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 300.0
var explosion_radius: float = 150.0
var lifetime: float = 1.0

var is_exploding: bool = false

func _ready():
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(explode)

func _physics_process(delta):
	if not is_exploding:
		position += direction * speed * delta

func explode():
	if is_exploding:
		return
	is_exploding = true
	
	modulate = Color(1, 0.3, 0)
	scale = Vector2(2, 2)
	queue_redraw()
	
	await get_tree().create_timer(0.15).timeout
	
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(10)
	
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _draw():
	if is_exploding:
		draw_circle(Vector2.ZERO, 70, Color(1, 0.5, 0, 0.7))
		draw_circle(Vector2.ZERO, 90, Color(1, 0.2, 0, 0.5), false)
	else:
		draw_circle(Vector2.ZERO, 18, Color(0.2, 0.2, 0.2))
		draw_circle(Vector2(0, -12), 10, Color(0.8, 0.3, 0))
		draw_circle(Vector2(0, 0), 12, Color(0.5, 0.5, 0.5))
