extends Control


@onready var character = get_node("../../Player")
@onready var levelling_sys = get_node("../../Player/LevellingSystem")

var skill_available_points : int
var attribute_available_points : int 


var constitution_add = 0
var strength_add = 0
var perception_add = 0

var endurance_add = 0
var resilience_add = 0
var melee_add = 0
var intimidation_add = 0
var handguns_add = 0
var longguns_add = 0

var selected_aptitude_button: TextureButton = null  
var selected_aptitude_id: String = ""     
   
var default_attributes = {
	"constitution": 3,
	"strength": 3,
	"perception": 3,
}
var default_attribute_points = 9


func _ready() -> void:
	if character and character.has_node("PlayerHUD"):
		character.get_node("PlayerHUD").set_visible(false)
		character.get_node("PlayerHUD").set_process_unhandled_input(false) 
		
	load_stats()

	attribute_available_points = character.attribute_available_points
	skill_available_points = character.skill_available_points


	$HBoxContainer/VBoxContainer/Attributes.set_visible(true)
	$HBoxContainer/VBoxContainer/Skills.set_visible(false)
	$HBoxContainer/VBoxContainer/Aptitude.set_visible(false)
	for button in get_tree().get_nodes_in_group("AttributePlusButtons"):
		button.set_disabled(true)
		button.set_visible(false)
	for button in get_tree().get_nodes_in_group("AttributeMinusButtons"):
		button.set_disabled(true)
		button.set_visible(false)
	
	if attribute_available_points == 0:
		$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints.set_visible(false)
		$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints/AttributeConfirm.set_visible(false)
	else:
		for button in get_tree().get_nodes_in_group("AttributePlusButtons"):
			button.set_disabled(false)
			button.set_visible(true)
	
	#elif $HBoxContainer/VBoxContainer/Skills.visible == true:
		
	for button in get_tree().get_nodes_in_group("SkillPlusButtons"):
		button.set_disabled(true)
		button.set_visible(false)
	for button in get_tree().get_nodes_in_group("SkillMinusButtons"):
		button.set_disabled(true)
		button.set_visible(false)
	
	if skill_available_points == 0:
		pass
		#$HBoxContainer/VBoxContainer/Attribute/AttributeName/AttributePoints.set_visible(false)
	else:
		for button in get_tree().get_nodes_in_group("SkillPlusButtons"):
			button.set_disabled(false)
			button.set_visible(true)
			
	for button in get_tree().get_nodes_in_group("AptitudeButtons"):
		if button.has_node("Highlight"):
			button.get_node("Highlight").visible = false
		button.pressed.connect(_on_aptitude_button_pressed.bind(button)) 


func load_stats():
	if character:
		#if $HBoxContainer/VBoxContainer/Attributes.visible == true:
		%AttributeAvailablePoints.set_text("Points: " + str(attribute_available_points))
		%SkillAvailablePoints.set_text("Points: " + str(skill_available_points))
		$HBoxContainer/VBoxContainer/Attributes/AttributeName/Constitution/Panel/Stats/Value.set_text(str(character.attributes["constitution"]))
		$HBoxContainer/VBoxContainer/Attributes/AttributeName/Strength/Panel/Stats/Value.set_text(str(character.attributes["strength"]))
		$HBoxContainer/VBoxContainer/Attributes/AttributeName/Perception/Panel/Stats/Value.set_text(str(character.attributes["perception"]))
		#elif $HBoxContainer/VBoxContainer/Skills.visible == true:
		$HBoxContainer/VBoxContainer/Skills/SkillName/Endurance/Panel/Stats/Value.set_text(str(character.skills["endurance"]))
		$HBoxContainer/VBoxContainer/Skills/SkillName/Resilience/Panel/Stats/Value.set_text(str(character.skills["resilience"]))
		$HBoxContainer/VBoxContainer/Skills/SkillName/Melee/Panel/Stats/Value.set_text(str(character.skills["melee"]))
		$HBoxContainer/VBoxContainer/Skills/SkillName/Intimidation/Panel/Stats/Value.set_text(str(character.skills["intimidation"]))
		$HBoxContainer/VBoxContainer/Skills/SkillName/Handguns/Panel/Stats/Value.set_text(str(character.skills["handguns"]))
		$HBoxContainer/VBoxContainer/Skills/SkillName/LongGuns/Panel/Stats/Value.set_text(str(character.skills["longguns"]))
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
	
func _on_aptitude_button_pressed(button: TextureButton) -> void:
	# 如果之前有选中的按钮，需要先取消它的高亮
	print(button.get_parent().name)
	if selected_aptitude_button and selected_aptitude_button.has_node("Highlight"):
		selected_aptitude_button.get_node("Highlight").visible = false

	# 高亮新点击的按钮
	if button.has_node("Highlight"):
		button.get_node("Highlight").visible = true

	# 记录新的选中按钮
	selected_aptitude_button = button
	# 假设 Aptitude 的 ID 就是按钮的 name（也可以换成自定义字段）
	selected_aptitude_id = button.get_parent().name  # or button.get_name()
	
func _on_attribute_confirm_pressed() -> void:
	if strength_add + constitution_add + perception_add == 0:
		print("Nothing changed")
	else :
		character.attribute_available_points = attribute_available_points
		character.attributes["constitution"] += constitution_add
		character.attributes["strength"] += strength_add
		character.attributes["perception"] += perception_add
		update_skills_from_attributes()
		
		strength_add = 0
		constitution_add = 0
		perception_add = 0
		load_stats()
		for button in get_tree().get_nodes_in_group("AttributeMinusButtons"):
			#button.set_disabled(true)
			button.set_visible(false)
		for label in get_tree().get_nodes_in_group("AttributeChangeLabels"):
			label.set_text(" ")
		$HBoxContainer/VBoxContainer/Attributes/AttributeName/Reset.set_visible(true)
		if attribute_available_points == 0:
			$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints/AttributeConfirm.set_visible(false)
			
func _on_skill_confirm_pressed() -> void:
	if endurance_add + resilience_add + melee_add + intimidation_add + handguns_add + longguns_add == 0:
		print("Nothing changed")
	else :
		character.skill_available_points = skill_available_points
		character.skills["endurance"] += endurance_add
		character.skills["resilience"] += resilience_add
		character.skills["melee"] += melee_add
		character.skills["intimidation"] +=intimidation_add
		character.skills["handguns"] += handguns_add
		character.skills["longguns"] += longguns_add
		endurance_add = 0
		resilience_add = 0
		melee_add = 0
		intimidation_add = 0
		handguns_add = 0
		longguns_add = 0
		load_stats()
		for button in get_tree().get_nodes_in_group("SkillMinusButtons"):
			button.set_visible(false)
		for label in get_tree().get_nodes_in_group("SkillChangeLabels"):
			label.set_text(" ")

func _on_aptitude_confirm_pressed() -> void:
	if selected_aptitude_button == null:
		$HBoxContainer/VBoxContainer/Aptitude/AptitudeName/Warning.text = "Please select an Aptitude..."
		return

	if character:
		character.aptitude = selected_aptitude_id
	if selected_aptitude_id.to_lower() == "firefighter":
		character.attributes["constitution"] += 2
		character.attributes["strength"] += 2
		character.attributes["perception"] -= 1
		

		
	if selected_aptitude_id.to_lower() == "assassin":
		character.attributes["perception"] += 5
		character.attributes["strength"] -= 1
		character.attributes["constitution"] -= 2

		
	if selected_aptitude_id.to_lower() == "soldier":
		character.attributes['constitution'] += 1
		character.attributes["strength"] += 1
		character.attributes["perception"] += 2

	update_skills_from_attributes()
	queue_free()

func _on_attribute_reset_pressed() -> void:
	# 将角色的 attributes、可用点数都恢复到初始值
	character.attributes["constitution"] = default_attributes["constitution"]
	character.attributes["strength"]     = default_attributes["strength"]
	character.attributes["perception"]   = default_attributes["perception"]
	character.attribute_available_points = default_attribute_points
	attribute_available_points = character.attribute_available_points

	constitution_add = 0
	strength_add = 0
	perception_add = 0

	update_skills_from_attributes()
	load_stats()
	for label in get_tree().get_nodes_in_group("AttributeChangeLabels"):
		label.set_text(" ")
	for button in get_tree().get_nodes_in_group("AttributeMinusButtons"):
			button.set_disabled(true)
			button.set_visible(false)
	if character.attribute_available_points > 0:
		for button in get_tree().get_nodes_in_group("AttributePlusButtons"):
			button.set_disabled(false)
			button.set_visible(true)

	$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints/AttributeConfirm.set_visible(true)
	$HBoxContainer/VBoxContainer/Attributes/AttributeName/Reset.set_visible(false)
	
func update_skills_from_attributes() -> void:
	if not character:
		return
	
	# 直接覆盖赋值
	character.skills["endurance"]    = character.attributes["constitution"] * 5
	character.skills["resilience"]   = character.attributes["constitution"] * 5
	character.skills["melee"]        = character.attributes["strength"]    * 5
	character.skills["intimidation"] = character.attributes["strength"]    * 5
	character.skills["handguns"]     = character.attributes["perception"]  * 5
	character.skills["longguns"]     = character.attributes["perception"]  * 5
	
	# 刷新界面显示
	load_stats()

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
	$HBoxContainer/VBoxContainer/Aptitude.hide()

	
	


func _on_skills_pressed() -> void:
	if attribute_available_points != 0:
		%Warning.text = "You must assign the attributes first..."
		await get_tree().create_timer(1.5).timeout
		%Warning.text = " "
	else:
		$HBoxContainer/VBoxContainer/Attributes.hide()
		$HBoxContainer/VBoxContainer/Skills.show()
		$HBoxContainer/VBoxContainer/Aptitude.hide()



func _on_aptitude_pressed() -> void:
	if attribute_available_points != 0:
		%Warning.text = "You must assign the attributes first..."
		await get_tree().create_timer(1.5).timeout
		%Warning.text = " "
	elif skill_available_points != 0:
		%WarningForSkills.text = "You must assign the skills first..."
		await get_tree().create_timer(1.5).timeout
		%WarningForSkills.text = " "
	else:
		$HBoxContainer/VBoxContainer/Attributes.hide()
		$HBoxContainer/VBoxContainer/Skills.hide()
		$HBoxContainer/VBoxContainer/Aptitude.show()
		
