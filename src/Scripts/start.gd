extends Control


@onready var animation_player: AnimationPlayer = $StartL/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("typewriter")
	await animation_player.animation_finished
	animation_player.play("blinking")


func _input(event: InputEvent) -> void:
	if event.is_pressed():
		SceneManager.transition_scene("uid://cde23851jw42e")
