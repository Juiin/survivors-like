class_name UpgradeMenu
extends Panel

@export var upgrade_entry: PackedScene

@onready var upgrade_entry_container := %UpgradeEntryContainer


func open(upgrades: Array[Upgrade]):
    show()
    var tween = create_tween()
    tween.tween_property(self, "global_position", global_position + Vector2(200, 0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

    for child in upgrade_entry_container.get_children():
        child.queue_free()

    for upgrade in upgrades:
        var _inst = upgrade_entry.instantiate();
        _inst.upgrade = upgrade
        upgrade_entry_container.add_child(_inst)

func close():
    var tween = create_tween()
    tween.tween_property(self, "global_position", global_position + Vector2(-200, 0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
    tween.tween_callback(hide)