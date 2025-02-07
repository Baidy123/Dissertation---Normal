class_name PlayerStats

extends Resource

@export var Background : String
#attributes
@export var constitution : int = 2
@export var strength : int  = 2
@export var perception : int = 2

#skills
@export var endurance : int = 10
@export var resilience : int = 10
@export var melee_weapons : int = 10 
@export var intimidation : int = 10
#@export var weapon_handling : int = 10 
@export var handguns : int = 10
@export var rifles : int = 10
@export var base_value : int 

@export var unassigned_skill_points: int = 0

func _init() -> void:
	_calculate_skills()
	
func _apply_background_influence():
	match Background:
		"Firefighter":
			constitution += 1
			strength += 2
		"Assassin":
			perception += 3
			constitution -= 1
		"Soldier":
			constitution += 1
			strength += 1
			perception += 1
		_:
			pass
		
func _calculate_skills():
	_apply_background_influence()
	endurance = base_value * (1 + constitution * 0.5)
	resilience = base_value * (1 + constitution * 0.5)
	melee_weapons = base_value * (1 + strength * 0.5)
	intimidation = base_value * (1 + strength * 0.5)
	#weapon_handling = base_value * (1 + strength * 0.5)
	handguns = base_value * (1 + perception * 0.5)
	rifles = base_value * (1 + perception * 0.5)

func on_level_up(skill_points_gain: int):
	unassigned_skill_points += skill_points_gain
	#print("Resource got on_level_up(): unassigned_skill_points =", unassigned_skill_points)
	
