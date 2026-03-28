extends CanvasLayer

@onready var score_label = $Panel/HBoxContainer/ScoreLabel
@onready var bombs_container = $Panel/HBoxContainer/BombsContainer
@onready var wave_label = $Panel/WaveLabel
@onready var phase_label = $Panel/PhaseLabel
@onready var message_panel = $MessagePanel
@onready var message_label = $MessagePanel/MessageLabel

var bomb_icons: Array[TextureRect] = []

func _ready():
	GameManager.connect("score_updated", update_score)
	GameManager.connect("bombs_updated", update_bombs)
	GameManager.connect("wave_updated", _on_wave_updated)
	GameManager.connect("phase_changed", update_phase)
	GameManager.connect("game_over", show_game_over)
	GameManager.connect("victory", show_victory)
	
	update_score(0)
	update_bombs(3)
	update_wave(1)
	update_phase("ATAQUE LENTO")
	message_panel.visible = false

func _on_wave_updated(wave: int, phase: String = ""):
	update_wave(wave)

func update_score(points: int):
	score_label.text = "PUNTOS: " + str(points)

func update_bombs(bombs: int):
	for child in bombs_container.get_children():
		child.queue_free()
	bomb_icons.clear()
	
	for i in range(bombs):
		var icon = TextureRect.new()
		icon.custom_minimum_size = Vector2(24, 24)
		var color_rect = ColorRect.new()
		color_rect.color = Color.ORANGE_RED
		color_rect.size = Vector2(20, 20)
		icon.add_child(color_rect)
		bombs_container.add_child(icon)
		bomb_icons.append(icon)

func update_wave(wave: int):
	wave_label.text = "OLA " + str(wave) + "/5"

func update_phase(phase: String):
	phase_label.text = phase
	
	if phase == "ATAQUE LENTO":
		phase_label.modulate = Color.GREEN
	elif phase == "ATAQUE INTENSO":
		phase_label.modulate = Color.RED
	elif phase == "¡OLAS COMPLETADA!":
		phase_label.modulate = Color.YELLOW
	elif phase == "¡VICTORIA!":
		phase_label.modulate = Color.GOLD

func show_wave_complete():
	message_panel.visible = true
	message_label.text = "¡HAS PARADO UNA ORDA!"
	message_label.modulate = Color.YELLOW
	await get_tree().create_timer(2.0).timeout
	message_panel.visible = false

func show_game_over():
	message_panel.visible = true
	message_label.text = "GAME OVER\n\nHAS SOBREVIVIDO " + str(GameManager.current_wave) + " OLAS\nPUNTUACIÓN: " + str(GameManager.score) + "\n\nPRESIONA R PARA REINICIAR"
	message_label.modulate = Color.RED

func show_victory():
	message_panel.visible = true
	message_label.text = "¡HAS SOBREVIVIDO A LA INVASIÓN ZOMBIE!\n\nPUNTUACIÓN FINAL: " + str(GameManager.score) + "\n\nPRESIONA R PARA REINICIAR"
	message_label.modulate = Color.GOLD

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.pressed and event.keycode == KEY_R):
		if not GameManager.is_game_running:
			GameManager.restart_game()
			message_panel.visible = false
