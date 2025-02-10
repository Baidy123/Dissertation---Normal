class_name LevellingSystem
extends Node3D
@export var player : Player

@export var curr_level : int = 1
@export var max_level : int = 12
@export var skill_points_gained : int = 10

var constitution : int = 0
var strength : int = 0
var perception : int = 0

#var experience : int = 0
#var experience_total : int = 0
var experience_required : int = get_required_experience(curr_level + 1)


@export var slow_factor = 0.5
@export var dmg_reduce_rate = 0.5

@export var speed_boost_multiplier: float = 2.0
@export var perk_requirement = {
	"1a": {
		"name": "qinggong",
		"attribute": {"constitution": 3},
		"skill": {"resilience": 10},
		"points": 1
	},
	"1b": {
		"name": "bullet time",
		"attribute": {"constitution": 3},
		"skill": {"resilience": 20},
		"points": 1
	},
	"1c": {
		"name": "tough skin",
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
@export var bullet_time_cd := 0.0
@export var deserter_cd := 0.0
@export var die_hard_cd := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	constitution = player.attributes["constitution"]
	strength = player.attributes["strength"]
	perception = player.attributes["perception"]
	curr_level = player.curr_level
	player.experience["req_exp"] = experience_required

func get_required_experience(level):
	if curr_level < max_level:
		return round(200 * (pow(level, 2) + level * 4))
	else :
		return 0 #round(200 * (pow(max_level - 1, 2) + (max_level - 1) * 4))
		
func gain_experience(amount):
	if curr_level >= max_level:
		player.experience["curr_lvl_exp"] = 0
		return
	if curr_level < max_level:
		player.experience["total_exp"] += amount
		player.experience["curr_lvl_exp"] += amount
		while player.experience["curr_lvl_exp"] >= experience_required:
			player.experience["curr_lvl_exp"] -= experience_required
			level_up()
			if curr_level >= max_level:
				player.experience["curr_lvl_exp"] = 0
				break

func level_up():
	if curr_level < max_level:
		curr_level += 1
		experience_required = get_required_experience(curr_level + 1)
		player.experience["req_exp"] = experience_required
		if player and player.has_method("on_level_up"):
			player.on_level_up(skill_points_gained)
			print(curr_level)
			
			print(experience_required)
			

		#print("Level up! current level:", curr_level)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("gain_exp"):
		#gain_experience(10000)
		#print(player.experience["total_exp"])
		#print(player.experience["curr_lvl_exp"])
		player.take_damage(20, " ")
	
		
#PERKS
var jump_twice = false
#1a
func qinggong(delta):
	if jump_twice == false and Input.is_action_just_pressed("jump"):
			player.velocity.y = player.jump_velocity
			jump_twice = true
	if Input.is_action_pressed("sprint"):
			player.velocity.x = player.wish_dir.x * player.walk_speed * player.sprint_multi
			player.velocity.z = player.wish_dir.z * player.walk_speed * player.sprint_multi
	else:
		player.velocity.x = player.wish_dir.x * player.walk_speed
		player.velocity.z = player.wish_dir.z * player.walk_speed
	
	player.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta

var is_bullet_time_active = false
#1b
func bullet_time():
	if is_bullet_time_active:
		return  
	if bullet_time_cd != 0:
		return
	bullet_time_cd = 5.0
	is_bullet_time_active = true
	Engine.time_scale = slow_factor  
	await get_tree().create_timer(1 * slow_factor).timeout
	Engine.time_scale = 1.0  
	is_bullet_time_active = false
	bullet_time_cold_down()
	
func bullet_time_cold_down():
	await get_tree().create_timer(bullet_time_cd).timeout
	bullet_time_cd = 0
#1c
func tough_skin(dmg: float):
	return dmg * dmg_reduce_rate

#2a
var deserter_active: bool = false
func deserter():
	if deserter_cd != 0:
		return
	deserter_cd = 10
	deserter_active = true
	await get_tree().create_timer(2.0).timeout
	deserter_active = false
	deserter_cold_down()
	
func deserter_cold_down():
	await get_tree().create_timer(deserter_cd).timeout
	deserter_cd = 0
#2b
func cowboy(recoil: float):
	return recoil * 0.1

#3c
var die_hard_active : bool = false
func die_hard():
	if die_hard_cd != 0:
		get_tree().change_scene_to_file("res://StarterScene.tscn")
		return
	die_hard_cd = 60
	die_hard_active = true
	await get_tree().create_timer(2.0).timeout
	die_hard_active = false
	die_hard_cold_down()
	
func die_hard_cold_down():
	await get_tree().create_timer(die_hard_cd).timeout
	die_hard_cd = 0
