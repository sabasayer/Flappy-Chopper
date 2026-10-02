extends Node

const MIN_PIPE_PAIR_DISTANCE :int = 100

# 2 pipe pair should have fair enough difference on their gap
# So player can be able to react and pass through

const MAX_CONSEQUENT_PIPE_PAIR_GAP_DIFF :int = 200

enum SpawnType {
	PIPE,
	PIPE_WITH_ENEMY,
	ENEMY_ONLY
}

const PIPE_PAIR_GAP_SETTING_BY_DISTANCE = {
	0: { 'gap_height_range': [260, 340], 'gap_padding': 100 },
	3000: { 'gap_height_range': [230, 250], 'gap_padding': 100 },
	12000: { 'gap_height_range': [220, 240], 'gap_padding': 100 },
	15000: { 'gap_height_range': [200, 230], 'gap_padding': 100 },
}

var last_gap_y

var player: Player:
	get():
		return get_tree().get_first_node_in_group("player") as Player

var player_distance: float:
	get():
		return player.global_position.x

func get_current_config_by_distance(config):
	var current_player_distance = player_distance
	var found_config
	for distance in config:
		if current_player_distance >= distance:
			found_config = config[distance]
	
	return found_config

var current_pipe_pair_config:
	get():
		return get_current_config_by_distance(PIPE_PAIR_GAP_SETTING_BY_DISTANCE)

func get_multiplier() -> float:
	var multiplier := player_distance / 1000
	return max(multiplier,1.0)
	
func get_base_distance() -> int:
	var min_val = 300
	var max_val = 350
	return randi_range(min_val,max_val)
	
func get_base_gap() -> int:
	var min_val = 200
	var max_val = 250
	return randi_range(min_val,max_val)

func get_next_spawn_information():
	var multiplier := get_multiplier()
	var base_distance := get_base_distance()
	var base_gap := get_base_gap()
	
	var calculated_distance = base_distance - ( 10 * multiplier)
	var pipe_gap = base_gap - ( 2 * multiplier )
	
	GlobalLogger.log_on_change_value("calculated_distance",calculated_distance)
	GlobalLogger.log_on_change_value("pipe_gap",pipe_gap)
	
	var gap_y = randi_range(100,400)
	
	if last_gap_y != null:
		var diff = abs(last_gap_y - gap_y)
		if diff > MAX_CONSEQUENT_PIPE_PAIR_GAP_DIFF:
			gap_y -= diff - MAX_CONSEQUENT_PIPE_PAIR_GAP_DIFF
	
	var pipe_pair_distance = max( MIN_PIPE_PAIR_DISTANCE ,calculated_distance )
	
	return {
		"pipe_pair_distance":pipe_pair_distance,
		"pipe_gap": pipe_gap,
		"pipe_gap_y": gap_y
	}
