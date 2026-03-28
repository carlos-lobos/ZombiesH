extends Node

signal score_updated(points: int)
signal bombs_updated(bombs: int)
signal wave_updated(wave: int, phase: String)
signal phase_changed(phase: String)
signal game_over
signal victory

enum GamePhase { ATTACK_SLOW, ATTACK_INTENSE, WAVE_COMPLETE, GAME_OVER, VICTORY }

var score: int = 0
var bombs: int = 3
var max_bombs: int = 3
var current_wave: int = 1
var max_waves: int = 5
var current_phase: GamePhase = GamePhase.ATTACK_SLOW

var is_game_running: bool = false
var phase_timer: float = 0.0

var attack_slow_duration: float = 60.0
var attack_intense_duration: float = 120.0

var zombies_per_wave: Array = [5, 8, 12, 18, 25]
var zombie_speed_multiplier: float = 1.0

func _ready():
	reset_game()

func reset_game():
	score = 0
	bombs = 3
	current_wave = 1
	current_phase = GamePhase.ATTACK_SLOW
	is_game_running = true
	zombie_speed_multiplier = 1.0
	emit_signals()

func emit_signals():
	score_updated.emit(score)
	bombs_updated.emit(bombs)
	wave_updated.emit(current_wave, get_phase_name())

func get_phase_name() -> String:
	match current_phase:
		GamePhase.ATTACK_SLOW:
			return "ATAQUE LENTO"
		GamePhase.ATTACK_INTENSE:
			return "ATAQUE INTENSO"
		GamePhase.WAVE_COMPLETE:
			return "¡OLAS COMPLETADA!"
		GamePhase.GAME_OVER:
			return "GAME OVER"
		GamePhase.VICTORY:
			return "¡VICTORIA!"
	return ""

func add_score(points: int):
	score += points
	score_updated.emit(score)

func use_bomb() -> bool:
	if bombs > 0:
		bombs -= 1
		bombs_updated.emit(bombs)
		return true
	return false

func add_bomb():
	if bombs < max_bombs:
		bombs += 1
		bombs_updated.emit(bombs)

func start_wave():
	current_phase = GamePhase.ATTACK_SLOW
	phase_timer = attack_slow_duration
	phase_changed.emit(get_phase_name())
	MusicManager.play_slow_music()

func _process(delta: float):
	if not is_game_running:
		return
	
	if current_phase == GamePhase.ATTACK_SLOW or current_phase == GamePhase.ATTACK_INTENSE:
		phase_timer -= delta
		if phase_timer <= 0:
			_on_phase_complete()

func _on_phase_complete():
	match current_phase:
		GamePhase.ATTACK_SLOW:
			current_phase = GamePhase.ATTACK_INTENSE
			phase_timer = attack_intense_duration
			phase_changed.emit(get_phase_name())
			MusicManager.play_intense_music()
		GamePhase.ATTACK_INTENSE:
			complete_wave()

func complete_wave():
	if current_wave >= max_waves:
		victory_state()
	else:
		current_phase = GamePhase.WAVE_COMPLETE
		phase_changed.emit(get_phase_name())
		zombie_speed_multiplier += 0.2
		
		await get_tree().create_timer(3.0).timeout
		
		current_wave += 1
		start_wave()
		wave_updated.emit(current_wave, get_phase_name())

func victory_state():
	is_game_running = false
	current_phase = GamePhase.VICTORY
	phase_changed.emit(get_phase_name())
	MusicManager.play_epic_music()
	victory.emit()

func game_over_state():
	is_game_running = false
	current_phase = GamePhase.GAME_OVER
	phase_changed.emit(get_phase_name())
	MusicManager.play_gameover_music()
	game_over.emit()

func restart_game():
	reset_game()
	start_wave()
