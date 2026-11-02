class_name MenuManager extends Node

@export var menu: MenuConfigResource
@export var side_menus: Array[MenuConfigResource]

enum ControlType{focus, hover}
var open_side_menus_stack: Array
var cur_default_button: NodePath
var last_hover: Control
var last_control_type: ControlType = 1
var stored_textures: Dictionary = {}


func _ready() -> void:
	cur_default_button = menu.default_button
	setup(get_node(menu.menu_parent), true)
	for path in menu.button_parents:
		var parent_node = get_node(path)
		for child in parent_node.get_children():
			if child is TextureButton:
				stored_textures[child] = child.texture_focused
				child.button_down.connect(_on_button_down.bind(child))
				child.button_up.connect(_on_button_up.bind(child))
	for menu in side_menus:
		setup(get_node(menu.menu_parent), false)


func setup(node: Control, is_base: bool) -> void:
	if !_is_capable_hover(node):
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		if not node.mouse_entered.is_connected(_on_menu_hover):
			node.connect("mouse_entered",_on_menu_hover.bind(node))
		if not is_base:
			node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			node.focus_mode = Control.FOCUS_NONE
	for child in node.get_children():
		if child is Control:
			setup(child,is_base)


func _is_capable_hover(node: Control) -> bool:
	return node is BaseButton or node is ItemList or node is Range or node is Tree or node is TextEdit or node is LineEdit   


func _on_menu_hover(button:Control) -> void:
	if button.mouse_filter == Control.MOUSE_FILTER_STOP:
		last_hover = button


func _enable_disable_menu(menu: Array[NodePath], enable: bool) -> void:
	for path in menu:
		for node in get_node(path).get_children():
			if _is_capable_hover(node):
				node.focus_mode = Control.FOCUS_ALL if enable else Control.FOCUS_NONE
				node.mouse_filter = Control.MOUSE_FILTER_STOP if enable else Control.MOUSE_FILTER_IGNORE
				if !enable:
					node.release_focus()
					if last_hover == node:
						last_hover = null
					_enable_disable_menu([node.get_path()],enable)


func open_menu(menu_node: Control, open_button: Control = null) -> void:
	var menu_resource = find_menu_data(menu_node)
	if not menu_resource:
		push_warning("No such menu exists")
		return
	_enable_disable_menu(menu_resource.button_parents,true)
	#if size menu opens another side size >0
	if open_side_menus_stack.size()>0:
		_enable_disable_menu(open_side_menus_stack.back()["config_resource"].button_parents,false) #close last side menu
	else:
		_enable_disable_menu(menu.button_parents, false)
	
	#animation
	var anim_player_node: AnimationPlayer = null if !menu_resource.anim else get_node(menu_resource.anim)
	if anim_player_node and menu_resource.anim_show != "" and anim_player_node.has_animation(menu_resource.anim_show):
		anim_player_node.play(menu_resource.anim_show)
	get_node(menu_resource.menu_parent).visible = true
	get_node(menu_resource.menu_parent).modulate.a = 1.0
	
	open_side_menus_stack.append({
		"config_resource": menu_resource,
		"open_button": open_button
	})
	
	cur_default_button = menu_resource.default_button
	if last_control_type == ControlType.focus:
		get_node(cur_default_button).grab_focus()


func find_menu_data(menu_node: Control) -> MenuConfigResource:
	if get_node(menu.menu_parent) == menu_node:
		return menu
	
	for data in side_menus:
		if get_node(data.menu_parent) == menu_node:
			return data
	return null


func close_menu() -> void:
	var menu_closing = open_side_menus_stack.pop_back()
	var closing_menu_resource: MenuConfigResource = menu_closing["config_resource"]
	var closing_menu_open_button: Control = menu_closing["open_button"]
	
	_enable_disable_menu(closing_menu_resource.button_parents, false)
	
	var anim_player_node: AnimationPlayer = null if !closing_menu_resource.anim else get_node(closing_menu_resource.anim)
	if anim_player_node and closing_menu_resource.anim_hide != "" and anim_player_node.has_animation(closing_menu_resource.anim_hide):
		anim_player_node.play(closing_menu_resource.anim_hide)
	get_node(closing_menu_resource.menu_parent).visible = false
	
	var cur_config: MenuConfigResource
	if open_side_menus_stack.size() > 0:
		cur_config = open_side_menus_stack.back()["config_resource"]
	else:
		cur_config = menu
		_enable_disable_menu(cur_config.button_parents, true)
	
	cur_default_button = cur_config.default_button
	last_hover = get_node(cur_default_button)
	if last_control_type == ControlType.focus:
		if closing_menu_open_button:
			closing_menu_open_button.grab_focus()
		else:
			get_node(cur_default_button).grab_focus()


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if last_control_type != ControlType.focus:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			get_viewport().set_input_as_handled()
			if last_hover and is_instance_valid(last_hover):
				last_hover.grab_focus()
				last_hover.mouse_filter = Control.MOUSE_FILTER_IGNORE
			elif cur_default_button:
				get_node(cur_default_button).grab_focus()
			else:
				get_node(cur_default_button).set_focus_mode()
			last_control_type = ControlType.focus
		
		if Input.is_action_just_pressed("ui_cancel") and open_side_menus_stack.size() > 0:
			close_menu()
	
	elif event is InputEventMouseMotion or event is InputEventMouseButton:
		if last_control_type != ControlType.hover:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			var focused = get_viewport().gui_get_focus_owner()
			if focused:
				focused.release_focus()
			if last_hover:
				last_hover.mouse_filter = Control.MOUSE_FILTER_STOP
			last_control_type = ControlType.hover


#hover and focus texture fix
func _on_button_down(btn: TextureButton) -> void:
	btn.texture_focused = null


func _on_button_up(btn: TextureButton) -> void:
	if stored_textures.has(btn):
		btn.texture_focused = stored_textures[btn]
