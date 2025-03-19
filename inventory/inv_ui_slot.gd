extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/item_display

func update(slot: InvItem):
	if !slot.item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
