extends Control

var skill_available_points : int
var attribute_available_points : int = 10
var constitution_add = 0
var strength_add = 0
var perception_add = 0

var endurance_add = 0
var resilience_add = 0
var melee_add = 0
var intimidation_add = 0
var handguns_add = 0
var longguns_add = 0


@onready var character = get_node("../../")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if character and character.has_node("PlayerHUD"):
		character.get_node("PlayerHUD").set_visible(false)
		character.get_node("PlayerHUD").set_process_unhandled_input(false) 
		
	load_stats()
	attribute_available_points = character.attribute_available_points
	skill_available_points = character.skill_available_points
	#print(character)
	if $HBoxContainer/VBoxContainer/Attributes.visible == true:
		
		for button in get_tree().get_nodes_in_group("AttributePlusButtons"):
			button.set_disabled(true)
			button.set_visible(false)
		for button in get_tree().get_nodes_in_group("AttributeMinusButtons"):
			button.set_disabled(true)
			button.set_visible(false)
		%AttributeAvailablePoints.set_text("Points: " + str(attribute_available_points))
		if attribute_available_points == 0:
			$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints.set_visible(false)
			$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints/AttributeConfirm.set_visible(false)
		else:
			for button in get_tree().get_nodes_in_group("AttributePlusButtons"):
				button.set_disabled(false)
				button.set_visible(true)
	
	elif $HBoxContainer/VBoxContainer/Skills.visible == true:
		
		for button in get_tree().get_nodes_in_group("SkillPlusButtons"):
			button.set_disabled(true)
			button.set_visible(false)
		for button in get_tree().get_nodes_in_group("SkillMinusButtons"):
			button.set_disabled(true)
			button.set_visible(false)
		%SkillAvailablePoints.set_text("Points: " + str(skill_available_points))
		if skill_available_points == 0:
			pass
			#$HBoxContainer/VBoxContainer/Attribute/AttributeName/AttributePoints.set_visible(false)
		else:
			for button in get_tree().get_nodes_in_group("SkillPlusButtons"):
				button.set_disabled(false)
				button.set_visible(true)

func load_stats():
	if character:
		if $HBoxContainer/VBoxContainer/Attributes.visible == true:
			$HBoxContainer/VBoxContainer/Attributes/AttributeName/Constitution/Panel/Stats/Value.set_text(str(character.constitution))
			$HBoxContainer/VBoxContainer/Attributes/AttributeName/Strength/Panel/Stats/Value.set_text(str(character.strength))
			$HBoxContainer/VBoxContainer/Attributes/AttributeName/Perception/Panel/Stats/Value.set_text(str(character.perception))
		elif $HBoxContainer/VBoxContainer/Skills.visible == true:
			$HBoxContainer/VBoxContainer/Skills/SkillName/Endurance/Panel/Stats/Value.set_text(str(character.endurance))
			$HBoxContainer/VBoxContainer/Skills/SkillName/Resilience/Panel/Stats/Value.set_text(str(character.resilience))
			$HBoxContainer/VBoxContainer/Skills/SkillName/Melee/Panel/Stats/Value.set_text(str(character.melee))
			$HBoxContainer/VBoxContainer/Skills/SkillName/Intimidation/Panel/Stats/Value.set_text(str(character.intimidation))
			$HBoxContainer/VBoxContainer/Skills/SkillName/Handguns/Panel/Stats/Value.set_text(str(character.handguns))
			$HBoxContainer/VBoxContainer/Skills/SkillName/LongGuns/Panel/Stats/Value.set_text(str(character.longguns))
	else: return
	
func increase_attribute(stat: String):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") +1)
	%AttributeName.get_node(stat + "/Panel/Stats/Change").set_text("+" + str(
												get(stat.to_lower() + "_add")) + " ")
	%AttributeName.get_node(stat + "/Panel/Min").set_disabled(false)
	%AttributeName.get_node(stat + "/Panel/Min").set_visible(true)
	attribute_available_points -= 1
	%AttributeAvailablePoints.set_text("Points: " + str(attribute_available_points))
	if attribute_available_points == 0:
		for button in get_tree().get_nodes_in_group("AttributePlusButtons"):
			button.set_disabled(true)
			button.set_visible(false)
	print(stat + "Plus")
	
func decrease_attribute(stat: String):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") -1)
	if get(stat.to_lower() + "_add") == 0:
		%AttributeName.get_node(stat + "/Panel/Min").set_disabled(true)
		%AttributeName.get_node(stat + "/Panel/Min").set_visible(false)
		%AttributeName.get_node(stat + "/Panel/Stats/Change").set_text("")
	else :
		%AttributeName.get_node(stat + "/Panel/Stats/Change").set_text("+" + str(
												get(stat.to_lower() + "_add")) + " ")
	attribute_available_points += 1
	%AttributeAvailablePoints.set_text("Points: " + str(attribute_available_points))
	for button in get_tree().get_nodes_in_group("AttributePlusButtons"):
		button.set_disabled(false)
		button.set_visible(true)
	print((stat + "Minus"))

func increase_skill(stat: String):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") +1)
	%SkillName.get_node(stat + "/Panel/Stats/Change").set_text("+" + str(
												get(stat.to_lower() + "_add")) + " ")
	%SkillName.get_node(stat + "/Panel/Min").set_disabled(false)
	%SkillName.get_node(stat + "/Panel/Min").set_visible(true)
	skill_available_points -= 1
	%SkillAvailablePoints.set_text("Points: " + str(skill_available_points))
	if skill_available_points == 0:
		for button in get_tree().get_nodes_in_group("SkillPlusButtons"):
			button.set_disabled(true)
			button.set_visible(false)
	print(stat + "Plus")
	
func decrease_skill(stat: String):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") -1)
	if get(stat.to_lower() + "_add") == 0:
		%SkillName.get_node(stat + "/Panel/Min").set_disabled(true)
		%SkillName.get_node(stat + "/Panel/Min").set_visible(false)
		%SkillName.get_node(stat + "/Panel/Stats/Change").set_text("")
	else :
		%SkillName.get_node(stat + "/Panel/Stats/Change").set_text("+" + str(
												get(stat.to_lower() + "_add")) + " ")
	skill_available_points += 1
	%SkillAvailablePoints.set_text("Points: " + str(skill_available_points))
	for button in get_tree().get_nodes_in_group("SkillPlusButtons"):
		button.set_disabled(false)
		button.set_visible(true)
	print((stat + "Minus"))
	
func _on_attribute_confirm_pressed() -> void:
	if strength_add + constitution_add + perception_add == 0:
		print("Nothing changed")
	else :
		character.attribute_available_points = attribute_available_points
		character.constitution += constitution_add
		character.strength += strength_add
		character.perception += perception_add
		strength_add = 0
		constitution_add = 0
		perception_add = 0
		load_stats()
		for button in get_tree().get_nodes_in_group("AttributeMinusButtons"):
			#button.set_disabled(true)
			button.set_visible(false)
		for label in get_tree().get_nodes_in_group("AttributeChangeLabels"):
			label.set_text(" ")
		if attribute_available_points == 0:
			$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints/AttributeConfirm.set_visible(false)

func _on_skill_confirm_pressed() -> void:
	if endurance_add + resilience_add + melee_add + intimidation_add + handguns_add + longguns_add == 0:
		print("Nothing changed")
	else :
		character.skill_available_points = skill_available_points
		character.endurance += endurance_add
		character.resilience += resilience_add
		character.melee += melee_add
		character.intimidation +=intimidation_add
		character.handguns += handguns_add
		character.longguns += longguns_add
		endurance_add = 0
		resilience_add = 0
		melee_add = 0
		intimidation_add = 0
		handguns_add = 0
		longguns_add = 0
		load_stats()
		for button in get_tree().get_nodes_in_group("SkillMinusButtons"):
			#button.set_disabled(true)
			button.set_visible(false)
		for label in get_tree().get_nodes_in_group("SkillChangeLabels"):
			label.set_text(" ")




func _process(delta):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _exit_tree():
	if character and character.has_node("PlayerHUD"):
		character.get_node("PlayerHUD").visible = true  
		character.get_node("PlayerHUD").set_process_unhandled_input(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)




func _on_attribute_pressed() -> void:
	$HBoxContainer/VBoxContainer/Attributes.show()
	$HBoxContainer/VBoxContainer/Skills.hide()
	$HBoxContainer/VBoxContainer/Perks.hide()
	load_stats()
	if attribute_available_points == 0:
		$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints.set_visible(false)
		$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints/AttributeConfirm.set_visible(false)
		for button in get_tree().get_nodes_in_group("AttributePlusButtons"):
			button.set_disabled(true)
			button.set_visible(false)
		for button in get_tree().get_nodes_in_group("AttributeMinusButtons"):
			button.set_disabled(true)
			button.set_visible(false)
	else:
		%AttributeAvailablePoints.set_text("Points: " + str(attribute_available_points))
		%SkillAvailablePoints.set_text("Points: " + str(skill_available_points))
	
	


func _on_skills_pressed() -> void:
	$HBoxContainer/VBoxContainer/Attributes.hide()
	$HBoxContainer/VBoxContainer/Skills.show()
	$HBoxContainer/VBoxContainer/Perks.hide()
	load_stats()
	%AttributeAvailablePoints.set_text("Points: " + str(attribute_available_points))
	%SkillAvailablePoints.set_text("Points: " + str(skill_available_points))


func _on_perks_pressed() -> void:
	$HBoxContainer/VBoxContainer/Attributes.hide()
	$HBoxContainer/VBoxContainer/Skills.hide()
	$HBoxContainer/VBoxContainer/Perks.show()
