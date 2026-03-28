extends Node

enum MusicState { NONE, SLOW, INTENSE, EPIC, GAMEOVER }

var current_state = MusicState.NONE
var fade_duration = 1.0

var music_slow: AudioStreamPlayer
var music_intense: AudioStreamPlayer
var music_epic: AudioStreamPlayer
var music_gameover: AudioStreamPlayer

func _ready():
	setup_audio_players()

func setup_audio_players():
	music_slow = AudioStreamPlayer.new()
	music_slow.name = "MusicSlow"
	add_child(music_slow)
	
	music_intense = AudioStreamPlayer.new()
	music_intense.name = "MusicIntense"
	add_child(music_intense)
	
	music_epic = AudioStreamPlayer.new()
	music_epic.name = "MusicEpic"
	add_child(music_epic)
	
	music_gameover = AudioStreamPlayer.new()
	music_gameover.name = "MusicGameover"
	add_child(music_gameover)

func play_slow_music():
	if current_state != MusicState.SLOW:
		transition_to(MusicState.SLOW)

func play_intense_music():
	if current_state != MusicState.INTENSE:
		transition_to(MusicState.INTENSE)

func play_epic_music():
	if current_state != MusicState.EPIC:
		transition_to(MusicState.EPIC)

func play_gameover_music():
	if current_state != MusicState.GAMEOVER:
		transition_to(MusicState.GAMEOVER)

func transition_to(new_state: int):
	var target_player: AudioStreamPlayer
	var others: Array[AudioStreamPlayer] = []
	
	match new_state:
		MusicState.SLOW:
			target_player = music_slow
			others = [music_intense, music_epic, music_gameover]
		MusicState.INTENSE:
			target_player = music_intense
			others = [music_slow, music_epic, music_gameover]
		MusicState.EPIC:
			target_player = music_epic
			others = [music_slow, music_intense, music_gameover]
		MusicState.GAMEOVER:
			target_player = music_gameover
			others = [music_slow, music_intense, music_epic]
	
	current_state = new_state
	
	for player in others:
		fade_out(player)
	
	if target_player:
		fade_in(target_player)

func fade_in(player: AudioStreamPlayer):
	if player.stream:
		var tween = create_tween()
		tween.tween_property(player, "volume_db", 0.0, fade_duration)
		player.play()

func fade_out(player: AudioStreamPlayer):
	if player.playing:
		var tween = create_tween()
		tween.tween_property(player, "volume_db", -80.0, fade_duration)
		await tween.finished
		player.stop()

func stop_all_music():
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()
	current_state = MusicState.NONE
