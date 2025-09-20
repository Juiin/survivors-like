class_name UpgradeMenu
extends Panel

@export var upgrade_entry: PackedScene
@export var type: Enums.UpgradeType

@onready var upgrade_entry_container := %UpgradeEntryContainer

var open_tween: Tween
var close_tween: Tween


func open(upgrades: Array[Upgrade]):
    if open_tween && open_tween.is_running():
        return

    show()

    if type != Enums.UpgradeType.GLOBAL:
        var x_adjust = 200 if type == Enums.UpgradeType.ICE_SPEAR else -200
        open_tween = create_tween()
        open_tween.tween_property(self, "global_position", global_position + Vector2(x_adjust, 0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    else:
        open_tween = create_tween()
        open_tween.tween_property(self, "global_position", global_position + Vector2(0, 155), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

    for child in upgrade_entry_container.get_children():
        child.queue_free()

    for i in upgrades.size():
        if upgrades[i].level > upgrades[i].cost.size() - 1:
            continue

        var _inst = upgrade_entry.instantiate();
        _inst.upgrade_array = upgrades
        _inst.upgrade_index = i
        upgrade_entry_container.add_child(_inst)

func close():
    if close_tween && close_tween.is_running():
        return
    if type != Enums.UpgradeType.GLOBAL:
        var x_adjust = -200 if type == Enums.UpgradeType.ICE_SPEAR else 200
        close_tween = create_tween()
        close_tween.tween_property(self, "global_position", global_position + Vector2(x_adjust, 0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
        close_tween.tween_callback(hide)
    else:
        close_tween = create_tween()
        close_tween.tween_property(self, "global_position", global_position + Vector2(0, -155), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)