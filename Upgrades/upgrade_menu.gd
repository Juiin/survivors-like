class_name UpgradeMenu
extends Panel

@export var upgrade_entry: PackedScene
@export var type: Enums.UpgradeType

@onready var upgrade_entry_container := %UpgradeEntryContainer


func open(upgrades: Array[Upgrade]):
    show()
    var x_adjust = 200 if type == Enums.UpgradeType.ICE_SPEAR else -200
    var tween = create_tween()
    tween.tween_property(self, "global_position", global_position + Vector2(x_adjust, 0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

    for child in upgrade_entry_container.get_children():
        child.queue_free()

    for i in upgrades.size():
        var _inst = upgrade_entry.instantiate();
        _inst.upgrade_array = upgrades
        _inst.upgrade_index = i
        upgrade_entry_container.add_child(_inst)

func close():
    var x_adjust = -200 if type == Enums.UpgradeType.ICE_SPEAR else 200
    var tween = create_tween()
    tween.tween_property(self, "global_position", global_position + Vector2(x_adjust, 0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
    tween.tween_callback(hide)