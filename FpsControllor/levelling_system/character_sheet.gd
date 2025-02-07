extends Control

var skill_available_points : int
var attribute_available_points : int 
var perk_available_points :int 

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
@onready var levelling_sys = get_node("../../LevellingSystem")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if character and character.has_node("PlayerHUD"):
		character.get_node("PlayerHUD").set_visible(false)
		character.get_node("PlayerHUD").set_process_unhandled_input(false) 
		
	load_stats()
	load_perks()
	attribute_available_points = character.attribute_available_points
	skill_available_points = character.skill_available_points

	#print(character)
	#if $HBoxContainer/VBoxContainer/Attributes.visible == true:

		
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
	
	#elif $HBoxContainer/VBoxContainer/Skills.visible == true:
		
	for button in get_tree().get_nodes_in_group("SkillPlusButtons"):
		button.set_disabled(true)
		button.set_visible(false)
	for button in get_tree().get_nodes_in_group("SkillMinusButtons"):
		button.set_disabled(true)
		button.set_visible(false)
	%SkillAvailablePoints.set_text("Points: " + str(skill_available_points))
	%PerkPoints.set_text("Points: " + str(character.perk_available_points))
	if skill_available_points == 0:
		pass
		#$HBoxContainer/VBoxContainer/Attribute/AttributeName/AttributePoints.set_visible(false)
	else:
		for button in get_tree().get_nodes_in_group("SkillPlusButtons"):
			button.set_disabled(false)
			button.set_visible(true)


func load_stats():
	if character:
		#if $HBoxContainer/VBoxContainer/Attributes.visible == true:
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
	
#func load_perks():
	#for button in get_tree().get_nodes_in_group("PerksButtons"):
		#var perk_id = button.get_name().to_lower()
		#if check_perk_requirements(perk_id):
			#button.disabled = false
		#else:
			#button.disabled = true
func load_perks():
	if not character:
		return
	# 遍历所有“PerksButtons”组内的按钮
	for button in get_tree().get_nodes_in_group("PerksButtons"):
		var perk_id = button.get_name().to_lower()
		var child_node = null
		if button.has_node("TextureRect"):
			child_node = button.get_node("TextureRect")

		# 如果这个 perk 已经被购买/解锁
		if perk_id in character.perks and character.perks[perk_id] == true:
			# 让子节点可见
			if child_node:
				child_node.visible = true
			# 让按钮无法被点击（Mouse Filter = IGNORE，相当于禁用点击，不改变外观）
			button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			# perk 尚未购买
			# 判断是否符合解锁需求
			if check_perk_requirements(perk_id):
				# 可以购买：让按钮可以点击
				
				if child_node:
					child_node.visible = false
				button.disabled = false
			else:
				# 不符合购买需求：让按钮不能点击
				if child_node:
					child_node.visible = false
				button.disabled = true


func check_perk_requirements(perk_id: String) -> bool:
	if not levelling_sys.perk_requirement.has(perk_id):
		return false  

	var req_dict =  levelling_sys.perk_requirement[perk_id]

	if req_dict.has("attribute"):
		for attr_name in req_dict["attribute"]:
			var required_val = req_dict["attribute"][attr_name]
			var current_val = character.attributes[attr_name] if character.attributes.has(attr_name) else 0
			if current_val < required_val:
				return false
	if req_dict.has("skill"):
		for skill_name in req_dict["skill"]:
			var required_val = req_dict["skill"][skill_name]
			var current_val = character.skills[skill_name] if character.skills.has(skill_name) else 0
			if current_val < required_val:
				return false
				
	if req_dict.has("points"):
		var required_val =  req_dict["points"]
		if character.perk_available_points < required_val:
			return false

	return true

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
	
func spend_perk_points(perk_id: String):
	if not character:
		return
	
	# 如果在 LevellingSystem 中找不到此 perk 的需求配置，则直接返回
	if not levelling_sys.perk_requirement.has(perk_id):
		return
		
	var req_dict = levelling_sys.perk_requirement[perk_id]
	# 根据需求字典获取此 perk 的点数花费，若没配置则默认为 1
	var cost = 1
	if req_dict.has("points"):
		cost = req_dict["points"]

	# 角色 perks 字典中将此 perk 标记为已解锁
	character.perks[perk_id] = true
	# 扣除相应的 perk 可用点数
	character.perk_available_points -= cost

	# 更新 PerkPoints 的文本
	%PerkPoints.set_text("Points: " + str(character.perk_available_points))

	# 找到被按下的 perk 按钮（或对应 perk 的按钮），让它的子节点从 false 变为 true
	for button in get_tree().get_nodes_in_group("PerksButtons"):
		# 比较时要确保大小写一致，所以这里转成小写再比
		if button.get_name().to_lower() == perk_id:
			# 假设该按钮有一个子节点名叫 "UnlockedCheck"（类型可能是 CheckBox 或 TextureRect），
			# 需要根据自己的实际节点名称来替换。
			if button.has_node("TextureRect"):
				var child_node = button.get_node("TextureRect")
				# 下面根据具体需求来设置，比如若是 CheckBox 就设置 pressed = true；
				# 若是 TextureRect，就修改可见性等。
				child_node.visible = character.perks[perk_id]  

			button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			break

	
func _on_attribute_confirm_pressed() -> void:
	if strength_add + constitution_add + perception_add == 0:
		print("Nothing changed")
	else :
		character.attribute_available_points = attribute_available_points
		character.attributes["constitution"] += constitution_add
		character.attributes["strength"] += strength_add
		character.attributes["perception"] += perception_add
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
	#load_stats()
	#if attribute_available_points == 0:
		#$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints.set_visible(false)
		#$HBoxContainer/VBoxContainer/Attributes/AttributeName/AttributePoints/AttributeConfirm.set_visible(false)
		#for button in get_tree().get_nodes_in_group("AttributePlusButtons"):
			#button.set_disabled(true)
			#button.set_visible(false)
		#for button in get_tree().get_nodes_in_group("AttributeMinusButtons"):
			#button.set_disabled(true)
			#button.set_visible(false)
	#else:
	#%AttributeAvailablePoints.set_text("Points: " + str(attribute_available_points))
	#%SkillAvailablePoints.set_text("Points: " + str(skill_available_points))
	
	


func _on_skills_pressed() -> void:
	$HBoxContainer/VBoxContainer/Attributes.hide()
	$HBoxContainer/VBoxContainer/Skills.show()
	$HBoxContainer/VBoxContainer/Perks.hide()
	#load_stats()
	#%AttributeAvailablePoints.set_text("Points: " + str(attribute_available_points))
	#%SkillAvailablePoints.set_text("Points: " + str(skill_available_points))


func _on_perks_pressed() -> void:
	$HBoxContainer/VBoxContainer/Attributes.hide()
	$HBoxContainer/VBoxContainer/Skills.hide()
	$HBoxContainer/VBoxContainer/Perks.show()
	load_perks()
