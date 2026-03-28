extends Area2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 800.0
var damage: int = 1
var lifetime: float = 2.0

func _ready():
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)

func _physics_process(delta):
	position += direction * speed * delta
	
	check_collision()
	
	var screen_rect = get_viewport_rect()
	if not screen_rect.has_point(position):
		queue_free()

func check_collision():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
			return

func _draw():
	draw_circle(Vector2.ZERO, 10, Color(1, 1, 0))
	draw_circle(Vector2.ZERO, 15, Color(1, 0.8, 0), false)
