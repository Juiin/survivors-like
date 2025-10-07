extends Node

const DAMAGE_TEXT_SCENE := preload("res://Effects/damage_text.tscn")

func spawn_damage_text(damage: float, pos: Vector2, color: Color = Color.WHITE) -> void:
    var damage_text := DAMAGE_TEXT_SCENE.instantiate()
    damage_text.text = str(int(damage))
    damage_text.pos = pos
    damage_text.color = color
    add_child(damage_text)

func spawn_floating_text(text: String, pos: Vector2, color: Color = Color.WHITE) -> void:
    var floating_text := DAMAGE_TEXT_SCENE.instantiate()
    floating_text.text = text
    floating_text.pos = pos
    floating_text.color = color
    add_child(floating_text)