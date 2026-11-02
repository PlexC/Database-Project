extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: ColorRect = $TextureRect
@onready var label: Label =  $TextureRect/Label



signal new_scene_ready(target_area: String, offset: Vector2)
signal load_finished
signal entered_scene(uid: String)

var cur_scene_uid: String = "" 


func _ready() -> void:
	texture_rect.visible = false
	label.visible = false
	label.text = "Loading"
	await get_tree().process_frame
	load_finished.emit()


func transition_scene(scene: String) -> void:
	texture_rect.visible = true
	var texture = texture_rect.material as ShaderMaterial

	var tween_in = create_tween()
	tween_in.tween_property(texture, "shader_parameter/block_size", 64.0, 0.3)
	
	await tween_in.finished
	label.visible = true
	get_tree().call_deferred("change_scene_to_file", scene)
	cur_scene_uid = ResourceUID.path_to_uid(scene)
	entered_scene.emit(cur_scene_uid)
	await get_tree().scene_changed
	
	label.text = "Loading."
	await get_tree().create_timer(0.2).timeout
	label.text = "Loading.."
	await get_tree().create_timer(0.2).timeout
	label.text = "Loading..."
	await get_tree().create_timer(0.2).timeout
	
	label.visible = false
	
	var tween_out = create_tween()
	tween_out.tween_property(texture, "shader_parameter/block_size", 1.0, 0.3)
	await tween_out.finished
	
	texture_rect.visible = false
	load_finished.emit()
