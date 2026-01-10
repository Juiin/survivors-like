extends Node2D

@onready var line_edit = $LineEdit
@onready var button = $Button
@onready var rank_label = %RankLabel

var final_score: float
var time: float

func _ready():
	time = Game.elapsed_time
	final_score = (1 / Game.elapsed_time) * 100000
	button.pressed.connect(_on_button_pressed)

	
	var sw_result = await SilentWolf.Scores.get_score_position(final_score).sw_get_position_complete
	var pos = sw_result.position
	rank_label.text = "Rank #%d with time:" % pos

func _on_button_pressed():
	if line_edit.text == "":
		return

	var player_name = line_edit.text
	var score: float = final_score
	var ldboard_name = "main"
	var metadata = {
		"elapsed_time": time,
	}
	SilentWolf.Scores.save_score(player_name, score, ldboard_name, metadata)
	%Leaderboard.clear_leaderboard()
	%Leaderboard.render_board(SilentWolf.Scores.scores, SilentWolf.Scores.local_scores)
	queue_free()