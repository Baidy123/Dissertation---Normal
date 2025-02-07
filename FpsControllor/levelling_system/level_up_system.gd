extends Node3D

@export var player : Player
@export var player_stats: PlayerStats

@export var curr_level : int = 1
@export var max_level : int = 12

@export var skill_points_gained : int
var experience : int = 0
var experience_total : int = 0
var experience_required : int = get_required_experience(curr_level + 1)

@export var perk_requirement = {
	"1a": {
		"attribute": {"constitution": 3},
		"skill": {"resilience": 10},
		"points": 1
	},
	"1b": {
		"attribute": {"constitution": 3},
		"skill": {"resilience": 20},
		"points": 1
	},
	"1c": {
		"attribute": {"constitution": 3},
		"skill": {"resilience": 30},
		"points": 1
	},
	"2a": {
		"attribute": {"constitution": 3},
		"skill": {"resilience": 40},
		"points": 1
	},
	"2b": {
		"attribute": {"constitution": 3},
		"skill": {"resilience": 50},
		"points": 1
	},
	"2c": {
		"attribute": {"constitution": 5},
		"skill": {"resilience": 240},
		"points": 1
	},
	"3a": {
		"attribute": {"constitution": 7},
		"skill": {"resilience": 20},
		"points": 1
	},
	"3b": {
		"attribute": {"constitution": 9},
		"skill": {"resilience": 20},
		"points": 1
	},
	"3c": {
		"attribute": {"strength": 10},
		"skill": {"resilience": 20},
		"points": 1
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var constitution = player_stats.constitution
	var strength = player_stats.strength
	var perception = player_stats.perception

func get_required_experience(level):
	if curr_level < max_level:
		return round(200 * (pow(level, 2) + level * 4))
	else :
		return 0 #round(200 * (pow(max_level - 1, 2) + (max_level - 1) * 4))
		
func gain_experience(amount):
	if curr_level < max_level:
		experience_total += amount
		experience += amount
		while experience >= experience_required:
			experience -= experience_required
			level_up()

func level_up():
	if curr_level < max_level:
		curr_level += 1
		experience_required = get_required_experience(curr_level + 1)
		if player_stats and player_stats.has_method("on_level_up"):
			player_stats.on_level_up(skill_points_gained)

		#print("Level up! current level:", curr_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
