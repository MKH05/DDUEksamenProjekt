extends Resource

class_name inv

signal update

@export var slots: Array[InvSlot]

func insert(item: InvItem) -> bool:
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
		update.emit()
		return true
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
			update.emit()
			return true
		else:
			return false

func recycle_all(rarity_points: Dictionary, scene_tree: SceneTree) -> int:
	var total_points = 0
	for slot in slots:
		if slot.item != null and slot.amount > 0:
			var rarity = slot.item.rarity
			var range = rarity_points.get(rarity, Vector2i(0, 0))
			var points_per_item = randi_range(range.x, range.y)
			total_points += points_per_item * slot.amount
			slot.item = null
			slot.amount = 0
			
			update.emit()
			await scene_tree.create_timer(0.25).timeout
	
	update.emit()
	return total_points
